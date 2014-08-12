@isTest(seeAllData=true)
private class LX_Test_LX_OpportunityHelper{

    public static List<Opportunity> testOpp1;
    public static List<Opportunity> testOpp2;
    public static Map<Id,Account> testOppAccMap;
    public static Map<Id,Opportunity> testOppMap;
    public static Map<Id,Opportunity> testOppMapOther;
    public static Account testAccount;
    public static List<Opportunity> sampleOpp;
    public static User tempUserCurrent;
    public static LX_SAP_Record_Sales_Org__c testSAPRecord;
    public static LX_SAP_Record_Sales_Org__c testSAPRecordOther;
    public static Profile p;
    public static User testUser;
    public static User testOtherUser;
    public static Map<id,User> testUserMap;
    public static Map<id,Boolean> testOppBool;
    public static Map<id,Integer> testOppInt;
    
    public static testmethod void testOppHelper(){
        
        test.startTest();
            
            testAccount = new Account();
            testAccount = Data_Account.createAccount();
            testOppAccMap = new Map<Id,Account>();
            testOppMap = new Map<Id,Opportunity>();
            testOppMapOther = new Map<Id,Opportunity>();
            testOpp1 = new List<Opportunity>();
            testOpp2 = new List<Opportunity>();
            sampleOpp = new List<Opportunity>();
            sampleOpp = [Select id,name from Opportunity limit 1];
            testSAPRecord = new LX_SAP_Record_Sales_Org__c();
            testSAPRecord = [Select id,name from LX_SAP_Record_Sales_Org__c  limit 1];
            testSAPRecordOther = new LX_SAP_Record_Sales_Org__c();
            testSAPRecordOther = [Select id,name from LX_SAP_Record_Sales_Org__c where id != :testSAPRecord.id limit 1]; 
            p = new Profile();
            p = [select id  from profile limit 1];
            testUser = new User();
            testUser.Legacy_Company__c = 'Lexmark';
            testUser.Username = 'userrandom@test.com';       
            testUser.LastName = 'executive';
            testUser.FirstName = 'Account';      
            testUser.Email = 'process.admin@perceptivesoftware.com';       
            testUser.Alias = 'u1';
            testUser.CommunityNickname = 'us1';        
            testUser.TimeZoneSidKey = 'America/Chicago';        
            testUser.LocaleSidKey = 'en_US';    
            testUser.EmailEncodingKey = 'ISO-8859-1';        
            testUser.LanguageLocaleKey = 'en_US';
            testUser.profileid = P.id;
            Insert testUser;
            
            testOtherUser = new User();
            testOtherUser.Legacy_Company__c = 'Lexmark';
            testOtherUser.Username = 'user2new@test.com';       
            testOtherUser.LastName = 'executive';
            testOtherUser.FirstName = 'Account';      
            testOtherUser.Email = 'process.admin@perceptivesoftware.com';       
            testOtherUser.Alias = 'u2';
            testOtherUser.CommunityNickname = 'us2';        
            testOtherUser.TimeZoneSidKey = 'America/Chicago';        
            testOtherUser.LocaleSidKey = 'en_US';    
            testOtherUser.EmailEncodingKey = 'ISO-8859-1';        
            testOtherUser.LanguageLocaleKey = 'en_US';
            testOtherUser.profileid = P.id;
            Insert testOtherUser ;
            for (Integer i = 0; i < 6; i++) {            
                testOpp1.add(new Opportunity(
                    Name = 'TestOpp' + i,
                    StageName = 'Upside',
                    LX_Country_Code__c = 'US',
                    CloseDate = System.Today(),
                    No_of_Offering__c = 2,
                    LX_Stage_Number_New__c = 0,
                    AccountId = testAccount.Id,
                    LX_Change_Request__c = 'Yes',
                    LX_CR_Related_Opportunity__c = sampleOpp[0].id,
                    LX_Sold_To_New__c = testSAPRecord.id,
                    OwnerId = testUser.Id));
            }
            for (Integer i=0; i < 6; i++){
                if(i==0){testOpp1[i].StageName = 'LX_QUALIFYING';}
                else if(i==1){testOpp1[i].StageName = 'LX_DEVELOPING';}
                else if(i==2){testOpp1[i].StageName = 'LX_DEMONSTRATING';}
                else if(i==3){testOpp1[i].StageName = 'LX_PROPOSING';}
                else if(i==4){testOpp1[i].StageName = 'LX_CLOSING';}
                else if(i==5){testOpp1[i].StageName = 'LX_WON';}
            }
            insert testOpp1;
            for (Integer i = 0; i < 6; i++) {            
                testOpp2.add(new Opportunity(
                    Name = 'TestOpp' + i,
                    StageName = 'Upside',
                    LX_Country_Code__c = 'US',
                    CloseDate = System.Today(),
                    No_of_Offering__c = 2,
                    LX_Stage_Number_New__c = 0,
                    AccountId = testAccount.Id,
                    LX_Change_Request__c = 'Yes',
                    LX_CR_Related_Opportunity__c = sampleOpp[0].id,
                    LX_Sold_To_New__c = testSAPRecord.Id,
                    OwnerId = testOtherUser.Id));
            }
            insert testOpp2;
            
            for(Opportunity tempOpp : testOpp1){
                testOppAccMap.put(tempOpp.AccountId,testAccount);
                testOppMap.put(tempOpp.Id,tempOpp);
            }
            for(Opportunity tempOpp : testOpp2){
                testOppMap.put(tempOpp.Id,tempOpp);
                testOppMapOther.put(tempOpp.Id,tempOpp);
            }
            for(Opportunity tempOpp : testOpp1){
                tempOpp.LX_Sold_To_New__c = testSAPRecordOther.Id;
            }
            update testOpp1;
            for(Opportunity tempOpp : testOpp2){
                tempOpp.LX_Sold_To_New__c = testSAPRecordOther.Id;
            }
            update testOpp2;
            Id curUserId = UserInfo.getUserId();
            tempUserCurrent = new User();
            tempUserCurrent= [Select Id,Profile.name from User where Id =:curUserId ];
            
            //Call To UpdateOpportunityStageNumber in OpportunityHelper
            LX_OpportunityHelper.validateTRAccounts(testOpp1,testOppAccMap);
            LX_OpportunityHelper.updateOpportunityStageNumber(testOpp1);
            LX_OpportunityHelper.updateOpportunityDefaults(True,testOpp1,True,testOppMap,tempUserCurrent,True);
            for(Opportunity tempOpp : testOpp1){
                    tempOpp.OwnerId = testOtherUser.Id;
                }
            Update testOpp1;
            
      test.stopTest();
        
    }
    
