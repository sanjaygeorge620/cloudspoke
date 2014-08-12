public class LX_NewOrderHelper{
 public static final String caseOrigin = 'Case';
 public static final String caseType = 'Request';
 public static final String caseSubject = 'New Order Request';
 
 public static void createJunctionObject(Map<ID,LX_New_Order_Request__c> mapNewRecs, set<ID> sapCon){
    System.debug('&&&&&&&'+mapNewRecs+'%%%%%%%%%'+sapCon);
    List<LX_New_Order_SAP_Contract_Item__c> saveJn = new List<LX_New_Order_SAP_Contract_Item__c>();
    map<ID,SAP_Contract__c> mapSAPItem = new map<ID,SAP_Contract__c>([SELECT ID,(SELECT ID FROM SAP_Contract_Items__r) FROM SAP_Contract__c WHERE ID in :sapCon ]);
    for(ID newOrderID : mapNewRecs.keyset()){
     if(mapNewRecs.containsKey(newOrderID) && mapNewRecs.get(newOrderID).LX_SAP_Contract__c != NULL 
        && mapSAPItem.containsKey(mapNewRecs.get(newOrderID).LX_SAP_Contract__c) && mapSAPItem.get(mapNewRecs.get(newOrderID).LX_SAP_Contract__c).SAP_Contract_Items__r.size()>0){ 
      for(SAP_Contract_Item__c sapConLine : mapSAPItem.get(mapNewRecs.get(newOrderID).LX_SAP_Contract__c).SAP_Contract_Items__r){
          LX_New_Order_SAP_Contract_Item__c jnObj = new LX_New_Order_SAP_Contract_Item__c();
          jnObj.LX_New_Order_Request__c = newOrderID;
          jnObj.LX_SAP_Contract_Item__c = sapConLine.ID;
          jnObj.LX_Quantity__C = 0;
          saveJn.add(jnObj);
        }
      }
    }
    if(saveJn.size()>0){
      insert saveJn;
    }
 }
 
 public static void createNewOrderCase(Map<Id,LX_New_Order_Request__c> newReqs, Set<Id> newOrder){
    List<Case> newOrderCaseList = new List<Case>();
    set<ID> hasOpenCases = new set<ID>();
    //Fetching the assignment rules on case
    AssignmentRule AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' and Active = true limit 1];
    //Creating the DMLOptions for "Assign using active assignment rules" checkbox
    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
    dmlOpts.EmailHeader.TriggerUserEmail = true;
    for(Case cs : [SELECT Id,LX_New_Order_Request__c,Status FROM Case WHERE LX_New_Order_Request__c IN:newOrder]){
      if(cs.Status != 'Closed'){
       hasOpenCases.add(cs.LX_New_Order_Request__c);
      }
    }
      for(ID orderID : newOrder){
      if(!hasOpenCases.contains(orderID) && newReqs.get(orderID).LX_Sum_of_Quantity__c >0){
          Case neworderCase = new Case();
          neworderCase.RecordTypeID = LX_SetRecordIDs.CaseNewOrderRecordTypeId;
          neworderCase.LX_New_Order_Request__c = orderID;
          neworderCase.Origin = LX_NewOrderHelper.caseOrigin;
          neworderCase.Type = LX_NewOrderHelper.caseType;
          neworderCase.subject = LX_NewOrderHelper.caseSubject;
          neworderCase.setOptions(dmlOpts);
          newOrderCaseList.add(neworderCase);
        }else{
          
        }
      }
      if(newOrderCaseList.size()>0){
        try{
          insert newOrderCaseList;
         }catch(Exception ex){
           System.debug('******'+ex.getMessage());
         }
      }
    
 } 
}