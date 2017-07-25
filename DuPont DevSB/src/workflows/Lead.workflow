<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Data_Management</fullName>
        <description>Email Data Management</description>
        <protected>false</protected>
        <recipients>
            <recipient>vbhandarkar.lab@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_Converted_Email</template>
    </alerts>
    <alerts>
        <fullName>New_Customer_Data</fullName>
        <description>New Customer Data</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_Details</template>
    </alerts>
    <rules>
        <fullName>Converted Lead Emails Data Management</fullName>
        <actions>
            <name>Email_Data_Management</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Customer Data Email</fullName>
        <actions>
            <name>New_Customer_Data</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.SBU__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Shipping_Conditions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Tax_Jurisdiction_Code__c</field>
            <operation>notEqual</operation>
            <value></value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Delivery_Priority__c</field>
            <operation>notEqual</operation>
            <value></value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Credit_Risk_Profile__c</field>
            <operation>notEqual</operation>
            <value></value>
        </criteriaItems>
        <description>Email Data Group with details of New Customer</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
