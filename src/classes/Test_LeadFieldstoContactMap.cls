/**
 * Name: Test_LeadFieldstoContactMap
 *
 * Description: to provide code coverage for LeadFieldstoContactMap trigger on Contact
 * Created By: Manoj Kolli
 * Created Date: 5/14/2012
 */
@isTest(seeAllData=true)
public class Test_LeadFieldstoContactMap{

    Public static testMethod void Test_LeadFieldstoContactMap() {
      
      Test.startTest();
      
        
     Contact con;  
     
     Set<String> userProfile = new Set<String>();
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      Profile prof = [Select id from Profile where name='System Administrator' limit 1];
      //ProfileIds.add('00e70000000yZmI');   
        ProfileIds.add(prof.Id);
      List<User> userList = Data_User.createUser(1, profileIds);       
     system.debug('userLIst in datacontact: ' + userList);
     String varAlias = string.valueof(system.currentTimeMillis());
     system.debug('varAlias' + varAlias);
     Integer aliaslength = varAlias.length();  
     integer u = 0;
     integer i = 0;
     system.runAs(userList[0])
     {
           Account acc = Data_Account.createAccount2();
         con = new Contact(
                           LastName='Test Contact '+i+varAlias.subString(aliaslength-2,aliaslength),
                           firstName='TestFirst',
                           AccountId = acc.Id,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email='test'+i+varAlias.subString(aliaslength-2,aliaslength)+'@gmail.com',
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           pse__Salesforce_User__c = userList[u].id,
                           Accounting_Contact__c = true,
                           pse__Is_Resource__c = true,
                           pse__Is_Resource_Active__c = true,
                           pse__Action_Update_Current_Time_Period__c = false,
                           Lead_AA_Name_Map__c = 'Test AA Name',
                           Lead_AA_Phone_Map__c = '999-999-9999',
                           phone='1234'+i,
                           Lx_Lexmark_Vertical__c = 'Manufacturing'
                           );
                           system.debug('new contact record: ' + con);
          
     insert con;
      }
      Test.stopTest();
    
    }
 }