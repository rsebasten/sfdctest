public class Spam
{

Map<string, SpamPattern__c> spamwords;

public Spam()
{
    spamwords = SpamPattern__c.getAll();
    for (string w : spamwords.keySet()) {
        System.debug('SPAMWORD: ' + spamwords.get(w).regex__c);
    }
}

public boolean isSpam(String txt)
{
    boolean spam_status=false;
    for (string w : spamwords.keySet()) {
        if (Pattern.matches(spamwords.get(w).regex__c,txt.toUpperCase())) {spam_status=true;}
    }
    return spam_status;
}
/*--
public static testMethod void testSpam(){
    Spam spm = new Spam();
    String test='href';
    spm.isSpam(test);
}
*/
}