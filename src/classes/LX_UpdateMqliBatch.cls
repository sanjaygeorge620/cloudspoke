/*
Class Name : LX_UpdateMqliBatch
Description : Batch class to update the MQLU
Created By : Veenu Trehan (vtrehan@deloitte.com)
Created Date : 2-4-2014
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan      2-4-2014        1000                   Initial Version
Shubashish Rai    5-4-2014                             Modified

*************************************************************************/


global class LX_UpdateMqliBatch implements Database.Batchable<sObject>,Database.Stateful{
    global final String query;
    global set<id> SetOppid = new set<id>();
    global static map<id,Opportunity> oppMap = new map<id,Opportunity>();
   // global set<id> childOppSet = new set<id>();
    
    global map<id, List<OpportunityLineItem>> lineItemsMap = new Map<id, List<OpportunityLineItem>>();
    global Set<id> masterOppId = new Set<id>();
    global map<id,OpportunityLineItem> lineItems = new Map<id, OpportunityLineItem>();
    global static String ApprovedStr = 'Approved'; 
    
    global LX_UpdateMqliBatch()
    {
       query = 'Select id,OpportunityId,Opportunity.Master_Opportunity__c,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c,LastModifiedDate from OpportunityLineItem where Opportunity.LX_MQLI_Update_Tracker__c=True and Opportunity.Master_Opportunity__c = null and Opportunity.LX_Master_Opportunity__c = true and Opportunity.LX_Has_Participant_Opportunities__c = true and Opportunity.Quote_Status__c = ' + '\'' + ApprovedStr + '\'';
    }     
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
              return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> Scope)
    {
        // Set<Id> masterOppId = new Set<Id>(); //Added this set to the list of class variables
       //  map<id,OpportunityLineItem> lineItems = new Map<id, OpportunityLineItem>();//Added this set to the list of class variables
        // map<id,List<OpportunityLineItem>> lineItemsMap = new Map<id, List<OpportunityLineItem>>();//Added this set to the list of class variables
         
         for(OpportunityLineItem oppLineItem: Scope){        
             masterOppId.add(oppLineItem.OpportunityId);
             
             lineItems.put(oppLineItem.id,oppLineItem);
             if(lineItemsMap.get(oppLineItem.Opportunity.Id) == null)
             lineItemsMap.put(oppLineItem.OpportunityId, new List<OpportunityLineItem >{oppLineItem});
             else
             lineItemsMap.get(oppLineItem.OpportunityId).add(oppLineItem);
         }
         
            // querying parent opps and child opps
    /*  Commented to include in the finish method   
    oppMap =  new map<id,Opportunity>([SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,Amount,LX_Number_of_Products__c,
                                                              MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,LX_Notify_Owner__c,
                                                              (Select LX_Country_Code__c, id, CurrencyIsoCode, Master_Opportunity__c,LX_Notify_Owner__c From ChildOpportunities__r) 
                                                              FROM Opportunity 
                                                              WHERE Id = :masterOppId]);
        system.debug('oppMap-->'+oppMap);                                                             
         //map to store child opps
         map<id,Opportunity> childOppMap = new map<id,Opportunity>();
         map<id,Id> childOppMapWithParent = new map<id,Id>();                                                      
            for(Opportunity opp:oppMap.values()){
                for(Opportunity child:opp.ChildOpportunities__r){
                    childOppMap.put(child.id,child);
                    childOppMapWithParent.put(child.Id,opp.Id);
                    childOppSet.add(child.id);
                }
                
            }
              system.debug('childmapsize'+childOppMap.size());*/
        //to ensure all MQLI are deleted before creation
      /* Commented for calling the deletion in a batch class  
        list<LX_Master_Quote_Line_Item__c> MQLIToDelete=new list<LX_Master_Quote_Line_Item__c>();
        if(childOppMap.size()>0){
            system.debug('delete thru batch class');
            MQLIToDelete=[Select id,LX_Opportunity__c 
                          from LX_Master_Quote_Line_Item__c 
                          where LX_Opportunity__c in :childOppMap.keyset()];
            if(!MQLIToDelete.isEmpty()){
            system.debug('@@@@@'+MQLIToDelete.size());
            Delete MQLIToDelete;
            }
            MQLIToDelete=[Select id,LX_Opportunity__c 
                          from LX_Master_Quote_Line_Item__c 
                          where LX_Opportunity__c in :childOppMap.keyset()];
            System.debug('>>>>>>>>>>>MQLIToDelete>>>>>>>>>>>>>>>>>>'+MQLIToDelete.size());              
        }*/
        //calling the mqli creation fucntion
       // List<LX_Master_Quote_Line_Item__c> lstMasterQuoteLineItem = LX_OpportunityLineItemHelper.mqliUpdate1(oppMap,childOppMap,lineItems,lineItemsMap,childOppMapWithParent,batchIdentifier);
    /*    Commented to be included in the finish method
         List<Opportunity> updateOpp = new List<Opportunity>();  //list to store Opportunity Records to update Notify Owner field  
        //updating the notify owner field to send out the email alerts
        for (Opportunity  oppRec : childOppMap.values())
         {
            if(SetOppid.contains(oppRec.Id))
            {
                 oppRec.LX_Notify_Owner__c = false;
            }
            else
            {
                 oppRec.LX_Notify_Owner__c = true;
                 SetOppid.add(oppRec.Id);
            }
            system.debug('SetOppid == '+SetOppid);
            //oppRec.LX_Notify_Owner__c = true;
            updateOpp.add(oppRec);
          //  System.debug('Im in the second for loop' + '-------------------->');
         }
             //to make LX_MQLI_Update_Tracker__c of the parent to false
            opportunity oppRec ;
            List<opportunity> UpdateParentOppList = new List<opportunity>();
            system.debug('oppMap-->'+oppMap);
            for(id oppid : oppMap.keyset()){
                oppRec = new opportunity(id=oppid);
                oppRec.LX_MQLI_Update_Tracker__c=false;
                //oppRec.LX_Products_Amount__c = string.valueOf(Integer.valueOf(oppMap.get(oppid).Amount))+string.valueOf(Integer.valueOf(oppMap.get(oppid).LX_Number_of_Products__c));
                   oppRec.Lx_Old_Amount__c=oppMap.get(oppid).Amount;
                   oppRec.LX_Number_of_Products_Prior_Value__c=oppMap.get(oppid).LX_Number_of_Products__c;
                UpdateParentOppList.add(oppRec);
            }
         
            try{
            List<Opportunity> lstToUpdate = new List<Opportunity>();
             if(!(updateOpp.isEmpty())){//updating opportunities for which new Master Quote Line Item being added/updated
                LX_OpportunityLineItemHelper.isMQLIUpdated = false;
                //update updateOpp;
                lstToUpdate.addAll(updateOpp);
                System.debug('Im in the try block' + '((((((((((((((((((()))))))))))))))))))');
                System.debug('UpdateOpp size' + updateOpp.size() + '------------------------------>');
              }
               if(!(UpdateParentOppList.isEmpty())){//updating opportunities for which new Master Quote Line Item being added/updated
                //update UpdateParentOppList;
                lstToUpdate.addAll(UpdateParentOppList);
               if(lstToUpdate.size() > 0) update lstToUpdate;
               
              }
             }
            catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
            }*/
        }
    
     
    global void finish(Database.BatchableContext BC)
    {    
        try{
        oppMap =  new map<id,Opportunity>([SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,Amount,LX_Number_of_Products__c,
                                                              MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,LX_Notify_Owner__c,LX_MQLI_error__c,LX_Master_Opportunity__c,LX_Has_Participant_Opportunities__c,
                                                              (Select LX_Country_Code__c, id, CurrencyIsoCode, LX_Master_Opportunity__c ,Master_Opportunity__c,LX_Has_Participant_Opportunities__c,LX_Notify_Owner__c From ChildOpportunities__r) 
                                                              FROM Opportunity 
                                                              WHERE Id = :masterOppId LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())] );
        }catch (exception ex){
                //log the exception error.
                LX_CommonUtilities.createExceptionLog(ex);              
            }                                                            
        system.debug('oppMap-->'+oppMap);                                                             
         //map to store child opps
         map<id,Opportunity> childOppMap = new map<id,Opportunity>();
         map<id,Id> childOppMapWithParent = new map<id,Id>();                                                      
            for(Opportunity opp:oppMap.values()){
                for(Opportunity child:opp.ChildOpportunities__r){
                    childOppMap.put(child.id,child);
                    childOppMapWithParent.put(child.Id,opp.Id);
                   // childOppSet.add(child.id);
                }   
            }
              system.debug('childmapsize'+childOppMap.size());
       
        Set<Opportunity> setMQLIErrorFalse = new Set<Opportunity>();  
        List<Opportunity> listMQLIErrorFalse = new List<Opportunity>();       
        for(Opportunity opp: oppMap.values()){
            if(opp.LX_Master_Opportunity__c == true && opp.LX_Has_Participant_Opportunities__c == true && opp.LX_MQLI_error__c==True){
                opp.LX_MQLI_error__c = false;
                setMQLIErrorFalse.add(opp);
            }
        }
        listMQLIErrorFalse.addAll(setMQLIErrorFalse);
        if((listMQLIErrorFalse.size()>0) && (listMQLIErrorFalse.size()<10000)){
            try{
                Database.SaveResult[] updateList= Database.update(listMQLIErrorFalse, false);
            }
            catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
            }
        }
        //MQLI Creation later than the MQLI Deletion. Creation called in the finish method of the Delete batch class
        //calling the MQLI Deletion batch
        LX_DeleteMQLIBatch DeleteMQLIInstance = new LX_DeleteMQLIBatch(childOppMap.keyset());

        for(Id id: childOppMap.keyset()){
            DeleteMQLIInstance.childOppSet.add(id);
        }
        
        for(Id id: oppMap.keyset()){
            DeleteMQLIInstance .oppMap.put(id, oppMap.get(id));
        }
        for(Id id: childOppMap.keyset()){
            DeleteMQLIInstance .childOppMap.put(id, childOppMap.get(id));
        }
        for(Id id: lineItems.keyset()){
            DeleteMQLIInstance .lineItems.put(id, lineItems.get(id));
        }
        for(Id id: lineItemsMap.keyset()){
            DeleteMQLIInstance .lineItemsMap.put(id, lineItemsMap.get(id));
        }
        System.debug('@@@@1' + lineItemsMap);
        
        for(Id id: childOppMapWithParent.keyset()){
            DeleteMQLIInstance .childOppMapWithParent.put(id, childOppMapWithParent.get(id));
        }

        System.debug('@@@@2' + childOppMapWithParent);
        
        Database.executeBatch(DeleteMQLIInstance ,200);
    }

}