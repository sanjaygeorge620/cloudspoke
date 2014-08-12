/*
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 6/07/2013
 *
 * Author : Rahul
 * 
 * Description : This is the test method for the AssetsForAgreementController class.
 * 
 */
@isTest(SeeAllData=true)
private class LX_Test_AssignSolutionOwner {

    static testMethod void setUpData() {
         
         
         EmailTemplate template = ([select Id from EmailTemplate where Name = 'Solution Development - Assignment Notification' limit 1]);
         system.debug('>>>>>>>>>>>>>>>>>>>>>temo'+template);
         //Created Account data.
         Account acct = Data_Account.createAccount();
         //Create contact data         
         List<Contact> contacts = Data_Contact.createContacts(acct.Id,3);
         
         //Create Case Data 
         List<Case> cases = Data_Case.createCase(acct, contacts[0] , 'Product Support', 10);  
         list<id> testIds = new list<id>();
         Case sampleCase ;
         Integer i = 0;
         
         for(Case cas: cases){
            if(i == 3){
                cas.Status = '03. Quote Submitted';
            }
            
            if( i == 1){
                cas.Status = '05. Development - Assigned';
                cas.Solution_Developer__c   = Userinfo.getUserId();
            }
            
            if( i == 2){
                cas.Status = '09. QA - In Progress';
                cas.Project_Manager__c = Userinfo.getUserId();
            }
            sampleCase = cas;
            testIds.add(cas.id);
         }
         
         //update cases;
         system.debug('>>>>>>>>>>>>>>>>>>>.'+cases);
         test.StartTest();         
            sampleCase.Status = '03. Quote Submitted';
            update sampleCase;
            AssignSolutionOwner.AssignSolutionOwnerName(testIds);
         
            sampleCase.Status = '05. Development - Assigned';
            sampleCase.Solution_Developer__c    = Userinfo.getUserId();
            update sampleCase;
            AssignSolutionOwner.AssignSolutionOwnerName(testIds);


            sampleCase.Status = '09. QA - In Progress';
            sampleCase.Project_Manager__c = Userinfo.getUserId();
            update sampleCase;
            AssignSolutionOwner.AssignSolutionOwnerName(testIds);


         test.StopTest();
    }
}