<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Last_QATest_Run_Date</fullName>
        <field>Last_Run_Date__c</field>
        <formula>Test_Run_Date__c</formula>
        <name>Update Last QATest Run Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>QATest_Script__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_QATest_Run_Verdict</fullName>
        <field>Last_Run_Verdict__c</field>
        <formula>TEXT( Test_Run_Verdict__c)</formula>
        <name>Update Last QATest Run Verdict</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>QATest_Script__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_QATest_Run</fullName>
        <field>Test_Run_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Update QATest Run Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>QATest Run added or updated</fullName>
        <actions>
            <name>Update_Last_QATest_Run_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_QATest_Run_Verdict</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_QATest_Run</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>QATest_Run__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>ISBLANK()</value>
        </criteriaItems>
        <criteriaItems>
            <field>QATest_Run__c.Test_Run_Verdict__c</field>
            <operation>equals</operation>
            <value>Testing In Progress</value>
        </criteriaItems>
        <description>This rule updates the QATest Script object each time a new test run is created or if last status was &quot;Testing In Progress&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
