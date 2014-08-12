/* 
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 07/09/2013
 *
 * Author : Rahul Raghunathan
 * 
 * Description : test class for rfpProjectItem_Ship .
*/
@isTest(seealldata= true)
public class Test_LX_rfpProjectItem_Ship  {
    public static rfp_projects__c rfpProject;
    public static list<string> stages = new list<string>();
    public static Opportunity rfpOpp ;
    
    static testMethod void setUpData(){
        stages.add('Qualifying');
        rfpOpp = LX_TestData.createOpportunity();
        rfpProject = new rfp_projects__c();
        rfpProject.Opportunity__c = rfpOpp.id;
        rfpProject.RFP_Ship_Date_and_Time__c = system.today();
        rfpProject.RFP_Due_Date_and_Time__c = system.today();
        insert rfpProject;
        
        // Create an instance of the rfpProjectItem_Ship  class and call the constructor
        rfpProjectItem_Ship testData = new rfpProjectItem_Ship (rfpProject);
        rfpProject = testData.getEv();
        string formatteddata = testData.getFormatedDate();
        system.assertNotEquals(testData.FormatedDate, null);
        
        // create an instance of the rfpProjectItem  class
        rfpProjectItem  test2Data = new rfpProjectItem (rfpProject);
        rfpProject = test2Data.getEv();
        formatteddata = test2Data.getFormatedDate();
        system.assertNotEquals(formatteddata , null);
        
    }

}