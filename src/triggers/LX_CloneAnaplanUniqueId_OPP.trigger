/* Trigger Name : LX_CloneAnaplanUniqueId_OPP
* Description :Trigger used to clone value from Id to Opportunity Unique Id in Opportunity 
* Created By :  Madhurupa Ghose Roy
* Created Date :3/19/2014 
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer         Date         Modification ID     Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*  Madhurupa Ghose Roy   3/19/2014                Initial Version

* 
*/

trigger LX_CloneAnaplanUniqueId_OPP on Opportunity(after insert, before update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [MR 30-APR-14] : Added Bypass code   
    List < Opportunity > opptyList = new List < Opportunity > ();
    
    if(trigger.isBefore && trigger.isUpdate){
      for (Opportunity oppObj: trigger.new) {
        if(oppObj.LX_Opportunity_Unique_Id__c!=null){
          oppObj.LX_Opportunity_Unique_Id__c = oppObj.Id;
        }
      }
    }
    
    if(trigger.isAfter && trigger.isInsert){
      Opportunity opptyObj;
        for(Opportunity oppObj: trigger.new) {     
          opptyObj = new Opportunity();                     
          opptyObj.Id = oppObj.Id;
          opptyObj.LX_Opportunity_Unique_Id__c = oppObj.Id;     
          opptyList.add(opptyObj);    
        }
         if(opptyList.size()>0 && opptyList!=null){
        try {       
          update opptyList;        
        } 
        catch (exception ex) {
          LX_CommonUtilities.createExceptionLog(ex);
        }
      }  
      }

    
}