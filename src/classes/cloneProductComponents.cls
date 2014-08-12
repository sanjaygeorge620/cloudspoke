Public Class cloneProductComponents
{

Public Static Void Clone(Set<ID> ProdConfig)
{
List<Product_Configuration__c> newProdConfigs = [select id,CloneParent__c,name,Product__c,ProductRelease__c from Product_Configuration__c where ID in: ProdConfig];
 Set<ID> oldProdConfig = new Set<ID>();
 
 for(Product_Configuration__c pcon : newProdConfigs)
 {
 oldProdConfig.add(pcon.CloneParent__c); 
 }
 
List<Product_Component__c> prodComponents = new List<Product_Component__c>();
                
        prodComponents = [select id, name, component__c, Release__c, brand__c, productConfig__c, Product_SKU__c, product__c 
                        from Product_Component__c where productConfig__c in: oldProdConfig];
         
        map<ID,List<Product_Component__c>> pcmap = new map<ID,List<Product_Component__c>>();
        
        for(Product_Component__c pc : prodComponents)
        {
        if(pcmap.containskey(pc.productConfig__c))
        {
        pcmap.get(pc.productConfig__c).add(pc);        
        }
        else
        {
        List<Product_Component__c> temp = new List<Product_Component__c>();
        temp.add(pc);
        pcmap.put(pc.productConfig__c,temp);
        }        
        }                
                        

List<Product_Component__c> toBeAddedProdComponents = new List<Product_Component__c>();
for(Product_Configuration__c pcon : newProdConfigs)
   {
        id newProdConfigID = pcon.Id;
        id oldProdConfigID = pcon.CloneParent__c;
       if(pcmap.containskey(oldProdConfigID))
       { 
        for(Product_Component__c pc : pcmap.get(oldProdConfigID))
        {            
            Product_Component__c newComponent = new Product_Component__c(brand__c = pc.brand__c,product__c = pc.Product__c,
            ProductConfig__c = newProdConfigID,Component__c = pc.Component__c,Product_SKU__c = pc.Product_SKU__c);

                toBeAddedProdComponents.add(newComponent);   
            }
        }
        }
        
        if(!toBeAddedProdComponents.isEmpty())
        {
            insert toBeAddedProdComponents;             
         }    

}
}