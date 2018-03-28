<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dissatisfied_Feedback</fullName>
        <description>Dissatisfied Feedback</description>
        <protected>false</protected>
        <recipients>
            <recipient>madhu.reddipalli_corp@tcs.com.pscrm</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>All/Dissatisfied_Feedback</template>
    </alerts>
    <alerts>
        <fullName>Dissatisfied_Feedback_For_SFAR</fullName>
        <description>Dissatisfied Feedback For SFAR</description>
        <protected>false</protected>
        <recipients>
            <recipient>madhu.reddipalli_corp@tcs.com.pscrm</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>All/Dissatisfied_Feedback_For_SFAR</template>
    </alerts>
    <rules>
        <fullName>Dissatisfied Feedback</fullName>
        <actions>
            <name>Dissatisfied_Feedback</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Survey__c.Q3__c</field>
            <operation>equals</operation>
            <value>Dissatisfied,Very Dissatisfied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey__c.Q2__c</field>
            <operation>equals</operation>
            <value>Dissatisfied,Very Dissatisfied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey__c.Q1__c</field>
            <operation>equals</operation>
            <value>Dissatisfied,Very Dissatisfied</value>
        </criteriaItems>
        <criteriaItems>
            <field>Survey__c.Issue_ID_del__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
