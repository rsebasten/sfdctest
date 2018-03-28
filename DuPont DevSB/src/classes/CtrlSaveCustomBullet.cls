/*********************************************************************************************
(C)2016
Author: Pallavi Sharma
Email: pallavi.sharma3@tcs.com
Description:  This class insert the record in BA Threat master for custom bullets
****************************************************************************************************/
@RestResource(urlMapping='/SaveCustomBullet/*')
global class CtrlSaveCustomBullet{

@HttpPost
global static CtrlKevlarSvcHelper.ReturnClass doPost(){
    CtrlKevlarSvcHelper h = new CtrlKevlarSvcHelper();
	RestRequest req = RestContext.request;
	RestResponse res = RestContext.response;
	
	try{
		List<Threat_Master__c> threatList = new List<Threat_Master__c>();
		String prettyJSON;
		List<Testing_Req_for_Threat__c> testingNeeds = new List<Testing_Req_for_Threat__c>();
		MainWrapper wrap = (MainWrapper)JSON.deserialize(req.requestBody.toString(),MainWrapper.class);
        system.debug('req.requestBody---' + req.requestBody.toString());
		List<Threat_Master__c> totalBulletMaster = [select id, name from Threat_Master__c where threat_Type__c = 'Bullet' limit 1000]; 		
			if(wrap != null){
				Threat_Master__c threat = new Threat_Master__c();
				threat.Name = wrap.bulletName;
				threat.Active__c = true;
				threat.Threat_Type__c = 'Bullet';
				threat.Type__c = wrap.bulletType;
				threat.Weight__c = wrap.weight;
				threat.Velocity__c = wrap.velocity;
				threat.v50__c = wrap.v50;
				threat.Velocity_Tolerance_m_s__c = wrap.range;
				threat.Shooting_Distance__c = wrap.shootingDistance;
				threat.Shooting_Mechnism__c = wrap.shootingMechanism;
				threat.Shot_Locations__c = wrap.shotLocation;
				threat.No_Of_Stabs__c = wrap.numberOfShots;
                if(wrap.angledShot.size()>0)
                                {
                                    threat.Angled_Shot__c = String.valueOf(wrap.angledShot);
                                }
				threat.Contact_Shot__c = wrap.contactShot;
				threat.BFD_Needed__c = wrap.bfdNeeded;
                threat.Threat_ID_iOS__c = wrap.iosId;
				Insert threat;		
				threatList.add(threat);
				totalBulletMaster.add(threat);
			}
		if(!threatList.isEmpty()){
			JSONGenerator gen = JSON.createGenerator(True);
			gen.writeStartObject();
				gen.writeStringField('id',threatList[0].Id);
				gen.writeNumberField('sequence',totalBulletMaster.size());
            	gen.writeStringField('iosId',threatList[0].Threat_ID_IOS__c);
			gen.WriteEndObject();
			prettyJSON=gen.getAsString();
		}
		return new CtrlKevlarSvcHelper.ReturnClass(h.dataSent, h.getMessage('200'),h.getResponseMessage('546'),'546', prettyJSON, null, null,'null');
	}
	 catch(Exception e){
         return new CtrlKevlarSvcHelper.ReturnClass(h.dataNotSent, h.getMessage('203'),'Insert failed!', null, null, null,'203');   
        }	
	

}

	public class MainWrapper{

	public String iosId;
    public String bulletName;
	public String bulletType;
	public Decimal weight;
	public Decimal velocity;
	public Decimal shootingDistance;
	public String shootingMechanism;
	public Decimal range;
	public Decimal v50;
	public String shotLocation;
	public String numberOfShots;
	public List<Integer> angledShot;
	public String contactShot;
	public Decimal bfdNeeded;

	}

}