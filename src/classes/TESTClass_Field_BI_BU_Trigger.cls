@isTest(seeAllData = FALSE)
public class TESTClass_Field_BI_BU_Trigger{

public static testmethod void testFieldBIBU(){

  // Insert organisation
  Organization__c orgRec = new Organization__c(Name='org');
  insert orgRec;

  // Insert object
  Object__c objRec = new Object__c(Name='account',Organization__c= orgRec.Id);
  insert objRec;
  
  // Insert field
  Field__c fldRec = new Field__c(Name='Field',Object__c = objRec.Id,UsedPageLayout__c = 'layout id',MandatoryPageLayout__c='mandatory layout id');
  insert fldRec;

}



}