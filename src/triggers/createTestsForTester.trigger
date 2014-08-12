trigger createTestsForTester on Tester__c (after insert) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    List<Test__c> Tst = new List<Test__c>();
    List<Test_Templates__c> Templates = new List<Test_Templates__c>();
    Set<Id> TempDetails = new Set<Id>();
    Map<Id, List<Test_Steps__c>> TempSteps = new Map<Id, List<Test_Steps__c>>();
    Map<id, Test_Templates__c> template2story = new map<id,Test_Templates__c>();
    
    for(tester__c t : trigger.new){
        TempDetails.add(t.Test_Template__c);
    }
    
    for(Test_Templates__c t : [select id, user_story__c, project__c, sprint__c from Test_Templates__c where id in :TempDetails]){
        template2story.put(t.id, t);
    
    }
    
    
    
for(Tester__c t : trigger.new){
    
    
    Tst.add(new Test__c(
    Template__c =t.Test_Template__c,
    user_story__c = template2story.get(t.Test_Template__c).user_story__c,
    project__c = template2story.get(t.Test_Template__c).project__c,
    sprint__c = template2story.get(t.Test_Template__c).sprint__c,
    OwnerId=t.User__c, 
    Status__c = 'Not Started',
    Test_Phase__c = t.Test_Phase__c,
    Process__c = t.Process__c,
    Assigned_To__c = t.User__c));
    
}

id ParId = null;
List<Test_Steps__c> toMap = new List<Test_Steps__c>();
List<Test_Steps__c> toMap2 = new List<Test_Steps__c>();
for(Test_Template_Steps__c ts : [select id, Name, Test_Script__c, Detailed_Requirements__c from Test_Template_Steps__c where Test_Script__c in :TempDetails]){
    
    if((ParId ==  ts.Test_Script__c) || (ParId == null)){
        toMap.add(new Test_Steps__c(Template_Step__c=ts.id, Detailed_Requirement__c = ts.Detailed_Requirements__c, Name = ts.name));
    }else{
        TempSteps.put(ParId, new List<Test_Steps__c>(toMap.deepClone()));
        toMap.clear();
        toMap.add(new Test_Steps__c(Template_Step__c=ts.id, Detailed_Requirement__c = ts.Detailed_Requirements__c, Name = ts.name));
    }
    
    ParId = ts.Test_Script__c;
    
    
}
system.debug(toMap);
system.debug(ParId);
TempSteps.put(ParId, new List<Test_Steps__c>(toMap.deepClone()));
system.debug(TempSteps);
toMap.clear();

insert tst;

for(Test__c ab : tst){
    String st = ab.Template__c;
    system.debug(TempSteps.get(st));
    if(TempSteps.containsKey(st)){
    list<Test_Steps__c> zy = TempSteps.get(st);
    for(Test_Steps__c x : zy){
        tomap2.add(new Test_Steps__c(
        Test__c = ab.Id,
        Name=x.Name,
        Template_Step__c = x.Template_Step__c,
        Detailed_Requirement__c = x.Detailed_Requirement__c
        ));
    }
    system.debug(zy);
    }
}
system.debug(toMap2);
insert toMap2;




}