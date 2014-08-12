@isTest(seealldata = True)
public Class batchProcessCloneScheduler_Test
{
public static testmethod void testbatchProcess()
{
Account act = Data_Account.createAccount3();
Account act1 = Data_Account.createAccount3();
system.debug('---test account ids---'+act.id+'---'+act1.id);


Contact con = new Contact(LastName='Test Contact1',
                           firstName='TestFirst',AccountId =act1.id);
asset asst = new asset();
asst.name='Test Asset';
asst.accountId=act.ID;
asst.ContactId=con.id;
asst.status='Inactive';
asst.Process_later__c = True;
insert asst;
asset_item__c astcln = new asset_item__c(name = 'Test Asset Item',Asset__c=asst.ID,Process_later__c = True);
insert astcln;
License_key__c lkey = new License_key__c(name='test abc',asset__r=asst,asset_item__c=astcln.ID,status__c='Inactive',Process_later__c = True);
insert lkey;
       Test.startTest();
       batchProcessCloneScheduler m = new batchProcessCloneScheduler();
       String sch = '00 25 06 * * ?';
       system.schedule('Batch Clone Process Schedule', sch, m);
       Test.stopTest();  
}
public static testmethod void testbatchProcess_Batch_Asset()
{
Account act = Data_Account.createAccount3();
Account act1 = Data_Account.createAccount3();
system.debug('---test account ids---'+act.id+'---'+act1.id);


Contact con = new Contact(LastName='Test Contact1',
                           firstName='TestFirst',AccountId =act1.id);
asset asst = new asset();
asst.name='Test Asset';
asst.accountId=act.ID;
asst.ContactId=con.id;
asst.status='Inactive';
asst.Process_later__c = True;
insert asst;
asset_item__c astcln = new asset_item__c(name = 'Test Asset Item',Asset__c=asst.ID,Process_later__c = True);
insert astcln;
License_key__c lkey = new License_key__c(name='test abc',asset__r=asst,asset_item__c=astcln.ID,status__c='Inactive',Process_later__c = True);
insert lkey;
       Test.startTest();
       string q='Select id, name, CurrencyIsoCode, AccountID, Agreement__r.ID, Company_Number__c, IsCompetitorProduct, Contact.id, Description, End_Date__c, InstallDate, License_Option__c, License_Type__c, Part_Number__c,Price, prodpk__c, Product__r.ID, Product_key__c, Product_Model__r.ID, Product_Name__c, PurchaseDate, Rate__c, SAP_Contract_Item__r.ID, SerialNumber, Server__r.ID,Server_ID__c, SKU__c,SKU_Description__c, Start_Date__c, Status, Product_Status__c, Total__c, Units__c, Usage__c, UsageEndDate, Users__c  from Asset';
       batchProcessClones m = new batchProcessClones(q,'Asset');
       //database.ExecuteBatch(m);
       Test.stopTest();  
}   
}