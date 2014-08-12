@isTest
private class LX_Test_ComponentControllerBase {
    static testMethod void myUnitTest() {
    
    ComponentControllerBase cc = new ComponentControllerBase(); 
    PageControllerBase pageController = new PageControllerBase(); 

 pageController.setComponentController(cc);
 pageController.setTaskComponentController(cc);
 pageController.setDescriptionComponentController(cc);
 pageController.setReminderComponentController(cc);
    }
   }