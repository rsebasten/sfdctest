<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>RecordTypeToSiteScript</fullName>
        <description>RecordTypeToSiteScript</description>
        <field>RecordTypeId</field>
        <lookupValue>SiteScriptQuestion</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordTypeToSiteScript</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SiteScriptRecordType</fullName>
        <actions>
            <name>RecordTypeToSiteScript</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Be sure to set the RecordType to SiteScript if the parent Script is a sitescript record</description>
        <formula>(Script__r.RecordTypeId==&quot;012Q0000000Ckmf&quot; &amp;&amp;   RecordTypeId != &quot;012Q0000000Ckmk&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
