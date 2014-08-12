/* Class Name : LX_Test_CreateImplementationProject
 * Description : This test class is written to test LX_CreateImplementationProject CLass.
 * Created By : Akanksha Gupta
 * Created Date : 10-29-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Akanksha Gupta       10-29-2013       1000                  Initial Version
 
 */
 
@isTest(seeAllData=true)
public class LX_Test_CreateImplementationProject{
      static testMethod void myUnitTest(){
           
            List<pse__proj__c> lstProj = Data_Project.createProject(1);
            ApexPages.StandardController sc = new ApexPages.StandardController(new pse__proj__c());
            ApexPages.currentPage().getParameters().put('oppId',lstProj[0].pse__opportunity__c);
            ApexPages.currentPage().getParameters().put('accID',lstProj[0].pse__Account__c); 
            ApexPages.currentPage().getParameters().put('projID',lstProj[0].Id);     
            LX_CreateImplementationProject obj = new LX_CreateImplementationProject(sc); 
            
        
      }
}