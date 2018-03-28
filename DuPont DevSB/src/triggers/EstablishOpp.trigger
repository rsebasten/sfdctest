trigger EstablishOpp on Opportunity (Before Insert, After Insert, After Update) {
  if(System.Label.Trigger_On_Off  == 'On'){   
    if(Trigger.isBefore){ 
        if(OSRUtil.runOnce()){
            if(Trigger.isInsert){
                for(Opportunity o : Trigger.new){ 
                    RevenueSchedulling.AddPriceBook(o);
                }
            }
        }
    }
    if(Trigger.isAfter){
        if(OSRUtil.run1Once()){
            if(Trigger.isInsert){
                for(Opportunity o2 : Trigger.new){ 
                    RevenueSchedulling.AddProduct(o2);
                }
            }
            if(Trigger.isUpdate){
                for(Opportunity o3 : Trigger.new){ 
                    RevenueSchedulling.CheckUpdate(o3);
                }
            }
        }
    }
  }
}