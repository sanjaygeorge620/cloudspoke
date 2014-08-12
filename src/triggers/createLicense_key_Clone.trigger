trigger createLicense_key_Clone on License_key__c (after insert,before delete)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
 if(trigger.isinsert)
  {
  set<ID> astID = new set<ID>();
  
  for(license_key__c a : trigger.new)
  {
  if(!a.Process_Later__c)
  {
  astID.add(a.ID);  
  }
  }
  if(!astID.isEmpty())
  {
  map<ID,license_key__c> astmap = new map<ID,license_key__c>([Select ID,CurrencyIsoCode,Name,Account__r.ID,Asset__c,Asset_Item__c,Asset_item__r.server__r.ID,
                                                              Company_Number__c,Contract__r.ID,Contract_ID__c,Exclude__c,Expiration_Date__c,
                                                              Product_Key__c,Quantity__c,Server__r.ID,Server_ID__c,SKU_Description__c,Status__c
                                                              from license_key__c where ID in : astID]);
  
  

  map<ID,ID> lk_ast_map = new map<ID,ID>();
  map<ID,ID> lk_astitm_map = new map<ID,ID>();
  
  set<ID> astitmID = new set<ID>();
  set<ID> asetID = new set<ID>();
  
  for(license_key__c lkk : trigger.new)
  {
  
  lk_ast_map.put(lkk.ID,lkk.asset__c);
  asetID.add(lkk.asset__c);
  
  lk_astitm_map.put(lkk.ID,lkk.asset_item__c);
  astitmID.add(lkk.asset_item__c);
  
  }
  
  map<ID,ID> ast_astcln_map = new map<ID,ID>();
  map<ID,ID> astitm_astitmcln_map = new map<ID,ID>();
  
  
  
  for(asset_clone__c ac :[select ID,parent_asset__c from Asset_clone__c where parent_asset__c in : asetID])
  {
  if(ac.ID != null) 
  {
  ast_astcln_map.put(ac.parent_asset__c,ac.ID);
  }  
  }
  
  
  for(asset_item_clone__c ac :[select ID,parent_asset_item__c from Asset_item_clone__c where parent_asset_item__c in : astitmID])
  {
  if(ac.ID != null) 
  {
  astitm_astitmcln_map.put(ac.parent_asset_item__c,ac.ID);
  }  
  }
  
  list<license_key_clone__c> astcln = new list<license_key_clone__c>();
  
  for(license_key__c ast : trigger.new)
  {
  license_key_clone__c tac = new license_key_clone__c();

  tac.name=astmap.get(ast.ID).name;
  tac.CurrencyIsoCode=astmap.get(ast.ID).CurrencyIsoCode;
  tac.Account__c=astmap.get(ast.ID).Account__r.ID;

  tac.asset_clone__c = ast_astcln_map.get(lk_ast_map.get(ast.ID)) ;

  tac.Asset_Item_Clone__c = astitm_astitmcln_map.get(lk_astitm_map.get(ast.ID));

  tac.Company_Number__c=astmap.get(ast.ID).Company_Number__c;
  tac.Contract__c=astmap.get(ast.ID).Contract__r.ID;
  tac.Contract_ID__c=astmap.get(ast.ID).Contract_ID__c;
  tac.Expiration_Date__c=astmap.get(ast.ID).Expiration_Date__c;
  tac.Parent_License_Key__c=astmap.get(ast.ID).ID;
  tac.Product_Key__c=astmap.get(ast.ID).Product_Key__c;
  tac.Quantity__c=astmap.get(ast.ID).Quantity__c;
  tac.Server__c=astmap.get(ast.ID).Server__r.ID;
  tac.Server_ID__c=astmap.get(ast.ID).Server_ID__c;
  tac.SKU_Description__c=astmap.get(ast.ID).SKU_Description__c;
  tac.Status__c=astmap.get(ast.ID).Status__c;
  
  
  astcln.add(tac); 
  }                                       
                                            
  insert astcln;                                          
  
  }
  }
  
  if(trigger.isdelete)
  {
  
   system.debug(' in Delete');
  
  set<ID> astitmdel = new set<ID>();
  
  for(license_key__c a : trigger.old)
  {  
  astitmdel.add(a.ID); 
   
  }
  

  
 license_key_clone__c[] todel = [select ID from license_key_clone__c where parent_license_key__c in : astitmdel];

  
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