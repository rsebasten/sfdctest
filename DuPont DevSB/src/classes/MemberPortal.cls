/**
*
* @file
* @author  Thomas E. Snyder II <thomas.snyder@usa.dupont.com>
* @version 1.1
*
* Copyright © 2013 DuPont. All rights reserved. 
*
* MemberPortal  Class

    TES20111123:  fix authorization bug in member portal : Key.isValidFor() require isValid=true status
    
    TES20131001:
        Added new MemberPortal key based on Email,  this will support both leads and or contacts. 
            - format = [portal]:[email]
                portal = SiteObject__c.ExternalId__c
                email = members email address
            - added Key.keyType = CONTACT (backward compat) or EMAIL  ( can be used for both leads and Contact members)
            - added Key.email ( members email address )
            - added Key.leadid
            - Portal constructor will also except SiteObject__c.ExternalId__c in lue of SiteObject__c.Id.
            - PortalNames will use SiteObject__c.ExternalId__c if populated otherwise uses publicName__c for backward compat
            - added Profile.company
            - added Profile.leadid
            - new static methods: createToken,encyptToken,decryptToken,getUserToken,getUserAccess
*/
 
public virtual class MemberPortal {
    
    public enum KeyType {EMAIL,CONTACT}
    public static final string RTYPE_SO_MEMBERPORTAL=Rtype.getIdByDevName('SiteObject__c','MemberPortal'); 
    

    
    
    //similar to createToken with the added check that the email exists within an public/active portal campaign
    public static string getUserToken(string portal, string userEmail) {
        try {
            string token = createToken(portal,userEmail);
            Key memberkey = new Key(token);
            if (memberkey!=null && memberkey.isValid)
                return token;
        }
        catch(exception ex) {}
        return null;
    }
     
    public static string getUserAccess(string token) {
        Key memberkey = new Key(token);
        return (memberkey!=null && memberkey.isValid) ? memberkey.status : 'NO_ACCESS';
    }   
    
    
    
    
    
    
/*----------------------------------------------------------------------------
    Portal
-----------------------------------------------------------------------------*/
    public virtual class Portal {
        private SiteObject__c siteObj;
        private SET<string> m_PortalNames;
        
        public Portal(string portalId) {
            try {
            siteObj= [
                SELECT Id, Campaign__c, publicName__c, ReturnUrl__c, Type__c
                FROM  SiteObject__c   
                WHERE ( id=: portalId OR ExternalId__c=: portalId ) AND IsPublic__c=true
                ][0];          
            }
            catch(Exception ex) {}
        }
        
        public string id            {GET { return ( siteObj!=null) ? siteObj.id             : null; } }
        public string name          {GET { return ( siteObj!=null) ? siteObj.publicName__c  : null; } }
        public string url           {GET { return ( siteObj!=null) ? siteObj.returnUrl__c   : null; } }
        public string campaignId    {GET { return ( siteObj!=null) ? siteObj.campaign__c    : null; } } 
        public string pageType      {GET { return ( siteObj!=null) ? siteObj.type__c        : null; } } 
                
        protected MAP<Id,SiteObject__c> Siblings {
         GET {
            return new MAP<Id,SiteObject__c>([
                SELECT Id, Campaign__c, publicName__c, ReturnUrl__c, Type__c, ExternalId__c
                    FROM  SiteObject__c
                    WHERE Campaign__c=: this.campaignId AND IsPublic__c=true
                    ]);
            }   
        }
        
        public SET<String> portalNames {
            GET {
                if (m_PortalNames==null) {
                    m_PortalNames = new SET<String>();
                    for (SiteObject__c so : Siblings.values())
                        if (!String.IsBlank(so.ExternalId__c)) m_PortalNames.add(so.ExternalId__c.tolowerCase());
                        else if (!String.IsBlank(so.publicName__c)) m_PortalNames.add(so.publicName__c.tolowerCase());
                }
                return m_PortalNames;
            }
        }   
        
    }  //class: Portal        








/*----------------------------------------------------------------------------
    KEY
    ?TODO determine why both status and member status
-----------------------------------------------------------------------------*/
    public virtual class Key {
        
        
        public KeyType type                 {get; private set;}
        public string key                   {get; private set;} //decryped token or legacy so.id+acc.id+con.id or 
        public string token                 {get; private set;} //encrypted: so.id+":"+email or so.externalid+":"+email
        public string portalId              {get; private set;} 
        public string accountId             {get; private set;}
        public string contactId             {get; private set;}
        public string leadId                {get; private set;}
        public string email                 {get; private set;} 
        public Portal portal                {get; private set;}
        private CampaignMember member;

        public string status            {   GET { return (member!=null) ? member.status : null;     } }     
        public string memberId          {   GET { return (member!=null) ? member.id : null;         } }
        public string campaignId        {   GET { return (member!=null) ? member.campaignId : null; } }
        public string memberStatus      {   GET { return (member!=null) ? member.status : null;     } }     
        
        //Used on MemberPortal pages to check if active member
        public boolean isValid { GET { return ( member!=null ); } }  

        public Key(string akey) {
            
            if (akey!=null) {
                //check if KeyType Contact
                key=akey;
                if( akey.length()==45 && aKey.substring(15,18)=='001' && aKey.substring(30,33)=='003') {
                    type=MemberPortal.KeyType.CONTACT;
                    portalId=parseKey(0,15);
                    accountId=parseKey(15,30);
                    contactId=parseKey(30,45);
                    portal=new portal(portalId);
                    //get member
                    if (portal!=null) {
                        try {
                            member=[
                                SELECT id, campaignId, status, leadid, contactid, femail__c
                                FROM CampaignMember
                                WHERE campaignId            =: portal.campaignId
                                    AND contactid           =: contactId
                                    AND contact.accountId   =: accountId
                                ][0];
                        } catch(Exception ex) {} 
                                 
                    }
                }
                else {
                    try {
                        token=akey;
                        type=MemberPortal.KeyType.EMAIL;
                        key = decryptToken(token);
                        string[] arr = key.split(':');
                        portal=new portal(arr[0]);
                        if (portal!=null) {
                            portalid=arr[0];
                            email=arr[1];
                            member=[
                                    SELECT id, campaignId, status, leadid, contactid, contact.accountid
                                    FROM CampaignMember
                                    WHERE campaignId            =: portal.campaignId
                                        AND fEmail__c           =: email
                                    ORDER BY leadid, lastmodifiedDate //contact get priority
                                    ][0];
                            if (member!=null) {
                                leadid=member.leadid;
                                if (member.contact!=null) {
                                    contactid=member.contact.id;
                                    accountid=member.contact.accountid;
                                }
                            }                         
                        }
                    } catch(Exception ex) {}    
                }

            }
        }
        

        
        //Used on page leveraging Member portal
        public boolean isValidFor(string pname) {
            if (!isValid) return false;  //TES20111123
            else 
                try {
                    if (portal.name.tolowerCase()==pname.tolowerCase())
                        return true;
                    else {
                        system.debug('Access granted due to shared campaign membership');
                        return portal.portalNames.contains(pname.tolowerCase());
                    }
                }
                catch (Exception ex) {
                    return false;
                }   
         }
        
        private string parseKey(integer s, integer e) {
            string rtn;
            try { rtn=key.substring(s,e); }
            catch(Exception ex) {}
            return rtn;
        }

        public Profile profile {
            GET {
                return new Profile(this);
            }
        }
    } //class: Key
    

/*----------------------------------------------------------------------------
    PROFILE
-----------------------------------------------------------------------------*/ 
    public virtual class Profile {
        private Contact c;
        private Lead l;     
        public Profile(MemberPortal.Key key) {
            try {
                if (key.contactid!=null) {
                c = [
                    SELECT a.id, a.country__c, a.name,
                        id, firstname, lastname, email
                    From Contact c, c.Account a 
                    WHERE accountid=:key.accountid
                        AND id=:key.contactid][0];
                }
                else if (key.leadid!=null) {
                    l= [SELECT id, Lead_Country__c, firstname, lastname, company, email
                        From Lead 
                        WHERE id=:key.leadid][0];                   
                }
                
            }
            catch(Exception ex) {}
        }
        public string contactId     {GET { return ( c!=null) ? c.id                     : null; } }
        public string leadId        {GET { return ( c!=null) ? c.id                     : null; } }
        public string accountId     {GET { return ( c!=null) ? c.accountid              : null; } }
        public string accountName   {GET { return ( c!=null) ? c.account.name           : null; } } //legacy
        public string firstName     {GET { return ( c!=null) ? c.firstName              : (l!=null) ? l.firstname   : null; } }
        public string lastName      {GET { return ( c!=null) ? c.lastName               : (l!=null) ? l.lastname    : null; } } 
        public string email         {GET { return ( c!=null) ? c.email                  : (l!=null) ? l.email       : null; } }      
        public string Country       {GET { return ( c!=null) ? c.account.Country__c     : (l!=null) ? l.Lead_Country__c : null; } }  
        public string Company       {GET { return ( c!=null) ? c.account.name           : (l!=null) ? l.Company     : null; } }
    
    }

    public class MemberPortalException extends Exception {}
    
    ////////////////////////////////////////////////////////////////////////////////////
    //   Helper functions
    ////////////////////////////////////////////////////////////////////////////////////    
    

    //portal: SiteObject__c.ExternalId__c (recommended) or SiteObject__c.Id 
    //email address 
    public static string createToken(string portal, string email ) {
        string rtn=null;
        if (portal!=null) {
            if (portal.substring(0,3)==Schema.SObjectType.SiteObject__c.getKeyPrefix() && portal.length()>=15) {
                rtn=portal.substring(0,15)+':'+email; //if Id truncate to 15 chars
            }
            else
                rtn=portal+':'+email;
            rtn=encryptToken(rtn);
        }
        return rtn;
    }
    //legacy,  use createToken
    public static string createKey(string portalId, string accountId, string contactId ) {
        string rtn=null;
            try { rtn=portalId.substring(0,15)+accountId.substring(0,15)+contactId.substring(0,15); }
            catch(Exception ex) {}
            return rtn;
    }   







    //s: string to encrypt; returns: encrypted base64 string
    public static string encryptToken(string s) {
        return EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', blob.valueof('1LG7PW1to4Pzw534'), Blob.valueOf(s)));
    }
    //s: encrypted base64 string; returns decrypted value
    public static string decryptToken(string s) {
        return Crypto.decryptWithManagedIV('AES128', blob.valueof('1LG7PW1to4Pzw534'), EncodingUtil.base64Decode(s)).toString();
    }  
    
}