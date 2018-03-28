/*******************************************************************************
Copyright © 2014 DuPont. All rights reserved. 
Author: Sravanthi Lakkimsetty
Email: sai-sravanthhi.lakkimsetty@bra.dupont.com
Description:  Controller for page: DPTIPPLogosPage
/***********************************************Modification Log************************************************
<BR20140901>
Last Modified By    :   Brundha Rajkumar
Last Modified Date  :   01-Sep-2014
Description         :   1.Added userRegion for disclaimer page block rendering(1.0)
                        2.Added userRegion query for disclaimer page block rendering(1.1)
                        3.Added FolderName for document query based on userRegion and modified developername assigned to FolderName  starts(1.2)
                        4.Added the logos to the map
                        5.Added userRegion in OR condition for the preview and download link

<BR20140910>
Last Modified By    :   Brundha Rajkumar
Last Modified Date  :   10-Sep-2014
Description         :   Logos(Previews not available) for EMEA

<BR20140923>
Last Modified By    :   Brundha Rajkumar
Last Modified Date  :   23-Sep-2014
Description         :   Added user region condition for EMEA and NA
*****************************************************************************************************************

********************************************************************************/

public class ctrlDPTIPPLogos {

    public ID conID {get; set;}
    public ID AccID  {get;set;}
    public List<Qualification__c> qualList{get; set;}
    public boolean displayPopUpFlag {get; set;}
    Public boolean downloadPopUpFlag{get; set;}
    public boolean displayMainPage{get; set;}
    public boolean displayDisclaimerPage{get; set;}
    public boolean displayError{get; set;}  
    Public List <Document> LogoJPGList{get; set;}
    Public List <Document> LogoJPGList1{get; set;}
    Public List <Document> LogoJPGList2{get; set;}
    Public String SelectedLogo{get; set;}
    Public String Extension{get; set;}
    Public Map<String,List<Document>> LogoMap;
    Public String FinalLogo {get; set;}
    Public String FinalLink {get; set;}
    Public boolean IsPortalUser;
    Public boolean IsPortal;
    Public boolean IsExtensionPresent{get; set;}
    Public Static ID LOGO_FOLDERID;    
    //<BR20140901> Ver 1.0
    public string userRegion{get;set;}
     //<BR20140901> Ver 1.3    
    private string FolderName;
    //<BR20140910> starts
    Public List <Document> LogoNoPreveiwList{get; set;}
    Public List <Document> LogoNoPreveiwList1{get; set;}
    Public List <Document> LogoNoPreveiwList2{get; set;}
    Public boolean PreviewsNtAvail{get;set;}
    //<BR20140910> ends
    public ctrlDPTIPPLogos () {
        //<BR20140901>  Ver 1.1
        userRegion=[SELECT User_Region__c from User WHERE id=:UserInfo.getUserId()].User_Region__c;
        //<BR20140910> starts
        PreviewsNtAvail=false;
        //<BR20140910> ends
        displayMainPage=true;
        IsExtensionPresent = true;
        FinalLogo ='';
        conID = [Select contactid from User where id =:Userinfo.getUserid()].contactId;
        if(conID == null){
            displayMainPage=true;
            displayDisclaimerPage = false;
            displayError = false;
            IsPortalUser=false;
        }
        else{
            IsPortalUser=true;
            AccID  = [Select Contact.AccountId from Contact where id =:conID].AccountId;
            qualList = [Select ID,Type__c,Program__c,Owning_Org__c,RecordType.Name,DuPont_Agreement_Verified__c,Qualification_Date__c from Qualification__c where Account_Name__c =:AccID and RecordType.Name='Partner Qualification' Limit 1 ];
            if(qualList.size()==0) {
                displayMainPage=false; 
                displayDisclaimerPage =false;
                displayError = true;
            }
            else {                                       
                if((qualList.get(0).type__c) == 'Brand License' &&  (qualList.get(0).Owning_Org__c)== 'DPT' && (qualList.get(0).Program__c)== 'DPT-IPP' && (qualList.get(0).RecordType.Name).equals('Partner Qualification')){
                    if(qualList.get(0).DuPont_Agreement_Verified__c==TRUE){
                        displayMainPage=true;
                        displayDisclaimerPage = false; 
                        displayError = false;
                    }
                    else {
                        displayMainPage=false; 
                        displayDisclaimerPage = true;
                        displayError = false;
                        PageReference pageRef= new PageReference('/apex/DPTIPPLogosPage');
                        pageRef.setRedirect(false);
                    }      
                }
                else{
                    displayMainPage=false; 
                    displayDisclaimerPage  = false;
                    displayError = true;
                }
            }
        }
        //<BR20140901> Ver 1.2 starts
        if(userRegion!=null && userRegion!='' && userRegion=='EMEA'){
        FolderName='DPT_IPP_EMEA_Distributor_Portal_Logos';
        }
        else if(userRegion!=null && userRegion!='' && userRegion=='North America'){
        FolderName='DPTIPP_Distributor_Portal_Logos';
        }
        // <BR20140923>
        if(userRegion!=null && userRegion!='' &&(userRegion=='EMEA' ||userRegion=='North America' ))
        LOGO_FOLDERID = [Select Id,Name,DeveloperName,Type from Folder where DeveloperName=:FolderName and Type='Document' limit 1].Id;
        //<BR20140901> Ver 1.2 ends
        
        getContentList();
        String pageUrl = URL.getCurrentRequestUrl().toExternalForm();
        String hostUrl=System.URL.getSalesforceBaseUrl().toExternalForm();
        if(pageUrl.startsWith(hostUrl)){
            String stringName = pageUrl.substring(hostUrl.length(),
                    pageUrl.length());
            if(stringName.contains('/DPTPartnerCommunity')){
            System.debug('Entered if');
                IsPortal = true;
            }
            else {
                IsPortal = false;
            } 
        }
    }


