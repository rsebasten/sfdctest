/*******************************************************************************
Copyright © 2010 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Singlton class used for storing data/state across pages
that use the Controller: ctrlPageBase
********************************************************************************/

//cannot have static virtual methods
//static_initblock will always get executed on ajax callbacks
//cannot call base class methods in the static_initblock (expected)
//static properties in components need to be stored in page for rehidration, where non-static are held in viewstate
//static variables are only persistant thoughout the request (new page, callback),  if you need them

//when using extends you must use non-static getter and setter methods in the extend class to expose a static variable to class initiator,  
//NOTE: non-static properties are exposed without the need of getter and setter methods
 
public virtual class PageBase {
  
  private static PageBase      instance     = null;
     private  LIST<IPageListner>    listners    = new LIST<IPageListner>();
     //private LIST<PageStep>      pages      = new LIST<PageStep>();
     
     private MemberPortal.Key     m_memberInfo  = null; 
  //private string           m_action    = null;   
  //public string          activeStep    {set; get;}
  public boolean           loaded      {set; get;}
  public string          isolang      {set; get;} 
  public string          memberKey    {set; get;} 
  public string          pageWidth     {set; get;} 
  public string           lnavWidth     {set; get;} 
  public boolean           showLNAV     {set; get;}
  public boolean           showFooter     {set; get;} 
  public boolean           showHeader     {set; get;} 
  public boolean           debug       {set; get;}
  //public MemberPortal.Key  sess;    {set; get;}
  public LIST<string>       eventLog    {set; get;}
  //private static LIST<string> s_eventLog = null;
  
   protected PageBase() {

         eventLog   = new LIST<string>();
         addEvent('PageBase.constructor');
         loaded    = false;
      debug      =(System.currentPageReference().getParameters().get('debug')!=null);
      isolang   = System.currentPageReference().getParameters().get('l');
      pageWidth  = System.currentPageReference().getParameters().get('pw');
      if (pageWidth==null) pageWidth='732px';
      if (! (pageWidth.endsWith('px') || pageWidth.endsWith('%')) ) pageWidth+='px';
      lnavWidth  = '50px';
      if (memberKey==null) memberKey=System.currentPageReference().getParameters().get('key');
      if (System.currentPageReference().getParameters().get('isdtp')=='mn' || System.currentPageReference().getParameters().get('skn')=='0') {
        showLNAV  = false;
        showFooter  = false;
        showHeader  = false;
      }
      else {
        showLNAV  = true;
        showFooter  = true;
        showHeader  = true;
      }  
   }
    
   
   public static PageBase getInstance() {
  
      if(instance == null) {
         instance = new PageBase();
      }
      instance.addEvent('PageBase:getInstance()'); 
      return instance;
   }
   

  public  MemberPortal.Key memberInfo {
    GET {
      if (m_memberInfo == null && this.memberKey!=null) 
        m_memberInfo =  new MemberPortal.Key(this.memberKey);
       return m_memberInfo;
    }
  } 
  
  public  MemberPortal.Profile getValidProfile(string appName) {
    return ( memberInfo!=null &&  memberInfo.isValidFor(appName)) ?  memberInfo.Profile : null;
  }  
  
  

/*
  public  string Action {
    GET {
      if (m_Action == null ) m_Action =  'init';
       return m_Action;
    }
    SET {
      if ()
        m_memberInfo =  new MemberPortal.Key(this.memberKey);
       return m_memberInfo;
    }
  }
*/
  
  static {
    getInstance().addEvent('PageBase:static_initblock');
  }  
  
  {
    //addEvent('PageBase:initblock,1');
    //addEvent('PageBase:initblock:reflect(this)='+String.valueOf(this));
  }


  public string reflect {
    GET { return String.valueOf(instance); }
  }  
  

  public LIST<string> headers {
    GET {
      LIST<string> rtn = new LIST<string>();
      for (string h : System.currentPageReference().getHeaders().keySet())
        rtn.add(h+':'+System.currentPageReference().getHeaders().get(h));
      return rtn;  
    }
  }
  
  public LIST<string> parameters {
    GET {
      LIST<string> rtn = new LIST<string>();
      for (string p : System.currentPageReference().getParameters().keySet())
        rtn.add(p+':'+System.currentPageReference().getParameters().get(p));
      return rtn;  
    }
  }
  public void addEvent(string s) {
    if (debug==null || debug)
      eventLog.add(+datetime.now().format('ss:SSSS')+':'+s);
  }


   
/*******************************************************************************
  use listeners to bubble events
*******************************************************************************/

   public void addListner(IPageListner l) {
    listners.add(l);
   }
   
  public interface IPageListner {
    PageReference onLoad();  
  }
  

  public PageReference onLoad() {
    addEvent('PageBase:onLoad()'); 
    loaded=true;
    for (IPageListner l : listners) {
      PageReference p = l.onLoad();
      if (p!=null) return p;
    }
    return null;
  }

}