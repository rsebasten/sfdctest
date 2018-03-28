/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>
Description: This class is Unit Test class for class JSON2Apex
***************************************************************************************/

@isTest()
public class JSON2Apex_UT{

static testMethod void testParse() {
        String json = '{\"response\":{\"registrant\":\"Amazon Technologies, Inc.\",\"registration\":{\"created\":\"1994-11-01\",\"expires\":\"2022-10-31\",\"updated\":\"2014-04-30\",\"registrar\":\"MARKMONITOR INC.\",\"statuses\":[\"clientDeleteProhibited\",\"clientTransferProhibited\",\"clientUpdateProhibited\",\"serverDeleteProhibited\",\"serverTransferProhibited\",\"serverUpdateProhibited\"]},\"name_servers\":[\"NS1.P31.DYNECT.NET\",\"NS2.P31.DYNECT.NET\",\"NS3.P31.DYNECT.NET\",\"NS4.P31.DYNECT.NET\",\"PDNS1.ULTRADNS.NET\",\"PDNS6.ULTRADNS.CO.UK\"],\"whois\":{\"date\":\"2015-02-03\",\"record\":\"Domain Name: amazon.com\\nRegistry Domain ID: 281209_DOMAIN_COM-VRSN\\nRegistrar WHOIS Server: whois.markmonitor.com\\nRegistrar URL: http:\\/\\/www.markmonitor.com\\nUpdated Date: 2014-04-30T12:11:08-0700\\nCreation Date: 1994-10-31T21:00:00-0800\\nRegistrar Registration Expiration Date: 2022-10-30T21:00:00-0700\\nRegistrar: MarkMonitor, Inc.\\nRegistrar IANA ID: 292\\nRegistrar Abuse Contact Email: abusecomplaints@markmonitor.com\\nRegistrar Abuse Contact Phone: +1.2083895740\\nDomain Status: clientUpdateProhibited (https:\\/\\/www.icann.org\\/epp#clientUpdateProhibited)\\nDomain Status: clientTransferProhibited (https:\\/\\/www.icann.org\\/epp#clientTransferProhibited)\\nDomain Status: clientDeleteProhibited (https:\\/\\/www.icann.org\\/epp#clientDeleteProhibited)\\nRegistry Registrant ID: \\nRegistrant Name: Hostmaster, Amazon Legal Dept.\\nRegistrant Organization: Amazon Technologies, Inc.\\nRegistrant Street: P.O. Box 8102\\nRegistrant City: Reno\\nRegistrant State\\/Province: NV\\nRegistrant Postal Code: 89507\\nRegistrant Country: US\\nRegistrant Phone: +1.2062664064\\nRegistrant Phone Ext: \\nRegistrant Fax: +1.2062667010\\nRegistrant Fax Ext: \\nRegistrant Email: hostmaster@amazon.com\\nRegistry Admin ID: \\nAdmin Name: Hostmaster, Amazon Legal Dept.\\nAdmin Organization: Amazon Technologies, Inc.\\nAdmin Street: P.O. Box 8102\\nAdmin City: Reno\\nAdmin State\\/Province: NV\\nAdmin Postal Code: 89507\\nAdmin Country: US\\nAdmin Phone: +1.2062664064\\nAdmin Phone Ext: \\nAdmin Fax: +1.2062667010\\nAdmin Fax Ext: \\nAdmin Email: hostmaster@amazon.com\\nRegistry Tech ID: \\nTech Name: Hostmaster, Amazon Legal Dept.\\nTech Organization: Amazon Technologies, Inc.\\nTech Street: P.O. Box 8102\\nTech City: Reno\\nTech State\\/Province: NV\\nTech Postal Code: 89507\\nTech Country: US\\nTech Phone: +1.2062664064\\nTech Phone Ext: \\nTech Fax: +1.2062667010\\nTech Fax Ext: \\nTech Email: hostmaster@amazon.com\\nName Server: ns2.p31.dynect.net\\nName Server: ns3.p31.dynect.net\\nName Server: pdns6.ultradns.co.uk\\nName Server: ns1.p31.dynect.net\\nName Server: pdns1.ultradns.net\\nName Server: ns4.p31.dynect.net\\nDNSSEC: unsigned\\nURL of the ICANN WHOIS Data Problem Reporting System: http:\\/\\/wdprs.internic.net\\/\\n\"}}}';
        JSON2Apex r = JSON2Apex.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Registration objRegistration = new JSON2Apex.Registration(System.JSON.createParser(json));
        System.assert(objRegistration != null);
        System.assert(objRegistration.created == null);
        System.assert(objRegistration.expires == null);
        System.assert(objRegistration.updated == null);
        System.assert(objRegistration.registrar == null);
        System.assert(objRegistration.statuses == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex objRoot = new JSON2Apex(System.JSON.createParser(json));
        System.assert(objRoot != null);
        System.assert(objRoot.response == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Response objResponse = new JSON2Apex.Response(System.JSON.createParser(json));
        System.assert(objResponse != null);
        System.assert(objResponse.registrant == null);
        System.assert(objResponse.registration == null);
        System.assert(objResponse.name_servers == null);
        System.assert(objResponse.whois == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        JSON2Apex.Whois objWhois = new JSON2Apex.Whois(System.JSON.createParser(json));
      //  System.assert(objWhois != null);
        //System.assert(objWhois.date == null);
        //System.assert(objWhois.record == null);
    }

}