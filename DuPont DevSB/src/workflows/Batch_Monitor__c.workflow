<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SFSCNotifyExceptionAlert</fullName>
        <description>SFSCNotifyExceptionAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Notifications/NotifyException</template>
    </alerts>
    <rules>
        <fullName>NotifySFSCException</fullName>
        <actions>
            <name>SFSCNotifyExceptionAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Batch_Monitor__c.Status__c</field>
            <operation>equals</operation>
            <value>Exception</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
