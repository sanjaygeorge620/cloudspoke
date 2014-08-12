/**
 * Name: Test_PopulateFlexeraAccount
 *
 * Description: to provide code coverage for PopulateFlexeraAccount Trigger
 *
 * Created Date: 2/2/2012
 * Created By: Manoj Kolli
 */
@isTest(seeAlldata=true)
private class Test_PopulateFlexeraAccount {

    static testMethod void Test_PopulateFlexeraAccount() {
      
      Test.startTest();
      
    Account acc = Data_Account.createAccount3();
     
    Account acc1 = Data_Account.createAccount3(); 
      acc1.Name='Account4TestMethod1';
      Update acc1 ;
      
      Test.stopTest(); 
           
    }
}