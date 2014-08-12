@isTest
private class LX_Test_PageControllerBase {
    static testMethod void myUnitTest() {
           
         Test.startTest();
             PageControllerBase Pb = new PageControllerBase ();
             pb.getThis();
             pb.getMyComponentController();
             pb.getmyTaskComponentController();
             pb.getmyReminderComponentController();
             pb.getmyDescriptionComponentController();
             
             ComponentControllerBase compBase = pb.getMyComponentController();
             pb.setTaskComponentController(compBase);
             pb.setComponentController(compBase);
             pb.setReminderComponentController(compBase);
             pb.setDescriptionComponentController(compBase);
            
         Test.stopTest();
    }
   }