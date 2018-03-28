/*******************************************************************************
Copyright © 2009 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Main Class for Subscription Center

Modifications:
TESII20091113 treat MEMBER_TRANS as OPT_IN
TESII20100203 - Fixed issue with CM Upserts not replicating to SOV for large batches via API calls
********************************************************************************/
public class SubscriptionCenter {

    public static final string OPT_IN               ='Member-Opt-In';
    public static final string OPT_OUT              ='Opt-Out';
    public static final string MEMBER_TARGET        ='Member-Target';
    public static final string MEMBER_TRANS         ='Member-Transactional';
    public static final string CONTACT_PREFIX       = Contact.sObjectType.getDescribe().getKeyPrefix();
    public static final SET<string> DUPONT_CONNS    = new SET<string>{'All Dupont', 'DuPont', 'E. I. DuPont de Nemours'};   
    public static final string ORG                  = UserInfo.getOrganizationId().substring(0,15);
    public static final string NEW_LEAD_ORIGINTYPE = 'Website'; 
    public static final string RTYPE_CAMP_SUBLIST   = Rtype.getIdByName('Campaign', 'Subscriber List');

    public static boolean DISABLE_SOV_UPSERT_TRIGGER    =false;
    public static boolean DISABLE_CM_UPSERT_TRIGGER     =false;
    
    
    public static MAP<string,string> DUPONT_ORGS = new MAP<string,string> {
            'All Dupont'                =>'00D3000000066BQ',    //CORP  
            'E. I. DuPont de Nemours'   =>'00D300000000IlK',    //DCSE 
            'DuPont'                    =>'00D3000000009K7'     //BI
        };

    
    
    public static List<PartnerNetworkConnection> PNConnections; 
    public static boolean TESTMODE=false;   
    
    
/*******************************************************************************************
  SF TO SF 
  
    CORP    - sf2sf to BI, DCSE
    BI      - sf2sf to CORP
    DCSE    - sf2sf to CORP
******************************************************************************************/
    public static List<PartnerNetworkConnection> getPartnerNetworkConnection() {
        if ( PNConnections!=null) return PNConnections;
        else {
            SET<string> sf2sfOrgs = new SET<string>();
            if ( UserInfo.getOrganizationId().startsWith('00D3000000066BQ') ) {
                sf2sfOrgs.add('E. I. DuPont de Nemours');
                sf2sfOrgs.add('DuPont');
            }
            else 
                sf2sfOrgs.add('All Dupont');
                
            return new List<PartnerNetworkConnection>([
                    select Id, ConnectionStatus, ConnectionName 
                    from PartnerNetworkConnection 
                    where ConnectionName in: DUPONT_ORGS.keySet() and ConnectionStatus='Accepted'
                    ]);
        }
    }


    //////////////////////////////////////////////////////////////////////////////
    //Sync all inserts and updates to the other instances
    //Syncs all records in this set
    /////////////////////////////////////////////////////////////////////////////
    public static void S2S_SOV(LIST<SiteObjectValue__c> sovs) {
        List<PartnerNetworkRecordConnection> pnrcs = new List<PartnerNetworkRecordConnection>();
        for(PartnerNetworkConnection conn : SubscriptionCenter.getPartnerNetworkConnection()) { 
            for  (SiteObjectValue__c sov : sovs  )
                if (sov.ConnectionReceivedId == NULL && sov.ExternalId__c != null ) {
                    //Select SYNC (all changes goto CORP where only BI,DSCE changes get replicated as needed)
                    if ( !UserInfo.getOrganizationId().startsWith('00D3000000066BQ') || 
                            sov.ExternalId__c.startsWith(DUPONT_ORGS.get(conn.ConnectionName))
                         ){
                        pnrcs.add( new PartnerNetworkRecordConnection(ConnectionId=conn.Id, LocalRecordId=sov.id, ParentRecordId=sov.SiteObject__c));
                    }
                }
                
        }
        if (!SubscriptionCenter.TESTMODE && pnrcs.size()>0) {
            try { 
                system.debug('SOV Sync:pnrcs: '+pnrcs);
                insert pnrcs;   
            }
            catch(Exception ex) {
                system.debug('Exception: '+ex);
                
                // Send an email to me
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'thomas.snyder@usa.dupont.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('ERROR: SOV Sync on ORG: ' + UserInfo.getOrganizationId());
                
                string s = 'Exception: '+ex+'\n\n';
                s+='LocalRecordId                     \tConnectionId\n';
                s+='----------------------------------\t------\n';
                for (PartnerNetworkRecordConnection p : pnrcs)
                    s+=p.LocalRecordId+'\t'+p.ConnectionId+'\n';
                    
                mail.setPlainTextBody(s);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }
        }
    }


/*******************************************************************************************
    SubList - represents a Subscriber List 
    (Campaign, and memberstatus for a particular member if avail)
*********************************************************************************************/
public class SubList {
    
