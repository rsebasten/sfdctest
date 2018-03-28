<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DPT_Nomex_New_Request_Approved</fullName>
        <ccEmails>victoria.mascaray@dupont.com</ccEmails>
        <description>DPT Nomex New Request Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_EMEA_Nomex_Label_Management_Template/DPT_EMEA_Nomex_New_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>DPT_Nomex_New_Request_Created</fullName>
        <description>DPT Nomex New Request Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>victoria.mascaray@esp.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_EMEA_Nomex_Label_Management_Template/DPT_EMEA_Nomex_New_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>DPT_Nomex_Request_Sent_to_Customer</fullName>
        <ccEmails>victoria.mascaray@che.dupont.com</ccEmails>
        <description>DPT Nomex Request Sent to Customer</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>victoria.mascaray@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPT_EMEA_Nomex_Label_Management_Template/DPT_Nomex_Request_Sent_to_Customer</template>
    </alerts>
    <alerts>
        <fullName>DPT_Nomex_Request_Shipped_to_Customer</fullName>
        <description>DPT Nomex Request Shipped to Customer</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>victoria.mascaray@esp.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPT_EMEA_Nomex_Label_Management_Template/DPT_Nomex_Request_being_Shipped_to_Customer</template>
    </alerts>
    <alerts>
        <fullName>Nomex_Samples_Request_Rejected</fullName>
        <description>Nomex Samples Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPT_EMEA_Nomex_Label_Management_Template/DPT_Nomex_Request_Rejected_by_Business</template>
    </alerts>
    <alerts>
        <fullName>P_IP_Samples_Request_Approved</fullName>
        <description>P&amp;IP Samples Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Samples_Request_Templates/Request_Approval_Template_Approved</template>
    </alerts>
    <alerts>
        <fullName>P_IP_Samples_Request_Rejected</fullName>
        <description>P&amp;IP Samples Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Samples_Request_Templates/Request_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>SalesAidCompleted</fullName>
        <description>Sales Aid - Completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>laetitia.laguerre@lux.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/Sales_Aid_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sales_Aide_Submitted</fullName>
        <description>Sales Aide - Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Sample_Request_Notification_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/New_Sales_Aid_Request_Supplier</template>
    </alerts>
    <alerts>
        <fullName>Sales_Aide_Submitted_Community</fullName>
        <description>Sales Aide - Submitted Community</description>
        <protected>false</protected>
        <recipients>
            <field>Sample_Request_Notification_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/New_Sales_Aid_Request_Supplier_Community</template>
    </alerts>
    <alerts>
        <fullName>Sample_Request_Web_Service_Call_Failed</fullName>
        <description>Sample Request Web Service Call Failed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alert_Templates/Sample_Request_Call_Failed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Add_Company_Name</fullName>
        <field>Send_to_Company__c</field>
        <formula>IF( Contact__r.Account.RecordType.Id=&quot;01230000000pv9P&quot;, Contact__r.Account.Name, Lead__r.Company)</formula>
        <name>Add Company Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DPT_nomex_Due_Date_change</fullName>
        <description>DPT-EMEA Nomex Label Mgt, change Due Date to 2 weeks after creation</description>
        <field>Due_Date__c</field>
        <formula>TODAY() +14</formula>
        <name>DPT nomex Due Date change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Step_to_Fully_Approved</fullName>
        <description>Updating the Approval step field to &quot;Fully Approved&quot;, after the Approval.</description>
        <field>Approval_Step__c</field>
        <literalValue>Fully Approved</literalValue>
        <name>Update Approval Step to Fully Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Step_to_Recalled</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Recalled</literalValue>
        <name>Update Approval Step to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Step_to_Rejected_Busines</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected by Business Unit</literalValue>
        <name>Update Approval Step to Rejected Busines</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_step_to_Pending_1st_Appr</fullName>
        <description>Update the Approval step to Pending Before First approver.</description>
        <field>Approval_Step__c</field>
        <literalValue>Pending First Approver</literalValue>
        <name>Update Approval step to Pending 1st Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Sales_Aid_Captur</fullName>
        <description>Update Record Type to Sales Aid Capture, after the Approval.</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesAidCapture</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Sales Aid Captur</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Sales_Aid_Capture</fullName>
        <description>Update Record Type to Sales Aid Capture, after the Approval.</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesAidCapture</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Sales Aid Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Sales_Aid_Capture1</fullName>
        <description>Update Record Type to Sales Aid Capture, after the Approval.</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesAidCapture</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Sales Aid Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Sales_Aid_Capture2</fullName>
        <description>Update Record Type to Sales Aid Capture, after the Approval.</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesAidCapture</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Sales Aid Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Sales_Aid_Capture3</fullName>
        <description>Update Record Type to Sales Aid Capture, after the Approval.</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesAidCapture</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Sales Aid Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Submitted</fullName>
        <description>Update Nomex request record type to Sales Aid - Submitted when the request is approved</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesAidSubmitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Phone</fullName>
        <field>Phone__c</field>
        <formula>Contact__r.Phone</formula>
        <name>Update Request Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Send_To_Contact</fullName>
        <field>Send_to_Contact__c</field>
        <formula>Contact__r.FirstName &amp; &quot; &quot; &amp; Contact__r.LastName</formula>
        <name>Update Request Send To Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Status_to_In_Progress</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Update Request Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Stage_to_Submitted</fullName>
        <field>Stage__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update the Stage to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Status_to_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update the Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Status_to_In_Progress</fullName>
        <description>Update the Status to In Progress, after the Approval.</description>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Update the Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DPT EMEA Nomex Sales Aid Request</fullName>
        <actions>
            <name>Update_Record_Type_to_Sales_Aid_Captur</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Request_Status_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Fully Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - In Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Product_Details__c</field>
            <operation>contains</operation>
            <value>DPT Nomex Labels</value>
        </criteriaItems>
        <description>Update Request Record Type to Sales Aid Capture and Status = In Progress when Approval Step = Fully Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT EMEA Notify Business Key User upon Label shipped to Customer</fullName>
        <actions>
            <name>DPT_Nomex_Request_Shipped_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Product_Details__c</field>
            <operation>contains</operation>
            <value>DPT Nomex Labels</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Tracking_Numbers__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notify Business Key User upon Label shipped to Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT EMEA Notify Customer upon Label Order being shipped</fullName>
        <actions>
            <name>DPT_Nomex_Request_Sent_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Product_Details__c</field>
            <operation>contains</operation>
            <value>DPT Nomex Labels</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Tracking_Numbers__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notify Customer upon Label Order being shipped</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT EMEA Notify Fulfillment User upon Label Request Approval</fullName>
        <actions>
            <name>DPT_Nomex_New_Request_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Product_Details__c</field>
            <operation>contains</operation>
            <value>DPT Nomex Labels</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Fully Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Tracking_Numbers__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Notify Fulfillment House upon Label Request Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT EMEA Notify Nomex Key User upon Label Request Submission</fullName>
        <actions>
            <name>DPT_Nomex_New_Request_Created</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>DPT_nomex_Due_Date_change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - In Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Product_Details__c</field>
            <operation>contains</operation>
            <value>DPT Nomex Labels</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Capture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Request_Shipping_Street__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notify Business Key User upon Label Request Submission</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Aid - Completed</fullName>
        <actions>
            <name>SalesAidCompleted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Owning_Org__c</field>
            <operation>startsWith</operation>
            <value>DPT</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Phone Number from Contact</fullName>
        <actions>
            <name>Update_Request_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - Submitted</value>
        </criteriaItems>
        <description>This rule will Update the Phone number in the request field as per the Contact&apos;s Phone number.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>SalesAidFollowup</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Request__c.CreatedDate</offsetFromField>
        <priority>Medium</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Sales Aid - Followup</subject>
    </tasks>
</Workflow>
