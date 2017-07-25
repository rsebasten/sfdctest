<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VS_Build_vs_Buy</fullName>
        <field>Build_vs_Buy_Score__c</field>
        <formula>IF ( ISPICKVAL(  Build_vs_Buy__c  , &quot;Yes&quot;) , 1,0)</formula>
        <name>VS: Build vs. Buy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VS_Computational_Intensive</fullName>
        <field>Computational_Intensive_Score__c</field>
        <formula>IF ( ISPICKVAL(  Computational_Intensive__c  , &quot;Yes&quot;) , 1,0)</formula>
        <name>VS: Computational Intensive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VS_Real_Time_Transaction_Score</fullName>
        <field>Real_time_Transaction_Volumes_Score__c</field>
        <formula>IF ( ISPICKVAL( Real_time_Transaction_Volumes_Millions__c , &quot;Yes&quot;) , 1,0)</formula>
        <name>VS: Real-Time Transaction Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VS_Regulatory_Limitations_Score</fullName>
        <field>Regulatory_Limitations_Score__c</field>
        <formula>IF(LEFT( TEXT( Regulatory_Limitations__c) , 3) = &quot;Yes&quot;,1,0)</formula>
        <name>VS: Regulatory Limitations Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VS_Response_Time_Score</fullName>
        <field>Response_Time_Score__c</field>
        <formula>IF ( ISPICKVAL(   Response_Time__c  , &quot;Yes&quot;) , 1,0)</formula>
        <name>VS: Response Time Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VS_Tolerate_Maintenance_Windows_Score</fullName>
        <field>Tolerate_Maintenance_Windows_Score__c</field>
        <formula>IF ( ISPICKVAL( Tolerate_Maintenance_Windows__c , &quot;Yes&quot;) , 1,0)</formula>
        <name>VS: Tolerate Maintenance Windows Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VS%3A Force Fit</fullName>
        <actions>
            <name>VS_Build_vs_Buy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VS_Computational_Intensive</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VS_Real_Time_Transaction_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VS_Regulatory_Limitations_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VS_Response_Time_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VS_Tolerate_Maintenance_Windows_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
