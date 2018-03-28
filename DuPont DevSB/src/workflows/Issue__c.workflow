<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Category_3_Email_alert</fullName>
        <description>Category 3 Email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>suresh.beniwal_corp@tcs.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/Cat3_email</template>
    </alerts>
    <alerts>
        <fullName>CompletionEmail_sent_to_Issue_Submitter_RecordCreator_and_SFDC_Support</fullName>
        <description>Email sent to Issue Submitter, Record Creator, and SFDC Support for Issue</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/IssueUpdateResponse</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_has_sent_when_Issue_is_related_to_SAP</fullName>
        <ccEmails>DupontESD@dellsevicedesk.com</ccEmails>
        <description>Email Notification has sent when Issue is related to SAP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>sudheer.gopisetty@dupont.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.beniwal_corp@tcs.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/DSOM_Creation_Issue_Object_SAP</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_Survey</fullName>
        <description>Email alert for Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/SurveyTemplate</template>
    </alerts>
    <alerts>
        <fullName>Email_to_key_user_for_Deactivation_SFAR_with_blank_Transfer_records_to_field</fullName>
        <description>Email to key user for Deactivation SFAR with blank Transfer records to field</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/KeyUser_intimation_for_Deactivation_SFAR_closed</template>
    </alerts>
    <alerts>
        <fullName>High_Severity_more_than_one_day_CRM</fullName>
        <ccEmails>suresh.beniwal@tcs.com</ccEmails>
        <description>High Severity more than one day</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/High_Severity_more_than_one_day</template>
    </alerts>
    <alerts>
        <fullName>Issue_Notification_of_Audit_Review</fullName>
        <ccEmails>SFDC-Admin@dupont.com</ccEmails>
        <description>Issue Notification of Audit Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>craig.hansen@pioneer.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/Audit_Review_Notification</template>
    </alerts>
    <alerts>
        <fullName>Issue_escalation_notification_to_Key_User</fullName>
        <description>Issue escalation notification to Key User</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/Issue_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>NewDataModelIssueNotificationAlert</fullName>
        <description>New Data Model Issue Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>DataModellingIssueQueueMembers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/NewIssueAlert</template>
    </alerts>
    <alerts>
        <fullName>NewIssueNotificationAlertAdminSupport</fullName>
        <description>New Issue Notification Alert - Admin Support</description>
        <protected>false</protected>
        <recipients>
            <recipient>SFDCAdminSupport787141</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/NewIssueAlert</template>
    </alerts>
    <alerts>
        <fullName>New_Issue_Notification_Alert_PA_Admin_Support</fullName>
        <description>New Issue Notification Alert - PA Admin Support</description>
        <protected>false</protected>
        <recipients>
            <recipient>SFDC_Utility_Support</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/NewIssueAlert</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_to_IOD_Team</fullName>
        <ccEmails>madiraju.satyadev@tcs.com.pscrm, sriramya.rayaprolu@tcs.com.pscrm,bhanu.kella@tcs.com.pscrm</ccEmails>
        <description>Send Email Notification to IOD Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>chanbasha.k_corp@tcs.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sudheer.gopisetty@dupont.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.beniwal_corp@tcs.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/DSOM_Creation_Issue_Object_IOD</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Pioneer_Team</fullName>
        <ccEmails>CHAD.TILL@PIONEER.COM</ccEmails>
        <description>Send Email to Pioneer Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/PQR_Creation_Issue_Object_Pioneer</template>
    </alerts>
    <alerts>
        <fullName>Send_Issue_hard_closed_email_to_the_Key_User</fullName>
        <ccEmails>suresh.beniwal@tcs.com</ccEmails>
        <description>Send Issue hard closed email  to the Key User</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IssuesandIdeas/Issue_hard_close_update_to_Users</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail_To_ETL_Team</fullName>
        <ccEmails>raja.damaraju@tcs.com,</ccEmails>
        <ccEmails>Dupont.informaticasupport@tcs.com</ccEmails>
        <description>Send Mail To ETL Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>chanbasha.k_corp@tcs.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sudheer.gopisetty@dupont.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suresh.beniwal_corp@tcs.com.pscrm</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/DSOM_Creation_Issue_Object_ETL</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_to_Approval_team_to_approve_the_pending_issue</fullName>
        <description>Send Reminder to Approval team to approve the pending issue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IssuesandIdeas/Reminder_Notification_to_approvers_to_approve_the_pending_request</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_waiting_Issue_to_the_Key_User</fullName>
        <description>Send email for waiting Issue to the Key User</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IssuesandIdeas/Issue_Waiting_update_to_Users</template>
    </alerts>
    <fieldUpdates>
        <fullName>AssignIssuetoQueueAdminSupport</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDCAdminSupport</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Issue to Queue - Admin Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Issue_to_Design_Review_Queue</fullName>
        <description>Assigns Issue to the Design Review Queue</description>
        <field>OwnerId</field>
        <lookupValue>CRMITDesignReview</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Issue to Design Review Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Issue_to_Queue_PA_Admin_Support</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_Utility_Support_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Issue to Queue - PA Admin Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Issue_to_Queue_SFDC_FF_PSA_Supp</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_FinancialForce_PSA_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Issue to Queue - SFDC FF PSA Supp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Tech_Review_Issues_to_TR_Queue</fullName>
        <description>Assigns Issues to the Technical Review Queue</description>
        <field>OwnerId</field>
        <lookupValue>CRMITTechnicalReview</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Tech Review Issues to TR Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Issue_Approval_Status</fullName>
        <description>Updates Approval Status to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Issue - Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Issue_Closing_Type</fullName>
        <description>Update Closing type to Tasks Complete.</description>
        <field>Closing_Type__c</field>
        <literalValue>Tasks Complete</literalValue>
        <name>Issue - Closing Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Issue_Owner_field_to_Craig_Hansen</fullName>
        <description>Issue - Owner field to Craig Hansen</description>
        <field>OwnerId</field>
        <lookupValue>craig.hansen@pioneer.com.pscrm</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Issue - Owner field to Craig Hansen</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Issue_Stage_Update</fullName>
        <description>Updates the Stage field upon approval of the Issue.</description>
        <field>Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Issue - Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Issue_Status_to_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Issue - Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completed_Date_Of_Issue</fullName>
        <description>Update Completed Date Of Issue</description>
        <field>Date_Closed__c</field>
        <formula>NOW()</formula>
        <name>Update Completed Date Of Issue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Accepted_as_today</fullName>
        <description>Update Date Accepted as Today () when the status of the issue is changed to Accepted</description>
        <field>Date_Accepted__c</field>
        <formula>NOW()</formula>
        <name>Update_Date_Accepted_as_today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Discussions_First_Reminder_sent</fullName>
        <description>To Update Discussions after the first auto reminder is sent</description>
        <field>Discussion_And_Updates__c</field>
        <formula>TEXT(TODAY() )+&quot; (System):&quot;+BR()+
