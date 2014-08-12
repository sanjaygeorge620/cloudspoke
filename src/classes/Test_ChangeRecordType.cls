@isTest(seeAllData = true)
private class Test_ChangeRecordType{
    public static Schema.DescribeSObjectResult des1 = Schema.SObjectType.Account; 
    public static Map<String,Schema.RecordTypeInfo> rtMap1 = des1.getRecordTypeInfosByName();
  static testMethod void testPartnerLeadLocking(){  
   
        //Fetch the partner locked record type id for the sobject 'Account'   
        try{
        id partnerLockedRecordType= LX_SetRecordIDs.L5LocationPartnerAccountRecordId;}
        catch(Exception e){}
                                       
        //Create an account
        Account acc = Data_Account.createAccount();
        
        //Fetch acc and set its type and change its record type.
        Account accToUpdate = [SELECT Id,Name FROM Account where Id=:acc.Id];
        //Change the account type to Partner-Channel Level 1
        accToUpdate.Type='Location Partner';        
        //Make the account record type to partner locked
        Id MRrtacctId = rtMap1.get('Location Partner').getRecordTypeId();  
        accToUpdate.RecordTypeId=MRrtacctId; 
        //Update the account with the new values
        update accToUpdate;       
       
        //Create a campaign
        Campaign camp =  Data_Campaign.createCampaign('Parent Campaign', '');
        
        //Create geography coverage
        //Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();
        
        //Fetch unlocked and locked record type id's
        RecordType leadUnlockedRecordType= [SELECT Id FROM RecordType
                                            WHERE SobjectType='Lead' AND Name='unlocked'];  
                                                                                   
        //create a lead
        Lead l1 = Data_Lead.createLeads(camp.id); 
       
        
        //Fetch the lead l1 and update its record type to unlocked
        Lead l1ToUpdate = [SELECT Id,Name FROM Lead WHERE Id=:l1.id];     
        l1ToUpdate.RecordTypeId=leadUnlockedRecordType.Id;
        //l1ToUpdate.Coverage_ID__c=gc.id; 
        update l1ToUpdate;
               
        //create the lead that will invoke the trigger
        Lead l=Data_Lead.createLeads(camp.id);
        //Fetch the lead l and update its Record Type,Primary Partner and Geography Code
        Lead lToUpdate=[SELECT Id,Name FROM Lead WHERE Id=:l.id];   
        lToUpdate.RecordTypeId=leadUnlockedRecordType.Id;
        lToUpdate.Primary_Partner__c=acc.id;
        lToUpdate.Partner_Approved__c='Approved';
        //lToUpdate.Coverage_ID__c=gc.id;
        update lToUpdate;
        
        Lead l1Updated=[SELECT Id,Name,Partner__c,Locked_Date__c,RecordTypeId,rrpu__Alert_Message__c FROM Lead WHERE Id=:l1.id]; 
                  
        //System.AssertNotEquals(l1Updated.Partner__c,null);
        //System.AssertEquals(l1Updated.rrpu__Alert_Message__c,'Partner Restricted Lead');
        //System.AssertEquals(l1Updated.Locked_Date__c,System.Today());
        //System.AssertNotEquals(l1Updated.RecordTypeId,leadUnlockedRecordType.Id);                
        
       }
  
}