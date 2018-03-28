<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BI_AP_Leadership_Big_Deal_Alert</fullName>
        <description>Email BI-AP Leadership when a Japan/Korea Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>benjamin.greenberg@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fumio.inomae@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_AP_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>BI_AP_Leadership_INDIA_ASEAN_AUSTRALIA_Big_Deal_Alert</fullName>
        <description>Email BI-AP Leadership when a India/Asean/Australia Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>benjamin.greenberg@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>manish.mishra@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>phillip.betts@aus.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_AP_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>BI_AP_Surfaces_Big_Deal_Alert</fullName>
        <description>Email BI-AP Leadership when a China Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>benjamin.greenberg@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniel.sun@chn.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_AP_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>BI_EMEA_Surfaces_Big_Deal_Alert</fullName>
        <description>Email BI-EMEA Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>benjamin.greenberg@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.segretinat@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_EMEA_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>BI_LA_Surfaces_Big_Deal_Alert</fullName>
        <description>Email BI-LA Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>benjamin.greenberg@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leandro.rosa@bra.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_LA_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>BI_NA_Surfaces_Big_Deal_Alert</fullName>
        <description>Email BI-NA Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>benjamin.greenberg@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>richard.j.mccarthy@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.m.finch@dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_NA_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>BI_Surfaces_Big_Deal_Alert_1000000</fullName>
        <description>Email BI Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $1,000,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>julie.j.eaton@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_Surfaces_Big_Deal_Alert1</template>
    </alerts>
    <alerts>
        <fullName>BI_Surfaces_Big_Deal_Alert_500000</fullName>
        <description>Email BI Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $500,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>maria.e.boulden-1@usa.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_Surfaces_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>Close_Date_Overduee</fullName>
        <description>Close Date Overdue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_EMEA_Templates_4_other_SBU_s/Close_Date_Overdue</template>
    </alerts>
    <alerts>
        <fullName>Email_BI_EMEA_Leadership_when_a_UK_or_Ireland_Surfaces_Opportunity_Expected_Reve</fullName>
        <description>Email BI-EMEA Leadership when a UK or Ireland Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.hill@gbr.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Email_Template/BI_EMEA_Surfaces_Big_Deal_Alert_for_UK_or_Ireland</template>
    </alerts>
    <alerts>
        <fullName>Email_BI_Global_Leadership_when_a_Surfaces_Opportunity_Amount_100_000</fullName>
        <description>Email BI Global Leadership when a Surfaces Opportunity Amount &gt;= $100,000</description>
        <protected>false</protected>
        <recipients>
            <recipient>BI_Surfaces_Global_Pipeline_Leadership</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI/BI_Global_Big_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>New_Opportunity_created_by_Distributor</fullName>
        <description>BI New Opportunity created by Distributor</description>
        <protected>false</protected>
        <recipients>
            <recipient>maricarmen.rodriguez@mex.dupont.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI/New_Distributor_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opp_Email_ALert</fullName>
        <description>Opp Email ALert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>OpportunityOwner_2__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BI_NA_Approval_Processes/BI_NA_Commercial_Opportunity_Notification</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Close_Date_Reminder_for_DPT_Opportunities</fullName>
        <description>Opportunity Close Date Reminder for DPT Opportunities</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AFS/Opportunity_Close_Date_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Remainder_that_the_Opportunity_status_hasn_t_chanegd_from_the_past_90_days</fullName>
        <description>Remainder that the Opportunity status hasn&apos;t chanegd from the past 90 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DPT_Garments_North_America/DPT_Reminder_email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Last_Modified_By_Partner</fullName>
        <field>Last_Modified_By_Partner__c</field>
        <formula>NOW()</formula>
        <name>Last Modified By Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opprtunity_End_Date_is_Today</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>Opprtunity End Date is Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Close</fullName>
        <field>StageName</field>
        <literalValue>Close</literalValue>
        <name>Oppty_Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_End_Date_Today</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>Oppty End Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_End_Lost</fullName>
        <field>StageName</field>
        <literalValue>End - Lost</literalValue>
        <name>Oppty End Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_End_Reason</fullName>
        <field>Main_Ending_Reason__c</field>
        <literalValue>No Solution</literalValue>
        <name>Oppty End Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Stage_Design_Sol</fullName>
        <field>StageName</field>
        <literalValue>Design Solution</literalValue>
        <name>Oppty Stage Design Sol</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Stage_Propose</fullName>
        <field>StageName</field>
        <literalValue>Propose</literalValue>
        <name>Oppty Stage Propose</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Stage_Qualify</fullName>
        <field>StageName</field>
        <literalValue>Qualify</literalValue>
        <name>Oppty Stage Qualify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Probability_Calculation</fullName>
        <description>Opportunity Other Probability = Customer Commitment Probability x Selection Probability</description>
        <field>OtherProbability__c</field>
        <formula>0</formula>
        <name>Other Probability Calculation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_First_Ship_DateWith_Close_Date</fullName>
        <field>First_Ship_Date__c</field>
        <formula>CloseDate</formula>
        <name>Populate First Ship DateWith Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Schedule_Base_Date_from_First_Ship_Date</fullName>
        <field>ScheduleBaseDate__c</field>
        <formula>First_Ship_Date__c</formula>
        <name>Schedule Base Date from First Ship Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update</fullName>
        <field>StageName</field>
        <literalValue>Active</literalValue>
        <name>Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update_to_Lost</fullName>
        <field>StageName</field>
        <literalValue>End - Lost</literalValue>
        <name>Stage Update to Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update_to_Won</fullName>
        <field>StageName</field>
        <literalValue>End - Won</literalValue>
        <name>Stage Update to Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BI_NA_Opportunity_Score</fullName>
        <field>Score__c</field>
        <formula>IF(
ISPICKVAL(Application_Type__c, &quot;CLT-Fluid&quot;),((0.5*(if((External_Initiative__r.Initiative_Size__c*0.383333)&lt;7000,1,if((External_Initiative__r.Initiative_Size__c* 0.383333)&gt;20999,9,3)))) 
+(0.3*(If(contains(External_Initiative__r.Specification_L1__c,&quot;Fluid Applied - Tyvek&quot;),9, 
If(contains (External_Initiative__r.Specification_L1__c, &quot;Fluid Applied - Other&quot;),3,1)))) 
+(0.2*( If (contains( External_Initiative__r.Specification_L2__c,&quot;Precast Concrete&quot;),9, 
If(contains(External_Initiative__r.Specification_L2__c, &quot;Pre-Engineered Metal&quot;),3, 
If(contains(External_Initiative__r.Specification_L2__c, &quot;Wall Bearing&quot;),3, 
1)))))), 
IF(ISPICKVAL(Application_Type__c, &quot;CLT-Tyvek&quot;),((0.5*(If((External_Initiative__r.Initiative_Size__c *0.051652) &lt; 6000, 1, if ((External_Initiative__r.Initiative_Size__c *0.051652) &gt; 17999, 9, 3)))) 
+(0.3*(If(contains( External_Initiative__r.Specification_L1__c, &quot;Commercial Wrap&quot;), 9, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;Stucco Wrap&quot;),9, 
If((External_Initiative__r.Specification_L1__c=&quot;&quot;),9, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;Tyvek NOT Comm. Or Stuc Wrap&quot;),3, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;Competitors NOT Tyvek&quot;),3,1))))))) 
+(0.2*(If(contains(External_Initiative__r.Specification_L2__c,&quot;Wood&quot;),9, 
If(contains(External_Initiative__r.Specification_L2__c,&quot;Structural Steel&quot;),9, 
If(contains(External_Initiative__r.Specification_L2__c,&quot;Reinforced Concrete&quot;),3, 
If(contains(External_Initiative__r.Specification_L2__c,&quot;Light Gauge Steel&quot;),3, 
If((External_Initiative__r.Specification_L2__c=&quot;&quot;),3, 
1)))))))), 
IF(ISPICKVAL(Application_Type__c, &quot;CLT-Surfaces&quot;),((0.50*(If((External_Initiative__r.Value__c*0.0009)&gt;=15000,9, 
if((External_Initiative__r.Value__c*0.0009)&lt;4000,1,3))) 
)+(0.30* (If(contains(External_Initiative__r.Specification_L1__c,&quot;Solid Surfaces - Corian&quot;),9, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;Engineered Stone - Zodiaq&quot;),9, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;SS - Other&quot;),3, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;ES - Other&quot;),3, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;Solid Surfaces - Not Corian&quot;),3, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;Engineered Stone - Not Zodiaq&quot;), 3, 
If(contains(External_Initiative__r.Specification_L1__c,&quot;&quot;),9,1))))))))) 
+(0.20*(If(contains(External_Initiative__r.Segment_L2__c,&quot;Food Service&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Food/Beverage Service&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;College/University&quot;),9, 
If(contains(External_Initiative__r.Segment_L2__c,&quot;Clinics&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Clinic/Medical Office&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Hospitals&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Hospital&quot;),9, 
If(contains(External_Initiative__r.Segment_L2__c,&quot;Labs&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Testing/Research/Development Lab&quot;),9, 
If(contains(External_Initiative__r.Segment_L2__c,&quot;Stadium&quot;),9, 
If(contains(External_Initiative__r.Segment_L2__c,&quot;Theaters&quot;),9, 
If(contains(External_Initiative__r.Segment_L2__c,&quot;Theater/Auditorium&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Hotel/Motel&quot;),9, 
If(contains(External_Initiative__r.Segment_L2__c,&quot;Dormitories&quot;),9,
If(contains(External_Initiative__r.Segment_L2__c,&quot;Dormitory&quot;),9,  
3)))))))))))))))))),0)))</formula>
        <name>Update BI-NA Opportunity Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>upper(Name)</formula>
        <name>Update Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BI Surfaces_Big_Deal_Alert - %241%2C000%2C000</fullName>
        <actions>
            <name>BI_Surfaces_Big_Deal_Alert_1000000</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-EMEA Surfaces,BI-NA Surfaces Dodge,BI-NA Surfaces Manual,Construction LA,Construction AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 1,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BI Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $1,000,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI Surfaces_Big_Deal_Alert - %24500%2C000</fullName>
        <actions>
            <name>BI_Surfaces_Big_Deal_Alert_500000</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-EMEA Surfaces,BI-NA Surfaces Dodge,BI-NA Surfaces Manual,Construction LA,Construction AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 500,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BI Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $500,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-AP_China_Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>BI_AP_Surfaces_Big_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Account_Country__c</field>
            <operation>contains</operation>
            <value>China,Mongolia,Macao,Hong Kong,Taiwan</value>
        </criteriaItems>
        <description>BI-AP Leadership when a China Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-AP_India%2FAsean%2FAustralia Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>BI_AP_Leadership_INDIA_ASEAN_AUSTRALIA_Big_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Account_Country__c</field>
            <operation>contains</operation>
            <value>India,Indonesia,Malaysia,Singapore,Australia,New Zealand</value>
        </criteriaItems>
        <description>BI-AP Leadership when a India/Asean/Australia Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-AP_Japan%2FKorea Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>BI_AP_Leadership_Big_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Account_Country__c</field>
            <operation>contains</operation>
            <value>Japan,Korea</value>
        </criteriaItems>
        <description>BI-AP Leadership when a Japan/Korea Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-EMEA_Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>BI_EMEA_Surfaces_Big_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-EMEA Surfaces</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BI-EMEA Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-EMEA_Surfaces_Big_Deal_Alert %28UK or Ireland%29</fullName>
        <actions>
            <name>Email_BI_EMEA_Leadership_when_a_UK_or_Ireland_Surfaces_Opportunity_Expected_Reve</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-EMEA Surfaces</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Account_Country__c</field>
            <operation>contains</operation>
            <value>IRELAND,UNITED KINGDOM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BI-EMEA Leadership when a UK or Ireland Surfaces Opportunity Expected Revenue is equal to or greater than $100,000.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-LA_Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>BI_LA_Surfaces_Big_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Construction LA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BI-LA Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI-NA CLT - Update Opportunity Score %26 Rating</fullName>
        <actions>
            <name>Update_BI_NA_Opportunity_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA MHC Opportunity</value>
        </criteriaItems>
        <description>Updates the Opportunity Score and Rating field for BI-MHC Opportunities</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BI-NA CLT Opportunity Last Modified By Specialists</fullName>
        <actions>
            <name>Last_Modified_By_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.User_Type__c</field>
            <operation>equals</operation>
            <value>Trading Partner</value>
        </criteriaItems>
        <description>Update Last Modified by Partner field when partner edits any CLT Opportunity</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BI-NA_Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>BI_NA_Surfaces_Big_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ExpectedRevenue</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BI-NA Leadership when a Surfaces Opportunity Expected Revenue is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_BE_Comm_Pipeline_NoApp</fullName>
        <actions>
            <name>Oppty_End_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_End_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_End_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>equals</operation>
            <value>No Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA BE Manual,BI-NA MHC Opportunity</value>
        </criteriaItems>
        <description>When the opportunity application is updated to No Application, Change Stage to &quot;End - Lost&quot; and change Close Date to Today&apos;s Date and change Main Ending Reason to &quot;No Solution&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Comm_Pipeline_Close</fullName>
        <actions>
            <name>Oppty_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>notEqual</operation>
            <value>No Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.BI_NA_Opportunity_Score__c</field>
            <operation>equals</operation>
            <value>1,2,3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>1/1/2050</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Comm_Pipeline_NoApp</fullName>
        <actions>
            <name>Oppty_End_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_End_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_End_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>equals</operation>
            <value>No Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual,BI-NA MHC Opportunity,BI-EMEA Surfaces,Construction LA,BI-NA BE Manual</value>
        </criteriaItems>
        <description>When the opportunity application is updated to No Application, Change Stage to &quot;End - Lost&quot; and change Close Date to Today&apos;s Date and change Main Ending Reason to &quot;No Solution&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Comm_Pipeline_Opp_DesignSol</fullName>
        <actions>
            <name>Oppty_Stage_Design_Sol</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>equals</operation>
            <value>Potential Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Target,Qualify</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.BI_NA_Opportunity_Score__c</field>
            <operation>equals</operation>
            <value>1,2,3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessOrEqual</operation>
            <value>1/1/2050</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual,BI-EMEA Surfaces,Construction LA</value>
        </criteriaItems>
        <description>When the BI-NA Opportunity Score = 1, 2 or 3, Change Stage to &quot;Design Solutions&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Comm_Pipeline_Opp_Propose</fullName>
        <actions>
            <name>Oppty_Stage_Propose</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>equals</operation>
            <value>Potential Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Target,Qualify,Design Solution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.BI_NA_Opportunity_Score__c</field>
            <operation>equals</operation>
            <value>1,2,3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>1/1/2050</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual,BI-EMEA Surfaces,Construction LA</value>
        </criteriaItems>
        <description>Amount NOT EQUAL TO blank, Change Stage to &quot;Propose&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Comm_Pipeline_Qualify</fullName>
        <actions>
            <name>Oppty_Stage_Qualify</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Application__c</field>
            <operation>equals</operation>
            <value>Potential Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.BI_NA_Opportunity_Score__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessOrEqual</operation>
            <value>1/1/2050</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual,BI-EMEA Surfaces,Construction LA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Target</value>
        </criteriaItems>
        <description>When the opportunity application is not blank or not No Application, Change Stage to &quot;Qualify&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Comm_Stage_End_Lost</fullName>
        <actions>
            <name>Opprtunity_End_Date_is_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-NA Surfaces Dodge,BI-NA Surfaces Manual,BI-NA BE Manual,BI-NA MHC Opportunity,BI-EMEA Surfaces,Construction LA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>End - Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>When the Stage is changed to End-Lost and Close Date is greater than today, Main Ending Reason is Mandatory and CloseDate Should be Today</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Surfaces_Big_Deal_Alert</fullName>
        <actions>
            <name>Email_BI_Global_Leadership_when_a_Surfaces_Opportunity_Amount_100_000</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-EMEA Surfaces,BI-NA Surfaces Dodge,BI-NA Surfaces Manual,Construction LA,Construction AP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 100,000&quot;</value>
        </criteriaItems>
        <description>Alert BI Global Surfaces Leadership when an Opportunity Amount is equal to or greater than $100,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BI_Surfaces_Comm_Pipeline_NoApp</fullName>
        <actions>
            <name>Oppty_End_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_End_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_End_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Application_2__c</field>
            <operation>includes</operation>
            <value>No Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>BI-EMEA Surfaces,BI-NA Surfaces Dodge,BI-NA Surfaces Manual,Construction LA</value>
        </criteriaItems>
        <description>When the opportunity field Application 2 includes No Application, Change Stage to &quot;End - Lost&quot; 
