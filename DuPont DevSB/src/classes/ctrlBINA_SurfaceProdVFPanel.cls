public with sharing class ctrlBINA_SurfaceProdVFPanel {
    public Case c;
    public string counter{get;set;}
    public integer size {get;set;}
    public SelectOption[] SelectedMaterials                     { get; set; }  
    public SelectOption[] AllMaterials                          { get; set; }
public ctrlBINA_SurfaceProdVFPanel (ApexPages.StandardController controller) {    
     
    string id= ApexPages.currentPage().getParameters().get('ID');
    system.debug('the id is:-------------'+id);
    c = [SELECT Id,product_selected__c from Case where Id=:id];
    String[] Product_case=c.product_selected__c.split('\\;');
    SelectedMaterials = new List<SelectOption>();
    size=Product_case.size()+2;
    for(integer j=0 ;j<Product_case.size();j++ ){
      SelectedMaterials.add(new SelectOption(Product_case[j], Product_case[j]+'        ',true));}
    }
}