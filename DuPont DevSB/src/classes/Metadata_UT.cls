@isTest
private class Metadata_UT {
    
   //  [01022017] Merge&Spin:Commented string parameters as these are not referenced in any class in the org.
      //  static final string TESTRESPONSE_listMetadata   = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://soap.sforce.com/2006/04/metadata"><soapenv:Body><listMetadataResponse><result><createdById>00530000000yWfBAAU</createdById><createdByName>Floris de Klerk</createdByName><createdDate>2008-09-04T08:16:00.000Z</createdDate><fileName>objects/Call_Report_Item__c.object</fileName><fullName>Call_Report_Item__c</fullName><id>01I300000008UZsEAM</id><lastModifiedById>00530000000yWfBAAU</lastModifiedById><lastModifiedByName>Floris de Klerk</lastModifiedByName><lastModifiedDate>2010-01-11T06:06:20.000Z</lastModifiedDate><manageableState>unmanaged</manageableState><type>CustomObject</type></result><result><createdById>00530000000znVUAAY</createdById><createdByName>Tom Snyder</createdByName><createdDate>2010-09-20T17:45:43.000Z</createdDate><fileName>objects/Metadata__c.object</fileName><fullName>Metadata__c</fullName><id>01IS0000000DZ3iMAG</id><lastModifiedById>00530000000znVUAAY</lastModifiedById><lastModifiedByName>Tom Snyder</lastModifiedByName><lastModifiedDate>2010-10-15T18:38:11.000Z</lastModifiedDate><manageableState>unmanaged</manageableState><type>CustomObject</type></result><result><createdById>00530000003aJU1AAM</createdById><createdByName>Joe Ferraro</createdByName><createdDate>2010-03-07T16:37:59.000Z</createdDate><fileName>objects/SVMXC__Site__c.object</fileName><fullName>SVMXC__Site__c</fullName><id>01I300000011pRbEAI</id><lastModifiedById>00530000003aJU1AAM</lastModifiedById><lastModifiedByName>Joe Ferraro</lastModifiedByName><lastModifiedDate>2010-03-07T16:46:34.000Z</lastModifiedDate><manageableState>installed</manageableState><namespacePrefix>SVMXC</namespacePrefix><type>CustomObject</type></result></listMetadataResponse></soapenv:Body></soapenv:Envelope>';
      //  static final string TESTRESPONSE_describeLayout = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><describeLayoutResponse><result><layouts><buttonLayoutSection><detailButtons><custom>false</custom><label>Edit</label><name>Edit</name></detailButtons><detailButtons><custom>false</custom><label>Delete</label><name>Delete</name></detailButtons><detailButtons><custom>false</custom><label>Clone</label><name>Clone</name></detailButtons><detailButtons><custom>false</custom><label>Sharing</label><name>Share</name></detailButtons></buttonLayoutSection><detailLayoutSections><columns>2</columns><heading>Information</heading><layoutRows><layoutItems><editable>false</editable><label>API Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>1</tabOrder><type>Field</type><value>Name</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Parent</label><layoutComponents><displayLines>1</displayLines><tabOrder>12</tabOrder><type>Field</type><value>Parent__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Label</label><layoutComponents><displayLines>1</displayLines><tabOrder>2</tabOrder><type>Field</type><value>Label__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Is Custom</label><layoutComponents><displayLines>1</displayLines><tabOrder>13</tabOrder><type>Field</type><value>IsCustom__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>3</tabOrder><type>Field</type><value>Type__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Control</label><layoutComponents><displayLines>1</displayLines><tabOrder>14</tabOrder><type>Field</type><value>Control__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Edit Layout</label><layoutComponents><displayLines>1</displayLines><tabOrder>4</tabOrder><type>Field</type><value>fEditLayout__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>ReferenceTo Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>15</tabOrder><type>Field</type><value>ReferenceTo__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Last Modified By</label><layoutComponents><displayLines>1</displayLines><tabOrder>5</tabOrder><type>Field</type><value>LastModifiedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>ReferenceTo</label><layoutComponents><displayLines>1</displayLines><tabOrder>16</tabOrder><type>Field</type><value>ReferenceToMetadata__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Created By</label><layoutComponents><displayLines>1</displayLines><tabOrder>6</tabOrder><type>Field</type><value>CreatedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Last Modified</label><layoutComponents><displayLines>1</displayLines><tabOrder>7</tabOrder><type>Field</type><value>LastModifiedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Created</label><layoutComponents><displayLines>1</displayLines><tabOrder>8</tabOrder><type>Field</type><value>CreatedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Namespace</label><layoutComponents><displayLines>1</displayLines><tabOrder>9</tabOrder><type>Field</type><value>Namespace__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Business Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>10</tabOrder><type>Field</type><value>BusinessOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>TechnicalOwner</label><layoutComponents><displayLines>1</displayLines><tabOrder>11</tabOrder><type>Field</type><value>TechnicalOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>11</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>false</useHeading></detailLayoutSections><detailLayoutSections><columns>1</columns><heading>New Section</heading><layoutRows><layoutItems><editable>false</editable><label>FullName</label><layoutComponents><displayLines>1</displayLines><tabOrder>32</tabOrder><type>Field</type><value>FullName__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>ForceId</label><layoutComponents><displayLines>1</displayLines><tabOrder>33</tabOrder><type>Field</type><value>ForceId__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Description</label><layoutComponents><displayLines>5</displayLines><tabOrder>34</tabOrder><type>Field</type><value>Description__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Administrator Notes (rtf)</label><layoutComponents><displayLines>1</displayLines><tabOrder>35</tabOrder><type>Field</type><value>rtfAdminNotes__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><rows>4</rows><useCollapsibleSection>true</useCollapsibleSection><useHeading>true</useHeading></detailLayoutSections><detailLayoutSections><columns>2</columns><heading>System Information</heading><layoutRows><layoutItems><editable>false</editable><label>Created By</label><layoutComponents><displayLines>1</displayLines><tabOrder>40</tabOrder><type>Field</type><value>CreatedById</value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>41</tabOrder><type>Separator</type><value>, </value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>42</tabOrder><type>Field</type><value>CreatedDate</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Last Modified By</label><layoutComponents><displayLines>1</displayLines><tabOrder>44</tabOrder><type>Field</type><value>LastModifiedById</value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>45</tabOrder><type>Separator</type><value>, </value></layoutComponents><layoutComponents><displayLines>1</displayLines><tabOrder>46</tabOrder><type>Field</type><value>LastModifiedDate</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>false</editable><label>Record Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>43</tabOrder><type>Field</type><value>RecordTypeId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>47</tabOrder><type>Field</type><value>OwnerId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>2</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>false</useHeading></detailLayoutSections><editLayoutSections><columns>2</columns><heading>Information</heading><layoutRows><layoutItems><editable>true</editable><label>API Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>17</tabOrder><type>Field</type><value>Name</value></layoutComponents><placeholder>false</placeholder><required>true</required></layoutItems><layoutItems><editable>true</editable><label>Parent</label><layoutComponents><displayLines>1</displayLines><tabOrder>27</tabOrder><type>Field</type><value>Parent__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Label</label><layoutComponents><displayLines>1</displayLines><tabOrder>18</tabOrder><type>Field</type><value>Label__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>Is Custom</label><layoutComponents><displayLines>1</displayLines><tabOrder>28</tabOrder><type>Field</type><value>IsCustom__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>19</tabOrder><type>Field</type><value>Type__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>Control</label><layoutComponents><displayLines>1</displayLines><tabOrder>29</tabOrder><type>Field</type><value>Control__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Last Modified By</label><layoutComponents><displayLines>1</displayLines><tabOrder>20</tabOrder><type>Field</type><value>LastModifiedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>ReferenceTo Name</label><layoutComponents><displayLines>1</displayLines><tabOrder>30</tabOrder><type>Field</type><value>ReferenceTo__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Created By</label><layoutComponents><displayLines>1</displayLines><tabOrder>21</tabOrder><type>Field</type><value>CreatedBy__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>true</editable><label>ReferenceTo</label><layoutComponents><displayLines>1</displayLines><tabOrder>31</tabOrder><type>Field</type><value>ReferenceToMetadata__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Last Modified</label><layoutComponents><displayLines>1</displayLines><tabOrder>22</tabOrder><type>Field</type><value>LastModifiedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Created</label><layoutComponents><displayLines>1</displayLines><tabOrder>23</tabOrder><type>Field</type><value>CreatedDT__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Namespace</label><layoutComponents><displayLines>1</displayLines><tabOrder>24</tabOrder><type>Field</type><value>Namespace__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Business Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>25</tabOrder><type>Field</type><value>BusinessOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>TechnicalOwner</label><layoutComponents><displayLines>1</displayLines><tabOrder>26</tabOrder><type>Field</type><value>TechnicalOwner__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label></label><placeholder>true</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>10</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>true</useHeading></editLayoutSections><editLayoutSections><columns>1</columns><heading>New Section</heading><layoutRows><layoutItems><editable>true</editable><label>FullName</label><layoutComponents><displayLines>1</displayLines><tabOrder>36</tabOrder><type>Field</type><value>FullName__c</value></layoutComponents><placeholder>false</placeholder><required>true</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>ForceId</label><layoutComponents><displayLines>1</displayLines><tabOrder>37</tabOrder><type>Field</type><value>ForceId__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Description</label><layoutComponents><displayLines>5</displayLines><tabOrder>38</tabOrder><type>Field</type><value>Description__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><layoutRows><layoutItems><editable>true</editable><label>Administrator Notes (rtf)</label><layoutComponents><displayLines>1</displayLines><tabOrder>39</tabOrder><type>Field</type><value>rtfAdminNotes__c</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>1</numItems></layoutRows><rows>4</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>true</useHeading></editLayoutSections><editLayoutSections><columns>2</columns><heading>System Information</heading><layoutRows><layoutItems><editable>false</editable><label>Record Type</label><layoutComponents><displayLines>1</displayLines><tabOrder>48</tabOrder><type>Field</type><value>RecordTypeId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><layoutItems><editable>false</editable><label>Owner</label><layoutComponents><displayLines>1</displayLines><tabOrder>49</tabOrder><type>Field</type><value>OwnerId</value></layoutComponents><placeholder>false</placeholder><required>false</required></layoutItems><numItems>2</numItems></layoutRows><rows>1</rows><useCollapsibleSection>false</useCollapsibleSection><useHeading>true</useHeading></editLayoutSections><id>00hS0000000XX6mIAG</id><relatedLists><columns><field>MetadataItem__c.Name</field><format xsi:nil="true"/><label>MDR</label><name>Name</name></columns><columns><field>Metadata__c.Name</field><format xsi:nil="true"/><label>Related Metadata</label><name>RelatedMetadata__r.Name</name></columns><columns><field>MetadataItem__c.Type__c</field><format xsi:nil="true"/><label>Type</label><name>Type__c</name></columns><custom>true</custom><field>Metadata__c</field><label>MetadataRelations</label><limitRows>5</limitRows><name>MetadataRelations__r</name><sobject>MetadataItem__c</sobject></relatedLists><relatedLists><columns><field>MetadataItem__c.Name</field><format xsi:nil="true"/><label>MDR</label><name>Name</name></columns><columns><field>Metadata__c.Name</field><format xsi:nil="true"/><label>Metadata</label><name>Metadata__r.Name</name></columns><columns><field>MetadataItem__c.Type__c</field><format xsi:nil="true"/><label>Type</label><name>Type__c</name></columns><custom>true</custom><field>RelatedMetadata__c</field><label>MetadataRelations (children)</label><limitRows>5</limitRows><name>RelatedMetadata__r</name><sobject>MetadataItem__c</sobject></relatedLists></layouts><recordTypeMappings><available>true</available><defaultRecordTypeMapping>true</defaultRecordTypeMapping><layoutId>00hS0000000XX6mIAG</layoutId><name>Master</name><picklistsForRecordType><picklistName>CRIM_Support__c</picklistName><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Categorized</label><value>Categorized</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Inherited</label><value>Inherited</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>System</label><value>System</value></picklistValues></picklistsForRecordType><picklistsForRecordType><picklistName>Control__c</picklistName><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Corporate</label><value>Corporate</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Business Select</label><value>Business Select</value></picklistValues><picklistValues><active>true</active><defaultValue>false</defaultValue><label>Business Free</label><value>Business Free</value></picklistValues></picklistsForRecordType><recordTypeId>012000000000000AAA</recordTypeId></recordTypeMappings><recordTypeSelectorRequired>true</recordTypeSelectorRequired></result></describeLayoutResponse></soapenv:Body></soapenv:Envelope>';
       //Start <SA20170915>
    @testSetup
    public static void testSetupMethod(){
        List<MetaDataSettings__c> settingList = new List<MetaDataSettings__c>();
       settingList.add(new MetaDataSettings__c(name='Profile'));
        settingList.add(new MetaDataSettings__c(name='CustomTab'));
        settingList.add(new MetaDataSettings__c(name='PermissionSet'));
         settingList.add(new MetaDataSettings__c(name='ReportFolder'));
        settingList.add(new MetaDataSettings__c(name='ReportType'));
        settingList.add(new MetaDataSettings__c(name='DashboardFolder'));
        insert settingList;
    }
    //End <SA20170915>
    public static testMethod void test_RefreshMetadataSchedAndBatch() {
        //Database.executeBatch(new batchRefreshMetadataLayout(),1);
        //Start<SA20170915>
        List<Metadata__c> metadataList = new List<Metadata__c>();
        metadataList.add(new Metadata__c(name='Metadata__c', forceId__c = '01IS0000000DZ3iMAG', fullName__c = 'Metadata'));
        metadataList.add(new Metadata__c(name='Metadata__c', fullName__c = 'Metadata__c',type__c='SOBJECT'));
        metadataList.add(new Metadata__c(name='Metadata1__c', forceId__c = '01IS0000000DZ3iMAH', fullName__c = 'Metadata1__c',type__c='SOBJECT',isCustom__c = true));
        upsert metadataList Metadata__c.FullName__c;
        //End<SA20170915>
        Test.startTest();
        system.schedule('TestScheduleA','0 0 1 * * ?',new sched_RefreshMetadata());
        batchRefreshMetadata b = new batchRefreshMetadata('Metadata__c');
        Database.executeBatch(b,200);
        Test.stopTest();
    }

    
    public static testMethod void testRefreshMetadataLogicSchedAndBatch() {

        Test.startTest();
        system.schedule('TestScheduleA','0 0 1 * * ?',new sched_RefreshMetadataLogic());
        batchRefreshMetadataLogic b = new batchRefreshMetadataLogic();
        Database.executeBatch(b);
        Test.stopTest();
    }  
 
