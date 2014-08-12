/* create opp
*  create User
*     -update userrole = AEX
*  create CLIN
*/
@isTest
private class Test_CLINInformation_EditCheck {

 //   public static List<User> userList ;//= new list<User>();
    
    static testMethod void Test_CLINInformation_EditCheck() {
        
        List<User> roleName = new LIst<User>([select UserRole.name, name, Profile.name from User where Profile.name = 'System Administrator' AND isActive = true limit 1]);
        
     Set<String> userProfile = new Set<String>();
      userProfile.add('PSE Management');
      userProfile.add('PSE User');
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
           ProfileIds.add(profile.id);
        }
 //     userList = Data_User.createUser(3, profileIds); 
 
 //       system.debug('userLIst.size()' + userList.size());
 
  map<Id,UserRole> AllRole = new map<Id,UserRole>([select id,name from UserRole where name like '%ISR%' or name like '%AEX%']);       
 
  list<User> AllUserRec = new list<User>([select id,name from User where UserRoleID IN :AllRole.keyset() AND isActive = true limit 1]); 
  //and profileId IN :ProfileIds
  list<User> AllUserRec1 = new list<User>([select id,name from User where UserRoleID NOT IN :AllRole.keyset() AND isActive = true limit 1]);

 /*
       for (User userRec : userList){
        //  userRec.userRole.name = 'P3 ISR';
        userRec.UserRoleId = AllRole[0].id;
       }
//       update userList;
  */      
       
        String [] stageList = new List<String>();
      //  stageList.add('Closed Won');
      stageList.add('test');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
        
        
        
        try{
            for (Opportunity oppRec: test_Opportunities){
            oppRec.Sector__c = 'Federal';
            oppRec.Requisition_Number__c = 'sdfsd';
            oppRec.Solicitation_Number__c = 'dfsdf';
            oppRec.CLIN_Contract_Number__c = 'dfs';
            oppRec.Period_of_Performance__c = 'sdfs';
            oppRec.Order_Number__c = 'sdfsd';
            }
            test.startTest();
            update test_Opportunities;
 System.runAs(roleName[0]){          
            CLIN_Information__c newClin = Data_CLIN_Information.createCLINInformation(test_Opportunities[0].id); 
            system.debug('newClinID: '+ newClin.id);      
            System.assert(newClin.id != null); 
    } 
    
  System.runAs(AllUserRec[0]){          
            CLIN_Information__c newClin1 = Data_CLIN_Information.createCLINInformation(test_Opportunities[0].id); 
  }
 System.runAs(AllUserRec1[0]){
    CLIN_Information__c newClin2 = Data_CLIN_Information.createCLINInformation(test_Opportunities[0].id); 
 }
        // CLIN_Information__c newClin2 = Data_CLIN_Information.createCLINInformation(test_Opportunities[0].id); 
  //  }    
        }catch(Exception e){
            system.debug('e.getMessage(): '+ e.getmessage());
          //  System.Assert(e.getMessage().contains('The following field(s): Requisition Number, Federal Contract Number, Order Number, Solicitation Number, Period of Performance, CLIN Information Record must be completed to move this opportunity to closed won status'));
        }
        
        

        
       test.stopTest();        
    }
 
}