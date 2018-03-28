<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_on_new_Fabric_Certification_Request</fullName>
        <description>Alert on new Fabric Certification Request</description>
        <protected>false</protected>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>ilona.ivanova@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maureen.barling@che.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>victoria.mascaray@esp.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPP_EMEA/Fabric_certification_Request</template>
    </alerts>
    <alerts>
        <fullName>BI_Email_Alert_Certificate_of_Authorization</fullName>
        <description>BI Email Alert: Certificate of Authorization</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Related_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Partner_Templates/BI_Authorized_Retailer_Certificate</template>
    </alerts>
    <alerts>
        <fullName>BI_Email_alert_Thank_You_Email</fullName>
        <description>BI Email alert: Thank You Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Related_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Partner_Templates/BI_Authorization_Thank_You_E_Mail</template>
    </alerts>
    <alerts>
        <fullName>Brand_License_Request_Rejected</fullName>
        <description>Brand License Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>M_S_Brand_Mgm_Templates/Qualification_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Brand_License_Request_completely_approved</fullName>
        <description>Brand License Request completely approved</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>M_S_Brand_Mgm_Templates/Qualification_Approved</template>
    </alerts>
    <alerts>
        <fullName>Brand_License_Request_partially_approved</fullName>
        <description>Brand License Request partially approved</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>M_S_Brand_Mgm_Templates/Qualification_Approved_Partial</template>
    </alerts>
    <alerts>
        <fullName>Certification_Certification_Completed_Nominee</fullName>
        <description>Certification - Certification Completed - Nominee</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_To_The_Candidate_Agreement</template>
    </alerts>
    <alerts>
        <fullName>Certification_Certification_Completed_Trainer</fullName>
        <description>Certification - Certification Completed - Trainer</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_To_The_Trainer_Agreement</template>
    </alerts>
    <alerts>
        <fullName>Certification_Email_Notification_to_create_DPS_Surf_Admin</fullName>
        <ccEmails>cheryl.a.jeanes@dupont.com</ccEmails>
        <description>Certification - Email Notification to create DPS-Surf Admin</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_For_the_DuPont_Admin</template>
    </alerts>
    <alerts>
        <fullName>Certification_Email_Notification_to_the_Candidate_Admin_Approved</fullName>
        <description>Certification - Email Notification to the Candidate -Admin Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_On_Admin_Approval</template>
    </alerts>
    <alerts>
        <fullName>Certification_Email_Notification_to_the_DPS_BE_Admin</fullName>
        <ccEmails>patti.a.wolfe@dupont.com</ccEmails>
        <description>Certification - Email Notification to the DPS-BE Admin</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_For_the_DuPont_Admin</template>
    </alerts>
    <alerts>
        <fullName>Certification_Email_Notification_to_the_Trainee_Admin_Rejected</fullName>
        <description>Certification - Email Notification to the Trainee -Admin Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_On_Admin_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Certification_Notification_For_the_Channel_Manager</fullName>
        <description>Certification - Notification For the Channel Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Channel_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Notification_For_the_Channel_Manager</template>
    </alerts>
    <alerts>
        <fullName>Certification_has_been_Approved</fullName>
        <description>Certification has been Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/Certification_Has_Been_Approved</template>
    </alerts>
    <alerts>
        <fullName>New_attachment_added</fullName>
        <description>New attachment added</description>
        <protected>false</protected>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPP_EMEA/New_Attachment</template>
    </alerts>
    <alerts>
        <fullName>Qualification_End_Date_and_Insurance_Date_to_expire</fullName>
        <description>Qualification End Date and Insurance Date to expire</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>M_S_Brand_Mgm_Templates/Qualification_End_Date_and_Insurance_end_date_to_expire_in_90_days</template>
    </alerts>
    <alerts>
        <fullName>Qualification_Notification_of_Expiration_30_Days</fullName>
        <description>Qualification Notification of Expiration - 30 Days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>M_S_Brand_Mgm_Templates/TMLA_Expiry_Notification</template>
    </alerts>
    <alerts>
        <fullName>Qualification_Notification_of_Expiration_90_Days</fullName>
        <description>Qualification Notification of Expiration - 90 Days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>M_S_Brand_Mgm_Templates/TMLA_Expiry_Notification</template>
    </alerts>
    <alerts>
        <fullName>Qualification_Record_approved_by_Approver</fullName>
        <description>Qualification Record approved by Approver</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI/Approved</template>
    </alerts>
    <alerts>
        <fullName>Rejected</fullName>
        <description>Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI/Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Step_Approval_by_BU</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Approval by Business Unit&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Approval by Business Unit</literalValue>
        <name>Approval Step - Approval by BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Approval_by_Licensee</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Approval by Licensee&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Approval by Licensee</literalValue>
        <name>Approval Step - Approval by Licensee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Approval_by_MC_B</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Approval by MC&amp;B&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Approval by MC&amp;B</literalValue>
        <name>Approval Step - Approval by MC&amp;B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Approving_Legal_Global</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Approval by Legal-Global&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Approval by Legal-Global</literalValue>
        <name>Approval Step - Approving Legal-Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Approving_Legal_Region</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Approval by Legal-Regional&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Approval by Legal-Regional</literalValue>
        <name>Approval Step - Approving Legal-Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Fully_Approved</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Fully Approved&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Fully Approved</literalValue>
        <name>Approval Step - Fully Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Recalled_by_Submitter</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Recalled by Submitter&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Recalled by Submitter</literalValue>
        <name>Approval Step - Recalled by Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected_by_BU</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Rejected by Business Unit&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by Business Unit</literalValue>
        <name>Approval Step - Rejected by BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected_by_Legal_Global</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Rejected by Legal-Global&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by Legal-Global</literalValue>
        <name>Approval Step - Rejected by Legal-Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected_by_Legal_Region</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Rejected by Legal-Regional&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by Legal-Regional</literalValue>
        <name>Approval Step - Rejected by Legal-Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected_by_Licensee</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Rejected by Licensee&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by Licensee</literalValue>
        <name>Approval Step - Rejected by Licensee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected_by_MC_B</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Rejected by MC&amp;B&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by MC&amp;B</literalValue>
        <name>Approval Step - Rejected by MC&amp;B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Routing_by_MC_B</fullName>
        <description>Set the Approval Step field in Qualification to &quot;Routing by MC&amp;B&quot;</description>
        <field>Approval_Step__c</field>
        <literalValue>Routing by MC&amp;B</literalValue>
        <name>Approval Step - Routing by MC&amp;B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_changes_to_Approved</fullName>
        <description>Changes Approval Step to Approved</description>
        <field>Approval_Step__c</field>
        <literalValue>Fully Approved</literalValue>
        <name>Approval Step changes to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_changes_to_Recalled</fullName>
        <description>Changes the Approval Step to Recalled</description>
        <field>Approval_Step__c</field>
        <literalValue>Recalled by Submitter</literalValue>
        <name>Approval Step changes to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_changes_to_Rejected</fullName>
        <description>Changes Approval Step to Rejected</description>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by Business Unit</literalValue>
        <name>Approval Step changes to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_to_Submitted</fullName>
        <description>Change Approval Step to Submitted</description>
        <field>Approval_Step__c</field>
        <literalValue>Pending First Approver</literalValue>
        <name>Approval Step to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Certification_Email_Notification_to_th</fullName>
        <field>Stage__c</field>
        <literalValue>On Hold</literalValue>
        <name>Stage Update - Certification OnHold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Stage_Update_Completed_Training</fullName>
        <field>Stage__c</field>
        <literalValue>Completed Training</literalValue>
        <name>Field Stage Update- Completed Training</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Changed_Field_Update</fullName>
        <field>Products_Changed__c</field>
        <literalValue>1</literalValue>
        <name>Product Changed Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Changed_To_Disable_Schedule_btn</fullName>
        <field>Products_Changed__c</field>
        <literalValue>0</literalValue>
        <name>Product Changed-To Disable Schedule btn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Stage_Active</fullName>
        <description>Sets the Stage field in Qualification to value &quot;Active&quot;</description>
        <field>Stage__c</field>
        <literalValue>Active</literalValue>
        <name>Qualification - Stage - Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Stage_Inactive_2</fullName>
        <description>Sets the stage of the Qualification to Inactive</description>
        <field>Stage__c</field>
        <literalValue>Inactive</literalValue>
        <name>Qualification - Stage - Inactive 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Stage_Reason_Null</fullName>
        <description>Sets the Stage Reason field in Qualification to null</description>
        <field>Stage_Reason__c</field>
        <name>Qualification - Stage Reason - Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Status_Approved</fullName>
        <description>Sets the Status field in Qualification to value Approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Qualification - Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Status_Expired</fullName>
        <description>Set Status of Qualification to Expired</description>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Qualification - Status - Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Status_In_Progress</fullName>
        <description>Sets the Status field in Qualification to &quot;In Progress&quot;</description>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Qualification -Status - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualification_Status_Waiting</fullName>
        <description>Set the Status field in Qualification to &quot;Waiting&quot;</description>
        <field>Status__c</field>
        <literalValue>Waiting</literalValue>
        <name>Qualification - Status - Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Reason_No_Approver_selected</fullName>
        <description>Set the Stage Reason field on Qualification to &quot;No Approver selected&quot;</description>
        <field>Stage_Reason__c</field>
        <literalValue>No Approver selected</literalValue>
        <name>Stage Reason - No Approver selected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update</fullName>
        <field>Stage__c</field>
        <literalValue>In Progress</literalValue>
        <name>Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_End_date_of_Qualification</fullName>
        <field>End_Date__c</field>
        <formula>Start_Date__c  + 730</formula>
        <name>Update End date of Qualification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>LOOPlus_Qualification</fullName>
        <apiVersion>32.0</apiVersion>
        <endpointUrl>https://apps.drawloop.com/package/111</endpointUrl>
        <fields>Drawloop_Next__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>cheryl.a.jeanes@usa.dupont.com</integrationUser>
        <name>LOOPlus-Qualification</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>LOOPlus_Qualification_Email_Schedule_1A</fullName>
        <apiVersion>32.0</apiVersion>
        <endpointUrl>https://apps.drawloop.com/package/111</endpointUrl>
        <fields>Drawloop_Next_Schedule_1A_Email__c</fields>
        <fields>Id</fields>
        <fields>Primary_Contact_Email__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>cheryl.a.jeanes@usa.dupont.com</integrationUser>
        <name>LOOPlus-Qualification-Email Schedule 1A</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Alert on new Fabric Certification request</fullName>
        <actions>
            <name>Alert_on_new_Fabric_Certification_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fabric Certification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Stage__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Stage_Reason__c</field>
            <operation>equals</operation>
            <value>Web Entry</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Certification Stage Updation</fullName>
        <actions>
            <name>Field_Stage_Update_Completed_Training</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Certification Env,BI-NA Certification Surf</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Stage__c</field>
            <operation>equals</operation>
            <value>Candidate Nomination</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification-Certification Completed</fullName>
        <actions>
            <name>Certification_Certification_Completed_Nominee</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Certification_Certification_Completed_Trainer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LOOPlus_Qualification</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.Stage__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Certification Env,BI-NA Certification Surf</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Products Changed Workflow</fullName>
        <actions>
            <name>Product_Changed_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Training_Completed__c ), ISPICKVAL( Stage__c , &quot;Completed&quot;) , $RecordType.DeveloperName ==&quot;BI_NA_Certification_Env&quot;, OR( ISPICKVAL( Certified_In_Area__c , &quot;DWSRCI&quot;), ISPICKVAL( Certified_In_Area__c , &quot;DWSRCI - CAN&quot;), ISPICKVAL( Certified_In_Area__c , &quot;DWSCCI&quot;), ISPICKVAL( Certified_In_Area__c , &quot;DWSCCIFA&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Products Changed-Email Schedule 1A</fullName>
        <actions>
            <name>Product_Changed_To_Disable_Schedule_btn</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOOPlus_Qualification_Email_Schedule_1A</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.Products_Changed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Drawloop_Next_Schedule_1A_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Stage__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Qualification Expiring</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Brand License</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Stage__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Expired</value>
        </criteriaItems>
        <description>Used to inform Account and Qualification Owners that a Qualification is expiring in 90 and then 30 days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Qualification_Notification_of_Expiration_90_Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Qualification__c.End_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Qualification_Notification_of_Expiration_30_Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Qualification__c.End_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Qualification has expired</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Brand License</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will change the Qualification of Record Type Brand License when the End date has passed. It will set the Status to &quot;Expired&quot; and the Stage to &quot;Inactive&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Qualification_Stage_Inactive_2</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Qualification_Status_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Qualification__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Thank You email and Certificate to Contacts upon registration</fullName>
        <actions>
            <name>BI_Email_Alert_Certificate_of_Authorization</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>BI_Email_alert_Thank_You_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_End_date_of_Qualification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Certification_Notification_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI Retailer Authorization</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Owning_Org__c</field>
            <operation>equals</operation>
            <value>BI,BI-Surf,BI-Env</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send email when End Date is to expire</fullName>
        <active>true</active>
        <formula>AND(OR( Account_Name__r.fsOwner_Name__c = &apos;Lauren Shade&apos;, Account_Name__r.fsOwner_Name__c = &apos;Joann Hennessy&apos;,  Account_Name__r.fsOwner_Name__c = &apos;Stacey Kitch&apos;),   Account_Name__r.RecordTypeId = &apos;012300000000tdC&apos;, OR( End_Date__c -  TODAY() &lt;= 90,  Insurance_End_Date__c -  TODAY() &lt;=90))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Qualification_End_Date_and_Insurance_Date_to_expire</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Certification_Notification_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <description>An email notification has been sent to the qualified recipient.  Please see the related qualification record for details.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Qualification__c.Certificate_Issued_Date__c</offsetFromField>
        <priority>Medium</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Certification Notification Sent</subject>
    </tasks>
</Workflow>
