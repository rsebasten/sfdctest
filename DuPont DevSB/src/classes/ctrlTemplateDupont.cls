public class ctrlTemplateDupont  {


	static {
		PageBase.getInstance().addEvent('Template:static_initblock');
	}
	
	{
		PageBase.getInstance().addEvent('Template:initblock1');
	}

	public  ctrlTemplateDupont() {
		PageBase.getInstance().addEvent('Template:constructor');
	}

	public pageReference init() {
		PageBase.getInstance().addEvent('Template:init()');
		return null;
	}
	
	public void updateLanguage() {
		//System.currentPageReference().getParameters().put('l',isoLang);
		//return null;
	}
	
}