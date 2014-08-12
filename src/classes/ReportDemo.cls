public with sharing class ReportDemo{
    
    public List<Opportunity> soqlquery(){
        List<Opportunity> opptyList = new List<Opportunity>();
        opptyList = [SELECT AccountId, LX_Account_ID__c, Amount_formatted__c, Amount_BM__c, Amount, Area_of_Interest_s__c, Date_Qualification_Conv__c, 
                    Reason_for_Conversion__c FROM Opportunity where Amount > 0 and Amount_BM__c > 0 and Amount_formatted__c > '0' 
                    and Reason_for_Conversion__c != 'legacy' and Reason_for_Conversion__c != null];
    
        return opptyList;
    }
    
   
    

}