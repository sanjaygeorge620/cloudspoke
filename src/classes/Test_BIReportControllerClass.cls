@isTest(SeeAllData=true)
public class Test_BIReportControllerClass{

     public static testmethod void testBIReportUI(){
     
    User martinCanningUser = [Select id from User where name = 'Martin Canning'];
    User ronBinkauskasUser = [Select id from User where name = 'Ron Binkauskas']; 
    
    System.runAS(martinCanningUser){
      BIReportsController reportController = new BIReportsController();
      reportController.selectedDashboard = 'Revenue Summary';
      reportController.displayReport();
      reportController.selectedDashboard = 'Monday Morning';
      reportController.displayReport();
    }
    
    System.runAS(ronBinkauskasUser){
      BIReportsController reportController = new BIReportsController();
      reportController.selectedDashboard = 'Revenue Summary';
      reportController.displayReport();
      reportController.selectedDashboard = 'Monday Morning';
      reportController.displayReport();
    }
    
    }
}