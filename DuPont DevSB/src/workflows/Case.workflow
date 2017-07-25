<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Opened</fullName>
        <description>Case Opened</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Case_Opened</template>
    </alerts>
    <alerts>
        <fullName>Case_Short_Description_Change</fullName>
        <description>Case Change Existing Customer</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Case_Short_Description_Modified</template>
    </alerts>
    <alerts>
        <fullName>Email_to_nitify_of_Case_Escalation</fullName>
        <description>Email to notify of Case Escalation</description>
        <protected>false</protected>
        <recipients>
            <recipient>derek.auth@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>uma.auth@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Escalated</template>
    </alerts>
    <alerts>
        <fullName>GS_Email_Alert_Me</fullName>
        <ccEmails>gsing25@gmail.com</ccEmails>
        <description>GS: Email Alert Me</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/GS_Approval_REquest</template>
    </alerts>
    <rules>
        <fullName>Alert CSR Case Updated</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Comments</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Alert the CSR that the case has been updated.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Change Existing Customer Email</fullName>
        <actions>
            <name>Case_Short_Description_Change</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Short_Description__c</field>
            <operation>equals</operation>
            <value>Customer: Change Existing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Opened Email</fullName>
        <actions>
            <name>Case_Opened</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Emaile Derek when case is opened.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Create Order</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SubType__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Case Short Description Change</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Short_Description__c</field>
            <operation>equals</operation>
            <value>Customer: Change Existing,Hybris: New Customer,End of Consignment,Investigate Delivery,New Business Requirement,Problem with Sales Order,Warehouse Follow-Up</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Case for Short Description Change</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Short_Description__c</field>
            <operation>equals</operation>
            <value>Customer: Change Existing,Hybris: New Customer,End of Consignment,Investigate Delivery,New Business Requirement,Problem with Sales Order,Warehouse Follow-Up</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Cases Details to Warehouse</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>equals</operation>
            <value>Warehouse</value>
        </criteriaItems>
        <description>When Warehouse is seletect for department, this email is sent.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Eamil</fullName>
        <actions>
            <name>Email_to_nitify_of_Case_Escalation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Escalate_to__c</field>
            <operation>equals</operation>
            <value>Credit Specialist,Security,MDG Group,SH&amp;E,CSR Operations Support</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
