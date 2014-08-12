/* Class Name   : testLX_CloneAnaplanUniqueId
* Description   : This is a test class for trigger LX_CloneAnaplanUniqueId 
* Created By   : Deepti Tadala
* Created Date : 03-13-2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Deepti Tadala         03-13-2014               1000                 Initial Version

*/





@isTest(seealldata = true)
private class testLX_CloneAnaplanUniqueId_OPP {

   public static testmethod void m1 () {
   
   
               
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 

        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today(),LX_Opportunity_Unique_Id__c = 'opp.id'); 
        insert Opp;
        
    
                      
    }
 }