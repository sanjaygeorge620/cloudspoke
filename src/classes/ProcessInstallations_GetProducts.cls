public class ProcessInstallations_GetProducts 
{
    
    public static Map<OpportunityLineItem, List<Product2>> ProcessInstallations_getProducts(ID oppID)
    {
        
        Map<OpportunityLineItem, List<Product2>> productsToProcess = new Map<OpportunityLineItem, List<Product2>>();    //list that will hold all products to be processed.
        Map<ID, List<Product_Sub_Item__c>> subitems = new Map<ID, List<Product_Sub_Item__c>>();     //list of subitems - will be put in map related to lineitemRec
        Map<Id, List<Product_Sub_Item__c>> productSubitemstocheck = new Map<Id, List<Product_Sub_Item__c>>();   //list of subitems need to be checked for additional sub items
        Map<Id, List<Product_Sub_Item__c>> subProduct = new Map<Id, List<Product_Sub_Item__c>>();
        Map<ID, List<Product_Sub_Item__c>> productSubItems = new Map<ID, List<Product_Sub_Item__c>>();     //ProductID-->List<Subitems>
        Map<ID,Solution_Sub_Products__c> sp_map = new Map<ID,Solution_Sub_Products__c>();
        
        Boolean ProductsFound;
        
        //get list of LineItems
        List<OpportunityLineItem> OppLineItems = (List <OpportunityLineItem>)(Database.query('Select Id,Part_number__c,Opportunity.AccountId,Opportunity.Account.Name,Opportunity.OwnerID,OpportunityId,Opportunity.Opportunity_Number__c,Opportunity.Type,Originating_Company__c,LX_Solution_Grouping__c,LX_Solution_Parent_Value__c,LX_Solution_Sub_Item_Value__c,Opportunity.Admin_Contact__r.Name, Opportunity.Admin_Contact__r.Email,Opportunity.Admin_Contact__r.Phone,Server__c,Price_Type__c,Quantity,Return__c,PricebookEntry.Product2.Originating_Company_PM__c,PricebookEntry.Product2.Core_Product__c,PricebookEntry.Product2.Product_Bundled__c,PricebookEntry.Product2.Parent_Product__r.Product_Bundled__c,PricebookEntry.Product2.Environment__c,PricebookEntry.Product2.Failover_Environments_Allowed__c,PricebookEntry.Product2.part_number__c,PricebookEntry.Product2.Failover_Environments_Needed__c,PricebookEntry.Product2.Failover_Licenses_Allowed__c,PricebookEntry.Product2.Exclude_from_Failover_Clone__c,PricebookEntry.Product2.Exclude_from_Test_Clone__c,PricebookEntry.Product2.Id,PricebookEntry.Product2.Price_Unit__c,PricebookEntry.Product2.License_Required__c,PricebookEntry.Product2.Name,PricebookEntry.Product2.Parent_Product__r.Product_Model__r.Name,PricebookEntry.Product2.Parent_Product__r.Name,PricebookEntry.Product2.Product_Model__c,   PricebookEntry.Product2.Product_Model__r.Asset_Required__c,PricebookEntry.Product2.Product_Model__r.Family__c,PricebookEntry.Product2.Product_Model__r.Line__c,PricebookEntry.Product2.Product_Model__r.Model__c,PricebookEntry.Product2.Product_Model__r.Name,PricebookEntry.Product2.Product_Model__r.Series__c,PricebookEntry.Product2.SMSA_Product__c,PricebookEntry.Product2.SMSA_Product__r.Product_Model__r.Name,PricebookEntry.Product2.Test_Environments_Allowed__c,PricebookEntry.Product2.Test_Environments_Needed__c,PricebookEntry.Product2.Test_Licenses_Allowed__c,PricebookEntry.Product2.Replicate_Full_Environment__c,PricebookEntry.Product2.Use_Sizing_Tool__c,PricebookEntry.Product2.Replicate_Assets__c FROM OpportunityLineItem Where OpportunityId = :oppId'));
        
        Map<ID,OpportunityLineItem> oppline_UOM = new Map<ID,OpportunityLineItem>();
        
        //from initial list check to see if any of these produts have subitems  
        if (OppLineItems.size() > 0) 
        {            
            Set<ID> ProductIDSet = new Set<ID>();            
            Set<ID> ProductIDSet_SolnPrd = new Set<ID>();            
            
            for(OpportunityLineItem LineItem : OppLineItems)
            {
                system.debug('LineItemRec.PricebookEntry.Product2.Id: '+ LineItem.PricebookEntry.Product2.Id);
                if(!LineItem.PricebookEntry.Product2.Product_Bundled__c)
                {
                    ProductIDSet.add(LineItem.PricebookEntry.Product2.Id);
                }
                else
                {
                    if(!String.isBlank(LineItem.PricebookEntry.Product2.Parent_Product__c))
                    {
                        if(!LineItem.PricebookEntry.Product2.Parent_Product__r.Product_Bundled__c)
                        {
                            oppline_UOM.put(LineItem.PricebookEntry.Product2.Id,LineItem);
                            ProductIDSet_SolnPrd.add(LineItem.PricebookEntry.Product2.Id);                     
                        }
                    }
                    else
                    {
                        oppline_UOM.put(LineItem.PricebookEntry.Product2.Id,LineItem);
                        ProductIDSet_SolnPrd.add(LineItem.PricebookEntry.Product2.Id); 
                    }
                }
                system.debug('productIDSet' + productIDSet);
                system.debug('ProductIDSet_SolnPrd' + ProductIDSet_SolnPrd.size());
            }
            
            if(!productIDSet.isEmpty() || !ProductIDSet_SolnPrd.isEmpty())
            {
                productSubItems = loadProductSubItems(ProductIDSet);        //get products related to productId
                
                if(!ProductIDSet_SolnPrd.isEmpty() && !oppline_UOM.keySet().isEmpty())
                {
                    for(id i : ProductIDSet_SolnPrd)
                    {
                        if(String.isNotBlank(oppline_UOM.get(i).Price_Type__c))
                        {
                            //   productSubItems = loadProductSubProducts_SolnProd(i,oppline_UOM.get(i),productSubItems);                                         
                            
                            Map<ID, List<Product_Sub_Item__c>> ProductSubItem_Map = new Map<Id, List<Product_Sub_Item__c>>();
                            List<Product_Sub_Item__c> subItemRecs = new List<Product_Sub_Item__c>();
                            List<Solution_Sub_Products__c> subprodRecs = new List<Solution_Sub_Products__c>([SELECT Solution_Product_ID__c,
                                                                                                             Solution_Product_UOM__c,
                                                                                                             Id,
                                                                                                             Sub_Product__c,
                                                                                                             Sub_Product__r.id,
                                                                                                             Sub_Product__r.Name,
                                                                                                             Sub_Product__r.Part_Number__c,
                                                                                                             Sub_Product__r.Core_Product__c,
                                                                                                             Sub_Product__r.Environment__c, 
                                                                                                             Sub_Product__r.Failover_Environments_Allowed__c,
                                                                                                             Sub_Product__r.Failover_Environments_Needed__c,
                                                                                                             Sub_Product__r.Failover_Licenses_Allowed__c,
                                                                                                             Sub_Product__r.Exclude_from_Failover_Clone__c,
                                                                                                             Sub_Product__r.Exclude_from_Test_Clone__c,
                                                                                                             Sub_Product__r.License_Required__c,
                                                                                                             Sub_Product__r.Parent_Product__r.Name,
                                                                                                             Sub_Product__r.SMSA_Product__c,
                                                                                                             Sub_Product__r.Product_Bundled__c,
                                                                                                             Sub_Product__r.Product_Model__c,
                                                                                                             Sub_Product__r.Product_Model__r.Name,
                                                                                                             Sub_Product__r.Test_Environments_Allowed__c,
                                                                                                             Sub_Product__r.Test_Environments_Needed__c,
                                                                                                             Sub_Product__r.Test_Licenses_Allowed__c,
                                                                                                             Sub_Product__r.Replicate_Full_Environment__c,
                                                                                                             Sub_Product__r.Use_Sizing_Tool__c,
                                                                                                             Sub_Product__r.Replicate_Assets__c,
                                                                                                             Sub_Product__r.Price_Unit__c,
                                                                                                             Sub_Product__r.Originating_Company_PM__c,
                                                                                                             Quantity__c,
                                                                                                             Ratio__c
                                                                                                             FROM Solution_Sub_Products__c 
                                                                                                             WHERE Solution_Setup__r.Active__c = true AND Solution_Product_ID__c =:i and Solution_Product_UOM__c =: oppline_UOM.get(i).Price_Type__c]);
                            
                            if(!subprodRecs.isEmpty())
                            {
                                for(Solution_Sub_Products__c sp : subprodRecs)
                                {
                                    sp_map.put(sp.Sub_Product__c,sp);
                                    system.debug('--------------' +sp.Sub_Product__r.name);
                                    Product_Sub_Item__c ps = new Product_Sub_Item__c();   
                                    ps.Parent_Product__c = sp.Solution_Product_ID__c;
                                    ps.Product__c = sp.Sub_Product__c;
                                    /*  ps.Product__r.Name = sp.Sub_Product__r.Name;
ps.Product__r.Part_Number__c = sp.Sub_Product__r.Part_Number__c;
ps.Product__r.Core_Product__c = sp.Sub_Product__r.Core_Product__c;
ps.Product__r.Environment__c = sp.Sub_Product__r.Environment__c;
ps.Product__r.Failover_Environments_Allowed__c = sp.Sub_Product__r.Failover_Environments_Allowed__c;
ps.Product__r.Failover_Environments_Needed__c = sp.Sub_Product__r.Failover_Environments_Needed__c;
ps.Product__r.Failover_Licenses_Allowed__c= sp.Sub_Product__r.Failover_Licenses_Allowed__c;
ps.Product__r.Exclude_from_Failover_Clone__c = sp.Sub_Product__r.Exclude_from_Failover_Clone__c;
ps.Product__r.Exclude_from_Test_Clone__c = sp.Sub_Product__r.Exclude_from_Test_Clone__c;
ps.Product__r.License_Required__c = sp.Sub_Product__r.License_Required__c;
ps.Product__r.Parent_Product__r.Name = sp.Sub_Product__r.Parent_Product__r.Name;
ps.Product__r.SMSA_Product__c = sp.Sub_Product__r.SMSA_Product__c;
ps.Product__r.Product_Bundled__c = sp.Sub_Product__r.Product_Bundled__c;
ps.Product__r.Product_Model__c = sp.Sub_Product__r.Product_Model__c;
ps.Product__r.Product_Model__r.Name = sp.Sub_Product__r.Product_Model__r.Name;
ps.Product__r.Test_Environments_Allowed__c = sp.Sub_Product__r.Test_Environments_Allowed__c;
ps.Product__r.Test_Environments_Needed__c = sp.Sub_Product__r.Test_Environments_Needed__c;
ps.Product__r.Test_Licenses_Allowed__c = sp.Sub_Product__r.Test_Licenses_Allowed__c;
ps.Product__r.Replicate_Full_Environment__c = sp.Sub_Product__r.Replicate_Full_Environment__c;
ps.Product__r.Use_Sizing_Tool__c = sp.Sub_Product__r.Use_Sizing_Tool__c;
ps.Product__r.Replicate_Assets__c = sp.Sub_Product__r.Replicate_Assets__c;  */                                                                                   
                                    ps.Quantity__c = sp.Quantity__c;
                                    ps.Ratio__c = sp.Ratio__c;
                                    system.debug('--------------' +ps.Product__r.Environment__c);
                                    subItemRecs.add(ps);
                                    
                                }
                                
                                //subItemRecs.addall(createSubItemFromSubProduct(subprodRecs));
                                
                                if (subItemRecs.size()>0 )
                                {         
                                    for(Product_Sub_Item__c SubRec : subItemRecs)
                                    {  
                                        //get map entry - add subrec
                                        boolean productKey; 
                                        if (productSubItems.size() > 0)
                                        {  
                                            productKey = productSubItems.containsKey(subRec.Parent_Product__c);
                                        }
                                        else
                                        {
                                            productKey = false;
                                        }
                                        system.debug('productKey: ' + productKey);
                                        List<Product_Sub_Item__c> tmpItemList = new List<Product_Sub_Item__c>();
                                        if (productKey)
                                        {        
                                            tmpItemList = productSubItems.get(subRec.Parent_Product__c);
                                        }       
                                        tmpItemList.add(subRec);
                                        productSubItems.put(subRec.Parent_Product__c,tmpItemList);
                                    }   
                                }
                            }
                            
                        }
                    }
                }
                
                
                if (productSubItems.size() > 0) 
                {
                    system.debug('OppLineItems : ' + OppLineItems);
                    For(OpportunityLineItem LineItemRec : OppLineItems) 
                    {
                        system.debug('LineItemRec: ' + LineItemRec);
                        ID LineItemProductID = LineItemRec.PricebookEntry.Product2.Id;
                        boolean subItemKey;
                        subItemKey = productsubItems.containsKey(LineItemRec.PricebookEntry.Product2.Id);
                        system.debug('subitemKey: ' + subItemKey);
                        if (subItemKey)
                        {
                            List<Product_Sub_Item__c> ProductSubItemsList = productsubItems.get(LineItemRec.PricebookEntry.Product2.Id);
                            if (ProductSubItemsList.size() > 0) 
                            {
                                system.debug('productSubItemsList: ' + productSubItemsList);
                                subItems.put(LineItemProductID, ProductSubItemsList);           //add any subproducts found so can check if they have subproducts
                                productsfound = true;           //subproducts found for line item.
                                system.debug('productsfound' + productsfound);
                            }
                            else 
                            {
                                system.debug('no Key found in ProductSubItemsList');
                                ProductstoProcess.putall(AddProductsToMap(createProductRecsfromLineItems(LineItemRec), ProductstoProcess));   
                                productsfound = false;              //no subproducts found for line item
                                system.debug('productsfound' + productsfound);
                            }
                        }
                        else
                        {
                            system.debug('no Key found in ProductSubItemsList');
                            ProductstoProcess.putall(AddProductsToMap(createProductRecsfromLineItems(LineItemRec), ProductstoProcess));    
                            productsfound = false;              //no subproducts found for line item
                            system.debug('productsfound' + productsfound);
                        }
                        
                        //****filter through if any subitems.  all these items will get put into map with opportunityLineItems
                        //by the time we have gotten to the 'Products found'
                        if (productsfound)
                        {
                            do{
                                if (subItems.size() > 0 )
                                {
                                    productSubitemstocheck.putall(subItems);            //all subitems still need to check for additional subitems
                                    system.debug('productSubitemstocheck: ' + productSubitemstocheck);
                                    subItems.clear();                                   //remove previous subitems so they are not combined with new sub items.
                                    List<ID> ProductSubitemsToCheckKeySet = new List<ID>(productSubitemstocheck.keyset());                      //define id set to hold Keyset Ids
                                    system.debug('ProductSubitemsToCheckKeySet:' + ProductSubitemsToCheckKeySet);
                                    for(ID keyset : ProductSubitemsToCheckKeySet )
                                    {
                                        system.debug('keyset - ProductSubitemsToCheckKeySet: ' + keyset);
                                        For(Product_Sub_Item__c subItem: productSubitemstocheck.get(keyset))
                                        {            
                                            set<id> subItemIDSet = new set<id>();
                                            system.debug('subItemRec - funneling through keyset: ' + subItem);
                                            subItemIDset.clear();
                                            subItemIDSet.add(subItem.id);
                                            subproduct = loadProductSubItems(subItemIDSet);
                                            system.debug('subProduct - in do: ' + subProduct);
                                            if (subproduct.size() > 0) 
                                            {
                                                productsfound = true;
                                                system.debug('productsfound - in do: ' + productsfound);
                                                try 
                                                {
                                                    List<Product_Sub_Item__c> SubProductItemsList = subproduct.get(subItem.id);
                                                    if(SubProductItemsList.size() > 0) 
                                                    {
                                                        system.debug('SubProductItemsList: ' + SubProductItemsList);
                                                        subItems.put(subItem.id, SubProductItemsList);
                                                    }
                                                    else
                                                    {
                                                        productsToProcess.putall(AddProductsToMap(createProductRecsfromSubItems(subItem, lineItemRec,sp_map), ProductstoProcess)); 
                                                    }
                                                }
                                                catch(exception subItemsException)
                                                {
                                                    system.debug('subItemsException:' + subItemsException);
                                                    productsToProcess.putall(AddProductsToMap(createProductRecsfromSubItems(subItem,lineItemRec,sp_map), ProductstoProcess)); 
                                                }
                                            }
                                            else 
                                            {         //no subitems - all records get processed
                                                system.debug('in do - subItem from productSubItemstoCheck: ' + subItem);
                                                system.debug('in do - lineITemRec from productSubItemstoCheck: ' + lineItemRec);
                                                productsToProcess.putall(AddProductsToMap(createProductRecsfromSubItems(subItem, lineItemRec,sp_map), ProductstoProcess));     ///check this line - where should it go
                                                productsfound = false;
                                                system.debug('in do - productsFound: ' + productsfound);
                                            }
                                        }   
                                    }
                                    system.debug('productSubItemstocheck: ' + productSubItemstocheck);
                                    productSubitemstocheck.clear(); 
                                }
                                else
                                {
                                    productsfound = false;
                                }   
                            } while(productsfound);
                        }       
                    }
                }
                else 
                {
                    //all products get added to productsToProcess
                    for (OpportunityLineItem lineItem : OppLineItems )
                    {
                        ProductstoProcess.putall(AddProductsToMap(createProductRecsfromLineItems(lineItem), ProductstoProcess)); 
                    }   
                }
            }            
        }
        system.debug('exit do');
        system.debug('productsToProcess - after do: ' + productsToProcess);
        Return productsToProcess;
    }
    public static Map<Id, List<Product_Sub_Item__c>> loadProductSubItems(Set<Id> parentID)
    {
        Map<ID, List<Product_Sub_Item__c>> ProductSubItemMap = new Map<Id, List<Product_Sub_Item__c>>();
        List<Product_Sub_Item__c> subItemRecs = new List<Product_Sub_Item__c>([SELECT Parent_Product__c,
                                                                               Id,
                                                                               Product__c,
                                                                               Product__r.Name,
                                                                               Product__r.Part_Number__c,
                                                                               Product__r.Core_Product__c,
                                                                               Product__r.Environment__c, 
                                                                               Product__r.Failover_Environments_Allowed__c,
                                                                               Product__r.Failover_Environments_Needed__c,
                                                                               Product__r.Failover_Licenses_Allowed__c,
                                                                               Product__r.Exclude_from_Failover_Clone__c,
                                                                               Product__r.Exclude_from_Test_Clone__c,
                                                                               Product__r.License_Required__c,
                                                                               Product__r.Parent_Product__r.Name,
                                                                               Product__r.SMSA_Product__c,
                                                                               Product__r.Product_Bundled__c,
                                                                               Product__r.Product_Model__c,
                                                                               Product__r.Product_Model__r.Name,
                                                                               Product__r.Test_Environments_Allowed__c,
                                                                               Product__r.Test_Environments_Needed__c,
                                                                               Product__r.Test_Licenses_Allowed__c,
                                                                               Product__r.Replicate_Full_Environment__c,
                                                                               Product__r.Use_Sizing_Tool__c,
                                                                               Product__r.Replicate_Assets__c,   
                                                                               Product__r.Price_Unit__c,
                                                                               Product__r.Originating_Company_PM__c,
                                                                               Quantity__c,
                                                                               Ratio__c
                                                                               FROM Product_Sub_Item__c 
                                                                               WHERE Active__c = true AND Parent_Product__c in :parentID]);
        
        system.debug('subItemRecs: ' +subItemRecs);
        if (subItemRecs.size()>0 )
        {         
            for(Product_Sub_Item__c SubRec : subItemRecs)
            {  
                //get map entry - add subrec
                boolean productKey; 
                if (ProductSubItemMap.size() > 0)
                {  
                    productKey = ProductSubItemMap.containsKey(subRec.Parent_Product__c);
                }
                else
                {
                    productKey = false;
                }
                system.debug('productKey: ' + productKey);
                List<Product_Sub_Item__c> tmpItemList = new List<Product_Sub_Item__c>();
                if (productKey)
                {        
                    tmpItemList = ProductSubItemMap.get(subRec.Parent_Product__c);
                }       
                tmpItemList.add(subRec);
                ProductSubItemMap.put(subRec.Parent_Product__c,tmpItemList);
            }   
        }
        system.debug('productSubItemMap: ' + productSubItemMap);        
        return ProductSubItemMap;
        
    }
    
    public static Map<Id, List<Product_Sub_Item__c>> loadProductSubProducts_SolnProd(Id parentID,Opportunitylineitem uom,Map<Id,List<Product_Sub_Item__c>> ProductSubItemMap)
    {        
        Map<ID, List<Product_Sub_Item__c>> ProductSubItem_Map = new Map<Id, List<Product_Sub_Item__c>>();
        List<Product_Sub_Item__c> subItemRecs = new List<Product_Sub_Item__c>();
        List<Solution_Sub_Products__c> subprodRecs = new List<Solution_Sub_Products__c>([SELECT Solution_Product_ID__c,
                                                                                         Solution_Product_UOM__c,
                                                                                         Id,
                                                                                         Sub_Product__c,
                                                                                         Sub_Product__r.Name,
                                                                                         Sub_Product__r.Part_Number__c,
                                                                                         Sub_Product__r.Core_Product__c,
                                                                                         Sub_Product__r.Environment__c, 
                                                                                         Sub_Product__r.Failover_Environments_Allowed__c,
                                                                                         Sub_Product__r.Failover_Environments_Needed__c,
                                                                                         Sub_Product__r.Failover_Licenses_Allowed__c,
                                                                                         Sub_Product__r.Exclude_from_Failover_Clone__c,
                                                                                         Sub_Product__r.Exclude_from_Test_Clone__c,
                                                                                         Sub_Product__r.License_Required__c,
                                                                                         Sub_Product__r.Parent_Product__r.Name,
                                                                                         Sub_Product__r.SMSA_Product__c,
                                                                                         Sub_Product__r.Product_Bundled__c,
                                                                                         Sub_Product__r.Product_Model__c,
                                                                                         Sub_Product__r.Product_Model__r.Name,
                                                                                         Sub_Product__r.Test_Environments_Allowed__c,
                                                                                         Sub_Product__r.Test_Environments_Needed__c,
                                                                                         Sub_Product__r.Test_Licenses_Allowed__c,
                                                                                         Sub_Product__r.Replicate_Full_Environment__c,
                                                                                         Sub_Product__r.Use_Sizing_Tool__c,
                                                                                         Sub_Product__r.Replicate_Assets__c,
                                                                                         Sub_Product__r.Price_Unit__c,
                                                                                         Sub_Product__r.Originating_Company_PM__c,
                                                                                         Quantity__c,
                                                                                         Ratio__c
                                                                                         FROM Solution_Sub_Products__c 
                                                                                         WHERE Solution_Setup__r.Active__c = true AND Solution_Product_ID__c =:parentID and Solution_Product_UOM__c =: uom.Price_Type__c]);
        
        if(!subprodRecs.isEmpty())
        {
            for(Solution_Sub_Products__c sp : subprodRecs)
            {
                system.debug('--------------' +sp.Sub_Product__r.name);
                Product_Sub_Item__c ps = new Product_Sub_Item__c();   
                ps.Parent_Product__c = sp.Solution_Product_ID__c;
                ps.Product__c = sp.Sub_Product__c;
                /*  ps.Product__r.Name = sp.Sub_Product__r.Name;
ps.Product__r.Part_Number__c = sp.Sub_Product__r.Part_Number__c;
ps.Product__r.Core_Product__c = sp.Sub_Product__r.Core_Product__c;
ps.Product__r.Environment__c = sp.Sub_Product__r.Environment__c;
ps.Product__r.Failover_Environments_Allowed__c = sp.Sub_Product__r.Failover_Environments_Allowed__c;
ps.Product__r.Failover_Environments_Needed__c = sp.Sub_Product__r.Failover_Environments_Needed__c;
ps.Product__r.Failover_Licenses_Allowed__c= sp.Sub_Product__r.Failover_Licenses_Allowed__c;
ps.Product__r.Exclude_from_Failover_Clone__c = sp.Sub_Product__r.Exclude_from_Failover_Clone__c;
ps.Product__r.Exclude_from_Test_Clone__c = sp.Sub_Product__r.Exclude_from_Test_Clone__c;
ps.Product__r.License_Required__c = sp.Sub_Product__r.License_Required__c;
ps.Product__r.Parent_Product__r.Name = sp.Sub_Product__r.Parent_Product__r.Name;
ps.Product__r.SMSA_Product__c = sp.Sub_Product__r.SMSA_Product__c;
ps.Product__r.Product_Bundled__c = sp.Sub_Product__r.Product_Bundled__c;
ps.Product__r.Product_Model__c = sp.Sub_Product__r.Product_Model__c;
ps.Product__r.Product_Model__r.Name = sp.Sub_Product__r.Product_Model__r.Name;
ps.Product__r.Test_Environments_Allowed__c = sp.Sub_Product__r.Test_Environments_Allowed__c;
ps.Product__r.Test_Environments_Needed__c = sp.Sub_Product__r.Test_Environments_Needed__c;
ps.Product__r.Test_Licenses_Allowed__c = sp.Sub_Product__r.Test_Licenses_Allowed__c;
ps.Product__r.Replicate_Full_Environment__c = sp.Sub_Product__r.Replicate_Full_Environment__c;
ps.Product__r.Use_Sizing_Tool__c = sp.Sub_Product__r.Use_Sizing_Tool__c;
ps.Product__r.Replicate_Assets__c = sp.Sub_Product__r.Replicate_Assets__c;  */                                                                                   
                ps.Quantity__c = sp.Quantity__c;
                ps.Ratio__c = sp.Ratio__c;
                system.debug('--------------' +ps.Product__r.Environment__c);
                subItemRecs.add(ps);
                
            }
            
            //subItemRecs.addall(createSubItemFromSubProduct(subprodRecs));
            
            if (subItemRecs.size()>0 )
            {         
                for(Product_Sub_Item__c SubRec : subItemRecs)
                {  
                    //get map entry - add subrec
                    boolean productKey; 
                    if (ProductSubItemMap.size() > 0)
                    {  
                        productKey = ProductSubItemMap.containsKey(subRec.Parent_Product__c);
                    }
                    else
                    {
                        productKey = false;
                    }
                    system.debug('productKey: ' + productKey);
                    List<Product_Sub_Item__c> tmpItemList = new List<Product_Sub_Item__c>();
                    if (productKey)
                    {        
                        tmpItemList = ProductSubItemMap.get(subRec.Parent_Product__c);
                    }       
                    tmpItemList.add(subRec);
                    ProductSubItemMap.put(subRec.Parent_Product__c,tmpItemList);
                }   
            }
        }
        
        return ProductSubItemMap;                                                                                        
    }
    
    public static List<Product_Sub_Item__c> createSubItemFromSubProduct(List<Solution_Sub_Products__c> spList)
    {
        List<Product_Sub_Item__c> returnList = new List<Product_Sub_Item__c>();
        for(Solution_Sub_Products__c sp : spList)
        {
            system.debug('--------------' +sp);
            Product_Sub_Item__c ps = new Product_Sub_Item__c();   
            ps.Parent_Product__c = sp.Solution_Product_ID__c;
            ps.Product__c = sp.Sub_Product__c;
            ps.Product__r.Name = sp.Sub_Product__r.Name;
            ps.Product__r.Part_Number__c = sp.Sub_Product__r.Part_Number__c;
            //      ps.Product__r.Core_Product__c = sp.Sub_Product__r.Core_Product__c;
            ps.Product__r.Core_Product__c = False;
            ps.Product__r.Environment__c = sp.Sub_Product__r.Environment__c;
            ps.Product__r.Failover_Environments_Allowed__c = sp.Sub_Product__r.Failover_Environments_Allowed__c;
            ps.Product__r.Failover_Environments_Needed__c = sp.Sub_Product__r.Failover_Environments_Needed__c;
            ps.Product__r.Failover_Licenses_Allowed__c= sp.Sub_Product__r.Failover_Licenses_Allowed__c;
            ps.Product__r.Exclude_from_Failover_Clone__c = sp.Sub_Product__r.Exclude_from_Failover_Clone__c;
            ps.Product__r.Exclude_from_Test_Clone__c = sp.Sub_Product__r.Exclude_from_Test_Clone__c;
            ps.Product__r.License_Required__c = sp.Sub_Product__r.License_Required__c;
            ps.Product__r.Parent_Product__r.Name = sp.Sub_Product__r.Parent_Product__r.Name;
            ps.Product__r.SMSA_Product__c = sp.Sub_Product__r.SMSA_Product__c;
            ps.Product__r.Product_Bundled__c = sp.Sub_Product__r.Product_Bundled__c;
            ps.Product__r.Product_Model__c = sp.Sub_Product__r.Product_Model__c;
            ps.Product__r.Product_Model__r.Name = sp.Sub_Product__r.Product_Model__r.Name;
            ps.Product__r.Test_Environments_Allowed__c = sp.Sub_Product__r.Test_Environments_Allowed__c;
            ps.Product__r.Test_Environments_Needed__c = sp.Sub_Product__r.Test_Environments_Needed__c;
            ps.Product__r.Test_Licenses_Allowed__c = sp.Sub_Product__r.Test_Licenses_Allowed__c;
            ps.Product__r.Replicate_Full_Environment__c = sp.Sub_Product__r.Replicate_Full_Environment__c;
            ps.Product__r.Use_Sizing_Tool__c = sp.Sub_Product__r.Use_Sizing_Tool__c;
            ps.Product__r.Replicate_Assets__c = sp.Sub_Product__r.Replicate_Assets__c;  
            ps.Product__r.Price_Unit__c = sp.Sub_Product__r.Price_Unit__c;            
            ps.Quantity__c = sp.Quantity__c;
            ps.Product__r.Product_Bundled__c = sp.Sub_Product__r.Product_Bundled__c;
            ps.Product__r.Originating_Company__c = sp.Sub_Product__r.Originating_Company_PM__c;            
            ps.Ratio__c = sp.Ratio__c;
            system.debug('--------------' +ps.Product__r.Environment__c);
            returnList.add(ps);
            
        }
        return returnList;
    }
    
    
    public static Map<OpportunityLineItem, List<Product2>> createProductRecsfromSubItems(Product_Sub_Item__c subItemRec, OpportunityLineItem LineItem,Map<ID,Solution_Sub_Products__c> sp_map)
    {
        Map<OpportunityLineItem, List<Product2>> subItemProducts = new Map<OpportunityLineItem, List<Product2>>();
        List<Product2> subItemProductsList = new List<Product2>();
        Product2 newSubItemProductRec = new Product2();
        if(!string.isBlank(subItemRec.id))
        {
            newSubItemProductRec.Parent_Product__c = subItemRec.Parent_Product__c;
            newSubItemProductRec.Part_Number__c  = subItemRec.Product__r.Part_Number__c;
            newSubItemProductRec.Core_Product__c = subItemRec.Product__r.Core_Product__c;
            newSubItemProductRec.Environment__c = subItemRec.Product__r.Environment__c;
            newSubItemProductRec.Failover_Environments_Allowed__c = subItemRec.Product__r.Failover_Environments_Allowed__c;
            newSubItemProductRec.Failover_Environments_Needed__c = subItemRec.Product__r.Failover_Environments_Needed__c;
            newSubItemProductRec.Failover_Licenses_Allowed__c = subItemRec.Product__r.Failover_Licenses_Allowed__c;
            newSubItemProductRec.Exclude_from_Failover_Clone__c = subItemRec.Product__r.Exclude_from_Failover_Clone__c;
            newSubItemProductRec.Exclude_from_Test_Clone__c = subItemRec.Product__r.Exclude_from_Test_Clone__c;
            newSubItemProductRec.License_Required__c = subItemRec.Product__r.License_Required__c;
            newSubItemProductRec.Name = subItemRec.Product__r.Name;
            newSubItemProductRec.Product_Model__c = subItemRec.Product__r.Product_Model__c; 
            newSubItemProductRec.SMSA_Product__c = subItemRec.Product__r.SMSA_Product__c;
            newSubItemProductRec.Test_Environments_Allowed__c = subItemRec.Product__r.Test_Environments_Allowed__c;
            newSubItemProductRec.Test_Environments_Needed__c = subItemRec.Product__r.Test_Environments_Needed__c;
            newSubItemProductRec.Test_Licenses_Allowed__c = subItemRec.Product__r.Test_Licenses_Allowed__c;
            newSubItemProductRec.Replicate_Full_Environment__c = subItemRec.Product__r.Replicate_Full_Environment__c;
            newSubItemProductRec.Product_Bundled__c = true;
            newSubItemProductRec.SubProduct_Quantity__c = subItemRec.Quantity__c;
            newSubItemProductRec.Sub_Product_Ratio__c = subItemRec.Ratio__c;
            newSubItemProductRec.Name_Abbrev__c = subitemRec.Product__r.id;         //used this field because couldn't populate ID in my temp table
            newSubItemProductRec.Use_Sizing_Tool__c= subitemRec.Product__r.Use_Sizing_Tool__c;                   
            newSubItemProductRec.Replicate_Assets__c= subitemRec.Product__r.Replicate_Assets__c; 
            newSubItemProductRec.Product_Bundled__c= subitemRec.Product__r.Product_Bundled__c;
            newSubItemProductRec.Price_Unit__c= subitemRec.Product__r.Price_Unit__c;
            newSubItemProductRec.Originating_Company__c= subitemRec.Product__r.Originating_Company_PM__c;
            
        }
        else if(sp_map.containsKey(subItemRec.Product__c))
        {
            Solution_Sub_Products__c subProdRec = sp_map.get(subItemRec.Product__c);
            newSubItemProductRec.Parent_Product__c = subProdRec.Solution_Product_ID__c;
            newSubItemProductRec.Part_Number__c  = subProdRec.Sub_Product__r.Part_Number__c;
            //  newSubItemProductRec.Core_Product__c = subProdRec.Sub_Product__r.Core_Product__c;
            newSubItemProductRec.Core_Product__c = false;
            newSubItemProductRec.Environment__c = subProdRec.Sub_Product__r.Environment__c;
            newSubItemProductRec.Failover_Environments_Allowed__c = subProdRec.Sub_Product__r.Failover_Environments_Allowed__c;
            newSubItemProductRec.Failover_Environments_Needed__c = subProdRec.Sub_Product__r.Failover_Environments_Needed__c;
            newSubItemProductRec.Failover_Licenses_Allowed__c = subProdRec.Sub_Product__r.Failover_Licenses_Allowed__c;
            newSubItemProductRec.Exclude_from_Failover_Clone__c = subProdRec.Sub_Product__r.Exclude_from_Failover_Clone__c;
            newSubItemProductRec.Exclude_from_Test_Clone__c = subProdRec.Sub_Product__r.Exclude_from_Test_Clone__c;
            newSubItemProductRec.License_Required__c = subProdRec.Sub_Product__r.License_Required__c;
            newSubItemProductRec.Name = subProdRec.Sub_Product__r.Name;
            newSubItemProductRec.Product_Model__c = subProdRec.Sub_Product__r.Product_Model__c; 
            newSubItemProductRec.SMSA_Product__c = subProdRec.Sub_Product__r.SMSA_Product__c;
            newSubItemProductRec.Test_Environments_Allowed__c = subProdRec.Sub_Product__r.Test_Environments_Allowed__c;
            newSubItemProductRec.Test_Environments_Needed__c = subProdRec.Sub_Product__r.Test_Environments_Needed__c;
            newSubItemProductRec.Test_Licenses_Allowed__c = subProdRec.Sub_Product__r.Test_Licenses_Allowed__c;
            newSubItemProductRec.Replicate_Full_Environment__c = subProdRec.Sub_Product__r.Replicate_Full_Environment__c;
            newSubItemProductRec.Product_Bundled__c = true;
            newSubItemProductRec.SubProduct_Quantity__c = subProdRec.Quantity__c;
            newSubItemProductRec.Sub_Product_Ratio__c = subProdRec.Ratio__c;
            newSubItemProductRec.Name_Abbrev__c = subProdRec.Sub_Product__r.id;         //used this field because couldn't populate ID in my temp table
            newSubItemProductRec.Use_Sizing_Tool__c= subProdRec.Sub_Product__r.Use_Sizing_Tool__c;                   
            newSubItemProductRec.Replicate_Assets__c= subProdRec.Sub_Product__r.Replicate_Assets__c;
            newSubItemProductRec.Price_Unit__c= subProdRec.Sub_Product__r.Price_Unit__c;
            newSubItemProductRec.Originating_Company__c= subProdRec.Sub_Product__r.Originating_Company_PM__c;
            
        }
        
        subItemProductsList.add(newSubItemProductRec);
        
        subItemProducts.put(LineItem, subItemProductsList);
        
        return subItemProducts;
        
    }
    
    public static Map<OpportunityLineItem, List<Product2>> createProductRecsfromLineItems(OpportunityLineItem lineItemRec){
        system.debug('createProductRecsfromLineItems - lineItemRec: ' + lineItemRec);
        system.debug('lineItemRec.PricebookEntry.Product2.Product_Model__r.Name: ' + lineItemRec.PricebookEntry.Product2.Product_Model__r.Name);
        system.debug('lineItemRec.PricebookEntry.Product2.Product_Model__r.Asset_Required__c: ' + lineItemRec.PricebookEntry.Product2.Product_Model__r.Asset_Required__c);
        
        Map<OpportunityLineItem, List<Product2>> LineItemProducts = new Map<OpportunityLineItem, List<Product2>>();
        List<Product2> lineItemProductsList = new List<Product2>();
        Product2 newLineItemProductRec = new Product2();
        newLineItemProductRec.Core_Product__c = lineItemRec.PricebookEntry.Product2.Core_Product__c;
        newLineItemProductRec.Part_Number__c  = lineItemRec.PricebookEntry.Product2.Part_Number__c;
        newLineItemProductRec.Environment__c = lineItemRec.PricebookEntry.Product2.Environment__c;
        newLineItemProductRec.Failover_Environments_Allowed__c = lineItemRec.PricebookEntry.Product2.Failover_Environments_Allowed__c;
        newLineItemProductRec.Failover_Environments_Needed__c = lineItemRec.PricebookEntry.Product2.Failover_Environments_Needed__c;
        newLineItemProductRec.Failover_Licenses_Allowed__c = lineItemRec.PricebookEntry.Product2.Failover_Licenses_Allowed__c;
        newLineItemProductRec.Exclude_from_Failover_Clone__c = lineItemRec.PricebookEntry.Product2.Exclude_from_Failover_Clone__c;
        newLineItemProductRec.Exclude_from_Test_Clone__c = lineItemRec.PricebookEntry.Product2.Exclude_from_Test_Clone__c;
        newLineItemProductRec.License_Required__c = lineItemRec.PricebookEntry.Product2.License_Required__c;
        newLineItemProductRec.Name = lineItemRec.PricebookEntry.Product2.Name;
        newLineItemProductRec.Product_Model__c = lineItemRec.PricebookEntry.Product2.Product_Model__c; 
        newLineItemProductRec.SMSA_Product__c = lineItemRec.PricebookEntry.Product2.SMSA_Product__c;
        newLineItemProductRec.Test_Environments_Allowed__c = lineItemRec.PricebookEntry.Product2.Test_Environments_Allowed__c;
        newLineItemProductRec.Test_Environments_Needed__c = lineItemRec.PricebookEntry.Product2.Test_Environments_Needed__c;
        newLineItemProductRec.Test_Licenses_Allowed__c = lineItemRec.PricebookEntry.Product2.Test_Licenses_Allowed__c;
        newLineItemProductRec.Replicate_Full_Environment__c = lineItemRec.PricebookEntry.Product2.Replicate_Full_Environment__c;
        newLineItemProductRec.SubProduct_Quantity__c = 0;
        newLineItemProductRec.Name_Abbrev__c = lineItemRec.PricebookEntry.Product2.id;          //used this field because couldn't populate ID in my temp table
        newLineItemProductRec.Use_Sizing_Tool__c= lineItemRec.PricebookEntry.Product2.Use_Sizing_Tool__c;    
        newLineItemProductRec.Replicate_Assets__c= lineItemRec.PricebookEntry.Product2.Replicate_Assets__c; 
        newLineItemProductRec.Price_Unit__c= lineItemRec.PricebookEntry.Product2.Price_Unit__c;
        newLineItemProductRec.Originating_Company__c= lineItemRec.PricebookEntry.Product2.Originating_Company_PM__c;
        
        lineItemProductsList.add(newLineItemProductRec);    
        
        LineItemProducts.put(LineItemRec, lineItemProductsList);
        
        return LineItemProducts;
        
    }
    
    
    public static Map<OpportunityLineItem, List<Product2>> AddProductsToMap(Map<OpportunityLineItem, List<Product2>> NewProductsToAdd, Map<OpportunityLineItem, List<Product2>> ExistingProducts) 
    {
        
        //for each key in new products to add, check against existing products
        Map<OpportunityLineItem, List<Product2>> ProductsAdded = new Map<OpportunityLineItem, List<Product2>>();
        List<OpportunityLineItem> NewProductsToAddKeySet = new List<OpportunityLineItem>(NewProductsToAdd.keyset());                        //get keyset of newProductsToAdd Map
        system.debug('NewProductsToAddKeySet:' + NewProductsToAddKeySet);
        for(OpportunityLineItem keyset : NewProductsToAddKeySet ){                                                      //for each keyset in the Map, cycle through
            
            boolean newProductKeyfound; 
            if (ExistingProducts.size() > 0){                                                           //check to see if the ExistingProductsMap Contains anything
                newProductKeyfound = ExistingProducts.containsKey(keyset);                                  //does the existing products map have the keyset of the new products                
            }else{
                newProductKeyfound = false;
            }
            system.debug('newProductKeyfound: ' + newProductKeyfound);                                                  //does the map have a keyset matching the NewProductsToAdd?
            List<Product2> tmpNewProductList = new List<Product2>();                    //create a tmpList to hold list returned from newProductsToadd
            List<Product2> tmpExistingProductList = new List<Product2>();                   //create a tmpList to hold list returned from newProductsToadd
            if (newProductKeyfound){        
                tmpExistingProductList = ExistingProducts.get(keyset);                              //get list from Existing productsList
            }   
            tmpNewProductList = NewProductsToAdd.get(keyset);   
            for (Product2 NewProductRec : tmpNewProductList )
            {
            tmpExistingProductList.add(NewProductRec);
            }   
            ProductsAdded.put(keyset,tmpExistingProductList);               
        }
        return ProductsAdded;
        
    }
    
    
}