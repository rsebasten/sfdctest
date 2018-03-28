<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ChangeActiveFalse</fullName>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>ChangeActiveFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeBACProgress</fullName>
        <field>BAC_Progress__c</field>
        <literalValue>New Campaigns</literalValue>
        <name>ChangeBACProgress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ChangeActiveFalse</fullName>
        <actions>
            <name>ChangeActiveFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BA_Configuration__c.Status__c</field>
            <operation>equals</operation>
            <value>Campaign Closed</value>
        </criteriaItems>
        <description>changes active as false when status changes to Closed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ChangeBACProgress</fullName>
        <actions>
            <name>ChangeBACProgress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BA_Configuration__c.Status__c</field>
            <operation>equals</operation>
            <value>Pre- Tender Solicitation</value>
        </criteriaItems>
        <description>changes bac progress value on creating new Campaign.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
