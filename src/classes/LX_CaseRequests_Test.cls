@isTest(SeeAllData = True)
public class LX_CaseRequests_Test{

    public static testMethod void Testing()
    {
        WBS_Request__c wbs = new WBS_Request__c();
        SAP_Project_Request__c sapr = new SAP_Project_Request__c();
        set<id> setid = new set<id>();
        test.startTest();
        wbs = [SELECT id FROM WBS_Request__c LIMIT 1]; 
        setid.add(wbs.Id);
        LX_CaseRequests.create_WBS_cases(setid);
        setid.remove(wbs.Id);
        sapr = [SELECT id FROM SAP_Project_Request__c LIMIT 1];
        setid.add(sapr.Id);
        LX_CaseRequests.create_SAP_cases(setid);
        test.stopTest();        
    }
    
}