    public string           id                      {set; get;}
    public SiteObject__c    listObject              {set; get;}
    public string           name                    {set; get;}
    public string           description             {set; get;}
    public string           memberStatus            {set; get;}
    public string           lang                    {set; get;}
    public boolean          checked                 {set; get;}
    public boolean          readonly                {set; get;}
    public decimal          order                   {set; get;} 
    public string           globalCampaignId        {set; get;} 

    public SubList() {
        this.checked=false;
        this.readonly=false;
        this.memberStatus=null;
        this.order=999;
        this.checked=false;
    }
    public SubList(siteObject__c so) {
        this();
        if (so!=null) {
            //this.id=so.id; 
            this.listObject=so;
            this.globalCampaignId = so.externalId__c;
            this.name =so.PublicName__c;
            this.description = so.PublicDescription__c;
        }
    }
        
    public SubList(SiteObjectItem__c soi, SiteObjectValue__c sov) {
        this(soi, (sov!=null) ? sov.value__c : null);
        }   
    public SubList(SiteObjectItem__c soi, string value) {
        this(soi.ChildSiteObject__r);
        this.id=soi.id; 
        this.memberStatus=value;
        this.order= (soi.order__c == null) ? 999 : soi.order__c;
        this.checked=MemberStatusToChecked;
    }
        
        public boolean isDirty {
            get {
                if ( this.readonly==true ) return false;
                else return ( this.checked != MemberStatusToChecked );
            }
        }
        
        private boolean MemberStatusToChecked {
            GET {
                return (this.memberStatus==MEMBER_TRANS || this.memberStatus==OPT_IN);
            }
        }


    } //end Sublist



/*****************************************************************************
    SubCenter - represents a grouping of Sublists
*****************************************************************************/
public class SubCenter {
    
    public string orgId                 {set; get;}
    public string id                    {set; get;}  
    public string name                  {set; get;}
    public string description           {set; get;}
    public string returnUrl             {set; get;}
    public string SubformId             {set; get;}
    private MAP<string,SubList> items   {set; get;}
    
    private SiteObject__c centerObject; 
    
    public SubCenter() {
        this.items = new MAP<string,SubList>();
    }
    
