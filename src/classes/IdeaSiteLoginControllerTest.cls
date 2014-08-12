@isTest
private class IdeaSiteLoginControllerTest {

    static testMethod void testGettersSetters() {
        Profile adminProfile = [select id from profile where name ='System Administrator' limit 1]; 
        User adminUser = new User(alias = '1qa', email='cstandarduser@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id, communityNickname='test123',
        timezonesidkey='America/Los_Angeles', username='Checking@lexmark.com',LX_region__c = 'NE',Legacy_Company__c='Lexmark');
        Insert adminUser;
        IdeaSiteLoginController controller = new IdeaSiteLoginController();
        String username = 'abc' + Crypto.getRandomInteger();
        controller.setUsername('test');
        controller.setPassword('abcdefg123456');

        System.assertEquals(controller.getPassword(), 'abcdefg123456');
        System.assertEquals(controller.getUsername(), 'test');     
        controller.login();       
    }
}