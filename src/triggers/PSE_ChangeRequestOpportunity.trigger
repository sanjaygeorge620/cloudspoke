/*********************************************************************
Trigger Name   : PSE_ChangeRequestOpportunity
Created by     : Appirio
Created Date   : January 4, 2010
Purpose        : When a 'Change Request' from a PSE Project is created,
                 the new Opportunity is created, this trigger will update
                  the Opporunity and create a PS product line.
***********************************************************************/
trigger PSE_ChangeRequestOpportunity on Opportunity (before insert, after insert) {

 if (trigger.IsBefore){
    // if the Opportunity is a change request set the ISR to be the ISR from the parent Opportunity
    for (Opportunity cr_opp : Trigger.new) { 
  
        system.debug('***DEBUG*** ChangeRequest Trigger  New Opp Name:'+ cr_opp.Name);
        system.debug('***DEBUG*** ChangeRequest Trigger  New Opp ID:'+ cr_opp.id);
        system.debug('***DEBUG*** ChangeRequest Trigger  Parent ID:'+ cr_opp.pse__Parent_Opportunity__c);
        
       // Opportunity parentOpp = [select id, ISR__c, AccountId from Opportunity where id = :cr_opp.pse__Parent_Opportunity__c];
 
        
        if (cr_opp.pse__Is_Change_Request__c == true) {
            Account parentAcct = [select id, ownerid, ISR__c from Account where id = :cr_opp.AccountId limit 1];           
            cr_opp.ISR__c = parentAcct.ISR__c;
            cr_opp.ownerID = parentAcct.OwnerID;
            system.debug('***DEBUG*** ChangeRequest Trigger  Account:'+ cr_opp.Account);
            system.debug('***DEBUG*** ChangeRequest Trigger  ISR ID:'+ cr_opp.Account.ISR__c);
            system.debug('***DEBUG*** ChangeRequest Trigger  ISR Name:'+ cr_opp.Account.ISR__r.name);
        }
    }
 }else {
 
      boolean update_flag = false;
      List< OpportunityLineItem > new_productline = new List< OpportunityLineItem >();
      Pricebook2 priceEntry = [select id from Pricebook2 where name = 'Perceptive' limit 1];
      
      for (Opportunity cr_opp : Trigger.new) {       
          
        // Grab the Professional Service Product item.
        // BIG NOTE: as of creation of this trigger there are only 1 PS products in Perceptive's 
        // system, so if this changes, then this trigger needs to be updated so that the proper 
        // PS Product is added to the OpportunityProductLine.
        //Product2 ps_prod = [select id from Product2 where Name = 'Professional Services' limit 1];



        // If the new Opportunity is a PSE Change Request the IsChangeRequest flag will be set
        if (cr_opp.pse__Is_Change_Request__c == true ) {
            update_flag = true;
            
           PricebookEntry ps_prod = [select id from PricebookEntry where Name = 'Professional Services' 
                            and currencyISOCode = :cr_opp.CurrencyISOCode
                            and Pricebook2ID = :priceEntry.Id limit 1];
           if(ps_prod.id <> null){
            
                // set the IsServices flag because it doesn't get set automatically via PS Change Request apex
                //opp.pse__Is_Services_Opportunity__c = true;
    
                // Create a new OpportunityProductLine record with a PS Product 
                new_productline.add(new OpportunityLineItem ( 
                                        OpportunityId = cr_opp.Id,
                                        ServiceDate = cr_opp.closedate,
                                        UnitPrice = cr_opp.Amount,
                                        //TotalPrice = opp.Amount,
                                        PricebookEntryId = ps_prod.Id,
                                        Quantity = 1,
                                        product_family__c = 'Professional Services',
                                        pse__IsServicesProductLine__c = true));
                                                    
                 system.debug('***DEBUG*** ChangeRequest Trigger  AFTER Step 4:'+ cr_opp.pse__Parent_Opportunity__c);
                 system.debug('***DEBUG*** ChangeRequest Trigger  AFTER Step 5:'+ cr_opp.pse__Parent_Opportunity__r.ISR__r.Name);
           }
        }
     }  
  
   if (update_flag == true) 
        insert new_productline;
  
}
}