/* 
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 08/07/2013
 *
 * Author : Kapil Reddy Sama.
 * 
 * Description : test class for LX_AccountDetailsExtension
*/

@isTest(seeAllData=true)
private class Test_LX_AccountDetailsExtension{
    public static Account acc;
    static testMethod void myUnitTest() {
        Test.startTest();        
        acc = data_Account.createAccount3(); 
        system.assertNotEquals(acc, Null);
        Test.setCurrentPage(Page.LX_accountDetails);   
        ApexPages.currentPage().getParameters().put('id',acc.id);          
        LX_AccountDetailsExtension controller = new LX_AccountDetailsExtension (new ApexPages.StandardController(acc) );
        controller.showMore();
        controller.showPagination();
        controller.showMore1();
        controller.showEnrollmentPagination();
        controller.next();
        controller.previous();
        controller.next1();
        controller.previous1();
        controller.cancel1();
    }
}