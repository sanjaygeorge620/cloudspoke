public class createInstallations_PCSGear
{
public static integer testServerCount;
public static integer liveServerCount;
public static integer foServerCount;
public static Map<ID,Account> accmap;

public static void createfromOppy(Map<OpportunityLineItem,List<Product2>> PGPmap,Boolean isFuture)
{    
Set<ID> ProductRec_ProductModelIds = new Set<ID>();
List<Product2> pdAll = new List<Product2>();
set<ID> oppIDs = new Set<ID>();
set<ID> accIDs = new Set<ID>();
Map<ID,ID> oppIDs_AcctID = new Map<ID,ID>();
Map<ID,ID> oppIDs_AgrID = new Map<ID,ID>();
List<Server__c> existingServ = new List<Server__c>();
List<Asset> existingAsset = new List<Asset>();


for(OpportunityLineItem keyset : PGPmap.keyset())
{
oppIDs.add(keyset.opportunityID);
accIDs.add(keyset.Opportunity.AccountId);
oppIDs_AcctID.put(keyset.opportunityID,keyset.Opportunity.AccountId);
}

existingServ = [Select ID,Name,Server_Type__c,Agreement__c,Account__c from Server__c where Account__c in: accIDs and Agreement__r.name = 'Basic Software Maintenance Agreement-PACSGEAR'];
existingAsset = [Select ID,name,Server__c,AccountID,Agreement__c,Server__r.Server_Type__c,Product_Model__c from Asset where AccountID in: accIDs and Agreement__r.name = 'Basic Software Maintenance Agreement-PACSGEAR'];

accmap = new Map<ID,Account>([Select ID,Name from Account where id in: accIDs]);

for(OpportunityLineItem otm : PGPmap.keyset())
{
pdAll.addall(PGPmap.get(otm));
for(Product2 pd : PGPmap.get(otm))
{
ProductRec_ProductModelIds.add(pd.Product_Model__c);
}
}
     
    
getServerCount(pdAll);

List<Agreement__c> ExistingAgreementList = new List<Agreement__c>();
String ProductModelName = 'Basic Software Maintenance Agreement-PACSGEAR';

ExistingAgreementList = [select Name, account__c from Agreement__c where account__c =:accIDs and name like '%PACSGEAR%'];

for(id keyset : oppIDs_AcctID.keyset())
   {
   boolean agreementfound = false;
   if(!ExistingAgreementList.isEmpty())
   {  
   for(Agreement__c Ag : ExistingAgreementList)
   {
   if(Ag.account__c == oppIDs_AcctID.get(keyset) && !agreementfound)
   {
   oppIDs_AgrID.put(keyset,Ag.id);
   agreementfound = True;
   create_Servers(Ag,existingServ,existingAsset,PGPmap,ProductRec_ProductModelIds,isFuture);
   }
   }
   if(!agreementfound)
   {
      Agreement__c agreement = new Agreement__c();
                    agreement.Account__c = oppIDs_AcctID.get(keyset);
                    agreement.Opportunity__c = keyset;
                    agreement.Name = ProductModelName;
                    agreement.Status__c = 'Active';
                    system.debug('agreement.name: ' + agreement.name);
                    
            insert agreement;  
            oppIDs_AgrID.put(keyset,agreement.id);
   create_Servers(agreement,existingServ,existingAsset,PGPmap,ProductRec_ProductModelIds,isFuture);
   }
   }
   else
   {
 Agreement__c agreement = new Agreement__c();
                    agreement.Account__c = oppIDs_AcctID.get(keyset);
                    agreement.Opportunity__c = keyset;
                    agreement.Name = ProductModelName;
                    agreement.Name = ProductModelName;
                    agreement.Status__c = 'Active';
                    system.debug('agreement.name: ' + agreement.name);
                    
            insert agreement;  
            oppIDs_AgrID.put(keyset,agreement.id);
    create_Servers(agreement,existingServ,existingAsset,PGPmap,ProductRec_ProductModelIds,isFuture);
   }   
   }
}

public static void getServerCount(List<Product2> prodlst)
{
for(Product2 pd : prodlst)
{
testServerCount = 0;
liveServerCount = 0;
foServerCount = 0;

if((ifnull(pd.Test_Environments_Needed__c)).intValue() > testServerCount)
{
testServerCount = (ifnull(pd.Test_Environments_Needed__c)).intValue();
}

if((ifnull(pd.Failover_Environments_Needed__c)).intValue() > foServerCount)
{
foServerCount = (ifnull(pd.Failover_Environments_Needed__c)).intValue();
}
}
}

public static void create_Servers(Agreement__c agr,List<Server__c> extServ,List<Asset> extAsset,Map<OpportunityLineItem,List<Product2>> PGR_Map,Set<ID> ProductRec_ProductModelIds,Boolean isFuture)
{
List<Server__c> extliveServ = new List<Server__c>();
List<Server__c> exttestServ = new List<Server__c>();
List<Server__c> extfoServ = new List<Server__c>();

Map<ID,List<Asset>> liveastMap = new Map<ID,List<Asset>>();
Map<ID,List<Asset>> testastMap = new Map<ID,List<Asset>>();
Map<ID,List<Asset>> FOastMap = new Map<ID,List<Asset>>();
    
    
    Map<String,OpportunityLineItem> PCG_soln_Parent = new Map<String,OpportunityLineItem>();    
    Map<String,OpportunityLineItem> PCSolnMap = new Map<String,OpportunityLineItem>();
            for(OpportunityLineItem keyset : PGR_Map.KeySet())
            {
            if(String.isNotBlank(keyset.LX_Solution_Parent_Value__c))    
            {
                PCG_soln_Parent.put(keyset.LX_Solution_Parent_Value__c,keyset);                
            }
            }
    
         for(OpportunityLineItem keyset : PGR_Map.KeySet())
            {
                if(String.isNotBlank(keyset.LX_Solution_Sub_Item_Value__c) && PCG_soln_Parent.containskey(keyset.LX_Solution_Sub_Item_Value__c))
                {
                for(Product2 pd: PGR_Map.get(keyset))
                {                    
                   PCSolnMap.put(pd.Part_number__c,PCG_soln_Parent.get(keyset.LX_Solution_Sub_Item_Value__c));
                }                    
                }
            }
for(Asset ast : extAsset)
{
if(ast.Server__r.Server_Type__c == 'Test')
{
if(testastMap.containskey(ast.Product_Model__c))
{
testastMap.get(ast.Product_Model__c).add(ast);
}
else
{
List<Asset> temp = new List<Asset>();
temp.add(ast);
testastMap.put(ast.Product_Model__c,temp);
}
}

if(ast.Server__r.Server_Type__c == 'Failover')
{
if(FOastMap.containskey(ast.Product_Model__c))
{
FOastMap.get(ast.Product_Model__c).add(ast);
}
else
{
List<Asset> temp = new List<Asset>();
temp.add(ast);
FOastMap.put(ast.Product_Model__c,temp);
}
}


if(ast.Server__r.Server_Type__c == 'Live')
{
if(liveastMap.containskey(ast.Product_Model__c))
{
liveastMap.get(ast.Product_Model__c).add(ast);
}
else
{
List<Asset> temp = new List<Asset>();
temp.add(ast);
liveastMap.put(ast.Product_Model__c,temp);
}
}
}

for(Server__c serv : extServ)
{
if(Serv.Server_Type__c == 'Test')
{
exttestServ.add(serv);
}
if(Serv.Server_Type__c == 'Failover')
{
extfoServ.add(Serv);
}
if(Serv.Server_Type__c == 'Live')
{
extLiveServ.add(Serv);
}
}

  
         List<Perceptive_Config_Value__c> pcv = new List<Perceptive_Config_Value__c>();
         map<String,Perceptive_Config_Value__c> key_desc = new map<String,Perceptive_Config_Value__c>();    
         pcv = [Select ID,Name,Custom_Attribute_1__c,Custom_Attribute_2__c,Description__c,Perceptive_Config_Option__c,sort__c,value__c
         from Perceptive_Config_Value__c where Perceptive_Config_Option__r.Name = 'Unit of Measure'];    
        if(!pcv.isEmpty())
        {
        for(Perceptive_Config_Value__c pc : pcv)
        {
            if(pc.name != null || pc.name != '')
            {
        key_desc.put(pc.Name,pc);
            }
        }   
        }

        List<Server__c> Servers = new List<Server__c>();
        List<Server__c> liveServer = new List<Server__c>();
        List<Server__c> testServer = new List<Server__c>();
        List<Server__c> foServer = new List<Server__c>();

   if(extLiveServ.isEmpty())
   {
   liveServer = (createServerRecord(agr, 'Live', 1, agr.id,'No'));
   insert liveServer;
   }
   else
   {
   liveServer.addall(extLiveServ);
   }
   
   String [] serverTypeList = new List<String>();
                serverTypeList.add('Test');
                serverTypeList.add('Failover');
                
                for (Integer sl = 0; sl < serverTypeList.size(); sl++)
                {    
                string serverType = serverTypeList[sl];
                integer numberofservers = 0;
                if (servertype == 'Test')
                {
                    numberofServers = testServerCount - exttestServ.size();
                }
                else
                {
                    numberofServers = foServerCount - extfoServ.size();
                } 
    
                if(numberOfServers > 0) 
                {
                    List<Server__c> addServers = new List<Server__c>(createServerRecord(agr, serverType, numberofServers, liveServer[0].id, 'Yes'));
                
                    for (Server__c serverRec : addServers)
                    {
                        servers.add(serverRec);
                    }       
                }
            }

        system.debug('createServers - return servers: ' + servers);
        insert servers;
        
        servers.add(liveServer[0]);
        servers.addall(extfoServ);
        servers.addall(exttestServ);        
        
        

for(Server__c srv : servers)
{
if(srv.Server_Type__c == 'Test')
{
testServer.add(srv);
}
else if(srv.Server_Type__c == 'Failover')
{
foServer.add(srv);
}
}

   List<Asset> astLst = new List<Asset>();
   Map<ID, Product_Model__c> ProductModelRecordsMap = new Map<ID,Product_Model__c> ();
   Product_Model__c productModelRec = new Product_Model__c();
   ProductModelRecordsMap = ProductModelMap(ProductRec_ProductModelIds); 
   Map<Asset, Asset_Item__c> Assets = new Map<Asset, Asset_Item__c>();   
   List<Case> CasesToInsert = new List<Case>();
   Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
   Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
   Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();
   Set<String> astID = new Set<String>();
   List<Asset> existingasts = new List<Asset>();
   Map<ID,Product2> prodmap = new Map<ID,Product2>();
   
   for(OpportunityLineItem keyset : PGR_Map.Keyset())
   {
   For(Product2 productRec: PGR_Map.get(keyset))
   {
   system.debug('XXXXXXXXXXX' +productRec);
   system.debug('XXXXXXXXXXXXXXXXXX' +ProductModelRecordsMap.containskey(productRec.Product_Model__c));  
   system.debug('XXXXXXXXXXXXXXXXXX' +ProductModelRecordsMap.Keyset().Size());
   
   productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c); 
   
   prodmap.put(productrec.Name_Abbrev__c,productrec);
   
   If(productModelRec.Asset_Required__c == true)
   {
   if(!liveastMap.containskey(productModelRec.id))
   {
   Asset lvAsset = new Asset(Name = productModelRec.name
                                        , Server__c = liveServer[0].Id 
                                        , AccountId = liveServer[0].Account__c
                                        , Agreement__c = liveServer[0].Agreement__c
                                        , Product_Model__c = productModelRec.id);
          if(isFuture)                 //Create Asset Clone Later
          {
          lvAsset.Process_Later__c = True;
          }                              
          astLst.add(lvAsset);
          astID.add(productModelRec.id + '--' +'Live');
    }
    else
    {
    existingasts.addall(liveastMap.get(productModelRec.id));
    astID.add(productModelRec.id + '--' +'Live');
    }      
   
   if(!astID.contains(productModelRec.id + '--' +'Test'))
   {  
   if(productRec.Test_Environments_Needed__c <= testServer.size())
   {   
   if(!testastMap.containskey(productModelRec.id))
   {
   for(Integer i = 0; i < productRec.Test_Environments_Needed__c; i++)
   {   
   Asset assset = new Asset(Name = productModelRec.name
                                        , Server__c = testServer[i].Id 
                                        , AccountId = testServer[i].Account__c
                                        , Agreement__c = testServer[i].Agreement__c
                                        , Product_Model__c = productModelRec.id);
          if(isFuture)                 //Create Asset Clone Later
          {
          assset.Process_Later__c = True;
          }                              
          astLst.add(assset);
          astID.add(productModelRec.id + '--' +'Test');
   }
   }
   else if(productRec.Test_Environments_Needed__c > testastMap.get(productModelRec.id).size())
   {
   for(Integer i = 0; i < productRec.Test_Environments_Needed__c - testastMap.get(productModelRec.id).size(); i++)
   {   
   Asset assset = new Asset(Name = productModelRec.name
                                        , Server__c = testServer[i].Id 
                                        , AccountId = testServer[i].Account__c
                                        , Agreement__c = testServer[i].Agreement__c
                                        , Product_Model__c = productModelRec.id);
          if(isFuture)                 //Create Asset Clone Later
          {
          assset.Process_Later__c = True;
          }                              
          astLst.add(assset);
          existingasts.addall(testastMap.get(productModelRec.id));
          astID.add(productModelRec.id + '--' +'Test');
   }
   }
   }
   }
   if(!astID.contains(productModelRec.id + '--' +'FailOver'))
   {
   if(productRec.Failover_Environments_Needed__c <= foServer.size())
   {
   if(!foastMap.containskey(productModelRec.id))
   {  
   for(Integer i = 0; i < productRec.Failover_Environments_Needed__c; i++)
   {      
   Asset assset = new Asset(Name = productModelRec.name
                                        , Server__c = testServer[i].Id 
                                        , AccountId = testServer[i].Account__c
                                        , Agreement__c = testServer[i].Agreement__c
                                        , Product_Model__c = productModelRec.id);
          if(isFuture)                 //Create Asset Clone Later
          {
          assset.Process_Later__c = True;
          }                              
          astLst.add(assset);
          astID.add(productModelRec.id + '--' +'FailOver');
   }
   }
   else if(productRec.Failover_Environments_Needed__c > foastMap.get(productModelRec.id).size())
   {
   for(Integer i = 0; i < productRec.Failover_Environments_Needed__c - foastMap.get(productModelRec.id).size(); i++)
   {   
   Asset assset = new Asset(Name = productModelRec.name
                                        , Server__c = testServer[i].Id 
                                        , AccountId = testServer[i].Account__c
                                        , Agreement__c = testServer[i].Agreement__c
                                        , Product_Model__c = productModelRec.id);
          if(isFuture)                 //Create Asset Clone Later
          {
          assset.Process_Later__c = True;
          }                              
          astLst.add(assset);
          existingasts.addall(foastMap.get(productModelRec.id));
          astID.add(productModelRec.id + '--' +'FailOver');
   }
   }
   }   
   }
   }       
   }
   } 
   if(!astLst.isEmpty())
   {
   insert astLst;
   }
   astlst.addall(existingasts);
   
   map<ID,List<Asset>> astMap = new map<ID,List<Asset>>();
   for(Asset ast : astLst)
   {
   if(astMap.containskey(ast.Product_Model__c))
   {
   astMap.get(ast.Product_Model__c).add(ast);
   }
   else
   {
   List<Asset> temp = new List<Asset>();
   temp.add(ast);
   astMap.put(ast.Product_Model__c,temp);
   }   
   }
   list<Asset_Item__c> atmtoIns = new list<Asset_Item__c>();
   for(OpportunityLineItem keyset : PGR_Map.Keyset())
   {
   For(Product2 productRec: PGR_Map.get(keyset))
   {
   productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c); 
   If(productModelRec.Asset_Required__c == true)
   {
   if(astMap.containskey(productModelRec.id))
   {
   for(Asset Ast : astMap.get(productModelRec.id))
   {
   String pt_desc;
    if(key_desc.Containskey(keyset.price_type__c))
              {
              pt_desc =  key_desc.get(keyset.price_type__c).Description__c;
              }
   
   Asset_Item__c assetItemRec = new Asset_Item__c(Name = productRec.Name
                                        , Quantity__c = keyset.Quantity
                                        , Status__c = 'Active'
                                        , Product__c = ProductRec.Name_Abbrev__c            //used this field because couldn't populate ID in my temp table
                                        , Opportunity__c = keyset.OpportunityId
                                        , Price_Type__c =  keyset.Price_Type__c 
                                        , Price_Type_Description__c = pt_desc                  
                                        , Server__c = Ast.Server__c
                                        , Asset__c = Ast.id);
          if(isFuture)                          //Create Asset Item Clone Later
          {
          assetItemRec.Process_Later__c = True;
          } 
   atmtoIns.add(assetItemRec);
   }
   }   
   }
   }     
}
if(!atmtoIns.isEmpty())
{
insert atmtoIns;
}
map<ID,List<Asset_Item__c>> astitmmap = new map<ID,List<Asset_Item__c>>();
    
    
List<License_Key__c> lkLst = new List<License_Key__c>();
for(Asset_Item__c atm : atmtoIns)
{
if(prodmap.get(atm.Product__c).License_Required__c)
{
   License_Key__c LicenseKeyRec = new License_Key__c(Name = atm.Name
                                        , Quantity__c = atm.Quantity__c
                                        , Asset__c = atm.Asset__c
                                        , Asset_Item__c = atm.id
                                        , server__c = atm.Server__c);
            if(isFuture)
            {
            LicenseKeyRec.Process_later__c = True;
            }
            lklst.add(LicenseKeyRec);
                

}
}
if(!lklst.isEmpty())
{
insert lklst;
}
    
    //Solution Bundles
    
    
}
    

