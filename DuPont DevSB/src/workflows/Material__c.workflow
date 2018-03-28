<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>ERP CEDW DPT Update Material Owner</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Material__c.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Material__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ERP Product</value>
        </criteriaItems>
        <criteriaItems>
            <field>Material__c.Owning_Organization_Code__c</field>
            <operation>equals</operation>
            <value>95GE999</value>
        </criteriaItems>
        <description>DPT Material Owner update rules for ERP FRB4 95GE999 CEDW SFDC data (Record Type = ERP Product)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW FH006CH BI Update Material Owner</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Material__c.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Material__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ERP Product</value>
        </criteriaItems>
        <criteriaItems>
            <field>Material__c.Owning_Organization_Code__c</field>
            <operation>equals</operation>
            <value>FH006CH</value>
        </criteriaItems>
        <description>BI Material Owner update rule for ERP FRB4 FH006CH CEDW SFDC data
(Record Type = ERP Product)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
