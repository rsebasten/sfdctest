<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BI_NA_Surfaces_Change_Case_Material_PL</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BI_NA_Surfaces_Read_Only_Page</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>BI NA Surfaces Change Case Material PL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BI NA Surfaces Read Only Case Material Page</fullName>
        <actions>
            <name>BI_NA_Surfaces_Change_Case_Material_PL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Material__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI NA Surfaces Material</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Material__c.ERP_Transaction_Nb__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
