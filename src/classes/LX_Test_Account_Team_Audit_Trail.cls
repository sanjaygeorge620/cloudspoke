/* Class Name   : LX_Test_Account_Team_Audit_Trail 
    * Description  : test class for LX_Account_Team_Audit_Trail.
    * Created By   : Kapil
    * Created Date : 07/01/2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Kapil                    07/09/2013           1000                   Initial Version
    */

@isTest(seeAllData=true)
public class LX_Test_Account_Team_Audit_Trail {
    static Account acc;  
    
    
    /* Description : This method is for creating test data and covering the LX_Audit_Trail_Extension functionalities. 
    *  Param - 
    *  Returns :  Void
    */   
    static testMethod void myUnitTest1() { 
    list<id> profileids = new list<id>();
        profile p = [select id from Profile where name = 'System Administrator'];
        profileids.add(p.id);
        list<User> tempUserList = data_user.createUser(1,profileids);       
        acc = data_Account.createAccount3(); 
        system.assertNotEquals(acc, Null);
        Test.startTest();  
        PageReference pageRef = Page.LX_Account_Team_Audit_Trail;
        pageRef.getParameters().put('id', acc.id);
        Test.setCurrentPage(pageRef);
        LX_Audit_Trail_Extension controller = new LX_Audit_Trail_Extension(new ApexPages.StandardController(acc));
        controller.getAccountAccessLevels();
        controller.getCaseAccessLevels();        
        controller.getOpportunityAccessLevels();  
        controller.getaccountTeamMembers();               
        controller.addDefaultTeam();  
        controller.deleteAll();        
        controller.DeleteAccount();   
          
        // stop the test
        Test.stopTest();    
    }
    /* Description : This method is for creating test data and covering the LX_Audit_Trail_Extension functionalities. 
    *  Param - 
    *  Returns :  Void
    */  
    static testMethod void myUnitTest2() {
        list<id> profileids = new list<id>();
        profile p = [select id from Profile where name = 'System Administrator'];
        profileids.add(p.id);
        list<User> tempUserList = data_user.createUser(1,profileids);
        acc = data_Account.createAccount3(); 
        system.assertNotEquals(acc, Null);        
        Test.startTest();
        PageReference pageRef = Page.LX_AddTeamMembers;
        pageRef.getParameters().put('id', acc.id);
        Test.setCurrentPage(pageRef); 
        LX_Audit_Trail_Extension controller = new LX_Audit_Trail_Extension(new ApexPages.StandardController(acc));
             
        controller.getAccountAccessLevels();
        controller.getCaseAccessLevels();        
        controller.getOpportunityAccessLevels();  
        
        controller.getContactAccessLevels();
        controller.addTeamMembers();        
        controller.addDefaultTeam();
               
        controller.newMemberList[0].AccountAccessLevel ='Edit';
        controller.newMemberList[0].OpportunityAccessLevel ='Edit';
        controller.newMemberList[0].CaseAccessLevel ='Edit';
        controller.newMemberList[0].ContactAccessLevel ='Edit';
        controller.newMemberList[0].member = new AccountTeamMember(TeamMemberRole = 'Account Manager');
        controller.newMemberList[0].audit  = new LX_Audit_Trail__c(LX_New_Modified_By__c = tempUserList[0].id);
        
        controller.newMemberList[1].AccountAccessLevel ='Edit';
        controller.newMemberList[1].OpportunityAccessLevel ='Edit';
        controller.newMemberList[1].CaseAccessLevel ='Edit';
        controller.newMemberList[1].ContactAccessLevel ='Edit';
        controller.newMemberList[1].member = new AccountTeamMember(TeamMemberRole = 'Account Manager');
        controller.newMemberList[1].audit  = new LX_Audit_Trail__c(LX_New_Modified_By__c = tempUserList[0].id);
        
        controller.newMemberList[2].AccountAccessLevel ='Edit';
        controller.newMemberList[2].OpportunityAccessLevel ='Edit';
        controller.newMemberList[2].CaseAccessLevel ='Edit';
        controller.newMemberList[2].ContactAccessLevel ='Edit';
        controller.newMemberList[2].member = new AccountTeamMember(TeamMemberRole = 'Account Manager');
        controller.newMemberList[2].audit  = new LX_Audit_Trail__c(LX_New_Modified_By__c = tempUserList[0].id);
        
        controller.newMemberList[3].AccountAccessLevel ='Edit';
        controller.newMemberList[3].OpportunityAccessLevel ='Edit';
        controller.newMemberList[3].CaseAccessLevel ='Edit';
        controller.newMemberList[3].ContactAccessLevel ='Edit';
        controller.newMemberList[3].member = new AccountTeamMember(TeamMemberRole = 'Account Manager');
        controller.newMemberList[3].audit  = new LX_Audit_Trail__c(LX_New_Modified_By__c = tempUserList[0].id);
        
        controller.newMemberList[4].AccountAccessLevel ='Edit';
        controller.newMemberList[4].OpportunityAccessLevel ='Edit';
        controller.newMemberList[4].CaseAccessLevel ='Edit';
        controller.newMemberList[4].ContactAccessLevel ='Edit';
        controller.newMemberList[4].member = new AccountTeamMember(TeamMemberRole = 'Account Manager');
        controller.newMemberList[4].audit  = new LX_Audit_Trail__c(LX_New_Modified_By__c = tempUserList[0].id);        
        
        controller.insertTeamMembers(); 
        controller.getaccountTeamMembers();
        if(controller.accountTeamMembers != null && controller.accountTeamMembers.size()>0)
        controller.SelectedTeamMeberId = controller.accountTeamMembers[0].id;
        //system.debug('controller.accountTeamMembers[0].id-->'+controller.accountTeamMembers[0].id);
        //system.debug('controller.SelectedTeamMeberId-->'+controller.SelectedTeamMeberId);        
        controller.displayAccess();
        controller.showMore();
        controller.showAccessList();
        controller.deleteAccount();
        controller.cancel();
        // stop the test
        Test.stopTest();    
    }
}