    static testMethod void testDeleteMetadataSchedAndBatch() {
        
        Account acc = new Account(name='Test Co');
        insert acc;
        
        Test.startTest();
//[01172017] Merge&Spin: Inserted metadata records and called Batch class from Metadata_UT test class.
        Metadata__c md = new Metadata__c(name='Metadata__c', fullName__c='Metadata__c');
       // <20170908:Shubham Agarwal> 
        insert md;
        //<20170908:Shubham Agarwal> : End 
        Database.executeBatch(new batchDeleteMetadata(),200);
        Database.executeBatch(new batchDeleteMetadata('Select Id,FullName__c,ForceId__c,IsDeleted__c from Metadata__c',true),200);
        system.schedule('TestScheduleA','0 0 0 15 3 ? 2022',new schedDeleteMetadata());
        system.schedule('TestScheduleB','0 0 1 * * ?',new schedDeleteMetadata('Select Id from Account'));
        Test.stopTest();
    }  
 //[01172017] Merge&Spin: updated test method to call parameters and method of ctrlMetadataConsole   
   public static testMethod void testMetadataConsole() {

        Test.startTest();
        
       Metadata__c md = new Metadata__c(name='Metadata__c', fullName__c='Metadata__c');
     // Metadata__c md= [select Id,ForceId__c,name,fullName__c from Metadata__c where name='Metadata__c' and fullName__c='Metadata__c']; 
        upsert md Metadata__c.FullName__c;
        
        PageReference pageRef = Page.MetadataConsole;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', md.id);        
        ctrlMetadataConsole ctrl = new ctrlMetadataConsole();
        ctrl.init();
        String sotherTypes = ctrl.OtherTypes;
        LIST<SelectOption> smtypeCategories = ctrl.mtypeCategories;
        LIST<SelectOption> ssObjects = ctrl.sObjects;
       ctrl.selectedCategory='Security';
        ctrl.RefreshDatabase();
        ctrl.RefreshLogic();
        ctrl.RefreshLayout();
        ctrl.refreshOtherTypes();
       Metadata.RefreshConfig('Account');
       Metadata.refreshSObjectMetaDatabase('Account');
       metadata.removeDeletedPicklists();
       metadata.getMetadataTriggers('Account');
       //new metadata().getlayoutFieldInfo(); 
        
        Test.stopTest();
    }  
  //[01172017] Merge&Spin: updated test method to increase code coverage for batchRefreshMetadataLayout class     
    public static testMethod void testMetadataConsole2() {

        Test.startTest();
        
        Metadata__c md = new Metadata__c(name='Metadata__c', fullName__c='Metadata__c');
     //   upsert md Metadata__c.FullName__c;
        
        PageReference pageRef = Page.MetadataConsole;
        Test.setCurrentPage(pageRef);    
        ctrlMetadataConsole ctrl = new ctrlMetadataConsole();
        ctrl.init();
        ctrl.RefreshLayout();
        Test.stopTest();
    }  
  
