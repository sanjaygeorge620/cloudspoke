public class CreateEntitlementItems
{
Public static Map<String,Boolean> pflistfull = new Map<String,Boolean>();
public static Map<ID,List<Flexera_Entitlement_Items__c>> createItems(SET<ID> ssoIDS)
{
Map<String,Product__c> pflst = Product__c.getall();
for(string st: pflst.keyset())
{
pflistfull.put(pflst.get(st).Product_Family__c,true);
}
map<ID,ID> so_con = new map<ID,ID>();
List<SAP_Contract_Item__c> usethisList = new List<SAP_Contract_Item__c>();
Map<ID,List<Flexera_Entitlement_Items__c>> ret_map = new Map<ID,List<Flexera_Entitlement_Items__c>>();
Map<Id, List<Product_Sub_Item__c>> subProduct = new Map<Id, List<Product_Sub_Item__c>>();
List<SAP_Contract_Item__c> conitlst = new List<SAP_Contract_Item__c>();
Map<Id, List<Product_Sub_Item__c>> productSubitemstocheck = new Map<Id, List<Product_Sub_Item__c>>();
Map<ID, List<Product_Sub_Item__c>> subitems = new Map<ID, List<Product_Sub_Item__c>>(); 
List<SAP_Contract_Item__c> sconi = new List<SAP_Contract_Item__c>();
List<SAP_Sales_Order__c> ssoLst = new List<SAP_Sales_Order__c>();
Set<ID> sConIDS = new Set<ID>();
Set<ID> proIDs = new set<ID>();
Set<String> pnum = new set<String>();
map<ID,ID> fe_sc = new map<ID,ID>();
map<ID,product2> mprod = new map<ID,product2>();
List<Flexera_Entitlement_Items__c> toIns = new List<Flexera_Entitlement_Items__c>();
List<SAP_Contract__c> sConLst = new List<SAP_Contract__c>();
Map<ID,Map<ID,List<SAP_Contract_Item__c>>> mp_fe_sc = new Map<ID,Map<ID,List<SAP_Contract_Item__c>>>();
Map<ID,List<SAP_Contract_Item__c>> sc_sci = new Map<ID,List<SAP_Contract_Item__c>>(); 
Map<ID, List<Product_Sub_Item__c>> productSubItems = new Map<ID, List<Product_Sub_Item__c>>();     //ProductID-->List<Subitems>
Set<ID> prodtoreprocess = new set<ID>();
List<Product2> prodlst = new List<Product2>();
Map<ID,List<Product2>> prodtoprocess = new Map<ID,List<Product2>>();
Map<String,product2> pnum_id = new map<String,product2>();
Map<SAP_Contract_Item__c, Set<Product2>> productsToProcess = new Map<SAP_Contract_Item__c, Set<Product2>>();    //list that will hold all products to be processed.
map<ID,String>conli_pnum = new map<ID,String>();
Boolean ProductsFound;
Map<String,Perceptive_Config_Value__c> PCV = new Map<String,Perceptive_Config_Value__c>();

for(Perceptive_Config_Value__c pc : [SELECT  Custom_Attribute_1__c, Custom_Attribute_2__c, IsDeleted, Description__c, Perceptive_Config_Option__c, Id, 
Sort__c, Value__c, Name FROM Perceptive_Config_Value__c where Perceptive_Config_Option__c in 
(SELECT Id FROM Perceptive_Config_Option__c where Perceptive_Config_Group__r.Key__c = 'Flexera Entitlement')])
{
PCV.put(pc.Value__c,pc);
}


 ssoLst = [SELECT Account_ID__c, Account_Name__c, Close_Date__c,  Opportunity_Number__c, Id,SAP_Contract__c,SAP_Contract__r.Account__c,
 SAP_Contract__r.Contract_Number__c,SAP_Contract__r.End_Date__c,SAP_Contract__r.Start_Date__c,SAP_Contract__r.Name,SAP_Contract__r.Processed_Date__c,
 SAP_Contract__r.Opportunity_Number__c,SAP_Contract__r.MDM_Sold_To_Number__c,SAP_Contract_Number__c,
 Name, SAP_Sales_Order_Number__c, SAP_Contract__r.Opportunity__r.Account.Legacy_Company_Originator__c FROM SAP_Sales_Order__c where ID in: ssoIDS];
 
for(SAP_Sales_Order__c SO : ssoLst)
{
    if(so.SAP_Contract__r.Opportunity__c != NULL && PCV.ContainsKey(so.SAP_Contract__r.Opportunity__r.Account.Legacy_Company_Originator__c))
    {
    sConIDS.add(SO.SAP_Contract__c);
    fe_sc.put(SO.ID,SO.SAP_Contract__c);
    so_con.put(SO.SAP_Contract__c,SO.ID);
    }   
}

if(!sconIDS.isEmpty())
{
sconi = [SELECT Asset__c,End_Date__c,Line_Number__c,  Part_Name__c, Part_Number__c, 
Processed_Date__c, Quantity__c, Id, Rejection_Reason__c, SAP_Contract__c, Name, 
Sold_Price__c, Start_Date__c FROM SAP_Contract_Item__c where SAP_Contract__c in: sConIDS];
system.debug('sConIDS == '+sConIDS);
system.debug('sconi == '+sconi);

if(!sconi.isEmpty())
{
for(SAP_Contract_Item__c sci : sconi)
{
conitlst.add(sci);
conli_pnum.put(sci.ID,sci.Part_Number__c);
pnum.add(sci.Part_Number__c);
if(sc_sci.containskey(sci.SAP_Contract__c))
{
List<SAP_Contract_Item__c> tmp1 = sc_sci.get(sci.SAP_Contract__c);
tmp1.add(sci);
sc_sci.put(sci.SAP_Contract__c,tmp1);
}
else
{
List<SAP_Contract_Item__c> tmp1 = new List<SAP_Contract_Item__c>();
tmp1.add(sci);
sc_sci.put(sci.SAP_Contract__c,tmp1);
}
}
}

if(!pnum.Isempty())
{
prodlst = [Select ID,Part_Number__c,Name,product_model__c,Product_Model__r.Asset_Required__c,family, Part_Type__c from Product2 where Part_Number__c in: pnum];
}

for(product2 pr : prodlst)
{
proIDs.add(pr.ID);
mprod.put(pr.ID,pr);
pnum_id.put(pr.Part_Number__c,pr);
}

productSubItems = loadProductSubItems(proIDs);        //get products related to productId

if (productSubItems.size() > 0) 
{
  system.debug('OppLineItems : ' + conitlst);
                
  for(SAP_Contract_Item__c scoit : conitlst)
  {  
  system.debug('XXXENtered' +scoit.part_number__c);
   IF(conli_pnum.ContainsKey(scoit.ID))
  {
   if(pnum_ID.ContainsKey(conli_pnum.get(scoit.ID)))
   {
   ID conitID =  pnum_ID.get(conli_pnum.get(scoit.ID)).ID;
  system.debug('pnum_ID' +pnum_ID);
  system.debug('conli_pnum' +conli_pnum);
   system.debug('scoit' +scoit);
   system.debug('productSubItems' +productSubItems);
    system.debug('conitID' +conitID);
  if (productSubItems.containskey(conitID))
  {
   List<Product_Sub_Item__c> ProductSubItemsList = productsubItems.get(conitID);
                        if (ProductSubItemsList.size() > 0) 
                        {
                            system.debug('productSubItemsList: ' + productSubItemsList);
                            subItems.put(conitID, ProductSubItemsList);           //add any subproducts found so can check if they have subproducts
                            productsfound = true;           //subproducts found for line item.
                            if(ProductstoProcess.containskey(scoit))
                            {
                            Set<Product2> temLst = ProductstoProcess.get(scoit);
                            temLst.add(mprod.get(conitID));
                            system.debug('Adding into Process' +temLst);
                            ProductstoProcess.put(scoit,temLst);
                            }
                            else
                            {
                            Set<Product2> temLst = new Set<Product2>();
                            temLst.add(mprod.get(conitID));
                            system.debug('Adding into Process' +temLst);
                            ProductstoProcess.put(scoit,temLst);
                            }
                            system.debug('productsfound' + productsfound);
                        }
                        else 
                        {
                            system.debug('no Key found in ProductSubItemsList');
                            ProductstoProcess.putall(AddProductsToMap(createProductRecsfromLineItems(scoit,pnum_id.get(scoit.Part_Number__c)), ProductstoProcess));   
                            productsfound = false;              //no subproducts found for line item
                            system.debug('productsfound' + productsfound);
                        }
                    }
                    else
                    {
                        system.debug('no Key found in ProductSubItemsList');
                        ProductstoProcess.putall(AddProductsToMap(createProductRecsfromLineItems(scoit,pnum_id.get(scoit.Part_Number__c)), ProductstoProcess));    
                        productsfound = false;              //no subproducts found for line item
                        system.debug('productsfound' + productsfound);
                    }
                    
                    if (productsfound)
                    {
                        do
                        {
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
                                       Product2 addthis = genProdfromSub(subItem);
                                        set<id> subItemIDSet = new set<id>();
                                        system.debug('subItemRec - funneling through keyset: ' + subItem);
                                        subItemIDset.clear();
                                        subItemIDSet.add(subItem.Product__c);
                                        system.debug('CXXXX' + subItemIDSet);
                                        subproduct = loadProductSubItems(subItemIDSet);
                                        system.debug('subProduct - in do: ' + subProduct);
                                        if (subproduct.size() > 0) 
                                        {
                                            productsfound = true;
                                            system.debug('productsfound - in do: ' + productsfound);
                                            try {
                                                List<Product_Sub_Item__c> SubProductItemsList = subproduct.get(subItem.Product__c);
                                                if(SubProductItemsList.size() > 0) 
                                                {
                                                    system.debug('SubProductItemsList: ' + SubProductItemsList);
                                                    subItems.put(subItem.id, SubProductItemsList);
                          if(ProductstoProcess.containskey(scoit))
                            {
                            Set<Product2> temLst = ProductstoProcess.get(scoit);
                            temLst.add(addthis);
                            system.debug('Adding into Process' +temLst);
                            ProductstoProcess.put(scoit,temLst);
                            }
                            else
                            {
                            Set<Product2> temLst = new Set<Product2>();
                            temLst.add(addthis);
                            system.debug('Adding into Process' +temLst);
                            ProductstoProcess.put(scoit,temLst);
                            }
                                                }
                                                else
                                                {
                                                    productsToProcess.putall(AddProductsToMap(createProductRecsfromSubItems(subItem, scoit), ProductstoProcess)); 
                                                }
                                            }
                                            catch(exception subItemsException)
                                            {
                                                system.debug('subItemsException:' + subItemsException);
                                                productsToProcess.putall(AddProductsToMap(createProductRecsfromSubItems(subItem, scoit), ProductstoProcess)); 
                                            }
                                        }
                                        else 
                                        {         //no subitems - all records get processed
                                            system.debug('in do - subItem from productSubItemstoCheck: ' + subItem);
                                            system.debug('in do - scoit from productSubItemstoCheck: ' + scoit);
                                            productsToProcess.putall(AddProductsToMap(createProductRecsfromSubItems(subItem,scoit), ProductstoProcess));     ///check this line - where should it go
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
  }             
}
         else 
           {
                //all products get added to productsToProcess
                for (SAP_Contract_Item__c scoit : conitlst)
                {
                    ProductstoProcess.putall(AddProductsToMap(createProductRecsfromLineItems(scoit,pnum_id.get(scoit.Part_Number__c)), ProductstoProcess)); 
                }   
            }   

system.debug('PRODUCTS TO PROCESS' +ProductstoProcess);


for(SAP_Sales_Order__c SO : ssoLst)
{
ID sconID = SO.SAP_Contract__c;
toIns.clear();
if(sc_sci.containskey(sconID))
{
for(SAP_Contract_Item__c coi : sc_sci.get(sconID))
{
system.debug('contract line item' +coi);
if(ProductstoProcess.containskey(coi))
{
system.debug('check3' );
Set<product2> prlst = Productstoprocess.get(coi);

system.debug('prlst' +prlst);
for(product2 p : prlst)
{
if( p != null)
{
system.debug('check5' +p );
if(pflistfull.containskey(p.Part_Type__c))
{
Date myDate = date.newinstance(2099, 12, 31);
system.debug('check4' );
Flexera_Entitlement_Items__c fei = new Flexera_Entitlement_Items__c();
fei.Catalog_Item_ID__c = p.Part_number__c;
fei.Catalog_Item_Name__c = p.name;    
fei.Effective_Date__c = coi.Start_Date__c;
fei.Status__c = 'Active';
fei.Expiration_Date__c = myDate;    
fei.Quantity__c = coi.Quantity__c;  
toIns.add(fei);
System.debug('Addingproductstolist*****' +toins);
}
}
}
}
}
}
if(!toIns.Isempty())
{
ret_map.put(so.ID,toIns);    
}
}
System.debug('ENtitleMENT iTEMS iNSERTED' +ret_map); 
}
    return ret_map;
}

//---------------------------------------------------------------------------

public static Map<Id, List<Product_Sub_Item__c>> loadProductSubItems(Set<Id> parentID)
{
        system.debug('llll' +parentID);
        Map<ID, List<Product_Sub_Item__c>> ProductSubItemMap = new Map<Id, List<Product_Sub_Item__c>>();
        List<Product_Sub_Item__c> subItemRecs = new List<Product_Sub_Item__c>([SELECT Parent_Product__c,      
                                                                                        Parent_Product__r.Name,
                                                                                        Parent_Product__r.Part_Type__c,
                                                                                        Parent_Product__r.Part_Number__c,
                                                                                        Parent_Product__r.Core_Product__c,
                                                                                        Parent_Product__r.Environment__c, 
                                                                                        Parent_Product__r.Failover_Environments_Allowed__c,
                                                                                        Parent_Product__r.Failover_Environments_Needed__c,
                                                                                        Parent_Product__r.Failover_Licenses_Allowed__c,
                                                                                        Parent_Product__r.Exclude_from_Failover_Clone__c,
                                                                                        Parent_Product__r.Exclude_from_Test_Clone__c,
                                                                                        Parent_Product__r.License_Required__c,
                                                                                        Parent_Product__r.Parent_Product__r.Name,
                                                                                        Parent_Product__r.SMSA_Product__c,
                                                                                        Parent_Product__r.Product_Model__c,
                                                                                        Parent_Product__r.Product_Model__r.Name,
                                                                                        Parent_Product__r.Product_Model__r.Asset_Required__c,                                                                                        
                                                                                        Parent_Product__r.Test_Environments_Allowed__c,
                                                                                        Parent_Product__r.Test_Environments_Needed__c,
                                                                                        Parent_Product__r.Test_Licenses_Allowed__c,
                                                                                        Parent_Product__r.Replicate_Full_Environment__c,
                                                                                        Id,
                                                                                        Product__c,
                                                                                        Product__r.Name,
                                                                                        Product__r.Part_Type__c,
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
                                                                                        Product__r.Product_Model__c,
                                                                                        Product__r.Product_Model__r.Name,
                                                                                        Product__r.Product_Model__r.Asset_Required__c,                                                                                        
                                                                                        Product__r.Test_Environments_Allowed__c,
                                                                                        Product__r.Test_Environments_Needed__c,
                                                                                        Product__r.Test_Licenses_Allowed__c,
                                                                                        Product__r.Replicate_Full_Environment__c,
                                                                                        Quantity__c
                                                                                        FROM Product_Sub_Item__c 
                                                                                        WHERE Active__c = true AND Parent_Product__c in :parentID]);
                                                                                        
        system.debug('subItemRecs: ' +subItemRecs);
        if (subItemRecs.size()>0 )
        { 
          
            for(Product_Sub_Item__c SubRec : subItemRecs){  
                           //get map entry - add subrec
                IF(SubRec.Parent_Product__c != SubRec.Product__c)
                {
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
                if (productKey){        
                        tmpItemList = ProductSubItemMap.get(subRec.Parent_Product__c);
                }       
                tmpItemList.add(subRec);
                ProductSubItemMap.put(subRec.Parent_Product__c,tmpItemList);
            }   
        }
        }
        system.debug('productSubItemMap: ' + productSubItemMap);        
        return ProductSubItemMap;
                
    }


  public static Map<SAP_Contract_Item__c, Set<Product2>> createProductRecsfromSubItems(Product_Sub_Item__c subItemRec, SAP_Contract_Item__c LineItem)
  {
  
        Map<SAP_Contract_Item__c, Set<Product2>> subItemProducts = new Map<SAP_Contract_Item__c, Set<Product2>>();
        Set<Product2> subItemProductsList = new Set<Product2>();
        if(pflistfull.containskey(subItemRec.Product__r.Part_Type__c))
         {
        Product2 newSubItemProductRec = new Product2();
            newSubItemProductRec.Parent_Product__c = subItemRec.Parent_Product__c;
            newSubItemProductRec.Part_Type__c = subItemRec.Product__r.Part_Type__c;
            newSubItemProductRec.Core_Product__c = subItemRec.Product__r.Core_Product__c;
            newSubItemProductRec.Part_Number__c = subItemRec.Product__r.Part_Number__c;            
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
            newSubItemProductRec.Name_Abbrev__c = subitemRec.Product__r.id;         //used this field because couldn't populate ID in my temp table
            
                
        subItemProductsList.add(newSubItemProductRec);
                
        subItemProducts.put(LineItem, subItemProductsList);
        
        }
                
        return subItemProducts;
                
    }
    
    public Static product2 genProdfromSubParent(Product_Sub_Item__c subItemRec)
    {
    
    Product2 newSubItemProductRec = new Product2();
            newSubItemProductRec.Parent_Product__c = subItemRec.Parent_Product__c;
            newSubItemProductRec.Part_Type__c = subItemRec.Parent_Product__r.Part_Type__c;
            newSubItemProductRec.Core_Product__c = subItemRec.Parent_Product__r.Core_Product__c;
            newSubItemProductRec.Part_Number__c = subItemRec.Parent_Product__r.Part_Number__c;            
            newSubItemProductRec.Environment__c = subItemRec.Parent_Product__r.Environment__c;
            newSubItemProductRec.Failover_Environments_Allowed__c = subItemRec.Parent_Product__r.Failover_Environments_Allowed__c;
            newSubItemProductRec.Failover_Environments_Needed__c = subItemRec.Parent_Product__r.Failover_Environments_Needed__c;
            newSubItemProductRec.Failover_Licenses_Allowed__c = subItemRec.Parent_Product__r.Failover_Licenses_Allowed__c;
            newSubItemProductRec.Exclude_from_Failover_Clone__c = subItemRec.Parent_Product__r.Exclude_from_Failover_Clone__c;
            newSubItemProductRec.Exclude_from_Test_Clone__c = subItemRec.Parent_Product__r.Exclude_from_Test_Clone__c;
            newSubItemProductRec.License_Required__c = subItemRec.Parent_Product__r.License_Required__c;
            newSubItemProductRec.Name = subItemRec.Parent_Product__r.Name;
            newSubItemProductRec.Product_Model__c = subItemRec.Parent_Product__r.Product_Model__c;     
            newSubItemProductRec.SMSA_Product__c = subItemRec.Parent_Product__r.SMSA_Product__c;
            newSubItemProductRec.Test_Environments_Allowed__c = subItemRec.Parent_Product__r.Test_Environments_Allowed__c;
            newSubItemProductRec.Test_Environments_Needed__c = subItemRec.Parent_Product__r.Test_Environments_Needed__c;
            newSubItemProductRec.Test_Licenses_Allowed__c = subItemRec.Parent_Product__r.Test_Licenses_Allowed__c;
            newSubItemProductRec.Replicate_Full_Environment__c = subItemRec.Parent_Product__r.Replicate_Full_Environment__c;
            newSubItemProductRec.Product_Bundled__c = true;
            newSubItemProductRec.SubProduct_Quantity__c = subItemRec.Quantity__c;
            newSubItemProductRec.Name_Abbrev__c = subitemRec.Parent_Product__r.id;         //used this field because couldn't populate ID in my temp table
            
    return newSubItemProductRec;
    
    }
    
     public Static product2 genProdfromSub(Product_Sub_Item__c subItemRec)
    {
    
    Product2 newSubItemProductRec = new Product2();
            newSubItemProductRec.Parent_Product__c = subItemRec.Parent_Product__c;
            newSubItemProductRec.Part_Type__c = subItemRec.Product__r.Part_Type__c;
            newSubItemProductRec.Core_Product__c = subItemRec.Product__r.Core_Product__c;
            newSubItemProductRec.Part_Number__c = subItemRec.Product__r.Part_Number__c;            
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
            newSubItemProductRec.Name_Abbrev__c = subitemRec.Product__r.id;         //used this field because couldn't populate ID in my temp table
            
    return newSubItemProductRec;
    
    }
    
    
      
    public static Map<SAP_Contract_Item__c, Set<Product2>> createProductRecsfromLineItems(SAP_Contract_Item__c lineItemRecord,product2 newLineItemProductRec)
    {       

        Map<SAP_Contract_Item__c, Set<Product2>> LineItemProducts = new Map<SAP_Contract_Item__c, Set<Product2>>();
        Set<Product2> lineItemProductsList = new Set<Product2>();
                        
            lineItemProductsList.add(newLineItemProductRec);    
            
            LineItemProducts.put(lineItemRecord, lineItemProductsList);
                
            return LineItemProducts;
        
    }
    
     public static Map<SAP_Contract_Item__c, Set<Product2>> AddProductsToMap(Map<SAP_Contract_Item__c, Set<Product2>> NewProductsToAdd, Map<SAP_Contract_Item__c, Set<Product2>> ExistingProducts) 
     {
        
        //for each key in new products to add, check against existing products
        Map<SAP_Contract_Item__c, Set<Product2>> ProductsAdded = new Map<SAP_Contract_Item__c, Set<Product2>>();
        List<SAP_Contract_Item__c> NewProductsToAddKeySet = new List<SAP_Contract_Item__c>(NewProductsToAdd.keyset());                        //get keyset of newProductsToAdd Map
        system.debug('NewProductsToAddKeySet:' + NewProductsToAddKeySet);
        for(SAP_Contract_Item__c keyset : NewProductsToAddKeySet ){                                                      //for each keyset in the Map, cycle through
            
            boolean newProductKeyfound; 
            if (ExistingProducts.size() > 0){                                                           //check to see if the ExistingProductsMap Contains anything
                newProductKeyfound = ExistingProducts.containsKey(keyset);                                  //does the existing products map have the keyset of the new products                
            }else{
                newProductKeyfound = false;
            }
            system.debug('newProductKeyfound: ' + newProductKeyfound);                                                  //does the map have a keyset matching the NewProductsToAdd?
            Set<Product2> tmpNewProductList = new Set<Product2>();                    //create a tmpList to hold list returned from newProductsToadd
            Set<Product2> tmpExistingProductList = new Set<Product2>();                   //create a tmpList to hold list returned from newProductsToadd
            if (newProductKeyfound){        
                tmpExistingProductList = ExistingProducts.get(keyset);                              //get list from Existing productsList
            }   
            tmpNewProductList = NewProductsToAdd.get(keyset);   
            for (Product2 NewProductRec : tmpNewProductList ){
                tmpExistingProductList.add(NewProductRec);
            }   
            ProductsAdded.put(keyset,tmpExistingProductList);               
        }
        return ProductsAdded;
        
    }

    


}