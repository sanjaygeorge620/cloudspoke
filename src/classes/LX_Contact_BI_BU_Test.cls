/* Class Name : LX_Contact_BI_BU_Test
 * Description : This is a test class for LX_Contact_BI_BU trigger.
 * Created By : Charan Tej (Deloitte)
 * Created Date : 6-11-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Charan Tej           6-11-2013                         Initial Version
 * Nam Saxena           6-14-2013
 * Kapil Reddy Sama     8-14-2013                         Migrated to QA
 */

@isTest(seealldata=true)
private class LX_Contact_BI_BU_Test {

/*Description:This is the test method written to test LX_Contact_BI_BU by passing test data for Account and Contact object.
*Param:None
*Returns:VOID
*/ 

    static testmethod void m1(){
        try{
        RecordType rec = [Select id from RecordType where name='Location Customer' and sobjectType='Account'];                
            Account acc = new Account();
            acc.name='Test account';
            acc.Industry='Banking';
            acc.recordTypeId = rec.Id;
            acc.Type = 'Customer';
            insert acc;
                
            Account acc1 = new Account();
            acc1.name='Test account';
            acc1.Industry='Banking';
            acc1.recordTypeId = rec.Id;
            acc1.Type = 'Internal';
            insert acc1;
                
            Contact con = new Contact();
            con.lastname='Test Contact';
            con.email='a@b.com';
            con.phone='41234';
            con.AccountId = acc.Id;
            con.Industry__c='Education';
            con.Accounting_Contact__c = false;
            con.MailingStreet='Mail Street';
            con.Physical_Street_Address__c='Phys Address';
            con.Physical_City__c='Phys City';
            con.MailingCity='Mail City';
            con.MailingCountry='CA';
            con.Physical_Province__c='BA';
            con.Address_Edit_States__c='ABC';
            con.Physical_Postal_Code__c='14234';
            con.MailingPostalCode='54321';          
            insert con; 
                
            List<Id> accIds = new List<Id>{acc.id,acc1.id};
            List<Contact> cons = new List<Contact>{con};
                
            LX_ContactTriggerUtil obj = new LX_ContactTriggerUtil();
            obj.updateContactAddress(cons,accIds);
        }
        catch(Exception e){
        }
    }
    
/*Description:This is the test method written to test LX_Contact_BI_BU by passing test data for Account and Contact object.
*Param:None
*Returns:VOID
*/ 
    
    static testmethod void m2(){       
        RecordType rec = [Select id from RecordType where name='Location Customer' and sobjectType='Account'];
            
        Account acc = new Account();
        acc.name='Test account';
        acc.Industry='Banking';
        acc.recordTypeId = rec.Id;
        acc.BillingCountry = 'USA';
        acc.Physical_Country__c='USA';
        insert acc;
            
        Contact con = new Contact();
        con.lastname='Test Contact';
        con.email='a@b.com';
        con.phone='41234';
        con.AccountId = acc.Id;
        con.Industry__c='Education';
        insert con;     
    }
    
/*Description:This is the test method written to test LX_Contact_BI_BU by passing test data for Account and Contact object.
*Param:None
*Returns:VOID
*/ 
    
    static testmethod void m3(){       
        RecordType rec = [Select id from RecordType where name='Location Customer' and sobjectType='Account'];
            
        Account acc = new Account();
        acc.name='Test account';
        acc.Industry='Banking';
        acc.recordTypeId = rec.Id;
        acc.type = 'Customer';
        acc.BillingCountry = 'USA';
        acc.Physical_Country__c='USA';
        insert acc;
            
        Contact con = new Contact();
        con.lastname='Test Contact';
        con.email='a@b.com';
        con.phone='41234';
        con.AccountId = acc.Id;
        con.Industry__c='Education';
        con.Lead_AA_Name_Map__c='test';
        con.Lead_AA_Phone_Map__c='test';
        insert con; 
            
        ActionPlan__c ap = new ActionPlan__c();
        ap.name='test plan';
        ap.Contact__c= con.Id;
        insert ap;
            
        ActionPlan__c ap1 = new ActionPlan__c();
        ap1.name='test plan';
        ap1.Contact__c= con.Id;
        insert ap1;    
            
        delete con;
        delete ap;
        List<Id> accIds = new List<Id>{acc.id};
        List<Contact> cons = new List<Contact>{con};
        List<Id> conIds = new List<Id>{con.Id};
        LX_ContactTriggerUtil obj = new LX_ContactTriggerUtil();            
        obj.updateContactAddress(cons,accIds);
        obj.contactActionPlanDelete(cons);
        obj.contactActionPlanUnDelete(cons);
        obj.leadFieldstoContactMap(cons);
        obj.checkUniqueDefaultToValidation(cons,conIds,accIds);         
    }
}