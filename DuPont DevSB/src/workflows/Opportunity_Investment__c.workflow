<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Distributor_Total_Investment</fullName>
        <description>Copies that amount in the Distributor Total Investment field into this field so that it can be rolled up into the Opportunity Total Distributor Investment. This was used as a work-around recommended by Salesforce Premier Support to solve circular error.</description>
        <field>Distributor_Total_Investment_copy__c</field>
        <formula>fDistributor_Total_Investment__c</formula>
        <name>Copy Distributor Total Investment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_DuPont_Total_Investment</fullName>
        <description>Copies that amount in the DuPont Total Investment field into this field so that it can be rolled up into the Opportunity Total DuPont Investment. This was used as a work-around recommended by Salesforce Premier Support to solve circular reference error.</description>
        <field>DuPont_Total_Investment_copy__c</field>
        <formula>fDuPont_Total_Investment__c</formula>
        <name>Copy DuPont Total Investment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>All Opportunity Investments new and modified</fullName>
        <actions>
            <name>Copy_Distributor_Total_Investment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_DuPont_Total_Investment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Actions to take any time an Opportunity Investment record is created or modified</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
