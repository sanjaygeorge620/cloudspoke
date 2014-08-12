@isTest 
public class TestOppTeam {
static testMethod void insertNew() {
    
    OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
    Opportunity opp = [SELECT Id, Name, OwnerId, Owner_Email__c FROM Opportunity where id = '006i000000BTVxE'];
    System.debug('************ Opportunity owner ID ************ ' + opp.Id);
 System.debug('************ Opportunity owner ID ************ ' + opp.OwnerId);

    				oppTeamMember.CurrencyIsoCode = 'USD';
							oppTeamMember.OpportunityId = opp.Id;
							oppTeamMember.TeamMemberRole = 'Quote Editor';                           
							oppTeamMember.UserId = UserInfo.getUserId();
    insert oppTeamMember;
}
}