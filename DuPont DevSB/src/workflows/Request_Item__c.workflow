<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Estimate_update</fullName>
        <field>Estimated_Value__c</field>
        <formula>VALUE( Catalog_Item__r.Estimated_Value__c ) * Quantity__c</formula>
        <name>Estimate update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Sales_Aid_In_App</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Sales_Aid_In_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Sales Aid - In App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>Request__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RequestItem_Status_to_Not_Started</fullName>
        <description>Updating the Request Item&apos;s Status to &quot;Not Started&quot;.</description>
        <field>Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Update RequestItem Status to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Not_Started</fullName>
        <description>Update Stage to Not Started.</description>
        <field>Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Update Stage to Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Request__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Supplier_Name_On_Request</fullName>
        <field>Fulfillment_Supplier__c</field>
        <formula>Supplier_Name__c</formula>
        <name>Update Supplier Name On Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Request__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>DPT EMEA Nomex Sales Aid Request Item</fullName>
        <actions>
            <name>Update_Record_Type_to_Sales_Aid_In_App</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_RequestItem_Status_to_Not_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Not_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Request_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid Item - Capture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - Capture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Product_Details__c</field>
            <operation>contains</operation>
            <value>DPT Nomex Labels</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request_Item__c.Quantity_Limit_Max_Action__c</field>
            <operation>equals</operation>
            <value>Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Request Item Estimated Rule</fullName>
        <actions>
            <name>Estimate_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request_Item__c.Quantity__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Aid Samples Request Workflow Rule</fullName>
        <actions>
            <name>Update_Record_Type_to_Sales_Aid_In_App</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_RequestItem_Status_to_Not_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Not_Started</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5 AND (6 OR 7 OR 8)</booleanFilter>
        <criteriaItems>
            <field>Request_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid Item - Capture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Aid - Capture</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Rejected by Business Unit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Approval_Step__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Request_Item__c.Quantity_Limit_Max_Action__c</field>
            <operation>equals</operation>
            <value>Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>P&amp;IP Ethylene Copolymers - LA,DPT - LA</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator,I2C Engagement Leader - LA,P&amp;IP Content Manager,DPP-Polymers Manager,DPP-Polymers Standard User,DPP-Polymers Leads Content Manager,DPP Parts Poly Standard User,DPP Parts Poly Content Manager,DPP-Polymers Content Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>DPP-Polymers Standard CUPS PA User</value>
        </criteriaItems>
        <description>Used to change the Record Type and  Stage, when its coming from the Catalog Item Wizard, so that we can have an Approval process before going ahead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
