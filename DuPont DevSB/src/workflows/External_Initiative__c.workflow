<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CPSF_Update_External_Initiaticve_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>mcgrawhillintegrator@dupont.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>CPSF Update External Initiaticve Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPSF Update External Initiative Owner</fullName>
        <actions>
            <name>CPSF_Update_External_Initiaticve_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Data_Source__c) = $Label.External_Initiative_Data_Source  &amp;&amp;  Owner:User.Username = $Label.Batch_SFDC_Deploy_User_Name</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
