/*******************************************************************************
Copyright Â© 2010 DuPont. All rights reserved. 
Author: Suneil Chetlur
Email: suneil.chetlur@ind.dupont.com
Description: Constructor Class for the Visual force page invoked when the custom
             button 'Quantity Matrix' is used.
Change History: <Ankit20160803 10:00 PM IST> Created two variables “isOppCloned” to check if Opportunity is cloned or not and “oppDuration” to store the value of duration of the opportunity as a part of Issue IS ID-00071084
 ********************************************************************************/

public class QuantitySchedulingController {

  /*******************************************************************************
Beginning Quantity Scheduling Controller class' constructors
   *******************************************************************************/

  private PageReference pageRef = ApexPages.currentPage();
  opportunity proj;
  opportunity []proj1;
  opportunity []proj2;
  opportunity proj23;
  opportunitylineitem []oppli;
  opportunitylineitemschedule []o12;
  product2 []pr;
  public Opportunitylineitem total { get; private set; }
  public double stotal { get; private set; }
  public double s1total { get; private set; }
  public double sqtotal { get; private set; }
  public boolean disen { get; private set; }
  public double q23{get;set;}
  public integer str1{get;set;}
  public double olitem { get; private set; }
  public string abc{get;set;}
  public string accname{get;set;}
  public string oppname{get;set;}
  public product2 []pro { get; private set; }
  public opportunity  tp { get; set; } 
  public opportunitylineitem  transcript { get; set; } 
  public opportunitylineitemschedule trainee { get; set; }
  public Opportunitylineitemschedule quart { get; private set; }
  public static boolean isOppCloned=false; // <Ankit20160803 10:00 PM IST> created to check if Opportunity is cloned or not as a part of Issue IS ID-00071084 Code Coverage: 86% <AK 20160803 10:33 PM IST>
  public static double oppDuration; // <Ankit20160803 10:00 PM IST> created “oppDuration” to store the value of duration of the opportunity as a part of Issue IS ID-00071084 Code Coverage: 86% <AK 20160803 10:33 PM IST>
  public class myexception extends exception{}
  public class my1exception extends exception{}
  string message=null;
  public QuantitySchedulingController(opportunity tp1, opportunitylineitem trans1,opportunitylineitemschedule p){ 
    tp = tp1; 
    transcript = trans1; 
    trainee = p; 
  } 
  public QuantitySchedulingController(double d){
    q23=d;
  }
  public void setmessage(String s){
    this.message = s;
  }
  public String getMessage(){
    return this.message;
  }
  public QuantitySchedulingController(ApexPages.StandardController controller){
    opportunity proj19;
    list<id>b=new list<id>();
    list<id>b1=new list<id>();
    this.proj = (opportunity)controller.getSubject();
    proj1=[select id,name,account.name,Contract_Duration__c,amount_type__c,first_ship_date__c from opportunity where id=:System.currentPageReference().getParameters().get('id')];
    proj19=[select id,name,account.name,Contract_Duration__c,amount_type__c,first_ship_date__c from opportunity where id=:System.currentPageReference().getParameters().get('id')];
    accname=proj19.account.name;
    oppname=proj19.name;

    myexception e21=new myexception('No products available.Add products and try for the matrix again.');
    if(proj19.Contract_Duration__c!=null&&proj19.first_ship_date__c!=null&&proj19.amount_type__c!=null){
      if(proj19.amount_type__c=='One Time - Auto - Monthly'||proj19.amount_type__c=='One Time - Auto - Quarterly'||proj19.amount_type__c=='One Time - Auto - Yearly'){
        if(proj19.Contract_Duration__c!=0){
          this.oppli=[select quantity,opportunityid,Id,unitprice,PriceBookEntry.Product2id,PriceBookEntry.Product2.Name,Description,
                      PricebookEntryId,totalprice from opportunitylineitem where opportunityid 
                      =:System.currentPageReference().getParameters().get('id')];
          if(this.oppli.size()==0)
            throw e21;
          for(opportunitylineitem o1235:this.oppli)
            b.add(o1235.id);
              for(opportunitylineitem o125:this.oppli)
                b1.add(o125.pricebookentry.product2id);
                  this.pr=[select id,Name,Unit_Of_Measure__c from product2 where id in:b1];    
                  this.o12 =[select scheduledate,quantity,id,opportunitylineitemid
                             from opportunitylineitemschedule where opportunitylineitemid in:b order by scheduledate]; 
        }    
      }
    }
    else
      throw e21;
  }
  /*******************************************************************************
Ending Quantity Scheduling Controller class' constructors
   *******************************************************************************/

