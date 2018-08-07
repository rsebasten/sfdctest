<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>StatusReportSendReminderforTrackOwnerstoCreateDetails</fullName>
        <description>Status Report:  Send Reminder for Track Owners to Create Details</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>StatusReportEmails/StatusReportNotifyTrackOwners</template>
    </alerts>
    <fieldUpdates>
        <fullName>StatusReportSetStatustoInProcess</fullName>
        <description>Set the Status Report status to In-Process after the Track Owners have been notified.</description>
        <field>Status__c</field>
        <literalValue>In-Process</literalValue>
        <name>Status Report:  Set Status to In-Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusReportUpdateCustomerName</fullName>
        <description>Status Report: Update Customer Name</description>
        <field>Customer_Name__c</field>
        <formula>Project_Overview__r.Customer_Name__c</formula>
        <name>Status Report: Update Customer Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusReportUpdateProjectId</fullName>
        <description>Status Report: Update Project Id</description>
        <field>Project_Id__c</field>
        <formula>Project_Overview__r.Project_Id__c</formula>
        <name>Status Report: Update Project Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Status Report%3A  Notify Track Owners</fullName>
        <actions>
            <name>StatusReportSendReminderforTrackOwnerstoCreateDetails</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>StatusReportSetStatustoInProcess</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Status_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>Request Update from Track Owners</value>
        </criteriaItems>
        <description>Send an email reminder for track owners to populate the status report details when the status = &quot;Request Update from Track Owners&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Report%3A Set Project Related Fields</fullName>
        <actions>
            <name>StatusReportUpdateCustomerName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>StatusReportUpdateProjectId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Status_Report__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Status Report: Set Project Related Fields</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
