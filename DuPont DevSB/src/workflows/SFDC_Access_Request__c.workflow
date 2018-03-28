<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_for_Survey_SFAR</fullName>
        <description>Email alert for Survey SFAR</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All/SurveyTemplate_SFAR</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Create_New_User_Access_Completed</fullName>
        <description>SFAR  - Create New User Access Completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Create_New_User_Access_Completed2</template>
    </alerts>
    <alerts>
        <fullName>SFAR_DDUser_has_been_Deactivated_MyAccess_Cmplt</fullName>
        <description>SFAR - DuPont User has been Deactivated-MyAccess Complete</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_DD_User_has_been_Deactivated_MyAccess_Cmplt</template>
    </alerts>
    <alerts>
        <fullName>SFAR_DDUser_has_been_Deactivated_MyAccess_Not_Cmplt</fullName>
        <ccEmails>sfdc-admin@dupont.com</ccEmails>
        <description>SFAR - DuPont User has been Deactivated-MyAccess NOT Complete</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_User_has_been_Deactivated_MyAccess_Not_Cmplt</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Deactivation_mail_after_4_hrs</fullName>
        <ccEmails>chanbasha.k@tcs.com.pscrm</ccEmails>
        <ccEmails>suresh.beniwal@tcs.com.pscrm</ccEmails>
        <description>SFAR Deactivation mail after 4 hrs</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/SFAR_Deactivation_mail_after_4_hrs</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Email_Requestor_that_Business_Approver_rejected_request</fullName>
        <description>SFAR: Email Requestor that Business Approver rejected request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Business_Approval_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Escalation_notification_to_Key_User</fullName>
        <description>SFAR - Escalation notification to Key User</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Request_Routing_Template/SFAR_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>SFAR_MDSDG</fullName>
        <ccEmails>chanbasha.k@tcs.com.pscrm</ccEmails>
        <ccEmails>suresh.beniwal@tcs.com.pscrm</ccEmails>
        <description>SFAR MDSDG</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All/SFAR_MDSDG</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Modify_User_Access</fullName>
        <description>SFAR - Modify User Access</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Modify_User_Access_is_Complete</template>
    </alerts>
    <alerts>
        <fullName>SFAR_MyAccess_Is_Required</fullName>
        <description>SFAR - MyAccess Is Required</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_MyAccess_Is_Required</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_SFAR_has_been_Created</fullName>
        <description>SFAR - New SFAR has been Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/New_SFAR_has_been_Created</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Cancelling_after_Still_Waiting_for_My_Access_45_days</fullName>
        <description>SFAR: New User - Cancelling after Still Waiting for My Access - 45 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Cancelled_after_45_days_Waiting_for_MyAccess</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Cancelling_after_Still_Waiting_for_My_Access_60_days</fullName>
        <description>SFAR: New User - Cancelling after Still Waiting for My Access - 60 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Cancelled_after_60_days_Waiting_for_MyAccess</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Still_Waiting_for_My_Access_15_days</fullName>
        <description>SFAR: New User - Still Waiting for My Access - 15 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Still_Waiting_for_MyAccess_15_Days</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Still_Waiting_for_My_Access_30_day</fullName>
        <description>SFAR: New User - Still Waiting for My Access - 30 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Waiting_for_MyAccess_30_days</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Still_Waiting_for_My_Access_30_days</fullName>
        <description>SFAR: New User - Still Waiting for My Access - 30 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Waiting_for_MyAccess_30_days</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Still_Waiting_for_My_Access_45_days</fullName>
        <description>SFAR: New User - Still Waiting for My Access - 45 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Waiting_for_MyAccess_45_days</template>
    </alerts>
    <alerts>
        <fullName>SFAR_New_User_Still_Waiting_for_My_Access_7_days</fullName>
        <description>SFAR: New User - Still Waiting for My Access - 7 days</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Still_Waiting_for_MyAccess_7days</template>
    </alerts>
    <alerts>
        <fullName>SFAR_NonDuPont_User_has_been_Deactivated</fullName>
        <ccEmails>sfdc-admin@dupont.com</ccEmails>
        <description>SFAR - NonDuPont User has been Deactivated</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_NonDD_User_has_been_Deactivated</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Portal_Access_Approval_is_Requested</fullName>
        <ccEmails>sfdc-admin@dupont.com</ccEmails>
        <description>SFAR - Portal Access Approval is Requested</description>
        <protected>false</protected>
        <recipients>
            <field>Access_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Create_Portal_User_Access_Requested</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Portal_Access_Enabled</fullName>
        <description>SFAR - Portal Access Enabled</description>
        <protected>false</protected>
        <recipients>
            <field>Access_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Access_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Create_Portal_User_Access_Enabled</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Send_email_for_waiting_SFAR_toKey_User</fullName>
        <ccEmails>chanbasha.k@tcs.com.pscrm</ccEmails>
        <description>SFAR Send email for waiting SFAR toKey User</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Waiting_update_to_Users</template>
    </alerts>
    <alerts>
        <fullName>SFAR_Send_email_for_waiting_to_Key_User</fullName>
        <ccEmails>chanbasha.k@tcs.com.pscrm</ccEmails>
        <description>SFAR Send email for waiting to Key User</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Waiting_update_to_Users</template>
    </alerts>
    <alerts>
        <fullName>SFAR_User_Access_Completed</fullName>
        <ccEmails>sfdc-admin@dupont.com</ccEmails>
        <description>SFAR - User Access Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_User_Access_Completed</template>
    </alerts>
    <alerts>
        <fullName>SFAR_email_waiting_SFAR_Key_User</fullName>
        <ccEmails>chanbasha.k@tcs.com.pscrm</ccEmails>
        <description>SFAR Send email waiting SFAR to the Key User</description>
        <protected>false</protected>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_Waiting_update_to_Users</template>
    </alerts>
    <alerts>
        <fullName>SFAR_hard_closed_email_to_the_Key_User</fullName>
        <ccEmails>chanbasha.k@tcs.com.pscrm</ccEmails>
        <description>SFAR Send hard closed email to the Key User</description>
        <protected>false</protected>
        <recipients>
            <field>Access_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Key_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Access_Requests/SFAR_hard_close_update_to_Key_Users</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Date_Closed_to_Today</fullName>
        <field>Date_Closed__c</field>
        <formula>NOW()</formula>
        <name>Change Date Closed to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_To_Completed</fullName>
        <description>Staus should be changed to Completed</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Change Status To Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Bus_App_Status_In_Progress</fullName>
        <description>Change Business Approval Status to In Progress</description>
        <field>Business_Approval_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>SFAR: Change Bus App Status-In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Bus_App_Status_to_Approved</fullName>
        <description>Change the Business Approval Status to Approved</description>
        <field>Business_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>SFAR: Change Bus App Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Bus_App_Status_to_New</fullName>
        <description>Change Business Approval Status to New</description>
        <field>Business_Approval_Status__c</field>
        <literalValue>New</literalValue>
        <name>SFAR: Change Bus App Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Bus_App_Status_to_Rejected</fullName>
        <description>Change Business Approval Status to Rejected.</description>
        <field>Business_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>SFAR: Change Bus App Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_MyAccess_Deactivation_Date</fullName>
        <description>Myaccess Deactivation Date Receipt should be changed to Deactivate Request Date/Time</description>
        <field>MyAccess_Deactivation_Date_Receipt__c</field>
        <formula>DATEVALUE(Deactivate_Request_Date_Time__c)</formula>
        <name>SFAR:Change MyAccess Deactivation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Owner_to_Completed_SFARs</fullName>
        <description>Changes ownership of completed SFARs to the Queue: Completed SFARs</description>
        <field>OwnerId</field>
        <lookupValue>CompletedSFARs</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR: Change Owner to Completed SFARs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Owner_to_SFDC_Asset_Grantor</fullName>
        <description>SFAR - Notifies SFDC MyAccess Asset Grantors that ownership of record has been changed to them.</description>
        <field>OwnerId</field>
        <lookupValue>SFDCAssetGrantor</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR: Change Owner to SFDC Asset Grantor</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Owner_to_SFDC_SFAR_Support</fullName>
        <description>SFAR - Change Owner to SFDC SFAR Support Team</description>
        <field>OwnerId</field>
        <lookupValue>SFDC_SFAR_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR: Change Owner to SFDC SFAR Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Owner_to_SFDC_SFARs_Support</fullName>
        <description>SFAR - Change Owner to SFDC SFAR Support Team</description>
        <field>OwnerId</field>
        <lookupValue>SFDC_SFAR_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR: Change Owner to SFDC SFAR Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Ownrto_SFDC_PA_Admin_Support</fullName>
        <description>SFAR - Change Owner to SFDC PA Admin Support Queue</description>
        <field>OwnerId</field>
        <lookupValue>SFDC_SFAR_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR:Change Ownrto SFDC PA Admin Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Stage_to_Closed</fullName>
        <description>Changes the Stage to Closed</description>
        <field>Stage__c</field>
        <literalValue>Closed</literalValue>
        <name>SFAR: Change Stage to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Stage_to_UserAccessPending</fullName>
        <description>SFAR - Update Stage to User Access Pending</description>
        <field>Stage__c</field>
        <literalValue>User Access Pending</literalValue>
        <name>SFAR: Change Stage User Access Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Status_Waiting_for_MyAccess</fullName>
        <description>SFAR - Updates the Status to Waiting for MyAccess</description>
        <field>Status__c</field>
        <literalValue>Waiting for MyAccess</literalValue>
        <name>SFAR: Change Status-Waiting for MyAccess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Status_to_Approval_Verified</fullName>
        <description>SFAR - Change status to Approval Verified</description>
        <field>Status__c</field>
        <literalValue>Approval Verified</literalValue>
        <name>SFAR: Change Status to Approval Verified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Status_to_Canceled</fullName>
        <field>Status__c</field>
        <literalValue>Canceled</literalValue>
        <name>SFAR: Change Status to Canceled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Change_Status_to_Waiting</fullName>
        <description>SFAR - Change Status to Waiting</description>
        <field>Status__c</field>
        <literalValue>Waiting</literalValue>
        <name>SFAR: Change Status to Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Chg_Stage_to_User_Access_Confirmed</fullName>
        <description>SFAR- Change Stage to User Access Confirmed</description>
        <field>Stage__c</field>
        <literalValue>User Access Confirmed</literalValue>
        <name>SFAR: Chg Stage to User Access Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Chg_Status_to_In_Progress</fullName>
        <description>SFAR - Change Status to In Progress</description>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>SFAR: Change Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Chg_Status_to_Not_Started</fullName>
        <field>Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>SFAR: Chg Status to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Chg_Status_to_Waiting_for_Biz_Appr</fullName>
        <field>Status__c</field>
        <literalValue>Waiting for Business Approval</literalValue>
        <name>SFAR: Chg Status to Waiting for Biz Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Submit_to_Integration_Admin_Queue</fullName>
        <description>SFAR: Submit SFDC Access Request for Integrator to Integration Admin SFDC Queue</description>
        <field>OwnerId</field>
        <lookupValue>Integration_Admin_SFDC</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR: Submit to Integration Admin Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Content_User_to_True</fullName>
        <description>SFAR: Content User is True for this SFDC Access Request</description>
        <field>Content_User__c</field>
        <literalValue>1</literalValue>
        <name>SFAR : Update Content User to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Discussions_First_Reminder</fullName>
        <field>DiscussionAndUpdates__c</field>
        <formula>TEXT(TODAY() )+&quot; (System):&quot;+BR()+ 
