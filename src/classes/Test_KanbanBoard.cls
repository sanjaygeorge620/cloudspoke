public class Test_KanbanBoard{

public static testmethod void TestControlleroad(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'BackLog';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

PageReference pageRef = Page.DigitalKanban;
Test.setCurrentPage(pageRef);
ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(Req);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);
KBC.getsprintval();
KBC.getFuncval();
ApexPages.currentPage().getParameters().put('UpdateSwing', 'AwaitingDevUS');
ApexPages.currentPage().getParameters().put('UserStoryID', req.Id);

KBC.updateUserStoriesSprint();
ApexPages.currentPage().getParameters().put('UpdateSwing', 'InDevUS');
KBC.updateUserStoriesSprint();
ApexPages.currentPage().getParameters().put('UpdateSwing', 'BacklogUS');
KBC.updateUserStoriesSprint();
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
update req;
ApexPages.currentPage().getParameters().put('UpdateSwing', 'AwaitingSATUS');
KBC.updateUserStoriesSprint();
ApexPages.currentPage().getParameters().put('UpdateSwing', 'DoneUS');
KBC.updateUserStoriesSprint();
ApexPages.currentPage().getParameters().put('UpdateSwing', 'InSATUS');
KBC.updateUserStoriesSprint();
ApexPages.currentPage().getParameters().put('UpdateSwing', 'BPC');
KBC.updateUserStoriesSprint();
ApexPages.currentPage().getParameters().put('ChatterComment', 'DoneUS');
KBC.addChatterComment();
KBC.filteredVal();
KBC.selvalue  = sp1.Name;
KBC.filteredVal();
KBC.funcSelValue = 'Market Access';
KBC.DispUserStories(sp1.Name);
KBC.DispUserStories(null);

}

public static testmethod void TestControlleroad1(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'BackLog';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);
KBC.getsprintval();
KBC.selvalue='All';
KBC.DispUserStories('test');
KBC.selvalue=null;
KBC.DispUserStories('test');
KBC.funcSelValue=Req.Functional_Area__c;
KBC.DispUserStories('test');





}

public static testmethod void TestControlleroad2(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'Awaiting Dev';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.funcSelValue='01pi0000002M4mS';
KBC.DispUserStories('test');







}

public static testmethod void TestControlleroad3(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'In Dev';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.funcSelValue='01pi0000002M4mS';
KBC.DispUserStories('test');







}

public static testmethod void TestControlleroad4(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'Awaiting SAT';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.funcSelValue='01pi0000002M4mS';
KBC.DispUserStories('test');







}

public static testmethod void TestControlleroad5(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'In Test';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.funcSelValue='01pi0000002M4mS';
KBC.DispUserStories('test');







}


public static testmethod void TestControlleroad6(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'Done';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.funcSelValue='01pi0000002M4mS';
KBC.DispUserStories('test');







}
public static testmethod void TestControlleroad7(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'BPC';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.funcSelValue='01pi0000002M4mS';
KBC.DispUserStories('test');







}

public static testmethod void TestControlleroad8(){
Sprint__c sp1 = new Sprint__c();
sp1.Name = 'Sprint 1A';
sp1.Status__c='In Progress';

insert sp1;

Requirements__c Req = new Requirements__c();
Req.Planned_Sprint_del__c = sp1.Id;
Req.Allocated_Sprint__c = sp1.Id;
Req.Development_Stage__c = 'Awaiting Dev';
Req.Checked_by_Design_Team__c = true;
Req.Release_Completeness__c = true;
Req.User__c = UserInfo.getUserId();
Req.Supporting_BA__c = UserInfo.getUserId();
insert Req;

ApexPages.currentPage().getParameters().put('id', sp1.Id);
ApexPages.StandardController cnt = new ApexPages.StandardController(sp1);
KanbanBoardCntrl KBC = new KanbanBoardCntrl(cnt);


KBC.SelValue=null;
KBC.FilteredVal();







}


}