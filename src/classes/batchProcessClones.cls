Global class batchProcessClones implements Database.Batchable<sObject>
{
Global final String Query;
Global Map<ID,ID> ast_astcln;    
Global Map<ID,ID> astit_astitcln;    
Global final boolean isAsset;    
Global final boolean isAssetItem;
Global final boolean isLicense;
    
    Global batchProcessClones(String q,string typ)
    {
        Query = q;
        if(typ == 'Asset')
        {
         isAsset = True; 
         isAssetItem = False;
         isLicense = False;
        }  
    }
    Global batchProcessClones(String q,string typ,map<ID,ID>astmap)
    {
        Query = q;
        if(typ == 'AssetItem')
        {
         ast_astcln = new map<ID,ID>();
         isAsset = False; 
         isAssetItem = True;
         isLicense = False;  
         ast_astcln.putall(astmap);    
        }
    }
     Global batchProcessClones(String q,string typ,map<ID,ID> astmap,map<ID,ID> astitmmap)
    {
        Query = q;
        if(typ == 'licenseKey')
        {
         ast_astcln = new map<ID,ID>();
         astit_astitcln = new map<ID,ID>();   
         isAsset = False; 
         isAssetItem = False;
         isLicense = True;
         ast_astcln.putall(astmap);    
         astit_astitcln.putall(astitmmap)   ;
        }       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    return Database.getQueryLocator(Query);        
    }
    
    global void execute(Database.BatchableContext BC,  List<sObject> recordList)
    {
        
        if(recordList.getSObjectType() == Asset.sObjectType)
        {
        ast_astcln = new Map<ID,ID>();
        list<asset_clone__c> astcln =new list<asset_clone__c>();
        list<asset> astlst =new list<asset>();    
        if(!recordList.isEmpty())
        {
        for(sObject ast : recordList)
        {
  Asset astmap = (Asset)ast;
            
            
  asset_clone__c tac = new asset_clone__c();
  
  tac.Name = astmap.Name;
  tac.CurrencyIsoCode = astmap.CurrencyIsoCode;
  tac.Account__c = astmap.AccountID; 
  tac.Agreement__c = astmap.Agreement__r.ID;  
  tac.Company_Number__c = astmap.Company_Number__c;
  tac.IsCompetitorProduct__c = astmap.IsCompetitorProduct;
  tac.Contact__c = astmap.Contact.ID;
  tac.Description__c = astmap.Description;
  tac.End_Date__c = astmap.End_Date__c;
  tac.Install_Date__c = astmap.InstallDate;
  tac.License_Option__c = astmap.License_Option__c;
  tac.License_Type__c = astmap.License_Type__c;
  tac.Parent_Asset__c = astmap.ID;
  tac.Part_Number__c = astmap.Part_Number__c;
  tac.Price__c = astmap.Price;
  tac.prodpk__c = astmap.prodpk__c;
  tac.Product__c = astmap.Product__r.ID;
  tac.Product_key__c = astmap.Product_key__c;
  tac.Product_Model__c = astmap.Product_Model__r.ID;
  tac.Product_Name__c = astmap.Product_Name__c;
  tac.Purchase_Date__c = astmap.PurchaseDate;
  tac.Rate__c = astmap.Rate__c;
  tac.SAP_Contract_Item__c = astmap.SAP_Contract_Item__r.ID;
  tac.Serial_Number__c = astmap.SerialNumber;
  tac.Server__c = astmap.Server__r.ID;
  tac.Server_ID__c = astmap.Server_ID__c;
  tac.SKU__c = astmap.SKU__c;
  tac.SKU_Description__c = astmap.SKU_Description__c;
  tac.Start_Date__c = astmap.Start_Date__c;
  tac.Status__c = astmap.Status;
  tac.Product_Status__c = astmap.Product_Status__c;
  tac.Total__c = astmap.Total__c;
  tac.Units__c = astmap.Units__c;
  tac.Usage__c = astmap.Usage__c;
  tac.Usage_End_Date__c = astmap.UsageEndDate;
  tac.Users__c = astmap.Users__c;
  
  astcln.add(tac); 
            
  astmap.Process_Later__c  = False;      
  astlst.add(astmap);      
        }
            if(!astcln.isEmpty())
            {
            insert astcln;
                
                for(Asset_Clone__c ascl : astcln)
                {
                 system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +ascl.id);   
                 system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +ascl.Parent_Asset__c);   
                ast_astcln.put(ascl.Parent_Asset__c,ascl.id);
                }                
            }
            
            if(!astlst.isEmpty())
            {
                update astlst;
            }
            
        }
        }
        
        if(recordList.getSObjectType() == Asset_Item__c.sObjectType)
        {
        astit_astitcln = new map<Id,Id>();
        list<asset_Item_clone__c> astitmcln =new list<asset_Item_clone__c>();  
        list<asset_Item__c> astitlst =new list<asset_Item__c>();      
        if(!recordList.isEmpty())
        {   
        for(sObject ast : recordList)
        {
  Asset_Item__c astmap = (Asset_Item__c)ast;          
  asset_Item_clone__c tac = new asset_item_clone__c();
         if(astmap.Process_Later__c)
  {
  asset_item_clone__c astitcln = new asset_item_clone__c();
  List<asset_item_clone__c> astcln = new List<asset_item_clone__c>();
  astitcln.name=astmap.name;
  astitcln.CurrencyIsoCode=astmap.CurrencyIsoCode;
  if(ast_astcln.containskey(astmap.Asset__c))
      {
  astitcln.asset_clone__c = ast_astcln.get(astmap.Asset__c);
      }
  astitcln.End_Date__c=astmap.End_Date__c;
  astitcln.Opportunity__c=astmap.Opportunity__r.ID;
  astitcln.Parent_Asset_Item__c=astmap.ID;
  astitcln.Product__c=astmap.Product__r.ID;
  astitcln.Price_Type__c = astmap.Price_Type__c;
  astitcln.Quantity__c=astmap.Quantity__c;
  astitcln.SAP_Contract_Item__c=astmap.SAP_Contract_item__r.ID;
  astitcln.Server__c=astmap.Server__r.ID;
  astitcln.Start_Date__c=astmap.Start_Date__c;
  astitcln.Status__c=astmap.Status__c;
  
  astitmcln.add(astitcln);
      
   astmap.Process_Later__c = False;   
   astitlst.add(astmap);
  } 
            
            
        }
         if(!astitmcln.isEmpty())
         {
         insert astitmcln;
             
              for(Asset_Item_Clone__c ascl : astitmcln)
                {
                astit_astitcln.put(ascl.Parent_Asset_Item__c,ascl.id);
                }  
         } 
            
            if(!astitlst.isEmpty())
         {
             Update astitlst;
         }
        }        
        }
        
        if(recordList.getSObjectType() == License_Key__c.sObjectType)
        {
        list<license_key_clone__c> lickey =new list<license_key_clone__c>();  
        list<license_key__c> lickeylst =new list<license_key__c>();  
        if(!recordList.isEmpty())
        {
        for(sObject ast : recordList)
        {    
        License_Key__c astmap = (License_Key__c)ast;          
        License_Key_clone__c tac = new License_Key_clone__c();
         if(astmap.Process_Later__c)
        {
            
  tac.name=astmap.name;
  tac.CurrencyIsoCode=astmap.CurrencyIsoCode;
  tac.Account__c=astmap.Account__r.ID;
  if(ast_astcln.containskey(astmap.Asset__c))
  {
  tac.asset_clone__c = ast_astcln.get(astmap.Asset__c); 
  }
  if(astit_astitcln.containskey(astmap.Asset_Item__c))
  {          
  tac.Asset_Item_Clone__c = astit_astitcln.get(astmap.Asset_Item__c);
  }
  tac.Company_Number__c=astmap.Company_Number__c;
  tac.Contract__c=astmap.Contract__r.ID;
  tac.Contract_ID__c=astmap.Contract_ID__c;
  tac.Expiration_Date__c=astmap.Expiration_Date__c;
  tac.Parent_License_Key__c=astmap.ID;
  tac.Product_Key__c=astmap.Product_Key__c;
  tac.Quantity__c=astmap.Quantity__c;
  tac.Server__c=astmap.Server__r.ID;
  tac.Server_ID__c=astmap.Server_ID__c;
  tac.SKU_Description__c=astmap.SKU_Description__c;
  tac.Status__c=astmap.Status__c; 
  
       lickey.add(tac);
            astmap.Process_Later__c = False;
            lickeylst.add(astmap);
            
        }
        }
          if(!lickey.isEmpty())  
          {
          insert lickey;
          }
            
            if(!lickeylst.isEmpty())  
          {
          update lickeylst;
          }
            
        }        
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
    if(isAsset)
    {        
    string q = 'Select ID,CurrencyIsoCode,Name,Asset__c,Asset__r.server__r.ID,End_date__c,Opportunity__r.ID,Product__r.ID,Quantity__c,SAP_Contract_item__r.ID,Server__r.ID,Start_Date__c,Status__c,Price_Type__c,Process_Later__c from asset_item__c where Process_Later__c = true';
    string ty = 'AssetItem';    
    map<ID,ID> it_itc = new map<ID,ID>();
    set<ID> astset = new set<ID>();    
    List<Asset_Clone__c> clnlst = new List<Asset_Clone__c>();    
    
    List<Asset_Item__c> qlst = [Select ID,CurrencyIsoCode,Name,Asset__c,Asset__r.server__r.ID,End_date__c,
                                Opportunity__r.ID,Product__r.ID,Quantity__c,SAP_Contract_item__r.ID,Server__r.ID,
                                Start_Date__c,Status__c,Price_Type__c,Process_Later__c from asset_item__c 
                                where Process_Later__c = true];
                                
                               if(!qlst.isEMpty())
                                {
                                for(Asset_Item__c atm : qlst)
                                {
                                astset.add(atm.Asset__c);
                                }
                                clnlst = [Select ID,Parent_Asset__c from Asset_Clone__c where Parent_Asset__c in :astset];
                                if(!clnlst.isEmpty())
                                {
                                    for(Asset_Clone__c ac : clnlst)
                                    {
                                    it_itc.put(ac.Parent_Asset__c,ac.id);
                                    }
                                }
                                }
      
       batchProcessClones batchController = new batchProcessClones(q,ty,it_itc); 
       Database.executeBatch(batchController);
    }
    
        if(isAssetItem)
        {
        string q = 'Select ID,CurrencyIsoCode,Name,Account__r.ID,Asset__c,Asset_Item__c,Asset_item__r.server__r.ID,Company_Number__c,Contract__r.ID,Contract_ID__c,Exclude__c,Expiration_Date__c,Product_Key__c,Quantity__c,Server__r.ID,Server_ID__c,SKU_Description__c,Status__c,Process_Later__c from license_key__c where Process_Later__c = true';    
        string ty = 'licenseKey'; 
        map<ID,ID> it_itc = new map<ID,ID>();
        map<ID,ID> at_atc = new map<ID,ID>();
        List<license_key__c> lst1 = new List<license_key__c>();    
        Set<ID> astid = new Set<ID>();    
        Set<ID> astitmid = new Set<ID>();
           
           lst1 = [Select ID,CurrencyIsoCode,Name,Account__r.ID,Asset__c,Asset_Item__c,Asset_item__r.server__r.ID,Company_Number__c,Contract__r.ID,Contract_ID__c,Exclude__c,Expiration_Date__c,Product_Key__c,Quantity__c,Server__r.ID,Server_ID__c,SKU_Description__c,Status__c,Process_Later__c from license_key__c where Process_Later__c = true];
           if(!lst1.isEMpty())
           {
           for(license_key__c lkc : lst1)
           {
           astid.add(lkc.Asset__c);
           astitmid.add(lkc.Asset_Item__c);    
           }
           if(!astid.isEmpty())
           {
               List<Asset_Clone__c> aclst1 = [Select ID,Parent_Asset__c from Asset_Clone__c where Parent_Asset__c in :astid];
               if(!aclst1.isEmpty())
               {
               for(Asset_Clone__c ac : aclst1)               
               {
               at_atc.put(ac.Parent_Asset__c,ac.id);
               }
               }
           }
            if(!astitmid.isEmpty())   
            {
             List<Asset_Item_Clone__c> aclst2 = [Select ID,Parent_Asset_Item__c from Asset_Item_Clone__c where Parent_Asset_Item__c in :astitmid];
               if(!aclst2.isEmpty())
               {
               for(Asset_Item_Clone__c ac : aclst2)               
               {
               it_itc.put(ac.Parent_Asset_Item__c,ac.id);
               }
               }
            }
           } 
        
       batchProcessClones batchController = new batchProcessClones(q,ty,at_atc,it_itc); 
       Database.executeBatch(batchController);     
            
        }
        
        if(isLicense)
        {
        
        }
    }    
}