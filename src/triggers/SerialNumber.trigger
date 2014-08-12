trigger SerialNumber on Serial_Number__c (before insert, before update, after insert, after update) {
 if(Trigger.isbefore && (Trigger.isInsert || Trigger.isUpdate))
{
    if(LX_CommonUtilities.ByPassBusinessRule()) return;

    if(trigger.isInsert) {

        handler_SerialNumber.setPartNameByPartNumber(trigger.new, trigger.newMap, trigger.isUpdate);
    }

    if(trigger.isUpdate) {

        handler_SerialNumber.setPartNameByPartNumber(trigger.new, trigger.oldMap, trigger.isUpdate);
    }
  }  
   /* if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
 {
            Set<Id> lstConId = new Set<Id>();
       for (Serial_Number__c temp : Trigger.new)     {
           lstConId.add(temp.Serial_Number_Sales_Order__c);
    }
    
    list<LX_Serial_Number_Sales_Order__c> updateserialnosalesorder = new list<LX_Serial_Number_Sales_Order__c>();
    Map<Id,LX_Serial_Number_Sales_Order__c> mapCo = new Map<Id,LX_Serial_Number_Sales_Order__c>([SELECT id, LX_Workflow__c FROM LX_Serial_Number_Sales_Order__c WHERE ID IN :lstConId]);
    for (Serial_Number__c temp : Trigger.new)    {
        if(mapCo.containsKey(temp.Serial_Number_Sales_Order__c) && temp.License_Activated__c == TRUE) {
             mapCo.get(temp.Serial_Number_Sales_Order__c).LX_Workflow__c = TRUE;
             updateserialnosalesorder.add(mapCo.get(temp.Serial_Number_Sales_Order__c));
            }
          }    
    try{              
    if(updateserialnosalesorder.size() >0){
    update updateserialnosalesorder;
        }     
      }
     catch(exception e){
    }
  } */
}