<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AP_Lead_Status_equals_Track_after_30_60_and_90_days</fullName>
        <description>AP - Lead Status equals &quot;Track&quot; after 30,60 and 90 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DIMCEmailTemplates/AP_Email_reminder_for_Track_lead</template>
    </alerts>
    <alerts>
        <fullName>AP_Lead_Status_equals_Track_after_7_days</fullName>
        <description>AP - Lead Status equals &quot;Track&quot; after &gt; 7 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DIMCEmailTemplates/AP_Email_reminder_for_Track_lead</template>
    </alerts>
    <alerts>
        <fullName>BI_Partner_Lead_Management_Program_Email_1HTML</fullName>
        <description>BI Partner Lead Management Program Email #1HTML</description>
        <protected>false</protected>
        <recipients>
            <field>Related_Partner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>francois-xavier.belottini@che.dupont.com.dupontdps</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.a.mushow@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI/BI_Partner_Lead_Management_Program_Email_1HTML</template>
    </alerts>
    <alerts>
        <fullName>BI_Partner_Lead_Management_Program_Email_2HTML</fullName>
        <description>BI Partner Lead Management Program Email #2HTML</description>
        <protected>false</protected>
        <recipients>
            <field>Related_Partner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>francois-xavier.belottini@che.dupont.com.dupontdps</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.a.mushow@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI/BI_Partner_Lead_Management_Program_Email_2HTML</template>
    </alerts>
    <alerts>
        <fullName>BI_Partner_Lead_Management_Program_Email_3HTML</fullName>
        <description>BI Partner Lead Management Program Email #3HTML</description>
        <protected>false</protected>
        <recipients>
            <field>Related_Partner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>francois-xavier.belottini@che.dupont.com.dupontdps</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wendy.a.mushow@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BI/BI_Partner_Lead_Management_Program_Email_3HTML</template>
    </alerts>
    <alerts>
        <fullName>DPT_DPP_TMLA_new_lead_email_alert</fullName>
        <description>DPT-DPP TMLA new lead email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>nathalie.florin@lux.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>victoria.mascaray@esp.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EMEATemplates/EMEALeadEmailTemplate</template>
    </alerts>
    <alerts>
        <fullName>DPT_DPP_TMLA_registration_email_alert</fullName>
        <description>DPT-DPP TMLA registration email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>victoria.mascaray@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPP_EMEA/DPP_Nomex_TMLA_received_confirmation</template>
    </alerts>
    <alerts>
        <fullName>DPT_EMEA_Notification_of_Lead_matched_to_Contact</fullName>
        <description>DPT-EMEA Notification of Lead matched to Contact</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc-admin.dps@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DPP_EMEA/DPT_EMEA_Notification_for_Leads_matched_to_Contacts</template>
    </alerts>
    <alerts>
        <fullName>ECEMEAReminderonLeads</fullName>
        <description>ECEMEA - Reminder on Leads</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DIMCEmailTemplates/First_Lead_Reminder_2</template>
    </alerts>
    <alerts>
        <fullName>Lead_Creation_Request</fullName>
        <description>Lead Creation Request</description>
        <protected>false</protected>
        <recipients>
            <field>Originator_External_email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DIMCEmailTemplates/EU_Info_Notification</template>
    </alerts>
    <alerts>
        <fullName>Lead_Notifcation_on_owner_change</fullName>
        <description>Lead Notifcation on owner change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DIMC_India_Templates/India_Lead_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Lead_Notification</fullName>
        <description>Lead Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Airfiltration_Assignment_Email</fullName>
        <ccEmails>airfiltration@protectplus.com</ccEmails>
        <description>M&amp;S Consumer - Airfiltration Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Autoprotection_Assignment</fullName>
        <ccEmails>joerusso@moreadvantage.com</ccEmails>
        <description>M&amp;S Consumer - Autoprotection Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Car_Care</fullName>
        <ccEmails>rbarnett@pylonhq.com</ccEmails>
        <description>M&amp;S Consumer - Car Care Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Caulk_Assignment_Email</fullName>
        <ccEmails>heckr@mdteam.com</ccEmails>
        <description>M&amp;S Consumer - Caulk Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Flooring_Assignment_Email</fullName>
        <ccEmails>kali@qep.com</ccEmails>
        <description>M&amp;S Consumer Flooring Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Performancelubricants_Assignment_Email</fullName>
        <ccEmails>drowe@finishlineusa.com</ccEmails>
        <description>M&amp;S Consumer - Performancelubricants Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Stormroom_Assignment_Email</fullName>
        <ccEmails>amber@stormrooms.us</ccEmails>
        <description>M&amp;S Consumer - Stormroom Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Syntheticgrass_Assignment_Email</fullName>
        <ccEmails>dupont@foreverlawn.com</ccEmails>
        <description>M&amp;S Consumer - Syntheticgrass Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Vinyl_Assignment_Email</fullName>
        <ccEmails>dupontvinyl@mannington.com</ccEmails>
        <description>M&amp;S Consumer - Vinyl Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>M_S_Consumer_Waterfiltration_Assignment_Email</fullName>
        <ccEmails>waterfiltration@protectplus.com</ccEmails>
        <description>M&amp;S Consumer - Waterfiltration Assignment Email</description>
        <protected>false</protected>
        <senderAddress>sfdc-admin@dupont.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Workflow_Email_Alert_Templates/DPS_M_S_Consumer</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_to_Lead_Owner</fullName>
        <description>Send notification to Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DIMCEmailTemplates/NewLeadAlertWithLink</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_to_Lead_Owner_for_Kevlar</fullName>
        <description>Send notification to Lead Owner for Kevlar</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AFS/Kevlar_Auto_Hose_New_Lead_Alert_with_Lead_Link</template>
    </alerts>
    <fieldUpdates>
        <fullName>CPSF_Update_Lead_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>mcgrawhillintegrator@dupont.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>CPSF Update Lead Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Erase_Actual_Close_Date</fullName>
        <field>Actual_Closed_Date__c</field>
        <name>Erase Actual Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Closure</fullName>
        <field>Status</field>
        <literalValue>End</literalValue>
        <name>Lead Closure</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_to_B_2_Queue</fullName>
        <description>Change Lead Owner to M&amp;S-Innovation Center B.2 Queue</description>
        <field>OwnerId</field>
        <lookupValue>M_S_Innovation_Center_B_2_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Owner to B.2 Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Legacy_set_to_NULL</fullName>
        <field>Legacy_Lead_ID__c</field>
        <name>Legacy set to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF2SF_DPT_EMEA_MA_Lead_follow_up</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Level2DPPEMEA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SF2SF DPT-EMEA MA Lead follow-up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF2SF_DPT_IPP_Level_2_EMEA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Level2DPPEMEA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SF2SF DPT-IPP Level 2 EMEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF2SF_DPT_IPP_Level_2_NA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Level2DPPNA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SF2SF DPT-IPP Level 2 NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF2SF_Level_2_Construction_EMEA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Level2ConstructionEMEA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SF2SF Level 2 Construction-EMEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF2SF_Level_2_DPT_Aramids</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Level2DPTAramids</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SF2SF Level 2 DPT-Aramids</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF2SF_M_S_Level_2_Consumer</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Level2Consumer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SF2SF M&amp;S Level 2 Consumer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UniqueIDfiller</fullName>
        <description>Automatically populate the Lead ID field with a unique value</description>
        <field>LeadIDCopy__c</field>
        <formula>Id</formula>
        <name>Unique ID filler</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Competitve_Info</fullName>
        <description>Description data is copied to Competitive Info field</description>
        <field>Competitive_Info__c</field>
        <formula>BLANKVALUE( Competitive_Info__c , Description )</formula>
        <name>Update Competitve Info</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_SF_to_SF_Transfer</fullName>
        <description>Update Stage to SF to SF Transfer</description>
        <field>Stage__c</field>
        <literalValue>SF to SF Transfer</literalValue>
        <name>Update Stage to SF to SF Transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign to User</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Business_User_Record_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Assign to User</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BI Partner Program %231</fullName>
        <actions>
            <name>BI_Partner_Lead_Management_Program_Email_1HTML</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>BI Partner Program #1</description>
        <formula>RecordType.DeveloperName =&apos;Level_2_BI_NA&apos; &amp;&amp;  CreatedById =&apos;005a0000008VkBq&apos; &amp;&amp;  NOT(ISBLANK(Website)) &amp;&amp;  Subject__c =&apos;BI Partner Program&apos; &amp;&amp; ISPICKVAL( Status , &apos;Capture&apos;) &amp;&amp; NOT(ISBLANK( Related_Partner_Contact__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI Partner Program %232</fullName>
        <actions>
            <name>BI_Partner_Lead_Management_Program_Email_2HTML</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>BI Partner Program #2</description>
        <formula>RecordType.DeveloperName =&apos;Level_2_BI_NA&apos; &amp;&amp;  CreatedById =&apos;005a0000008VkBq&apos;&amp;&amp;  NOT(ISBLANK(Website)) &amp;&amp;  Subject__c =&apos;BI Partner Program&apos; &amp;&amp; ISPICKVAL( Status , &apos;Route&apos;) &amp;&amp; NOT(ISBLANK( Related_Partner_Contact__c )) &amp;&amp; BU_Answer1__c =&apos;Yes&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BI_Partner_Lead_Management_Program_Email_3HTML</name>
                <type>Alert</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BI-AP Field Visibility in List View</fullName>
        <actions>
            <name>Update_Competitve_Info</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Level 2 BI AP,Level 1 Leads</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Owning_Organization__c</field>
            <operation>equals</operation>
            <value>BI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Region__c</field>
            <operation>equals</operation>
            <value>Asia Pacific</value>
        </criteriaItems>
        <description>Rule to copy the data from Description field to Competitive info for BI-AP business.And visibility is extended to List views.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BI-SURF Lead assignment</fullName>
        <actions>
            <name>Send_notification_to_Lead_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify user of new lead created and assigend in SFDC</description>
        <formula>AND( 
($RecordType.Name = &apos;Level 2 Construction-EMEA&apos;), 
(CreatedById = &apos;00541000003Fjwt&apos;), 
IF(LEFT(OwnerId, 3) &lt;&gt; &apos;00G&apos;, TRUE,FALSE) 
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CIC Lead Legacy NULL for Others</fullName>
        <actions>
            <name>Legacy_set_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set CIC Lead Legacy NULL for Others</description>
        <formula>BEGINS(Legacy_Lead_ID__c, $Label.CIC) &amp;&amp;  $User.Username != $Label.CIC_Construction_UserName &amp;&amp; $User.Username != $Label.Batch_SFDC_Deploy_User_Name</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPSF Lead Legacy NULL for Others</fullName>
        <actions>
            <name>Legacy_set_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set CPSF Lead Legacy NULL for Others</description>
        <formula>BEGINS(Legacy_Lead_ID__c, $Label.CPSF) &amp;&amp;  $User.Username != $Label.External_Initiative_Owner_Full_Name &amp;&amp; $User.Username != $Label.Batch_SFDC_Deploy_User_Name</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPSF Update Lead Owner</fullName>
        <actions>
            <name>CPSF_Update_Lead_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>BEGINS(Legacy_Lead_ID__c, $Label.CPSF) &amp;&amp; Owner:User.Username =  $Label.Batch_SFDC_Deploy_User_Name</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DPS Kevlar Lead assignment</fullName>
        <actions>
            <name>Send_notification_to_Lead_Owner_for_Kevlar</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>DPS Kevlar Auto Sales,DPS Kevlar Auto Technical</value>
        </criteriaItems>
        <description>Notify members of new lead in DPS Kevlar queues</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT-DPP TMLA registration email alert</fullName>
        <actions>
            <name>DPT_DPP_TMLA_new_lead_email_alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>DPT_DPP_TMLA_registration_email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Level 2 DPP EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>equals</operation>
            <value>DPT-DPP Level 2 EMEA TMLA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Origin_Channel_Type__c</field>
            <operation>equals</operation>
            <value>Website</value>
        </criteriaItems>
        <description>To notify the customer what their TMLA form was successfully registered AND to inform the DPT process owner of the new lead</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DPT-EMEA Lead mapped to Contact</fullName>
        <actions>
            <name>DPT_EMEA_Notification_of_Lead_matched_to_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Level 2 DPP EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Related_Contact_Status__c</field>
            <operation>equals</operation>
            <value>Completed-Single Contact</value>
        </criteriaItems>
        <description>Used by DPT-EMEA Electric Arc process, to be notified of Leads linked to existing Contacts</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>India Lead Notification on Change</fullName>
        <actions>
            <name>Lead_Notifcation_on_owner_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>India Lead Notification on Change</description>
        <formula>AND(ISCHANGED(OwnerId),(RecordType.DeveloperName==&apos;Level2DCF&apos; || RecordType.DeveloperName==&apos;Level_2_AGCP_CPC&apos; ||  RecordType.DeveloperName==&apos;Level1Leads&apos; ||  RecordType.DeveloperName==&apos;Level_2_BI_AP&apos; || RecordType.DeveloperName==&apos;Level2EP&apos; || RecordType.DeveloperName==&apos;Level2Food&apos; || RecordType.DeveloperName==&apos;Level2_IB_Biomaterials_TateLyle&apos; ||RecordType.DeveloperName==&apos;Level2_IB_Biomaterials_Sorona&apos; || RecordType.DeveloperName==&apos;Level2DPTAramids&apos; || RecordType.DeveloperName==&apos;Level2DSS&apos; || RecordType.DeveloperName==&apos;Level2DECT&apos; || RecordType.DeveloperName==&apos;Level2PIP&apos;)  ,ISPICKVAL(Lead_Country__c,&apos;India&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Airfiltration Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Airfiltration_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Airfiltration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to airfiltration@protectplus.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Autoprotection Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Autoprotection_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Autoprotection</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to info@moreadvantage.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Car Care Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Car_Care</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Car Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to nhughes@pylonhq.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Caulk Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Caulk_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Caulk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to heckr@mdteam.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Flooring Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Flooring_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Flooring</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to adamcusick@fausinc.com and alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Performancelubricants Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Performancelubricants_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Performancelubricants</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to lnielsen@finishlineusa.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Stormroom Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Stormroom_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Stormroom</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to amber@stormrooms.us, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Syntheticgrass Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Syntheticgrass_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Syntheticgrass</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to dupont@foreverlawn.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Vinyl Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Vinyl_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Vinyl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to dupontvinyl@mannington.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>M%26S Consumer - Waterfiltration Assignment</fullName>
        <actions>
            <name>M_S_Consumer_Waterfiltration_Assignment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer - Waterfiltration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>wwwroot Site Guest User</value>
        </criteriaItems>
        <description>Workflow Rule created to send Assignment Rule emails to waterfiltration@protectplus.com, an alternative solution to Web-To-Lead Assignment rules</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF DPT-EMEA MA Lead follow-up</fullName>
        <actions>
            <name>SF2SF_DPT_EMEA_MA_Lead_follow_up</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>equals</operation>
            <value>DPT-EMEA MA Lead follow-up</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF DPT-IPP Level 2 EMEA</fullName>
        <actions>
            <name>SF2SF_DPT_IPP_Level_2_EMEA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>equals</operation>
            <value>DPT-IPP Level 2 EMEA</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF DPT-IPP Level 2 NA</fullName>
        <actions>
            <name>SF2SF_DPT_IPP_Level_2_NA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>startsWith</operation>
            <value>DPT-IPP Level 2 NA</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF Level 2 BI-NA</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Business_User_Record_Id__c</field>
            <operation>startsWith</operation>
            <value>005</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF Level 2 Construction-EMEA</fullName>
        <actions>
            <name>SF2SF_Level_2_Construction_EMEA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>equals</operation>
            <value>BI-EMEA,BI (Surf) -EMEA-UK,BI-EMEA-France,BI-EMEA-France,BI-EMEA-Germany</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF Level 2 DPT-Aramids</fullName>
        <actions>
            <name>SF2SF_Level_2_DPT_Aramids</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>equals</operation>
            <value>DPT Level 2 AP-China,DPT Level 2 AP-India,DPT Level 2 LA</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SF2SF M%26S Level 2 Consumer</fullName>
        <actions>
            <name>SF2SF_M_S_Level_2_Consumer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Stage__c</field>
            <operation>equals</operation>
            <value>SF to SF Transfer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Queue__c</field>
            <operation>equals</operation>
            <value>M&amp;S Consumer</value>
        </criteriaItems>
        <description>Set Record Type for Replicated Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
