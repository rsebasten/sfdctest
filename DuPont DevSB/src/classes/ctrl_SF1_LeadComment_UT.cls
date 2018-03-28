/*******************************************************************************
Author: Martin Ryder
Email: martin.ryder@doextra.com
Description:  SF1_LeadComment test class
********************************************************************************/
@isTest
public class ctrl_SF1_LeadComment_UT {
    static testMethod void test_ctrl_SF1_LeadComment() {
  //[05102017] Merge&Spin: Added company field to lead test data      
        Lead l = new lead(lastname='Test',company='test company');
        insert l;
        Apexpages.StandardController sc = new Apexpages.StandardController(l);
        ctrl_SF1_LeadComment lc1 = new ctrl_SF1_LeadComment(sc);
        lc1.newComment='Test';
        lc1.updateComment();
    }
}