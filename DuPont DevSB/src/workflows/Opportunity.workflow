<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CloseDate</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Start_Date</fullName>
        <field>Start_Date__c</field>
        <formula>Today()</formula>
        <name>Start_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCloseDate</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Close Date to Stalled Opportunities</fullName>
        <actions>
            <name>CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateCloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ThreeMonthStalledOpportunity</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Stalled</value>
        </criteriaItems>
        <description>When status of Opportunity changes to Stalled, populate Close Date with current date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pre-Populate Start Date</fullName>
        <actions>
            <name>Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Populate the Start Date field in Opportunity with the current date for all new Opportunities.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>ThreeMonthStalledOpportunity</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Opportunity was Stalled 3 Months ago and needs to be revisited to find out about any positive developments.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Deferred</status>
        <subject>Three Month Stalled Opportunity.</subject>
    </tasks>
</Workflow>
