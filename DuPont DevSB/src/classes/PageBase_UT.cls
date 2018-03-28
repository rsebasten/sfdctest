@isTest
private class PageBase_UT {
  
  public static testMethod void test_PageBase() {  

    PageReference pageRef = Page.sitePage;  
    ApexPages.currentPage().getParameters().put('id', 'ABC123');
    Test.setCurrentPage(pageRef);
    ctrlPageBase controller = new ctrlPageBase();
    controller = new ctrlPageBase(new ApexPages.StandardController(new Contact()));  //test extension
    PageBase base = controller.page;
    system.debug(base.reflect);
    base.getValidProfile('nosuchApp');
    base.addEvent('here is an event to show when debugging');
    for (string ev : base.eventLog)
      system.debug(ev);
    system.debug(base.parameters);
    system.debug(base.headers);
    base.addListner(new MyTestPageListner());
    base.onLoad();
  }
  
  
  public class MyTestPageListner implements PageBase.IPageListner {
    public PageReference onLoad() {
      system.debug('Ding');
      return null;
    }
  }
  /*
  public static testMethod void test_sitePage() {  

    PageReference pageRef = Page.sitePage;  
    ApexPages.currentPage().getParameters().put('id', 'ABC123');
    Test.setCurrentPage(pageRef);
    
    PageBase base = PageBase.getInstance();

  }      
    */


}