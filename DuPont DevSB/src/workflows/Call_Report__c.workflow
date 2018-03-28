<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DPTNOWNewNACallReportCreatednotification</fullName>
        <description>DPT-NOW - New NA Call Report Created notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>leslie.a.love@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NOW/NOWCallReportCreateNotification</template>
    </alerts>
    <alerts>
        <fullName>DPT_Aramids_New_NA_Call_Report_Created_notification</fullName>
        <description>DPT-Aramids - New NA Call Report Created notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>marta.l.hilton@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AFS/DPT_Aramids_Call_Report_Created_Notification</template>
    </alerts>
    <rules>
        <fullName>DPT-NOW NA Call Report created</fullName>
        <actions>
            <name>DPTNOWNewNACallReportCreatednotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-NOW</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Region__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-NOW Call Report</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Program__c</field>
            <operation>equals</operation>
            <value>DPT-NOW-PH</value>
        </criteriaItems>
        <description>Workflow to send a notification to DPT-NOW Global Sales &amp; Marketing Manager when new Call Report is created by a member of the DPT-NOW NA Sales Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT-Nomex NA Call Report</fullName>
        <actions>
            <name>DPT_Aramids_New_NA_Call_Report_Created_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-Aramids</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Region__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Call_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-Aramids Call Report</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Owning_Organization__c</field>
            <operation>equals</operation>
            <value>DPT-Thermal Apparel,DPT-Composite Solutions,DPT-Energy Solutions</value>
        </criteriaItems>
        <description>Workflow to send a notification to DPT-Aramids Global Sales &amp; Marketing Manager when new Call Report is created by a member of the DPT-Aramids NA Sales Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
