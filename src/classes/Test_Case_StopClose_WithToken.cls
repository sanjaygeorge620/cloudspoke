@isTest
private class Test_Case_StopClose_WithToken 
{

Public Static List<pse__Proj__c> Projects = Data_Project.createProject(1);

    static testMethod void Test_Case_StopClose_WithToken() 
    {
    system.debug('Check2' + Limits.getQueries());
     
  
      Account acc = Data_Account.createAccount2();

      Test.StartTest();       
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,2); 
      RecordType recordtypeID = [select Id from RecordType where name = 'Product Support' and sobjectType = 'Case' Limit 1];
    //  List<pse__Proj__c> Projects = Data_Project.createProject(1); 
      ID misc2 = recordTypeID.id;
      id misc3 = recordTypeID.id;    
      
      

      List<Case> cases = Data_Case.createCase(acc, contacts[0], recordtypeID.id, projects[0].id, misc2, misc3,3);  
    
      
      try{
        cases[0].Require_Token__c = 'Yes';
        cases[0].status = 'Closed';
        update cases[0];
      }catch(Exception e){
            system.debug('e.getMessage(): '+ e.getmessage());
            System.Assert(e.getMessage().contains('Token Quantity is required to close this case.:'));
        }
        
      system.debug('Check2' + Limits.getQueries());
    Test.StopTest();        
    }
}