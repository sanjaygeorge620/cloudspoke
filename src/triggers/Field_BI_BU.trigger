trigger Field_BI_BU on Field__c (before insert, before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
 if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)){
  
  for(Field__c fieldRec: Trigger.new){
  // Check if field is present on any page layout and is non mandatory
   if(fieldRec.UsedPageLayout__c != NULL && fieldRec.UsedPageLayout__c.length() > 0 ){
   
   fieldRec.Used_on_Page_Layouts__c = TRUE;
   }
   if(fieldRec.MandatoryPageLayout__c != NULL && fieldRec.MandatoryPageLayout__c.length() > 0){
      fieldRec.Mandatory_on_Page_Layouts__c = TRUE;
   
   }
 }
 }

}