@isTest(seeAllData=true)
public class Controller_PlanningPokerTest{


static testMethod void myUnitTest() {



Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
insert sp1;
try{
Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'BackLog';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
//try{
insert Req;
//}

//catch(Exception e){}

Planning_Poker_Session__c pps=new Planning_Poker_Session__c();
pps.Title__c='Test';
pps.Sprint__c=sp1.id;
//pps.System_Is_Selected__c=true;
insert pps;

Planning_Poker_Session_Content__c ppsc=new Planning_Poker_Session_Content__c();
ppsc.Planning_Poker_Session__c=pps.id;
ppsc.User_Story__c=Req.id;
ppsc.System_Is_Selected__c=true;
//ppsc.User_Story__c=req.id;

insert ppsc;

Planning_Poker_Session_User__c ppsu=new Planning_Poker_Session_User__c();
ppsu.Planning_Poker_Session__c=pps.id;
ppsu.User__c=UserInfo.getUserId();
insert ppsu;

Planning_Poker_Votes__c ppv=new Planning_Poker_Votes__c();
ppv.Name = 'test';
ppv.Planning_Poker_Session_Content__c=ppsc.id;
ppv.User__c=UserInfo.getUserId();

insert ppv;


ApexPages.currentPage().getParameters().put('id',pps.id);
ApexPages.currentPage().getParameters().put('generateSession',Req.Id);
Controller_PlanningPoker ppo=new Controller_PlanningPoker();
Controller_PlanningPoker.setScore(pps.id, '10', '10', 'Test');
Controller_PlanningPoker.getData(pps.id);
Controller_PlanningPoker.reEstimate(pps.id);
ppo.enterSession();
ppo.generateSession();
Controller_PlanningPoker.setStory(ppsc.id);
Controller_PlanningPoker.kickUser('Test',ppsu.id);
Controller_PlanningPoker.vote('1',pps.id);
Controller_PlanningPoker.UserVote cpuv=new Controller_PlanningPoker.UserVote();

}
catch(Exception e){
    System.debug(e);
}

}

}