    public SubCenter(string siteObjId) {this(siteObjId,null,null);}
    public SubCenter(string siteObjId, string email)  {this(siteObjId,email,null);}
    public SubCenter(string siteObjId, string email, string isolang) {
    
        if (SiteObjId!=null) {
            
            centerObject = SiteBuilder.getSiteObjectAndItems(SiteObjId, SiteBuilder.RTYPE_SO_CENTER, SiteBuilder.RTYPE_SOI_CENTERITEM, isoLang);
            if (centerObject!=null) {
                
                /////////////////////////////////////////////////////////////////////////////////////////
                //  Put each List in mapSiteObjects
                /////////////////////////////////////////////////////////////////////////////////////////   
                Map<id,SiteObject__c> mapSiteObjects = new Map<id,SiteObject__c>();
                for (SiteObjectItem__c soi : centerObject.Items__r ) {
                            mapSiteObjects.put(soi.ChildSiteObject__c,soi.ChildSiteObject__r);
                }
        
                /////////////////////////////////////////////////////////////////////////////////////////
                //get the values for the lists
                /////////////////////////////////////////////////////////////////////////////////////////
                MAP<Id,SiteObjectValue__c> sovs = new MAP<id, SiteObjectValue__c>();
                if (email!=null  && mapSiteObjects.size()>0) {
                    for ( SiteObjectValue__c sov : [
                                Select Value__c, SiteObject__c, 
                              //LastUpdatedLocation__c,  -- Part of remediation 
                                Id, ExternalId__c, Email__c 
                                From SiteObjectValue__c
                                where email__c=:email AND SiteObject__c in : mapSiteObjects.KeySet()
                            ])
                        sovs.put(sov.SiteObject__c, sov);
                }   
        
                /////////////////////////////////////////////////////////////////////////////////////////
                //  add the center to mapSiteObjects to get translated w/ the lists
                /////////////////////////////////////////////////////////////////////////////////////////
                mapSiteObjects.put(centerObject.id, centerObject);
                SiteBuilder.translateSiteObjects(mapSiteObjects, isolang);
                
                this.name=centerObject.publicname__c;
                this.description=centerObject.PublicDescription__c;
                this.id=centerObject.id;
                this.SubFormId=centerObject.SubForm__c;
                
                if ( centerObject.ReturnUrl__c != null )
                    this.returnUrl = (centerObject.ReturnUrl__c.startswith('http'))
                        ? centerObject.ReturnUrl__c : 'http://'+centerObject.ReturnUrl__c;  
                
                //add the SubList
                this.items = new MAP<string,SubList>();
                if ( centerObject.Items__r != null && centerObject.Items__r.size()>0 ) {
                    for (SiteObjectItem__c soi : centerObject.Items__r ) {
                        if (sovs.containskey(soi.ChildSiteObject__c))
                            this.items.put(soi.id,new SubList(soi,sovs.get(soi.ChildSiteObject__c)));
                        else
                            this.items.put(soi.id,new SubList(soi,(string) null));

                    }
                }
            }
            
    } //end: SiteObjId!=null
    else 
        this.items = new MAP<string,SubList>();
}
    
    
    public MAP<string,SubList> getItemMap() {
            return items;
    }
    
    //////////////////////////////////////////////////////////////////////////////////////
    public SubList[] getItems() {
        SubList[] rtn=new SubList[items.size()];
        MAP<decimal,List<SubList>> sortedLists = new MAP<decimal,List<SubList>>();
        for (SubList s : items.values()) {
            if (! sortedLists.containskey(s.order))
                sortedLists.put(s.order,new List<SubList>());
            sortedLists.get(s.order).add(s);
        }
        List<decimal> sortkey = new List<decimal>();
        for (decimal d : sortedLists.keyset() ) 
            sortkey.add(d);
            
        sortkey.sort();
        
        integer order=0;
        for (decimal d : sortkey ) {
            for (SubList s : sortedLists.get(d)) {
                rtn[order++]=s;
            }
        }
         return rtn;
    }
    //////////////////////////////////////////////////////////////////////////////////////
    public SubList getItem(string id) {
        if (items.containskey(id)) 
            return items.get(id);
        else
            return null;
    }
    