&quot;First Reminder sent to Submitter&quot; +BR()+BR() + DiscussionAndUpdates__c</formula>
        <name>SFAR Update Discussions First Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Discussions_Sec_Reminder</fullName>
        <field>DiscussionAndUpdates__c</field>
        <formula>TEXT(TODAY() )+&quot; (System):&quot;+BR()+ 
&quot;Second Reminder sent to Submitter&quot; +BR()+BR() + DiscussionAndUpdates__c</formula>
        <name>SFAR Update Discussions-Sec Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Discussions_Third_Reminder</fullName>
        <field>DiscussionAndUpdates__c</field>
        <formula>TEXT(TODAY() )+&quot; (System):&quot;+BR()+ 
&quot;Third Reminder sent to Submitter&quot; +BR()+BR() + DiscussionAndUpdates__c</formula>
        <name>SFAR Update Discussions Third Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Epass_ID</fullName>
        <description>Updates the Epass ID on the SFAR from the User Record</description>
        <field>EPass_ID__c</field>
        <formula>User__r.EPass_ID__c</formula>
        <name>SFAR: Update Epass ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Owner_to_Pioner_EMEA_Instanc</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_SFAR_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR-Update Owner to Pioner EMEA Instanc</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Owner_to_Utility_instance</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_SFAR_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFAR-Update Owner to Utility instance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Portal_User_Role</fullName>
        <description>Update Portal User Role on SFDC Access Request</description>
        <field>Role__c</field>
        <formula>Portal_Contact__r.Account.Name</formula>
        <name>SFAR Update Portal User Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_Workspace_Viewing_Group</fullName>
        <description>Update Workspace Viewing Group on SFDC Access Request from Site Object</description>
        <field>Groups__c</field>
        <formula>Site_Object__r.Group__c</formula>
        <name>SFAR: Update Workspace Viewing Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_Update_waiting_for_user_since_fiel</fullName>
        <description>SFAR Update waiting for user since field with blank</description>
        <field>SFAR_Waiting_for_User_since__c</field>
        <name>SFAR 	Update waiting for user since fiel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFAR_for_Update_the_Closed_date</fullName>
        <field>Date_Closed__c</field>
        <formula>Now()</formula>
        <name>SFAR Update the Closed date</name>
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
        <fullName>Update_SFAR_Portal_User_Profile</fullName>
        <description>Update Portal User Profile on SFAR</description>
        <field>Profile__c</field>
        <formula>Site_Object__r.Profile__c</formula>
        <name>SFAR Update Portal User Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_SFAR_Waiting_since</fullName>
        <field>SFAR_Waiting_for_User_since__c</field>
        <formula>Now()</formula>
        <name>Update field-SFAR Waiting since</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_closed</fullName>
        <description>Update the SFAR status to closed</description>
        <field>Status__c</field>
        <literalValue>Not Applicable/System Hard Closed</literalValue>
        <name>Update the status to closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updt_Profile_with_Like_this_User_Profile</fullName>
        <description>SFAR - Update Profile with &quot;Like this User&quot; Profile</description>
        <field>Profile__c</field>
        <formula>Like_this_User__r.Profile.Name</formula>
        <name>Updt Profile with Like this User Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updt_Role_with_Like_this_User_Role</fullName>
        <description>SFAR: Update Role with &quot;Like this User&quot; Role</description>
        <field>Role__c</field>
        <formula>Like_this_User__r.UserRole.Name</formula>
        <name>Updt Role with Like this User Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SFAR%3A Still Waiting for MyAccess Notifications-New %26 Reactivations</fullName>
        <active>false</active>
        <criteriaItems>
            <field>SFDC_Access_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Waiting for MyAccess</value>
        </criteriaItems>
        <criteriaItems>
            <field>SFDC_Access_Request__c.MyAccess_Approval_History__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SFDC_Access_Request__c.Subtype__c</field>
            <operation>equals</operation>
            <value>Reactivate User Account,New User Account</value>
        </criteriaItems>
        <description>Sends a notice to the Creator &amp; Key User that MyAccess Approval has not been received at 7 days from creation, then again at 15 days, 30 days, and cancels and closes the SFAR at 40 days..</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SFAR_New_User_Still_Waiting_for_My_Access_7_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>SFDC_Access_Request__c.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFAR_New_User_Still_Waiting_for_My_Access_15_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>SFDC_Access_Request__c.CreatedDate</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFAR_New_User_Still_Waiting_for_My_Access_30_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>SFDC_Access_Request__c.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SFAR_New_User_Cancelling_after_Still_Waiting_for_My_Access_45_days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Change_Date_Closed_to_Today</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SFAR_Change_Owner_to_Completed_SFARs</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SFAR_Change_Stage_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SFAR_Change_Status_to_Canceled</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>SFDC_Access_Request__c.CreatedDate</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
