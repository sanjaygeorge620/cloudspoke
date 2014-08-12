/* Class Name : LX_Test_PSE_PreSalesToImplementation
 * Description : This test class is written to test LX_PSE_PreSalesToImplementation CLass.
 * Created By : Maruthi kolla
 * Created Date : 11-05-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Maruthi Kolla      11-05-2013       1000                  Initial Version
 
 */
 @isTest(seeAlldata = true)
 private class LX_Test_PSE_PreSalesToImplementation{
 
 
 static testmethod void m1(){
List<pse__Proj__c> ps_projects = Data_Project.createProject(1);
//List<pse__Proj__c> ps_imp = Data_Project.createProject(1);


Note nt = new Note();
nt.title = 'Testing';
nt.parentid = ps_projects[0].id ; 
insert nt;

Test.starttest();

Recordtype presales_proj = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'pre_sales'];
Recordtype imp_proj = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'Implementation_Project'];


List<pse__Proj__c> pj1 = ps_projects.deepclone();
pj1[0].recordtypeid = presales_proj.id;
insert pj1;

List<pse__Proj__c> pj_imp = ps_projects.deepclone();
pj_imp[0].recordtypeid = imp_proj.id;
pj_imp[0].pre_sales_project_name__C = pj1[0].id;
insert pj_imp;

Test.stoptest();
 }
 
 }