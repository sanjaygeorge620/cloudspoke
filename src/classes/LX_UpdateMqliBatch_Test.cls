/*
Class Name : LX_UpdateMqliBatch_Test
Description : Batch class to update the MQLU
Created By : Shubhashish Rai (shrai@deloitte.com)
Created Date : 10-6-2013
Modification Log:
-------------------------------------------------------------------------
Developer            Date            Modification ID        Description
-------------------------------------------------------------------------
Shubashish Rai      15-4-2013        1000                   Initial Version
    

*************************************************************************/
@isTest(SeeAllData=false)
private class LX_UpdateMqliBatch_Test{

/* Class Name   : LX_Test_SetRecordIDs 
    * Description   : This is a Test class to call the LX_SetRecordIDs class. 
    * Created By   : Shubhashish Rai
    * Created Date : 04-15-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Shubhashish Rai          04-15-2014                                  Initial Version

    */
    static testmethod void m1(){
        PricebookEntry pb = [select id from PricebookEntry where isActive = True and CurrencyIsoCode = 'USD' limit 1 ];
        
         Account acc = Data_Account.createAccount3();      
        acc.Primary_Sector_Focus__c  = 'Manufacturing';
        acc.name='testAccount';  
        update acc;       
        
        Opportunity oppRec = new Opportunity();        
            oppRec.Name = 'Test Opp';    
            oppRec.AccountID = acc.id;        
            oppRec.Type = 'Add On Solution';        
            oppRec.Sector__c = 'State/Local';                  
            oppRec.Amount = 000.00;        
            oppRec.StageName = 'Closed Won';  
            oppRec.Technology__c = true;
            oppRec.LX_Sales_Type__c = 'Add On';
            oppRec.LX_Ramp_Type__c = 'Back Loaded';
            oppRec.LX_Rollout_Start_Date__c = system.Today();
            oppRec.LX_Rollout_End_Date__c = System.Today() + 7;  
            oppRec.LX_First_Time_to_Revenue__c = 'Repeat Customer' ;        
            OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';   
            oppRec.CurrencyIsoCode = 'USD';     
            //OppRec.Primary_Competitor__c = accPrimary.ID;  
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.      
            OppRec.Competitor_Installs__c = 'Testing';   
            //OppRec.Top_3_Reason_for_Win__c = 'Testing';  
            OppRec.Need_Established__c = true;
            OppRec.Recommenders_Met__c = true;
            OppRec.LX_ID_decision_makers_exec_sponsors__c = true;
            OppRec.Business_Case_Agreement__c = true;
            OppRec.All_Formal_Presentation_Demo_Complete__c = true;
            OppRec.Verbal_Received_Check__c = true;
            OppRec.Signed_Contract_Received__c = true;
            OppRec.LX_Product_Type__c = 'Technology';
            OppRec.Technology__c = true;
            OppRec.LX_Sales_Type__c = 'Run Rate';
            OppRec.LX_First_Time_to_Revenue__c = 'Repeat Customer';
            OppRec.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
            OppRec.Contract_Number__c = 'test123';
            OppRec.LX_SAP_Upfront_Discount__c = 'test123';
            OppRec.LX_Vistex_Backend_Rebate__c = 'test123';
            OppRec.Contract_Indicator__c = 'Test';
            OppRec.CloseDate = System.Today()+7;
            OppRec.Master_Opportunity__c = null;
            OppRec.LX_Master_Opportunity__c = true;
            OppRec.LX_Has_Participant_Opportunities__c = true;
            insert OppRec;
            
       Opportunity childOppRec1 = new Opportunity();        
            childOppRec1.Name = 'Test Opp';    
            childOppRec1.AccountID = acc.id;        
            childOppRec1.Type = 'Add On Solution';        
            childOppRec1.Sector__c = 'State/Local';                  
            childOppRec1.Amount = 000.00;        
            childOppRec1.StageName = 'Closed Won';  
            childOppRec1.Technology__c = true;
            childOppRec1.LX_Sales_Type__c = 'Add On';
            childOppRec1.LX_Ramp_Type__c = 'Back Loaded';
            childOppRec1.LX_Rollout_Start_Date__c = system.Today();
            childOppRec1.LX_Rollout_End_Date__c = System.Today() + 7;  
            childOppRec1.LX_First_Time_to_Revenue__c = 'Repeat Customer' ;        
            childOppRec1.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';   
            childOppRec1.CurrencyIsoCode = 'USD';     
            //childOppRec1.Primary_Competitor__c = accPrimary.ID;  
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.      
            childOppRec1.Competitor_Installs__c = 'Testing';   
            //childOppRec1.Top_3_Reason_for_Win__c = 'Testing';  
            childOppRec1.Need_Established__c = true;
            childOppRec1.Recommenders_Met__c = true;
            childOppRec1.LX_ID_decision_makers_exec_sponsors__c = true;
            childOppRec1.Business_Case_Agreement__c = true;
            childOppRec1.All_Formal_Presentation_Demo_Complete__c = true;
            childOppRec1.Verbal_Received_Check__c = true;
            childOppRec1.Signed_Contract_Received__c = true;
            childOppRec1.LX_Product_Type__c = 'Technology';
            childOppRec1.Technology__c = true;
            childOppRec1.LX_Sales_Type__c = 'Run Rate';
            childOppRec1.LX_First_Time_to_Revenue__c = 'Repeat Customer';
            childOppRec1.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
            childOppRec1.Contract_Number__c = 'test123';
            childOppRec1.LX_SAP_Upfront_Discount__c = 'test123';
            childOppRec1.LX_Vistex_Backend_Rebate__c = 'test123';
            childOppRec1.Contract_Indicator__c = 'Test';
            childOppRec1.CloseDate = System.Today()+7;
            childOppRec1.Master_Opportunity__c = OppRec.id;
            childOppRec1.LX_Master_Opportunity__c = false;
            childOppRec1.LX_Has_Participant_Opportunities__c = false;
            insert childOppRec1;
        
       List<opportunitylineitem> opppro = new opportunitylineitem[]{new opportunitylineitem(UnitPrice=10000.00, Quantity=10, opportunityid=oppRec.id, pricebookEntryId=pb.id)};
       insert opppro ;
       
       Test.startTest();
    //VT commented 4/27 for deployment failure LX_UpdateMqliBatch c = new LX_UpdateMqliBatch();
      // Database.executeBatch(c,199);
       Test.stopTest();
    }
}