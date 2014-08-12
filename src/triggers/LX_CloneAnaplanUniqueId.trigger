/* Trigger Name : LX_CloneAnaplanUniqueId
* Description :Trigger used to clone value from Anaplan Unique Id to Unique Id in OpportunityLineItem 
* Created By :  Madhurupa Ghose Roy
* Created Date :3/13/2014 
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer         Date         Modification ID     Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*  Madhurupa Ghose Roy   3/13/2014                Initial Version

* 
*/

trigger LX_CloneAnaplanUniqueId on OpportunityLineItem(after insert,before update) {   

    if(LX_CommonUtilities.ByPassBusinessRule()) return;  //[MR 30-APR-14] : Added Bypass code 
    List<OpportunityLineItem> opptyLineItem = new List<OpportunityLineItem>();
      if(trigger.isAfter && trigger.isInsert){
        OpportunityLineItem opptyLineItemObj;
        for(OpportunityLineItem oliObj: trigger.new) {       
          opptyLineItemObj = new OpportunityLineItem();                   
          opptyLineItemObj.Id = oliObj.Id;
          opptyLineItemObj.LX_Unique_ID__c = oliObj.Id;     
          opptyLineItem.add(opptyLineItemObj);    
        }
       if(opptyLineItem.size()>0 && opptyLineItem!=null){
        try {       
          update opptyLineItem;        
        } 
        catch (exception ex) {
          LX_CommonUtilities.createExceptionLog(ex);
        }
      }  
      }
      if(trigger.isBefore && trigger.isUpdate){
        for (OpportunityLineItem oliObj: trigger.new) {
          if(oliObj.LX_Unique_ID__c!=null){
            oliObj.LX_Unique_ID__c = oliObj.Id;
          }
        }
      }
     
  }