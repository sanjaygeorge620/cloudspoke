/*************************************************************************************
Name : AssignCurrencyAndOwner 
Created By : Reena Acharya(Appirio Offshore)
Created Date : 15th May , 2012
Description : -Opportunity Owner value on the Qualification Object always relfects the name
               of the Opportunity owner value based on the related Opportunity selected. 
              -set the "Qualification.Currency" to the same value as that of the related 
               Accounts currency
               
               
Updated By : Hemlata Mandowara(Appirio Offshore)
Created Date : 11th June , 2012
Description : - Updated due to creation of Account as formula field as opportunity 's Account Name

*************************************************************************************/
trigger AssignCurrencyAndOwner on Qualification__c (Before Insert , Before Update) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    Set<ID> OpportunityIDs = new Set<ID>();
    Set<ID> accountIDs = new Set<ID>();
    Map<ID , Opportunity> opportunities = new Map<ID , Opportunity>();
    Map<ID , Account> accounts = new Map<ID , Account>();
    
    //Create set of Opportunity Ids and Account Ids.
    for(Qualification__c  qualification : Trigger.New){
        if(qualification.Opportunity__c  != null){
            OpportunityIDs.Add(qualification.Opportunity__c); 
            if(qualification.Opportunity__r.AccountId != null){
                accountIDs.Add(qualification.Opportunity__r.AccountId);  
            }
        }    
    }
    
    //Get associated Opportunities
    if(OpportunityIDs.size() > 0){
        opportunities = new Map<ID , Opportunity>([Select id,OwnerID from Opportunity where id in : OpportunityIDs]);        
    }
    //Get associated Accounts
    if(accountIDs.size() > 0){
        accounts = new Map<ID , Account>([Select id,CurrencyIsoCode from Account where id in : accountIDs ]);        
    }
    
    //Assign Qualification's Opportunity Owner and Qualification's Currency Code.
    for(Qualification__c  qualification : Trigger.New){
        if(qualification.Opportunity__c  != null){
            qualification.Opportunity_Owner__c = opportunities.get(qualification.Opportunity__c).OwnerID; 
            if(qualification.Opportunity__r.AccountId != null){
                qualification.CurrencyIsoCode = accounts.get(qualification.Opportunity__r.AccountId).CurrencyIsoCode ;  
            }
        }    
    }
   
}