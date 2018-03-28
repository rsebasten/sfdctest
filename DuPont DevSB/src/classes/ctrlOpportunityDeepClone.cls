/*******************************************************************************
Author: Martin Ryder
Email: martin.ryder@doextra.com
Description:  OpportunityDeepClone controller class
********************************************************************************/
//Will make a clone of the opportunity, changing the name, and duplicating related lists for:
//Contact Roles, Opportunity-Contacts, Opportunity-Products, Opportunity Line Items, Opportunity Team
//Use of dynamic SOQL & metadata fields ensures new fields will be included as expected.

//<MR20160614> remove generated schedules before cloning old ones.
//<MR20160614> List inactive products.
	



public class ctrlOpportunityDeepClone {
	//<MR20160614> List inactive products.
	public list<opportunityLineItem> inactiveProducts {get;set;}
    public opportunity newOpp {get;set;}
        
    public opportunity opp {get;set;}
    public string fieldlist {get;set;}
    public ctrlOpportunityDeepClone(apexpages.standardcontroller sc){
        opp = (opportunity)sc.getRecord();
    }
    
    public string makeNewName(){
        string newName=opp.Name;
        if (newName.left(6)=='Clone('){
            string sNum = newName.substring(6, newName.indexOf(')'));
            integer iNum=0;
            try{ 
                iNum = Integer.valueOf(sNum)+1;
            } catch (exception e){
                iNum=1;
            }
            newName='Clone('+ iNum +') ' + newName.substring(newName.indexOf(')')+1);
        } else if (newName.left(5)=='Clone'){
            newName='Clone(1) ' + newName.substring(5);
        } else {
            newName='Clone ' + newName;
        }
        if (newname.length()>120){
            newName = newName.left(120);
        }
        
        return newName;        
    }
    
