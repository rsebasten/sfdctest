/*******************************************************************************
Copyright Â© 2010 DuPont. All rights reserved. 
Author: Suneil Chetlur
Email: suneil.chetlur@ind.dupont.com
Description: Trigger on Opportunity after update to create and update the 
         opportunity line item schedules on the opportunity line item 
         for schedule type Quantity Schedules Only-Recalculate Total Price.
********************************************************************************/

trigger trigOppQuantitySchedules on Opportunity (before insert,before update,after update) {

double contractdurationold;

date fsdate;
string amtype;
id i99;
double quantityold;

/*******************************************************************************
New condition to check whether trigger is run once in compliance with the new
Opportunity save behaviour.
********************************************************************************/
   if(System.Label.Trigger_On_Off  == 'On'){  
//if(OSRUtil.run3Once()){
    
    if(trigger.isafter){
     if(trigger.isupdate){
 
    opportunitylineitemschedule []o12; 
    set<id>lis1=new set<id>();
    opportunitylineitem []o123; 
    id i98;id idr;
    double expschedquant;
    date act;
    date fsd;
    date cd;
        for(opportunity yoppty1:trigger.new){
            i98=yoppty1.id;
            idr=yoppty1.recordtypeid;
            act=yoppty1.Actual_Commercial_Date__c;
            cd=yoppty1.CloseDate;
        }
    recordtype r;
    r=[select name,id from recordtype where id=:idr];
    list__c []l;
    string recid;
    recid=r.id;
    string recidtomap;
    recidtomap=recid.substring(0,15);
 
    l=[select id,code_1__c,code_2__c,code_3__c from list__c where code_1__c=:recidtomap and Type__c='Quantity Matrix'];
    string presentid; 
    string code3;
    if(l.size()!=0){
    presentid=l[0].code_1__c;
    code3=l[0].code_3__c;
    }
 for(opportunity oppty2:trigger.old){
        fsdate=oppty2.first_ship_date__c;
        amtype=oppty2.amount_type__c;
        i99=oppty2.id;
        contractdurationold=oppty2.Contract_Duration__c;
    }
 
    o123=[select quantity,opportunityid,Id,unitprice,PriceBookEntry.Product2id,PriceBookEntry.Product2.Name,Description,
    PricebookEntryId,hasquantityschedule,
    (select scheduledate,quantity,id,opportunitylineitemid
    from opportunitylineitemschedules order by scheduledate) from opportunitylineitem where opportunityid=:i98];
    for(opportunity yoppty11:trigger.new){
        for(opportunitylineitem or1:o123){
                lis1.add(or1.id);
            }
    }
    
    set<id>lis=new set<id>();

 
/********************************************************************************
Implementation incase the new first ship date is not equal to the previous one.
********************************************************************************/

    for(opportunity oppty1:trigger.new){
        if(recidtomap==presentid){
            if(oppty1.first_ship_date__c!=null&&oppty1.first_ship_date__c!=fsdate){
                list<opportunitylineitemschedule> oqw2up=new list<opportunitylineitemschedule>();
                    for(opportunitylineitem o12345:o123){
                            integer mo1=oppty1.first_ship_date__c.month();
                            integer y1=oppty1.first_ship_date__c.year();
                            integer x1=date.daysinmonth(y1,mo1);
                            date stdate1=date.newinstance(y1,mo1,x1);
                            if(oppty1.amount_type__c=='One Time - Auto - Quarterly'){
                                integer i=0;integer x=0;
                        integer siolis=o12345.opportunitylineitemschedules.size();
                        for(opportunitylineitemschedule oqw2:o12345.opportunitylineitemschedules){
                                    if(oqw2.opportunitylineitemid==o12345.id){
                                            date nd1=stdate1.addmonths(i);
                                            integer mo11=nd1.month();
                                            integer mo21;
                                            if(mo11==1||mo11==2||mo11==3)
                                                mo21=3;
                                            if(mo11==4||mo11==5||mo11==6)
                                                mo21=6;
                                            if(mo11==7||mo11==8||mo11==9)
                                                mo21=9;
                                            if(mo11==10||mo11==11||mo11==12)
                                                    mo21=12;
                                            integer y11=nd1.year();
                                            integer x11=date.daysinmonth(y11,mo21);
                                            date std=date.newinstance(y11,mo21,x11);
                                            oqw2.scheduledate=std;
                                            i=i+3;
                                oqw2up.add(oqw2);
                                }
                        }
                            }
                            if(oppty1.amount_type__c=='One Time - Auto - Monthly'){
                                integer i=0;integer x=0;
                        for(opportunitylineitemschedule oqw2:o12345.opportunitylineitemschedules){
                                if(oqw2.opportunitylineitemid==o12345.id){
                                        date nd1=stdate1.addmonths(i);
                                            integer mo11=nd1.month();
                                            integer y11=nd1.year();
                                            integer x11=date.daysinmonth(y11,mo11);
                                            date std=date.newinstance(y11,mo11,x11);
                                            oqw2.scheduledate=std;
                                            i=i+1;
                                        oqw2up.add(oqw2);
                                 }
                             }
                         }
         
                    }
                    update oqw2up;
            }
/********************************************************************************
Implementation in the case of new contract duration not equal to the previous one
********************************************************************************/


/********************************************************************************
Conditions to check if new value 'greater' or 'lower' than previous value.
********************************************************************************/

            if(oppty1.Contract_Duration__c!=contractdurationold||oppty1.amount_type__c!=amtype){
                list <opportunitylineitemschedule> olistr1=new list <opportunitylineitemschedule>();
        list <opportunitylineitemschedule> olistr2=new list <opportunitylineitemschedule>();
                if(oppty1.Contract_Duration__c<contractdurationold){
                  if(contractdurationold!=0){
                    for(opportunitylineitem o12345:o123){
                      for(opportunitylineitemschedule oqw:o12345.opportunitylineitemschedules){
                                if(oqw.opportunitylineitemid==o12345.id){
                                    olistr1.add(oqw);
                                }
                        }
                    }
                    delete olistr1;
                }
                }
                else if(oppty1.Contract_Duration__c>contractdurationold){
                        if(contractdurationold!=0){
                        list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
                    for(opportunitylineitem o12345:o123){
                        if((oppty1.Contract_Duration__c!=null&&oppty1.Contract_Duration__c!=0)
                        &&oppty1.first_ship_date__c!=null&&oppty1.amount_type__c!=null){
                            if(oppty1.amount_type__c=='One Time - Auto - Monthly'||oppty1.amount_type__c=='One Time - Auto - Quarterly'){
                                id id1=o12345.id;
                                double numbe=oppty1.Contract_Duration__c-contractdurationold;
                                date d;
                                for(opportunitylineitemschedule o:o12345.opportunitylineitemschedules){
                                        d=o.scheduledate;
                                }
                                integer mo=d.month();
                                integer y=d.year();
                                integer x=date.daysinmonth(y,mo);
                                date stdate=date.newinstance(y,mo,x);
                                double quant;
                                quant=0;
                                if(oppty1.amount_type__c=='One Time - Auto - Monthly'){
                                        integer z=0;
                                        date newdate=stdate;
                                        for(integer i=1;i<numbe+1;i++){
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
                                    for(integer i=1;i<sd+1;i=i+3){
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
                            else 
                                return;

                    }
                }
            }
            insert o9;
        }}
    }
}
//DPP

     if(recidtomap==presentid){
                   if(oppty1.first_ship_date__c!=null&&oppty1.first_ship_date__c!=fsdate){
                list<opportunitylineitemschedule> oqw2up=new list<opportunitylineitemschedule>();
                    for(opportunitylineitem o12345:o123){
                            integer mo1=oppty1.first_ship_date__c.month();
                            integer y1=oppty1.first_ship_date__c.year();
                            integer x1=date.daysinmonth(y1,mo1);
                            date stdate1=date.newinstance(y1,mo1,x1);
                        if(oppty1.amount_type__c=='One Time - Auto - Yearly'){
                                integer i=0;integer x=0;
                            for(opportunitylineitemschedule oqw2:o12345.opportunitylineitemschedules){
                                    if(oqw2.opportunitylineitemid==o12345.id){
                                            date nd1=stdate1.addyears(i);
                                            integer mo11=nd1.month();
                                            integer y11=nd1.year();
                                            integer x11=date.daysinmonth(y11,mo11);
                                            date std=date.newinstance(y11,mo11,x11);
                                            oqw2.scheduledate=std;
                                            i=i+1;
                                        oqw2up.add(oqw2);
                                 }
                             }
                         }
                     }
                    update oqw2up;
 }
  if(oppty1.Contract_Duration__c!=contractdurationold||oppty1.amount_type__c!=amtype){
                list <opportunitylineitemschedule> olistr1=new list <opportunitylineitemschedule>();
            list <opportunitylineitemschedule> olistr2=new list <opportunitylineitemschedule>();
                if(oppty1.Contract_Duration__c>contractdurationold){
                        if(contractdurationold!=0){
                        list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
                    for(opportunitylineitem o12345:o123){
                        if((oppty1.Contract_Duration__c!=null&&oppty1.Contract_Duration__c!=0)
                        &&oppty1.first_ship_date__c!=null&&oppty1.amount_type__c!=null){
                            if(oppty1.amount_type__c=='One Time - Auto - Yearly'){
                                id id1=o12345.id;
                                double numbe=oppty1.Contract_Duration__c-contractdurationold;
                                date d;
                                for(opportunitylineitemschedule o:o12345.opportunitylineitemschedules){
                                        d=o.scheduledate;
                                }
                                integer mo=d.month();
                                integer y=d.year();
                                integer x=date.daysinmonth(y,mo);
                                date stdate=date.newinstance(y,mo,x);
                                double quant;
                                quant=0;
                                if(oppty1.amount_type__c=='One Time - Auto - Yearly'){
                                         integer z=0;
                                     date newdate=stdate;
                                     for(integer i=1;i<numbe+1;i++){
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
                                else 
                                    return;
                  }
                          }
                      }
            insert o9;
        }
        }
    }
}

//DPP

/********************************************************************************
Creation of opportunity line item schedules if old values not meeting criteria
and new values meeting the required criterion.
********************************************************************************/
for(opportunity oppty:trigger.new){
  if(recidtomap==presentid){
    if(fsdate==null||contractdurationold==null||contractdurationold==0||amtype!='One Time - Auto - Monthly'||amtype!='One Time - Auto - Quarterly'){
       if((oppty.Contract_Duration__c!=null&&oppty.Contract_Duration__c!=0)
        &&oppty.first_ship_date__c!=null&&oppty.amount_type__c!=null){
            if(oppty.amount_type__c=='One Time - Auto - Monthly'||oppty.amount_type__c=='One Time - Auto - Quarterly'){
                for(opportunitylineitem o12345:o123){
                    boolean a=o12345.hasquantityschedule;
                    if(!a){
                        id id1=o12345.id;
                        double numbe=oppty.Contract_Duration__c;
                        integer mo=oppty.first_ship_date__c.month();
                        integer y=oppty.first_ship_date__c.year();
                        integer x=date.daysinmonth(y,mo);
                        date stdate=date.newinstance(y,mo,x);
                        decimal quant;
                        quant=(o12345.quantity).divide(numbe,3);
                        if(oppty.amount_type__c=='One Time - Auto - Monthly'){
                                list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
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
                                    insert o9;
                            }
                            else if(oppty.amount_type__c=='One Time - Auto - Quarterly'){
                                list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
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
                                insert o9;
                            }
                    }
                }
            }
        }
    }
}
//DPP
 
  if(recidtomap==presentid){
      if(fsdate!=null||contractdurationold!=null||contractdurationold!=0||amtype=='One Time - Auto - Yearly'||fsdate==null||contractdurationold==null||contractdurationold==0||amtype!='One Time - Auto - Yearly'){
        if((oppty.Contract_Duration__c!=null&&oppty.Contract_Duration__c!=0)
        &&oppty.first_ship_date__c!=null&&oppty.amount_type__c!=null){
            if(oppty.amount_type__c=='One Time - Auto - Yearly'){
                for(opportunitylineitem o12345:o123){
                    boolean a=o12345.hasquantityschedule;
                    if(!a){
                        id id1=o12345.id;
                        double numbe=oppty.Contract_Duration__c;
                        integer mo=oppty.first_ship_date__c.month();
                        integer y=oppty.first_ship_date__c.year();
                        integer x=date.daysinmonth(y,mo);
                        date stdate=date.newinstance(y,mo,x);
                        decimal quant;
                        quant=(o12345.quantity).divide(numbe,3);
                        if(oppty.amount_type__c=='One Time - Auto - Yearly'){
                                list<opportunitylineitemschedule> o9=new list<opportunitylineitemschedule>();
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
                                    insert o9;
                            }
                    }
                }
            }
        }
    }
}

//DPP

}
}
}
}
if(trigger.isbefore){
    if(trigger.isupdate||trigger.isinsert){
        string idr1;
        date act;
        date fsd;
        date cd;
        string r;
        for(opportunity yoppty1:trigger.new){
            idr1=yoppty1.recordtypeid;
            act=yoppty1.Actual_Commercial_Date__c;
            cd=yoppty1.CloseDate;
            r=idr1.substring(0,15);
            if(r=='01230000000pncM'){
                if(act!=null)
                    yoppty1.first_ship_date__c=act;
                else if(act==null)
                    yoppty1.first_ship_date__c=cd;
            }
        }
    }
}
}
}