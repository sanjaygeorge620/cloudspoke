@isTest

private class Test_Employee_Referral_Approval
{
Static Testmethod void test_single()
{

  
  
  Account aa = Data_Account.createAccount();
  
  list<Contact> testCon = Data_Contact.createContacts(aa.id,1);
  
  test.starttest();
  
  Employee_Referral__c emp = new Employee_Referral__c (Submitted_By__c = testCon[0].ID,
  First_Name__c = 'Test',
  Last_Name__c = 'Testlast',
  Email__c = 'test@perceptivesoftware.com',
  Phone__c = '878676786',
  Current_Employer__c = 'Honda');
  
  insert emp;
  
    List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :emp.id];
    //VT 8/25 COmmented System.assertEquals(processInstances.size(),1);

test.stoptest();

}

Static Testmethod void test_bulk()
{

  
  
  Account aa = Data_Account.createAccount();
  
  list<Contact> testCon = Data_Contact.createContacts(aa.id,1);
  
  list<Employee_Referral__c> empl = new list<Employee_Referral__c>();
  test.starttest();
  
  for(integer i=0;i<100;i++)
  {
  Employee_Referral__c emp = new Employee_Referral__c (Submitted_By__c = testCon[0].ID,
  First_Name__c = 'Test',
  Last_Name__c = 'Testlast',
  Email__c = 'test@perceptivesoftware.com',
  Phone__c = '878676786',
  Current_Employer__c = 'Honda');
  empl.add(emp);
  }
  
  
  insert empl;
  
    List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :empl];
    //VT 8/25 Commented System.assertEquals(processInstances.size(),100);

test.stoptest();

}




}