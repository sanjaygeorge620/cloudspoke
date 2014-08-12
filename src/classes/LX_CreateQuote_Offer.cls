/*global class LX_CreateQuote_Offer{ 
  webService static boolean checkQuote(Id offId) { 
        
        List<BigMachines__Quote__c> bmQuote = new List<BigMachines__Quote__c>();
        bmQuote = [select Id,Name from BigMachines__Quote__c where Offer__c =:offId]; 
        
        if(bmQuote.size() > 0)
        {
           return true; 
        }    
        else
        return false;
    }
}*/

Public class LX_CreateQuote_Offer{ 
    
    Id OffId{get;set;}
    public LX_CreateQuote_Offer(ApexPages.StandardController controller){
        OffId = ApexPages.currentPage().getParameters().get('offerId');
    }
    public PageReference checkQuote() { 
        
        List<BigMachines__Quote__c> bmQuote = new List<BigMachines__Quote__c>();
        bmQuote = [select Id,Name from BigMachines__Quote__c where Offer__c =:offId]; 
        
        if(bmQuote.size()==0)
        { 
            PageReference PageRef = new PageReference('/apex/BigMachines__QuoteEdit?offerid='+OffId);
            return PageRef;
            
        }    
        else
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Fatal, 'There is already an existing Quote on this offer, please create a new Quote from Deal Desk');
            ApexPages.addMessage(msg);
            return null;
            
        }
    }
}