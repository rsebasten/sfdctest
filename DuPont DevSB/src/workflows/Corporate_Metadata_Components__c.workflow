<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_AgCo</fullName>
        <field>Targeted_AgCo__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;AgCo&quot;),&quot;AgCo&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target AgCo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_EC</fullName>
        <field>Targeted_EC__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;EC&quot;),&quot;EC&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target EC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_FMC</fullName>
        <field>Targeted_FMC__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;Remedy&quot;),&quot;FMC&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target FMC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_IB</fullName>
        <field>Targeted_IB__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;IB&quot;),&quot;IB&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target IB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_MSCRM</fullName>
        <field>Targeted_MS__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;MatCo&quot;),&quot;MatCo&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target MSCRM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_NH</fullName>
        <field>Targeted_NH__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;NH&quot;),&quot;NH&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target NH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_PS</fullName>
        <field>Targeted_PS__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;DPS&quot;),&quot;DPS&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target PS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corp_Component_Update_Target_SS</fullName>
        <field>Targeted_SS__c</field>
        <formula>IF(INCLUDES( Corporate_Package__r.Targeted_Production_Orgs__c ,&quot;DSS&quot;),&quot;DSS&quot;,&quot;&quot;)</formula>
        <name>Corp Component - Update Target SS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Target Fields</fullName>
        <actions>
            <name>Corp_Component_Update_Target_AgCo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_EC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_FMC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_IB</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_MSCRM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_NH</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_PS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Corp_Component_Update_Target_SS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
