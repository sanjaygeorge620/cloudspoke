/* Class Name : LX_Test_AccountTriggerUtil
 * Description : This test class is written to test LX_AccountTriggerUtil CLass.
 * Created By : Abhishek Jain 
 * Created Date : 6-4-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Abhishek Jain        6-4-2013                        Initial Version
 * Srinivas Pinnamaneni 6-9-2013 
 * Kapil Reddy Sama     8-14-2013                       Migrated to QA
 */

@isTest(seealldata= true)
public class LX_Test_AccountTriggerUtil{ 

/*Description:This is the test method written to provide test account data for updating Account Address
*Param:None
*Returns:VOID
*/ 

    public Static  TestMethod void UpdateAccountAddress(){
        List<Account> LX_AccountList = new List<Account>();
        Account acc = Data_Account.createAccount3();
        acc.BillingStreet = '123 Street';
        acc.Physical_Street_Address__c = 'TestStreet';
        acc.BillingCity = 'TestCity';
        acc.Physical_City__c = 'TestCity1';
        acc.BillingState = 'CA';
        acc.Physical_Province_Other__c = 'CA1';
        acc.BillingCountry = 'Canada';
        acc.Physical_Country__c = 'Canada';
        acc.BillingPostalCode = '12345';
        acc.Physical_Postal_Code__c = '54321';
        update acc;
        LX_AccountList.add(acc);
        LX_AccountTriggerUtil ObjAccountTriggerUtil = new LX_AccountTriggerUtil();
        ObjAccountTriggerUtil.updateAccountAddress(LX_AccountList); 
    }
    
/*Description:This is the test method written to test Delete Action Plan scenario.
*Param:None
*Returns:VOID
*/

    public Static TestMethod void DeleteActionPlan(){
        List<Account> LX_AccountList = new List<Account>();
        ActionPlan__c ActionPlan = new ActionPlan__c();
        Account acc = Data_Account.createAccount3();
        LX_AccountList.add(acc);      
        ActionPlan.Name = 'TestPlan';
        ActionPlan.Account__c = acc.id;
        insert ActionPlan;
        delete ActionPlan;
        LX_AccountTriggerUtil ObjAccountTriggerUtil = new LX_AccountTriggerUtil();
        ObjAccountTriggerUtil.accountActionPlanDelete(LX_AccountList);               
    }
}