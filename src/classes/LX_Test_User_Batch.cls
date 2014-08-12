/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 07/26/2013
*
* Author : Sanjay George.
* 
* Description : Test class for 'LX_user_batch' class .

*/

@isTest(seeAllData = true)
public class LX_Test_User_Batch{

         
        static testmethod void testSchedule2() {
            Test.startTest();
                
                Profile pr = [Select id from profile where name='System Administrator'];
                Data_User.createUser(1,new List<ID>{pr.Id});
                Database.executebatch(new LX_user_batch(),1);
        
            Test.stopTest();

       }
        
        static testmethod void testSchedule3() {
            Test.startTest();
                
                Profile pr = [Select id from profile where name='System Administrator'];
                Data_User.createUser(1,new List<ID>{pr.Id});
                Account acc = new Account(name='test Account',Primary_ISS_Internal_Segment__c ='Distributor',BillingCountry='USA',ISS_Coverage_Model__c ='Enterprise',ISS_Coverage_Method__c = 'Uncovered' ,Local_Priority__c  = 'E',MPS_Qualification__c = 'Non MPS',Physical_country__c='USA',type = 'Customer',Coverage_Status__c ='Active',TR_Status__c='On');
                insert acc;
                Account acc2 = new Account(name='test Account',BillingCountry='USA',Primary_ISS_Internal_Segment__c = 'Distributor',ISS_Coverage_Model__c ='SMB',Local_Priority__c  = 'E',MPS_Qualification__c = 'MPS',Physical_country__c='USA',type = 'Partner',Coverage_Status__c ='Active');
                insert acc2;
                Database.executebatch(new LX_user_batch(),1);
        
            Test.stopTest();

       }
        
        static testmethod void testSchedule4() {
            Test.startTest();
                
                Profile pr = [Select id from profile where name='System Administrator'];
                Data_User.createUser(1,new List<ID>{pr.Id});
                Account acc = new Account(name='test Account',Primary_ISS_Internal_Segment__c ='Distributor', BillingCountry='USA',Local_Priority__c  = 'E',MPS_Qualification__c = 'MPS',Physical_country__c='USA',type = 'Customer',Coverage_Status__c ='Active' ,TR_Status__c='On',ISS_Coverage_Model__c ='Enterprise',ISS_Coverage_Method__c = 'Uncovered');
                insert acc;
                       
                Database.executebatch(new LX_user_batch(),1);
        
            Test.stopTest();

       }
        
        static testmethod void testSchedule5() {
            Test.startTest();
                
                Profile pr = [Select id from profile where name='System Administrator'];
                Data_User.createUser(1,new List<ID>{pr.Id});
                Account acc = new Account(name='test Account',BillingCountry='USA',Primary_ISS_Internal_Segment__c = 'Distributor',ISS_Coverage_Model__c ='SMB',Local_Priority__c  = 'E',MPS_Qualification__c = 'MPS',Physical_country__c='USA',type = 'Partner',Coverage_Status__c ='Active');
                insert acc;
                Database.executebatch(new LX_user_batch(),1);
        
            Test.stopTest();

       }
}