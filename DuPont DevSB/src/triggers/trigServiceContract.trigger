trigger trigServiceContract on ServiceContract (after insert) {
    if(System.Label.Trigger_On_Off  == 'On'){  
        serviceContracthandler startTrigger = new serviceContracthandler();
        startTrigger.onTrigger();
    }
}