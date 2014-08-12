public class ProcessInstallations 
{
/* pass in a list of opportunity ids
 * get all the line items for
 ** check to see if any products are bundled
 ** with new list, check for any core products
 ** if core product, move to core product list
 **                , else move to non core product list
 ** if more than 1 core product, create a case
 ** if only 1 core product, check to see if assetRequired flag is set on product model
 *** if no flag set, create a case
 *** if flag, create server for live
 ***          Create server for all allowed environments.  populate live server id in "live server" field
 **** if asset required is set
 ***** Create Asset
 ***** create asset item - populate quantity field with allowed #
 ***** check License required flag on product
 ****** if license required is set, create license key
 ******                           , create License case
 ** if no core products - check for server on rec
 *** if server given = test or failover
 **** if asset required is set
 ***** Create Asset
 ***** create asset item - populate quantity field with allowed #
 ***** check License required flag on product
 ****** if license required is set, create license key
 ******                           , create License case
 *** if server given = live, put in list of servers to create assets

 **** put retrieved servers in list of servers to create assets
 **** for each server in list
 ***** if asset required is set
 ****** Create Asset
 ****** create asset item - populate quantity field with allowed #
 ****** check License required flag on product
 ******* if license required is set, create license key
 *******                           , create License case
 *** if no server given, create a case
 */

    //@Future
    public static void processInstallation (list<ID> OppID)
    {
        Map<OpportunityLineItem,List<Product2>> Saperion_map= new Map<OpportunityLineItem,List<Product2>>();
        Map<OpportunityLineItem,List<Product2>> PGR_map= new Map<OpportunityLineItem,List<Product2>>();
        List<Opportunity> OpportunityList = new List<Opportunity>();
        OpportunityList = ProcessInstallations_GetOpportunity.OpportunityList(oppID);
        List<Product2> usesizingList = new List<Product2>();
        map<ID,List<OpportunityLineItem>> sizingcaseList = new map<ID,List<OpportunityLineItem>>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();
        boolean isfuture;
        Set<ID> ProductRec_ProductModelIds = new Set<ID>();
        Set<ID> ProductRec_ProductModelIds_Saperion = new Set<ID>();        
        Set<ID> ProductRec_ProductModelIds_PGR = new Set<ID>();        
        system.debug('license-External recordtype: ' + recordTypeId);
            
        for (Opportunity OpportunityRec : OpportunityList)
        {
            isfuture = False;  
            //********get products to Process
            Map<OpportunityLineItem, List<Product2>> LineItemProductMap = new Map<OpportunityLineItem, List<Product2>> ();    //map of opplineitems per opp (Map<OppID, Map<lineItemID, lineItemrec)>>)
            LineItemProductMap.clear();     //clears all line items used in previous loop if needed.
            LineItemProductMap = ProcessInstallations_GetProducts.ProcessInstallations_getProducts(OpportunityRec.id);          //returns per opp, the lineItems and product(s) and Subitems of Products
//          system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + LineItemProductMap.Keyset().Size());
            
            if(!LineItemProductMap.KeySet().isEmpty() && LineItemProductMap.KeySet().Size() > InstallationSize__c.GetAll().get('OpportunityLineItemQty').LineItemNumber__c)
            {
            isfuture = True;            
            }
            //*****process through each item to see if core product
            List<OpportunityLineItem> LineItemProductMapKeySet = new List<OpportunityLineItem>(LineItemProductMap.keyset());                        //define id set to hold Keyset Ids returned from _GetProducts
            List<Product2>coreProductsList = new List<Product2>();                                              //list of Products per keyset from CoreProducts map
            List<Product2>noncoreProductsList = new List<Product2>();                                           //list of Products per keyset from nonCoreProducts map
            List<Product2>bundleProductsList = new List<Product2>();                                           //list of Products per keyset from bundle map                                                       
            Map<OpportunityLineItem, List<Product2>> CoreProductsMap = new Map<OpportunityLineItem, List<Product2>>();
            Map<OpportunityLineItem, List<Product2>> nonCoreProductsMap = new Map<OpportunityLineItem, List<Product2>>();
            Map<OpportunityLineItem, List<Product2>> upgradeProductMap = new Map<OpportunityLineItem, List<Product2>>();
            Map<OpportunityLineItem, List<Product2>> solnProductsMap = new Map<OpportunityLineItem, List<Product2>>();
            Map<OpportunityLineItem, List<Product2>> solnSubProductsMap = new Map<OpportunityLineItem, List<Product2>>();
            
            set<String> part_numberset = new set<String>();
            List<Server__c> Servers = new List<Server__c>();
            Map<Asset, Asset_Item__c> Assets = new Map<Asset, Asset_Item__c>();
            String productModelName;
            
            Map<ID, Product_Model__c> ProductModelRecordsMap = new Map<ID,Product_Model__c> ();
            List<Case> CasesToInsert = new List<Case>();
            Product_Model__c productModelRec = new Product_Model__c();
            boolean CoreProductErrorFound = false;
            Map<ID, Product2> SwapProducts = new Map<ID, Product2>();
            Map<Product2, OpportunityLineItem> ProductRecLineItem = new Map<Product2, OpportunityLineItem>();
            List<ID> SwapAssetItems = new List<ID>();
            Map<ID, List<Asset_Item__c>> SwapAssetItemsMap = new Map<ID, List<Asset_Item__c>>();            //id = productrec id
            Map<ID,List<License_Key__c>> SwapLicenseKeyMap = new Map<ID, List<License_Key__c>>();
            List<Asset_Item__c> AssetItemsToUpdate = new List<Asset_Item__c>();
            List<License_Key__c> LicenseKeysToUpdate = new List<License_Key__c>();
            boolean isUpgradepart = false;
            boolean isBundlepart = false;
            Integer coreProductCount = 0;
            String errormsg = '';
            
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
        //           system.debug('LineItemProductMapKeySet.size():' + LineItemProductMapKeySet.size());
            for(OpportunityLineItem keyset : LineItemProductMapKeySet)
            {
            isUpgradepart = False;
            isBundlepart = False;    
            if(Upgrade_Table__c.getall().containskey(keyset.part_number__c+'-'+keyset.price_type__c))
            {       
            isUpgradepart = True;
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + isUpgradepart);
            }                
 //             system.debug('keyset - LineItemProductMapKeySet: ' + keyset);
                For(Product2 productRec: LineItemProductMap.get(keyset))               //get each productRec in list related to OppLineItem
                    {
                    if(productRec.Use_Sizing_Tool__c && productRec.Originating_Company__c != 'PacsGear' && !productRec.Replicate_Assets__c)                    //Added For Acuo Installations
                    {
                    usesizingList.add(productRec);
                    if(sizingcaseList.containskey(keyset.opportunityID))
                    {
                    List<OpportunityLineiTEM> TEMP = sizingcaseList.get(keyset.opportunityID);
                    temp.add(keyset);
                    sizingcaseList.put(keyset.opportunityID,temp);
                    }
                    else
                    {
                    List<OpportunityLineiTEM> TEMP = new List<OpportunityLineiTEM>();
                    temp.add(keyset);
                    sizingcaseList.put(keyset.opportunityID,temp);
                    }
                    }
                        //Solution Products
                                                
                       else if(keyset.PricebookEntry.Product2.Product_Bundled__c && keyset.PricebookEntry.Product2.id == productRec.Name_Abbrev__c && productRec.Use_Sizing_Tool__c && productRec.Originating_Company__c != 'PacsGear' && !productRec.Replicate_Assets__c)
                        {
                         isBundlepart = True;  
                         bundleProductsList.add(productRec);
                         solnProductsMap.put(keyset,bundleProductsList);    
                         ProductRec_ProductModelIds.add(keyset.PricebookEntry.Product2.Product_Model__c);   
						 List<Product2> temp = new List<Product2>();  
                         if(LineItemProductMap.containskey(keyset))	
                         {						 
                         solnSubProductsMap.put(keyset,LineItemProductMap.get(keyset)); 
                         }						 
                         system.debug('--------------------------' +solnSubProductsMap.values());
                        }
                        else if(keyset.PricebookEntry.Product2.Product_Bundled__c)
                        {
                         ProductRec_ProductModelIds.add(productRec.Product_Model__c); 
                        }
                      
                    //----------------------Saperion Products
                    //
                    //
                    //-----------------------PacsGear Products
                    else if(productRec.Originating_Company__c == 'PacsGear')
                    {
                     if(PGR_map.containskey(keyset))
                    {
                    PGR_map.get(keyset).add(productRec);
                    }
                    else
                    {
                    List<Product2> prdList = new List<Product2>();
                    prdList.add(productRec);
                    PGR_map.put(keyset,prdList);                  
                    }       
                    ProductRec_ProductModelIds_PGR.add(productRec.Product_Model__c);
                    }
                        
               
                    
                    else if(productRec.Replicate_Assets__c)                    
                    {                    
                    if(Saperion_map.containskey(keyset))
                    {
                    Saperion_map.get(keyset).add(productRec);
                    }
                    else
                    {
                    List<Product2> prdList = new List<Product2>();
                    prdList.add(productRec);
                    Saperion_map.put(keyset,prdList);                  
                    }
                    ProductRec_ProductModelIds_Saperion.add(productRec.Product_Model__c);
                    }
                    
                    //----------------------Saperion Products
                    
                    
                    else if(!productRec.Replicate_Assets__c && productRec.Originating_Company__c != 'PacsGear' && !productRec.Use_Sizing_Tool__c && !keyset.PricebookEntry.Product2.Product_Bundled__c)
                    {
                    system.debug('productRec: ' + productRec);
                    system.debug('productRec.Core_Product__c: ' + productRec.Core_Product__c);
                    if (productRec.Core_Product__c == true && !isUpgradepart && !isBundlepart)
                    {
                        system.debug('in core product');
                        coreProductCount = coreProductCount + 1;
                        system.debug(coreProductCount);
                        system.debug('CoreProductErrorFound:' + CoreProductErrorFound);
                        if(coreProductCount <= 1)
                        {
                            coreProductsList.add(productRec);
                            
                            CoreProductsMap.put(keyset, coreProductsList);
                            
                        }
                        else
                        {
                            if(CoreProductErrorFound ==false)
                            {
                                errorMsg = 'More than 1 core product.';
                                ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
                                CoreProductErrorFound = true;
                            }
                        }   
                    }
                    else if(!isUpgradepart && !isBundlepart)
                    {
                        system.debug('nonCoreProductsMap: ' + nonCoreProductsMap);
                        system.debug('ProductRec: ' + ProductRec);
                        nonCoreProductsMap.putall(ProcessInstallations_NonCoreProducts.ProcessInstallations_NonCoreProducts(keyset, nonCoreProductsMap, ProductRec));
                        
                    }
                    
                    if(isUpgradepart)
                    {
                    List<Product2>upgradeProdList = new List<Product2>();
                    if(upgradeProductMap.containskey(keyset))
                    {                    
                    upgradeProductMap.get(keyset).add(productRec);                    
                    }
                    else
                    {                    
                    upgradeProdList.add(productRec);
                    upgradeProductMap.put(keyset,upgradeProdList);  
                    }
                        part_numberset.add(productRec.part_number__c);
                    }
                    
                    ProductRec_ProductModelIds.add(productRec.Product_Model__c);
                    If(keyset.Return__c == true)
                    {
                        SwapProducts.put(ProductRec.Name_Abbrev__c, ProductRec);        //productRec.Id is in Name_Abbrev__c field since can set ID when creating temp productRectable
                        ProductRecLineItem.put(ProductRec, keyset);
                    }
                    }
                    else if(keyset.Return__c && productRec.Use_Sizing_Tool__c)
                    {
                    //For Future Processing
                    
                    }
                }
            }
            
            ProductModelRecordsMap = ProductModelMap(ProductRec_ProductModelIds);           //load map with all product model
//          system.debug('ProductModelRecordsMap:'+ProductModelRecordsMap);
            
            
            system.debug('coreProductMaps.size(): ' +  coreProductsMap.size());
            system.debug('nonCoreProductsMap.size(): ' +  nonCoreProductsMap.size());
            system.debug('solnProductsMap.size(): ' +  solnProductsMap.size());
            system.debug('solnSubProductsMap.size(): ' +  solnSubProductsMap.size());            
            system.debug('upgradeProductMap.size(): ' +  upgradeProductMap.size());
            
            if(CoreProductErrorFound == false)
            {                
                
                if (CoreProductsMap.size()== 1 )                        //check to see if any core products found
                {
                    List<OpportunityLineItem> CoreProductsMapKeySet = new List<OpportunityLineItem>(CoreProductsMap.keyset());                      //define id set to hold Keyset Ids returned from CoreProducts
                    List<OpportunityLineItem> nonCoreProductsMapKey = new List<OpportunityLineItem>(nonCoreProductsMap.keyset());                       //define id set to hold Keyset Ids returned from nonCoreProducts
     //               system.debug('CoreProductsMapKeySet.size()' + CoreProductsMapKeySet.size());
                    for(OpportunityLineItem keyset : CoreProductsMapKeySet )
                    {
     //                   system.debug('keyset - CoreProductsMapKeySet: ' + keyset);
     //                   system.debug('coreProductsMap: ' + coreProductsMap);
     //                   system.debug('coreProductMaps.size(): ' +  coreProductsMap.size());
     //                   system.debug('list<product2> productRec from CoreProductsMap: ' + CoreProductsMap.get(keyset));
                        For(Product2 productRec: CoreProductsMap.get(keyset))              //get each productRec in list related to OppLineItem
                        {
                        
     //                       system.debug('productRec.Product_Model__c: ' + ProductModelRecordsMap.get(productRec.Product_Model__c) );
                            productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c);
                            If(productModelRec.Asset_Required__c == true)
                            {
                                servers = ProcessInstallations_CreateServer.ProcessInstallations_CreateServer(keyset, ProductRec, productModelName);
                                Assets = ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(Keyset, ProductRec, Servers, productModelRec.id, ProductModelRec.Name, 'Yes', isFuture);
    //                            system.debug('ProductRec.License_Required__c' + ProductRec.License_Required__c);
                                if (ProductRec.License_Required__c == true && !isUpgradepart && !isBundlepart)
                                {
                                    ProcessInstallations_CreateLicense.ProcessInstallations_CreateLicense(Keyset,ProductRec, Assets, servers, recordTypeID, CasesToInsert,isFuture);
                                }
                            }
                            else
                            {
                                errorMsg = 'Asset Required Flag not set for core product.';
                                ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
                            
                            }
                        }
                    }
    
     //               system.debug('end processing coreProductsMap: ');
     //               system.debug('nonCoreProductsMap.size():' + nonCoreProductsMap.size());
                    if(nonCoreProductsMap.size() > 0)
                    {                                              //make sure there are some nonCoreProducts to process
                        for(OpportunityLineItem keyset : nonCoreProductsMapKey )
                        {
     //                       system.debug('keyset - nonCoreProductsMapKeySet: ' + keyset);   
                            For(Product2 productRec: nonCoreProductsMap.get(keyset))
                            {               //get each productRec in list related to OppLineItem
                                productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c);
                                system.debug('productRec.Product_Model__c_noncoreProducts: ' + ProductModelRecordsMap.get(productRec.Product_Model__c) );
                                If(productModelRec.Asset_Required__c == true)
                                {
                                    Assets = ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(Keyset, ProductRec, Servers, productModelRec.id, ProductModelRec.Name, 'Yes', isFuture);
                                    if (ProductRec.License_Required__c == true && !isUpgradepart && !isBundlepart)
                                    {
                                        ProcessInstallations_CreateLicense.ProcessInstallations_CreateLicense(Keyset,ProductRec, Assets, servers, recordTypeID, CasesToInsert,isFuture);
                                    }
                                }   
                            }
                        }
                    }
                    
           if(upgradeProductMap.size() > 0)
                    {    
                    for(OpportunityLineItem keyset : upgradeProductMap.keyset())
                        {
            if(keyset.server__c != null)
            {
            List<Server__c> srvlist = new List<Server__c>();
                        srvList = [Select ID,name from Server__c where (ID =: keyset.server__c or Live_Server__c =: keyset.server__c) ];
                          For(Product2 productRec: upgradeProductMap.get(keyset))
                            {
                            CasestoInsert.addall(ProcessInstallations_CreateAsset.isUpgradereq(srvList,productRec,keyset,key_desc,isFuture));                                                  
                            }
             }
            
            else
            {
            errorMsg = 'No server found on Upgrade line Item';
            ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
            }           
            }
                    
                    }
                }
				
							
				
            else
            {   
           if(upgradeProductMap.size() > 0)
                    {    
                    for(OpportunityLineItem keyset : upgradeProductMap.keyset())
                        {
            if(keyset.server__c != null)
            {
            List<Server__c> srvlist = new List<Server__c>();
                        srvList = [Select ID,name from Server__c where (ID =: keyset.server__c or Live_Server__c =: keyset.server__c) ];
                          For(Product2 productRec: upgradeProductMap.get(keyset))
                            {
                            CasestoInsert.addall(ProcessInstallations_CreateAsset.isUpgradereq(srvList,productRec,keyset,key_desc,isFuture));                                                  
                            }
            }
            
            else
            {
            errorMsg = 'No server found on Upgrade line Item';
            ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
            }           
            }                    
            }
                    
            if(nonCoreProductsMap.size() > 0)
            {
                    Map<OpportunityLineItem, List<Server__c>> AllServersGivenMap = new Map<OpportunityLineItem,List<Server__c>>();
                    List<Server__c> ServersGiven = new List<Server__c>();                                               //no core products found - must have server to continue
                    Set<ID> LiveServerIds = new set<ID>();
                    Set<ID> serverIds = new set<ID>();
                    List<OpportunityLineItem> nonCoreProductsMapKey = new List<OpportunityLineItem>(nonCoreProductsMap.keyset());
                    
                    //check to see if all records have server information - if no stop & create a case.
                    boolean serverFound = true;
                    
                    AllServersGivenMap = ProcessInstallations_getServers.ProcessInstallations_getServers(nonCoreProductsMapKey);
     //               system.debug('AllServersGivenMap:' + AllServersGivenMap);
                    for(OpportunityLineItem keyset : nonCoreProductsMapKey )
                    {
                        if(ServerFound)
                        {                //once server is not found - create case and stop
     //                       system.debug('keyset - nonCoreProductsMapKey: ' + keyset);
                            For(Product2 productRec: nonCoreProductsMap.get(keyset))
                            {               //get each productRec in list related to OppLineItem
                                if(ServerFound)
                                {
                                    productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c);
     //                               system.debug('productRec.Product_Model__c_noncoreProducts: ' + ProductModelRecordsMap.get(productRec.Product_Model__c) );
                                    If(productModelRec.Asset_Required__c == true)
                                    {
     //                                   system.debug('AllServersGivenMap.Containskey(keyset):' + AllServersGivenMap.Containskey(keyset));
                                        if(AllServersGivenMap.Containskey(keyset))
                                        {    
     //                                       system.debug('serverFound by ContainsKey.');
     //                                       system.debug('server list: ' +AllServersGivenMap.get(keyset) );
                                            if (AllServersGivenMap.get(keyset).size()>0)
                                            {
     //                                         system.debug('list returned is not empty.');
                                            }
                                            else
                                            {
                                             if(!productRec.Product_Bundled__c)   
                                             {
                                                serverFound = false;
                                                errorMsg = 'No server found on line Item';
                                                ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
                                             }
                                            }
                                        }
                                        else
                                        {
                                          if(!productRec.Product_Bundled__c)   
                                             {  
                                            serverFound = false;
                                            errorMsg = 'No server found on line Item';
                                            ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
                                             }
                                        }
                                    }   
                                }       
                            }
                        }   
                    }   
    //                system.debug('serverFound: ' + serverFound);
                    if (serverFound)
                    {               //all opportunity line items that required a server, have a server.
                        
                        //get all data related to "swap" info (assetItems & LicenseKeys)
                        system.debug('SwapProducts: ' + SwapProducts);
                        if(SwapProducts.size()>0){          //do we have any line items that are going to be swapped?
                            SwapAssetItemsMap = ProcessInstallations_GetSwapAssets.ProcessInstallations_GetSwapAssets(SwapProducts, AllServersGivenMap, ProductRecLineItem, ProductModelRecordsMap);
                            system.debug('return from getSwapAssets - SwapAssetItemsMap' + SwapAssetItemsMap );
                            if(SwapAssetItemsMap.size()>0)
                            {
                                //loop through Asset map to compile list of assetIds to use 
                                List<ID> SwapAssetItemsMapKey = new List<ID>(SwapAssetItemsMap.keyset());
                                system.debug('SwapAssetItemsMapKey: ' + SwapAssetItemsMapKey);
                                for(ID IDRec : SwapAssetItemsMapKey )
                                {
                                    For(Asset_Item__c AssetItemRec: SwapAssetItemsMap.get(IDRec))
                                    { 
                                        SwapAssetItems.add(AssetItemRec.Asset__c);
                                    }
                                }  
                                system.debug('SwapAssetItems: ' + SwapAssetItems);  
                                if  (SwapAssetItems.size()>0)
                                {
                                    SwapLicenseKeyMap = ProcessInstallations_GetSwapLicenses.ProcessInstallations_GetSwapLicenses(SwapAssetItems);
                                }   
                            }   
                        }       
                        for(OpportunityLineItem keyset : nonCoreProductsMapKey )
                        {
    //                      system.debug('keyset - nonCoreProductsMapKey: ' + keyset);
                            For(Product2 productRec: nonCoreProductsMap.get(keyset)){               //get each productRec in list related to OppLineItem
                                productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c);
                                system.debug('productRec.Product_Model__c_noncoreProducts: ' + ProductModelRecordsMap.get(productRec.Product_Model__c) );
                                ServersGiven = AllServersGivenMap.get(keyset);          //should provide a list of servers for just this line item
    //                          system.debug('ServerGiven - nonCoreProductsMap: ' + ServersGiven);
                                if(keyset.Return__c == true && productModelRec.Asset_Required__c == true){          //swapping a product
                                    //inactivate asset(s) - use AssetItemsToUpdate List
                                    AssetItemsToUpdate = ProcessInstallations_InactivateAssetItem.ProcessInstallations_InactivateAssetItem
                                    (keyset, productRec, AssetItemsToUpdate, ServersGiven, SwapAssetItemsMap, 
                                    productModelRec.id, ProductModelRec.Name, 'Yes', recordTypeID, CasesToInsert, isFuture);
                                    //inactivate license(s) - use LicenseKeysToUpdate list
                                    If(AssetItemsToUpdate.size() > 0){
                                        LicenseKeysToUpdate = ProcessInstallations_InactivateLicense.ProcessInstallations_InactivateLicense(AssetItemsToUpdate, SwapLicenseKeyMap, LicenseKeysToUpdate, keyset, ServersGiven, recordTypeID, CasesToInsert);
                                    }
                                }else{
                                //this loop is needed so that Quantity being passed back from the "inactivateAsset" can be put into the product Rec.

                                    system.debug('productRec:'+ productRec);
                                    If(productModelRec.Asset_Required__c == true){
                                        
        //                                system.debug('ServerGiven - nonCoreProductsMap: ' + ServersGiven);
                                        Assets = ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(Keyset, ProductRec, ServersGiven, productModelRec.id, ProductModelRec.Name, 'Yes',isFuture);
                                        if (ProductRec.License_Required__c == true){
                                            ProcessInstallations_CreateLicense.ProcessInstallations_CreateLicense(Keyset,ProductRec, Assets, ServersGiven, recordTypeID, CasesToInsert,isFuture);
                                        }
                                    }   
                                }       
                            }   
                        }
                    }   
                } 
            }

                if(!solnProductsMap.keyset().isempty())
                    {
                    for(OpportunityLineItem keyset : solnProductsMap.keyset())
                    {
                        For(Product2 productRec: solnProductsMap.get(keyset))              //get each productRec in list related to OppLineItem
                        {                        
                          system.debug('productRec.Product_Model__c: ' + ProductModelRecordsMap.get(productRec.Product_Model__c) );
                            productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c);
                            If(productModelRec.Asset_Required__c == true && productRec.Product_Bundled__c)
                            {
                                servers = ProcessInstallations_CreateServer.ProcessInstallations_CreateServer(keyset, ProductRec, productModelName);
                                Assets = ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(Keyset, ProductRec, Servers, productModelRec.id, ProductModelRec.Name, 'Yes', isFuture);
    //                          system.debug('ProductRec.License_Required__c' + ProductRec.License_Required__c);
                                if (ProductRec.License_Required__c == true && !isUpgradepart)
                                {
                                    ProcessInstallations_CreateLicense.ProcessInstallations_CreateLicense(Keyset,ProductRec, Assets, servers, recordTypeID, CasesToInsert,isFuture);
                                }
                            }
                            else
                            {
                                errorMsg = 'Asset Required Flag not set for Bundled product.';
                                ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(keyset, errormsg, CasesToInsert, keyset.Server__c);
                            
                            }
                        }
                    } 
					
					if(solnSubProductsMap.size() > 0)
                    {                                              //make sure there are some nonCoreProducts to process
                        for(OpportunityLineItem keyset : solnSubProductsMap.keyset())
                        {
     //                       system.debug('keyset - solnSubProductsMap: ' + keyset);   
                            For(Product2 productRec: solnSubProductsMap.get(keyset))
                            {   //get each productRec in list related to OppLineItem
                                productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c);                               
                                If(productModelRec.Asset_Required__c == true && keyset.PricebookEntry.Product2.Id != productRec.Name_Abbrev__c)
                                {
                                    Assets = ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(Keyset, ProductRec, Servers, productModelRec.id, ProductModelRec.Name, 'Yes', isFuture);
                                    if (ProductRec.License_Required__c == true && !isUpgradepart)
                                    {
                                        ProcessInstallations_CreateLicense.ProcessInstallations_CreateLicense(Keyset,ProductRec, Assets, servers, recordTypeID, CasesToInsert,isFuture);
                                    }
                                }   
                            }
                        }
                    }
					
                 }			
                
                If(AssetItemsToUpdate.size() > 0)
                {
                    system.debug('AssetItemsToUpdate: ' + AssetItemsToUpdate);
                    update AssetItemsToUpdate;
                }
                If(SwapLicenseKeyMap.size() > 0)
                {
                    update LicenseKeysToUpdate;
                }

                				
                
                if(!LineItemProductMap.keyset().isEmpty() && !solnProductsMap.keyset().isempty())             //Added to Update the Parent Asset and Hide on Portal Fields for Solution product changes
                {
                 ProcessInstallations_Rearrange.Rearrange_Asset_Items(LineItemProductMap,OpportunityRec);
                }
                
                
                OpportunityRec .InstallationStatus__c = 'Completed';
            //    update OpportunityRec ;
            } 
            if(casesToInsert.size()>0)
            {
                    system.debug('casestoInsert: ' + CasestoInsert);
                    insert CasestoInsert;
            }
        }     
        if(!usesizingList.isempty())        
        {
        ProcessInstallations_CreateLicenseCase.ProcessInstallations_CreateAcuoLicenseCase(sizingcaseList);
        }
        if(!Saperion_map.keyset().isEmpty())
        {
          createInstallations_Saperion.create(Saperion_map,ProductRec_ProductModelIds_Saperion,isFuture);        
        }
        
        if(!PGR_map.keySet().isempty())
        {
           createInstallations_PCSGear.createfromOppy(PGR_map,isFuture);            
        }
        
        
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
        For (Product_Model__c ProductModelRec : productModelRecList){
            ProductModelMap_Return.put(productModelRec.id, ProductModelRec);
        }   
        return ProductModelMap_Return;                                                                                              
    }
    
    static testmethod void m1(){
        Account acc = createAccount();
        Opportunity opp = createopportunity(acc.Id);
        
        List<Product_Model__c> productModels = new List<Product_Model__c>();
        Product_Model__c pm;
        for(Integer i =0; i< 2;i++){
            pm = new Product_Model__c(Name = 'Test Model '+i,Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support');
            if(i==0){
                pm.Model__c = 'TestM-'+i;
                pm.Asset_Required__c = true;
            }
            productModels.add(pm);
        }
        insert productModels;
        List<Product2> ProdList = new List<Product2> ();
        Product2 prod= new Product2();
        prod.Product_Category__c = 'Client';
        prod.Name = 'test';
        prod.product_Model__c = productModels[0].Id;
        prod.Use_Sizing_Tool__c = true;
        ProdList.add(prod);
        //insert prod;
        
        Product2 prod1= new Product2();
        prod1.Product_Category__c = 'Client';
        prod1.Name = 'test2';
        prod1.product_Model__c = productModels[0].Id;
        prod1.Core_Product__c = true;
        ProdList.add(prod1);
        //insert prod1;
        insert ProdList;
        Pricebook2 pb =[Select id from pricebook2 where isStandard=true];
        List<pricebookEntry> pbeList = new List<pricebookEntry>();
        pricebookEntry pbe = new pricebookEntry();
        pbe.pricebook2Id = pb.Id;
        pbe.product2Id = ProdList[0].Id;
        pbe.UnitPrice=20.00;
        pbe.isActive=true;
        pbeList .add(pbe);
        //insert pbe;
        
        pricebookEntry pbe1 = new pricebookEntry();
        pbe1.pricebook2Id = pb.Id;
        pbe1.product2Id = ProdList[1].Id;
        pbe1.UnitPrice=20.00;
        pbe1.isActive=true;
        pbeList.add(pbe1);
        //insert pbe1;
        insert pbeList ;
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Opportunityid = opp.Id;
        oli.pricebookEntryId = pbeList[0].Id;
        oli.Quantity = 3;
        oli.TotalPrice = 75.00;
        oliList.add(oli);
        //insert oli;
        
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.Opportunityid = opp.Id;
        oli1.pricebookEntryId = pbeList[1].Id;
        oli1.Quantity = 3;
        oli1.TotalPrice = 75.00;
        oliList.add(oli1);
        //insert oli1;
        insert oliList;
        Test.startTest();
        ProcessInstallations.processInstallation(new List<Id>{opp.Id}); 
        Test.Stoptest();
    }
     public static Opportunity createOpportunity(String accId){
      List<Contact> contacts = new List<Contact>(); 
      contacts.add(new Contact(LastName = 'Test',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_Contact__c=true,Status__c='Active'));
      contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_Contact__c=true,Status__c='Active'));
      insert contacts;
        
      Opportunity opp =  new Opportunity();
      opp.AccountId = accId;
      opp.Name = 'Opportunity4TestMethod';
      opp.CloseDate = Date.today().addDays(10);
      opp.StageName = 'Negotiation';
      opp.Type = 'Renewal';
      opp.QAStatus__c = 'New';
      opp.Ship_To__c  = contacts.get(0).Id;
      opp.Bill_To__c  = contacts.get(0).Id;
      insert opp;
      return opp;
    }
    public static Account createAccount()
    {
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.MDM_Sold_To_Number__c = '1234';
        acc.Physical_Country__c = 'India';
        acc.BillingCountry = 'India';
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId(); 
        insert acc;
        return acc;
    }    
}