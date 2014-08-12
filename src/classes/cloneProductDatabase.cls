Public Class cloneProductDatabase
{

Public Static Void Clone(Set<ID> ProdConfig)
{
 List<Product_Configuration__c> newProdConfigs = [select id,CloneParent__c,name,Product__c,ProductRelease__c from Product_Configuration__c where ID in: ProdConfig];
 Set<ID> oldProdConfig = new Set<ID>();
 
 for(Product_Configuration__c pcon : newProdConfigs)
 {
 oldProdConfig.add(pcon.CloneParent__c); 
 }
 
 List<Product_Database__c> prodDatabases = new List<Product_Database__c>();
                
 prodDatabases = [select id, name, ProductConfig__c, Release__c, brand__c, database__c, database_master__c, database_version__c, product__c from Product_Database__c where ProductConfig__c in: oldProdConfig];
        
        map<ID,List<Product_Database__c>> pcmap = new map<ID,List<Product_Database__c>>();
        
        for(Product_Database__c pc : prodDatabases)
        {
        if(pcmap.containskey(pc.productConfig__c))
        {
        pcmap.get(pc.productConfig__c).add(pc);        
        }
        else
        {
        List<Product_Database__c> temp = new List<Product_Database__c>();
        temp.add(pc);
        pcmap.put(pc.productConfig__c,temp);
        }        
        }                
        
        
        
        
        
 System.debug('Size of prodDatabases is: ' + prodDatabases.size());
   List<Product_Database__c> toBeAddedProdDbs = new List<Product_Database__c>();
   for(Product_Configuration__c pcon : newProdConfigs)
   {
   id newProdConfigID = pcon.ID;
   id oldProdConfigID = pcon.CloneParent__c;
     if(pcmap.containskey(oldProdConfigID))
       {    
        for(Product_Database__c pd : pcmap.get(oldProdConfigID))
        {
            
            String errMsg = 'pd.ProductConfig__c: ' + pd.productConfig__c + '\n prodConfig.CloneParent__c' + newProdConfigID;
            
            System.debug(errMsg);
                      
                Product_Database__c newPd = new Product_Database__c(ProductConfig__c = newProdConfigID,brand__c = pd.brand__c,database__c = pd.database__c,
                Database_Master__c = pd.Database_Master__c,database_version__c = pd.database_version__c,product__c = pd.product__c);
                toBeAddedProdDbs.add(newPd);
            
        }
        }
       }
        
        System.debug('Size of toBeAddedProdDBs: ' + toBeAddedProdDbs.size());
        
        
        if(!toBeAddedProdDbs.isEmpty())
        {
            insert toBeAddedProdDbs;
        }   
      

}
}