@isTest(SeeAllData=true)
private class UpdateProjectOnOpp_Test {
    
   public static List<pse__Budget__c> tempPseBudgetList ;
   public static List<pse__Proj__c> projectIDList ;
   public static List<pse__Proj__c> projectIDListUpdate ;
   public static List<Id> accountIdToUpdate;
   public static List<Account> accountForopp;
   public static List<Account> accountForUpdate;
   public static List<pse__Budget__c> budjLst;
   public static List<pse__Budget__c> budjLstUpdate;
   public static List<Id> pseProjIDList;
   public static List<pse__Proj__c> projectRecordTypeUpdateList;
   public static testmethod void test() {

    Test.startTest();
    try {
           Schema.DescribeSObjectResult acc = Schema.SObjectType.Account; 
           Map<String,Schema.RecordTypeInfo> accMap = acc.getRecordTypeInfosByName();
           Id accRTId = accMap.get('Location Customer').getRecordTypeId();
           
           Schema.DescribeSObjectResult des = Schema.SObjectType.pse__Proj__c; 
           Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
           Id MRrtId = rtMap.get('Professional Services').getRecordTypeId();
           
           accountForUpdate = new List<Account>();
           accountForopp = new List<Account>();
           accountIdToUpdate = new List<Id>();
           projectIDList = new List<PSE__Proj__c>{};
           projectIDListUpdate = new List<PSE__Proj__c>{};
           budjLst = new List<pse__Budget__c>();
           budjLstUpdate = new List<pse__Budget__c>();
           projectIDList = [Select id, createdDate, pse__opportunity__c, pse__Opportunity__r.pse__Primary_Project__c,
                           pse__Opportunity__r.Account.RecordType.DeveloperName,pse__Opportunity__r.AccountId
                           from pse__Proj__c where pse__opportunity__c <> null
                           and pse__Opportunity__r.pse__Primary_Project__c = null
                           order by CreatedDate asc
                           limit 10];
           for(pse__Proj__c tempProj : projectIDList ){
               tempProj.RecordTypeid = MRrtId ;
               accountIdToUpdate.add(tempProj.pse__Opportunity__r.AccountId);
               projectIDListUpdate.add(tempProj);
           }
           accountForOpp = [Select id,recordTypeId from Account where Id IN :accountIdToUpdate];
           for(Account tempAcc : accountForopp ){
               tempAcc.RecordTypeid = accRTId;
               accountForUpdate.add(tempAcc);
           }
           update accountForUpdate;
           update projectIDListUpdate;
           
           tempPseBudgetList = new List<pse__Budget__c>(); 
           tempPseBudgetList = [Select ID,pse__Opportunity__c,pse__Opportunity__r.pse__Primary_Project__c,pse__Project__c,
                               pse__Project__r.Recordtypeid,pse__Project__r.createddate
                               from pse__Budget__c
                               where pse__Opportunity__r.pse__Primary_Project__c = null
                               and pse__Opportunity__c != null
                               order by pse__Project__r.createddate asc
                               limit 1];
           tempPseBudgetList[0].pse__Project__r.RecordTypeid = MRrtId ;
           update tempPseBudgetList;
           
           budjLst = [Select ID,pse__Opportunity__c,pse__Opportunity__r.pse__Primary_Project__c,pse__Project__c,
                      pse__Project__r.Recordtypeid,pse__Project__r.createddate
                      from pse__Budget__c where 
                      pse__Opportunity__r.pse__Primary_Project__c = null and pse__Opportunity__c != null
                      order by pse__Project__r.createddate asc 
                      limit 10];
           
           pseProjIDList = new List<Id>();
           
           for(pse__Budget__c temBudget : budjLst ){
                      pseProjIDList.add(temBudget.pse__Project__r.Id);
                      budjLstUpdate.add(temBudget );
           }
           projectRecordTypeUpdateList = new List<pse__Proj__c>();
           projectRecordTypeUpdateList = [Select id 
                                         from pse__Proj__c 
                                         where Id IN : pseProjIDList ];
                                         
           for(pse__Proj__c tproj : projectRecordTypeUpdateList ){
                   tproj.RecordTypeid = MRrtId;
           }
           Update projectRecordTypeUpdateList; 
           
           Update budjLstUpdate;
           
           UpdateProjectOnOpp  t = new UpdateProjectOnOpp();
           
    }
    catch (Exception e) {}           
    Test.stopTest();


    }
}