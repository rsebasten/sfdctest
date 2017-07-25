<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Create_Order</fullName>
        <field>Type</field>
        <literalValue>New Order</literalValue>
        <name>Create Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CLose Group Activity</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Create Order from Tasks</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>equals</operation>
            <value>New Order</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
