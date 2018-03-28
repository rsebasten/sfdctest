public class accountSBU {

public static void registerSBU(Account[] accgr){
for(Account a:accgr){
if(a.Owning_Organization__c != null){
String[] sbuLevels = a.Owning_Organization__c.split('-');
if(sbuLevels[0].equals('ENGR') || sbuLevels[0].equals('FIN') || sbuLevels[0].equals('FS&RE') || sbuLevels[0].contains('CORP') || sbuLevels[0].equals('HR') ||sbuLevels[0].equals('IT&S') ||sbuLevels[0].equals('LEGL') ||sbuLevels[0].equals('S&L')){
sbuLevels[0]='Function';
}else if(sbuLevels[0].equals(' ') || sbuLevels[0].equals('')){
sbuLevels[0]='Not Defined';	 
}
a.Owning_SBU_Org__c = sbuLevels[0];
}else{
a.Owning_SBU_Org__c = 'Not Defined';
}
}
}
}