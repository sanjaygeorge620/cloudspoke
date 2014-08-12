@isTest(SeeAllData = true)
public class EditNewOrderRequest_Extension_Test{
    
    public static testMethod void testNewOrderEditExtension(){
        
        
        Recordtype recAcc = [Select id from RecordType where Sobjecttype='Account' and Name='MDM Customer'];
        Account acc = new Account(name = 'TestAccount26', CurrencyIsoCode = 'USD', Physical_Country__c = 'US', BillingCountry = 'US',recordtypeId = recAcc.Id);
        insert acc;
        
        Recordtype recAcc1 = [Select id from RecordType where Sobjecttype='Account' and Name='Location Customer'];
        Account acc1 = new Account(name = 'TestAccount26', CurrencyIsoCode = 'USD', Physical_Country__c = 'US', BillingCountry = 'US',recordtypeId = recAcc1.Id);
        insert acc1;
        
        Contact newContact = new Contact(AccountId = acc.id, lastName = 'Kashyap');
        insert newContact;
        Opportunity opp = new Opportunity(name = 'TestOpportunity26', AccountId = acc1.Id, closeDate = System.today(), Amount = 1000, stageName = 'Qualifying', Reason_for_Conversion__c = 'Sales');
        insert opp;
        
        Recordtype rec = [Select id from RecordType where Sobjecttype='LX_SAP_Record__c' and name='Sold To'];
        LX_SAP_Record__c sap = new LX_SAP_Record__c(recordtypeId = rec.Id,LX_Account__c = acc.Id);
        insert sap; 
       
        LX_New_Order_Request__c newOrder = new LX_New_Order_Request__c(LX_Opportunity__c = opp.id, License_Contact__c = newContact.id,LX_License_End_User__c=sap.id);
        insert newOrder;
        ApexPages.CurrentPage().getParameters().put('id',newOrder.id);
        ApexPages.standardController sc = new ApexPages.StandardController(newOrder);
        EditNewOrderRequest_Extension extn = new EditNewOrderRequest_Extension(sc);
        PageReference pg = extn.saveNewReq();
        System.assertNotEquals(pg, null);
        extn.doCancel();
        
    }
}