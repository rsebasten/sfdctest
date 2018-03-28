<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Expected_Results</fullName>
        <field>Expected_Result__c</field>
        <formula>Test_Scenario__r.Expected_Result__c</formula>
        <name>Update Expected Results</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Test_Data</fullName>
        <field>Test_Data__c</field>
        <formula>Test_Scenario__r.Testing_Data__c</formula>
        <name>Update Test Data</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
