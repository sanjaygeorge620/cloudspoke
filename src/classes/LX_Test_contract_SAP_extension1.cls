/* Class Name : LX_Test_contract_SAP_extension1
 * Description : This test class is written to test LX_contract_SAP_extension CLass.
 * Created By : Maruthi kolla
 * Created Date : 11-05-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Maruthi Kolla      11-05-2013       1000                  Initial Version
 
 */
 
 @isTest(seeAlldata = true)
 private class LX_Test_contract_SAP_extension1{
 
 Public static List<pse__Proj__c> ps_projects = Data_Project.createProject(1);
 static testmethod void m1(){
 ApexPages.CurrentPage().getParameters().put('id',ps_projects[0].Id);
 Test.starttest();
 LX_contract_SAP_extension con_SAP_Proj = new LX_contract_SAP_extension ();
 //con_SAP_Proj.init();
 //Pagereference saveFun = con_SAP_Proj.save();
 Pagereference cancelFun = con_SAP_Proj.cancel();
 Test.stoptest();
 }
 
 }