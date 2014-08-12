@isTest
private class Test_CheckFederalSection {

    static testMethod void myUnitTest() {
        
        
        Set<String> userProfile = new Set<String>();
    userProfile.add('System Administrator');
         
        List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
             ProfileIds.add(profile.id);
        }
        //List<User> userList = Data_User.createUser(1, profileIds);       
        List<User> userList = [select id from User where ProfileID = :profileIDs[0] and isActive = True];
        User su = userList[0];   
        // Switch current user to Standard User
        system.debug('su: ' + su);
      //  System.runAs(su) {  
          
        List<Opportunity> test_opportunities = [select sector__c, Host_Manufacturer__c, id 
                        from Opportunity 
                        where Sector__c = 'Healthcare'
                        and StageName = 'Closed Won' limit 1];
                
          try{
              for (Opportunity oppRec: test_Opportunities){
                system.debug('oppRec: ' + oppRec);
              oppRec.Sector__c = 'Federal';
              oppRec.Host_Manufacturer__c = 'Cedar';
              }
              update test_Opportunities;
              CLIN_Information__c newClin = Data_CLIN_Information.createCLINInformation(test_Opportunities[0].id); 
              system.debug('newClinID: '+ newClin.id);      
              //System.assert(newClin.id != null); 
              
          }catch(Exception e){
              //system.debug('e.getMessage(): '+ e.getmessage());
              //System.Assert(e.getMessage().contains('The following field(s): Requisition Number, Federal Contract Number, Order Number, Solicitation Number, Period of Performance, CLIN Information Record must be completed to move this opportunity to closed won status'));
          }
      //  }
        
        
    }
}