   public static testMethod void test_ctrlLayoutReport() {
    //  Account acc = new Account(name='Test Co');
      //  insert acc;
  //[01302017] Merge&Spin: Modified test method in order to increase code coverage for ctrlLayoutReport class
       Metadata__c mt = new Metadata__c(FullName__c='test1-test2', name = 'Name');
       insert mt;
        Test.startTest();
        PageReference pageRef = Page.LayoutReport;
        pageRef.getParameters().put('so', 'Metadata__c');
       pageRef.getParameters().put('rt', RType.getIdByDevName('Metadata__c','Master'));
       Test.setCurrentPage(pageRef);
       ctrlLayoutReport ctrl = new ctrlLayoutReport();
       ctrl.refresh();
       System.debug(ctrl.rtypeMapping); 
                ctrl.sObjectType='Metadata__c';
                system.debug(ctrl.recordTypes[1].getValue());
                ctrl.rtypeId = ctrl.recordTypes[1].getValue();
                Metadata.describeLayout dl = ctrl.layout;
                String layoutNameString = ctrl.layoutName;
                List<SelectOption> objectTypeList = ctrl.sObjectTypes;
                
                system.debug(dl.getRecordTypeMappings());
                system.debug(dl.getlayoutFieldInfo());
                system.debug(ctrl.layoutName);
                system.debug(ctrl.describe);
                system.debug(ctrl.items);
                 ctrlLayoutReport.LayoutResult lr = new ctrlLayoutReport.LayoutResult();
                String picklistValues = lr.picklistEntries;
       for(ctrlLayoutReport.LayoutResult i : ctrl.items){
           System.debug(i.picklistEntries);
           if(i.dfr!=null){
                System.debug(i.ReferenceTo);
                i.getType();    
           }
       }
                ctrl.refresh();
   Test.stopTest(); 
   }
     
        
   public static testMethod void testMetadataRefreshLogic() {
        Test.startTest();
        system.debug(Metadata.RefreshLogic());
        Test.stopTest();
    }   
    
