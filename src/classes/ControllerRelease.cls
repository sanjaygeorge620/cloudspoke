//Controller for Clone page used for Cloning a Release
public class ControllerRelease 
{
    private ProductRelease__c release;
    ApexPages.StandardController standardController;
    private Id previousPage;
    private String newReleaseStr;    
    
    public ControllerRelease(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.release = (ProductRelease__c)pcfController.getRecord();

        
    }

    
    public PageReference back()
    {
        PageReference pageRef;
        pageRef = new PageReference('/' + release.Id);
        return pageRef;
        
    }
    
    public PageReference returnNewObject(String id)
    {
        PageReference pageRef;
        pageRef = new PageReference('/' + id);
        return pageRef;
        
    }
    
    public PageReference cloneRelease()
    {
        if(release.New_Major__c == null || 
            release.New_Minor__c == null
            || release.New_Increment__c == '')
        {
            
            return back();
        }
        
        //Create a new Release
        STRING NAMER = release.new_major__c.rOUND() + '.'+release.new_minor__c.Round()+'.'+release.new_increment__c;
        ProductRelease__c newRelease = new ProductRelease__c(NAME = nAMER,major__c = release.new_major__c,minor__c = release.new_minor__c,increment__c = release.new_increment__c,brand__c = release.brand__c,status__c = 'In Development');

        

        
        try
        {
            insert newRelease;
            newRelease = [select id, release__c, major__c, minor__c, increment__c from ProductRelease__c where id =: newRelease.id];     
            //Don't continue trying to clone when insert fails
            cloneProductConfigs(newRelease);            
        }
        catch(Exception e){}
        if(newRelease.id!=null)
            return returnNewObject(newRelease.id);
        return back();      
    }
    
    
    public void cloneProductConfigs(ProductRelease__c newRelease)
    {
        
        //Get ProductConfigs for this release
        Map<Id, Product_Configuration__c> currentProdConfigs = getProductConfigurations();
             
        List<Product_Configuration__c> newProdConfigs = new List<Product_Configuration__c>();
        
        for(Product_Configuration__c prodConfig : currentProdConfigs.values())
        {
            Product_Configuration__c newProdConfig = prodConfig.clone(false, true);
            newProdConfig.Product__c = prodConfig.Product__c;
            newProdConfig.ProductRelease__c = newRelease.Id;
            newProdConfig.status__c = 'In Development';
            newProdConfig.CloneParent__c = prodConfig.id;
            newProdConfigs.add(newProdConfig);
            
        }
        try
        {
            if(newProdConfigs.size() > 0)
            {
                insert newProdConfigs;
            }
        }
        catch(Exception e)
        {
        }
       
       set<ID> newProdConfigIds = new Set<ID>();
        
       if(!newProdConfigs.isEmpty())
       {
       for(Product_Configuration__c P : newProdConfigs)
       {
       newProdConfigIds.add(P.id);
       }
                       
            cloneProductComponents.Clone(newProdConfigIds);
            cloneProductLicenseOptions.Clone(newProdConfigIds); 
            cloneProductPlatforms.Clone(newProdConfigIds);  
            cloneProductDatabase.Clone(newProdConfigIds);  
            
        }
            
                  
    }
    
    private Map<Id, Product_Configuration__c> getProductConfigurations()
    {
        Map<Id, Product_Configuration__c> prodConfigsMap = new Map<Id, Product_Configuration__c>();
        List<Product_Configuration__c> prodConfigs = new List<Product_Configuration__c>();
        try{
            prodConfigs = [select id, name, Product__c, ProductRelease__c from Product_Configuration__c where ProductRelease__c =: release.id];
        }catch(Exception e){}
        
        System.debug('Size of prodConfigs in getProductConfigurations is: ' + prodConfigs.size() + '\n releaseId: ' + release.id);
        
        for(Product_Configuration__c prodConfig : prodConfigs){
            prodConfigsMap.put(prodConfig.id, prodConfig);
        }
        
        return prodConfigsMap;
    }

    
}