/*******************************************************************************
Copyright © 2013 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for component RelatedList 
********************************************************************************/
public with sharing class ctrlRelatedList {

    //attributes
    public string parentId                  {get; set;}
    public string relationship              {get; set;}
    public string colsFieldSetName          {get; set;}
    public string whereClause               {get; set;}
    private RelatedList cacheRelatedList    {get; private set;}

    
    public RelatedList rlist {
        get {
            if (cacheRelatedList==null)
                cacheRelatedList=new RelatedList(parentId, relationship, colsFieldSetName, whereClause);
            return cacheRelatedList;
        }
    }   
    
        public class RelatedList {
            
            public LIST<item> items                 {get; set;}
            public string selectionType             {get; set;} //checkbox, radio, none
            public string sobjectType               {get; set;} 
            public string colsFS                    {get; set;}
            //public transient Schema.FieldSet colFieldSet      {get; private set;}
            
            public Schema.FieldSet colFieldSet {
                 get { 
                    Schema.FieldSet rtn;
                    try {
                    if (sobjectType!=null && colsFS!=null)
                        rtn=Schema.getGlobalDescribe().get(sobjectType).getDescribe().fieldSets.getMap().get(colsFS);
                    }catch(Exception ex) {}
                    return rtn; 
                 }
            }
            
            public RelatedList(string parentid, string relationship, string colsFieldSetName, string whereClause) {
                colsFS=colsFieldSetName;
                
                //init items
                items = new LIST<item>();
                if (Util.isId(parentId) && !Util.isBlank(relationship)) {
                    Util.Describe descrParent = new Util.Describe(Util.TypeById(parentid));
                    Schema.ChildRelationship crel = descrParent.getChildRelationship(relationship);
                    if (crel!=null) {
                        string fld=String.valueOf(crel.getField());
                        sobjectType = String.valueOf(crel.getChildSObject());
                        Util.Describe descrChild = new Util.Describe(sobjectType);
                        string soql = 'SELECT ' + Util.joint(descrChild.AccessibleFieldMap.values(),',');
                        soql += ' FROM ' + sobjectType;
                        soql += ' WHERE '+ fld + '=:parentId';
                        if (!Util.isBlank(whereClause)) 
                            soql += ' AND (' + whereClause + ')';
                        
                        for (sObject so : database.query(soql)) {
                            items.add(new item(so,this));
                        }
                    }       
                }
            
            

            }           
        }
    
    
        public class Item {
            public string indx                      {get; set;}
            public boolean isSelected               {get; set;}
            public transient sobject record         {get; set;}
            public MAP<string,string> extrinsics    {get; set;}
            public RelatedList parent               {get; set;}
                        
            public Item(sobject so,RelatedList p ) {
                indx=so.id;
                isSelected=false;
                record=so;
                extrinsics = new MAP<string,string>();
                parent=p;
            }
    }
    
    
    
   public static testMethod void test1() {
        geovalidation.DisableGeoValidationOverride=true;
        Account a =new Account(name='ParentCo', country__c='United States');
        insert a;
        Contact c1 =new Contact(accountid=a.id, lastname='TestCo: ', email='test1@test.com');
        Contact c2 =new Contact(accountid=a.id, lastname='TestCo: ', email='test2@test.com');
        insert c1;
        insert c2;
        Test.startTest();    
        ctrlRelatedList ctrl = new ctrlRelatedList();
        ctrl.parentId=a.id;
        ctrl.relationship='Contacts';
        ctrl.colsFieldSetName='RL Default';
        ctrl.whereClause='email=\'test2@test.com\'';
        Test.stopTest();
    }  
    
}