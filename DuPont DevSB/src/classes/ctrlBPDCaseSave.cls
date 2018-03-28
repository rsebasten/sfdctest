/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Pranitha S
Email: Pranitha_S@infosys.com
Description:  Controller class for page BPDCaseSave to check/uncheck the case events checkboxes,
to add contact roles and to check for various validations on required fields.
Change History: <Ankit20160719 10:19 PM IST> Included the new fields Sample Available and Infrigement Confirmed on TradeMarkAbuseCaseDetails object in the currentCaseDetail query for saving the values as per Issue IS ID-00071360 Code Coverage: 86% <AK 20160811 12:55 AM IST>
 *******************************************************************************/

public with sharing class ctrlBPDCaseSave {

 public Case currentCase{get;set;}
 public Case_Details__c currentCaseDetail{get;set;}
 public List<CaseContactRole> ContactRoles{get;set;}
 String currentCaseId{get;set;}
 public String imageURL{get; set;}
 public Document doc{get;set;} 
 public Attachment proofOfUse = new Attachment();
 public Transient  Blob bl {get; set;} 
 public String fileName {get; set;}
 public List<Attachment> allAttachments{get;set;}
 public List<Attachment> attachmentIdList{get;set;}
 public Attachment CD1= new Attachment();
 public Attachment CD2 = new Attachment();
 public Attachment CDHardcopy = new Attachment();
 public Attachment legal = new Attachment();
 public Attachment properuse = new Attachment();
 public Attachment response = new Attachment();
 public Attachment industry = new Attachment();
 public Attachment initialBudget= new Attachment();
 public Attachment additionalBudget= new Attachment();
 public Attachment investigationReport= new Attachment();
 public Attachment otherDocuments= new Attachment();
 public Attachment raidReports = new Attachment();
 public Attachment caseSchedule = new Attachment();
 public Attachment pleadings = new Attachment();
 public Attachment discovery = new Attachment();
 public Attachment motions = new Attachment();
 public Attachment settlement = new Attachment(); 
 public Attachment legalDoc = new Attachment();    
 public Attachment priviledgedDoc = new Attachment();  
 public Attachment judgementDoc = new Attachment();  
 public Attachment resolutionDoc = new Attachment();
 public Attachment bpClosureDoc = new Attachment();
 public Attachment TRO = new Attachment();
   
 public Transient  Blob CD1bl{get; set;}
 public String CD1fileName {get; set;}
 public List<Attachment> CD1IdList{get;set;}
 public Transient  Blob CD2bl{get; set;} 
 public String CD2fileName{get; set;}
 public List<Attachment> CD2IdList{get;set;}
 public Transient  Blob CDHardcopybl{get; set;} 
 public String CDHardcopyfileName{get; set;}
 public List<Attachment> CDHardcopyIdList{get;set;}
 public Transient  Blob legalbl{get; set;} 
 public String legalfileName{get; set;}
 public List<Attachment> legalIdList{get;set;}
 public Transient  Blob properusebl{get; set;} 
 public String properusefileName{get; set;}
 public List<Attachment> properuseIdList{get;set;}
 public Transient  Blob responsebl{get; set;} 
 public String responsefileName{get; set;}
 public List<Attachment> responseIdList{get;set;}
 public Transient  Blob industrybl{get; set;} 
 public String industryfileName{get; set;}
 public List<Attachment> industryIdList{get;set;}
 public List<Attachment> initialBudgetIdList{get;set;}
 public Transient  Blob initialBudgetbl{get; set;} 
 public String initialBudgetfileName{get; set;}
 public List<Attachment> additionalBudgetIdList{get;set;}
 public Transient  Blob additionalBudgetbl{get; set;} 
 public String additionalBudgetfileName{get; set;}
 public List<Attachment> investigationReportIdList{get;set;}
 public Transient  Blob investigationReportbl{get; set;} 
 public String investigationReportfileName{get; set;}
 public List<Attachment> otherDocumentsIdList{get;set;}
 public Transient  Blob otherDocumentsbl{get; set;} 
 public String otherDocumentsfileName{get; set;}
 public List<Attachment> raidReportIdList{get;set;}
 public Transient  Blob raidReportbl{get; set;} 
 public String raidReportfileName{get; set;}
 public Boolean flagvar{get;set;} 
 public List<Attachment> sampleAttachements{get;set;}
 public List<Trademark_Abuse_Sample__c> caseSamples{get;set;}
 public Boolean sampleAnalyzed{get;set;}
 public Boolean trapPurchaseAnalyzed{get;set;}
 public Boolean trapPurchaseMade{get;set;}
 public List<Attachment> caseScheduleIdList{get;set;}
 public Transient  Blob caseSchedulebl{get; set;} 
 public String caseSchedulefileName{get; set;}
 public List<Attachment> pleadingsIdList{get;set;}
 public Transient  Blob pleadingsbl{get; set;} 
 public String pleadingsfileName{get; set;}
 public List<Attachment> discoveryIdList{get;set;}
 public Transient  Blob discoverybl{get; set;} 
 public String discoveryfileName{get; set;}
 public List<Attachment> motionsIdList{get;set;}
 public Transient  Blob motionsbl{get; set;} 
 public String motionsfileName{get; set;}
 public List<Attachment> settlementIdList{get;set;}
 public Transient  Blob settlementbl{get; set;} 
 public String settlementfileName{get; set;}
 public List<Attachment> legalDocIdList{get;set;}
 public Transient  Blob legalDocbl{get; set;} 
 public String legalDocfileName{get; set;}
 public List<Attachment> priviledgedDocIdList{get;set;}
 public Transient  Blob priviledgedDocbl{get; set;} 
 public String priviledgedDocfileName{get; set;}
 public List<Attachment> judgementDocIdList{get;set;}
 public Transient  Blob judgementDocbl{get; set;} 
 public String judgementDocfileName{get; set;}
 public List<Attachment> resolutionDocIdList{get;set;}
 public Transient  Blob resolutionDocbl{get; set;} 
 public String resolutionDocfileName{get; set;}
 public List<Attachment> bpClosureDocIdList{get;set;}
 public Transient  Blob bpClosureDocbl{get; set;} 
 
 public List<Attachment> TROIdList{get;set;}
 public Transient  Blob TRObl{get; set;} 
 public String TROfileName{get; set;}
 
 public String bpClosureDocfileName{get; set;}
 public Boolean permissions{get;set;}
 public list<selectOption>options{get;set;}
 public String seizureBrand{get;set;}
 public String seizureVolume = '';
 public String raidVolume = '';
 public User userInformation{get;set;}
 public SelectOption[] SelectedMaterials { get; set; }  
 public SelectOption[] AllMaterials { get; set; }
 public LIST<BPD_Sample_Settings__c> brand{get; set;} 
 public String outsideCounsel{get;set;}
 public String customAuthority{get;set;}
 public String govAuthority{get;set;}
 public String counselInfo{get;set;}
 public String thirdParty{get;set;}
 public String investigator{get;set;}
 public Boolean check {get{
     if(check==null)
         check = false;
         return check;
     } set;}
 public String whoisString {get; set;}
  public ctrlBPDCaseSave (ApexPages.StandardController stdController) { 
  userInformation=[Select id,UserOwningSBUOrg__c from User where id = :Userinfo.getUserId()];
  flagvar = false;
  sampleAnalyzed = false;
  trapPurchaseAnalyzed = false;
  seizureBrand = 'None';
  imageURL='/servlet/servlet.FileDownload?file=';
      attachmentIdList = new List<Attachment>();
      CD1IdList = new List<Attachment>();
      CD2IdList = new List<Attachment>();
      CDHardcopyIdList = new List<Attachment>();
      legalIdList = new List<Attachment>();
      properuseIdList = new List<Attachment>();
      responseIdList = new List<Attachment>();
      industryIdList = new List<Attachment>();
      initialBudgetIdList = new List<Attachment>();
      additionalBudgetIdList = new List<Attachment>();
      otherDocumentsIdList= new List<Attachment>();
      investigationReportIdList = new List<Attachment>();
      raidReportIdList = new List<Attachment>();
      caseScheduleIdList = new List<Attachment>();
      pleadingsIdList = new List<Attachment>();
      discoveryIdList = new List<Attachment>();
      motionsIdList = new List<Attachment>();
      settlementIdList = new List<Attachment>();
      legalDocIdList = new List<Attachment>();
      priviledgedDocIdList = new List<Attachment>();
      judgementDocIdList = new List<Attachment>();
      resolutionDocIdList = new List<Attachment>();
      bpClosureDocIdList = new List<Attachment>();
      TROIdList = new List<Attachment>();
      
      outsideCounsel = '';
      govAuthority = '';
      counselInfo ='';
      customAuthority = '';
      investigator ='';
      thirdParty = '';
      ContactRoles = new List<CaseContactRole>();
      
      SelectedMaterials = new List<SelectOption>();
     AllMaterials= new List<SelectOption>();
      doc=[select name from Document where 
                                    Name='BPDAttachmentImage'];
   
    
      imageURL=imageURL+doc.id;
      
      
      List<PermissionSetAssignment> perSet = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
      for (PermissionSetAssignment ps: perSet)
        {
          if(ps.PermissionSet.Name.equals('Legal_Trademark_Counsel'))
          {
                permissions = true;
          }
        }
      currentCaseId = System.currentPageReference().getParameters().get('id');
      if(currentCaseId != NULL){
         currentCase = [SELECT Id,status,Brand__c,Subject,Description,product_selected__c
         FROM Case WHERE id=:currentCaseId];
         allAttachments = [Select Id,name From Attachment where ParentId = :currentCaseId];
          //<Ankit20160719 10:19 PM IST> Included the new fields Sample Available and Infrigement Confirmed on TradeMarkAbuseCaseDetails object in the currentCaseDetail query for saving the values as per Issue IS ID-00071360 Code Coverage: 86% <AK 20160811 12:55 AM IST>
         currentCaseDetail = [SELECT Id,Name,Case_Suspension_Date__c,Infringing_Product_Description__c,
      Infringement_Type__c,Response_Requested_by__c,DuPont_Attorney_Responsible__c,How_Trademark_is_Used__c,
      Record_Origination__c,CurrencyIsoCode,CreatedBy.name,CreatedBy.id,Legal_Recovery_Amount__c,Investigation_Proposal_Approval_Date__c,
      Web_site_screen_shot__c,Web_site_screen_shot_date__c,Investigation_Proposal_Submit_Date__c,
      Customs_Seizure_Port__c,Customs_Seizure_Date__c,Outside_Counsel_firm__c, 
      Company__c,DuPont_matter_Billing_Ref_No__c,Soft_Benefit_justification__c,Soft_Benefit_Amount_Date__c,Hard_Benefit_Amount_Date__c,Legal_Recovery_Amount_Date__c,
      Budget_Comments__c,Enforcement_Proposal_Approval_Date__c,Enforcement_Proposal_Submit_Date__c,Sample_Received__c,
      Enforcement_Action_initiated__c,Other_relevant_dates__c,Physical_visit_to_target__c,Criminal_Investigation__c,Investigation_Resolution__c,
      Raid_Action_Comments__c,Administrative_action_initiated__c,Civil_proceeding__c,Raid_Action_Volume__c,
      Criminal_proceeding__c,Discovery_period_started__c,Trial_initiated__c,TRO_Preliminary_Injunction__c,Raid_Action_Location__c,
      Next_Step__c,Hard_Benefit_Amount_USD__c,Hard_Benefit_Amount_Actual__c,Hard_Benefit_Currency__c,
      Soft_Benefit_Amount_USD__c,Soft_Benefit_Amount_Actual__c,Soft_Benefit_Currency__c,Legal_Recovery_Amount_USD__c,Crop_Phase_Status__c,
      Procedural_Status__c,Legal_Recovery_Currency__c,Case_Investigation_Open_Date__c,Counsel__c,Counsel_s_Ref_No__c,
      Enforcement_Action_Description__c,Agency_Tribunal__c,Official_Case_No__c,Answer_Due_Date__c,Discovery_Open_Date__c,Complaint_Filed_Date__c,Discovery_Close_Date__c,
      Summary_Judgment_Due_Date__c,Appeal__c,Sources_Revealed__c,Fine_Imposed__c,Domain_Name_Disposition__c,Settlement_Agreement__c,
      Undertaking_Received__c,Public_Apology__c,Court_Ruling__c,Damages_Monetary_Recovery__c,Arrests_Imprisonment__c,
      Manufacturing_equipment_destroyed__c,Infringing_Products_Destroyed__c,Priviledged_Raid_Action_Comments__c,Raid_Action_Date__c,
      Settlement_Agreement_Comments__c,Court_Ruling_Comments__c,Additional_Comments__c,Website_corrected__c,Website_image_s_removed__c,
      Website_taken_down__c,Type_of_Record__c,Related_Target_1__c,Related_Target_2__c,Related_Target_3__c,Individual_Name__c,
      Address__c,City__c,State__c,Zip_Postal_Code__c,Target_Country__c,Fax__c,Email__c,Website__c,Phone__c,Prior_relationship_with_DuPont__c,Other_Target_Information__c,Third_Party_Web_Crawlers__c,
      Customs_Seizure_Country__c,Internet_Evidence_Comments__c,Communication_Comments__c,Custom_Seizure_Comments__c,Investigation_Comments__c,Hard_Benefit_Justification__c,
      Legal_Recovery_Justification__c,Private_Investigation_Initiated_Date__c,BP_Closed_Soft_Benefit__c,License_Potential__c,
      Quantity_Unit_of_Measure__c,BPC_C_D_1_document__c,BPC_C_D_2_document__c,BPC_C_D_Hardcopy_document__c,Proof_of_Use_Document_Available__c,
      Legal_C_D_sent_document__c,Proper_use_document__c,Response_from_Infringer_document__c,Industry_Communication_Warning_document__c,
      Initial_Proposed_Budget_Form_document__c,Additional_Proposed_Budget_document__c,Investigation_Report_s_document__c,
      Other_documents__c,RaidReports_Images_and_Related_Documents__c,Case_Management_Schedule_document__c,Pleadings_Document__c,
      Discovery_document__c,Motions_Document__c,Copy_of_Settlement_Agreement_document__c,Other_documents_LegalEnforcementActions__c,
      Privileged_Raid_documents__c,Copy_of_Court_Ruling_Judgment_document__c,Additional_Documents__c,Brand__c,Owning_SBU__c,
      BP_Closure_Comments__c,BP_Closure_Confirmation_Sent__c,BP_Closure_No_Action_Required__c,Resolution_Recovery_Website_Screenshot__c,
      X2nd_Raid_Description_If_Applicable__c,WhoIs_Details__c,Registry_Admin_Details__c,Registry_Registrant_Details__c,Registry_Tech_Details__c,
      Custom_Seizure_Volume__c,Infringing_URL__c,Target_Region__c,Total_Classification_Points__c,Relative_Priority_Score__c,
      Recommended_Action__c,TRO_Preliminary_Injunction_Comments__c,Schedule_Comments__c,Pleadings_Comments__c,Discovery_Comments__c,
      Motions_Comments__c,Legacy_Data__c,Legacy_Case_Number__c,Legacy_Case_owner__c,Date_Opened__c,Facts_of_the_Case__c,BP_Close_Date__c,Infringement_Confirmed__c,Sample_Available__c FROM Case_Details__c WHERE Related_Case__c =:currentCase.id limit 1];
      
      ContactRoles = [SELECT Contact.Name, Role FROM  CaseContactRole WHERE CasesId =:currentCase.id];
        
         
         for (Attachment singleAttachment: allAttachments ) {
         if(singleAttachment.name.startsWith('POU-')){
         attachmentIdList.add(singleAttachment);
         currentCaseDetail.Proof_of_Use_Document_Available__c = 'Yes';
         }
         else if(singleAttachment.name.startsWith('CD1-')){
         CD1IdList.add(singleAttachment);
         currentCaseDetail.BPC_C_D_1_document__c= 'Yes';
         }
         else if(singleAttachment.name.startsWith('CD2-')){
         CD2IdList.add(singleAttachment);
         currentCaseDetail.BPC_C_D_2_document__c= 'Yes';
         }
        else if(singleAttachment.name.startsWith('CDH-')){
         CDHardcopyIdList.add(singleAttachment);
         currentCaseDetail.BPC_C_D_Hardcopy_document__c= 'Yes';
         }
        else if(singleAttachment.name.startsWith('LCD-')){
         legalIdList.add(singleAttachment);
         currentCaseDetail.Legal_C_D_sent_document__c= 'Yes';
         }
        else if(singleAttachment.name.startsWith('PU-')){
         properuseIdList.add(singleAttachment);
         currentCaseDetail.Proper_use_document__c= 'Yes';
         }
         else if(singleAttachment.name.startsWith('RI-')){
         responseIdList.add(singleAttachment);
         currentCaseDetail.Response_from_Infringer_document__c= 'Yes';
         }
        else if(singleAttachment.name.startsWith('IC-')){
         industryIdList.add(singleAttachment);
         currentCaseDetail.Industry_Communication_Warning_document__c= 'Yes';
         }
         else if(singleAttachment.name.startsWith('IB-')){
         initialBudgetIdList.add(singleAttachment);
         currentCaseDetail.Initial_Proposed_Budget_Form_document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('AB-')){
         additionalBudgetIdList.add(singleAttachment);
         currentCaseDetail.Additional_Proposed_Budget_document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('IR-')){
         investigationReportIdList.add(singleAttachment);
         currentCaseDetail.Investigation_Report_s_document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('OD-')){
         otherDocumentsIdList.add(singleAttachment);
         currentCaseDetail.Other_documents__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('RR-')){
         raidReportIdList.add(singleAttachment);
         currentCaseDetail.RaidReports_Images_and_Related_Documents__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('CMS-')){
         caseScheduleIdList.add(singleAttachment);
         currentCaseDetail.Case_Management_Schedule_document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('PL-')){
         pleadingsIdList.add(singleAttachment);
         currentCaseDetail.Pleadings_Document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('DIS-')){
         discoveryIdList.add(singleAttachment);
         currentCaseDetail.Discovery_document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('MOT-')){
         motionsIdList.add(singleAttachment);
         currentCaseDetail.Motions_Document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('SET-')){
         settlementIdList.add(singleAttachment);
         currentCaseDetail.Copy_of_Settlement_Agreement_document__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('LD-')){
         legalDocIdList.add(singleAttachment);
         currentCaseDetail.Other_documents_LegalEnforcementActions__c= 'Yes';
         }
        else  if(singleAttachment.name.startsWith('PR-')){
         priviledgedDocIdList.add(singleAttachment);
         currentCaseDetail.Privileged_Raid_documents__c= 'Yes';
         }
         else  if(singleAttachment.name.startsWith('JUD-')){
         judgementDocIdList.add(singleAttachment);
         currentCaseDetail.Copy_of_Court_Ruling_Judgment_document__c= 'Yes';
         }
         else  if(singleAttachment.name.startsWith('RES-')){
         resolutionDocIdList.add(singleAttachment);
         currentCaseDetail.Additional_Documents__c= 'Yes';
         }
         else  if(singleAttachment.name.startsWith('BP-')){
         bpClosureDocIdList.add(singleAttachment);
         currentCaseDetail.BP_Closure_Confirmation_Sent__c= 'Yes';
         }
         else  if(singleAttachment.name.startsWith('TRO-')){
         TROIdList.add(singleAttachment);
         currentCaseDetail.TRO_Preliminary_Injunction__c= 'Yes';
         }
         
         }
         
         for (CaseContactRole contactrole : ContactRoles) {
         if(contactrole.Role == 'Customs Authority'){
         customAuthority += contactrole.Contact.Name + '; ';
           }
          else if(contactrole.Role == 'Customs Seizure Outside Counsel'){
         outsideCounsel += contactrole.Contact.Name + '; ';
           }
           else if(contactrole.Role == 'Government Authority Contact'){
         govAuthority += contactrole.Contact.Name + '; ';
           }
           else if(contactrole.Role == 'Enforcement Action Outside Counsel'){
         counselInfo += contactrole.Contact.Name + '; ';
           }
           else if(contactrole.Role == 'Investigator'){
         investigator += contactrole.Contact.Name + '; ';
           }
           else if(contactrole.Role == 'Third Party Contact(s)'){
         thirdParty += contactrole.Contact.Name + '; ';
           }
         }
         
         options=new list<selectoption>(); 
         Schema.DescribeFieldResult fieldResult = Case.Brand__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple)
        {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
      }
      
      
      
      currentCase.Brand__c = 'None';
      currentCaseDetail.Quantity_Unit_of_Measure__c = '';
       
       caseSamples = [Select Id,Sample_Technical_Analysis__c,Trap_Purchase_Technical_Analysis__c From Trademark_Abuse_Sample__c
       where Case__c = :currentCase.id];
       
      if(currentCaseDetail.Raid_Action_Volume__c != null){
       raidVolume = currentCaseDetail.Raid_Action_Volume__c;
       }
       if(currentCaseDetail.Custom_Seizure_Volume__c!= null){
      seizureVolume = currentCaseDetail.Custom_Seizure_Volume__c;
       }
         
         
         
       if(caseSamples != null ){
       for (Trademark_Abuse_Sample__c sample : caseSamples ) {
         if(sample.Sample_Technical_Analysis__c != null){
         sampleAnalyzed = true;
         break;
         }
       }
         for (Trademark_Abuse_Sample__c sample : caseSamples ) {
         if(sample.Trap_Purchase_Technical_Analysis__c != null){
         trapPurchaseAnalyzed = true;
         break;
         }
       }
       for (Trademark_Abuse_Sample__c sample : caseSamples ) {
         sampleAttachements = [Select Id,name From Attachment where ParentId = :sample .id];
         for(Attachment  sampleAttachment :sampleAttachements){
         if(sampleAttachment.name.startsWith('TP-') ){
           trapPurchaseMade = true;
           break;         
         }
        }
         if(trapPurchaseMade == true)
         {
         break;
         }
       } 
      
       
     } 
     
      
   }
   
   public void uploadAttachment(Attachment attachement, String AttachmentName, Blob attachmentBody ){
        attachement.OwnerId = UserInfo.getUserId();
        attachement.ParentId = currentCase.Id;
        attachement.Name = AttachmentName;
        attachement.Body = attachmentBody ;
        try {
       
            insert attachement;     
            attachement.Body = null;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
        } 
   }
   
 public PageReference  savingCase(){
        
        if(bl !=null) {
        uploadAttachment(proofOfUse,'POU-'+ fileName,bl);
        currentCaseDetail.Proof_of_Use_Document_Available__c = 'Yes';
        }

        if(CD1bl !=null) {
        uploadAttachment(CD1,'CD1-'+ CD1fileName,CD1bl);
        currentCaseDetail.BPC_C_D_1_document__c = 'Yes';
        }
        
        if(CD2bl !=null) {
        uploadAttachment(CD2,'CD2-'+ CD2fileName,CD2bl);
        currentCaseDetail.BPC_C_D_2_document__c= 'Yes';
        }
        
        if(CDHardcopybl !=null) {
        uploadAttachment(CDHardcopy,'CDH-'+ CDHardcopyfileName,CDHardcopybl);
        currentCaseDetail.BPC_C_D_Hardcopy_document__c= 'Yes';
        }
        
        if(legalbl !=null) {
        uploadAttachment(legal,'LCD-'+ legalfileName,legalbl);
        currentCaseDetail.Legal_C_D_sent_document__c= 'Yes';
        }
        
        if(properusebl !=null) {
        uploadAttachment(properuse,'PU-'+ properusefileName,properusebl);
        currentCaseDetail.Proper_use_document__c= 'Yes';
        }
        
        if(responsebl!=null) {
        uploadAttachment(response,'RI-'+ responsefileName,responsebl);
        currentCaseDetail.Response_from_Infringer_document__c= 'Yes';
        }
        
        if(industrybl !=null) {
        uploadAttachment(industry,'IC-'+ industryfileName,industrybl);
        currentCaseDetail.Industry_Communication_Warning_document__c= 'Yes';
        }   

        update currentCaseDetail;
        update currentCase;
        flagvar = true;
     return null;
      }
      
 public PageReference savingCaseDetail(){
        
        system.debug('status value'+currentCaseDetail.Procedural_Status__c);
        if((currentCaseDetail.Procedural_Status__c == 'Brand Protection - Closed' || currentCaseDetail.Procedural_Status__c == 'Legal - In Progress'
         || currentCaseDetail.Procedural_Status__c == 'Legal - Suspension'
        || currentCaseDetail.Procedural_Status__c == 'Legal - Closed') && (currentCaseDetail.BP_Close_Date__c == null) ){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter BP Close Date in section GENERAL INFORMATION')); 
          return null;
        }
        //<Satish 20151106> Modified the condition for Bp closed validation rule
        else if(currentCaseDetail.Date_Opened__c > currentCaseDetail.BP_Close_Date__c)
        {
        //<Satish 20151014> Created the validation rule for date check.
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'BP Close Date should be greater than Date Opened in GENERAL INFORMATION section')); 
        //currentCaseDetail.BP_Close_Date__c.addError('BP Close Date should be greater than Date Opened in GENERAL INFORMATION section');
        return null;
        
        }
        else{
        update currentCaseDetail;
        flagvar = true;
        return null;
        }
      }
      
     public PageReference saveInternetEvidence(){
        if(currentCaseDetail.Infringing_URL__c == null || currentCaseDetail.Third_Party_Web_Crawlers__c == null || currentCaseDetail.Web_site_screen_shot__c == null ){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Required Information in section INTERNET EVIDENCE')); 
          return null;
        }
        else{
     update currentCaseDetail;
     flagvar = true;
     return null;
     }
     }
     
    public PageReference saveCustomsSeizure(){
        if(currentCaseDetail.Customs_Seizure_Date__c == null || currentCaseDetail.Sample_Received__c == null || (String.isEmpty(currentCaseDetail.Custom_Seizure_Volume__c) && seizureBrand == 'None' && currentCaseDetail.Quantity_Unit_of_Measure__c == '')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Required Information in section CUSTOMS SEIZURE')); 
            return null;
        }
        else{
            if(seizureBrand != 'None' && currentCaseDetail.Quantity_Unit_of_Measure__c != ''){
                seizureVolume+= seizureBrand+'-'+ currentCaseDetail.Quantity_Unit_of_Measure__c+';';
                currentCaseDetail.Custom_Seizure_Volume__c=seizureVolume;
            } 
            update currentCaseDetail;     
            flagvar = true;
            return null;
        }
    }
      
      public PageReference saveBudget(){
      if(String.isEmpty(currentCaseDetail.DuPont_matter_Billing_Ref_No__c)){
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Required Information in section BUDGET / TIMELINES')); 
      return null;
      }
      else{
      if(initialBudgetbl!=null) {
      uploadAttachment(initialBudget,'IB-'+ initialBudgetfileName,initialBudgetbl);
      currentCaseDetail.Initial_Proposed_Budget_Form_document__c = 'Yes';
        }
        
        if(additionalBudgetbl!=null) {
        uploadAttachment(additionalBudget,'AB-'+ additionalBudgetfileName,additionalBudgetbl);
        currentCaseDetail.Additional_Proposed_Budget_document__c= 'Yes';
        }
     update currentCaseDetail;
     flagvar = true;
     return null;
     }
     
     }
     
     public PageReference saveInvestigationEvidence(){

      if(investigationReportbl!=null) {
      uploadAttachment(investigationReport,'IR-'+ investigationReportfileName,investigationReportbl);
      currentCaseDetail.Investigation_Report_s_document__c = 'Yes';
        }
        if(otherDocumentsbl!=null) {
        uploadAttachment(otherDocuments,'OD-'+ otherDocumentsfileName,otherDocumentsbl);
        currentCaseDetail.Other_documents__c = 'Yes';
        }
     update currentCaseDetail;
     flagvar = true;
     return null;
     }
     
     public PageReference saveRaidAction(){
     if(currentCaseDetail.Raid_Action_Date__c == null || (String.isEmpty(currentCaseDetail.Raid_Action_Volume__c) && currentCase.Brand__c == 'None' && currentCaseDetail.Quantity_Unit_of_Measure__c == '')) {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Required Information in section RAID ACTION')); 
          return null;
        }
        else{
        if(currentCase.Brand__c != 'None' && currentCaseDetail.Quantity_Unit_of_Measure__c != ''){
        raidVolume+= currentCase.Brand__c+'-'+ currentCaseDetail.Quantity_Unit_of_Measure__c+';';
        currentCaseDetail.Raid_Action_Volume__c=raidVolume;
        }  
      if(raidReportbl!=null) {
      uploadAttachment(raidReports,'RR-'+ raidReportfileName,raidReportbl);
      currentCaseDetail.RaidReports_Images_and_Related_Documents__c = 'Yes';
        }
        update currentCaseDetail;
     flagvar = true;
     return null;
     }
     }
     
     
     public PageReference saveLegal(){
     if(String.isEmpty(currentCaseDetail.Counsel__c) || String.isEmpty(currentCaseDetail.Enforcement_Action_Description__c)) {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Required Information in section LEGAL/ENFORCEMENT ACTIONS')); 
          return null;
        }
        else{
        
      if(caseSchedulebl!=null) {
      uploadAttachment(caseSchedule,'CMS-'+ caseSchedulefileName,caseSchedulebl);
      currentCaseDetail.Case_Management_Schedule_document__c= 'Yes';
        }
        if(pleadingsbl!=null) {
        uploadAttachment(pleadings,'PL-'+ pleadingsfileName,pleadingsbl);
        currentCaseDetail.Pleadings_Document__c= 'Yes';
        }
        if(discoverybl!=null) {
        uploadAttachment(discovery,'DIS-'+ discoveryfileName,discoverybl);
        currentCaseDetail.Discovery_document__c = 'Yes';
        }
        if(motionsbl!=null) {
        uploadAttachment(motions,'MOT-'+ motionsfileName,motionsbl);
        currentCaseDetail.Motions_Document__c= 'Yes';
        }  
        if(legalDocbl!=null) {
        uploadAttachment(legalDoc,'LD-'+ legalDocfileName,legalDocbl);
        currentCaseDetail.Other_documents_LegalEnforcementActions__c= 'Yes';
        }
        if(priviledgedDocbl!=null) {
        uploadAttachment(priviledgedDoc,'PR-'+ priviledgedDocfileName,priviledgedDocbl);
        currentCaseDetail.Privileged_Raid_documents__c= 'Yes';
        } 
        if(TRObl!=null) {
        uploadAttachment(TRO,'TRO-'+ TROfileName,TRObl);
        currentCaseDetail.TRO_Preliminary_Injunction__c= 'Yes';
        } 
       
        update currentCaseDetail;
     flagvar = true;
     return null;
     }
     }
     
     public PageReference saveResolution(){
     if(settlementbl!=null) {
        uploadAttachment(settlement,'SET-'+ settlementfileName,settlementbl);
        currentCaseDetail.Copy_of_Settlement_Agreement_document__c= 'Yes';
        }
        if(judgementDocbl!=null) {
        uploadAttachment(judgementDoc,'JUD-'+ judgementDocfileName,judgementDocbl);
        currentCaseDetail.Copy_of_Court_Ruling_Judgment_document__c= 'Yes';
        }
        if(resolutionDocbl!=null) {
        uploadAttachment(resolutionDoc,'RES-'+ resolutionDocfileName,resolutionDocbl);
        currentCaseDetail.Additional_Documents__c= 'Yes';
        }
        if(bpClosureDocbl!=null) {
        uploadAttachment(bpClosureDoc,'BP-'+ bpClosureDocfileName,bpClosureDocbl);
        currentCaseDetail.BP_Closure_Confirmation_Sent__c= 'Yes';
        }
        update currentCaseDetail;
     flagvar = true;
     return null;
     }
    
     public PageReference saveTarget(){
     if(String.isEmpty(currentCaseDetail.Company__c)) {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Required Information in section TARGET INFORMATION')); 
         return null;
       }
        else{
     update currentCaseDetail;
     flagvar = true;
     return null;
     }
     }
     
     public PageReference saveFinance(){

         //<Vaishnavi11192015>start  
         if((currentCaseDetail.Legal_Recovery_Amount__c!= null  && currentCaseDetail.Legal_Recovery_Amount_USD__c == null) && currentCaseDetail.Legal_Recovery_Currency__c== null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Amount (USD),Legal Recovery Currency in section FINANCIAL INFORMATION')); 
             return null;
         }
         if((currentCaseDetail.Soft_Benefit_Amount_Actual__c!= null  && currentCaseDetail.Soft_Benefit_Amount_USD__c == null) && currentCaseDetail.Soft_Benefit_Currency__c== null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Amount (USD),Soft Benefit Currency in section FINANCIAL INFORMATION')); 
             return null;
         }
         if((currentCaseDetail.Hard_Benefit_Amount_Actual__c!= null  && currentCaseDetail.Hard_Benefit_Amount_USD__c == null) && currentCaseDetail.Hard_Benefit_Currency__c== null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Amount (USD),Hard Benefit Currency in section FINANCIAL INFORMATION')); 
             return null;
         }
         //<Vaishnavi11192015>end
         //<Vaishnavi11182015>start   
         if(currentCaseDetail.Soft_Benefit_Amount_USD__c!= null  && currentCaseDetail.Soft_Benefit_Amount_Date__c== null)     
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Amount Date in section FINANCIAL INFORMATION')); 
             return null;
         }
         
         if(currentCaseDetail.Hard_Benefit_Amount_USD__c!= null  && currentCaseDetail.Hard_Benefit_Amount_Date__c== null)    
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Amount Date in section FINANCIAL INFORMATION')); 
             return null;
         }
         if(currentCaseDetail.Legal_Recovery_Amount_USD__c!= null  && currentCaseDetail.Legal_Recovery_Amount_Date__c== null)    
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Amount Date in section FINANCIAL INFORMATION')); 
             return null;
         }
         //<vaishnavi11182015>end
         //<vaishnavi11242015>start
                  if(currentCaseDetail.Hard_Benefit_Amount_Actual__c!=null  && currentCaseDetail.Hard_Benefit_Amount_Date__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Amount Date in section FINANCIAL INFORMATION')); 
             return null;
         }
         if(currentCaseDetail.Hard_Benefit_Amount_Actual__c!=null  && currentCaseDetail.Hard_Benefit_Currency__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Currency in section FINANCIAL INFORMATION')); 
             return null;
         }
         if(currentCaseDetail.Soft_Benefit_Amount_Actual__c!=null  && currentCaseDetail.Soft_Benefit_Amount_Date__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Amount Date in section FINANCIAL INFORMATION')); 
             return null;
         }
         if(currentCaseDetail.Soft_Benefit_Amount_Actual__c!=null  &&  currentCaseDetail.Soft_Benefit_Currency__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Currency in section FINANCIAL INFORMATION')); 
             return null;
         }
         if(currentCaseDetail.Legal_Recovery_Amount__c!=null  && currentCaseDetail.Legal_Recovery_Amount_Date__c==null )
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Amount Date in section FINANCIAL INFORMATION')); 
             return null;
         }
         if(currentCaseDetail.Legal_Recovery_Amount__c!=null  && currentCaseDetail.Legal_Recovery_Currency__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Currency in section FINANCIAL INFORMATION')); 
             return null;
         }
         if( (currentCaseDetail.Hard_Benefit_Amount_Actual__c!=null ||currentCaseDetail.Hard_Benefit_Amount_USD__c!=null) && (currentCaseDetail.Hard_Benefit_Justification__c==null))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Justification in section FINANCIAL INFORMATION')); 
             return null;
         } 
         if( (currentCaseDetail.Hard_Benefit_Amount_Actual__c!=null ||currentCaseDetail.Hard_Benefit_Amount_USD__c!=null) && (currentCaseDetail.Hard_Benefit_Amount_Date__c==null))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Amount Date  in section FINANCIAL INFORMATION')); 
             return null;
         } 
         if( (currentCaseDetail.Soft_Benefit_Amount_Actual__c!=null ||currentCaseDetail.Soft_Benefit_Amount_USD__c!=null) && (currentCaseDetail.Soft_Benefit_Justification__c==null))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Justification in section FINANCIAL INFORMATION')); 
             return null;
         } 
         if( (currentCaseDetail.Soft_Benefit_Amount_Actual__c!=null ||currentCaseDetail.Soft_Benefit_Amount_USD__c!=null) && (currentCaseDetail.Soft_Benefit_Amount_Date__c==null))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Amount Date  in section FINANCIAL INFORMATION')); 
             return null;
         } 
         if( (currentCaseDetail.Legal_Recovery_Amount__c!=null ||currentCaseDetail.Legal_Recovery_Amount_USD__c!=null) && (currentCaseDetail.Legal_Recovery_Justification__c==null))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Justification in section FINANCIAL INFORMATION')); 
             return null;
         } 
         if( (currentCaseDetail.Legal_Recovery_Amount__c!=null ||currentCaseDetail.Legal_Recovery_Amount_USD__c!=null) && (currentCaseDetail.Legal_Recovery_Amount_Date__c==null))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Amount Date  in section FINANCIAL INFORMATION')); 
             return null;
         } 
         //<vaishnavi11242015>end    
         if((currentCaseDetail.Hard_Benefit_Amount_Actual__c != null  || currentCaseDetail.Hard_Benefit_Amount_USD__c != null) && String.isEmpty(currentCaseDetail.Hard_Benefit_Justification__c ))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Justification in section FINANCIAL INFORMATION')); 
             return null;
         }
         if((currentCaseDetail.Soft_Benefit_Amount_Actual__c != null  || currentCaseDetail.Soft_Benefit_Amount_USD__c != null) && String.isEmpty(currentCaseDetail.Soft_Benefit_justification__c))
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Justification in section FINANCIAL INFORMATION')); 
             return null;
         }
         if((currentCaseDetail.Hard_Benefit_Amount_Actual__c != null  && currentCaseDetail.Hard_Benefit_Currency__c != null) && currentCaseDetail.Hard_Benefit_Amount_USD__c == null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Hard Benefit Amount (USD) in section FINANCIAL INFORMATION')); 
             return null;
         }
         if((currentCaseDetail.Soft_Benefit_Amount_Actual__c!= null  && currentCaseDetail.Soft_Benefit_Currency__c!= null) && currentCaseDetail.Soft_Benefit_Amount_USD__c== null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Soft Benefit Amount (USD) in section FINANCIAL INFORMATION')); 
             return null;
         }
         if((currentCaseDetail.Legal_Recovery_Amount__c!= null  && currentCaseDetail.Legal_Recovery_Currency__c!= null) && currentCaseDetail.Legal_Recovery_Amount_USD__c== null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Legal Recovery Amount (USD) in section FINANCIAL INFORMATION')); 
             return null;
         }
         else{
             update currentCaseDetail;
             flagvar = true;
             return null;
         }
     }
   
}