    /* Follwoing methods are used in Disclaimer page for applying pop up logic and going to specific page on button click */  
    /**
     * Name: closePopup
     * Params: None
     * Description: Method to set flag variable value to false to stop displaying pop up in disclaimer page
     */

    public void closePopup() {        
        displayPopUpFlag = false;    
    } 

    /**
     * Name: showPopup
     * Params: None
     * Description: Method to set variable value to true to display pop up in disclaimer page
     */

    public void showPopUp() {        
        displayPopUpFlag = true;    
        displayMainPage=false;
    }

    /**
     * Name: samePage
     * Params: None
     * Description: Method to set variable value to false to stop displaying pop up in disclaimer page and be on the same page
     */  

    public pageReference samePage(){
        displayPopUpFlag = false; 
        return null;
    }


    /**
     * Name: directHomePage
     * Params: None
     * Description: Method to check the url of the current and accordingly direct the user to specific home page.
     */
    public PageReference directHomePage() {
        PageReference pageRef;
        String pageUrl = URL.getCurrentRequestUrl().toExternalForm();
        String hostUrl=System.URL.getSalesforceBaseUrl().toExternalForm();
        if(pageUrl.startsWith(hostUrl)){
            String stringName = pageUrl .substring(hostUrl.length(),
                    pageUrl.length());
            if(stringName.contains('/DPTPartnerCommunity')){
                pageRef= new PageReference(hostUrl +'/DPTPartnerCommunity/home/home.jsp');
            }
            else {
                pageRef= new PageReference(hostUrl + '/home/home.jsp');
            } 
        }

        return pageRef;
    }

    /**
     * Name: directMainPage
     * Params: None
     * Description: Method to set variables value in qualification to indicate the agreement signed
     */
    public void directMainPage(){
        displayMainPage = true; 
        displayDisclaimerPage =false;
        displayError = false;
        qualList.get(0).DuPont_Agreement_Verified__c=TRUE;
        qualList.get(0).Qualification_Date__c=date.Today();
        update qualList;

    }

