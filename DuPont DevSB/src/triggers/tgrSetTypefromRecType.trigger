//This trigger automatically sets the Type picklist depending on

//the recordtype of the parent application record



trigger tgrSetTypefromRecType on Validation_Score__c (before insert, before update) {

  for (Validation_Score__c vs : Trigger.new) {

            vs.Type__c = vs.gsapprectype__c;

                   

        }



}