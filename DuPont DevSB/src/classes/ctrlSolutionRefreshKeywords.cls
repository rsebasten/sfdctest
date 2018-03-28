public without sharing class ctrlSolutionRefreshKeywords {

public PageReference init() {
    string sid = ApexPages.currentPage().getParameters().get('id');
  //  SolutionKeywords.refreshSolutionKeywords(new SET<Id> {sid});
    return new PageReference('/'+sid);
    }

}