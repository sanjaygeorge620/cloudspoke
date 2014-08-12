/* Class Name : LX_Test_AccountContactOptOut
 * Description : This test class is written to test trigger LX_UpdateContactOptedOut.
 * Created By : Abhishek Jain(Deloitte)
 * Created Date : 6-4-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Abhishek Jain        6-4-2013                        Initial Version                        Initial Version
 * Srinivas Pinnamaneni 6-9-2013 
 * Kapil Reddy Sama     8-14-2013                       Migrated to QA
 */

@isTest(seeAlldata =true)
public class LX_Test_AccountContactOptOut{ 

/*Description:This method is written to update account Do Not Call field
*Param:None
*Returns:VOID
*/ 

    public Static  TestMethod void UpdateAccountDoNotCall(){
        Account acc = Data_Account.createAccount3();
        //insert acc;
        acc.LX_Do_Not_Call__c = true;
        update acc;
    }

/*Description:This method is written to update account Email Opt Out field
*Param:None
*Returns:VOID
*/ 

    public Static TestMethod void UpdateAccountEmailOptOut(){
        Account acc = Data_Account.createAccount3();
        //insert acc;
        acc.LX_Email_Opt_Out__c = true;
        update acc;  
    }
    
/*Description:This method is written to update account Opt Out Early Pipeline field
*Param:None
*Returns:VOID
*/ 

    public Static TestMethod void UpdateAccountOptOutEarlyPipeline(){
         Account acc = Data_Account.createAccount3();
        //insert acc;
        acc.LX_Opt_Out_Early_Pipeline__c = true;
        update acc;  
    }
}