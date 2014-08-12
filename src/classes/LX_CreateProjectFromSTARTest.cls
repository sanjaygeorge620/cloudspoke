/* Class Name : LX_CreateProjectFromSTARTest
 * Description : This test class is written to test  LX_CreateProjectFromSTAR.
 * Created By : Sunil kati
 * Created Date : 11-27-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Sunil Kati       11-27-2013       1000                  Initial Version
 
 */

@isTest(seealldata=true)
private class LX_CreateProjectFromSTARTest
{
    static testmethod void m1()
    {
      /*  Account acct = new Account();
        acct .name = 'TestAC';
        acct .LX_Country_Code__c = 'IN';
        acct .Physical_Country__c = 'India';
        acct .LXK_Region__c = 'India';
        acct .LX_Geo__c = 'Asia Pacific';
        acct .PSW_Sales_Region__c = 'APAC'; 
        
        acct = Data_Account.createAccount();  
        insert acct ;
        */
        
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        Account acct = Data_Account.createAccount3();  
        //insert acct;
        
        /*   
        List<Contact> contacts = Data_Contact.createContacts(acct.Id,1);
        Contact cont = contacts[0];

        List<Opportunity> test_opportunities3 = Data_Opportunity.createOpportunity3(stageList,3,acct,contacts);  
        insert test_opportunities3 ;
           */  
           
        Opportunity op = new Opportunity();
        op.AccountId = acct.id;
        op.name = 'test op';
        op.CloseDate = System.Today()+30;
        op.amount = 2345;
        op.StageName = 'Qualifying';
        op.Sector__c = 'Education';
        op.ForecastCategoryName = 'Pipeline';
        op.Next_Steps__c = 'test step';
        insert op;
        
        
        STAR__c s1 = new STAR__c();
        s1.name = 'Test Star';
        s1.Account__c = acct .id;
        s1.Opportunity__c  = op.id;    
        Insert s1;
        
        Apexpages.currentPage().getparameters().put('starID',s1.id);
        LX_pse_recordtypeSelection pse_recordselection = new LX_pse_recordtypeSelection();
        //pse_recordselection.Star_ID = s1.id;
        pse_recordselection.recordtypes='Assessment';
        pagereference pg1 = pse_recordselection.continueToRequest();
        LX_CreateProjectFromSTAR.create_PresalesProj(s1.id);
        pagereference pg = pse_recordselection.CancelURL();
        LX_CreateProjectFromSTAR.populate_TimeZone('Chatham');
        pse_recordselection.populate_TimeZone('Chatham');
        
    
    }
}