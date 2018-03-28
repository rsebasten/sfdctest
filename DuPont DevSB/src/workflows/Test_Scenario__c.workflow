<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Overall_Status_to_Complete</fullName>
        <field>Overall_Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Change Overall Status to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Testing_Wave_to_2</fullName>
        <field>Testing_Wave__c</field>
        <literalValue>Wave 2</literalValue>
        <name>Change Testing Wave to 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Move_to_Next_Wave</fullName>
        <description>After the Move to Next Wave, clear the field.</description>
        <field>Move_to_Next_Wave__c</field>
        <literalValue>0</literalValue>
        <name>Clear Move to Next Wave</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_Change_Record_Type_to_Sign_off</fullName>
        <description>When the Wave is 3 and it Passes, change Record Type to Test Scenario-Sign-off</description>
        <field>RecordTypeId</field>
        <lookupValue>Test_Scenario_Sign_off</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Test: Change Record Type to Sign-off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_Chng_Overall_Status_to_In_Progress</fullName>
        <field>Overall_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Test:Chg Overall Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_Chng_Overall_Status_to_Ready_for_SO</fullName>
        <field>Overall_Status__c</field>
        <literalValue>Ready for Sign-off</literalValue>
        <name>Test Chng Overall Status to Ready for SO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_Scen_Chg_Ov_Status_to_Failed</fullName>
        <description>Changes Overall Status to Failed</description>
        <field>Overall_Status__c</field>
        <literalValue>Failed</literalValue>
        <name>Test Scen - Chg Ov Status to Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_Scen_Chg_Ov_Status_to_Not_Started</fullName>
        <description>Changes Overall Status to Not Started</description>
        <field>Overall_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Test Scen - Chg Ov Status to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Wave_2</fullName>
        <description>Updates Record type to Test Scenario-Wave 2</description>
        <field>RecordTypeId</field>
        <lookupValue>Test_Scenario_Wave_2</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Wave 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
