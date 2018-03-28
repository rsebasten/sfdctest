/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Kusuma Kumar
Email: Kusuma.Kumar@usa.dupont.com
Date : 30th May 2011
Description : WrapperClass for RegistrationRenewalUpdate , contains the Program value,
			  Material Regulatory Status value and Checkbox. Used to display the Program
			  and Material Regulatory Status Values along with the checkboxes for selection
**************************************************************************************************************/
public class wrapperRenewalUpdate {
	public Boolean checked{get;set;}
    public String program{get;set;}
    public String status{get;set;}
    //Wrapper class constructor which sets the Program values to the String value passed 
    public wrapperRenewalUpdate(String s){
    	program=s;
    	status=s;
    	checked=false;
    }
}