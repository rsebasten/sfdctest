trigger trigContract on Contract (before insert, before update) {
    if(System.Label.Trigger_On_Off  == 'On'){   
        ContractHandler conHandler = new ContractHandler();
        conHandler.onTrigger();  
    }
}