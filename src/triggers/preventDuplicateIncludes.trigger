trigger preventDuplicateIncludes on Price_Book_Include__c(before insert,before update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
map<ID,list<Price_Book_Include__c>> pbd_ed = new map<ID,list<Price_Book_Include__c>>();
map<ID,Price_Book_Include__c> ed_map = new map<ID,Price_Book_Include__c>();
set<ID> edID = new set<ID>();
list<Price_Book_Include__c> ed_lst = new list<Price_Book_Include__c>();

list<Price_Book_Include__c> temp = new list<Price_Book_Include__c>();

for(Price_Book_Include__c ed : trigger.new)
{
edID.add(ed.Price_Book_Definition__c);
}


for(Price_Book_Include__c ed : [Select id,Product__c,Product_Model__c,Price_Book_Definition__c from Price_Book_Include__c ed where ed.Price_Book_Definition__c in :edID])
{
system.debug('Test 23' +ed.Id);
if(ed.id != null)
{
ed_map.put(ed.ID,ed);
ed_lst.add(ed);
}
}

for(Price_Book_Include__c ed : ed_lst)
{
if(pbd_ed.Containskey(ed.Price_Book_Definition__c))
{
system.debug('inside IF');
temp = pbd_ed.get(ed.Price_Book_Definition__c);
temp.add(ed);
pbd_ed.put(ed.Price_Book_Definition__c,temp);
}

if(!pbd_ed.Containskey(ed.Price_Book_Definition__c))
{
system.debug('inside else');
temp.clear();
temp.add(ed);
pbd_ed.put(ed.Price_Book_Definition__c,temp);
edID.add(ed.Price_Book_Definition__c);
system.debug('test12' +ed.Price_Book_Definition__c);

}
}

for(Price_Book_Include__c ed : trigger.new)
{
if(pbd_ed.Containskey(ed.Price_Book_Definition__c))
{
for(Price_Book_Include__c edd : pbd_ed.get(ed.Price_Book_Definition__c))
{
if(edd.Product_Model__c == ed.Product_Model__c && edd.Product__c == ed.Product__c && ed.ID != edd.ID)
{
ed.addError('Product Model and Product already exists');
} 

if(edd.Product_Model__c == ed.Product_Model__c && ed.Product_Model__c != null && ed.ID != edd.ID)
{
ed.addError('Product Model already exists');
} 
if(edd.Product__c == ed.Product__c && ed.Product__c != null && ed.ID != edd.ID)
{
ed.addError('Product already exists');

}
}
}
}
}