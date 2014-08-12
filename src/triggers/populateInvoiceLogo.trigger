trigger populateInvoiceLogo on Opportunity (before update,before insert) 
{


set<ID> accID = new set<ID>();
for(Opportunity opp : Trigger.New)
{
if(opp.accountId != null)
accID.add(opp.AccountID);
}
map<ID,Account> mac = new map<ID,Account>([Select ID,Legacy_Company_Originator__c from Account where ID in: accID]);

map<string,ID> invmap = new map<String,ID>();

for(Invoice_Logo__c inv : [Select ID,Name,Code__c,Status__c from Invoice_Logo__c limit 50])
{
invmap.put(inv.name,inv.ID);
}
List<invoice_logo__c > toIns = new List<invoice_logo__c >();
for(Opportunity op : Trigger.new)
{
if(op.AccountID != null && mac.containskey(op.AccountID) && !invmap.containskey(mac.get(op.AccountID).Legacy_Company_Originator__c))
{
if(mac.get(op.AccountID).Legacy_Company_Originator__c == 'Perceptive Software' ||
   mac.get(op.AccountID).Legacy_Company_Originator__c == 'Pallas Athena' ||
   mac.get(op.AccountID).Legacy_Company_Originator__c == 'Nolij' ||
   mac.get(op.AccountID).Legacy_Company_Originator__c == 'ISYS' ||
   mac.get(op.AccountID).Legacy_Company_Originator__c == 'Brainware')
   {
   invoice_logo__c inl = new invoice_logo__c();
   inl.Name =  mac.get(op.AccountID).Legacy_Company_Originator__c;
   inl.Code__c = 'P';
   inl.Status__c = 'Active';
   toIns.add(inl);
   }

}
}
insert toIns;
for(invoice_logo__c  inlo : toIns)
{
invmap.put(inlo.Name,Inlo.ID);
}
for(Opportunity op : Trigger.new)
{
if(op.AccountID != null && mac.containskey(op.AccountID) && invmap.containskey(mac.get(op.AccountID).Legacy_Company_Originator__c))
{
op.Invoice_Logo__c = invmap.get(mac.get(op.AccountID).Legacy_Company_Originator__c);
}
}


}