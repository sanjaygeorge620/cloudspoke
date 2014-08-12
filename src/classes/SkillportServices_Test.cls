@isTest
public with Sharing class SkillportServices_Test{
    
    
    static testmethod void testHappyPath(){
        //CreateData
        createEnvironmentVariables();

        //Pagereference should NOT have been redirected
        system.assert(null != SkillportServices.SinglePassUserCmd(UserInfo.getUserID(),'End-User','SkillSoft'));
    }    
    
    static testmethod void testSadPath(){
        //Pagereference should have been redirected
        system.assert(null == SkillportServices.SinglePassUserCmd(UserInfo.getUserID(),'End-User','SkillSoft'));
    }    
    
    
    private static void createEnvironmentVariables(){
        list<Environment_Variable__c> evs = new list<Environment_Variable__c>();
            evs.add(new Environment_Variable__c(name='skillport.endpoint.prod', value__c='endpoint'));
            evs.add(new Environment_Variable__c(name='skillport.endpoint.test', value__c='endpoint'));
            evs.add(new Environment_Variable__c(name='skillport.sharedsecret.prod', value__c='secret'));
            evs.add(new Environment_Variable__c(name='skillport.sharedsecret.test', value__c='secret'));
            evs.add(new Environment_Variable__c(name='skillport.adminusername.prod', value__c='username'));
            evs.add(new Environment_Variable__c(name='skillport.adminusername.test', value__c='username'));
            evs.add(new Environment_Variable__c(name='salesforce.com.OrgID', value__c=userinfo.getOrganizationId()));
        insert evs;   
    }

}