  /*******************************************************************************
Class whose variables are used in the visualforce page
   *******************************************************************************/

  public class secondcontroller{
    opportunity [] tp1 ;
    opportunitylineitemschedule []o12;
    public list<SecondController> result3{get;set;}
    public opportunity  tp2 { get; set; } 
    public opportunitylineitem transcript2 { get; set; } 
    public opportunitylineitemschedule []trainee2 { get; set; }
    public product2 tr2{get;set;}
    public double q{get;set;}
    public string nam{get;set;}

    public SecondController(opportunity t1, opportunitylineitem tran1,list<opportunitylineitemschedule> p1,product2 prod,double d,string n1) { 
      tp2 = t1; 
      transcript2 = tran1; 
      trainee2 = p1; 
      tr2=prod;
      q=d;
      nam=n1;
    } 
  }

  /*******************************************************************************
Ending Class secondcontroller
   *******************************************************************************/

  public class myclass{
    public opportunitylineitemschedule []opplischd{get;set;}
    public string heade{get;set;}
    public myclass(list<opportunitylineitemschedule> opplisc){
      opplischd =opplisc;
      heade = 'abc';
    }
  }

  /*******************************************************************************
Function to get the schedule(column) headers for monthly/quarterly on 
visualforce page
   *******************************************************************************/

  public list<string> getScheduleHeaders() {
    opportunitylineitem curTrans;
    opportunity proj2;
    list<string> rtn=new list<string>();
    list<string> rtnyr=new list<string>();
    list<string> rtn1=new list<string>();
    list<string> r=new list<string>();
    integer akl=0;
    string quarter;
    string kl;
    my1exception ile=
        new my1exception('Empty or incorrect value in one of the following fields needed by this functionality viz,First Ship Date,Contract Duration,Amount Type.Please save needed changes and try again.');
    try{
      if((this.oppli.size()!=null)){
        for(Opportunitylineitem o3:this.oppli) { 
          curTrans= o3;
          opportunitylineitemschedule curTrainingPath; 
          set<id> l =new set<id>();
          for(opportunitylineitemschedule olis:this.o12){
            l.add(olis.id);
            if(olis.opportunitylineitemid ==o3.id ){
              curTrainingPath=olis;
              rtn.add(String.valueof(curTrainingPath.scheduledate.month()));            
              rtnyr.add(String.valueof(curTrainingPath.scheduledate.year()));         

              string ahj=String.valueof(curTrainingPath.scheduledate.year());
              string ahj1=ahj.substring(2,4);
              rtn1.add(ahj1);
            }
          }
        }
        proj2=[select id,Contract_Duration__c,amount_type__c from opportunity where id=:System.currentPageReference().getParameters().get('id')];
        akl=(proj2.contract_duration__c).intValue();
        if(proj2.amount_type__c=='One Time - Auto - Quarterly'){
          for(integer l=0;l<akl;l++){
            if(rtn.get(l)=='1'||rtn.get(l)=='2'||rtn.get(l)=='3')
              quarter='1Q';
            else if(rtn.get(l)=='4'||rtn.get(l)=='5'||rtn.get(l)=='6')
              quarter='2Q';
            else if(rtn.get(l)=='7'||rtn.get(l)=='8'||rtn.get(l)=='9')
              quarter='3Q';
            else if(rtn.get(l)=='10'||rtn.get(l)=='11'||rtn.get(l)=='12')
              quarter='4Q';
            string kl1=rtn1.get(l)+' ';
            r.add(quarter+'-'+kl1);
          }
        }
        if((proj2.amount_type__c=='One Time - Auto - Monthly')){
          for(integer a=0;a<akl;a++){
            if(rtn.get(a)=='1'){
              kl='Jan';
            }
            else if(rtn.get(a)=='2'){
              kl='Feb';
            }
            else if(rtn.get(a)=='3'){
              kl='Mar';
            }
            else if(rtn.get(a)=='4'){
              kl='Apr';
            }
            else if(rtn.get(a)=='5'){
              kl='May';
            }
            else if(rtn.get(a)=='6'){
              kl='Jun';
            }
            else if(rtn.get(a)=='7'){
              kl='Jul';
            }
            else if(rtn.get(a)=='8'){
              kl='Aug';
            }
            else if(rtn.get(a)=='9'){
              kl='Sep';
            }
            else if(rtn.get(a)=='10'){
              kl='Oct';
            }
            else if(rtn.get(a)=='11'){
              kl='Nov';
            }
            else if(rtn.get(a)=='12'){
              kl='Dec';
            }
            string kl1=rtn1.get(a);
            r.add(kl+kl1);
          }
        }
        if(proj2.amount_type__c=='One Time - Auto - Yearly'){
          for(integer l=0;l<akl;l++){
            r.add('Y'+rtnyr.get(l));
          }
        }  
        return r;
      }
      else{
        return null;
      }
    }
    catch(Exception i){
      throw ile;
    }
  }

