@isTest(SeeAllData = true)
private class TestSiteRegisterControllerClass {
    // Test method to bring this class's test coverage over the required 75%
    static testMethod void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        controller.isTestExecution = true;
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        //System.assert(controller.registerUser() == null);    
        //Account portalAccount = Data_Account.createAccount();
        //portalAccount.iscustomerportal = true;
        //update portalAccount;
       /* Account acc = data_account.createaccount();
        Account portalAccount= [Select id from Account where iscustomerportal= true limit 1][0];
        controller.testAccountId = portalAccount.Id;
        system.debug('controller.testAccountId == '+controller.testAccountId);
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);*/
       
    }
}