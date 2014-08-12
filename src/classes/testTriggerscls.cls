@isTest(seeAlldata=true)
private class testTriggerscls{
    public static List<String> lst = new List<String>{'Prospecting'};  
    public static Opportunity opp = Data_opportunity.createOpportunity(lst,1)[0];
   
    public static Dealer__c dlr;
    
    static testmethod void m1(){              
        dlr = new Dealer__c();
        dlr.Opportunity_Name__c = opp.Id;
        dlr.Dealer_Name__c=opp.AccountId;
        dlr.Primary_Dealer__c = true;
        dlr.Active__c = true;
        insert dlr;
     }
     
    static testmethod void m2(){   
        dlr = new Dealer__c();
        dlr.Opportunity_Name__c = opp.Id;
        dlr.Dealer_Name__c=opp.AccountId;
        dlr.Primary_Dealer__c = true;
        dlr.Active__c = true;
        insert dlr;
        
        
        test.startTest();
        Dealer__c dlr1 = new Dealer__c();
        dlr1.Opportunity_Name__c = opp.Id;
        dlr1.Dealer_Name__c=opp.AccountId;
        dlr1.Primary_Dealer__c = true;
        dlr1.Active__c = true;
        insert dlr1;
        test.stopTest();        
        
        dlr1.Primary_Dealer__c = true;
        update dlr1;
     }
     
     static testmethod void m3(){   
        test.starttest();
        Dealer__c dlr1 = new Dealer__c();
        dlr1.Opportunity_Name__c = opp.Id;
        dlr1.Dealer_Name__c=opp.AccountId;
        dlr1.Primary_Dealer__c = true;
        dlr1.Active__c = true;
        insert dlr1;
        test.stopTest();  
        delete dlr1;
          
        
    }
    
   
    
}