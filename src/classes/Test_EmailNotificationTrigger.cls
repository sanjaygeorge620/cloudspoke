@isTest(seealldata=true)
Private class Test_EmailNotificationTrigger {
    public static pse__Region__c testPSERegion; 
    public static pse__Proj__c testPSEProj;
    public static List<pse__Proj__c> testPSEProjList;
    
    public static testmethod void testFunction(){
        testPSERegion = new pse__Region__c();
        testPSERegion = [Select Id, Name from pse__Region__c where Name LIKE '%VNA%' limit 1];
        testPSEProjList = new List<pse__Proj__c>();
        testPSEProj = new pse__Proj__c();
        testPSEProj.Solution_Acceptance_Date__c = system.Today();
        testPSEProj.pse__Region__c = testPSERegion.Id;
        testPSEProjList.add(testPSEProj);
        
        Insert testPSEProjList;
     
    }

}