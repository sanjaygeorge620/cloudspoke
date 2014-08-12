public class CreateFlexeraAccount
{
Public Static List<Flexera_Account__c> Create(List<Account> accLst)
{
List<Flexera_Account__c> returnlst = new List<Flexera_Account__c>();

for(Account a : accLst)
        {           
            Flexera_Account__c flac = new Flexera_Account__c();
            flac.Account__c = a.ID;
            String strAccId = '';
            if(a.get('Company_Number__c') != null)
                strAccId = String.valueOf(a.get('Company_Number__c'));
            flac.Account_Id__c = strAccId;
            flac.Account_Name__c = a.Name;
            flac.Account_Status__c = 'Active';                //for US1700
            flac.MDM_Sold_To__c = a.MDM_Sold_To_Number__c; 
            returnlst.add(flac);       
            
        }   
insert returnlst;        
return returnlst;
}
Public Static Void createSalesOrder(List<Contact> conlst,map<ID,ID> flamap,map<ID,Account> glob)
{
Date myDate = date.newinstance(2099, 12, 31);
List<SAP_Sales_Order__c> soIns = new List<SAP_Sales_Order__c>();
List<SAP_Sales_Order__c> soInsLat = new List<SAP_Sales_Order__c>();
List<Flexera_Entitlement__c> FleLst = new List<Flexera_Entitlement__c>();
List<Flexera_Entitlement_Items__c> FleiLst = new List<Flexera_Entitlement_Items__c>();
for(Contact c : conlst)
{
SAP_Sales_Order__c so = new SAP_Sales_Order__c();
so.Account_DEV_Channel__c = c.AccountID;
if(c.Portal_User_Type__c.contains('Channel'))
{
so.Portal__c = 'Channel';
}
else if(c.Portal_User_Type__c.contains('Developer'))
{
so.Portal__c = 'Developer';
}
soIns.add(so); 
}
Insert soIns;
Set<ID> sids = new Set<ID>();
for(SAP_Sales_Order__c sco: soIns)
{
sids.add(sco.id);
}
if(!sids.isEmpty())
{
soInsLat = [Select ID,SAP_Sales_Order_Number__c,Account_DEV_Channel__c,Portal__c from SAP_Sales_Order__c  where ID in: sids];
}
if(!soInsLat.isEmpty())
{
for(SAP_Sales_Order__c sop : soInsLat)
{
Flexera_Entitlement__c fle = new Flexera_Entitlement__c();

String strAccId = '';
if(glob.get(sop.Account_DEV_Channel__c)!= null && glob.get(sop.Account_DEV_Channel__c).get('Company_Number__c') != null)
    strAccId = String.valueOf(glob.get(sop.Account_DEV_Channel__c).get('Company_Number__c'));
fle.Account_ID__c = strAccId;
fle.Account_Name__c = glob.get(sop.Account_DEV_Channel__c).Name;
fle.Flexera_Account_ID__c = flamap.get(sop.Account_DEV_Channel__c);
fle.Order_Date__c = Date.Today();
fle.Order_ID__c = sop.SAP_Sales_Order_Number__c; 
fle.SAP_Sales_Order_ID__c = sop.ID;
FleLst.add(fle); 
}
if(!FleLst.isEmpty())
{
Insert FleLst;
}
for(Flexera_Entitlement__c Fe : FleLst)
{
Flexera_Entitlement_Items__c FLEI = New Flexera_Entitlement_Items__c();
FLEI.Catalog_Item_ID__c = 'PER9999';
FLEI.Catalog_Item_Name__c = 'Master Part List for Entitlements';
FLEI.Effective_Date__c = Date.Today();
FLEI.Expiration_Date__c = myDate;    
FLEI.Flexera_Entitlement_ID__c = Fe.ID;
FLEI.Quantity__c = 1;
FLEI.Status__c = 'Active';
FleiLst.add(FLEI);
}
if(!FleiLst.isEmpty())
{
Insert FleiLst;
}
}
}
}