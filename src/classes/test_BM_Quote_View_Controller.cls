@isTest(seealldata = true)
private class test_BM_Quote_View_Controller
{
static testMethod void test1() 
{ 
Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
         
         RecordType rtype =[Select id from RecordType where name='Location Customer'];   
         
         User sysAdmin = new User(alias = 'test21', email='test123@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Tes2ting', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test2231@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',Legacy_Company__c='Lexmark',BigMachines__User_Groups__c = 'psQuoteAnalyst');

         insert sysAdmin;
         
         
         system.runas(sysAdmin)
         {
         
           Account acc= createAccount();

        
        System.assert(acc.id != null);
        
        //create Opportuntiy test Data
        Opportunity opp = createOpportunity(acc.id); 
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(opp);
         List<BigMachines__Quote__c> test_bigMachineQuotes = new List<BigMachines__Quote__c > ();
            Integer i = 0;
            for(Opportunity temp_oppor : opportunities)
            {
            
            test_bigMachineQuotes.add(new BigMachines__Quote__c(BigMachines__Opportunity__c = temp_oppor.Id,Current_Approvers__c = 'sserna [Lexmark] OR pcarvalh [Lexmark] OR praveensadineni [Lexmark] OR jbcorral [Lexmark] OR nveronic [Lexmark]Quote Analyst [Lexmark]'));
            test_bigMachineQuotes.add(new BigMachines__Quote__c(BigMachines__Opportunity__c = temp_oppor.Id,Current_Approvers__c = 'U:TestUserCountryGM2@TestUserCountryGM3@TrainingCountryGM$$G:psQuoteAnalyst'));            
            }
        insert test_bigMachineQuotes;
        
        test.starttest();
        BM_Quote_View_Controller qtcon = new BM_Quote_View_Controller(); 
              
        test.stoptest();
         }
         }
         
         
         public static Account createAccount()
                {
                Account acc = new Account();
                acc.Name = 'testAccount';
                acc.MDM_Sold_To_Number__c = '1234'; 
                acc.BillingCountry = 'USA';
                acc.Physical_Country__c = acc.BillingCountry;
                insert acc;
                
                 AccountTeamMember teamMemberToUpdate = new AccountTeamMember();
                 teamMemberToUpdate.AccountId = acc.id;
                 teamMemberToUpdate.UserId = UserInfo.getUserId();
                 teamMemberToUpdate.TeamMemberRole = 'Account Manager';
                 
                 insert teamMemberToUpdate;
                
             /*   AccountShare accSH = new AccountShare(AccountAccessLevel = 'Edit',
                                              //ContactAccessLevel = teamMember.ContactAccessLevel,
                                                OpportunityAccessLevel = 'Edit',
                                                CaseAccessLevel = 'Edit',
                                                AccountId = acc.id,
                                                UserorgroupId = UserInfo.getUserId());
                                                
                insert accSH;*/
                
                return acc;
                } 
                
                public static Opportunity createOpportunity(String accId)
                {
                Opportunity opp = new Opportunity();
                opp.AccountId = accId; 
                opp.Name = 'Opportunity4TestMethod';
                opp.CloseDate = Date.today().addDays(10);
                opp.Technology__c = true;
                opp.StageName = 'Negotiation';
                opp.LX_Sales_Type__c = 'Add On';
                opp.QAStatus__c = 'New';
                opp.Contract_Number__c = '12345';
                opp.Contract_End_Date__c = Date.Today().addDays(5);
                insert opp;
                              
                return opp;
                } 



}