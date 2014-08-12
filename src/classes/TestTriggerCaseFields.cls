/**********************************************************************************************
Name : TestTriggerCaseFields
Purpose : gives test coverage for UpdateCaseFields and UpdateResellerFields
author : Jennifer Dauernheim
Date : July 15, 2009
************************************************************************************************/
@isTest
Private class TestTriggerCaseFields {
public static List<pse__Proj__c> Projects = Data_Project.createProject(1);   
    @isTest
    static void testTriggerCaseFields() {
    /**********************************
    *   create records for processing *
    **********************************/
       Test.StartTest();
         
      Account acc = Data_Account.createAccount();
      Account acc_Reseller = Data_Account.createAccount();
      acc_Reseller.type = 'Partner';
      update acc_Reseller;
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3); 
      contacts[0].email = 'testing@perceptivesoftware.com';    
      update contacts[0]  ;
      system.debug('contacts[0]: ' + contacts[0]);
    
    //add account record - this will be used for Reseller and to test remote administration, subscription, platform services
        
    acc.Name = 'testAccount';
    acc.Reseller_ID__c = acc_Reseller.id;
    acc.Remote_Administration__c = True;
    acc.Subscription__C = True;
    acc.Platform_Services__c = True;
    update acc;
        
        
    
    RecordType recordtypeID = [select Id from RecordType where name = 'HelpDesk' and sobjectType = 'Case' Limit 1];
    system.assert(recordtypeID != Null);
        
    ID misc2 = recordtypeID.id;
    id misc3 = recordtypeID.id;    
    
    
    List<Case> cases = Data_Case.createCase(acc, contacts[0], recordtypeID.id, projects[0].id, misc2, misc3,1); 
    system.debug('cases List: ' + cases);
        
    /***********************
    *    test records      *
    ***********************/
    //test remote administration
    //system.assertEquals(False,
     //   [select remote_Administration__c from Case where id = :cases[0].id].remote_Administration__c);
    //system.assertEquals(null,
      //  [select reseller_ID__c from Case where id = :cases[0].id].reseller_ID__c);
        
        Test.StopTest();
 
    }
    
  
}