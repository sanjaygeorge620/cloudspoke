@isTest(seealldata = true)
private class LX_test_ActionPlansUtilities_test{

 public static testmethod void m1() {
     
      Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
      insert acc; 

      Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
      insert Opp;
     
// ActionPlansUtilities action_plans_utils = new  ActionPlansUtilities();

     ActionPlan__c action_plan = new ActionPlan__c();
     action_plan.Name = 'test';
     action_plan.Account__c =acc.id;
     action_plan.Opportunity__c = opp.id;
     insert action_plan;

     
     ActionPlanTemplate__c act_plan_temp = new ActionPlanTemplate__c();
     act_plan_temp.Name = 'test';
     insert act_plan_temp;
     
     APTaskTemplate__c ap_task_temp_test = new APTaskTemplate__c();
     list<APTaskTemplate__c> ap_task_temp = new list<APTaskTemplate__c>();
     ap_task_temp_test.Name = 'test';
     ap_task_temp_test.Action_Plan__c = action_plan.id;
     ap_task_temp_test.DaysFromstart__c = 3;
     ap_task_temp_test.Dependent__c = '0';
     ap_task_temp_test.Subject__c = 'test';
     insert ap_task_temp_test;
     ap_task_temp.add(ap_task_temp_test);
     
     APTTaskTemplate__c apt = new APTTaskTemplate__c();
     apt.Name = 'test';
     apt.Action_Plan_Template__c = act_plan_temp.id;
     apt.DaysFromstart__c = 3;
     apt.Dependent__c = '0';
     apt.Subject__c = 'test';
     insert apt;

ApexPages.StandardController sc = new ApexPages.standardController(action_plan);
      ActionPlansUtilities action_plans_utils = new  ActionPlansUtilities(sc);

     ActionPlansUtilities acPlans = new ActionPlansUtilities(action_plan); 
     
     action_plans_utils.actionPlan = action_plan;
     
     ApexPages.currentPage().getParameters().put( 'templateId', act_plan_temp.id );
     action_plans_utils.getTasks();
     

 action_plans_utils.getRelatedObjName();
 action_plans_utils.relatedObjIds();
 action_plans_utils.getActionPlans();

 action_plans_utils.retrieveTaskFromExistingActionPlan(action_plan.Id);
 
action_plans_utils.apTasks = new List<APTaskTemplate__c>();
action_plans_utils.apTasks =  ap_task_temp;

  Profile pr = [Select id from profile where name='System Administrator'];
  List<User> uList = Data_User.createUser(1,new List<ID>{pr.Id});
  
    try{  
      System.RunAs(uList[0]){
          action_plans_utils.saveAp();
          action_plans_utils.checkCycleDependent();
      }
    }
    catch(Exception e){
        System.debug(e);
    }
    /* 
 action_plans_utils.checkPendingDeletes();
 action_plans_utils.save();
 action_plans_utils.saveHandler();
action_plans_utils.saveMultiple();
action_plans_utils.saveAndNew();
 action_plans_utils.cancel();

 action_plans_utils.addTask();
action_plans_utils.removeTask();
action_plans_utils.getTaskSize();
  action_plans_utils.getSubjectItems();
  action_plans_utils.getCompleted();
  action_plans_utils.deletePlan();
  action_plans_utils.getVersion();
  action_plans_utils.getCustomSetting();
   action_plans_utils.getHoursOption();
   action_plans_utils.hasRelatedObject();
   action_plans_utils.getRelatedObjectOptions();
   action_plans_utils.getDefaultRelatedObjectOption();
   action_plans_utils.relatedObjectId();
    action_plans_utils.getDisplayReminder();
     action_plans_utils.deleteActionPlans();
       */
 
 }
 }