    /**
     * Name: getContentList
     * Params: None
     * Description: Method to fetch all the Logos that need to be displayed in on the Page  
     */
    Public void getContentList(){
        List <Document> LogoList = new List<Document>();
        LogoJPGList= new List<Document>();
        LogoJPGList1= new List<Document>();
        LogoJPGList2= new List<Document>();
        //<BR20140910> starts
        LogoNoPreveiwList1=new List<Document>();
        LogoNoPreveiwList2=new List<Document>();
        LogoNoPreveiwList=new List<Document>();
        //<BR20140910> ends
        LogoMap = new Map<String,List<Document>>();
        if(LOGO_FOLDERID!=null)
        LogoList = [SELECT Description, FolderId,Id, Name,Type, Url FROM Document where FolderId=:LOGO_FOLDERID order by Name ];
        if(LogoList.size()!=0){
            for(Document doc: LogoList ){
            //<BR20140901> Ver 1.3 code starts for NA
            if(userRegion=='North America'){
            //<BR20140901> Ver 1.3 code Ends
                List<Document> tempList = new List<Document>();
                if(doc.Type=='JPG'){
                    LogoJPGList.add(doc);
                }
                if(LogoMap.ContainsKey(doc.Name)){
                    tempList.addAll(LogoMap.get(doc.Name));
                }
                tempList.add(doc);
                LogoMap.put(doc.Name,tempList);
                //<BR20140901> Ver 1.3 code starts for EMEA
                }
              else if(userRegion=='EMEA'){
              List<Document> tempList = new List<Document>();
              tempList.add(doc);
              //<BR20140910> starts
              if(doc.type=='jpg' || doc.type=='png')
              //<BR20140910> ends
                  LogoJPGList.add(doc);
              //<BR20140910> starts
               else
                  LogoNoPreveiwList.add(doc);
               //<BR20140910> ends
                  LogoMap.put(doc.Name,tempList);
                }
                //<BR20140901> Ver 1.3 code ends for EMEA
            }

            for(integer i=0;i< LogoJPGList.size();i++){
                if(math.mod(i,2)==0){
                    LogoJPGList1.add(LogoJPGList.get(i));
                }
                else{
                    LogoJPGList2.add(LogoJPGList.get(i));
                }
            }
            //<BR20140910> starts
            if(LogoNoPreveiwList.size()!=0){
            PreviewsNtAvail=true;
            for(integer i=0;i< LogoNoPreveiwList.size();i++){
               if(math.mod(i,2)==0){
                   LogoNoPreveiwList1.add(LogoNoPreveiwList.get(i));
                }
                else{
                   LogoNoPreveiwList2.add(LogoNoPreveiwList.get(i));
                }
            }
            }
           //<BR20140910> Ends
        }
    }

    /**
     * Name: openDownloadPopUpFlag
     * Params: None
     * Description: Method to set variable to true to indicate that the pop up for selection of template opens  
     */
    public void openDownloadPopUpFlag() {        
        downloadPopUpFlag= true;
    }

    /**
     * Name: closeDownloadPopUpFlag
     * Params: None
     * Description: Method to set variable to false to indicate that the pop up for selection of template be closed  
     */
    public void closeDownloadPopUpFlag() {        
        downloadPopUpFlag= false; 
        SelectedLogo = '';  
        Extension = ''; 
    }

    /**
     * Name: downloadLogo
     * Params: None
     * Description: Method to set the download link based on the portal/internal user access and based on the logo and image type selected  
     */
    Public void downloadLogo(){
        FinalLogo ='';
        FinalLink='';
        system.debug(SelectedLogo+'SelectedLogoSelectedLogo');
        for(String LogoName :LogoMap.KeySet()){
            if(LogoName == SelectedLogo){
                for(Document logo: LogoMap.get(LogoName)){
                //<BR20140901> Ver 1.2
                   if((logo.type==Extension && userRegion=='North America') || userRegion=='EMEA'){
                        FinalLogo = logo.id;
                    }
                    
                }
            }
        }
       
        if(string.IsBlank(FinalLogo)){
            IsExtensionPresent=false;
            downloadPopUpFlag=true;
            SelectedLogo = '';  
            Extension = ''; 
        }
        else{
            if(IsPortal ==false){
                FinalLink='/servlet/servlet.FileDownload?file='+FinalLogo ;
            }
            else{
                FinalLink='/DPTPartnerCommunity/servlet/servlet.FileDownload?file='+FinalLogo ;
            }
            IsExtensionPresent=true;
            downloadPopUpFlag= false; 
            SelectedLogo = '';  
            Extension = ''; 
        }
        system.debug(FinalLink+'FinalLinkFinalLink');
        system.debug(SelectedLogo+'SelectedLogoSelectedLogo');
        system.debug(FinalLogo+'FinalLogoFinalLogo');
    }

    /**
     * Name: logoExtensionNotAvailable
     * Params: None
     * Description: Method to set the variable to true to indicate the image type is not available.  
     */
    Public void logoExtensionNotAvailable(){
        downloadPopUpFlag=false;
        IsExtensionPresent=true;
    }

}