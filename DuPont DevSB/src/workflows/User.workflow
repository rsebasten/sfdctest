<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Convert_User_Ref_ID_to_EPass_ID</fullName>
        <description>Convert to text and Copy User Ref ID to EPass</description>
        <field>EPass_ID__c</field>
        <formula>User_Ref_ID__c</formula>
        <name>Convert User Ref ID to EPass ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>E_Pass_Id_to_LowerCase</fullName>
        <description>Update the value in E-Pass Id to Lower Case</description>
        <field>EPass_ID__c</field>
        <formula>LOWER( EPass_ID__c )</formula>
        <name>E-Pass Id to LowerCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Federation_Id_to_LowerCase</fullName>
        <description>Update the value in Federation Id to Lower Case</description>
        <field>FederationIdentifier</field>
        <formula>LOWER( FederationIdentifier )</formula>
        <name>Federation Id to LowerCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update to Lower Case</fullName>
        <actions>
            <name>E_Pass_Id_to_LowerCase</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Federation_Id_to_LowerCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.EPass_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.FederationIdentifier</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Modify the values in the fields E-Pass Id and Federation Id to Lower Case</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Ref ID to EPass ID</fullName>
        <actions>
            <name>Convert_User_Ref_ID_to_EPass_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.UserType</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Copy User Ref ID To EPass ID for Partner Users</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
