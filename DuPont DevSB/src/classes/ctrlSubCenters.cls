public class ctrlSubCenters {
	

	public static string email 					{set; get;}
	public static string isoLang 				{set; get;}
	public static string lastUpdatedLocation	{set; get;}
	public static string tag	  				{set; get;}
	public static string HeaderFooter			{set; get;}	
	public boolean err  						{set; get;}
	public string errMsg  						{set; get;}
	public boolean showList						{set; get;}


	private MAP<id, SiteObject__c> mapCenters;	
	
public pageReference init() {

		err=false;
		email 					= ApexPages.currentPage().getParameters().get('em');
		tag 					= ApexPages.currentPage().getParameters().get('t');
		isoLang 				= ApexPages.currentPage().getParameters().get('l');
		lastUpdatedLocation 	= ApexPages.currentPage().getParameters().get('src');
		HeaderFooter			= ApexPages.currentPage().getParameters().get('hf');
		
		//decode email if encoded
		if ( email!=null && (! email.contains('@'))) {
			email=System.Encodingutil.base64Decode(email).toString();
		}
		
		
		if (tag==null) 
			tag='global';
		
		mapCenters = new MAP<id, SiteObject__c> ([
				Select Id, PublicName__c, PublicDescription__c
				From SiteObject__c
				where type__c = 'Subscription Center'
					AND IsPublic__c=true
					AND tags__c includes (:tag)
				order by PublicName__c
				]);
		
		SiteBuilder.translateSiteObjects(mapCenters,isolang);
		
		return null;
	}


	public LIST<centerLink> centers {
		get { 
			//map the centerlinks by publicname (key)
			MAP<string,centerLink> centerlinks = new MAP<string,centerLink>();
			if  (mapCenters != null )
				for (SiteObject__c so : mapCenters.values() )
					centerlinks.put(so.publicname__c, new centerLink(so));
			
			//sort the keys
			LIST<string> sortkey = new List<string>();
			for (string s : centerlinks.keyset() ) 
				sortkey.add(s);
			sortkey.sort();
		
			//Reorder alpha
			integer order=0;
			LIST<centerLink> rtn = new centerLink[sortkey.size()];
			for (string s : sortkey ) {
				if ( centerlinks.containskey(s) )
					rtn[order++]=centerlinks.get(s);
			}
		 
		 	return rtn;
		}	
	}	
	
	
	public class centerLink {
		public string 	name			{set; get;}
		public string	description		{set; get;}
		public string	url				{set; get;}
		
		public centerLink (SiteObject__c so) {
			this.name=so.PublicName__c;
			this.description = so.PublicDescription__c;
			pageReference pg = Page.subcenter; 
			this.url = 'http://'+ApexPages.CurrentPage().getHeaders().get('Host')+pg.getUrl()+'?&cid='+so.id;
			if (isoLang!=null) 				this.url += '&l='+isoLang;
			if (email!=null) 				this.url += '&em='+SubscriptionCenter.hash(email);
			if (lastUpdatedLocation!=null) 	this.url += '&src='+lastUpdatedLocation;
			if (HeaderFooter!=null) 		this.url += '&hf='+HeaderFooter;
	
		}
		
	}


////////////////////////////////////////////////////////////////////////////////////
//		Test script(s)
////////////////////////////////////////////////////////////////////////////////////

	public static testMethod void test_ctrlSubCenters1() {
		SubscriptionCenter.TESTMODE=true;
		string CenterId = SubscriptionCenter.testAddSubCenter('Center1');
	
			Test.startTest();
			PageReference pageRef = Page.SubCenters;
			Test.setCurrentPage(pageRef);
			ctrlSubCenters controller = new ctrlSubCenters();
			ApexPages.currentPage().getParameters().put('cid', CenterId);
			ApexPages.currentPage().getParameters().put('em', 'tom@3ddd.com');
			ApexPages.currentPage().getParameters().put('src', 'testMethod');
			ApexPages.currentPage().getParameters().put('hf', '0');
			controller.init();
			system.debug('--------test_ctrlSubCenters1:centers---->'+controller.centers);
			
					
			Test.stopTest();
	}
	
}