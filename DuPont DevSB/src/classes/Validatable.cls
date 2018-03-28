/*******************************************************************************
Copyright © 2011 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description:  Abstract class used when validating a list of records.  

To use: wrap object, etc.. and extend using the Validatable class. 
Ex:
	public class ValidationResult extends Validatable {
		public CampaignMember member 	{get; set;}
		public ValidationResult(CampaignMember aMember) { this(aMember,null); }
		public ValidationResult(CampaignMember aMember,LIST<Validatable.Message> msgs) {
			member=amember;
			this.messages=msgs;
		}
	}	
	
TES20140127 Added method addValidationMessage(string msg, string severity)
********************************************************************************/
public abstract class Validatable {
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		

		public LIST<Validatable.Message> messages			{get; set;}
		public Validatable() {
		messages = new LIST<Validatable.Message>();
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		public boolean hasErrors 	{ GET { return (errorMessages.size()>0); }}
		public boolean hasWarnings 	{ GET { return (warningMessages.size()>0); }}
		public boolean hasInfos 	{ GET { return (infoMessages.size()>0); }}
		
		public LIST<Validatable.Message> errorMessages {
			get {
				LIST<Validatable.Message> rtn=new LIST<Validatable.Message>();
				for (Validatable.Message vm : messages)
					if (vm.severity=='ERROR') rtn.add(vm);
				return rtn;
			}
		}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		
		public LIST<Validatable.Message> warningMessages {
			get {
				LIST<Validatable.Message> rtn=new LIST<Validatable.Message>();
				for (Validatable.Message vm : messages)
					if (vm.severity=='WARNING') rtn.add(vm);
				return rtn;
			}
		}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		
		public LIST<Validatable.Message> infoMessages {
			get {
				LIST<Validatable.Message> rtn=new LIST<Validatable.Message>();
				for (Validatable.Message vm : messages)
					if (vm.severity=='INFO') rtn.add(vm);
				return rtn;
			}
		}	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
		public void addValidationMessage(string msg, string severity) {
			messages.add(new Message(msg,severity.toUppercase()));
		}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
	
	public class Message {
		public string severity 					{get; set;}
		public string message					{get; set;}	
		public Message(string s,string msg) {
				 severity=s.toUpperCase();
				 message=msg;
			}
		public string toString { GET { return severity+': '+message;}}
	}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
	public string toString {
		GET {
		string rtn='';
		for (Validatable.Message vm : errorMessages)
			rtn+=vm.toString+'<br/>';
		for (Validatable.Message vm : warningMessages)
			rtn+=vm.toString+'<br/>';
		for (Validatable.Message vm : infoMessages)
			rtn+=vm.toString+'<br/>';	
		return rtn;	
		}	
	}
	
}