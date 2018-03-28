/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved.
Author: Pranitha S
Email: Pranitha_S@infosys.com 
Description:  Controller for component BPDAutoComplete_General to implement autocomplete functionality
 *****************************************************************************/
global with sharing class ctrlBPDAutoComplete_General {

    @RemoteAction
    global static Set<String> query(string obj, string qry, string addFields, string whereClause) {
        // more than one field can be passed in the addFields parameter
        // split it into an array for later use
        List<String> fieldList;
        if (addFields!=null && addFields.trim()!='') fieldList = addFields.split(',');
       // check to see if the object passed is valid
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(obj);
        if (sot == null) {
            // Object name not valid
            return null;
        }
        
        //Get the name field (i.e Case, solution, etc..)
        string nameField=Util.getNameField(String.valueOf(sot));

        // create the filter text
        String filter = ' like \'%' + String.escapeSingleQuotes(qry) + '%\'';
        //begin building the dynamic soql query
        String soql = 'select id, '+nameField;
        // if an additional field was passed in add it to the soql
        if (fieldList!=null) {
            for (String s : fieldList) {
                soql += ', ' + s;
            }
        }
        // add the object and filter by name to the soql
        soql += ' from ' + obj + ' where ';
        if (whereClause!=null && whereClause.trim()!='')
          soql += '('+whereClause+') AND ';
        // add the filter by additional fields to the soql
        soql +='('+nameField+filter;
        if (fieldList != null) {
            for (String s : fieldList) {
                soql += ' or ' + s + filter;
            }
        }
        soql += ') order by '+nameField+' limit 20';
        List<sObject> L = new List<sObject>();
        Set<String> dist  = new Set<String>();
        try {
          system.debug('SOQL:'+soql);
            L = Database.query(soql);
           
           
           for(sObject recordValue : L){
                if (fieldList != null) {
                    for (String s : fieldList) {
                        if(((String)recordValue.get(s))!= null && ((String)recordValue.get(s)).contains(qry)){
                        dist.add(((String)recordValue.get(s)));
                        }
                    }
                }
            }
           
            
        }
        catch (QueryException e) {
            return null;
        }
       return dist;
   }
   
}