    public pagereference deepclone(){
		//<MR20160614> List inactive products.
		inactiveProducts=[select id, product2Id, product2.name from opportunityLineItem where opportunityId=:opp.Id and product2.isActive=false];

        //Clone Opportunity Company, Opportunity Team, and Opportunity Contact Roles
        list<OpportunityTeamMember> newOppTeam = new list<OpportunityTeamMember>();
        Opportunity fullObj = database.query(getFullObjectQuery('Opportunity', 'id=\'' + opp.Id + '\''));
        newOpp = fullObj.clone(false, true, false, false);
        newopp.name=makeNewName();
        insert newOpp;
        
        list<opportunitycontactrole>newOCR = new list<opportunitycontactrole>();
        for(opportunitycontactrole ocr:[select contactId, role from opportunitycontactrole where opportunityid=:opp.id]){
            newOCR.add(new opportunitycontactrole(opportunityid=newopp.id, contactid=ocr.contactid, role=ocr.role));
        }
        if (newOCR.size()>0){
            insert newOCR;
        }
        
        list<Opportunitylineitem>newOLI = new list<Opportunitylineitem>();
        //<MR20160614> remove generated schedules before cloning old ones.
        set<Id> newOLIIds = new set<Id>();
        
        //<MR20160614> List inactive products.
		string sq = getFullObjectQuery('Opportunitylineitem', 'OpportunityId =\'' + opp.Id + '\' and product2.isActive=true');
		for(Opportunitylineitem oli:database.query(sq)){
            oli.clonedId__c=oli.Id;
        	Opportunitylineitem cloneOLI = oli.clone(false, true, false, false);
            cloneOLI.opportunityId=newopp.Id;
            if (cloneOLI.totalprice>0){
                cloneOLI.unitprice=null;
            } else {
                cloneOLI.totalprice=null;
            }
            newOLI.add(cloneOLI);
        }        
        if (newOLI.size()>0){
            insert newOLI;
            map<Id,Id>OliOldToNew = new map<Id,Id>();
            for (OpportunityLineItem olix:newOli){
                OliOldToNew.put((Id)olix.ClonedId__c, olix.Id);
                //<MR20160614> remove generated schedules before cloning old ones.
                newOLIIds.add(olix.Id);
            }
            //<MR20160614> remove generated schedules before cloning old ones.
        	list<opportunitylineitemschedule> interimolis = [select id from opportunitylineitemschedule where opportunityLineitemID in:newOLIIds];
            if (interimolis.size()>0){
                delete interimolis;
            }
            list<opportunitylineitemschedule> newolis = new list<opportunitylineitemschedule>();
            sq = getFullObjectQuery('opportunitylineitemschedule', 'opportunitylineitem.opportunityId =\'' + opp.Id + '\'');
            list<opportunitylineitemschedule> olis = database.query(sq);
            for (opportunitylineitemschedule olisx:olis){
                opportunitylineitemschedule cloneOlis = olisx.clone(false, true, false, false);
                cloneOlis.opportunitylineitemId=OliOldToNew.get(cloneOlis.opportunitylineitemId);
                newolis.add(cloneOlis);
            }
            if (newolis.size()>0){
                insert newolis;
            }
        }
		

        list<Opportunity_Products__c>newOP = new list<Opportunity_Products__c>();
        sq = getFullObjectQuery('Opportunity_Products__c', 'Opportunity__c =\'' + opp.Id + '\'');
		for(Opportunity_Products__c oc:database.query(sq)){
        	Opportunity_Products__c cloneOP = oc.clone(false, true, false, false);
            cloneOP.opportunity__c=newopp.Id;
            newOP.add(cloneOP);
        }        
        if (newOP.size()>0){
            insert newOP;
        }


        list<Opportunity_Company__c>newOC = new list<Opportunity_Company__c>();
        sq = getFullObjectQuery('Opportunity_Company__c', 'Opportunity__c =\'' + opp.Id + '\'');
		for(Opportunity_Company__c oc:database.query(sq)){
        	Opportunity_Company__c cloneOC = oc.clone(false, true, false, false);
            cloneOC.opportunity__c=newopp.Id;
            newOC.add(cloneOC);
        }        
        if (newOC.size()>0){
            insert newOC;
        }

		
        fieldlist=sq;//JSON.serializePretty(newOC);
        
        for (OpportunityTeamMember otm:[select OpportunityId, UserId, TeamMemberRole from OpportunityTeamMember where opportunityId=:opp.Id and User.isActive=True]){
            newOppTeam.add(new OpportunityTeamMember(OpportunityId=newOpp.Id, UserId=otm.UserId, TeamMemberRole=otm.TeamMemberRole));
        }
        if (newOppTeam.size()>0){
            insert newOppTeam;
        }
        List<OpportunityShare> shares = [select Id, OpportunityAccessLevel, RowCause from OpportunityShare where OpportunityId=:newOpp.Id and RowCause = 'Team'];
        for (OpportunityShare share : shares){  
            share.OpportunityAccessLevel = 'Edit';
        }
        update shares; 

        //<MR20160614> List inactive products.
		pagereference pr=null;
        if (inactiveProducts.size()==0){
            pr = ContinueToOpp();
        }
        return pr;
        
        //return null;
    }
    
    //<MR20160614> List inactive products.
	public pagereference ContinueToOpp(){
	        Apexpages.standardcontroller sc = new Apexpages.standardcontroller(newOpp);
            pagereference pr = sc.view();
			return pr;
    }
    
    public string getFullObjectQuery(string sobjecttype, string sWhere){
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(sobjecttype);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String,Schema.SObjectField> M = r.fields.getMap();
        Decimal ItemsOnChecklist = 0;
        list<string> fields = new list<string>();
        fields.addAll(M.keyset());
        
        string fieldstring = string.join(fields, ', ');
        string soql = 'select ' + fieldstring + ' from ' + sobjecttype + ' where ' + sWhere;
        return soql;
    }             
    
}