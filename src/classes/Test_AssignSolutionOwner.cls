/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class Test_AssignSolutionOwner {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
     
       
        Account acc = Data_Account.createAccount();
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);  
        List<Case> cases = createCaseTest(acc, contacts[0], 'Partner-Channel', 6);
        
        
        
        
        Integer iCount = 0;      
        List<Id> lstIds = new List<Id>();
         Test.startTest();
        for(Case obj : cases)
        {
            if(iCount == 0)obj.Status = '03. Quote Submitted';
            if(iCount == 1)obj.Status = '05. Development – Assigned';
            if(iCount == 2) obj.Status = '08. QA – Ready to Assign';
            if(iCount == 3) obj.Status = '09. QA – In Progress';
            if(iCount == 4) obj.Status = '10. Implementation – Ready for Install';
            if(iCount == 5) {
            obj.Status = '12. On Hold';
            obj.Solution_Developer__c = userInfo.getUserId();
            }
            icount++;
            lstIds.add(obj.Id);
            
            
        }
        
        system.debug( 'Cases ==='+cases);
        update cases;
        AssignSolutionOwner.AssignSolutionOwnerName(lstIds);
        //LX_AssignSolutionOwner obj1  = new LX_AssignSolutionOwner();
        //obj1.AssignSolutionOwnerName(cases);
        
        Test.stopTest();
    }
    
    public static List<Case> createCaseTest(Account acc, Contact con, string RecordTypeName, integer Size){    
     
     //get recordtype id
     Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
     Id recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
     
     //list for cases    
     List<Case> cases= new List<Case>();    
     
     integer u = 0;
     for(Integer i =0; i<size; i++){        
          Case newcase = New Case();
          newcase.Account = acc;
          newcase.Contact = con;
          
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
  public static List<Case> createCase2Test(Account Account, Contact Contact, string RecordTypeName, integer Size){    
  //   Account acc = Data_Account.createAccount(); 
  //   List<Contact> contacts = Data_Contact.createContacts2(acc.Id,1); 
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
  
}