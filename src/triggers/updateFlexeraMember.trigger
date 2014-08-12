trigger updateFlexeraMember on Contact (after insert,after update,after delete)
{
if(LX_CommonUtilities.ByPassBusinessRule() && !Userinfo.getUsername().contains('sqljobs@')) return; // [AS 07-Aug-13] : Added Bypass code
if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
Set<ID> conId = new Set<ID>();
map<string,Flexera_Member__c> fmap = new map<string,Flexera_Member__c>();   
Set<String> cnum = new set<String>();
List<Flexera_Member__c> fmlist = new List<Flexera_Member__c>();      
Set<ID> AccID = New Set<ID>();
Set<String> portallst = new set<String>{'Customer Portal','Developer Portal','Channel Portal'};
map<ID,Account> global_acc = new map<ID,Account>();
//string FlacID = FlexeraAccount__c.getValues('Perceptive Software').Flexera_Account_ID__c;
string FlacID = FlexeraAccount__c.GETALL().get('Perceptive Software')!=null?FlexeraAccount__c.GETALL().get('Perceptive Software').Flexera_Account_ID__c:null;
List<Flexera_Member__c> fmelist = new List<Flexera_Member__c>(); 
map<ID,ID> cfamap = new map<ID,ID>(); 
Map<String,boolean> createSO = new Map<String,boolean>();    
List<Account> createFa = new List<Account>();
List<Flexera_Account__c> newlst = new List<Flexera_Account__c>();
List<Account> lateracc = new List<Account>();
List<Contact> createSOID = new List<Contact>();
List<Flexera_Member__c> fmupd = new List<Flexera_Member__c>(); 
List<Contact> insList = new List<Contact>();
List<Contact> updList = new List<Contact>();
List<Contact> delList = new List<Contact>();


If(Trigger.isInsert)
{
For(Contact c : Trigger.New)
{
if(c.Flexera_Account_Checkbox__c == true)
{
    if(c.AccountID != null)
    {
        AccID.add(c.AccountID);
    }
    if(c.get('Contact_Number__c') != '')
    {
    insList.add(c);
    cnum.add((String)c.get('Contact_Number__c'));
    }
}
}
}



If(Trigger.isUpdate)
{
For(Contact c : Trigger.New)
{
contact o = trigger.oldmap.get(c.ID);
if(((portallst.contains(C.Portal_User_Type__c)&& c.Portal_User_Status__c == 'Active' && c.Flexera_Account_Checkbox__c != True)&&(c.Portal_User_Type__c != o.Portal_User_Type__c || c.Portal_User_Status__c != o.Portal_User_Status__c ||
c.FirstName != o.FirstName || c.LastName != o.LastName || c.Email != o.Email )))
{
if(c.AccountID != null)
{
AccID.add(c.AccountID);
}
if(c.get('Contact_Number__c') != '')
{
updList.add(c);
cnum.add((String)c.get('Contact_Number__c'));
}
}
if(c.Flexera_Account_Checkbox__c == true && (c.Flexera_Account_Checkbox__c != o.Flexera_Account_Checkbox__c ))
{
if(c.AccountID != null)
{
AccID.add(c.AccountID);
}
if(c.get('Contact_Number__c') != '')
{
cnum.add((String)c.get('Contact_Number__c'));
}
}
}
}

// Trigger.DELETE-----------------------------------------

if(Trigger.IsDelete)
{
for(Contact con : Trigger.Old)
{
if((portallst.contains(Con.Portal_User_Type__c)&&con.Portal_User_Status__c == 'Active')||(con.Flexera_Account_Checkbox__c == True))
{
delList.add(con);
cnum.add((String)con.get('Contact_Number__c'));    
}
}
}

if(!cnum.isEMpty())    
{

// Rahul Comment 7/24. Switching to dynamic SOQL to leverage the switching of Company_Number__c field.  
/*for(Flexera_Member__c fm :[Select First_Name__c,Last_Name__c,Member_ID__c,Email__c,Address_Line_1__c,City__c,Country__c,Postal_Code__c,
Flexera_Account_ID__r.Account__r.Company_Number__c,Flexera_Account_ID__r.Account__r.Type
 from Flexera_Member__c where Member_ID__c in: cnum])    
{    
fmap.put(fm.Member_ID__c,fm);    
}*/

list<Flexera_Member__c> listOfFlexeraMembers = database.query('Select First_Name__c,Last_Name__c,Member_ID__c,Email__c,Address_Line_1__c,City__c,Country__c,Postal_Code__c,Flexera_Account_ID__r.Account__r.Company_Number__c,Flexera_Account_ID__r.Account__r.Type from Flexera_Member__c where Member_ID__c in: cnum');
for(Flexera_Member__c fm :listOfFlexeraMembers){
    fmap.put(string.valueof(fm.get('Member_ID__c')),fm);
}

if(!Accid.IsEmpty())
{
    
    
// Rahul Comment 7/24. Switching to dynamic SOQL to leverage the switching of Company_Number__c field.  
/*for(Flexera_Member__c fm :[Select First_Name__c,Last_Name__c,Member_ID__c,Email__c,Address_Line_1__c,City__c,Country__c,Postal_Code__c,

for(Account a : [SELECT ID,Type,Name,Company_Number__c, SMA_Status__c, MDM_Sold_To_Number__c,
BillingStreet,
BillingCity,
BillingState,
BillingCountry,
BillingPostalCode,
Physical_Province_Other__c 

 FROM Account where ID in : accid])
{
global_acc.put(a.ID,a);
}*/

list<Account> listOfAccounts = database.query('SELECT ID,Type,Name,Company_Number__c, SMA_Status__c, MDM_Sold_To_Number__c,BillingPostalCode,Physical_Province_Other__c,BillingCity,BillingStreet,BillingState,BillingCountry FROM Account where ID in : accid');
for(Account a :listOfAccounts){
    global_acc.put(a.ID,a);
}


if(Trigger.isUpdate)
{
for(Flexera_Account__c fa : [Select ID,Account__c from Flexera_Account__c where Account__c in : AccID])
    {
    cfamap.put(fa.Account__c,fa.Id);    
    }
for(Flexera_Entitlement_Items__c fe : [Select ID,Catalog_Item_ID__c,Flexera_Entitlement_ID__c,Flexera_Entitlement_ID__r.Account_ID__c,Flexera_Entitlement_ID__r.Flexera_Account_ID__r.Account__c,
Flexera_Entitlement_ID__r.Flexera_Account_ID__c,Flexera_Entitlement_ID__r.SAP_Sales_Order_ID__c from Flexera_Entitlement_Items__c  
where Flexera_Entitlement_ID__r.Flexera_Account_ID__r.Account__c in: AccID])
{
if(fe.Catalog_Item_ID__c == 'PER9999' && fe.Flexera_Entitlement_ID__c != Null && fe.Flexera_Entitlement_ID__r.SAP_Sales_Order_ID__c != Null)
{
createSO.put(fe.Flexera_Entitlement_ID__r.Flexera_Account_ID__r.Account__c,FALSE);
}
}     
}
}


// Trigger.DELETE-----------------------------------------
   
 if(Trigger.IsDelete)
{   
for(Contact c : delList)
{
   if(fmap.containskey((String)c.get('Contact_Number__c')))
   {
   fmlist.add(fmap.get((String)c.get('Contact_Number__c')));   
   }
}  
        if(!fmlist.isempty())
        {
        Delete fmlist; 
        }
}
// Trigger.DELETE-----------------------------------------

// Trigger.INSERT------------------------------------------

if(Trigger.isInsert)
{
for(Contact c : insList)
{
if(c.Flexera_Account_Checkbox__c  == True && global_acc.get(c.AccountID).Type == 'Internal')
{
   Flexera_Member__c fme = new Flexera_Member__c(First_Name__c = c.FirstName,Last_Name__c = c.LastName,Member_ID__c = (String)c.get('Contact_Number__c'),
                                Email__c = c.email);
                                
   fme.Address_Line_1__c = global_acc.get(c.AccountID).BillingStreet;
   //fme.Address_Line_2__c =  global_acc.get(c.AccountID).Physical_Street_Address_2__c; 
   if(global_acc.get(c.AccountID).BillingCountry == 'United States')
   {
   fme.State__c = global_acc.get(c.AccountID).BillingState;   
   }
   else
   {
   fme.State__c = global_acc.get(c.AccountID).Physical_Province_Other__c;
   }   
   fme.City__c = global_acc.get(c.AccountID).BillingCity;
   fme.Country__c = global_acc.get(c.AccountID).BillingCountry;
   fme.Postal_Code__c = global_acc.get(c.AccountID).BillingPostalCode;                                  
   fme.Flexera_Account_ID__c = FlacID;
   fmelist.add(fme);    
}
}
}

// Trigger.INSERT------------------------------------------

system.debug('>>>>>>>>>>>>'+updList);

//Trigger.Update--------------------------------------------------------------
if(Trigger.isUpdate && !updList.isEmpty())
{
for(Contact c : updList)
{
if(!(global_acc.get(c.AccountID).Type == 'Internal'))
{
if(!cfaMap.Containskey(c.AccountID))
{
createFa.add(global_acc.get(c.AccountID));
}
}
}
if(!createFa.isEmpty())
{
newlst = CreateFlexeraAccount.Create(createFa);
 
for(Flexera_Account__c fa : newLst)
{
cfaMap.put(fa.Account__c , fa.ID);
}
}
for(Contact c : updList)
{
if(global_acc.containskey(c.AccountID))
{
if(((global_acc.get(c.AccountID).Type != 'Internal')&&(global_acc.get(c.AccountID).Type != 'Customer')))
{
if(!createSO.containskey(c.AccountID))
{
createSOID.add(c);  
}
}
}
}
if(!createSOID.isEmpty())
{
CreateFlexeraAccount.createSalesOrder(createSOID,cfaMap,global_acc);
}

for(Contact c : Trigger.New)
{
contact o = trigger.oldmap.get(c.ID);
if(c.Flexera_Account_Checkbox__c == true && global_acc.get(c.AccountID).type == 'Internal' && c.Flexera_Account_Checkbox__c != o.Flexera_Account_Checkbox__c)
{
if(fmap.containskey((String)c.get('Contact_Number__c')))
{

}
else if(!fmap.containskey((String)c.get('Contact_Number__c')))
{
Flexera_Member__c fme = new Flexera_Member__c(First_Name__c = c.FirstName,Last_Name__c = c.LastName,Member_ID__c = (String)c.get('Contact_Number__c'),
                                Email__c = c.email);
                                
   fme.Address_Line_1__c = global_acc.get(c.AccountID).BillingStreet;
   //fme.Address_Line_2__c =  global_acc.get(c.AccountID).Physical_Street_Address_2__c; 
   if(global_acc.get(c.AccountID).BillingCountry == 'United States')
   {
   fme.State__c = global_acc.get(c.AccountID).BillingState;   
   }
   else
   {
   fme.State__c = global_acc.get(c.AccountID).Physical_Province_Other__c;
   }   
   fme.City__c = global_acc.get(c.AccountID).BillingCity;
   fme.Country__c = global_acc.get(c.AccountID).BillingCountry;
   fme.Postal_Code__c = global_acc.get(c.AccountID).BillingPostalCode;                                  
   fme.Flexera_Account_ID__c = FlacID;
   fmelist.add(fme);  

}
}

if(((portallst.contains(C.Portal_User_Type__c) && c.Portal_User_Status__c == 'Active'  && c.Flexera_Account_Checkbox__c != True)&&(c.Portal_User_Type__c != o.Portal_User_Type__c || c.Portal_User_Status__c != o.Portal_User_Status__c ||
c.FirstName != o.FirstName || c.LastName != o.LastName || c.Email != o.Email )))
{
if(fmap.containskey((String)c.get('Contact_Number__c')))
{
Flexera_Member__c fm = fmap.get((String)c.get('Contact_Number__c'));    
   fm.First_Name__c = c.FirstName;
   fm.Last_Name__c = c.LastName;
   fm.Member_ID__c = (String)c.get('Contact_Number__c');
   fm.Email__c = c.email;
   
   //US1749 Pull Addres from Account
   
   fm.Address_Line_1__c = global_acc.get(c.AccountID).BillingStreet;
  // fm.Address_Line_2__c =  global_acc.get(c.AccountID).Physical_Street_Address_2__c; 
   if(global_acc.get(c.AccountID).BillingCountry == 'United States')
   {
   fm.State__c = global_acc.get(c.AccountID).BillingState;   
   }
   else
   {
   fm.State__c = global_acc.get(c.AccountID).Physical_Province_Other__c;
   }
   fm.City__c = global_acc.get(c.AccountID).BillingCity;
   fm.Country__c = global_acc.get(c.AccountID).BillingCountry;
   fm.Postal_Code__c = global_acc.get(c.AccountID).BillingPostalCode;
      
   //US1749 Pull Addres from Account
    
   fm.Status__c = c.Portal_User_Status__c;       
   fm.Flexera_Account_ID__c = cfamap.get(c.AccountID); 
  
    fmupd.add(fm);
}
else if(!fmap.containskey((String)c.get('Contact_Number__c')))
{
Flexera_Member__c fme = new Flexera_Member__c(First_Name__c = c.FirstName,Last_Name__c = c.LastName,Member_ID__c = (String)c.get('Contact_Number__c'),
                                Email__c = c.email);
                                
   fme.Address_Line_1__c = global_acc.get(c.AccountID).BillingStreet;
   //fme.Address_Line_2__c =  global_acc.get(c.AccountID).Physical_Street_Address_2__c; 
   if(global_acc.get(c.AccountID).BillingCountry == 'United States' || global_acc.get(c.AccountID).BillingCountry == 'United States of America' || global_acc.get(c.AccountID).BillingCountry == 'US' || global_acc.get(c.AccountID).BillingCountry == 'USA')
   {
   fme.State__c = global_acc.get(c.AccountID).BillingState;   
   }
   else
   {
   fme.State__c = global_acc.get(c.AccountID).Physical_Province_Other__c;
   }   
   fme.City__c = global_acc.get(c.AccountID).BillingCity;
   fme.Country__c = global_acc.get(c.AccountID).BillingCountry;
   fme.Postal_Code__c = global_acc.get(c.AccountID).BillingPostalCode;                                  
   fme.Flexera_Account_ID__c = cfamap.get(c.AccountID); 
   fmelist.add(fme); 

}
}
}
}


//Trigger.Update--------------------------------------------------------------
system.debug('>>>>>>>>>>+++'+fmelist);
system.debug('##############'+fmupd);
if(!fmelist.IsEmpty())
    {
        insert fmelist;
    }
   if(!fmupd.IsEmpty())
    {
          update fmupd;         
    }
    }

}