  /*******************************************************************************
End of schedule header function
   *******************************************************************************/


  /*******************************************************************************
Beginning getSecondController function
   *******************************************************************************/

  public SecondController[] getSecondController() 
  { 
    list<SecondController> result2=new list<SecondController>(); 
    list<SecondController> result5=new list<SecondController>(); 
    if(getScheduleHeaders()!=null){
      list<string>abc1=new list<string>();
      abc1=getScheduleHeaders();
      integer adf=abc1.size();
      abc=abc1.get(0);
      for(integer f=1;f<adf;f++){
        abc=abc+' '+abc1.get(f);
      }
    }
    this.total = new Opportunitylineitem(quantity = 0); 
    this.stotal=null;
    this.disen=false;
    for(opportunity opportun:this.proj1){
      if(opportun.amount_type__c=='One Time - Auto - Monthly' || opportun.amount_type__c=='One Time - Auto - Quarterly'|| opportun.amount_type__c=='One Time - Auto - Yearly'){
        opportunitylineitem curTrans; 
        product2 pro;            
        list<opportunitylineitem> lin =new list<opportunitylineitem>();
        list<double>liststot=new list<double>();
        for(Opportunitylineitem o3:this.oppli) { 
          for(product2 p:this.pr){
            if(p.id==o3.PriceBookEntry.Product2id)
              pro=p;
          }
          curTrans= o3;
          olitem=o3.quantity;
          if((o3.quantity != null)) {   
            total.quantity += o3.quantity;        
          }
          string nam1;
          if(o3.PriceBookEntry.Product2.Name.length()>10)
            nam1=o3.PriceBookEntry.Product2.Name.substring(0,9);
          else 
            nam1=o3.PriceBookEntry.Product2.Name;
          opportunitylineitemschedule curTrainingPath; 
          list<opportunitylineitemschedule> li =new list<opportunitylineitemschedule>();
          list<double> li8=new list<double>();
          set<id> l =new set<id>();
          for(opportunitylineitemschedule olis:this.o12){
            l.add(olis.id);
            if(olis.opportunitylineitemid ==o3.id ){
              if(olis.quantity==null)
                olis.quantity=0;
              curTrainingPath=olis;
              if(this.proj1.get(0).Contract_Duration__c>li.size())
                li.add(curTrainingPath);
              li8.add(olis.quantity);              
            }
          }
          double tot8;             
          tot8=li8.get(0);
          for(integer r=1;r<li.size();r++){
            tot8+=li8.get(r);
          }
          stotal=tot8;
          liststot.add(stotal);
          result2.add(new SecondController(opportun,curTrans,li,pro,tot8,nam1));
        }
        sqtotal=liststot.get(0);
        for(integer h=1;h<liststot.size();h++){
          sqtotal+=liststot.get(h);
        }         
      }
    }
    return result2; 
    return result5;
  }

