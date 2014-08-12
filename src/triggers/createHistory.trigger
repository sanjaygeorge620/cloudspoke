trigger createHistory on Product2 (before update)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
//Rahul Updated the variables as static variables to prevent describe limits
static Map<String, Schema.SObjectType> schemaMap ;
static Schema.SObjectType productSchema ;
static Map<String, Schema.SObjectField> fieldMap ;
static Schema.DescribeSObjectResult r;

If(FirstRun_Check.FirstRun_ProdHistory)
{



if(schemaMap == null){
    schemaMap = Schema.getGlobalDescribe();
}

if(productSchema == null){
    productSchema = schemaMap.get('Product2');
}

if(fieldMap == null){
    fieldMap = productSchema.getDescribe().fields.getMap();
}

if(r == null){
    r = productSchema.getDescribe();
}

map<String,History__c> mapset = History__c.getAll();
List<History_Tracking__c> htrList = new List<History_Tracking__c>();
system.debug(mapset.keyset());

for(Product2 pr : Trigger.new)
{
History_Tracking__c htr = new History_Tracking__c();
htr.Date__c = System.Now();
htr.user__c = UserInfo.getUserId();
htr.Product__c = pr.id;
boolean isins = false;
product2 oldpr = Trigger.oldmap.get(pr.id);
string st = '';
for(string str : mapset.keyset())
{

if(pr.get(str) != oldpr.get(str))
{
//Schema.SObjectType t = Schema.getGlobalDescribe().get('Product2');
Schema.DescribeFieldResult f = r.fields.getMap().get(str).getDescribe();
string lab = fieldMap.get(str).getDescribe().getLabel();
if (f.getType() == Schema.DisplayType.Currency)
{
st = st + 'Changed   '+'<b>'+ lab +'</b>'+'    from    ' + oldpr.CurrencyISOCode +' '+ oldpr.get(str) + '    to    ' + pr.CurrencyISOCode +' '+ pr.get(str) + '<br>';
}
else
{
st = st + 'Changed   '+'<b>'+ lab +'</b>'+'    from    ' + oldpr.get(str) + '    to    ' + pr.get(str) + '<br>';
}
isins = true;
}
}
if(isins)
{
htr.Activity__c = st;
htrList.add(htr);
}
}
if(!htrList.isEmpty())
{
insert htrList;
}
}
FirstRun_Check.FirstRun_ProdHistory = False;
}