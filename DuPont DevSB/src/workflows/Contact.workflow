<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Invalid_Contact_Email_Address_alert</fullName>
        <description>Invalid Contact Email Address alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPP_EMEA/DPT_IPP_EMEA_invalid_Contact_Email_Address</template>
    </alerts>
    <fieldUpdates>
        <fullName>BI_EMEA_Registration_Contact_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>giada.menda@ita.dupont.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>BI-EMEA Registration - Contact Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Year_in_BirthDate</fullName>
        <field>Birthdate</field>
        <formula>DATE(1804, MONTH(Birthdate), DAY(Birthdate))</formula>
        <name>Update Year in BirthDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BI-EMEA Registration - Contact Owner reassignment</fullName>
        <actions>
            <name>BI_EMEA_Registration_Contact_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.OwnerId</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <description>BI-EMEA warranty registration - Contact Owner reassignment</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DPT-IPP EMEA invalid Contact Email Address Alert</fullName>
        <actions>
            <name>Invalid_Contact_Email_Address_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Data_Quality__c</field>
            <operation>includes</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-IPP EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-EMEA</value>
        </criteriaItems>
        <description>Triggers Email to contact Owner if Data Quality in Contact record includes Email.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update BirthDate</fullName>
        <actions>
            <name>Update_Year_in_BirthDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Birthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow to update the Birthdate of the User to 1804 to maintain Privacy</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
