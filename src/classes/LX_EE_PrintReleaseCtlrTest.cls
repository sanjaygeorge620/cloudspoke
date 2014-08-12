/* Class Name : LX_EE_PrintReleaseCtlrTest
* Description : This test class is written to test LX_EE_PrintReleaseCtlr CLass.
* Created By : Sunil Kati
* Created Date : 11-27-2013 
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer            Date       Modification ID       Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sunil Kati      11-27-2013       1000                  Initial Version

*/

@isTest(seealldata=true)
private class LX_EE_PrintReleaseCtlrTest
{
    
    static testmethod void m1()
    { 
        test.starttest();
        user u = [select ID , Legacy_Company__c from user where ID = :UserInfo.getUserId()];
        u.Legacy_Company__c = 'Lexmark';
        update u;
        
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        Account acct = Data_Account.createAccount3();  
        
        
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
        
         Map<String,STAR_Easy_Estimate__c> mcs = STAR_Easy_Estimate__c.getall();
     
         List<STAR_Easy_Estimate__c> list_of_data = new List<STAR_Easy_Estimate__c>();
         
         if(mcs.get('PR_Between100and199')==null)
         {
         STAR_Easy_Estimate__c easy_estimate_data = new STAR_Easy_Estimate__c();
         easy_estimate_data.Name='PR_Between100and199';
         easy_estimate_data.DocAccounting_Licensing__c = 50;
         easy_estimate_data.Installation__c=100;
         easy_estimate_data.Project_Management__c=100;
         easy_estimate_data.MobilePrint_Licensing__c=200;
         easy_estimate_data.PrintRelease_Licensing__c=200;
         easy_estimate_data.Travel__c=250;
         list_of_data.add(easy_estimate_data);
         }
         
         if(mcs.get('PR_Between200and250')==null)
         {
         STAR_Easy_Estimate__c easy_estimate_data2 = new STAR_Easy_Estimate__c();
         easy_estimate_data2.Name='PR_Between200and250';
         easy_estimate_data2.DocAccounting_Licensing__c = 100;
         easy_estimate_data2.Installation__c=200;
         easy_estimate_data2.Project_Management__c=200;
         easy_estimate_data2.MobilePrint_Licensing__c=300;
         easy_estimate_data2.PrintRelease_Licensing__c=300;
         easy_estimate_data2.Travel__c=400;
         list_of_data.add(easy_estimate_data2);
         }
         
         if(mcs.get('PR_Between251and499')==null)
         {
         STAR_Easy_Estimate__c easy_estimate_data3 = new STAR_Easy_Estimate__c();
         easy_estimate_data3.Name='PR_Between251and499';
         easy_estimate_data3.DocAccounting_Licensing__c = 500;
         easy_estimate_data3.Installation__c=1000;
         easy_estimate_data3.Project_Management__c=1000;
         easy_estimate_data3.MobilePrint_Licensing__c=2000;
         easy_estimate_data3.PrintRelease_Licensing__c=2000;
         easy_estimate_data3.Travel__c=3000;
         list_of_data.add(easy_estimate_data3);
         }
     
          if(mcs.get('PR_Between500and1000')==null)
         {
         STAR_Easy_Estimate__c easy_estimate_data4 = new STAR_Easy_Estimate__c();
         easy_estimate_data4.Name='PR_Between500and1000';
         easy_estimate_data4.DocAccounting_Licensing__c = 1000;
         easy_estimate_data4.Installation__c=2000;
         easy_estimate_data4.Project_Management__c=2000;
         easy_estimate_data4.MobilePrint_Licensing__c=3000;
         easy_estimate_data4.PrintRelease_Licensing__c=3000;
         easy_estimate_data4.Travel__c=4000;
         list_of_data.add(easy_estimate_data4);
         }
         
          if(mcs.get('PR_Between51And99')==null)
         {
         STAR_Easy_Estimate__c easy_estimate_data5 = new STAR_Easy_Estimate__c();
         easy_estimate_data5.Name='PR_Between51And99';
         easy_estimate_data5.DocAccounting_Licensing__c = 10;
         easy_estimate_data5.Installation__c=30;
         easy_estimate_data5.Project_Management__c=30;
         easy_estimate_data5.MobilePrint_Licensing__c=50;
         easy_estimate_data5.PrintRelease_Licensing__c=50;
         easy_estimate_data5.Travel__c=40;
         list_of_data.add(easy_estimate_data5);
         }
         
          if(mcs.get('PR_Lessthan50')==null)
         {
         STAR_Easy_Estimate__c easy_estimate_data6 = new STAR_Easy_Estimate__c();
         easy_estimate_data6.Name='PR_Lessthan50';
         easy_estimate_data6.DocAccounting_Licensing__c = 10;
         easy_estimate_data6.Installation__c=20;
         easy_estimate_data6.Project_Management__c=20;
         easy_estimate_data6.MobilePrint_Licensing__c=30;
         easy_estimate_data6.PrintRelease_Licensing__c=30;
         easy_estimate_data6.Travel__c=40;
         list_of_data.add(easy_estimate_data6);
         }
        
         if(list_of_data.size()>0)
         insert list_of_data;
     
        STAR__c s1 = new STAR__c();
       
        
        Apexpages.Standardcontroller cont1 = new Apexpages.Standardcontroller(s1 );
        Pagereference pg1 = Page.LX_EE_PrintRelease;
        pg1.getParameters().put('oppID',op.id);
        
        Test.setCurrentPage(pg1);        
        LX_EE_PrintReleaseCtlr vcon= new LX_EE_PrintReleaseCtlr(cont1);
        
        vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 50; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
          vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 5; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
         vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 90; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
          vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 110; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
        
        vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 190; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
         vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 220; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
         vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 300; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
         vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 600; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
          
        vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 600; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
          
        vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 1200; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
         vcon.PSObj.LX_Conversion_Rate__c = 2; 
        vcon.PSObj.LX_Number_of_devices__c = 2200; 
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
        
        
        vcon.PSObj.LX_Conversion_Rate__c = 0; 
        vcon.PSObj.LX_Number_of_devices__c = 3000; 
        vcon.PSObj.LX_Document_accounting_required__c = LX_PSEHelperClass.YES_Const;
        vcon.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
        vcon.Calculations();
        vcon.GenerateDoc();
           
        LX_EE_PrintReleaseCtlr vcon1= new LX_EE_PrintReleaseCtlr(cont1); 
        vcon1.Calculations();
        vcon1.GenerateDoc();
        vcon1.PSObj.LX_Conversion_Rate__c = 2; 
        vcon1.PSObj.LX_Number_of_devices__c = 20; 
        vcon1.Calculations();
        vcon1.GenerateDoc();
        
        test.stoptest();
    }
   
}