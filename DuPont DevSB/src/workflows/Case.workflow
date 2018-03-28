<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BI_EMEA_Complaint_Handling_Service_Center_Update</fullName>
        <description>BI EMEA Complaint Handling - Service Center Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>Case Agent</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI_EMEA_Complaint_Handling/BI_EMEA_Complaint_Handling_Service_Center_Update</template>
    </alerts>
    <alerts>
        <fullName>BI_EMEA_email_confirmation_on_registration_of_complaint</fullName>
        <description>BI EMEA  email confirmation on registration of complaint</description>
        <protected>false</protected>
        <recipients>
            <field>Alt_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>bi-warranty@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI/BI_EMEA_Complaint_Handling_VF_template</template>
    </alerts>
    <alerts>
        <fullName>BI_NA_Env_Notification_to_Owner</fullName>
        <description>BI-NA Env Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Case_Investigator_Email</template>
    </alerts>
    <alerts>
        <fullName>BI_NA_Surf_Notification_to_Owner</fullName>
        <description>BI-NA Surf Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Alt_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Case_Investigator_Email</template>
    </alerts>
    <alerts>
        <fullName>Brand_Protection_Web_to_Case_Alert</fullName>
        <description>Brand Protection Web to Case Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BPD_Email_Templates/BPD</template>
    </alerts>
    <alerts>
        <fullName>CS_CaseCreationNotificationforInternalRequest</fullName>
        <description>Case Creation Notification for Internal Request</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice.reply@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_EmailTemplates/CS_Case_Creation_Internal_Request</template>
    </alerts>
    <alerts>
        <fullName>CS_CaseCreationNotificationforOrdersServiceRequests</fullName>
        <description>Case Creation Notification for Orders/Service Requests</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice.reply@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CS_EmailTemplates/CS_Case_Creation_Order_SR</template>
    </alerts>
    <alerts>
        <fullName>CS_mail_Notification_on_Reply_Received</fullName>
        <description>CS_mail_Notification_on_Reply_Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CS_EmailTemplates/CS_mail_Notification_on_Reply_Received</template>
    </alerts>
    <alerts>
        <fullName>DPT_Case_Approval</fullName>
        <description>DPT Case Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_Case_Email_Templates/DPT_Case_Approval</template>
    </alerts>
    <alerts>
        <fullName>DPT_Case_Rejection</fullName>
        <description>DPT Case Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_Case_Email_Templates/DPT_Case_Rejection</template>
    </alerts>
    <alerts>
        <fullName>DPT_Effectiveness_Followup</fullName>
        <description>DPT Effectiveness Followup</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_Case_Email_Templates/Case_Effectiveness_FollowUp</template>
    </alerts>
    <alerts>
        <fullName>DPT_converter_approval_email_for_resolution_proposal</fullName>
        <description>DPT converter approval email for resolution proposal</description>
        <protected>false</protected>
        <recipients>
            <recipient>Investigator</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_Case_Email_Templates/DPT_AP_converter_fully_approved</template>
    </alerts>
    <alerts>
        <fullName>DPT_converter_reject_email_for_resolution_proposal</fullName>
        <description>DPT converter reject email for resolution proposal</description>
        <protected>false</protected>
        <recipients>
            <recipient>Investigator</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_Case_Email_Templates/DPT_AP_converter_resolution_proposal_is_rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_Template_Sent_to_Owner_when_Case_Record_is_recalled</fullName>
        <description>Email Template Sent to Owner when Case Record is recalled</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_EMEA_Templates_4_other_SBU_s/BI_EMEA_CH_Approval_Recalled_EN</template>
    </alerts>
    <alerts>
        <fullName>Email_Template_Sent_to_Submitter_after_the_Case_has_been_approved</fullName>
        <description>Email Template Sent to Submitter after the Case has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_EMEA_Complaint_Handling/BI_EMEA_CH_Approval_Accepted_EN_2</template>
    </alerts>
    <alerts>
        <fullName>Email_Template_Sent_to_Submitter_after_the_Case_has_been_rejected</fullName>
        <description>Email Template Sent to Submitter after the Case has been rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_EMEA_Templates_4_other_SBU_s/BI_EMEA_CH_Approval_Rejected_EN1</template>
    </alerts>
    <alerts>
        <fullName>Send_BI_EMEA_VF_Email_Template</fullName>
        <description>Send BI EMEA VF Email Template</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_EMEA_Complaint_Handling/Task_Email_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Approved</fullName>
        <description>Case Record - Approval Stage = Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Recalled</fullName>
        <description>Case Record Has been recalled</description>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Approval Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Rejected</fullName>
        <description>Approval Stage = Rejected when Case Record is rejected</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Submitted</fullName>
        <description>Case Record is submitted for approval</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Approval Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Not_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Approval Status to Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_DPT_Aramids_Case_Queue</fullName>
        <description>Assign to DPT Aramids Case Queue</description>
        <field>OwnerId</field>
        <lookupValue>DPT_Aramids_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to DPT Aramids Case Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_DPT_Garments_Case_Queue</fullName>
        <description>Assign to DPT Garments Case Queue</description>
        <field>OwnerId</field>
        <lookupValue>DPT_Garments_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to DPT Garments Case Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_DPT_Nonwovens_Case_Queue</fullName>
        <description>Assign to DPT Nonwovens Case Queue</description>
        <field>OwnerId</field>
        <lookupValue>DPT_Nonwovens_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to DPT Nonwovens Case Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Autopouplate_current_date_in_Close_Date</fullName>
        <description>Update Close Date field with today&apos;s date.</description>
        <field>Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>Autopouplate current date in Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BI_NA_Env_Update_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>laura.m.dwyer@dupont.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>BI NA Env Update Case Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BI_NA_Surface_Show_Detail</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BI_NA_Surfaces_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BI NA Surface Show Detail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_Change_to_New_Queue_Order</fullName>
        <field>OwnerId</field>
        <lookupValue>CS_Order</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CS_Change_to_New_Queue_Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_Change_to_New_Queue_SR</fullName>
        <field>OwnerId</field>
        <lookupValue>CS_ServiceRequest</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CS_Change_to_New_Queue_SR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_StatusUpdateFieldUpdate</fullName>
        <description>This Workflow action will update the status field to In progress.Created as a part of PMO req.113.</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>CS_StatusUpdateFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpadateDivisionDescription</fullName>
        <description>This Field Update will update Case&apos;s Division Description as per associated Account&apos;s Division Description value.</description>
        <field>ERP_DivisionDescription__c</field>
        <formula>Account.ERP_DivisionDescription__c</formula>
        <name>CS_UpadateDivisionDescription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateCustomerGroup2</fullName>
        <description>To update Customer group2 on Case from Accounts</description>
        <field>Customer_Group_2__c</field>
        <formula>Account.ERP_CustomerGroup2__c</formula>
        <name>CS_UpdateCustomerGroup2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateCustomerServiceCenter</fullName>
        <description>This Field Update will update Case&apos;s Customer Service Center as per associated Account&apos;s Customer Service Center value.</description>
        <field>CustomerServiceCenter__c</field>
        <formula>Account.ERP_CustomerServiceCenter__c</formula>
        <name>CS_UpdateCustomerServiceCenter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateDistChannelCode</fullName>
        <description>This Field Update will update Case&apos;s District Code as per associated Account&apos;s District Code value.</description>
        <field>ERP_DistChannelCode__c</field>
        <formula>Account.ERP_DistChannelCode__c</formula>
        <name>CS_UpdateDistChannelCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateDistChannelDescription</fullName>
        <description>This Field Update will update Case&apos;s Dist Channel Description as per associated Account&apos;s Dist Channel Description  value.</description>
        <field>ERP_DistChannelDescription__c</field>
        <formula>Account.ERP_DistChannelDescription__c</formula>
        <name>CS_UpdateDistChannelDescription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateDivisionCode</fullName>
        <description>This Field Update will update Case&apos;s Division Code as per associated Account&apos;s Division Code value.</description>
        <field>ERP_DivisionCode__c</field>
        <formula>Account.ERP_DivisionCode__c</formula>
        <name>CS_UpdateDivisionCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateERPAccountCode</fullName>
        <description>This field update will update  Case ERP Account Code field as per related Account &apos;ERP Account Code &apos;Field</description>
        <field>ERP_Account_Code__c</field>
        <formula>Account.ERP_Account_Code__c</formula>
        <name>CS_UpdateERPAccountCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateIRCaseRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CS_InternalRequest</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CS_UpdateIRCaseRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateOrderCaseRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CS_Order</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CS_UpdateOrderCaseRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateSRCaseRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CS_ServiceRequest</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CS_UpdateSRCaseRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateSalesOrgCode</fullName>
        <description>This Field Update will update the Sales Org Code of Case object as per the associated account&apos;s Sales Org Code Field Value.</description>
        <field>ERP_SalesOrgCode__c</field>
        <formula>Account.ERP_SalesOrgCode__c</formula>
        <name>CS_UpdateSalesOrgCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateSalesOrgDescription</fullName>
        <description>This Field Update will update Case&apos;s Sales Org Description as per associated Account&apos;s Sales Org. Description</description>
        <field>ERP_SalesOrgDescription__c</field>
        <formula>Account.ERP_SalesOrgDescription__c</formula>
        <name>CS_UpdateSalesOrgDescription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_UpdateYKPartnerCode</fullName>
        <description>This Field update will update the Case YK Partner Code Field Value Based on Related Account.</description>
        <field>ERP_YKPartnerCode__c</field>
        <formula>Account.ERP_YKPartnerCode__c</formula>
        <name>CS_UpdateYKPartnerCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_UpdateApprovalStatus</fullName>
        <description>Update Case.Approval Status to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update &lt;Approval Status&gt;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_UpdateApprovalStatus_Recalled</fullName>
        <description>Update Case.Approval Status to Recalled</description>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Update Approval Status to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_UpdateResolvedDate</fullName>
        <description>Update Case.Resolved_Date__c</description>
        <field>Resolved_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Resolved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>BI_EMEA_Complaints</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_RecordType_BI_NA_Surfaces_freeze</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BI_NA_Surfaces_Case_freeze</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RecordType BI-NA Surfaces freeze</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type</fullName>
        <description>Change Record Type to DPT Global Complaint Case – Investigate</description>
        <field>RecordTypeId</field>
        <lookupValue>DPT_Global_Complaint_Investigate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_DPT_Investigate</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DPT_Global_Complaint_Investigate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to DPT Investigate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_DPT_Resolved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DPT_Global_Complaint_Resolve</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to DPT Resolved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Investigate</fullName>
        <description>Change Status to Investigate</description>
        <field>Status</field>
        <literalValue>Investigate</literalValue>
        <name>Change Status to Investigate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Resolve</fullName>
        <field>Status</field>
        <literalValue>Resolve</literalValue>
        <name>Change Status to Resolve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cost_Updated</fullName>
        <field>TotalActualCost__c</field>
        <formula>IF(ISPICKVAL( Activity_Type__c , &quot;Inspection&quot;),150, 
IF(ISPICKVAL( Activity_Type__c , &quot;Repair Type 1&quot;),575, 
IF(ISPICKVAL( Activity_Type__c , &quot;Repair Type 2&quot;),650, 
TotalActualCost__c )))</formula>
        <name>Cost Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Approval_status_Recalled</fullName>
        <description>Credit Approval status Recalled</description>
        <field>Credit_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Credit Approval status Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Cost_Updation1</fullName>
        <field>Total_Cost__c</field>
        <formula>TotalActualCost__c + Case_Material_Cost__c</formula>
        <name>Total Cost Updation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_Investigate</fullName>
        <field>Status</field>
        <literalValue>Investigate</literalValue>
        <name>Update Case Status - Investigate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_DPT_IPP_NA_General_Inqui</fullName>
        <field>OwnerId</field>
        <lookupValue>DPT_IPP_NA_General_Inquiry_Managers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to DPT-IPP NA General Inqui</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>BI Case Close Date Autofill</fullName>
        <actions>
            <name>Autopouplate_current_date_in_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Close</value>
        </criteriaItems>
        <description>The close date (current date) to automatically populate when you click on Save &amp; Close button, Status changes automatically to Close. (IS ID-00071635)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI EMEA Complaint Handling</fullName>
        <actions>
            <name>BI_EMEA_email_confirmation_on_registration_of_complaint</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Change_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BI EMEA Complaint Handling - Service Center Update</fullName>
        <actions>
            <name>BI_EMEA_Complaint_Handling_Service_Center_Update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies the complaint handling team when a service center partner portal user has made changes to case assigned to them.</description>
        <formula>AND( RecordTypeId =&apos;01241000001E5to&apos;, LastModifiedBy.ProfileId=&apos;00e41000000OxCK&apos;,  ISCHANGED(Investigation_Completion_Date__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BI NA Env Case Assignment</fullName>
        <actions>
            <name>BI_NA_Env_Update_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Investigate-Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Envelopes Case</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BI NA Surface Cost Type Update</fullName>
        <actions>
            <name>Cost_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Total_Cost_Updation1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Activity_Type__c</field>
            <operation>equals</operation>
            <value>Inspection,Repair Type 1,Repair Type 2,Inspect and Replace,Zero Labor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BI NA Surface Detail Page</fullName>
        <actions>
            <name>BI_NA_Surface_Show_Detail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI - NA Surfaces Closed Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Close</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI NA Surfaces Read Only Page</fullName>
        <actions>
            <name>Change_RecordType_BI_NA_Surfaces_freeze</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Close</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Brand Protect Web to Case Alert</fullName>
        <actions>
            <name>Brand_Protection_Web_to_Case_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Brand Protection Legal Case,Crop Protection Legal Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS_CaseCreationCustomerNotificationInternalRequest</fullName>
        <actions>
            <name>CS_CaseCreationNotificationforInternalRequest</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This is used to notify the contacts as soon a case of Internal Request record type is created for them in the system through automatic process,Created as a part of PMO Req.107</description>
        <formula>TEXT(Status) =$Label.CS_CaseNewStatus &amp;&amp; ISBLANK(ParentId) &amp;&amp; NOT(ISBLANK(SuppliedEmail))&amp;&amp;(RecordType.Name =$Label.CS_CaseIRRecordType)&amp;&amp; TEXT(Origin) &lt;&gt; &apos;Fax&apos; &amp;&amp; (NOT(ISBLANK(AccountId)))&amp;&amp; Account.ERP_EmailNotificationSuppressed__c = False</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS_CaseCreationCustomerNotificationOrdersSR</fullName>
        <actions>
            <name>CS_CaseCreationNotificationforOrdersServiceRequests</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This is used to notify the contacts as soon a case od Order/Service Request type is created for them in the system through automatic process,Created as a part of  PMO Req.107</description>
        <formula>TEXT(Status) =$Label.CS_CaseNewStatus &amp;&amp; ISBLANK(ParentId) &amp;&amp; NOT(ISBLANK(SuppliedEmail))&amp;&amp;(RecordType.Name=$Label.CS_CaseSRRecordType || RecordType.Name =$Label.CS_CaseOrderRecordType )&amp;&amp; TEXT(Origin) &lt;&gt; $Label.CS_Fax  &amp;&amp;((ISBLANK(AccountId)) ||  (NOT(ISBLANK(AccountId))&amp;&amp; (ERP_CustomerLanguage__c = Account.fERP_Language__c || ISBLANK(ERP_CustomerLanguage__c)) &amp;&amp; Account.ERP_EmailNotificationSuppressed__c = False))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CS_Change_Owner_when_Account_Added_to_Case_Order</fullName>
        <actions>
            <name>CS_Change_to_New_Queue_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED(AccountId ) || ISCHANGED(ContactId))&amp;&amp;(RecordType.Name =$Label.CS_CaseOrderRecordType)&amp;&amp;TEXT(Status)=$Label.CS_CaseNewStatus</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_Change_Owner_when_Account_Added_to_Case_SR</fullName>
        <actions>
            <name>CS_Change_to_New_Queue_SR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED(AccountId ) || ISCHANGED(ContactId))&amp;&amp;(RecordType.Name=$Label.CS_CaseSRRecordType)&amp;&amp;TEXT(Status)=$Label.CS_CaseNewStatus</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_StatusUpdateOnOwnerChange</fullName>
        <actions>
            <name>CS_StatusUpdateFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will process Customer Service Case Records When Owner is updated Created as a part of req.113</description>
        <formula>ISCHANGED(OwnerId) &amp;&amp; OwnerId =  $User.Id &amp;&amp; (RecordType.Name =$Label.CS_CaseIRRecordType|| RecordType.Name=$Label.CS_CaseSRRecordType || RecordType.Name =$Label.CS_CaseOrderRecordType )&amp;&amp;(TEXT(Status)=$Label.CS_CaseWIStatus || TEXT(Status)=$Label.CS_CaseNewStatus)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_UpdateCaseFields</fullName>
        <actions>
            <name>CS_UpadateDivisionDescription</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateCustomerGroup2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateCustomerServiceCenter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateDistChannelCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateDistChannelDescription</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateDivisionCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateERPAccountCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateSalesOrgCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateSalesOrgDescription</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CS_UpdateYKPartnerCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update Case fields like Dist. Channel Description ,Dist. Channel ,Division Description ,Sales Org Code,Sales Org Description as per the associated Account ,Created as per req.182</description>
        <formula>((TEXT(Origin) != &apos;Fax&apos;) || (TEXT(Origin) == &apos;Fax&apos; &amp;&amp; fCaseAge__c &gt; 0.01)) &amp;&amp; NOT( ISNULL( Account.Id)) &amp;&amp; NOT( ISBLANK( Account.Id)) &amp;&amp; ((RecordType.Name=$Label.CS_CaseSRRecordType || RecordType.Name =$Label.CS_CaseOrderRecordType  || RecordType.Name=$Label.CS_CaseIRRecordType  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_UpdateIRCaseRecordType</fullName>
        <actions>
            <name>CS_UpdateIRCaseRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is to update the Record type of Internal Request Cases when owner for a record is changed to correct owner.</description>
        <formula>ISCHANGED( OwnerId )&amp;&amp;  RecordType.DeveloperName != &apos;CS_InternalRequest&apos; &amp;&amp; (Owner:Queue.DeveloperName = &apos;CS_InternalRequestIndia&apos; || Owner:Queue.DeveloperName = &apos;CS_Internal_Request_China&apos;|| Owner:Queue.DeveloperName = &apos;CS_Internal_Request_NA&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_UpdateOrderCaseRecordType</fullName>
        <actions>
            <name>CS_UpdateOrderCaseRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is to update the Record type of Order Cases when owner for a record is changed to correct owner.</description>
        <formula>ISCHANGED( OwnerId )  &amp;&amp;  RecordType.DeveloperName != &apos;CS_Order&apos; &amp;&amp;  Owner:Queue.DeveloperName = &apos;CS_Order&apos; ||  Owner:Queue.DeveloperName = &apos;CS_UnAssignedOrder&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_UpdateSRCaseRecordType</fullName>
        <actions>
            <name>CS_UpdateSRCaseRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is to update the Record type of Service Request Cases when owner for a record is changed to correct owner.</description>
        <formula>ISCHANGED( OwnerId ) &amp;&amp; RecordType.DeveloperName != &apos;CS_ServiceRequest&apos; &amp;&amp; (Owner:Queue.DeveloperName = &apos;CS_ServiceRequest&apos; || Owner:Queue.DeveloperName = &apos;CS_UnAssignedServiceRequest&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS_mail_Notification_on_Reply_Received</fullName>
        <actions>
            <name>CS_mail_Notification_on_Reply_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow is useful in order to send Acknowledge mail when case status changes to Reply Received</description>
        <formula>AND( ISPICKVAL(Status, &quot;Reply Received&quot;), ( RecordTypeId = &apos;01213000001FszK&apos; || RecordTypeId = &apos;01213000001FszL&apos; || RecordTypeId = &apos;01213000001FszM&apos;),  NOT( BEGINS(OwnerId ,&apos;00G13&apos; ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Task Completion Notification</fullName>
        <actions>
            <name>Send_BI_EMEA_VF_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to task completion notifications on the related Case.</description>
        <formula>AND($RecordType.DeveloperName=&apos;BI_Case&apos;,ISCHANGED( Activity_Id__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DPT Complaint Initiation%2FAssignment 1</fullName>
        <actions>
            <name>Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_Status_to_Investigate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>DPT Aramids Case Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>DPT Complaint Initiation/Assignment Rule #1</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT Complaint Initiation%2FAssignment 2</fullName>
        <actions>
            <name>Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_Status_to_Investigate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>DPT Nonwovens Case Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>DPT Complaint Initiation/Assignment Rule #2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT Complaint Initiation%2FAssignment 3</fullName>
        <actions>
            <name>Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_Status_to_Investigate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>DPT Garments Case Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>DPT Complaint Initiation/Assignment Rule #3</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT Effectiveness Followup</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT Global Complaint - Resolve</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Resolution_Verify_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DPT_Effectiveness_Followup</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Resolution_Verify_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DPT Quality Case Resolved upon Approval</fullName>
        <actions>
            <name>Case_UpdateResolvedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT Global Complaint - Resolve</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Case: Update Resolved Date to TODAY when a case action or resolution is approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT-IPP General Inquiry Assignment to Queue</fullName>
        <actions>
            <name>Update_Owner_to_DPT_IPP_NA_General_Inqui</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Owning_SBU__c</field>
            <operation>equals</operation>
            <value>Protection Technologies</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>DPT-IPP Value Chain Service Distributors</value>
        </criteriaItems>
        <description>To assign the Case to a Queue and notify the Queue members on the query</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
