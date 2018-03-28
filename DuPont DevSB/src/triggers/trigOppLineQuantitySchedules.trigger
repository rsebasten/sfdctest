/*******************************************************************************
Copyright Â© 2010 DuPont. All rights reserved. 
Author: Suneil Chetlur
Email: suneil.chetlur@ind.dupont.com
Description: Trigger on Opportunitylineitem after insert and update mainly to 
         create and update the opportunity line item schedules for schedule 
         type Quantity Schedules Only-Recalculate Total Price.
Change History: <Ankit20160803 10:00 PM IST> As a workaround added logic on the code to have only the opportunityLineItemSchedules(of original Opportunity) remained on the cloned opportunity as a part of Issue IS ID-00071084
                <Ankit20161103 12:10 PM EST> Changed the order by condition in the query to sort data on the basis of recordId instead of CreatedDate. This will allow the data to be sorted more accurately in case the createdDate comes same for certain records as a part of Issue IS ID-00075925

         
********************************************************************************/

trigger trigOppLineQuantitySchedules on OpportunityLineItem (after insert,after update) {

double quantityyy;

/*******************************************************************************
Condition to check if this trigger has been called once in compliance with
the New Opportunity Save Behaviour
********************************************************************************/
 if(System.Label.Trigger_On_Off  == 'On'){  
//if(OSRUtil.run2Once()){
    if(trigger.isafter){
        if(trigger.isupdate){
          //<Ankit20160803 10:00 PM IST> As a workaround added logic on the code to have only the opportunityLineItemSchedules(of original Opportunity) remained on the cloned opportunity as a part of Issue IS ID-00071084 Code Coverage: 92% <AK 20160803 10:32 PM IST> Change Starts 
            if(QuantitySchedulingController.isOppCloned==true ){
                integer duration=(QuantitySchedulingController.oppDuration).intValue();
                duration=duration*trigger.new.size();
                system.debug('Ankit--duration--'+duration);
        List<opportunitylineitemschedule> todelete=new List<opportunitylineitemschedule>();
      // <Ankit20161103 12:10 PM EST> Changed the order by condition in the query to sort data on the basis of recordId instead of CreatedDate. This will allow the data to be sorted more accurately in case the createdDate comes same for certain records as a part of Issue IS ID-00075925 Code Coverage: 92% <AK 20161103 12:10 PM EST>
            List<opportunitylineitemschedule> AllSchedules= [select id from opportunitylineitemschedule  where opportunitylineitemid in :trigger.new order by Id];
            if(AllSchedules!=null && AllSchedules.size()>duration){
                for(Integer i=0; i<duration; i++){
                    todelete.add(AllSchedules[i]);
                }   
                if( todelete.size()>0){
                     system.debug('Ankit--exisSche--'+AllSchedules);  
                       delete todelete;
                }
            }
        }  
        
        
        //Change ends
        boolean a;
        for(opportunitylineitem o:trigger.new){
            a=o.hasquantityschedule;
            quantityyy=o.quantity;
        }
            set<id> phatid1=new set<id>();
        for(integer i=0;i<trigger.new.size();i++){
            phatid1.add(trigger.new[i].opportunityid);
        }
/********************************************************************************
If the opportunity has been updated and no schedules are present then this
implementation creates opportunity line item schedule
********************************************************************************/

        if(!a){
            integer imax=0;
            set<id>lis=new set<id>();
            opportunity oppty21;
            opportunity oppty1=new opportunity();
            oppty1=[select id,recordtype.name,recordtypeid,first_ship_date__c,Commercial_Revenue_Date__c,
            amount,amount_type__c,Contract_Duration__c from opportunity where id in:phatid1];
            string recid;
            recid=oppty1.recordtypeid;
            string recidtomap;
            recidtomap=recid.substring(0,15);
            list__c []l;
            l=[select id,code_1__c,Type__c,code_2__c from list__c where code_1__c=:recidtomap and Type__c='Quantity Matrix'];
            string presentid; 
            if(l.size()!=0){
            presentid=l[0].code_1__c;
            }
            integer checkifqueried=0;
                list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
            for(opportunitylineitem o:trigger.new){
                if(recidtomap==presentid){
                    if((oppty1.Contract_Duration__c!=null&&oppty1.Contract_Duration__c!=0)
                        &&oppty1.first_ship_date__c!=null&&oppty1.amount_type__c!=null){
                        if(oppty1.amount_type__c=='One Time - Auto - Monthly'||oppty1.amount_type__c=='One Time - Auto - Quarterly'){
                        id id1=o.id;
                        double numbe=oppty1.Contract_Duration__c;
                        integer mo=oppty1.first_ship_date__c.month();
                        integer y=oppty1.first_ship_date__c.year();
                        integer x=date.daysinmonth(y,mo);
                        date stdate=date.newinstance(y,mo,x);
                        decimal quant;
                        if(o.quantity==null||o.quantity==0){
                            map<id,decimal> quantold=new map<id,decimal>();
                            integer six=trigger.old.size();
                            if(six!=null||six!=0){
                                for(opportunitylineitem oold:trigger.old){
                                    quantold.put(oold.id,oold.quantity);
                                }
                            }
                                quant=(quantold.get(o.id)).divide(numbe,3);
                        }
                        else if(o.quantity!=null||o.quantity!=0){
                                quant=(o.quantity).divide(numbe,3);
                        }
                        if(!(o.hasquantityschedule)){
                            if(oppty1.amount_type__c=='One Time - Auto - Monthly'){
                                    integer z=0;
                                    date newdate=stdate;
                                    for(integer i=0;i<numbe;i++){
                                            opportunitylineitemschedule o1=new opportunitylineitemschedule();
                                            date nd=stdate.addmonths(i);
                                            integer mo1=nd.month();
                                            integer y1=nd.year();
                                            integer x1=date.daysinmonth(y1,mo1);
                                            date std=date.newinstance(y1,mo1,x1);
                                    o1=new opportunitylineitemschedule(quantity=quant,type='QuantityRevenueRelated',opportunitylineitemid=id1,scheduledate=std);
                                            o9.add(o1);
                                    }
                                }
                                else if(oppty1.amount_type__c=='One Time - Auto - Quarterly'){
                                        integer z=0;
                                    string newdate=stdate.format();
                                    double sd=numbe*3;      
                                        for(integer i=0;i<sd;i=i+3){
                                            opportunitylineitemschedule o1=new opportunitylineitemschedule();
                                            date nd=stdate.addmonths(i);
                                            integer mo1=nd.month();
                                            integer mo2;
                                            if(mo1==1||mo1==2||mo1==3)
                                                mo2=3;
                                            if(mo1==4||mo1==5||mo1==6)
                                                mo2=6;
                                            if(mo1==7||mo1==8||mo1==9)
                                                mo2=9;
                                            if(mo1==10||mo1==11||mo1==12)
                                                mo2=12;
                                            integer y1=nd.year();
                                            integer x1=date.daysinmonth(y1,mo2);
                                            date std=date.newinstance(y1,mo2,x1);
                                    o1=new opportunitylineitemschedule(quantity=quant,type='QuantityRevenueRelated',opportunitylineitemid=id1,scheduledate=std);
                                            o9.add(o1);
                                    }    //end of for
                                    }
                        }

                    }
                }
            }

//DPP

if(recidtomap==presentid){
                    if((oppty1.Contract_Duration__c!=null&&oppty1.Contract_Duration__c!=0)
                        &&oppty1.first_ship_date__c!=null&&oppty1.amount_type__c!=null){
                        if(oppty1.amount_type__c=='One Time - Auto - Yearly'){
                        id id1=o.id;
                        double numbe=oppty1.Contract_Duration__c;
                        integer mo=oppty1.first_ship_date__c.month();
                        integer y=oppty1.first_ship_date__c.year();
                        integer x=date.daysinmonth(y,mo);
                        date stdate=date.newinstance(y,mo,x);
                        decimal quant;
                        if(o.quantity==null||o.quantity==0){
                            map<id,decimal> quantold=new map<id,decimal>();
                            integer six=trigger.old.size();
                            if(six!=null||six!=0){
                                for(opportunitylineitem oold:trigger.old){
                                    quantold.put(oold.id,oold.quantity);
                                }
                            }
                                quant=(quantold.get(o.id)).divide(numbe,3);
                        }
                        else if(o.quantity!=null||o.quantity!=0){
                                quant=(o.quantity).divide(numbe,3);
                        }
                        if(!(o.hasquantityschedule)){
                            if(oppty1.amount_type__c=='One Time - Auto - Yearly'){
                                    integer z=0;
                                    date newdate=stdate;
                                    for(integer i=0;i<numbe;i++){
                                            opportunitylineitemschedule o1=new opportunitylineitemschedule();
                                            date nd=stdate.addyears(i);
                                            integer mo1=nd.month();
                                            integer y1=nd.year();
                                            integer x1=date.daysinmonth(y1,mo1);
                                            date std=date.newinstance(y1,mo1,x1);
                                    o1=new opportunitylineitemschedule

(quantity=quant,type='QuantityRevenueRelated',opportunitylineitemid=id1,scheduledate=std);
                                            o9.add(o1);
                                    }  
                                }
                         }

                    }
                }
            }
 
             //DPP
               
        }
        insert o9;
    }
}
else if(trigger.isinsert){
    for(opportunitylineitem o:trigger.new){
        boolean a=o.hasquantityschedule;
        quantityyy=o.quantity;
    }
    integer imax=0;
        set<id>lis=new set<id>();
        set<id> phatid=new set<id>();
    for(integer i=0;i<trigger.new.size();i++){
        phatid.add(trigger.new[i].opportunityid);
    }
    opportunity oppty=new opportunity();
    opportunity oppty21;
    integer checkifqueried=0;
    oppty=[select id,recordtype.name,recordtypeid,first_ship_date__c,Commercial_Revenue_Date__c,
    amount,amount_type__c,Contract_Duration__c from opportunity where id in:phatid];
            string recid;
            recid=oppty.recordtypeid;
            string recidtomap;
            recidtomap=recid.substring(0,15);
            
            list__c []l;
            l=[select id,code_1__c,Type__c,code_2__c from list__c where code_1__c=:recidtomap and Type__c='Quantity Matrix'];
            string presentid; 
            if(l.size()!=0){
            presentid=l[0].code_1__c;
            }
    list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
    for(opportunitylineitem o:trigger.new){
        if(recidtomap==presentid){
            if((oppty.Contract_Duration__c!=null&&oppty.Contract_Duration__c!=0)
            &&oppty.first_ship_date__c!=null&&oppty.amount_type__c!=null){
                if(oppty.amount_type__c=='One Time - Auto - Monthly'||oppty.amount_type__c=='One Time - Auto - Quarterly'){
                    id id1=o.id;
                    double numbe=oppty.Contract_Duration__c;
                    integer mo=oppty.first_ship_date__c.month();
                    integer y=oppty.first_ship_date__c.year();
                    integer x=date.daysinmonth(y,mo);
                    date stdate=date.newinstance(y,mo,x);
                    decimal quant;
                    if(o.quantity==null||o.quantity==0){
                        decimal quantold;
                        integer six=trigger.old.size();
                        if(six!=null||six!=0){
                            for(opportunitylineitem oold:trigger.old){
                                quantold=oold.quantity;
                            }
                        }
                            quant=(quantold).divide(numbe,3);
                    }
                    else if(o.quantity!=null||o.quantity!=0){
                            quant=(o.quantity).divide(numbe,3);
                }
                if(!(o.hasquantityschedule)){
                    if(oppty.amount_type__c=='One Time - Auto - Monthly'){
                            integer z=0;
                            date newdate=stdate;
                            for(integer i=0;i<numbe;i++){
                                    opportunitylineitemschedule o1=new opportunitylineitemschedule();
                                    date nd=stdate.addmonths(i);
                                    integer mo1=nd.month();
                                    integer y1=nd.year();
                                    integer x1=date.daysinmonth(y1,mo1);
                                    date std=date.newinstance(y1,mo1,x1);
                            o1=new opportunitylineitemschedule(quantity=quant,type='QuantityRevenueRelated',opportunitylineitemid=id1,scheduledate=std);
                                    o9.add(o1);
                            }
                        }
                        else if(oppty.amount_type__c=='One Time - Auto - Quarterly'){
                            integer z=0;
                            string newdate=stdate.format();
                            double sd=numbe*3;      
                            for(integer i=0;i<sd;i=i+3){
                                    opportunitylineitemschedule o1=new opportunitylineitemschedule();
                                    date nd=stdate.addmonths(i);
                                    integer mo1=nd.month();
                                    integer mo2;
                                    if(mo1==1||mo1==2||mo1==3)
                                        mo2=3;
                                    if(mo1==4||mo1==5||mo1==6)
                                        mo2=6;
                                    if(mo1==7||mo1==8||mo1==9)
                                        mo2=9;
                                    if(mo1==10||mo1==11||mo1==12)
                                        mo2=12;
                                    integer y1=nd.year();
                                    integer x1=date.daysinmonth(y1,mo2);
                                    date std=date.newinstance(y1,mo2,x1);
                            o1=new opportunitylineitemschedule(quantity=quant,type='QuantityRevenueRelated',opportunitylineitemid=id1,scheduledate=std);
                                    o9.add(o1);
                            }  
                        }
                }
            }
        }
    }
//DPP
  
  if(recidtomap==presentid){
            if((oppty.Contract_Duration__c!=null&&oppty.Contract_Duration__c!=0)
            &&oppty.first_ship_date__c!=null&&oppty.amount_type__c!=null){
                if(oppty.amount_type__c=='One Time - Auto - Yearly'){
                    id id1=o.id;
                    double numbe=oppty.Contract_Duration__c;
                    integer mo=oppty.first_ship_date__c.month();
                    integer y=oppty.first_ship_date__c.year();
                    integer x=date.daysinmonth(y,mo);
                    date stdate=date.newinstance(y,mo,x);
                    decimal quant;
                    if(o.quantity==null||o.quantity==0){
                        decimal quantold;
                        integer six=trigger.old.size();
                        if(six!=null||six!=0){
                            for(opportunitylineitem oold:trigger.old){
                                quantold=oold.quantity;
                            }
                        }
                            quant=(quantold).divide(numbe,3);
                    }
                    else if(o.quantity!=null||o.quantity!=0){
                            quant=(o.quantity).divide(numbe,3);
                }
                if(!(o.hasquantityschedule)){
                    if(oppty.amount_type__c=='One Time - Auto - Yearly'){
                            integer z=0;
                            date newdate=stdate;
                            for(integer i=0;i<numbe;i++){
                                    opportunitylineitemschedule o1=new opportunitylineitemschedule();
                                    date nd=stdate.addyears(i);
                                    integer mo1=nd.month();
                                    integer y1=nd.year();
                                    integer x1=date.daysinmonth(y1,mo1);
                                    date std=date.newinstance(y1,mo1,x1);
                            o1=new opportunitylineitemschedule(quantity=quant,type='QuantityRevenueRelated',opportunitylineitemid=id1,scheduledate=std);
                                    o9.add(o1);
                            }
                        }
            }
            }
        }
    }
    
    //DPP
}
insert o9;
}
}
//}
}
}