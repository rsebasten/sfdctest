<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_BAC_Progress_on_FDR_Insert</fullName>
        <field>BAC_Progress__c</field>
        <literalValue>Requirements Commenced</literalValue>
        <name>Update BAC Progress on FDR Insert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>BA_Configuration__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update BAC Progress on FDR insert</fullName>
        <actions>
            <name>Update_BAC_Progress_on_FDR_Insert</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BA_Configuration__c.BAC_Progress__c</field>
            <operation>notEqual</operation>
            <value>Requirements Commenced</value>
        </criteriaItems>
        <description>Updates BAC progress  to Requirement commenced.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
