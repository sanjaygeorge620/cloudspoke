@isTest
private class test_ContributeImageNow {

    static testMethod void test_ContributeImageNow() {
      
      String usrId = UserInfo.getUserId();
     
      User user = [select id, firstName, lastName, department from User where id = :UserInfo.getUserId()];
                
      contributeImageNowController  controller = new contributeImageNowController();
                           
                
      controller.contribute();
   
    }
}