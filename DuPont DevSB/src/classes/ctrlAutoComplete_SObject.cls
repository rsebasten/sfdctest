/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Controller for component  autoComplete_SObject
  will need to grant acess to this controller, as this uses a global @RemoteAction
********************************************************************************/
global with sharing class ctrlAutoComplete_SObject {

    @RemoteAction
    global static SObject[] query(string obj, string qry, string addFields, string whereClause) {
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
        try {
          system.debug('SOQL:'+soql);
            L = Database.query(soql);
           
           /*
            //Cleans the data (SF issue serializing sobject list to JSON containing Trademark symb)
            for ( Sobject so : L) {
              if (so.get(nameField)!=null)
                so.put(nameField,String.valueOf(so.get(nameField)).replace('™',''));
              for ( string fn : fieldList) {
                Object o=so.get(fn);
                if (o!=null && String.valueOf(o).contains('™'))
                  so.put(fn,String.valueOf(o).replace('™',''));
              }
            }
            */
            
        }
        catch (QueryException e) {
            return null;
        }
        return L;
   }
   
   //LIST<Sobject> clean(SObject[] sos) {
   //  for (Sobject so : sos) {
   //    for Sobject
   //}
   //}
}