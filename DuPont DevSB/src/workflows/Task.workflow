<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_DPS_task_creator_when_a_task_has_been_completed</fullName>
        <description>Notify DPS task creator when a task has been completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alert_Templates/Notify_Creator_when_a_task_has_been_completed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_completed</fullName>
        <description>Status to be completed when Type = Customer Follow up (DEC) and Type = NDA</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Status completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type</fullName>
        <description>Update the Task Type field with the value from the Text(Type)</description>
        <field>Rpt_Activity_Type__c</field>
        <formula>Text(Type)</formula>
        <name>Task Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DPS Task Completed email notification</fullName>
        <actions>
            <name>Notify_DPS_task_creator_when_a_task_has_been_completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPS Task</value>
        </criteriaItems>
        <description>Notify DPS original task creator that a task has been completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type</fullName>
        <actions>
            <name>Task_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
