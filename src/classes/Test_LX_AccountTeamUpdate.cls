/* 
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 07/09/2013
 *
 * Author : Kapil Reddy Sama.
 * 
 * Description : test class for LX_AccountTeamUpdate.
*/
@isTest(seeAllData=true)
public class Test_LX_AccountTeamUpdate {
    public static Account acc;
    static testMethod void myUnitTest1() {
        
        Test.startTest();        
        acc = data_Account.createAccount3(); 
        system.assertNotEquals(acc, Null);
        profile prfl = [Select id from Profile where name = 'System Administrator' limit 1];
        list<id> profile = new list<id>();
        profile.add(prfl.id);
        list<User> usr = Data_User.createUser(1,profile );
        
        AccountTeamMember teamMember = new AccountTeamMember(AccountId = acc.id,
                                                             UserId = usr[0].id,                                                                                                                         
                                                             TeamMemberRole = 'Account Manager');
        
        insert teamMember;
        system.assertNotequals(teamMember,null);
        AccountTeamMember member = [Select id from AccountTeamMember where id = :teamMember.id ];
        AccountShare accShare = new AccountShare(AccountId = acc.id,
                                                 AccountAccessLevel = 'Read',
                                                 CaseAccessLevel = 'None',
                                                 UserOrGroupId = usr[0].id,
                                                 OpportunityAccessLevel = 'None');
        insert accShare;                                         
        system.assertNotequals(accShare,null);                                       
        Test.setCurrentPage(Page.LX_Account_Team_Audit_Trail);   
        ApexPages.currentPage().getParameters().put('teamMemberID',member.id);          
        LX_AccountTeamUpdate controller = new LX_AccountTeamUpdate(new ApexPages.StandardController(acc));        
        controller.AccountAccessLevel = 'Edit';
        controller.CaseAccessLevel = 'Edit';
        controller.OpportunityAccessLevel = 'Edit';
        controller.TeamMemberRole = 'Alliance Manager';
        controller.getAccountAccessLevels();
        controller.getContactAccessLevels();
        controller.getCaseAccessLevels();        
        controller.getOpportunityAccessLevels();
        controller.UpdateTeamMember();  
        controller.cancel();
        // stop the test
        Test.stopTest();    
    }
}