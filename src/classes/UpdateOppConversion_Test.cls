@isTest(seeAllData=true)
private class UpdateOppConversion_Test{
    public static testmethod void m1(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
    public static testmethod void m2(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Proposing',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
    public static testmethod void m3(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Demonstrating',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
    public static testmethod void m4(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Negotiation',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
    public static testmethod void m5(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Developing',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
    public static testmethod void m6(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Withdraw',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
    
    
    public static testmethod void m7(){
       Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closing',CloseDate=System.today());
        insert Opp;

        UpdateOppConversion scInstance = new UpdateOppConversion();
        UpdateOppConversion.updateOppConversionDate(new List<Id>{opp.Id});
        
           
    }
}