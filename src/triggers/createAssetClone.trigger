trigger createAssetClone on Asset (after insert,before delete,before update)
{


if(Trigger.isupdate)
{
set<ID> astID = new set<ID>();
List<Asset_Clone__c> astcln = new List<Asset_Clone__c>();
  
  for(asset a : trigger.new)
  {
  asset b = trigger.oldmap.get(a.id);
  if(a.name != b.name || a.Server__c != b.Server__c  || a.Agreement__c  != b.Agreement__c || a.accountID != b.AccountID)
  {
  astID.add(a.ID);  
  }
  }

astcln = [Select ID,name,Account__c,Agreement__c,Server__c,Parent_Asset__c from Asset_Clone__c where Parent_Asset__c  in: astID];

if(!astcln.isEmpty())
{
for(Asset_Clone__c acln : astcln)
{
asset a = Trigger.newmap.get(acln.Parent_Asset__c);

acln.name = a.name;
acln.Account__c = a.AccountID;
acln.Agreement__c = a.Agreement__c;
acln.Server__c = a.Server__c;
}
update astcln;
}

}

 if(trigger.isinsert)
  {
  set<ID> astID = new set<ID>();
  
  for(asset a : trigger.new)
  {
   if(!a.Process_Later__c)  
   {
  astID.add(a.ID);  
  }
  }
  if(!astID.isEmpty())  
  {
  map<ID,asset> astmap = new map<ID,asset>([Select ID,AccountID,CurrencyIsoCode,Name,IsCompetitorProduct,Contact.ID,Description,InstallDate,Price,
                                            PurchaseDate,Quantity,SerialNumber,Status,UsageEndDate,Agreement__r.ID,Company_Number__c,End_Date__c,
                                            License_Option__c,License_Type__c,Part_Number__c,prodpk__c,Product__r.ID,Product_Key__c,Product_Model__r.ID,
                                            Product_Name__c,Quantity__c,Rate__c,SAP_Contract_Item__r.ID,Server__r.ID,Server_ID__c,SKU__c,SKU_Description__c,
                                            Start_Date__c,Product_Status__c,Total__c,Units__c,Usage__c,Users__c                                            
                                            from asset where ID in : astID]);
                                            
  list<asset_clone__c> astcln =new list<asset_clone__c>();  
  
  for(asset ast : trigger.new)
  {
  asset_clone__c tac = new asset_clone__c();
  
  tac.Name = astmap.get(ast.ID).Name;
  tac.CurrencyIsoCode = astmap.get(ast.ID).CurrencyIsoCode;
  tac.Account__c = astmap.get(ast.ID).AccountID; 
  tac.Agreement__c = astmap.get(ast.ID).Agreement__r.ID;  
  tac.Company_Number__c = astmap.get(ast.ID).Company_Number__c;
  tac.IsCompetitorProduct__c = astmap.get(ast.ID).IsCompetitorProduct;
  tac.Contact__c = astmap.get(ast.ID).Contact.ID;
  tac.Description__c = astmap.get(ast.ID).Description;
  tac.End_Date__c = astmap.get(ast.ID).End_Date__c;
  tac.Install_Date__c = astmap.get(ast.ID).InstallDate;
  tac.License_Option__c = astmap.get(ast.ID).License_Option__c;
  tac.License_Type__c = astmap.get(ast.ID).License_Type__c;
  tac.Parent_Asset__c = astmap.get(ast.ID).ID;
  tac.Part_Number__c = astmap.get(ast.ID).Part_Number__c;
  tac.Price__c = astmap.get(ast.ID).Price;
  tac.prodpk__c = astmap.get(ast.ID).prodpk__c;
  tac.Product__c = astmap.get(ast.ID).Product__r.ID;
  tac.Product_key__c = astmap.get(ast.ID).Product_key__c;
  tac.Product_Model__c = astmap.get(ast.ID).Product_Model__r.ID;
  tac.Product_Name__c = astmap.get(ast.ID).Product_Name__c;
  tac.Purchase_Date__c = astmap.get(ast.ID).PurchaseDate;
  tac.Rate__c = astmap.get(ast.ID).Rate__c;
  tac.SAP_Contract_Item__c = astmap.get(ast.ID).SAP_Contract_Item__r.ID;
  tac.Serial_Number__c = astmap.get(ast.ID).SerialNumber;
  tac.Server__c = astmap.get(ast.ID).Server__r.ID;
  tac.Server_ID__c = astmap.get(ast.ID).Server_ID__c;
  tac.SKU__c = astmap.get(ast.ID).SKU__c;
  tac.SKU_Description__c = astmap.get(ast.ID).SKU_Description__c;
  tac.Start_Date__c = astmap.get(ast.ID).Start_Date__c;
  tac.Status__c = astmap.get(ast.ID).Status;
  tac.Product_Status__c = astmap.get(ast.ID).Product_Status__c;
  tac.Total__c = astmap.get(ast.ID).Total__c;
  tac.Units__c = astmap.get(ast.ID).Units__c;
  tac.Usage__c = astmap.get(ast.ID).Usage__c;
  tac.Usage_End_Date__c = astmap.get(ast.ID).UsageEndDate;
  tac.Users__c = astmap.get(ast.ID).Users__c;
  
  astcln.add(tac);
  
  }                                       
                                            
  insert astcln;                                          
  
  }
  }
  
  if(trigger.isdelete)
  {
  
  system.debug(' in Delete');
  
  set<ID> astdel = new set<ID>();
  
  for(asset a : trigger.old)
  {  
  astdel.add(a.ID); 
 // system.debug(' in Delete' +a.ID);
  
  }
  

  
 asset_clone__c[] todel = [select ID from asset_clone__c where parent_asset__c in : astdel];

  
  try
  {
   delete todel;
  }
   catch (DmlException e)
    {
   system.debug(e) ;
    } 
  
  }



}