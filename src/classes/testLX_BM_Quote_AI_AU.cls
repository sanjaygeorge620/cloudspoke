@isTest(SeeAllData=true)
/* Class Name    : testLX_BM_Quote_AI_AU
 * Description   : This is a test class written for trigger " LX_BM_Quote_AI_AU "
 * Created By    : Charan Vuyyuru (Deloitte)
 * Created Date  : 8-17-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                  Date        Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Charan Vuyyuru            8-17-2013     1000               Initial Version
 * SreeCharan Shatdarsanam   09-11-2013    1001               Updated test class 
 * Veenu Trehan              9-27-2013                        Updated test class
 */

public class testLX_BM_Quote_AI_AU{
    
  public static string PArtnerStringTest='partyID$#$1$#$partyName$#$Axiz (PTY) LTD- (Bt)$#$Street$#$PO BOX 2794$#$City$#$Rivonia$#$State$#$$#$Zip code$#$2128$#$Country$#$South Africa$#$partyRole$#$Distributor$#$partyProductLine$#$Printers,Options,Supplies,Warranty$#$partyType$#$National$#$purchasingMethod$#$Direct$#$claimingParty$#$$#$orderClaim$#$Order$#$shipDebit$#$$#$sapSoldTo$#$115944$#$selectedId$#$';

        static testMethod void testCase1()
        {
       //create Account test Data
      Account acc= createAccount();

        
        System.assert(acc.id != null);
        
        //create Opportuntiy test Data
        Opportunity opp = createOpportunity(acc.id); 
        List<Opportunity> opportunities = new List<Opportunity>();
             opportunities.add(opp);
            if(opportunities.size() == 0)
            {
           System.debug('*******EMPTY LIST *******************');
           }
           else
            {
           System.debug('*******LIST IS:  *******************'+ opportunities);
           }
       /*    BigMachines__Quote__c test_bigMachineQuotes1 = new BigMachines__Quote__c (BigMachines__Opportunity__c = opp.Id,Partner_Information_String__c=PArtnerStringTest);
            Test.startTest();
            insert test_bigMachineQuotes1;
            Test.stopTest();*/
            
            //insert some BigMachines__Quote__c records
          /*  List<BigMachines__Quote__c> test_bigMachineQuotes = new List<BigMachines__Quote__c > ();
            Integer i = 0;
            for(Opportunity temp_oppor : opportunities)
            {
            test_bigMachineQuotes.add(new BigMachines__Quote__c(BigMachines__Opportunity__c = temp_oppor.Id,Partner_Information_String__c=PArtnerStringTest));
            }
            Test.startTest();
            
            insert test_bigMachineQuotes;
            Test.stopTest();*/
            }
            
            
            static testMethod void testCase2()
        {
            Account acc= createAccount();

        
        System.assert(acc.id != null);
        
        //create Opportuntiy test Data
        Opportunity opp = createOpportunity(acc.id); 
        List<Opportunity> opportunities = new List<Opportunity>();
             opportunities.add(opp);
                    //insert some BigMachines__Quote__c records
            List<BigMachines__Quote__c> test_bigMachineQuotes = new List<BigMachines__Quote__c > ();
            Integer i = 0;
            for(Opportunity temp_oppor : opportunities)
            {
            test_bigMachineQuotes.add(new BigMachines__Quote__c(BigMachines__Opportunity__c = temp_oppor.Id));
            }
           Test.startTest();
           try
           {
         //    insert test_bigMachineQuotes;
            //delete the recently created BigMachines__Quote__c records 
          //  delete test_bigMachineQuotes;
            }
            catch (ListException L_ex)
            {
            System.debug('***********Exception ********' + L_ex.getMessage());
            }
            Test.stopTest();
            }
                        
             
             
             
             
             
             
          //methods used to create test data for account and Opportunity 
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
                
                OpportunityTeamMember oppteam = new  OpportunityTeamMember();
                oppteam.OpportunityId = opp.id;
                oppteam.userID = UserInfo.getUserId();
                oppteam.TeamMemberRole = 'Sales Manager';
                
                insert oppteam;
                
                return opp;
                } 
    
}