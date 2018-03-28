/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Smita Kadian
Email: Smita.Kadian@usa.dupont.com
Date: 10 July 2011
Description: Controller class for XML Parsing
********************************************************************************/
public with sharing class ctrlLeadExtDataTransform{
	//Variable Declarations
	public List<Lead> leadList=new List<Lead>();
	Id leadID;
	public List<String> listOfAttribute{get;set;}
	public List<String> listOfAttributeValues{get;set;}
	public String parsedXML{get;set;}
	public Integer leadListSize{get;set;}
	//Constructor to fetch the Lead id
	public ctrlLeadExtDataTransform(ApexPages.StandardController controller){
		listOfAttribute=new List<String>();
		listOfAttributeValues=new List<String>();
		leadID = ApexPages.currentPage().getParameters().get('id');
		//Fetching the 'Extended Data' field which contact the XML
		leadList=[Select Extended_Data__c from Lead where id=:leadID limit 1];
		if(leadList.size()!=0){
			String extendedData='';
			extendedData=leadList[0].Extended_Data__c;
			if(extendedData!=null)
			//Calling the program to parse the XML
			parse(extendedData);
		}
	}
	public ctrlLeadExtDataTransform(){}
	
	public String parse(String toParse) {
		DOM.Document doc = new DOM.Document();        
		try {  
			doc.load(toParse);      
			DOM.XMLNode root = doc.getRootElement();  
			return walkThrough(root);       
		} catch (System.XMLException e) { // invalid XML  
			return e.getMessage();
		}  
    }  

	private String walkThrough(DOM.XMLNode node) {
		parsedXML='';
		//looping through the XML to search from COMMENT
		if (node.getNodeType() == DOM.XMLNodeType.COMMENT ) {
			return 'Comment (' +  node.getText() + ')';  
		}
		//looping through the XML to search from TEXT
		if (node.getNodeType() == DOM.XMLNodeType.TEXT ) {
			return 'Text (' + node.getText() + ')';  
		}
		//looping through the XML to search from ELEMENT
		if (node.getNodeType() == DOM.XMLNodeType.ELEMENT ) {
			parsedXML += ' Element: ' + node.getName(); 
			parsedXML += ' text=' + node.getText().trim(); 
			//looping through the XML further to search from ATTRIBUTES
			if (node.getAttributeCount() > 0) {
				parsedXML+=' ';
				for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
					parsedXML +=' '+node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i))+' \n ';  
					listOfAttribute.add(node.getAttributeKeyAt(i));
					leadListSize=listOfAttribute.size();
					listOfAttributeValues.add(node.getAttributeValue(node.getAttributeKeyAt(i),node.getAttributeKeyNsAt(i)));
				}  
			}
			for (Dom.XMLNode child: node.getChildElements()){
				parsedXML += walkThrough(child);  
			}
			return parsedXML;  
		}
		return '';
	}
}