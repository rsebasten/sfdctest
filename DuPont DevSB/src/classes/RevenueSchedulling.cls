public Class RevenueSchedulling{

// Check if The Process needs to be activated !
public static boolean checkcompliance(Opportunity ops, Integer stage){
boolean accessgranted = false;
// Line 1 : Check on Amount Type.
// Line 2 : Check on Opportunity Currency.
// Line 3 : Check on Commercial Revenue Date.
if(ops.Amount_Type__c != ' ' && ops.Amount_Type__c != null && ops.Amount_Type__c != '' && ops.Amount_Type__c != 'Annual' && ops.Amount_Type__c != 'One Time'){
    if(ops.CurrencyIsoCode != null && ops.CurrencyIsoCode != ' '){
        if(ops.Commercial_Revenue_Date__c != null && ops.Commercial_Revenue_Date__c != null){
            if(stage == 1){
            accessgranted = true;
            }else if(stage >= 2){
            String[] opsIds = new String[]{ops.Id};
            Integer CheckProductNumber =[select count() from OpportunityLineItem where OpportunityId in :opsIds];
                if (stage == 2){
                    if (CheckProductNumber < 2){
                    accessgranted = true;
                    }
                }else if (stage == 3){
                    if (CheckProductNumber < 2 && CheckProductNumber > 0){
                    accessgranted = true;
                    }
                }
            }
                                    
        }
    }
}

return accessgranted;
}






public static void AddPriceBook(Opportunity ops){
    if(checkcompliance(ops,1) == true){
    // You can search for PriceBook, Product, PricebookProductLine.
    if(ops.New_Duration__c == null || ops.New_Duration__c == 0){
    ops.New_Duration__c = 1;
    }

    String[] RecordTypeID = new String[]{ops.RecordTypeID}; 
    RecordType[] RecordTypeNameRequest = [select Name from Recordtype where ID in :RecordTypeID];       
    
    String[] RecordTypeName = new String[]{RecordTypeNameRequest[0].Name+' - '+ops.Owning_Organisation__c};
    String[] OppCurrency = new String[]{ops.CurrencyIsoCode};
    List__c[] PriceProductRequest =[select code_1__c, code_2__c , code_3__c, description__c from List__c where Type__c = 'Revenue Schedule Product' and CurrencyIsoCode in :OppCurrency and Name in :RecordTypeName];
        if(PriceProductRequest.size() > 0){
            // Add the Right Price Book to the Opportunity. 
            if(PriceProductRequest[0].Code_2__c != '' && PriceProductRequest[0].Code_2__c != null){
            ops.Pricebook2Id = PriceProductRequest[0].Code_2__c;
            }
        }
    }
    
}





public static void AddProduct(Opportunity ops){

    if(checkcompliance(ops,2) == true){
    String[] RecordTypeID = new String[]{ops.RecordTypeID}; 
    RecordType[] RecordTypeNameRequest = [select Name from Recordtype where ID in :RecordTypeID];       
    String[] RecordTypeName = new String[]{RecordTypeNameRequest[0].Name+' - '+ops.Owning_Organisation__c};
    String[] OppCurrency = new String[]{ops.CurrencyIsoCode};
    List__c[] PriceProductRequest =[select code_1__c, code_2__c , code_3__c, description__c from List__c where Type__c = 'Revenue Schedule Product' and CurrencyIsoCode in :OppCurrency and Name in :RecordTypeName];
        if(PriceProductRequest.size() > 0){
            Double Numb = 0;
            if(ops.New_Duration__c == null || ops.New_Duration__c == 0){
            Numb = 1;
            }else{
            Numb = ops.New_Duration__c;
            }

            // Add the Right Product
            if(PriceProductRequest[0].Code_3__c != null && PriceProductRequest[0].Code_3__c != ''){
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.OpportunityId = ops.Id; 
            opli.PricebookEntryId = PriceProductRequest[0].Code_3__c;
            opli.Quantity=1.0;
            opli.UnitPrice=ops.Amount;
                insert opli;
            CreateSchedule(ops,opli.Id,Numb);   
            }
        }
    }
}







public static void CreateSchedule(Opportunity ops, String opliID, Double numMonth){

        if(checkcompliance(ops,3) == true){
        List<OpportunityLineItemSchedule> lst=new List<OpportunityLineItemSchedule>();
        Date t = ops.Commercial_Revenue_Date__c;
        Integer z = 0;      
        // Handling the Multiple Possibilities.
        Integer multiplier = 1;     
            if(ops.Amount_Type__c.contains('Quarterly')){
            multiplier = 3;
            }else if(ops.Amount_Type__c.contains('Yearly')){
            multiplier = 12;
            }
        Double Numberz = 0;
        if(numMonth != 100){
        Numberz = numMonth;
        }else{
        Numberz = ops.New_Duration__c;
        }
            for(Integer i=0;i<Numberz;i++){     
            z = i*multiplier;
            date d = Date.newInstance(t.year(),t.month()+z,t.day());                    
            OpportunityLineItemSchedule sch=new OpportunityLineItemSchedule();      
            
            sch.ScheduleDate =d;
            sch.Revenue = ops.Amount/Numberz;
            sch.OpportunityLineItemId = opliID;
            sch.Type = 'Revenue';
            lst.add(sch);
            }
        insert lst; 

        }
}


public static void CheckUpdate(Opportunity ops){
    if(checkcompliance(ops,3) == true){
        if(ops.New_Duration__c != null && ops.New_Duration__c != 0){
        reschedule(ops);
        }else if(ops.Amount_Type__c.contains('Auto')){
        reschedule2(ops);
        }
    }


}


public static void reschedule(Opportunity ops){
            OpportunityLineItem opli =[Select o.Id from OpportunityLineItem o where o.OpportunityId =: ops.Id];
            OpportunityLineItemSchedule[] oplisch = [Select s.Id from OpportunityLineItemSchedule s where s.OpportunityLineItemId =: opli.Id];
            try{
            delete oplisch;
            CreateSchedule(ops,opli.Id,100);
            }catch(DmlException e){
                //todo
            }
}


public static void reschedule2(Opportunity ops){
OpportunityLineItem opli =[Select o.Id from OpportunityLineItem o where o.OpportunityId =: ops.Id];
OpportunityLineItemSchedule[] oplisch = [Select s.Id from OpportunityLineItemSchedule s where s.OpportunityLineItemId =: opli.Id];
Integer OpportunityLineCount = [Select count() from OpportunityLineItemSchedule s where s.OpportunityLineItemId =: opli.Id];

            try{
            delete oplisch;
            CreateSchedule(ops,opli.Id,OpportunityLineCount);
            }catch(DmlException e){
                //todo
            }
}
}