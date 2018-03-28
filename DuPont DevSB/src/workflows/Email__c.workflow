<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Privacy_Notification</fullName>
        <description>Send Privacy Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customer-privacy@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Privacy_Notifications/Notice_All</template>
    </alerts>
    <fieldUpdates>
        <fullName>Privacy_Notification_Notified</fullName>
        <description>Updates Privacy Notification To &apos;Notified&apos;</description>
        <field>Privacy_Notification__c</field>
        <literalValue>Notified</literalValue>
        <name>Set Privacy Notification To Notified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Send Privacy Notification</fullName>
        <actions>
            <name>Send_Privacy_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Privacy_Notification_Notified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Privacy_Notification_Task</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Email__c.Privacy_Notification__c</field>
            <operation>equals</operation>
            <value>Not Notified</value>
        </criteriaItems>
        <description>Send Privacy Notification</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Privacy_Notification_Task</fullName>
        <assignedTo>lisa.mcshane@lux.dupont.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>A Notification has been sent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Privacy Notification Task</subject>
    </tasks>
</Workflow>
