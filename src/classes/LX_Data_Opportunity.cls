/*
Class Name : LX_Data_Opportunity 
Description : -Test class for creating data in the Opportunity triggers.
Created By : Kapil Sama(ksamadeloitte.com)
Created Date : 01-07-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Kapil Sama     01-07-2013        1000                   Initial Version
*************************************************************************/
@isTest
public class LX_Data_Opportunity {   
    
    public static Opportunity optyRec;

/*   Description: This method create a opportunity in the qualifying stage
     Param - No Parameters
     Returns - Void
 */
    
    public static void testData() {
        Account acc;
       Opportunity opp;
        list<Opportunity> oppList = new list<Opportunity>();
        acc = Data_Account.createAccount3();
       // acc = new Account(name = 'Test Opportunity Trigger');   
        //insert acc;
        
            opp = new Opportunity(StageName = 'Qualifying' ,
                                  CloseDate = System.today(),
                                  Name = 'opportunityName',
                                  AccountId = acc.id,
                                  LX_Sales_Type__c ='Add On',Technology__c = true,
                                  LX_First_Time_to_Revenue__c = 'Repeat Customer');
            oppList.add(opp);
        
        
        insert oppList;     
        optyRec = oppList[0];
    }
}