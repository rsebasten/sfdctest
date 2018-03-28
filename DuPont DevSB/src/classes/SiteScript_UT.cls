@isTest
private class SiteScript_UT {

/*******************************************************************************
	Test scripts
*******************************************************************************/

public static string createScript() {
	SFDC_Script__c s1 = new SFDC_Script__c(
		name='My test script',
		Available_With__c ='Account;Contact;Lead;Case;Qualification__c',
		WriteToObject__c='Lead',
		AllowContinuation__c=true,
		Use_Scoring__c=true,
		ReturnToValue__c=null, 
		ReturnToType__c=null
		);
	insert s1;
	
	SFDC_Questions__c q1 = new SFDC_Questions__c( 
		WriteToField__c=null, 
		ValidationRegEx__c=null,
		ValidationError__c=null,
		ShortName__c='Q1',
		Script__c=s1.id,
		SaveResult__c=true,
		Question_Coach__c='help',
		OutParameter__c='out',
		Name='Question 1', 
		MinNumber__c=null, 
		MaxNumber__c=null,
		IsVisible__c=true,
		IsRequired__c=false,
		DefaultAnswer__c='A',
		DataType__c='Picklist',
		Answer_Format__c=null,
		AllowChange__c=true
		);
		
	SFDC_Questions__c q2 = new SFDC_Questions__c( 
		WriteToField__c='lastname', 
		ValidationRegEx__c=null,
		ValidationError__c=null,
		ShortName__c='Q2',
		Script__c=s1.id,
		SaveResult__c=true,
		Question_Coach__c='help',
		OutParameter__c='out',
		Name='Question 2', 
		MinNumber__c=null, 
		MaxNumber__c=null,
		IsVisible__c=true,
		IsRequired__c=true,
		DefaultAnswer__c='tester',
		DataType__c='TEXT',
		Answer_Format__c=null,
		AllowChange__c=true
		);

	SFDC_Questions__c q3 = new SFDC_Questions__c( 
		WriteToField__c='company', 
		ValidationRegEx__c=null,
		ValidationError__c=null,
		ShortName__c=null,
		Script__c=s1.id,
		SaveResult__c=true,
		Question_Coach__c='help',
		OutParameter__c=null,
		Name='Question 3', 
		MinNumber__c=null, 
		MaxNumber__c=null,
		IsVisible__c=true,
		IsRequired__c=true,
		DataType__c='TEXT',
		Answer_Format__c=null,
		AllowChange__c=true,
		DefaultAnswer__c='Test Co'
		);
		
		SFDC_Questions__c q4 = new SFDC_Questions__c( 
		Script__c=s1.id,
		SaveResult__c=false,
		Name='Question 4', 
		IsVisible__c=true,
		IsRequired__c=true,
		DataType__c='Section',
		AllowChange__c=false
		);	
		
		SFDC_Questions__c q5 = new SFDC_Questions__c( 
		Script__c=s1.id,
		SaveResult__c=true,
		Name='Question 5', 
		IsVisible__c=true,
		IsRequired__c=false,
		DataType__c='Date',
		AllowChange__c=true,
		DefaultAnswer__c='@today'
		);	
			
		SFDC_Questions__c q6 = new SFDC_Questions__c( 
		WriteToField__c='id',
		Script__c=s1.id,
		SaveResult__c=true,
		Name='Question 6', 
		IsVisible__c=false,
		IsRequired__c=false,
		DataType__c='Text',
		AllowChange__c=false
		);
		
		SFDC_Questions__c q7 = new SFDC_Questions__c( 
		WriteToField__c='description',
		Script__c=s1.id,
		SaveResult__c=true,
		Name='Question 7', 
		IsVisible__c=false,
		IsRequired__c=true,
		DataType__c='integer',
		AllowChange__c=false,
		DefaultAnswer__c='@totalScore'
		);

		SFDC_Questions__c q8 = new SFDC_Questions__c( 
		WriteToField__c=null,
		Script__c=s1.id,
		SaveResult__c=true,
		Name='Question 8', 
		IsVisible__c=true,
		IsRequired__c=true,
		DataType__c='decimal',
		AllowChange__c=false,
		MinNumber__c=10, 
		MaxNumber__c=20,
		DefaultAnswer__c='0',
		ShortName__c='Q8'
		);		
					
		insert new LIST<SFDC_Questions__c> {q1,q2,q3,q4,q5,q6,q7,q8};
		
		SFDC_FollowOnQuestion__c fq1 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q1.id, QuestionOrder__c=1);
		SFDC_FollowOnQuestion__c fq2 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q2.id, QuestionOrder__c=2);
		SFDC_FollowOnQuestion__c fq3 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q3.id, QuestionOrder__c=3);
		SFDC_FollowOnQuestion__c fq4 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q4.id, QuestionOrder__c=4);
		SFDC_FollowOnQuestion__c fq5 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q5.id, QuestionOrder__c=5);
		SFDC_FollowOnQuestion__c fq6 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q6.id, QuestionOrder__c=6);
		SFDC_FollowOnQuestion__c fq7 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q7.id, QuestionOrder__c=7);
		SFDC_FollowOnQuestion__c fq8 = new SFDC_FollowOnQuestion__c(Script__c=s1.id, Question__c=q8.id, QuestionOrder__c=8);
		insert new LIST<SFDC_FollowOnQuestion__c> {fq1,fq2,fq3,fq4,fq5,fq6,fq7,fq8};
		
		SFDC_Answer__c an1 = new SFDC_Answer__c(Score__c=1, Order__c=1, Answer__c='A', Questions__c=q1.id);
		SFDC_Answer__c an2 = new SFDC_Answer__c(Score__c=2, Order__c=2, Answer__c='B', Questions__c=q1.id);
		SFDC_Answer__c an3 = new SFDC_Answer__c(Score__c=3, Order__c=3, Answer__c='C', Questions__c=q1.id);
		insert new LIST<SFDC_Answer__c> {an1,an2,an3};	
		
		return s1.id;
}
	
