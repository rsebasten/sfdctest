<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>COB_Queue_Watcher_Email_Alert</fullName>
        <description>COB Queue Watcher Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Queue_Watcher</template>
    </alerts>
    <alerts>
        <fullName>Credit_Refuse</fullName>
        <description>Credit Refuse</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Credit_Refuse1</template>
    </alerts>
    <alerts>
        <fullName>DMS_Refusal</fullName>
        <description>DMS Refusal</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/DMS_Refuse1</template>
    </alerts>
    <alerts>
        <fullName>Email_for_queue_watcher_notification</fullName>
        <description>COB Queue Watcher Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Queue_Watcher</template>
    </alerts>
    <alerts>
        <fullName>Generic_Notification_After_Credit_Analysis_Approval</fullName>
        <description>Generic Notification After Credit Analysis Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Credit_Analysis</template>
    </alerts>
    <alerts>
        <fullName>Generic_Notification_after_Data_Gathering</fullName>
        <description>Generic Notification after Data Gathering</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Gathering1</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Closing_After_Data_Gathering</fullName>
        <description>Notification After Closing After Data Gathering</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Send_Notification_On_Closing_After_Data_Gathering</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Credit_Analysis</fullName>
        <description>Notification After Credit Analysis</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Credit_Analysis</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Credit_Analysis_Approval</fullName>
        <description>Notification After Credit Analysis Approval for DPT</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Credit_Analysis</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Credit_Analysis_Approval_for_DPP</fullName>
        <ccEmails>Preethi.chandrasekaran02@gmail.com</ccEmails>
        <description>Notification After Credit Analysis Approval for DPP</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Credit_Analysis</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_DOA_Approval</fullName>
        <description>Notification After DOA Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_DOA_Approval</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Data_Deliver</fullName>
        <description>Notification After Data Delivery</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Delivery1</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Data_Delivery</fullName>
        <ccEmails>Preethi.chandrasekaran02@gmail.com</ccEmails>
        <description>Notification After Data Delivery for DPT</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>shyamlal.patnaik@ind.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Delivery1</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Data_Delivery_for_DPP</fullName>
        <description>Notification After Data Delivery for DPP</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Delivery1</template>
    </alerts>
    <alerts>
        <fullName>Notification_After_Data_Delivery_for_P_IP</fullName>
        <description>Notification After Data Delivery for P&amp;IP</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Delivery1</template>
    </alerts>
    <alerts>
        <fullName>Notification_after_Data_Gathering</fullName>
        <ccEmails>Preethi.chandrasekaran02@gmail.com</ccEmails>
        <description>Notification after Data Gathering</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Gathering1</template>
    </alerts>
    <alerts>
        <fullName>Notification_after_Data_Gathering_except_New_Customer</fullName>
        <description>Notification after Data Gathering except New Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_After_Data_Gathering_except_New_Customer1</template>
    </alerts>
    <alerts>
        <fullName>Request_sent_for_Re_work</fullName>
        <description>Request sent for Re-work</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_to_CSR_team_indicating_Re_Work_on_a_Request1</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_After_Data_Delivery</fullName>
        <description>Send Notification After Data Delivery</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Send_Notification_After_Data_Delivery1</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_back_to_CSR_from_CA</fullName>
        <description>Send Notification back to CSR from CA</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Send_Notification_back_to_CSR_from_CA1</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_back_to_CSR_from_DCA</fullName>
        <description>Send Notification back to CSR from DCA</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Send_Notification_back_to_CSR_from_DCA1</template>
    </alerts>
    <alerts>
        <fullName>Send_Request_back_to_CA</fullName>
        <ccEmails>Preethi.chandrasekaran02@gmail.com</ccEmails>
        <ccEmails>bhuvanesh.purohit@gmail.com</ccEmails>
        <description>Mail to requestor when sent back from DMS to CA</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Notification_to_Requestor_when_sent_back_from_DMS_to_CA</template>
    </alerts>
    <alerts>
        <fullName>Send_Request_back_to_CSR</fullName>
        <description>Send Request back to CSR</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COB_Email_Templates/Send_Notification_back_to_CSR1</template>
    </alerts>
    <fieldUpdates>
        <fullName>COB_Last_Modified_Time_field_update</fullName>
        <description>Updating the field Last Modified Time every time there is a request status change</description>
        <field>Last_Modified_Time__c</field>
        <formula>now()</formula>
        <name>COB_Last Modified Time_field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Draft_Data_Gathering_time_update_on_save</fullName>
        <description>Draft/Data Gathering time update on save</description>
        <field>Data_Draft_Gathering_Time__c</field>
        <formula>LastModifiedDate   -  CreatedDate</formula>
        <name>Draft/Data Gathering time update on save</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Erase_Bank_Number_details_update</fullName>
        <description>Erase the Bank Account Number once the request is moved from One dupont org to Utility.</description>
        <field>Bank_Account__c</field>
        <name>Erase Bank Number details update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_Customer_Data_Request_Record</fullName>
        <field>Record_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Lock Customer Data Request Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Cust_Data_Req_Status_to_Closed</fullName>
        <field>Request_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Update Cust Data Req Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proposed_Reference_Date</fullName>
        <description>Update Proposed Reference Date to Today</description>
        <field>Proposed_Reference_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Proposed Reference Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_to_Utility</fullName>
        <field>Send_To_Utility__c</field>
        <literalValue>1</literalValue>
        <name>Update Send to Utility</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sent_to_Utility</fullName>
        <field>Sent_To_Utility__c</field>
        <literalValue>0</literalValue>
        <name>Update Sent to Utility</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>COB Queue Watchers</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Data_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Draft/Data Gathering</value>
        </criteriaItems>
        <description>Workflow to send an email notification to the owner of the request if the request has not been modified since three days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_for_queue_watcher_notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Customer_Data_Request__c.LastModifiedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>COB_Update Draft%2FData Gathering on save</fullName>
        <actions>
            <name>Draft_Data_Gathering_time_update_on_save</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updating Draft/Data Gathering time on saving a record</description>
        <formula>ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)&amp;&amp; ( IF( ISNEW(), true, false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>COB_Update of Last Modified Time Field</fullName>
        <actions>
            <name>COB_Last_Modified_Time_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updation of &quot;Last Modified Time&quot; field when the request is sent from Utility to CRM</description>
        <formula>ISCHANGED( Request_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Refuse</fullName>
        <actions>
            <name>Credit_Refuse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>To process when a request is rejected by a credit analyst</description>
        <formula>( ((RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;) &amp;&amp; (Credit_Approval_Required__c == true)) || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; ) &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;)) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Rejected&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DMS Refuse</fullName>
        <actions>
            <name>DMS_Refusal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>To process when a request is rejected by the data analyst.</description>
        <formula>(RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos;  || RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;  || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; ||RecordType.DeveloperName = &apos;Miscellaneous_customer_data_request&apos;  || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; )  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Data Analyst (DMS Team) Approval&apos;))  &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Rejected&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Erase Bank Number details</fullName>
        <actions>
            <name>Erase_Bank_Number_details_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Data_Request__c.Sent_To_Utility__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Erase Bank name once the request is Sent to Utility</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposed Reference Date</fullName>
        <actions>
            <name>Update_Proposed_Reference_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Data_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Customer Creation</value>
        </criteriaItems>
        <description>Update Proposed Reference Date To Today If Record Type is New Customer Data Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Request sent for Re-work</fullName>
        <actions>
            <name>Request_sent_for_Re_work</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sent notification to CSR regarding re-opening of a request</description>
        <formula>(RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos;  ||  RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;  || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; ||RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos;)  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Request Completed in SAP&apos;)) &amp;&amp;(ISPICKVAL(Request_Status__c,&apos;Request Sent for Re-Work&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Closing After Data Gathering</fullName>
        <actions>
            <name>Notification_After_Closing_After_Data_Gathering</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow is for sending a notification to the requestor when the request status is changed to closed from draft/data gathering</description>
        <formula>(RecordType.DeveloperName = &apos;New_Customer_Creation&apos; || RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos; || RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos; || RecordType.DeveloperName = &apos;Miscellaneous_customer_data_request&apos;|| RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos;) &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Draft/Data Gathering&apos;)) &amp;&amp; NOT(ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)) &amp;&amp; (ISPICKVAL(Request_Status__c,&apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Credit Analysis</fullName>
        <actions>
            <name>Notification_After_Credit_Analysis</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Manager after the Credit Analysis Phase</description>
        <formula>(RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; || RecordType.DeveloperName = &apos;Modify_Finance_Credit_Terms_Data&apos;) &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;)) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Awaiting Data Analyst (DMS Team) Approval&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Credit Analysis Approval</fullName>
        <actions>
            <name>Generic_Notification_After_Credit_Analysis_Approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Notification_After_Credit_Analysis_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Manager after the Credit Analysis Phase - New Customer Creation</description>
        <formula>RecordType.DeveloperName = &apos;New_Customer_Creation&apos; &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;)) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Awaiting Data Analyst (DMS Team) Approval&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Credit Analysis except new Customer Creation</fullName>
        <actions>
            <name>Notification_After_Credit_Analysis</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Requestor after the Credit Analysis Phase</description>
        <formula>(RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos;  || ((RecordType.DeveloperName = &apos;Modify_Finance_Credit_Terms_Data&apos;) &amp;&amp; (Credit_Approval_Required__c == true)) )  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;))  &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Awaiting Data Analyst (DMS Team) Approval&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Credit Analysis for DPT</fullName>
        <actions>
            <name>Notification_After_Credit_Analysis_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Manager after the Credit Analysis Phase - New Customer Creation</description>
        <formula>RecordType.DeveloperName = &apos;New_Customer_Creation&apos; &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;)) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Awaiting Data Analyst (DMS Team) Approval&apos;)&amp;&amp; ISPICKVAL(Sub_Business__c, &apos;DPT&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After DOA Approval</fullName>
        <actions>
            <name>Notification_After_DOA_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Manager after DOA Phase - New Customer Creation</description>
        <formula>RecordType.DeveloperName = &apos;New_Customer_Creation&apos; &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;)) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Awaiting DOA approval&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Data Delivery</fullName>
        <actions>
            <name>Notification_After_Data_Deliver</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Manager after the Data Delivery Phase</description>
        <formula>((RecordType.DeveloperName = &apos;New_Customer_Creation&apos;)||((RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;) &amp;&amp; (Credit_Approval_Required__c == true)) ) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Request Completed in SAP&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Data Delivery - except new customer creation</fullName>
        <actions>
            <name>Send_Notification_After_Data_Delivery</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification On completion Of Data Delivery - Add New Contact , Add New Partner function, Modify Address, Modify General Data &amp; Modify Sales Area Data</description>
        <formula>(RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos;||((RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;) &amp;&amp; (Credit_Approval_Required__c == false))|| RecordType.DeveloperName = &apos;Miscellaneous_customer_data_request&apos;   || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos;)  &amp;&amp; (ISPICKVAL(Request_Status__c,&apos;Request Completed in SAP&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Data Delivery for DPT</fullName>
        <actions>
            <name>Notification_After_Data_Delivery</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to DPT Manager after the Data Delivery Phase - New Customer Creation</description>
        <formula>(RecordType.DeveloperName = &apos;New_Customer_Creation&apos;) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Request Completed in SAP&apos;)&amp;&amp; ISPICKVAL(Sub_Business__c, &apos;DPT&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Data Gathering</fullName>
        <actions>
            <name>Generic_Notification_after_Data_Gathering</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Manager after the Draft/Data Gathering Phase</description>
        <formula>(RecordType.DeveloperName = &apos;New_Customer_Creation&apos;) &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Draft/Data Gathering&apos;)||IF(ISNEW(),true,false)) &amp;&amp; NOT(ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)) &amp;&amp;  Record_Locked__c == true &amp;&amp;  Send_To_Utility__c ==true &amp;&amp; NOT(ISPICKVAL(Request_Status__c,&apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Data Gathering except New Customer</fullName>
        <actions>
            <name>Notification_after_Data_Gathering_except_New_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to Requester after the Draft/Data Gathering Phase except New Customer Creation</description>
        <formula>(RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos; || RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos; || RecordType.DeveloperName = &apos;Miscellaneous_customer_data_request&apos;|| RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos;)  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Draft/Data Gathering&apos;)||IF(ISNEW(),true,false)) &amp;&amp; NOT(ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)) &amp;&amp; Record_Locked__c == true &amp;&amp; NOT(ISPICKVAL(Request_Status__c,&apos;Closed&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification After Data Gathering for DPT</fullName>
        <actions>
            <name>Notification_after_Data_Gathering</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send Notification to DPT Manager after the Draft/Data Gathering Phase</description>
        <formula>(RecordType.DeveloperName = &apos;New_Customer_Creation&apos;)  &amp;&amp;  ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Draft/Data Gathering&apos;) &amp;&amp; NOT(ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)) &amp;&amp;  Record_Locked__c == true &amp;&amp;  ISPICKVAL(Sub_Business__c, &apos;DPT&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send request back to CSR from CA</fullName>
        <actions>
            <name>Send_Notification_back_to_CSR_from_CA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send request back to CSR from CA</description>
        <formula>( ((RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;) &amp;&amp; (Credit_Approval_Required__c == true)) || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; )  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Credit Approval&apos;))  &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send request back to CSR from DCA</fullName>
        <actions>
            <name>Send_Notification_back_to_CSR_from_DCA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send request back to CSR from DCA</description>
        <formula>( ((RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;) &amp;&amp; (Credit_Approval_Required__c == true)) || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; )  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Destination Credit Approval&apos;))  &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send request back to CSR from DMS</fullName>
        <actions>
            <name>Send_Request_back_to_CSR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send request back to CSR</description>
        <formula>(RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos;  ||  RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;  || RecordType.DeveloperName = &apos;Miscellaneous_customer_data_request&apos;  || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; )  &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Awaiting Data Analyst (DMS Team) Approval&apos;) || ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Request Sent for Re-Work&apos;) ) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send request back to CSR from DMS after re-work</fullName>
        <actions>
            <name>Send_Request_back_to_CSR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send request back to CSR from DMS after re-work</description>
        <formula>(RecordType.DeveloperName = &apos;Create_partner_function_Link_Contact_Link_Existing_Partner&apos;  || RecordType.DeveloperName = &apos;Modify_Existing_Customer_Data&apos;  || RecordType.DeveloperName = &apos;Extend_Existing_Customer&apos; || RecordType.DeveloperName = &apos;New_Customer_Creation&apos; ) &amp;&amp; (ISPICKVAL(PRIORVALUE(Request_Status__c),&apos;Request Sent for Re-Work&apos;)) &amp;&amp; ISPICKVAL(Request_Status__c,&apos;Draft/Data Gathering&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer Data Request Status</fullName>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Customer_Data_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Request Completed in SAP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Data_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Extend Existing Customer,Create partner function/Link Contact/Link Existing Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Data_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Modify Existing Customer Data</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Data_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Customer Creation,Miscellaneous customer data request</value>
        </criteriaItems>
        <description>To auto close the Customer Data Request after 10 days of entering into SAP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lock_Customer_Data_Request_Record</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Cust_Data_Req_Status_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Send_to_Utility</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Sent_to_Utility</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