    //////////////////////////////////////////////////////////////////////////////////////
    public void save(string email, string lastUpdatedLocation) {
        if (email!=null) {
            LIST<SiteObjectValue__c> SOVsToUpsert = new LIST<SiteObjectValue__c>();
            for ( SubList s : items.values() ) {
                if ( s.isDirty ) {
                    SiteObjectValue__c sov = new SiteObjectValue__c(
                            name='', 
                            SiteObject__c   = s.listObject.id, 
                            ExternalId__c   = s.globalCampaignId+email,
                            email__c = email, 
                            value__c=SubscriptionCenter.OPT_OUT 
                        );
                    sov.value__c= SubscriptionCenter.getNewMemberStatus(sov.value__c, s.checked);
                    if (lastUpdatedLocation!=null) sov.lastUpdatedLocation__c=lastUpdatedLocation;
                    //?last updated SiteObjId
                    SOVsToUpsert.add(sov);
                }               
            } //next SubList s
            system.debug('----UPSERT: '+SOVsToUpsert);  
            upsert SOVsToUpsert ExternalId__c;
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////
    public SiteObject__c SiteObject {
        Get {
            return centerObject;
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////
    public boolean isDirty {
        GET {
        for ( SubList s : items.values() )
                if ( s.isDirty ) return true;
        return false;
        }
    }
    
    //Total number of checked Items
    public integer numChecked {
        GET {
        integer rtn=0;
        for ( SubList s : items.values() )
                if ( s.checked ) rtn++;
        return rtn;
        }
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////
    public static string getNewMemberStatus(string currentStatus, boolean checked) {
        string rtn=currentStatus;
        if (checked)
            rtn=OPT_IN;
        else {
            SET<string> optOuts = new SET<string>{MEMBER_TRANS,MEMBER_TARGET,OPT_IN,OPT_OUT,'To Be Determined'};
            if (optOuts.contains(CurrentStatus)) rtn=OPT_OUT;
        }
        return rtn; 
    }
    

    /**********************************************************************
    used in trigCampMemberSubscription
    
    Upsert Site Object Value sVia CampaignMember change
    ***********************************************************************/
    
    //////////////////////////////////////////////////////////////////////////////////////
    public static void CampaignMember_BeforeUpsert(LIST<CampaignMember> members) {
        system.debug('--------CampaignMember_BeforeUpsert:members------>'+members);
            for (CampaignMember cm : members) {
                if (cm.fEmail__c != null && cm.fEmail__c.trim() != '')
                    cm.SubscriptionId__c=ORG+String.valueof(cm.CampaignId).substring(0,15)+cm.fEmail__c.toLowerCase();
            }
    }
    ////////////////////////////////////////////////////////////////////////////////////// 
    public static void CampaignMember_AfterUpsert(MAP<Id,CampaignMember> members) {
    
            //////////////////////////////////////////////////////////////////
            //Filter members in Campaigns with RTYPE = 'Subscriber List'
            //////////////////////////////////////////////////////////////////
            MAP<Id,CampaignMember> listmembers = new MAP<Id,CampaignMember>([
                SELECT Id, CampaignId,     Status, fEmail__c, SubscriptionId__c
                //lastUpdatedLocation__c -- KK
                FROM CampaignMember 
                WHERE   id                          in : members.keyset()  
                    AND Campaign.recordtypeid        = : RTYPE_CAMP_SUBLIST
                    AND fEmail__c !=null
                        //Status in (:SubscriptionCenter.OPT_IN, :SubscriptionCenter.OPT_OUT) 
            ]);
            system.debug('----Subscription List Campaign Members-->'+members);
            //////////////////////////////////////////////////////////////////
            
            //////////////////////////////////////////////////////////////////
            // Copy member details to SiteObjectValue__c records
            //////////////////////////////////////////////////////////////////      
            Map<string,SiteObjectValue__c> SOVs = new Map<string,SiteObjectValue__c>();
            for ( CampaignMember m : listmembers.values() ) {
                if (m.femail__c != null) {
                    string extid = ORG+String.valueOf(m.CampaignId).substring(0,15);
                    SiteObject__c so = new SiteObject__c(ExternalId__c=extid);
                    SiteObjectValue__c sov = new SiteObjectValue__c(
                        ExternalId__c           = m.SubscriptionId__c, 
                        SiteObject__r           = so, 
                        value__c                = m.Status, 
                        email__c                = m.femail__c
                    //  lastUpdatedLocation__c  = m.LastUpdatedLocation__c
                        );
                    SOVs.put(m.SubscriptionId__c,sov);
                }
            }
            system.debug('----SOVs to Upsert-->'+SOVs.values());
            
            //Update SOV (disable sov trigger to avoid recursion)
            SubscriptionCenter.DISABLE_SOV_UPSERT_TRIGGER=true;
            upsert SOVs.values() ExternalId__c;
            SubscriptionCenter.DISABLE_SOV_UPSERT_TRIGGER=false;
                    
            //*****************************
            //  UPDATE CMEMBER (SIBLING)
            //*****************************
            Map<Id,CampaignMember> cmembersToUpdate = new Map<Id,CampaignMember>([
                Select Id, LeadId, ContactId, SubscriptionId__c, status, campaignId 
              //  lastUpdatedLocation__c - kk
                from CampaignMember
                where ( SubscriptionId__c in :SOVs.keyset())
                ]);
                
                // Exclude the original upserted members
                for (CampaignMember cm : listmembers.values()) {
                    if (cmembersToUpdate.containsKey(cm.Id))
                        cmembersToUpdate.remove(cm.Id);
                }
                //update the status and the lastUpdatedLocation__c
                 for (CampaignMember cm : cmembersToUpdate.values() ) {
               //     cm.LastUpdatedLocation__c   = SOVs.get(cm.SubscriptionId__c).LastUpdatedLocation__c; - KK
                    cm.Status                   = SOVs.get(cm.SubscriptionId__c).Value__c;
                 }
                SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER=true;
                update cmembersToUpdate.values();
                SubscriptionCenter.DISABLE_CM_UPSERT_TRIGGER=false;
    }
    
//////////////////////////////////////////////////////////////////////////////////////
            //Filter Campaigns with RTYPE = 'Subscriber List'
            //////////////////////////////////////////////////////////////////
    private static MAP<Id,Campaign> FilterListCampaigns(LIST<Campaign> campaigns) {
            MAP<Id,Campaign> rtn = new MAP<Id,Campaign>();
            for ( Campaign c : campaigns )
                if (c.RecordTypeId==RTYPE_CAMP_SUBLIST) 
                    rtn.put(c.id,c);
            return rtn;
    }
    
//////////////////////////////////////////////////////////////////////////////////////  
    
    public static void Campaign_BeforeDelete(MAP<Id,Campaign> campaigns) {  
        
        MAP<Id,Campaign> listCampaigns = FilterListCampaigns(campaigns.values());
        
        LIST<SiteObject__c> siteObjects = new LIST<SiteObject__c>();    
        for ( Campaign c : listCampaigns.values() ) {
            if (c.RecordTypeId==RTYPE_CAMP_SUBLIST) {
                string externalId=UserInfo.getOrganizationId().substring(0,15)+String.valueof(c.Id).substring(0,15);
                siteObjects.add( new SiteObject__c(IsPublic__c=false, 
                    externalId__c=externalId));
            }
        }
        system.debug(siteObjects);
        upsert siteObjects externalId__c;
    }
    
    



//////////////////////////////////////////////////////////////////////////////////////
    public static void Campaign_AfterUpsert(MAP<Id,Campaign> campaigns) {

        MAP<Id,Campaign> listCampaigns = FilterListCampaigns(campaigns.values());
        
        if (listCampaigns.size()>0) {
            
            //*************
            //  UPSERT SOV
            //*************
            //upsert the SiteObject__c 'List' to reflect the campaign 
            LIST<SiteObject__c> siteObjects = new LIST<SiteObject__c>();
            for ( Campaign c : listCampaigns.values() ) {
                if (! c.IsDeleted) {  //Added cause the after update fires on delete
                    string name = (c.PublicName__c!=null) ? c.PublicName__c : c.name;
                    string externalId=ORG+String.valueof(c.Id).substring(0,15);
                    siteObjects.add( new SiteObject__c(name=name, PublicName__c=name, PublicDescription__c=c.PublicDescription__c, IsPublic__c=c.IsPublic__c, 
                        externalId__c=externalId, campaign__c=c.id, recordtypeid=SiteBuilder.RTYPE_SO_LIST,  type__c='Subscription List'));             
                }
                    
            }
            upsert siteObjects externalId__c;

            
        if (SubscriptionCenter.TESTMODE)    
            CreateCampaignMemberStatusforLists(listCampaigns.values());
        }
    }

//////////////////////////////////////////////////////////////////////////////////////
    //Update the CampaignMemberStatus status
    //TODO: GET THIS TO WORK,  THIS DOES NOT WORK
    // ISSUES:  cannot update a label of an existing status
    //          cannot delete the default status
    public static void CreateCampaignMemberStatusforLists(LIST<Campaign> listCampaigns ) {

        MAP<integer,string> stats = new MAP<integer,string>{
                    1=>MEMBER_TARGET,
                    2=>OPT_IN,
                    3=>OPT_OUT,
                    4=>MEMBER_TRANS                         
                };
        
        List<CampaignMemberStatus> cmsToInsert = new List<CampaignMemberStatus>();  
        List<CampaignMemberStatus> cmsToDelete = new List<CampaignMemberStatus>();  
        try {
                //Get all the CampaignMemberStatus for the list campaigns
                MAP<ID,MAP<integer,CampaignMemberStatus>> cmss = new MAP<ID,MAP<integer,CampaignMemberStatus>>();
                for (CampaignMemberStatus cms : [ 
                        Select Id, CampaignId, SortOrder, Label, IsDefault, HasResponded 
                        From CampaignMemberStatus 
                        where CampaignId in :listCampaigns
                        ]) {
                    if ( !cmss.containskey(cms.CampaignId) )
                        cmss.put(cms.CampaignId, new MAP<integer,CampaignMemberStatus>());
                    cmss.get(cms.CampaignId).put(cms.sortorder,cms);
                }
                
                for ( Campaign c : listCampaigns ) {
                    
                    if ( ! cmss.get(c.Id).containskey(1) )
                        cmsToInsert.add(new CampaignMemberStatus(label=stats.get(1),sortorder=1,CampaignId=c.id,IsDefault=true, HasResponded=false));       
                    else if (cmss.get(c.Id).get(1).label != stats.get(1)) {
                        cmsToDelete.add(cmss.get(c.Id).get(1));
                        cmsToInsert.add(new CampaignMemberStatus(label=stats.get(1),sortorder=1,CampaignId=c.id,IsDefault=true, HasResponded=false));       
                    }
                            
                            
                    for (integer ordernum : stats.keyset() ) {
                        if (ordernum>1) {
                            if ( ! cmss.get(c.Id).containskey(ordernum) )
                                cmsToInsert.add(new CampaignMemberStatus(label=stats.get(ordernum),sortorder=ordernum,CampaignId=c.id,IsDefault=false, HasResponded=true));     
                            else if (cmss.get(c.Id).get(ordernum).label != stats.get(ordernum)) {
                                cmsToDelete.add(cmss.get(c.Id).get(ordernum));
                                cmsToInsert.add(new CampaignMemberStatus(label=stats.get(ordernum),sortorder=ordernum,CampaignId=c.id,IsDefault=false, HasResponded=true));         
                            }
                        }
                    }               
                }

                

                system.debug('----CampaignMemberStatus:BEFORE_INSERT------>'+cmsToInsert);
                if (cmsToInsert.size()>0)
                    insert cmsToInsert;
                        system.debug('----CampaignMemberStatus:AFTER_INSERT------>'+[Select Id, CampaignId, SortOrder, Label, IsDefault, HasResponded From CampaignMemberStatus where CampaignId in :listCampaigns]);
 
                if (cmsToDelete.size()>0)
                            delete cmsToDelete;
                
               
        
        }
        catch (Exception ex) {
            system.debug('Error: '+ex);
        } 
    }
    
    
    
    
    
////////////////////////////////////////////////////////////////////////////
public static MAP<string,CampaignMember> SOVtoCampaignMembers(SiteObjectValue__c sov, SET<string> Ids) {
    MAP<string,CampaignMember> rtn = new MAP<string,CampaignMember>();
    for (string memberid : Ids) {
        CampaignMember cm = new CampaignMember();
     // cm.LastUpdatedLocation__c=sov.LastUpdatedLocation__c;
        cm.Status=sov.value__c;
        cm.CampaignId=sov.ExternalId__c.substring(15,30);
        if ( memberid.startswith(CONTACT_PREFIX))
            cm.ContactId=memberid;
        else 
            cm.LeadId=memberid;
        rtn.put(sov.ExternalId__c.substring(15,30)+memberid.substring(0,15),cm);
    }
    return rtn;
}

////////////////////////////////////////////////////////////////////////////    
    public static string crlfToBR(string s) {
        return s.replace('\n','<BR/>');
    }
////////////////////////////////////////////////////////////////////////////    
    public static string mergefieldUrl(string url, string email, string lang, string src) {
        if (email==null)    email='';
        if (src==null)      src='';
        if (lang==null)     lang='';
        url=url.replaceAll('\\{![E,e][M,m][A,a][I,i][L,l]}',email);
        url=url.replaceAll('\\{![L,l][A,a][N,n][G,g]}',lang);
        url=url.replaceAll('\\{![S,s][R,r][C,c]}',src);
        return url;
    }

////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////
    public static string hash(string s) {
        return System.Encodingutil.base64Encode(Blob.valueof(s));
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////



/*************************************************************************************

TEST SCRIPTS

*************************************************************************************/

public static string testAddSubCenter(string name) {
        SubscriptionCenter.TESTMODE=true;
        string subformId = SiteBuilder.testAddSubform();
        
        SiteObject__c Center1 = new SiteObject__c(name=name, type__c='Subscription Center', recordTypeid=SiteBuilder.RTYPE_SO_CENTER, publicname__c=name, returnUrl__c='www.3ddd.com', subform__c=subformId);   
        insert Center1;
        Campaign  ListA = new Campaign(name=name+'.ListA', recordTypeid=RTYPE_CAMP_SUBLIST, publicname__c=name+'.ListA');   
        Campaign  ListB = new Campaign(name=name+'.ListB', recordTypeid=RTYPE_CAMP_SUBLIST, publicname__c=name+'.ListB');   
        insert new Campaign[]{ListA,ListB};
        
        LIST<SiteObject__c> soLists = new LIST<SiteObject__c>([
            Select Id 
            from SiteObject__c 
            where Campaign__c in ( :ListA.id, :ListB.id )
            ]);
        
        for (SiteObject__c sol : soLists) {
            insert new SiteObjectItem__c(SiteObject__c=Center1.id, ChildSiteObject__c=sol.id, recordtypeid=SiteBuilder.RTYPE_SOI_CENTERITEM);
            
        }
        return Center1.Id;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
public static testMethod void test_SubscriptionCenter() {
        
        SubscriptionCenter.TESTMODE=true;
        string CenterId = SubscriptionCenter.testAddSubCenter('Center1');
        SubscriptionCenter.SubCenter center = new SubscriptionCenter.SubCenter(CenterId);
        SubscriptionCenter.SubList lst = center.getItems()[0];
        string email = 'subscriptioncentertester@3ddd.com';
        string sid=lst.globalCampaignId+email;
        System.debug('@#debuggetItems'+center.getItems());
        //OPT-IN  tester to all lists
        for (SubList l : center.getItems() )
            l.checked=true; 
        center.save(email, 'test_SubscriptionCenter1');
        system.debug(center.isDirty);
        system.debug(center.numChecked);
        system.debug(center.getItem(lst.id));
        string campid=lst.globalCampaignId.substring(15);
        
        
        //Add tester as Contact and add to lst Campaign as status = member-transactional
        Account a = new Account(name='test', Country__c='United States');
        insert a;
        Contact contact1 = new Contact(lastname='test', email=email, Account=a, Contact_Country__c='United States');
        insert contact1;
        CampaignMember member = new CampaignMember(campaignid=campid, status=MEMBER_TRANS, Contactid=contact1.id );
        insert member;
        system.debug('------member----->'+member);
        system.debug([Select value__c, ExternalId__c from SiteObjectValue__c where ExternalId__c=:sid]);        
        
        
        //requery the centers and try to opt out of all lists....
        center = new SubscriptionCenter.SubCenter(CenterId);
        for (SubList l : center.getItems() )
            l.checked=false;    
        center.save(email,'test_SubscriptionCenter2');
        system.debug([Select value__c, ExternalId__c from SiteObjectValue__c limit 10000]);
        //system.assertEquals([Select value__c from SiteObjectValue__c where ExternalId__c=:sid][0].value__c, MEMBER_TRANS);
            
        //delete the campaign...
        try {   
        delete new Campaign(id=campid);
        }
        catch(Exception ex) {}
        
        
        system.debug(crlfToBR('this\nthat'));
        system.debug(mergefieldUrl('{!email}{!lang}{!src}', null, null, null));
        system.debug(hash('hashthis'));
        
    }
////////////////////////////////////////////////////////////////////////////////////
}




/*  
//////////////////////////////////////////////////////////////////////////////////////  
    public static MAP<Id,string> normalizeCampaignMembers(LIST<CampaignMember> campaignMembers) {
        MAP<Id,string> memberStatus = new MAP<Id,string>(); //MAP<CampaignId,memberStatus>
        for (CampaignMember cm : campaignMembers) {
            if (memberStatus.containsKey(cm.CampaignId)) {
                //(pick best member status)
                string currStat=memberStatus.get(cm.CampaignId);
                if (cm.status==MEMBER_TRANS )
                    memberStatus.put(cm.CampaignId,cm.status);
                else if (currStat!=MEMBER_TRANS || currStat!=OPT_IN) 
                    memberStatus.put(cm.CampaignId,cm.status);
            }
            else 
                memberStatus.put(cm.CampaignId,cm.status);
        }
    return memberStatus;
    }
//////////////////////////////////////////////////////////////////////////////////////
*/