<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_BAC_Progress_on_Solution_Insert</fullName>
        <description>Change the BAC Progress to Solutioning Started.</description>
        <field>BAC_Progress__c</field>
        <literalValue>Solutioning Started</literalValue>
        <name>Update BAC Progress on Solution Insert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>BA_Configuration__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update BAC Progress on Solution insert</fullName>
        <actions>
            <name>Update_BAC_Progress_on_Solution_Insert</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BA_Configuration__c.BAC_Progress__c</field>
            <operation>notEqual</operation>
            <value>Solutioning Started</value>
        </criteriaItems>
        <description>Update BAC Progress on insert BA Solution.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
