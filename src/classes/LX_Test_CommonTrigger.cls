/**
This Test class is used to cover the following trigger:
LX_Opportunity_Competitor_AI_AU
 */
@isTest(SeeAllData = true)
private class LX_Test_CommonTrigger {
    
    //Declaring the Opportunity instance    
    static public Opportunity testOpp;
    
    //Declare the Account instances for Opportunity and the competitor
    static public Account testAcc, testComp;
    
    //Declare the Opportunity Competitor Instance
    static public LX_Opportunity_Competitor__c oppComp1, oppComp2;
    
    //Declare contacts instance
    static public Contact testCon;
    
    /* This method is used to setup the testData required for test classes
    */
    static testMethod void setupData() {
        
        //List<User> lstUser = [Select id from User where profile.Name='System Administrator' and isActive=true and LX_Ability_to_Create_Accounts__c='Yes' limit 2];
         List<User> lstUser = [Select id from User where profile.Name='System Administrator' and isActive=true and LX_Ability_to_Create_Accounts__c='Yes' limit 2];

        System.runAs(lstUser[0]){
        //Create an Account for Partner Location Type
        testAcc =  Data_Account.createAccount3();
        testAcc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();

        
        //Ceate an Account recordType for competitor record type.
        testComp = Data_Account.createAccount3();
        testComp.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        
        
        update testAcc;
        update testComp;
        }
         
        System.runAs(lstUser[1]){
                
        //Create the opportunity.       
        list<string> stageList = new List<String>();
        stageList.add('Qualifying');        
        

        test.startTest();        
        for(Opportunity opp :Data_Opportunity.createOpportunity3(stageList,1,testAcc, Data_Contact.createContacts(testAcc.id,2))){
            testOpp = opp;
        }
        testOpp.AccountId = testAcc.id;
        update testOpp;
        
        system.debug('@@@@@@@@@@@@'+testOpp.AccountId);
        
        oppComp1 = new LX_Opportunity_Competitor__c(
                        LX_Competitor_Account__c = testComp.id,
                        LX_Primary__c = true,
                        LX_winner__c = true,
                        LX_Opportunity__c = testOpp.Id,
                        LX_Customer_Account__c = testAcc.id);
                        
        system.debug('>>>>>>>>>>>>>>>>>'+oppComp1);
        system.debug('>>>>>>>>>>>>>>>>>'+oppComp1.LX_Customer_Account__c );
        system.debug('>>>>>>>>>>>>>>>>>'+oppComp1.LX_Competitor_Account__c );                
        insert oppComp1; 
        test.stopTest();
        /*oppComp2 = new LX_Opportunity_Competitor__c(
                        LX_Competitor_Account__c = testComp.id,
                        LX_Primary__c = true,
                        LX_winner__c = true,
                        LX_Opportunity__c = testOpp.Id,
                        LX_Customer_Account__c = testAcc.id);
                        
        system.debug('>>>>>>>>>>>>>>>>>'+oppComp2);
        system.debug('>>>>>>>>>>>>>>>>>'+oppComp2.LX_Customer_Account__c );
        system.debug('>>>>>>>>>>>>>>>>>'+oppComp2.LX_Competitor_Account__c );                
        insert oppComp2;*/    
        }    
         
    }
   
    /* This method is used to setup the testData required for test classes
    */
    static void commonTriggerMethod() {
        setupData();
        
        system.assertNotEquals(oppComp1, null); 
        oppComp1.LX_winner__c = false;
        update oppComp1;
        oppComp1.LX_winner__c = true;
        update oppComp1;
        test.startTest();
        oppComp1.LX_Primary__c = false;
        update oppComp1;
        oppComp1.LX_Primary__c = true;
        update oppComp1;
        delete oppComp1;
        
        list<LX_Opportunity_Competitor__c> oppCompDel = [select id from LX_Opportunity_Competitor__c
                                      where id =:oppComp1.id];
        system.assertEquals(oppCompDel.size(),0);
        test.stopTest();                               
        
    }    
    
}