  /*******************************************************************************
Ending getSecondController function
   *******************************************************************************/

  /*******************************************************************************
Beginning getmyclassfunction function
   *******************************************************************************/

  public myclass []getmyclass() { 
    list<myclass> result5=new list<myclass>(); 
    list<opportunitylineitemschedule> li =new list<opportunitylineitemschedule>();
    set<id> l =new set<id>();
    opportunitylineitemschedule curTrainingPath; 
    opportunitylineitem curTrans;
    for(Opportunitylineitem o3:this.oppli) { 
      curTrans= o3;
      for(opportunitylineitemschedule olis:this.o12){
        l.add(olis.id);
        if(olis.opportunitylineitemid ==o3.id ){
          curTrainingPath=olis;
          li.add(curTrainingPath);
        }
      }
      result5.add(new myclass(li));
    }
    return result5;
  }
  public opportunitylineitem getol(){
    return this.total;
  }

  /*******************************************************************************
Ending getSecondController function
   *******************************************************************************/

  public void sqa(){
    this.disen=true;
  }
  public pagereference sqb(){
    this.disen=false;
    return null;
  }
  /*******************************************************************************
Beginning function to calculate the total sum based
on the real time inputs provided on the visualforcec page.
   *******************************************************************************/

  public pagereference qwerty(){
    list<double> li81=new list<double>();
    list<opportunitylineitemschedule> li2 =new list<opportunitylineitemschedule>();
    double tot81;  
    for(Opportunitylineitem o3:this.oppli) { 
      this.disen=true;
      for(opportunitylineitemschedule olis:this.o12){
        if(olis.opportunitylineitemid ==o3.id ){
          if(olis.quantity==null)
            olis.quantity=0;
          li2.add(olis);
          li81.add((olis.quantity));              
        }
      }
      tot81=li81.get(0);
      for(integer r=1;r<li2.size();r++){
        tot81+=li81.get(r);
      }
      s1total=tot81;
    }
    getSecondController();
    str1=1;
    return null;
  }

  /*******************************************************************************
Ending function to calculate total sum
   *******************************************************************************/

  public opportunitylineitemschedule get1ols(){
    return this.quart;
  }
  myexception e=new myexception('wromg feed');
  public double tot81{get;private set;}             
  public double dubb(){
    return this.tot81;
  }

  /*******************************************************************************
Beginning saveChanges function to save all the changess made on
visualforce page
   *******************************************************************************/

  public pagereference saveChanges() { 
    list<double> li81=new list<double>();
    list<opportunitylineitemschedule> li2 =new list<opportunitylineitemschedule>();
    double tot81;  
    myexception e=new myexception('Sum of schedule quantities does not match the total quantity.');
    try{
      for(Opportunitylineitem o3:this.oppli) { 
        for(opportunitylineitemschedule olis:this.o12){
          if(olis.opportunitylineitemid ==o3.id ){
            if(olis.quantity==null)
              olis.quantity=0;
            li2.add(olis);
            li81.add((olis.quantity));   
          }
        }
        tot81=li81.get(0);
        for(integer r=1;r<li2.size();r++){
          tot81+=li81.get(r);
        }
      }
      upsert this.oppli;
      upsert this.o12;
      PageReference oppPage = new ApexPages.StandardController(this.proj).view();
      oppPage.setRedirect(true);
      return oppPage;
    }
    catch(DMLException ex){
      string thisid = pageRef.getParameters().get('id');
      PageReference obj = new PageReference(pageRef.getUrl() + '?ID=' + thisid);
      for (Integer i = 0; i < ex.getNumDml(); i++) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(i)));
      }
      pageRef.setRedirect(false);
      return pageRef;
    }
    return null;
  }

  /*****************************************************
Ending saveChanges function
   *****************************************************/

  public opportunity getOpp() {
    return [select id,name,account.name,amount_type__c,Contract_Duration__c,
            (select id,PriceBookEntry.Product2.Name,Quantity,totalprice,UnitPrice,Description,PricebookEntryId
                from OpportunityLineItems limit 5)
                from opportunity where id =:System.currentPageReference().getParameters().get('id')];
  }
}