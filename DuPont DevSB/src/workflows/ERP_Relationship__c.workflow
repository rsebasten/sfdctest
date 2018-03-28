<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CS_UpdateERPCustomerYKPartnerFieldUpdate</fullName>
        <description>This WorkFlow Action will update the YKPartnerCode Field on ERP Customer Object with Partner Code Value of ERP Relationship Record.</description>
        <field>ERP_YKPartnerCode__c</field>
        <formula>Partner_Code__c</formula>
        <name>CS_UpdateERPCustomerYKPartnerFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ERP_Customer__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CS_UpdateERPCustomerYKPartnerCode</fullName>
        <actions>
            <name>CS_UpdateERPCustomerYKPartnerFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ERP_Relationship__c.Partner_Function_Code__c</field>
            <operation>equals</operation>
            <value>YK</value>
        </criteriaItems>
        <description>This WorkFlow Action will update the YKPartnerCode Field on ERP Customer Object with Partner Function Code Value of ERP Relationship Record with Partner Code Value as YK.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
