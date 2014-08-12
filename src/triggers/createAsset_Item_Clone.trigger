trigger createAsset_Item_Clone on Asset_item__c (after insert,after update,before delete)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
 if(trigger.isinsert)
  {
  
  set<ID> astID = new set<ID>();
  set<ID> upgradeID = new Set<ID>();
  Map<ID,ID> ast_up = new Map<ID,ID>();
  
  for(asset_item__c a : trigger.new)
  {
  if(!a.Process_Later__c)
  {
  astID.add(a.ID); 
  }
  }
  if(!astID.isEmpty())
  {
  map<ID,asset_item__c> astmap = new map<ID,asset_item__c>([Select ID,CurrencyIsoCode,Name,Asset__c,Asset__r.server__r.ID,End_date__c,Opportunity__r.ID,Product__r.ID,
                                                            Quantity__c,SAP_Contract_item__r.ID,Server__r.ID,Start_Date__c,Status__c,Price_Type__c,Price_Type_Description__c,Upgrade_From__c
                                                            from asset_item__c where ID in : astID]);
                                                            

map<ID,ID> parastID = new map<ID,ID>();      //Maps Asset_item ID with ASSETID

set<ID> usethisID = new set<ID>();

  for(asset_item__c a : trigger.new)
  {
 parastID.put(a.ID,a.asset__c);
 usethisID.add(a.asset__c);
 if(a.Upgrade_From__c != null)
 {
 upgradeID.add(a.Upgrade_From__c);
 }
 system.debug('asset item ID' +a.ID);
 system.debug('asset ID' +a.asset__c);
 
  }
  
  if(!upgradeID.isEmpty())
  {
  List<Asset_Item_Clone__c> astitcln = new List<Asset_Item_Clone__c>();
  
  astitcln = [Select ID,Parent_Asset_Item__c from Asset_Item_Clone__c where Parent_Asset_Item__c in: upgradeID];
  
  if(!astitcln.isEmpty())
  {
  for(Asset_Item_Clone__c ac : astitcln)
  {
  ast_up.put(ac.Parent_Asset_Item__c,ac.id);
  }
  }
  }
  
 map<ID,ID> tmp = new map<ID,ID>();   //Maps AssetID with asset clone ID

  
for(asset_clone__c ac :[select ID,parent_asset__c from Asset_clone__c where parent_asset__c in : usethisID])
  {
  if(ac.ID != null) 
  {
  tmp.put(ac.Parent_asset__c,ac.ID);
  
 system.debug('asset clone ID' +ac.ID);
 //system.debug('Parent asset ID' +ac.Parent_asset__r);
 
  }
  }
 
  
  list<asset_item_clone__c> astcln = new list<asset_item_clone__c>();
  
  for(asset_item__c ast : trigger.new)
  {
  if(!ast.Process_Later__c)
  {
  asset_item_clone__c tac = new asset_item_clone__c();
  // system.debug('check this' +tmp.get(s));
  tac.name=astmap.get(ast.ID).name;
  tac.CurrencyIsoCode=astmap.get(ast.ID).CurrencyIsoCode;
  tac.asset_clone__c = tmp.get(parastID.get(ast.ID));
  tac.End_Date__c=astmap.get(ast.ID).End_Date__c;
  tac.Opportunity__c=astmap.get(ast.ID).Opportunity__r.ID;
  tac.Parent_Asset_Item__c=astmap.get(ast.ID).ID;
  tac.Product__c=astmap.get(ast.ID).Product__r.ID;
  tac.Price_Type__c = astmap.get(ast.ID).Price_Type__c;
  tac.Quantity__c=astmap.get(ast.ID).Quantity__c;
  tac.SAP_Contract_Item__c=astmap.get(ast.ID).SAP_Contract_item__r.ID;
  tac.Server__c=astmap.get(ast.ID).Server__r.ID;
  tac.Start_Date__c=astmap.get(ast.ID).Start_Date__c;
  tac.Status__c=astmap.get(ast.ID).Status__c;
  tac.Price_Type_Description__c = astmap.get(ast.ID).Price_Type_Description__c;
  if(astmap.get(ast.ID).Upgrade_From__c != null && ast_up.containskey(astmap.get(ast.ID).Upgrade_From__c))
  {  
  tac.Upgrade_From__c = ast_up.get(astmap.get(ast.ID).Upgrade_From__c);  
  }
  astcln.add(tac);
  } 
  }                                       
                                            
  insert astcln;                                          
  
  }
  }
  
  if(trigger.isupdate)
  {
  set<ID> astID = new set<ID>();
  set<ID> upgradeID = new Set<ID>();
  Map<ID,asset_item__c> astitmmap = new Map<ID,asset_item__c>();
  List<Asset_Item_clone__c> clnlist = new   List<Asset_Item_clone__c>();
  for(asset_item__c a : trigger.new)
  {
  if(!a.Process_Later__c && (trigger.oldmap.get(a.id).Status__c != a.status__c || trigger.oldmap.get(a.id).Exclude__c != a.Exclude__c))
  {
  astID.add(a.ID); 
  astitmmap.put(a.id,a);
  }
  }
  
  if(!astID.isEMpty())
  {
  clnlist = [Select ID,Parent_Asset_Item__c from Asset_Item_Clone__c where Parent_Asset_Item__c in: astID];
  
  if(!clnlist.isEMpty())
  {
  for(Asset_Item_Clone__c AIC : CLNLIST)
  {
  aic.sTATUS__C = astitmmap.get(AIC.Parent_Asset_Item__c).Status__c;
  aic.Exclude__C = astitmmap.get(AIC.Parent_Asset_Item__c).Exclude__C;
  }
  update CLNLIST;
  }  
  }
  }
  
   
  if(trigger.isdelete)
  {
  system.debug(' in Delete');
  
  set<ID> astitmdel = new set<ID>();
  
  for(asset_item__c a : trigger.old)
  {  
  astitmdel.add(a.ID); 
   
  }
  

  
 asset_item_clone__c[] todel = [select ID from asset_item_clone__c where parent_asset_item__c in : astitmdel];

  
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