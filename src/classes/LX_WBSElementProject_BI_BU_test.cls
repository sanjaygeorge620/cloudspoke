/*
Class Name : LX_WBSElementProject_BI_BU_test
Description : Test Class for LX_WBSElementProject_BI_BU.
Created By : Maruthi kolla 
Created Date : 2-5-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Maruthi kolla  2-5-2013        1000                 Initial Version
*************************************************************************/
@isTest(seealldata = true)
public class LX_WBSElementProject_BI_BU_test{

   public static testmethod void m1(){
   
   Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
       
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;

         WBS_Element__c wbs_ele = new WBS_Element__c(name='Testing');
         insert wbs_ele ;
         
         WBS_Element_Project__c wbs_ele_proj = new WBS_Element_Project__c(WBS_Element__c = wbs_ele.id , Opportunity__c = opp.id);
         insert  wbs_ele_proj;
         
      
       
    }
    

}