&quot;First Reminder sent to Submitter&quot; +BR()+BR() + Discussion_And_Updates__c</formula>
        <name>Update Discussions-First Reminder sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Discussions_Second_Reminder_sent</fullName>
        <description>To Update Discussions after the second auto reminder is sent</description>
        <field>Discussion_And_Updates__c</field>
        <formula>TEXT(TODAY() )+&quot; (System):&quot;+BR()+ 
&quot;Second Reminder sent to Submitter&quot; +BR()+BR() + Discussion_And_Updates__c</formula>
        <name>Update Discussions-Second Reminder sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Issues_Closed_date</fullName>
        <description>Update the Issues Closed date</description>
        <field>Date_Closed__c</field>
        <formula>Now()</formula>
        <name>Update the Issues Closed date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_Waiting_since</fullName>
        <field>Waiting_for_User_since__c</field>
        <formula>NOW()</formula>
        <name>Update field-Waiting since</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Closing_Type</fullName>
        <description>Update Closing Type to &apos;No Response&apos;</description>
        <field>Closing_Type__c</field>
        <literalValue>No Response</literalValue>
        <name>Update the Closing Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Issues_status_to_closed</fullName>
        <field>Status__c</field>
        <literalValue>Not Applicable/System Hard Closed</literalValue>
        <name>Update the Issues status to closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_issues_closed_Date</fullName>
        <field>Date_Closed__c</field>
        <formula>NOW()</formula>
        <name>Update the issues closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_waiting_for_user_since_field</fullName>
        <description>Update waiting for user since field with blank</description>
        <field>Waiting_for_User_since__c</field>
        <name>Update waiting for user since field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Issue to Design Review Queue</fullName>
        <actions>
            <name>Assign_Issue_to_Design_Review_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Architecture Review,Data Model Review,Security Review,Design Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Project Review</value>
        </criteriaItems>
        <description>Assign to Design Review queue when Type is Arch, DM, Security or Design Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Technical Review Issue to TR Queue</fullName>
        <actions>
            <name>Assign_Tech_Review_Issues_to_TR_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Technical Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Issue_Type__c</field>
            <operation>equals</operation>
            <value>IT</value>
        </criteriaItems>
        <description>When Type = Technical Review - assign the Issue to the CRM IT TechnicalReview Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date Accepted is autopopulated when Status is changed to Accepted</fullName>
        <actions>
            <name>Update_Date_Accepted_as_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Issue_Type__c</field>
            <operation>equals</operation>
            <value>IT-Price Authorization,IT,Digital Marketing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Date_Accepted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Date Accepted is auto populated to TODAY() when Status is changed to Accepted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification Sent for Integration related Issue -SAP</fullName>
        <actions>
            <name>Email_Notification_has_sent_when_Issue_is_related_to_SAP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.SubType__c</field>
            <operation>equals</operation>
            <value>SAP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress,Waiting</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Alias</field>
            <operation>equals</operation>
            <value>TCS COO</value>
        </criteriaItems>
        <description>Email Notification is sent for Integration related Issue -SAP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification Sent related to IOD Issue</fullName>
        <actions>
            <name>Send_Email_Notification_to_IOD_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress,Waiting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.SubType__c</field>
            <operation>equals</operation>
            <value>IOD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Alias</field>
            <operation>equals</operation>
            <value>TCS COO</value>
        </criteriaItems>
        <description>Email Notification Sent to IOD team if Issue is related to IOD</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification Sent to ETL Team</fullName>
        <actions>
            <name>Send_Mail_To_ETL_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress,Waiting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Issues and Ideas,DuPont Administration,Project Review,Marketing Communications,Price Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.SubType__c</field>
            <operation>equals</operation>
            <value>ETL</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Alias</field>
            <operation>equals</operation>
            <value>TCS COO</value>
        </criteriaItems>
        <description>Email Notification Sent for Integration related Issue - ETL</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification Sent to Pioneer Team</fullName>
        <actions>
            <name>Send_Email_to_Pioneer_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress,Waiting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.SubType__c</field>
            <operation>equals</operation>
            <value>Pioneer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Alias</field>
            <operation>equals</operation>
            <value>TCS COO</value>
        </criteriaItems>
        <description>Email Notification Sent for Integration related Issue - Pioneer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>High Severity Issues</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started,Accepted,In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Application__c</field>
            <operation>equals</operation>
            <value>CRM (Standard functionality),Customer Service Console,Price Approval,FinancialForce PSA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Priority__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Severity__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <description>Mail will be sent if Issue is in Not Started/Accepted/In Progress stage for more than one day for high severity issues</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>High_Severity_more_than_one_day_CRM</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Issue__c.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Issue - Audit Review Approval</fullName>
        <actions>
            <name>Issue_Notification_of_Audit_Review</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Issue_Owner_field_to_Craig_Hansen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DuPont Administration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Audit IT Controls</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.SubType__c</field>
            <operation>equals</operation>
            <value>Privileged Access Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Submitted_By__c</field>
            <operation>contains</operation>
            <value>Gopisetty</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Review_Actual_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Forwarding audit issue(s) to App rover</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Issue - Update when Approved</fullName>
        <actions>
            <name>Issue_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Issue_Closing_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Issue_Stage_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Issue_Status_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_the_Issues_status_to_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DuPont Administration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Audit IT Controls</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Username</field>
            <operation>startsWith</operation>
            <value>craig.hansen@pioneer.com.temp</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Review_Actual_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Change in Approval Status and closing issue after issue has been reviewed and approved.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Issue Waiting Automatic updates</fullName>
        <actions>
            <name>Update_field_Waiting_since</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To Update the date in which the Issue was set to waiting, send reminders and close the issue</description>
        <formula>AND(ISPICKVAL(Status__c, &apos;Waiting&apos;),  ISPICKVAL(Sub_Status__c,&apos;Waiting with Customer&apos; ) ,OR ( Owner:User.Alias == &apos;TCS COO&apos;, LastModifiedBy.Alias == &apos;TCS COO&apos; ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Issue_hard_closed_email_to_the_Key_User</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_Issues_Closed_date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_the_Closing_Type</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_the_Issues_status_to_closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Issue__c.Waiting_for_User_since__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_email_for_waiting_Issue_to_the_Key_User</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_Discussions_Second_Reminder_sent</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Issue__c.Waiting_for_User_since__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_email_for_waiting_Issue_to_the_Key_User</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_Discussions_First_Reminder_sent</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Issue__c.Waiting_for_User_since__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Issue logged to Admin Support Queue</fullName>
        <actions>
            <name>AssignIssuetoQueueAdminSupport</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 6) OR (4 AND 5  AND 7)</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Issues and Ideas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Issue_Type__c</field>
            <operation>equals</operation>
            <value>IT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Communications</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Type__c</field>
            <operation>equals</operation>
            <value>Content-Data</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Application__c</field>
            <operation>notEqual</operation>
            <value>FinancialForce PSA,Eloqua</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Application__c</field>
            <operation>notEqual</operation>
            <value>Eloqua</value>
        </criteriaItems>
        <description>Notify SFDC Admin Support when the issue is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Issue logged to PA Admin Support Queue</fullName>
        <actions>
            <name>New_Issue_Notification_Alert_PA_Admin_Support</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Issue_to_Queue_PA_Admin_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Price Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started</value>
        </criteriaItems>
        <description>This workflow will assign all the issues from PA Application to SFDC PA Queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Issue logged to SFDC FF PSA Support Queue</fullName>
        <actions>
            <name>Assign_Issue_to_Queue_SFDC_FF_PSA_Supp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Application__c</field>
            <operation>equals</operation>
            <value>FinancialForce PSA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Issues and Ideas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Date_Accepted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Issue owner changed to SFDC FF PSA Support Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Issue-Auto Completion Email notification</fullName>
        <actions>
            <name>CompletionEmail_sent_to_Issue_Submitter_RecordCreator_and_SFDC_Support</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Issues and Ideas,DuPont Administration,Project Review,Marketing Communications,Price Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>An email will be sent to the Issue Submitter, DuPont Admin and SFDC Support Team once the Issue status is changed to Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Low Severity Issues other than CRM</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started,Accepted,In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Application__c</field>
            <operation>equals</operation>
            <value>Customer Service Console,Price Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Priority__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Severity__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <description>Mail will be sent if Issue is in Not Started/Accepted/In Progress stage for more than two days for Low severity issues</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Issue__c.LastModifiedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Mail to be sent when Cat 1%2C2%2C3 Issues reported</fullName>
        <actions>
            <name>Category_3_Email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Issue__c.Category__c</field>
            <operation>equals</operation>
            <value>Cat 3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Category__c</field>
            <operation>equals</operation>
            <value>Cat 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.Category__c</field>
            <operation>equals</operation>
            <value>Cat 1</value>
        </criteriaItems>
        <description>A mail will be triggered when Category 1,2,3 Issues reported.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notification to Issue Submitter when issue has been escalated</fullName>
        <actions>
            <name>Issue_escalation_notification_to_Key_User</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issue__c.OwnerId</field>
            <operation>equals</operation>
            <value>CRM IT Data Modelling,CRM IT Design Review,CRM IT Security Review,CRM IT Technical Review,SFDC Escalated Support,SFDC Utility Escalated Support</value>
        </criteriaItems>
        <description>Email notification to Issue Submitter when the status of an Issue has been changed to &apos;Escalated&apos;&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SurveyFeedback</fullName>
        <actions>
            <name>Email_alert_for_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Customer Satisfaction Survey</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Waiting for user since field blank other than issue status is waiting</fullName>
        <actions>
            <name>Update_waiting_for_user_since_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Waiting for user since field blank other than issue status is waiting</description>
        <formula>AND(ISCHANGED(Status__c),  !ISPICKVAL(Status__c,&apos;Waiting&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
