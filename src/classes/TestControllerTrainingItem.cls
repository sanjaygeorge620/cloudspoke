/**************************************************************************
Name    : TestControllerTrainingItem
Author  : Kirtesh Jain
Date    : 02 July, 2009
Usage   : used to Test ControllerTrainingItem.cls 

****************************************************************************/

@isTest
private class TestControllerTrainingItem {

    static testMethod void testControllerTrainingItem() {
        
        Test.setCurrentPageReference(new PageReference('Page.TrainingInfo'));
        
        ControllerTrainingItem extensioncontroller = new ControllerTrainingItem() ;
        extensioncontroller.getInfoItems1();
        extensioncontroller.getInfoItems2();
        extensioncontroller.getInfoItems3();
        extensioncontroller.getInfoItems4();
        extensioncontroller.getShowItems1();
        extensioncontroller.getShowItems2();
        extensioncontroller.getShowItems3();
        extensioncontroller.getShowItems4();
        
        Training_Info_Item__c parentTrainingInfoItem = new Training_Info_Item__c();
        insert parentTrainingInfoItem ;
        
        List<Training_Info_Item__c> listchildTraningInfoITems = new List<Training_Info_Item__c>();
        
        for( Integer i = 0 ; i < 3 ; i++){
          Training_Info_Item__c childTrainingInfoItem = new Training_Info_Item__c();
          childTrainingInfoItem.Parent_Training_Info_Item__c = parentTrainingInfoItem.Id ;
          listchildTraningInfoITems.add( childTrainingInfoItem ) ;
        }
        
        insert listchildTraningInfoITems ;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(parentTrainingInfoItem); 
        ControllerTrainingItem extensionstdController = new ControllerTrainingItem(sc);  
        
        System.AssertEquals( extensionstdController.getChildInfoItems().size() , 3 ) ;
     }
}