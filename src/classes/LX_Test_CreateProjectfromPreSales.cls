/* Class Name : LX_Test_CreateProjectfromPreSales 
 * Description : This test class is written to test LX_CreateProjectfromPreSales CLass.
 * Created By : Akanksha Gupta
 * Created Date : 10-29-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Akanksha Gupta       10-29-2013       1000                  Initial Version
 
 */
 
 @isTest(seeAlldata = true)
private class LX_Test_CreateProjectfromPreSales {
     static testmethod void m1(){
        List<pse__proj__C> lstProj = Data_Project.createProject(1);
        ApexPages.CurrentPage().getParameters().put('projID',lstProj[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lstProj[0]);
        LX_CreateProjectfromPreSales obj = new LX_CreateProjectfromPreSales(sc);
        obj.recordType='Database Services';
        obj.continueToProject();
        obj.recordType='MS Upgrades';
        obj.continueToProject();
        obj.recordType='Professional Services';
        obj.continueToProject();
        obj.recordType='ISS Implementation';
        obj.continueToProject();
        obj.recordType='MS Implementation';
        obj.continueToProject();
        
    }
}