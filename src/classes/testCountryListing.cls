@isTest(seealldata=true)
Private class testCountryListing {

static testMethod void CountryListing() {

List<Contact> ct=new List<Contact>();
//Recordtype rec=[select ID,developername from RecordType where id='012e00000004MCg'];
Account Acc=Data_account.createAccount3();                        //[SG]: new Account(Name='Motorola', Recordtype=rec);
//insert Acc;

for(integer i=0;i<2;i++)
{

Contact Con=new Contact(LastName='test'+i, MailingCountry='US',phone='2345678',accountID = acc.id);
//Contact Con=new Contact(LastName='test'+i, MailingCountry='UK',phone='2345678',Account=Acc);
ct.add(con);
}
insert ct;





}
}