static testMethod void testSiteScript() {
	
	geovalidation.DisableGeoValidationOverride=true;
	
		string scriptId=createScript();
		
		sitescript ss = new sitescript(scriptId);
		SiteScript.QA qa1 = ss.questions[0];

		system.debug( qa1.allowChange  );
		system.debug( qa1.answer  );
		system.debug( qa1.answerAsNumber );
		system.debug( qa1.answerId  );
		system.debug( qa1.AnswerPicklist  );
		system.debug( qa1.answerType  );
		system.debug( qa1.dataType  );
		system.debug( qa1.developerName  );
		system.debug( qa1.helpText  );
		system.debug( qa1.isOdd  );
		system.debug( qa1.outparam  );
		system.debug( qa1.question  );		
		system.debug( qa1.readonly  );
		system.debug( qa1.required );
		system.debug( qa1.resultId );	
		system.debug( qa1.saveResult );
		system.debug( qa1.score );
		system.debug( qa1.textScore );
		system.debug( qa1.ValidationError );
		system.debug( qa1.visible );
		system.debug( qa1.WriteToField );	
		system.debug( String.valueOf(qa1) );	
		system.debug( qa1.validate());			
		
		ss.clearResultIds();
		ss.getNewHeader(true);
		ss.getNewHeader(false, true);
		ss.getQuestion(1);
		ss.getQuestion('Q1');
		system.debug(ss.validate());
		
		system.debug(ss.OutboundParameters);
		system.debug(ss.visibleQuestions);
		system.debug(ss.WriteToIdQuestion);
		system.debug(ss.writeToType);
		system.debug(ss.WriteToFields);
		system.debug(ss.WriteToId);
		system.debug(ss.WriteToIdQuestion );
		system.debug(ss.Name);
		system.debug(ss.OutboundParameters);	
		system.debug('--get an nonexistant question:'+ss.getQuestion('Q12'));
		
		ss.save();
		ss.returnPageReference();
		ss.WriteOutboundParameters();
		
		SiteScript.QA decQA = ss.getQuestion('Q8');
		system.debug('decimalQA:'+decQA);
		//fail validation - needs to be between 10-20
		decQA.answer='4.0';  //
		system.assertEquals(false, decQA.validate() ); 
		//pass this one
		decQA.answer='15.6';  
		system.assertEquals(true, decQA.validate()); 
		//save again...
		ss.save();
		
		ss.setReadOnly(true);
		
		
	}

}