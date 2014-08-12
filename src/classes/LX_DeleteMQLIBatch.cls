/*
Class Name : LX_DeleteMQLIBatch
Description : Batch class to delete the MQLU
Created By : Veenu Trehan (vtrehan@deloitte.com)
Created Date : 28-4-2014
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan      28-4-2014         1000                   Initial Version
Shubashish Rai    28-04-2014                              Modified

*************************************************************************/


global class LX_DeleteMQLIBatch implements Database.Batchable<sObject>,Database.Stateful{
    global final set<id> childOppSet = new set<id>();
    global final String query;
    
    global final map<id,Opportunity> oppMap = new map<id,Opportunity>();
    global final map<id,Opportunity> childOppMap = new map<id,Opportunity>();
    global final map<id,OpportunityLineItem> lineItems = new Map<id, OpportunityLineItem>();
    global final map<id, List<OpportunityLineItem>> lineItemsMap = new Map<id, List<OpportunityLineItem>>();
    global final map<id,Id> childOppMapWithParent = new map<id,Id>();  

    global set<id> DeleteErrorSet =new set<id>();
    global list<LX_Master_Quote_Line_Item__c> DeleteErrorList=new list<LX_Master_Quote_Line_Item__c>();
    global LX_DeleteMQLIBatch(set<id> childOppSetFromBatch){
        childOppSet.addAll(childOppSetFromBatch);
        query = 'Select id,LX_Opportunity__c from LX_Master_Quote_Line_Item__c where LX_Opportunity__c in : childOppSet';
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
//            if(childOppSet.size()>0)
                  return Database.getQueryLocator(query);   
    }
    global void execute(Database.BatchableContext BC, List<LX_Master_Quote_Line_Item__c> Scope){   
        if(Scope!=null){
           
            Database.DeleteResult[] srList =Database.delete(scope, false);
            for(Database.DeleteResult delRec :srList ){
            if(!delRec.isSuccess()){ //if not successfully deleted
                System.debug('@@@1 execute' + delRec.getId());
                DeleteErrorSet.add(delRec.getId() );
                }
            }
        }
        else{
            System.debug(scope.size());
        }
    }
    global void finish(Database.BatchableContext BC){
        set<Id> MasterOppSet=new set<id>();
        set<id> ChildOppSet=new set<id>();
        System.debug('DeleteErrorSet.size() @@@@' + DeleteErrorSet.size());
        if(DeleteErrorSet.size()>0){
            DeleteErrorList=[select id,LX_Opportunity__c,LX_Opportunity__r.Master_Opportunity__c from LX_Master_Quote_Line_Item__c where id IN :DeleteErrorSet LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
            System.debug('DeleteErrorList.size() @@@@' + DeleteErrorList.size());
            if(DeleteErrorList.size()>0){
            
                for(LX_Master_Quote_Line_Item__c MQrec:DeleteErrorList){
                    MasterOppSet.add(MQrec.LX_Opportunity__r.Master_Opportunity__c);
                    ChildOppSet.add(MQrec.LX_Opportunity__c);
                    }
                 System.debug('MasterOppSet.size() @@@@' + MasterOppSet.size());
                if(MasterOppSet.size()>0){
                list<opportunity> MastOppList=new list<opportunity>();
                    MastOppList=[Select id,LX_MQLI_error__c,LX_MQLI_Update_Tracker__c,LX_Opportunity_Amount_Prior_Value__c,Amount,LX_Number_of_Products__c,LX_Number_of_Products_Prior_Value__c from opportunity where id IN :MasterOppSet LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
                    for(opportunity MastOppRec:MastOppList){
                    MastOppRec.LX_MQLI_Update_Tracker__c=false;
                    MastOppRec.LX_MQLI_error__c=true;
                    MastOppRec.LX_Number_of_Products_Prior_Value__c=MastOppRec.LX_Number_of_Products__c;
                    MastOppRec.LX_Opportunity_Amount_Prior_Value__c=MastOppRec.Amount;
                    }
                    if(MastOppList.size()>0){
                        try{
                            update MastOppList;
                        } catch(Exception ex){
                            LX_CommonUtilities.createExceptionLog(ex);
                            }
                        }
                }
                }
            }
        LX_CreateMQLIBatch CreatBatchInstance = new LX_CreateMQLIBatch();

        for(Id id: oppMap.keyset()){
          if(!MasterOppSet.contains(id)){
                CreatBatchInstance .oppMap.put(id, oppMap.get(id));
         }
        }
        for(Id id: childOppMap.keyset()){
        if(!ChildOppSet.contains(id)){
            CreatBatchInstance .childOppMap.put(id, childOppMap.get(id));
           }
        }
        for(Id id: lineItems.keyset()){
            CreatBatchInstance .lineItems.put(id, lineItems.get(id));
        }
        for(Id id: lineItemsMap.keyset()){
            CreatBatchInstance .lineItemsMap.put(id, lineItemsMap.get(id));
        }
        System.debug('@@@@1' + lineItemsMap);
        
        for(Id id: childOppMapWithParent.keyset()){
            CreatBatchInstance .childOppMapWithParent.put(id, childOppMapWithParent.get(id));
        }

        System.debug('@@@@2' + childOppMapWithParent);
        
        Database.executeBatch(CreatBatchInstance ,200);
    }
}