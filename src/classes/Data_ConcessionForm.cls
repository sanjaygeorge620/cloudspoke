@istest
public with sharing class Data_ConcessionForm {
    public static Concession_Form__c createConcessionForm(Id oppId,Id userId1,Id userId2){
        Concession_Form__c concessionForm = new Concession_Form__c();
        concessionForm.Opportunity__c = oppId;
        concessionForm.AEX_Manager__c = userId1;
        concessionForm.Account_Executive__c = userId2;
        concessionForm.Initiating_Department__c = 'Sales';
        concessionForm.Standard_License_Proposal_Amount__c = 0;
        concessionForm.Proposed_Licensed_Amount_1__c = 0;
        concessionForm.License_Conc_Comment__c = 'test license concession';
        concessionForm.Standard_Prof_Srvcs_Proposal_Amount__c = 0;
        concessionForm.Proposed_Prof_Srvcs_Amount_1__c = 0;
        concessionForm.Prof_Srvcs_Concession_Comment__c = 'test prof srvcs';
        concessionForm.Standard_Tech_Srvcs_Proposal_Amount__c = 0;
        concessionForm.Proposed_Tech_Srvcs_Amount_1__c = 0;
        concessionForm.Tech_Srvcs_Concession_Comment__c = 'test tech srvcs';
        concessionForm.Standard_3rd_Party_Proposal_Amount__c = 0;
        concessionForm.Proposed_3rd_Party_Amount_1__c = 0;
        concessionForm.X3rd_Party_Concession_Comment__c = 'test 3rd party';
        concessionForm.Concession_Category__c = 'License Exchange';
        concessionForm.Account_Executive_Understands_Terms__c = true;
        
        
        insert concessionForm;
        return concessionForm;
   }
   static testMethod void testTestData() {
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);       
                
      Set<String> userProfile = new Set<String>();
      userProfile.add('PSE Management');
      userProfile.add('PSE User');
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
           ProfileIds.add(profile.id);
        }
      List<User> userList = Data_User.createUser(3, profileIds);       
             
         Concession_Form__c concessionForm = Data_ConcessionForm.createConcessionForm( test_Opportunities[0].id, userList[0].id, userList[1].id);       
         System.assert(concessionForm.id != null);
      }   
}