    public static testmethod void testOppHelper2(){
    test.startTest();
            Schema.DescribeSObjectResult acc = Schema.SObjectType.Account; 
            Map<String,Schema.RecordTypeInfo> accMap = acc.getRecordTypeInfosByName();
            Id accRTId = accMap.get('Location Customer').getRecordTypeId();
            testAccount = new Account();
            testAccount = Data_Account.createAccount();
            testAccount.RecordTypeId = accRTId;
            Update testAccount; 
            testOpp1 = new List<Opportunity>();
            testOpp2 = new List<Opportunity>();
            testOppMap = new Map<Id,Opportunity>();
            testOppMapOther = new Map<Id,Opportunity>();
            testUserMap = new Map<Id,User>();
            testOppBool = new Map<Id,Boolean>();
            testOppInt = new Map<Id,Integer>();
            sampleOpp = new List<Opportunity>();
            sampleOpp = [Select id,name from Opportunity limit 1];
            testSAPRecord = new LX_SAP_Record_Sales_Org__c();
            testSAPRecord = [Select id,name from LX_SAP_Record_Sales_Org__c  limit 1];
            testSAPRecordOther = new LX_SAP_Record_Sales_Org__c();
            testSAPRecordOther = [Select id,name from LX_SAP_Record_Sales_Org__c where id != :testSAPRecord.id limit 1]; 
            p = new Profile();
            p = [select id  from profile limit 1];
            testUser = new User();
            testUser.Legacy_Company__c = 'Lexmark';
            testUser.Username = 'userrandom@test.com';       
            testUser.LastName = 'executive';
            testUser.FirstName = 'Account';      
            testUser.Email = 'process.admin@perceptivesoftware.com';       
            testUser.Alias = 'u1';
            testUser.CommunityNickname = 'us1';        
            testUser.TimeZoneSidKey = 'America/Chicago';        
            testUser.LocaleSidKey = 'en_US';    
            testUser.EmailEncodingKey = 'ISO-8859-1';        
            testUser.LanguageLocaleKey = 'en_US';
            testUser.profileid = P.id;
            Insert testUser;
            
        for (Integer i = 0; i < 6; i++) {            
                testOpp1.add(new Opportunity(
                    Name = 'TestOpp' + i,
                    StageName = 'Upside',
                    LX_Country_Code__c = 'US',
                    CloseDate = System.Today(),
                    No_of_Offering__c = 2,
                    LX_Stage_Number_New__c = 5,
                    AccountId = testAccount.Id,
                    LX_Change_Request__c = 'Yes',
                    LX_CR_Related_Opportunity__c = sampleOpp[0].id,
                    LX_Sold_To_New__c = testSAPRecord.id,
                    OwnerId = testUser.Id,
                    QALevel2Approved__c = True,
                    Type = 'New Solution',
                    LX_No_of_BM_Quotes__c = 3));
                    //LX_MPS_Inc_Funnel__c = False,
                    //Master_Opportunity__c = sampleOpp[0].id));
            }
         insert testOpp1;
         for (Integer i = 0; i < 6; i++) {            
                testOpp2.add(new Opportunity(
                    Name = 'TestOpp' + i,
                    StageName = 'Upside',
                    LX_Country_Code__c = 'US',
                    CloseDate = System.Today(),
                    No_of_Offering__c = 2,
                    LX_Stage_Number_New__c = 0,
                    AccountId = testAccount.Id,
                    LX_Change_Request__c = 'Yes',
                    LX_CR_Related_Opportunity__c = sampleOpp[0].id,
                    LX_Sold_To_New__c = testSAPRecord.Id,
                    OwnerId = testUser.Id,
                    Master_Opportunity__c = testOpp1[0].Id));
            }
         insert testOpp2;
         for(Opportunity tempOpp : testOpp2){
             testOppMapOther.put(tempOpp.Id,tempOpp); 
         }   
         for(Opportunity tempOpp : testOpp1){
             testOppMap.put(tempOpp.Id,tempOpp);
             testUserMap.put(tempOpp.OwnerId,testUser);
             testOppBool.put(tempOpp.Id, True);
             testOppInt.put(tempOpp.Id,Integer.ValueOf(tempOpp.LX_No_of_BM_Quotes__c) );
         }
         LX_OpportunityHelper.updateOpportunityOwnerFields(True,testOpp1,True,testOppMap,testUserMap);
         testUser.Legacy_Company__c = 'Nolij';
         Update testUser;
         for(Opportunity tempOpp : testOpp1){
             testUserMap.put(tempOpp.OwnerId,testUser);
         }
         LX_OpportunityHelper.updateOpportunityOwnerFields(True,testOpp1,True,testOppMap,testUserMap); 
         for(Opportunity tempOpp : testOpp1){
             tempOpp.Type = 'ElseType';
             tempOpp.LX_Stage_Number_New__c = 2;
         }
         Update testOpp1;
         LX_OpportunityHelper.updateOpportunityOwnerFields(True,testOpp1,True,testOppMap,testUserMap);
         LX_OpportunityHelper.updateOpportunityEndDate(True,testOpp1,False,testOppMap);
         LX_OpportunityHelper.updateOpportunityEndDate(True,testOpp1,True,testOppMap);
         String ParentId = testOpp1[0].Id;
         LX_OpportunityHelper.updateOppChildFlag(ParentId );
         LX_OpportunityHelper.updateOppFromQuote(testOppBool,testOppInt);
         String ProductType = 'MPS';
         LX_OpportunityHelper.sales_type(ProductType );
         ProductType = 'Random'; 
         LX_OpportunityHelper.sales_type(ProductType );
         LX_OpportunityHelper.updateMPSFunnel(testOpp1);
         LX_OpportunityHelper.updateMPSFunnel(testOpp2);
         LX_OpportunityHelper.updateMPSFunnelOnDelete(testOpp1);
         LX_OpportunityHelper.updateMPSFunnelOnDelete(testOpp2);
         LX_OpportunityHelper.BmiUpdate(testOppMapOther,testOppMapOther);
         
    test.stopTest();
    }
    
