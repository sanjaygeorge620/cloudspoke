@isTest(SeeAllData=true)
public class testDesign_Controller {
    public static testmethod void testDesign_Controller(){
    test.startTest();
        Design_Controller testInstance = new Design_Controller();
        Boolean retValue;
        testInstance.currentSprint = 'a0Yi0000000w5QpEAI';
        testInstance.SprintName = 'a0Yi0000000w5QpEAI';
        retValue = testInstance.getIsSelectedDesignDetails();
        testInstance.setIsSelectedDesignDetails(retValue);
        retValue = testInstance.getIsSelectedDesignComponent();
        testInstance.setIsSelectedDesignComponent(retValue);
        retValue = testInstance.getIsSelectedDesignname();
        testInstance.setIsSelectedDesignname(retValue);
        retValue = testInstance.getIsSelectedAcceptance();
        testInstance.setIsSelectedAcceptance(retValue);
        
        List<SelectOption> retList = new List<SelectOption>();
        retList = testInstance.getSprint();
        retList = testInstance.getStatus();
        PageReference tempRef;
        tempRef = testInstance.converTWord();
        tempRef = testInstance.redirectDesign();
        
        list<string> strList = new list<string>();
        strList = testInstance.getUserStory();
        
        map<string,Requirements__c> retMap = new map<string,Requirements__c>();
        retMap = testInstance.getUserStoryDesign2();
        
        map<string,UserStory2Design__c>retMap1 = new map<string,UserStory2Design__c>();
        retMap1 = testInstance.getUserStoryDesign();
        Apexpages.currentPage().getParameters().put('SprintName','a0Yi0000000w5QpEAI');
        Apexpages.currentPage().getParameters().put('StName','ALL');
        tempRef = testInstance.converTWord();
        tempRef = testInstance.redirectDesign();
        strList = testInstance.getUserStory();
        
        map<string,UserStory2Design__c> t = new map<string,UserStory2Design__c>();
        t = testInstance.getUserStoryDesign();
        retMap = testInstance.getUserStoryDesign2();
        
    test.stopTest();
    }
}