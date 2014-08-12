/*************************************************************************************
Name     : TestSetSolutionDevCaseOwner

Purpose  : Test class to cover SetSolutionDevCaseowner & AssignSolutinOwner

Author   : jennifer dauernheim

Date     : January 12, 2010
**************************************************************************************/
@isTest
private class TestSetSolutionDevCaseOwner {

public static List<pse__Proj__c> Projects = Data_Project.createProject(1);  

    @isTest
    static void TestSetSolutionDevCaseOwner() 
    {
    
     test.starttest();
     
      Account acc = Data_Account.createAccount();             
     
      Set<String> userProfile = new Set<String>();
      userProfile.add('PSE Management');
      userProfile.add('PSE User');
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
           ProfileIds.add(profile.id);
        }
     List<User> userList = Data_User.createUser(3, profileIds);  
        
    //List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);    
    List<Contact> contacts = new List<Contact>();
    Contact con = new Contact(
                           LastName='Test Contact 2323',
                           firstName='TestFirst',
                           AccountId = acc.ID,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email='process.admin@perceptivesoftware.com',
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           License_Contact__c=true,
                           //pse__Salesforce_User__c = userList[u].id,
                           Accounting_Contact__c = true,
                           areas_of_need__c = 'Content',
                          // pse__Is_Resource__c = true,
                          // pse__Is_Resource_Active__c = true,
                          // pse__Action_Update_Current_Time_Period__c = false,
                           phone='1234',
                           Lx_Lexmark_Vertical__c = 'Manufacturing');
     
      insert con;
      contacts.add(con); 
  //   List<pse__Proj__c> Projects = Data_Project.createProject(1);  
    
    Contact TestContact =  [select Id, ownerID from Contact where status__c = 'Active' Limit 1];
        // get any product
    Product_Model__c ProductConfig = new Product_Model__c (Status__c = 'General Availability',name='test Model');
    insert ProductConfig;
    
    //[Select Id from Product_Model__c  where Status__c = 'General Availability' Limit 1];
    
    
    RecordType recordtypeID = [select Id from RecordType where name = 'Solution Development' and sobjectType = 'Case' Limit 1];
    system.assert(recordtypeID != Null);
        
    ID misc2 = recordtypeID.id;
    id misc3 = recordtypeID.id;    
    
    List<Case> cases = Data_Case.createCase(Acc, contacts[0], recordtypeID.id, projects[0].id, misc2, misc3,3); 
    list<ID> caseidSet = new list<ID>();
    //caseidset.add(newCase.Id);
        
    //    
        //check did case get created
        
       
      
        Cases[0].status = '08. QA – Ready to Assign';
        
        update Cases[0];
            AssignSolutionOwner.AssignSolutionOwnerName(caseidset);
        

        system.assertEquals(cases[0].Project_Manager__c , 
             [select OwnerID, Project_Manager__c from Case where ID = :cases[0].id limit 1].Project_Manager__c);
        
//test email message
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

         User SendtoUser = ([select Email, name, id from User where id = :userList[0].ID limit 1]);   // Strings to hold the email addresses to which you are sending the email.  
         //Contact SendtoContact = ([select Email, name, id from Contact where email = :SendtoUser.email limit 1]);
                        
         EmailTemplate template = ([select Id from EmailTemplate where Name = 'Solution Development - Assignment Notification' limit 1]);
         mail.setTargetObjectId(contacts[0].id);
         mail.setTemplateId(template.Id);
         mail.setWhatId(cases[0].ID);
         mail.saveAsActivity = false;
                                        
         mail.setSenderDisplayName('Solution Development');                 // Specify the name used as the display name.  
         List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                                
         //Send email results    
   //     system.debug ('statuscode : ' + results.get(0).getErrors()[0].getMessage());
        System.debug('Email result ' + results[0].IsSuccess());
         
        
         System.AssertEquals(true, results[0].IsSuccess());
         
         test.stoptest();
      
    }
}