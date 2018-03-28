<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BI_EMEA_Registration_Account_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>giada.menda@ita.dupont.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>BI-EMEA Registration - Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BI-EMEA Registration - Account Owner reassignment</fullName>
        <actions>
            <name>BI_EMEA_Registration_Account_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction-EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <description>BI-EMEA warranty registration - Account Owner reassignment</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW DPT-IPP 95TYVTP Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB5_Code__c</field>
            <operation>equals</operation>
            <value>95TYVTP</value>
        </criteriaItems>
        <description>DPT-IPP Account Update rules for FRB5: 95TYVTP (DPT-TYVEK) CEDW SFDC data</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW DPT-NOW 95SONPF Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB5_Code__c</field>
            <operation>equals</operation>
            <value>95SONPF</value>
        </criteriaItems>
        <description>DPT-NOW Account update rules for FRB5: 95SONPF (SONTARA-PLN) CEDW SFDC data</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW DPT-PM Aramids Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB5_Code__c</field>
            <operation>equals</operation>
            <value>BA03841</value>
        </criteriaItems>
        <description>DPT-PM Account update rules for FRB5: BA03841 (ARAMIDS) CEDW SFDC data</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW DPT-PM Kevlar Nomex Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB5_Code__c</field>
            <operation>equals</operation>
            <value>95KEV00,95NOM88</value>
        </criteriaItems>
        <description>DPT Account update rules for FRB5: 95KEV00 (KEVLAR-PLN) and 95NOM88 (NOMEX-PL) CEDW SFDC data</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW FH006CH BI-AP Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB4_Code__c</field>
            <operation>equals</operation>
            <value>FH006CH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Asia Pacific</value>
        </criteriaItems>
        <description>BI-AP Account update rules for FRB4: FH006CH CEDW SFDC data
(Building Innovations : Building &amp; Construction : Construction)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW FH006CH BI-EMEA Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB4_Code__c</field>
            <operation>equals</operation>
            <value>FH006CH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>BI-EMEA Account update rules for FRB4: FH006CH CEDW SFDC data
(Building Innovations : Building &amp; Construction : Construction)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW FH006CH BI-LA Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB4_Code__c</field>
            <operation>equals</operation>
            <value>FH006CH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Latin America</value>
        </criteriaItems>
        <description>BI-LA Account update rules for FRB4: FH006CH CEDW SFDC data
(Building Innovations : Building &amp; Construction : Construction)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ERP CEDW FH006CH BI-NA Account Update</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CEDW SFDC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ERP_FRB4_Code__c</field>
            <operation>equals</operation>
            <value>FH006CH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <description>BI-NA Account update rules for FRB4: FH006CH CEDW SFDC data
(Building Innovations : Building &amp; Construction : Construction)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