public static Map<ID,Product_Model__c> ProductModelMap(Set<ID> ProductModelRecIds)
    {
        Map<ID, Product_Model__c> ProductModelMap_Return = new Map<ID,Product_Model__c>() ;
        List<Product_Model__c> productModelRecList = new List<Product_Model__c>([select Asset_Required__c
                                                                                                    , Name 
                                                                                                    , Id
                                                                                                    from Product_Model__c 
                                                                                                    where id in :ProductModelRecIDs]);
        system.debug('productModelRecList:' + productModelRecList);
        For (Product_Model__c ProductModelRec : productModelRecList)
        {
            ProductModelMap_Return.put(productModelRec.id, ProductModelRec);
        }   
        return ProductModelMap_Return;                                                                                              
    }
    
    
    public static list<Server__c> createServerRecord(agreement__c agr
                                                        , String serverType
                                                        , Integer numberofservers
                                                        , ID LiveServerID
                                                        , string addLiveServer)
       {
        List<Server__c> Servers = new List<Server__c>();                                                            
        system.debug('==numberOfServers:' + numberOfServers);
        String ServerName = accmap.get(agr.Account__c).name;
           if(ServerName.length() > 79)
           {
           ServerName = ServerName.substring(0,79);     
           }
        for (Integer i = 0; i < numberOfServers; i++) 
        {
            Server__c server = new Server__c();
            server.Name = ServerName;
            server.Server_Type__c = serverType;
            if (serverType != 'Live' && addLiveServer == 'Yes')
            {
                server.Live_Server__c = LiveServerID;
            }
            server.Agreement__c = agr.id;
            server.Account__c = agr.Account__c;
            system.debug('server in createServers: ' + server);
            Servers.add(server);
        }                                               
        return Servers;
    }
    
    

public static decimal ifnull(decimal num) 
{
if (num == null) 
{
    num = 0;
}
return num;
}
}