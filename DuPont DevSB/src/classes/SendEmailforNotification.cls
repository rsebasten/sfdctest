public class SendEmailforNotification{
    private static boolean run = true; 
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public static void Notifiyusers(Set<ID> accountids){
        if(runOnce()){
            try{
                list<CDR_Notification__c> cdrlist = new list<CDR_Notification__c>();
                list<User> userlist = new list<User>();
                List<string> useremailset = new List<string>();
                List<Id> UserIds=new List<Id>(); 
                List<Id> cdrIdList = new List<Id>();
                /***************Code to Send Notification Email ****************/ 

                cdrIdList.addAll(accountids);
                if(cdrIdList.size()==1){   
                    cdrlist = [select id,Customer_Data_Request__c,User__c  from CDR_Notification__c where Customer_Data_Request__c in : cdrIdList];
                }
                if(cdrlist.size()>0){
                    for(CDR_Notification__c cd : cdrlist){

                        UserIds.add(cd.User__c);
                    }
                }
                if(UserIds.size()>0){
                    EmailTemplate template =  [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = 'Notification_For_Dupont_Marketing_Rep_Manager' LIMIT 1];
                    userlist = [select id,name,email from User where Id in : UserIds];
                    String[] toaddress= new List<String>();
                    if(userlist.size()>0){
                        for(User u : userlist){
                            toAddress.add(string.valueOf(u.email));
                        }
                    }
                    Id whatId = cdrlist[0].Customer_Data_Request__c;
                    Contact cnt = new Contact();
                    cnt.LastName='test';
                    cnt.Email='test@dupont.com';
                    insert cnt;
                    List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setWhatId(whatID);
                    msg.setTemplateId(template.Id);
                    msg.setTargetObjectId(cnt.id);
                    msg.setToAddresses(toAddress);
                    msgList.add(msg);
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(msgList); // Dummy email send
                    delete cnt;
                }
            }
            catch(Exception e){
                system.debug('========Exception========='+e);
            }
        }
    }
}