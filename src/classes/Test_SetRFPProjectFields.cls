/************************************************************************
Name      : Test_SetRFPProjectFields
Purpose   : Gives test coverage for SetRFPProjectFields.
Author    : Jennifer Dauernheim
Date      : May 10, 2010
************************************************************************/
@isTest
private class Test_SetRFPProjectFields {

    static testMethod void Test_SetRFPProjectFields() {
        // TO DO: implement unit test
        //create account
        
           
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
              List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1); 
               
        
        //create a project
        rfp_projects__c projectRec = new rfp_projects__c ();
        projectRec.opportunity__c = test_opportunities[0].id;
        insert projectRec;
        
        system.debug('opportunity id' + ([select opportunity__c from rfp_projects__c where id = :projectRec.ID]));
        system.debug('projectrec ID' + projectRec.Id);
        
        //system.assertEquals(test_opportunities[0].ownerid,
       // [select Account_Executive__c from rfp_projects__c where ID = :projectRec.ID limit 1].Account_Executive__c);

       // system.assertEquals(test_opportunities[0].SE__c,
       //[select Sales_Engineer__c from rfp_projects__c where ID = :projectRec.ID limit 1].Sales_Engineer__c);

       // system.assertEquals(test_opportunities[0].ISR__c,
       // [select Inside_Sales_Representative__c from rfp_projects__c where ID = :projectRec.ID limit 1].Inside_Sales_Representative__c);

        
        
    }
}