<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CS_StatusUpdate</fullName>
        <description>Workflow Action will update the case status.</description>
        <field>Status</field>
        <literalValue>Reply Received</literalValue>
        <name>CS_StatusUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CS_UpdateCaseStatus</fullName>
        <actions>
            <name>CS_StatusUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will update the Case Status upon receiving an inbound email on Dupont Customer Service Email Address created as per requirement RID#147</description>
        <formula>Incoming = True &amp;&amp;(CONTAINS(ToAddress, $Label.CS_EmailToCase)||  CONTAINS(CcAddress, $Label.CS_EmailToCase)||  CONTAINS(ToAddress, $Label.CS_EmailToCase_SR)||  CONTAINS(CcAddress, $Label.CS_EmailToCase_SR)||  CONTAINS(ToAddress, $Label.CS_EmailToCase_OR)||  CONTAINS(CcAddress, $Label.CS_EmailToCase_OR)|| CONTAINS(ToAddress, $Label.CS_EmailToCase_OR_CSCC)||  CONTAINS(CcAddress, $Label.CS_EmailToCase_OR_CSCC)||  CONTAINS(ToAddress, $Label.CS_EmailToCase_SR_CSCC)||  CONTAINS(CcAddress, $Label.CS_EmailToCase_SR_CSCC)|| CONTAINS(ToAddress, $Label.CS_EmailToCase_OR_CSCNA)||  CONTAINS(CcAddress, $Label.CS_EmailToCase_OR_CSCNA)||  CONTAINS(ToAddress, $Label.CS_EmailToCase_SR_CSCNA)||  CONTAINS(CcAddress, $Label.CS_EmailToCase_SR_CSCNA)) &amp;&amp; Parent.fCaseAge__c &gt; 0.01</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
