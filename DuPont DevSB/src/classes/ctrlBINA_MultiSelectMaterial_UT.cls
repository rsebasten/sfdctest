/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Copyright © 2014 DuPont. All rights reserved. 
//Name :ctrlBINA_EnvelopesRegistration
//Author :Rajiv Kumar Bhatter<Rajiv_Bhatter@infosys.com>, Sanjay Nandi<Sanjay_Nandi@infosys.com>
//Description: This  UT class for controller  ctrlBINA_MultiSelectMaterial
//************************************<MG-20140827>***************************************************//
@isTest
private class ctrlBINA_MultiSelectMaterial_UT{
    static testMethod void testctrlBINA_MultiSelectMaterial() {
        ctrlBINA_MultiSelectMaterial c = new ctrlBINA_MultiSelectMaterial();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();
        
        Material__c []m= new LIST <Material__c>{
            new material__C(name='material1'),
            new material__C(name='material2'),
            new material__C(name='material3'),
            new material__C(name='material4'),
            new material__C(name='material5')
            }; 
        insert m; 
        system.debug('the size is '+m.size());
        c.leftOptionsHidden='';    
        for(Integer i=0;i<m.size();i++){
            if(i<(m.size()-1)){
            c.leftOptionsHidden +=m[i].name+'&';
            c.leftOptionsHidden +=m[i].name+'&';}
            else{
            c.leftOptionsHidden +=m[i].name+'&';
            c.leftOptionsHidden +=m[i].name;
           }
        }
        c.rightOptionsHidden = '';
         system.debug('the size is '+c.leftOptionsHidden);
        system.debug('the size is '+c.leftOptions.size());
        system.debug('the size is '+c.leftOptions[0]);
        system.debug('the size is '+c.leftOptions[1]);
        System.assertEquals(c.leftOptions.size(), 5);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}