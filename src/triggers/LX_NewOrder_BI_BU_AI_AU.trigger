trigger LX_NewOrder_BI_BU_AI_AU on LX_New_Order_Request__c (before insert,after insert,before update, after update) { 
  
    set<Id> oppId = new set<Id>();
    set<Id> casenewOrderID = new set<Id>();
    set<Id> sapCOntract = new set<Id>();
    Map<ID,LX_New_Order_Request__c> mapNewOrder = new Map<Id,LX_New_Order_Request__c >();
   for(LX_New_Order_Request__c order:Trigger.New){
     If(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        oppId.add(order.LX_Opportunity__c);
     }
     if(Trigger.isAfter){
       if(Trigger.isInsert && order.LX_SAP_Contract__c != NULL){
          mapNewOrder.put(order.id,order);
          sapCOntract.add(order.LX_SAP_Contract__c);
       }
       if((Trigger.isInsert && order.LX_License_End_User__c != null && order.LX_Sum_of_Quantity__c >0 && (order.LX_Bill_To_ID__c != '' && order.LX_Bill_To_ID__c != null) && (order.LX_Ship_To_ID__c != '' && order.LX_Ship_To_ID__c != null))
           || (Trigger.isUpdate && order.LX_License_End_User__c != null  
               && order.LX_Bill_To_ID__c != '' && order.LX_Bill_To_ID__c != null 
               && order.LX_Ship_To_ID__c != '' && order.LX_Ship_To_ID__c != null 
               && order.LX_Sum_of_Quantity__c >0
               && (Trigger.oldMap.get(order.id).LX_Sum_of_Quantity__c != order.LX_Sum_of_Quantity__c || Trigger.oldMap.get(order.id).LX_Ship_To_ID__c != order.LX_Ship_To_ID__c || Trigger.oldMap.get(order.id).LX_Bill_To_ID__c != order.LX_Bill_To_ID__c || Trigger.oldMap.get(order.id).LX_License_End_User__c != order.LX_License_End_User__c)  )
          ){
             System.debug('********hereherehere*** inside case generation'+order.LX_Bill_To_ID__c);
              casenewOrderID.add(order.id);    
       }
    }
   }//end of for loop
     if(!mapNewOrder.isEmpty()){
       LX_NewOrderHelper.createJunctionObject(mapNewOrder,sapCOntract);
     }
     if(casenewOrderID.size()>0){
       LX_NewOrderHelper.createNewOrderCase(Trigger.newMap,casenewOrderID);
     }
   
   Map<Id,Opportunity> oppMap; 
   if(OppId.size()>0 && Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
     oppMap = new Map<Id,Opportunity>([SELECT id,LX_End_User_Sold_To__c,LX_End_User_Sold_To__r.LX_Sold_To__c FROM Opportunity WHERE Id in:OppId]);
   for(LX_New_Order_Request__c order1 : Trigger.New){

     if(oppMap.containsKey(order1.LX_Opportunity__c) && oppMap.get(order1.LX_Opportunity__c).LX_End_User_Sold_To__c != null && oppMap.get(order1.LX_Opportunity__c).LX_End_User_Sold_To__r.LX_Sold_To__c != null){

     system.debug('*************'+oppMap.get(order1.LX_Opportunity__c).LX_End_User_Sold_To__c);
     system.debug('^^^^^^^^^^^^'+oppMap.get(order1.LX_Opportunity__c).LX_End_User_Sold_To__r.LX_Sold_To__c);
      order1.LX_License_End_User__c = oppMap.get(order1.LX_Opportunity__c).LX_End_User_Sold_To__r.LX_Sold_To__c;
     // order1.addError('fkkhfyufuf'+order1.LX_License_End_User__c );
     }
   }
 }
}