//[06142017] Merge&Spin: Created test class for ctrlEncrypt class
@isTest
public class ctrlEncrypt_UT {
    public static testMethod void testEncrypt(){
        ctrlEncrypt ctrl = new ctrlEncrypt();
        ctrl.val='testString';
        String encryptedString1 = ctrl.val;
        String encryptedString = ctrlEncrypt.encrypt('testString');
        string originalString = ctrlEncrypt.decrypt(encryptedString);
        System.assertEquals(originalString,'testString');
    }
}