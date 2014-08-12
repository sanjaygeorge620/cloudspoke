trigger updateFlexeraMemberAddress on Account (after update) 
{

Set<ID> accID = new Set<ID>();
map<ID,Account> accmap = new map<ID,Account>();
for(Account acc : Trigger.New)
{
account accold = Trigger.oldmap.get(acc.ID);
if(acc.BillingStreet!= accold.BillingStreet ||
acc.BillingState!= accold.BillingState|| acc.BillingCity!= accold.BillingCity|| 
acc.Physical_Country__c != accold.Physical_Country__c || acc.BillingPostalCode!= accold.BillingPostalCode)
{
accID.add(acc.ID);
accmap.put(acc.ID,acc);
}
}
system.debug('AccID' +accid);
List<Flexera_Member__c> fmemList = [SELECT Account_ID__c, Account_Name__c, Address_Line_1__c, Address_Line_2__c, City__c, 
Country__c, Postal_Code__c, State__c, Flexera_Account_ID__r.Account__c FROM Flexera_Member__c where Flexera_Account_ID__c in:
[SELECT Id FROM Flexera_Account__c where Account__c in: accID]];

if(!fmemList.IsEmpty())
{
for(Flexera_Member__c fm : fmemList)
{
fm.Address_Line_1__c = accmap.get(fm.Flexera_Account_ID__r.Account__c).BillingStreet;
//fm.Address_Line_2__c = accmap.get(fm.Flexera_Account_ID__r.Account__c).Physical_Street_Address_2__c ;
fm.City__c = accmap.get(fm.Flexera_Account_ID__r.Account__c).BillingCity;
fm.State__c = accmap.get(fm.Flexera_Account_ID__r.Account__c).BillingState;
fm.Postal_Code__c = accmap.get(fm.Flexera_Account_ID__r.Account__c).BillingPostalCode;
fm.Country__c = accmap.get(fm.Flexera_Account_ID__r.Account__c).BillingCountry;
}
}
if(!fmemList.IsEmpty())
{
Update fmemList;
}
}