   public static testMethod void testMetadataRefreshFileProperties() {

        LIST<Metadata.ListMetadataInstruction> mlis = metadata.buildListMetadataInstructions();
        Test.startTest();

        for (metadata.ListMetadataInstruction mli : mlis)
            system.debug(mli);
        system.debug(metadata.ListMetadata('CustomObject'));
        system.debug(metadata.ListMetadata('CustomField','Account'));
        Metadata.ProcessDeletedMetadataByInstruction(metadata.ListMetadata('FieldSet','Metadata__c'),new metadata.listMetadataInstruction('FieldSet','Metadata__c'));       
        Test.stopTest();
       
    }  
 //[01232017] Merge&Spin: Created test method for ctrlMetadataERD class   
    public static testMethod void testMetadataERD(){
        test.startTest();
        PageReference pg = Page.MetadataERD;
        pg.getParameters().put('sotyp','Metadata__c');
        test.setCurrentPage(pg);
        ctrlMetadataERD ctrl = new ctrlMetadataERD();
        ctrl.init();
        ctrl.getRelations();
        System.debug(ctrl.sObjects);
        system.debug(ctrl.dot);
        system.debug(ctrl.dotSize);
        string sobjType = ctrl.sotype;
        ctrl.sotype = sobjType;
        test.stopTest();
    }
 //[01232017] Merge&Spin: Created test method for ctrlMetdataExplorer class     
    public static testMethod void testMetdataExplorer(){
        List<String> mdList = new List<String>();
        Metadata__c md = new Metadata__c(name='Metadata__c', fullName__c='Metadata__c', Type__c = 'SOBJECT');
        upsert md Metadata__c.FullName__c;
        mdList.add(md.Id);
        test.startTest();
        PageReference pg = Page.MetadataExplorer;
        pg.getParameters().put('m',md.Id);
        test.setCurrentPage(pg);
        ctrlMetadataExplorer ctrl = new ctrlMetadataExplorer();
        ctrl.firstRun = false;
        ctrl.init();
        system.debug(ctrl.sObjects);
        ctrl.sObjectOnSelect();
        ctrl.createNode(md);    
        ctrl.createDataMap(mdList);
        test.stopTest();
    }
    
}