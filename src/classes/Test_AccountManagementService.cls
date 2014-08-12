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
@isTest
private class Test_AccountManagementService {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        AccountManagementService.AccountServiceResponse obj = new AccountManagementService.AccountServiceResponse();
        AccountManagementService.DisableResponse_element obj1 = new AccountManagementService.DisableResponse_element();
        AccountManagementService.Disable_element obj2 = new AccountManagementService.Disable_element();
        AccountManagementService.Enable_element obj3 = new AccountManagementService.Enable_element();
        AccountManagementService.ArrayOfString obj4 = new AccountManagementService.ArrayOfString();
        AccountManagementService.UserAccount obj5 = new AccountManagementService.UserAccount();
        AccountManagementService.EnableResponse_element obj6 = new AccountManagementService.EnableResponse_element();
        AccountManagementService.SetAsMaster_element obj7 = new AccountManagementService.SetAsMaster_element();
        AccountManagementService.SetAsMasterResponse_element obj8 = new AccountManagementService.SetAsMasterResponse_element();
                  
        
    }
}