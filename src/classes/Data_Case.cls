@isTest
public class Data_Case{
    //misc1 & misc2 ids are for any field that you want to push an id that may be required for that particular case
 public static List<Case> createCase(Account account_Rec, Contact Contact_Rec, id recordtypeID, id misc1, id misc2, id misc3, Integer size){    
     List<Case> cases= new List<Case>();    
     Set<Id> contactIds = new Set<Id>();    
     Contact con;   
     
     
     Set<String> userProfile = new Set<String>();
     userProfile.add('PSE User');
     userProfile.add('PSE Management');
     userProfile.add('PSE Admin');
      
     List<ID> ProfileIds = new List<ID>();
         
     for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           ProfileIds.add(profile.id);
     }
     
     List<User> userList = Data_User.createUser(3, ProfileIds); 
     
     List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
     List<Product2> product = Data_Product.createProduct(pmList);        

     integer u = 0;
     for(Integer i =0;i<size;i++){        
        Case caseRec = New Case();
        caseRec.Impact__c = 'User';
    //    caseRec.Accountid = account_Rec.Id;
        caseRec.Internal_Case_Account__c = account_Rec.Id;
    //    caseRec.Contactid = Contact_Rec.id;
        caseRec.Contactid = Contact_Rec.Id;
        caseRec.Frequency__c = 'Hourly';
        caseRec.Subject = 'Testing Subject';
        caseRec.Dev_Start_Date__c = Date.newInstance(2009,01,01);
        caseRec.Description = 'Testing Description';
        caseRec.Name_of_Component__c = 'Testing';
        caseRec.Run_Method__c = 'Intool';
        caseRec.Install_Instructions__c = 'Testing';
        caseRec.Reason = 'new problem';
        caseRec.RecordTypeId = recordtypeID;
        caseRec.Consultant__c = userList[1].id;
        caseRec.Project_Manager__c = userList[2].id;
        caseRec.Solution_Developer__c = userList[0].id;
        caseRec.Due_Date__c = Date.newInstance(2009,01,01);
        caseRec.Product__c = pmList[0].id;
        caseRec.Reseller_ID__c = Account_Rec.Reseller_ID__r.name;
        caseRec.Project__c = misc1;
        Cases.add(caseRec);
        system.debug('new contact record: ' + con);
      
         if (u < profileIDs.size()-1){
                u++;
                system.debug('u:' + u);

         } 
     }
     insert cases;
     return cases;
  }  
  
  
  //method overridden - Generic
  public static List<Case> createCase(Account Account, Contact Contact, string RecordTypeName, integer Size){    
     
     //get recordtype id
     Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
     Id recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
     
     //list for cases    
     List<Case> cases= new List<Case>();    
     
     integer u = 0;
     for(Integer i =0; i<size; i++){        
          Case newcase = New Case();
          newcase.Account = Account;
          newcase.Contact = Contact;
          
          newcase.Subject = 'Testing Subject';
          newcase.Description = 'Testing Description';
          newcase.Impact__c = 'User';
          newcase.Frequency__c = 'Hourly';
          newcase.Reason = 'new problem';
          newcase.RecordTypeId = recordType;
        Cases.add(newcase);
     }
     insert cases;
     return cases;
  }  
  //method overridden - Generic
  public static List<Case> createCase2(Account Account, Contact Contact, string RecordTypeName, integer Size){    
     Account acc = Data_Account.createAccount(); 
     List<Contact> contacts = Data_Contact.createContacts2(acc.Id,1); 
     //get recordtype id
     Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
     Id recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
     list<string> caseStatus = new list<string>();
     caseStatus.add('03. Quote Submitted');
     caseStatus.add('05. Development - Assigned');
     caseStatus.add('08. QA - Ready to Assign');
     caseStatus.add('09. QA - In Progress');
     caseStatus.add('10. Implementation - Ready for Install');
     caseStatus.add('12. On Hold');
     //list for cases    
     List<Case> cases= new List<Case>();    
     
     integer u = 0;
     integer j = 0;
     for(Integer i =0; i<size; i++){        
          Case newcase = New Case();
          newcase.Account = Account;
          newcase.Contact = Contact;
          
          newcase.Subject = 'Testing Subject';
          newcase.Description = 'Testing Description';
          newcase.Impact__c = 'User';
          newcase.Frequency__c = 'Hourly';
          newcase.Reason = 'new problem';
          newcase.RecordTypeId = recordType;
          newcase.status = caseStatus[j];
          newcase.Solution_Developer__c  = userInfo.getUserId(); 
          newcase.Project_Manager__c = userInfo.getUserId();
          newcase.Consultant__c = userInfo.getUserId();
          j++;
          if(j == 6){
              j = 0;
          }
        Cases.add(newcase);
     }
     insert cases;
     return cases;
  }
  
  ////////////////
    public static List<Case> createCase_withSubject(Account Account,string subj,Contact Contact, string RecordTypeName, integer Size)
    {    
     
     //get recordtype id
     Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
     Id recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
     
     //list for cases    
     List<Case> cases= new List<Case>();    
     
     integer u = 0;
     for(Integer i =0; i<size; i++){        
          Case newcase = New Case();
          newcase.Account = Account;
          newcase.Contact = Contact;
          
          newcase.Subject = subj;
          newcase.Description = 'Testing Description';
          newcase.Impact__c = 'User';
          newcase.Frequency__c = 'Hourly';
          newcase.Reason = 'new problem';
          newcase.RecordTypeId = recordType;
        Cases.add(newcase);
     }
     insert cases;
     return cases;
  }  

  
  //////////////////// 
  
  @istest(SeeallData = true)  
  static void testTestData() 
  {
      
  
   system.debug('Check 3 ' + Limits.getQueries());
                
      system.debug('Check 3 ' + Limits.getLimitQueries());  
      
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);
      
        pse__Region__c pse_region = Data_PSE_Region.createRegion(); 
     system.assert(pse_region.Id != null);
        
     //Insert Practice
     pse__Practice__c pse_practice = Data_PSE_Practice.createPractice();
     system.assert(pse_practice.Id != null);
      
      
       system.debug('Check 4 ' + Limits.getQueries());
                
      system.debug('Check 4 ' + Limits.getLimitQueries());  
       
  //    RecordType recordtypeID = [select Id from RecordType where name = 'Solution Development' and sobjectType = 'Case' Limit 1];
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('Solution Development').getRecordTypeId();
        
      test.starttest(); 
      List<pse__Proj__c> Projects = Data_Project.createProjects(1,acc,Contacts,pse_region,pse_practice); 
      ID misc2 = recordTypeID;
      id misc3 = recordTypeID; 
 
      
       system.debug('Check 5 ' + Limits.getQueries());
                
      system.debug('Check 5 ' + Limits.getLimitQueries());  
      
      List<Case> cases = Data_Case.createCase(acc, contacts[0], recordtypeId, projects[0].id, misc2, misc3,3);     
      
    
      System.assertEquals(cases.size(),3);  
      
      
      //overridden method
   
      
        
      
        
      test.stoptest();
      
          
    //  System.assertEquals(cases[0].subject,'Testing Subject'); 
      
  }  
