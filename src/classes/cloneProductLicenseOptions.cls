Public Class cloneProductLicenseOptions
{
Public Static Void Clone(Set<ID> ProdConfig)
{
List<Product_Configuration__c> newProdConfigs = [select id,CloneParent__c,name,Product__c,ProductRelease__c from Product_Configuration__c where ID in: ProdConfig];
 Set<ID> oldProdConfig = new Set<ID>();
 
 for(Product_Configuration__c pcon : newProdConfigs)
 {
 oldProdConfig.add(pcon.CloneParent__c); 
 }
 List<Product_License_Option__c> prodLicenseOptions = new List<Product_License_Option__c>();
                
        prodLicenseOptions = [select id, name, License_Option__c, Release__c, brand__c, productConfig__c, product__c 
        from Product_License_Option__c where productConfig__c in: oldProdConfig];
        
          map<ID,List<Product_License_Option__c>> pcmap = new map<ID,List<Product_License_Option__c>>();
        
        for(Product_License_Option__c pc : prodLicenseOptions)
        {
        if(pcmap.containskey(pc.productConfig__c))
        {
        pcmap.get(pc.productConfig__c).add(pc);        
        }
        else
        {
        List<Product_License_Option__c> temp = new List<Product_License_Option__c>();
        temp.add(pc);
        pcmap.put(pc.productConfig__c,temp);
        }        
        }                
        
        
        
                        
    List<Product_License_Option__c> toBeAddedProdLicenseOptions = new List<Product_License_Option__c>();
    for(Product_Configuration__c pcon : newProdConfigs)
   {
   id newProdConfigID = pcon.ID;
   id oldProdConfigID = pcon.CloneParent__c;
   if(pcmap.containskey(oldProdConfigID))
       {   
        for(Product_License_Option__c lo : pcmap.get(oldProdConfigID))
        {            
            
                Product_License_Option__c newLicenseOption = new Product_License_Option__c(brand__c = lo.brand__c,
                product__c = lo.Product__c,License_Option__c = lo.License_Option__c,ProductConfig__c = newProdConfigID);
                toBeAddedProdLicenseOptions.add(newLicenseOption);
            
        }
        }
      }    
          if(!toBeAddedProdLicenseOptions.isEmpty())
          {
            insert toBeAddedProdLicenseOptions;             
          }
                    
}
}