    public static testmethod void testOppHelper3(){
    
    test.startTest();
            Schema.DescribeSObjectResult acc = Schema.SObjectType.Account; 
            Map<String,Schema.RecordTypeInfo> accMap = acc.getRecordTypeInfosByName();
            Id accRTId = accMap.get('Location Customer').getRecordTypeId();
            testAccount = new Account();
            testAccount = Data_Account.createAccount();
            testAccount.RecordTypeId = accRTId;
            Update testAccount; 
            testOpp1 = new List<Opportunity>();
            testOpp2 = new List<Opportunity>();
            testOppMap = new Map<Id,Opportunity>();
            testOppMapOther = new Map<Id,Opportunity>();
            testUserMap = new Map<Id,User>();
            testOppBool = new Map<Id,Boolean>();
            testOppInt = new Map<Id,Integer>();
            sampleOpp = new List<Opportunity>();
            sampleOpp = [Select id,name from Opportunity limit 1];
            testSAPRecord = new LX_SAP_Record_Sales_Org__c();
            testSAPRecord = [Select id,name from LX_SAP_Record_Sales_Org__c  limit 1];
            testSAPRecordOther = new LX_SAP_Record_Sales_Org__c();
            testSAPRecordOther = [Select id,name from LX_SAP_Record_Sales_Org__c where id != :testSAPRecord.id limit 1]; 
            p = new Profile();
            p = [select id  from profile limit 1];
            testUser = new User();
            testUser.Legacy_Company__c = 'Lexmark';
            testUser.Username = 'userrandom@test.com';       
            testUser.LastName = 'executive';
            testUser.FirstName = 'Account';      
            testUser.Email = 'process.admin@perceptivesoftware.com';       
            testUser.Alias = 'u1';
            testUser.CommunityNickname = 'us1';        
            testUser.TimeZoneSidKey = 'America/Chicago';        
            testUser.LocaleSidKey = 'en_US';    
            testUser.EmailEncodingKey = 'ISO-8859-1';        
            testUser.LanguageLocaleKey = 'en_US';
            testUser.profileid = P.id;
            Insert testUser;
            
        for (Integer i = 0; i < 6; i++) {            
                testOpp1.add(new Opportunity(
                    Name = 'TestOpp' + i,
                    StageName = 'Upside',
                    LX_Country_Code__c = 'US',
                    CloseDate = System.Today(),
                    No_of_Offering__c = 2,
                    LX_Stage_Number_New__c = 5,
                    AccountId = testAccount.Id,
                    LX_Change_Request__c = 'Yes',
                    LX_CR_Related_Opportunity__c = sampleOpp[0].id,
                    LX_Sold_To_New__c = testSAPRecord.id,
                    OwnerId = testUser.Id,
                    QALevel2Approved__c = True,
                    Type = 'New Solution',
                    LX_No_of_BM_Quotes__c = 3));
                    //LX_MPS_Inc_Funnel__c = False,
                    //Master_Opportunity__c = sampleOpp[0].id));
            }
         insert testOpp1;
         for(Opportunity tempOpp : testOpp1){
             testOppMap.put(tempOpp.Id,tempOpp);
             testUserMap.put(tempOpp.OwnerId,testUser);
             testOppBool.put(tempOpp.Id, True);
             testOppInt.put(tempOpp.Id,Integer.ValueOf(tempOpp.LX_No_of_BM_Quotes__c) );
         }
         for(Opportunity tempOpp : testOpp1){
             tempOpp.LX_Stage_Number_New__c = 4;
             tempOpp.LX_Change_Request__c = 'No';
             tempOpp.LX_SAP_Project_Request__c = True;
             
         }
         update testOpp1;
         LX_OpportunityHelper.CreateSAPProjectRequest(testOpp1,testOppMap);
    test.stopTest();
    }
    
   
}