@istest(SeeallData = true)
public static void test2()
{
    
     Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);
      
        pse__Region__c pse_region = Data_PSE_Region.createRegion(); 
     system.assert(pse_region.Id != null);
        
      test.starttest(); 
     //Insert Practice
     pse__Practice__c pse_practice = Data_PSE_Practice.createPractice();
     system.assert(pse_practice.Id != null);
      
      
       system.debug('Check 4 ' + Limits.getQueries());
                
      system.debug('Check 4 ' + Limits.getLimitQueries());  
       
  //    RecordType recordtypeID = [select Id from RecordType where name = 'Solution Development' and sobjectType = 'Case' Limit 1];
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('Product Support').getRecordTypeId();
    
List<Case>cases = Data_Case.createCase(acc, contacts[0],'Product Support', 1);
      
      system.debug('Check42 ' + Limits.getQueries());
                
      system.debug('Check42 ' + Limits.getLimitQueries()); 
    
     test.stoptest();
}
@istest(SeeallData = true)
public static void test3()
{
    
     Account acc = Data_Account.createAccount();
     List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);
      test.starttest(); 
      system.debug('Check 4 ' + Limits.getQueries());
      system.debug('Check 4 ' + Limits.getLimitQueries());  

        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('Product Support').getRecordTypeId();
    
List<Case>cases = Data_Case.createCase_withSubject(acc,'Subject',contacts[0],'Product Support', 1);   //Added By Naveen 05/06 to Pass Subject for case creation
      
      system.debug('Check42 ' + Limits.getQueries());
                
      system.debug('Check42 ' + Limits.getLimitQueries()); 
    
     test.stoptest();
}       
}