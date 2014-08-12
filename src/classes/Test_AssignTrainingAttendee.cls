@isTest
private class Test_AssignTrainingAttendee {
    
    public static List<Opportunity> test_opportunities = new list<opportunity>();
    public static user u = [Select id from User where profile.Name = 'System Administrator' and isActive = true limit 1];
    static testMethod void myUnitTest() {
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
        List<Product2> product = Data_Product.createProduct(pmList);   
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        //Account acct = Data_Account.createAccount4();
        
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 
            
        
        acc.LX_Geo__c = 'EMEA'; // added on 10/15/13 by Gajanan
        acc.recordtypeId = LX_setrecordIds.L5LocationPartnerAccountRecordId;
        acc.TR_Status__c='Off';
      update acc;
      
      Contact c = new Contact();
            c.LastName = 'Test Contact';
            c.AccountId = acc.Id;
            c.Accounting_Contact__c = false;
            c.Default_Bill_To__c = true;
            c.Contact_Role__c = 'User';
            c.Language__c = 'French';
            c.Lx_Lexmark_Vertical__c = 'Manufacturing';
            c.Phone = '11223344';
            c.MobilePhone = '3323232323';
            c.email = 'test33@test.com';
            insert c; 
        
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
                             Contact cont = contacts[0];
                             cont.Email='c@k.com';
                             cont.License_contact__c =true;
                             update cont;
         system.debug('xxxxx'+limits.getQueries());
        //create opportunity in system
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
        opportunity opp;
        system.runAs(u)
        {   
           // test_opportunities = Data_Opportunity.createOpportunity2(stageList, 1,acc,contacts,pmList,product ,pricebook2 ,pbe);
        //update test opportunity so that QA Status = 'Complete'
         opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
        insert opp;
        }
        
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');
        CategoryList.add('');
        CategoryList.add('');
        test.startTest(); 
             
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp.id, pbe.id, categoryList );       
        System.assert(oppLineItem[0].id != null);
        
                                                 
        for (Opportunity oppRec : Test_Opportunities){
            oppRec.QAStatus__c = 'Complete'; 
        }
        
        
        
          update Test_Opportunities;
        //test.startTest();
        
        
        Class__c newClass = Data_Class.createClass(); 
       
        ELearning_Registration__c newRegistration = Data_ELearningRegistration.createElearning(newclass.id,opp.AccountID ); 
        Training_Attendee__c newAttendee = Data_TrainingAttendee.createTrainingAttendee(newClass.id,newRegistration.id ); 
        newAttendee.contact__c = opp.Ship_To__c;
        update newAttendee;
        List<Token__c> tokenRecList = new List<Token__c>();
        Token__c tokenRec = new Token__c();
        tokenRec.Account__c = opp.AccountID;
        tokenRec.Token_Type__c = 'Training';
        //tokenRec.Training_Attendee__c = newAttendee.Id;
        tokenRecList.add(tokenRec);
        //insert tokenRec;
        
        Token__c tokenRec2 = new Token__c();
        tokenRec2.Account__c = opp.AccountID;
        tokenRec2.Token_Type__c = 'Training';
        tokenRecList.add(tokenRec2);
        //insert tokenRec2;
        insert tokenRecList;
       system.debug('new attendee: '+ newAttendee);
        
        List<Training_Attendee__c> attendeeRec = new List<Training_Attendee__c>([ select Id
                                                                                , tokens__c
                                                                                , Account__c
                                                                                , Name
                                                                                , Registration__c
                                                                                , contact__c
                                                                              from Training_Attendee__c
                                                                                where id = :newAttendee.id ]);  
         system.debug('attendeerec: '+ attendeerec);
        test.stopTest(); 
      for (integer t = 0;t<1;t++){
            //  Integer tokens = integer.valueof(attendeerec[t].Tokens__c);
            //  system.debug('tokens' + tokens);
              
              string attendeeID = attendeerec[0].Id;
              system.debug('attendeeID' + attendeeID);
              
              string accountID = opp.AccountID;
              system.debug('accountID' + accountID);
    
              //string contactID = attendeeRec[0].Contact__c;
              string contactID = c.id;
              
      
              string name = attendeerec[0].Name;
              system.debug('name' + name);
              
              string registration = attendeerec[0].Registration__c;
              system.debug('registrationid' + registration);
              Token_AssignTrainingAttendee.AttendeeStatus(1, contactID, attendeeID, accountID , name, registration);
              Token_RemoveTrainingAttendee.RemoveAttendee(attendeeID);
        } 
    }
}