and change Close Date to Today&apos;s Date and change Main Ending Reason to &quot;No Solution&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DPT Email Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-Aramids Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Remainder_that_the_Opportunity_status_hasn_t_chanegd_from_the_past_90_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.LastModifiedDate</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DPT Opportunity Email Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Close,End - Won,End - Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owning_Organisation__c</field>
            <operation>startsWith</operation>
            <value>DPT</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Close_Date_Reminder_for_DPT_Opportunities</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Overdue-DPT-EMEA Simple</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>DPT-EMEA Simple</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>End - Won,End - Lost</value>
        </criteriaItems>
        <description>Opportunity is overdue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_date_arriving_Expiration</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Date_Overduee</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>ACTION_REQUIRED_Update_Open_Opportunity_Close_Date_is_Past_Due</fullName>
        <assignedToType>owner</assignedToType>
        <description>The close date for this Opportunity is now past due. Follow the link to this record, and update the close date, status or other relevant information about this Opportunity. This information must be kept up to date.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>ACTION REQUIRED: Update Open Opportunity - Close Date is Past Due</subject>
    </tasks>
    <tasks>
        <fullName>Close_date_arriving_Expiration</fullName>
        <assignedToType>owner</assignedToType>
        <description>“The Close date arrive to expiration within 7 day, please remember to update your opportunity status”</description>
        <dueDateOffset>-7</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Close date arriving Expiration</subject>
    </tasks>
</Workflow>
