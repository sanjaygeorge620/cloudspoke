@isTest(seeAllData = true)
Public class LX_Test_LX_AssignSolutionOwner{
   // public Case testCaseRec,testCaseRec2;
    public static List<Case> testCaseList;
    public static Product_Model__c tempProdModel;
    public static Account tempAcc;
    public static Account tempResellerAcc;
    public static Contact tempContact;
    public static pse__proj__c tempProj;
    public static User tempUser;
    public static Opportunity tempOpp;
    public static Map<String,String> mapNameEmail;
    public static Map<String,Contact> mapEmailContact;
    
    public static testmethod void LX_Test_LX_AssignSolutionOwner(){
    test.startTest();
    try{ 
        tempOpp = [Select id from Opportunity limit 1];
        mapNameEmail = new Map<String,String>();
        mapEmailContact =  new Map<String,Contact>();
         
        Schema.DescribeSObjectResult cas= Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> recMap = cas.getRecordTypeInfosByName();
        Id recTypeId = recMap.get('SAP Project Request').getRecordTypeId();
        
        tempAcc = new Account();
            tempAcc = Data_Account.CreateAccount();
         
        tempProj = new pse__proj__c();
            tempProj.pse__Opportunity__c = tempOpp.Id;
            tempProj.pse__Account__c = tempAcc.Id;
        insert tempProj; 
        
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage(); 
        tempResellerAcc = new Account();
            tempResellerAcc.name='Account4TestMethod';       
            tempResellerAcc.BillingState= 'Rajasthan';  
            tempResellerAcc.Name = 'testAccount';
            tempResellerAcc.Sector__c = 'State/Local';
            tempResellerAcc.Type = 'Customer';  
            tempResellerAcc.Party_Role__c = 'Perpetual';
            tempResellerAcc.Party_Type__c =  'Commercial';
            tempResellerAcc.Coverage_ID__c = gc.id;
            tempResellerAcc.MDM_Sold_To_Number__c = '56A47657';
            tempResellerAcc.Primary_Sector_Focus__c = 'Manufacturing';
            tempResellerAcc.Legacy_Company_Originator__c = 'Acuo';
            tempResellerAcc.LX_Sales_Team_Assigned__c='Manufacturing';
            tempResellerAcc.Physical_Country__c = 'USA';
            tempResellerAcc.BillingCountry  = 'USA';
            tempResellerAcc.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
            tempResellerAcc.Reseller_ID__c = tempAcc.Id;
            insert tempResellerAcc;
            
            
        tempContact = new Contact();
            tempContact.LastName='Test Contact1 ';
            tempContact.firstName='TestFirst';
            tempContact.AccountId = tempAcc.Id;
            tempContact.Contact_Role__c ='Executive'; 
            tempContact.Region__c='NA';
            tempContact.email='test@lexmark.com';
            tempContact.Physical_street_address__c = '74553 W';
            tempContact.Physical_City__c = 'shawnee';
            tempContact.address_edit_countries__c = 'United States';
            tempContact.License_Contact__c=true;
            tempContact.Accounting_Contact__c = true;
            tempContact.areas_of_need__c = 'Content';
            tempContact.pse__Is_Resource__c = true;
            tempContact.pse__Is_Resource_Active__c = true;
            tempContact.phone='123456789';
            tempContact.MobilePhone='9123456789';
            tempContact.Fax='9123456789';
            tempContact.Status__c = 'Active' ;
            tempContact.Industry__c = 'Manufacturing';
            tempContact.Lx_Lexmark_Vertical__c='Manufacturing';
        insert tempContact;
        
        
                
        tempProdModel = new Product_Model__c();
            tempProdModel = new Product_Model__c();
            tempProdModel.Name  = 'Test Model'; 
            tempProdModel.Line__c = 'Solutions Software';
            tempProdModel.Series__c = 'Application Maint. & Dev';
            tempProdModel.Family__c  = 'Support';
            tempProdModel.Model__c = 'TestM';
            tempProdModel.Asset_Required__c = true;
            insert tempProdModel ;
        
        Set<String> userProfile = new Set<String>();
            userProfile.add('Sales');
            userProfile.add('Sales Admin');
            userProfile.add('Sales Management');
        List<Profile> ProfileIds = new List<Profile>();
             
            for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                      ProfileIds.add(profile);
            }   
        tempUser = new User();
            tempUser.FirstName = 'testUser';
            tempUser.LastName = 'testUser';
            tempUser.ProfileId = ProfileIds[0].Id;
            tempUser.Legacy_Company__c = 'Lexmark';
            tempUser.Username = 'testUserName2345@test.com';
            tempUser.Email = 'test23456@lexmark.com';
            tempUser.Alias = 'test';
            tempUser.CommunityNickname = 'testComName123';
            tempUser.TimeZoneSidKey = 'America/Chicago';
            tempUser.LocaleSidKey = 'en_US';
            tempUser.EmailEncodingKey = 'ISO-8859-1';
            tempUser.LanguageLocaleKey = 'en_US';
            
        insert tempUser;
        
        testCaseList = new List<Case>();
        Case testCaseRec = new Case();
            testCaseRec.Impact__c = 'Test';
            testCaseRec.Accountid = tempResellerAcc.id;
            testCaseRec.Contactid = tempContact.id;
            testCaseRec.Frequency__c = 'Hourly';
            testCaseRec.Subject = 'Testing Subject';
            testCaseRec.Dev_Start_Date__c = Date.newInstance(2014,05,05);
            testCaseRec.Description = 'Testing Description';
            testCaseRec.Name_of_Component__c = 'Testing';
            testCaseRec.Run_Method__c = 'Intool';
            testCaseRec.Install_Instructions__c = 'Testing';
            testCaseRec.Reason = 'new problem';
            testCaseRec.RecordTypeId = recTypeId ;
            testCaseRec.Consultant__c = UserInfo.getUserId();
            testCaseRec.Project_Manager__c = UserInfo.getUserId();
            testCaseRec.Solution_Developer__c = UserInfo.getUserId();
            testCaseRec.Due_Date__c = Date.newInstance(2014,09,09);
            testCaseRec.Product__c = tempProdModel.id;
            testCaseRec.Reseller_ID__c = tempResellerAcc.Reseller_ID__r.name;
            testCaseRec.Project__c = tempProj.id;
           // testCaseRec.OwnerId = tempUser.id;
         //   testCaseRec.OwnerId = CreatedByID;
            testCaseRec.status = '03. Quote Submitted';
        insert testCaseRec;
       
        testCaseList.add(testCaseRec);
            
        LX_AssignSolutionOwner testInstance = new LX_AssignSolutionOwner();
        //testInstance.mapOwnerDetails.put(testCaseRec.Owner.Name,testCaseRec.Owner.Email );
        //testInstance.mapContacts.put(testCaseRec.Owner.Email,testCaseRec.Contactid);
       
       testInstance.AssignSolutionOwnerName(testCaseList);
       }
       catch(Exception e){}
        
    
    test.stopTest();
    }

}