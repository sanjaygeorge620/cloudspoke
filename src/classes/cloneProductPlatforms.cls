Public Class cloneProductPlatforms
{
@future
Public Static Void Clone(Set<ID> ProdConfig)
{
List<Product_Configuration__c> newProdConfigs = [select id,CloneParent__c,name,Product__c,ProductRelease__c from Product_Configuration__c where ID in: ProdConfig];
 Set<ID> oldProdConfig = new Set<ID>();
 
 for(Product_Configuration__c pcon : newProdConfigs)
 {
 oldProdConfig.add(pcon.CloneParent__c); 
 }
 
 List<Product_Platform__c> prodPlatforms = new List<Product_Platform__c>();
                
 prodPlatforms = [select id, name, product_master__c, Release__c, brand__c, platform__c, platform_master__c, platform_version__c, product__c from Product_Platform__c where Product_Master__c in: oldProdConfig];
 
  map<ID,List<Product_Platform__c>> pcmap = new map<ID,List<Product_Platform__c>>();
        
        for(Product_Platform__c pc : prodPlatforms)
        {
        if(pcmap.containskey(pc.product_master__c))
        {
        pcmap.get(pc.product_master__c).add(pc);        
        }
        else
        {
        List<Product_Platform__c> temp = new List<Product_Platform__c>();
        temp.add(pc);
        pcmap.put(pc.product_master__c,temp);
        }        
        }           
 
  List<Product_Platform__c> toBeAddedProdPlatforms = new List<Product_Platform__c>();
  for(Product_Configuration__c pcon : newProdConfigs)
   {
   id newProdConfigID = pcon.id;
   id oldProdConfigID = pcon.CloneParent__c;
    if(pcmap.containskey(oldProdConfigID))
       { 
        for(Product_Platform__c pp : pcmap.get(oldProdConfigID))
        {
          
                Product_Platform__c newPlatform = new Product_Platform__c(brand__c = pp.brand__c,product__c = pp.Product__c,Platform__c = pp.platform__c,
                platform_version__c = pp.platform_version__c,Platform_Master__c = pp.Platform_Master__c,Product_Master__c = newProdConfigID);
                toBeAddedProdPlatforms.add(newPlatform);
            
        }
       }
       } 
        if(!toBeAddedProdPlatforms.isEmpty())
        {
            insert toBeAddedProdPlatforms;
        }   

}
}