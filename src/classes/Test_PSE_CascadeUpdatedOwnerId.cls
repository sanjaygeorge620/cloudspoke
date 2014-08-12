/******************************************************************
Class Name   : TestPSE_CascadeUpdatedOwnerId
Created by   : Appirio
Created Date : December 11, 2009
Purpose      : Test the PSE_CascadeUpdatedOwnerId trigger on the 
               pse__Proj__c update trigger
********************************************************************/
@isTest
private class Test_PSE_CascadeUpdatedOwnerId {

    static testMethod void Test_PSE_CascadeUpdatedOwnerId()  {
        //prepare test data
        //fetching users
        List<User> userList = [select id, Name from User where profile.Name = 'System Administrator' and isActive = true LIMIT 2];
        
        system.runAs(userList[0])
        {
            List<pse__Proj__c> Projects = Data_Project.createProject(1); 
            pse__Proj__c project = Projects[0];            
            
            Test.startTest(); 
            
            //create pse__Miscellaneous_Adjustment__c
            pse__Miscellaneous_Adjustment__c pseMiscAdj = new pse__Miscellaneous_Adjustment__c(Name='test');
            pseMiscAdj.pse__Transaction_Category__c = 'Revenue';
            pseMiscAdj.pse__Effective_Date__c = System.today();
            pseMiscAdj.pse__Amount__c = 100;
            pseMiscAdj.CurrencyIsoCode = 'USD';
            pseMiscAdj.pse__Project__c = project.ID;
            pseMiscAdj.Product_Line__c='ISS';
            insert pseMiscAdj;
            
            //create pse__Milestone__c
            pse__Milestone__c pseMile = new pse__Milestone__c(Name='test');
            pseMile.CurrencyIsoCode = 'USD';
            pseMile.pse__Target_Date__c = System.today();
            pseMile.pse__Milestone_Amount__c = 100;
            pseMile.pse__Project__c = project.ID;
            insert pseMile;
            
            

            //updating the project for code coverage of trigger TestUpdateOwnerProjectAfterUpdate
            project.Name = 'test1';
            project.Product_Line_s__c ='ISS';
            String ownId = '';
            if(userList != null && userList.size()>1) {
                project.OwnerId = userList[1].ID;
                ownId = project.OwnerId;
            }
            update project;
            
            List<pse__Milestone__c> pseMileLst = [select id, OwnerId from pse__Milestone__c where pse__Project__c =: project.Id LIMIT 1];
            List<pse__Miscellaneous_Adjustment__c> pseMiscAdjLst = [select id, OwnerId from pse__Miscellaneous_Adjustment__c where pse__Project__c =: project.Id LIMIT 1];        
            //System.assertEquals(ownId, pseMileLst[0].OwnerId);
            //System.assertEquals(ownId, pseMiscAdjLst[0].OwnerId);
                    
            Test.stopTest();
            }
    }
}