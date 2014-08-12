public with sharing class runTestScriptExtension {
        
        Public final Id Test = System.currentPageReference().getParameters().get('Id');
        
        Private final test__c tst;
        
        public Boolean isnewBugs{get;set;}
        
        private list<Test_Bug_Link__c> BugLink = new list<Test_Bug_Link__c>();
        private Map<string, id> stepName = new Map<string, id>();
        
        public runTestScriptExtension(ApexPages.StandardController stdController) {
        this.tst = (test__c)stdController.getRecord();
    }
        
        
        
        Public list<Bug__c> Bugs {get{
                if(Bugs == null){
                        Bugs = new list<Bug__c>();
                }
                return Bugs;
                
        }set;
        }
        
        
        Public list<test_steps__c> TestSp {get{
                if(testSp == null){
                        TestSp = [select id,
                                                        name, 
                                                        Action__c, 
                                                        Expected_Results__c, 
                                                        Tips__c, 
                                                        Outcome__c, 
                                                        Comments__c,
                                                        detailed_requirement__c
                                                        from test_steps__c 
                                                        where test__c = :Test order by Name];
                                                        
                        for(test_steps__c t : TestSp){
                                stepName.put(t.name, t.id);
                        }
                }
                return TestSp;
        
        
        }set;}
        
        public PageReference addBug(){
                id testId = System.currentPageReference().getParameters().get('testId');
                string testStepName = System.currentPageReference().getParameters().get('testName');
                id req1;
                if(System.currentPageReference().getParameters().get('req')!= ''){
                        req1 = System.currentPageReference().getParameters().get('req');
                }
                isnewBugs = true;
                Bugs.add(new Bug__c(status__c='Raised', User_Story__c= tst.User_Story__c, Assigned_to__c = tst.test_manager__c, Test_Phase__c = tst.Test_Phase__c, Detailed_Requirement__c = req1, script_number__c = testStepName));
                
                system.debug(Bugs);
                return null;
        }
        
        Public PageReference Save(){
                update tst;
                update TestSp;  
                if(!bugs.isEmpty()){
                        insert Bugs;
                        for(Bug__c b: Bugs){
                                id testst = stepName.get(b.script_number__c);
                                BugLink.add(new Test_Bug_Link__c(Bug__c=b.id, Test_Script__c=tst.id, Test_Step_Result__c=testst));
                        
                        }
                        insert BugLink;
                }
                PageReference savenclose = new PageReference('/'+Test);
                return savenclose;
        }

}