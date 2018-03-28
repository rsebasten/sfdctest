<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CS_UpdateERPCustomerOnNullYKPartnerCode</fullName>
        <description>This Workflow field update  the YK Partner Code Field as Null when there is no any associated ERP Relation Record with Partnet Value as YK.</description>
        <field>ERP_YKPartnerCode__c</field>
        <name>CS_UpdateERPCustomerOnNullYKPartnerCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CS_UpdateERPCustomerOnNullYKPartner</fullName>
        <actions>
            <name>CS_UpdateERPCustomerOnNullYKPartnerCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ERP_Customer__c.ERP_YKPartnerCount__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>This workflow will update the YK Partner Field value on ERP Customer as NULL based on Rollup Summary field YK Partner Count,created as per PMO Requirement 169.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
