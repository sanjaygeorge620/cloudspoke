public class ControllerProductConfiguration {
    
    private static final string ADD = 'add';
    private static final String DEL = 'delete';
    private static final String CHK_PREFIX = 'CHBX';
    
    private Product_Configuration__c pc;
    private Id releaseMasterId;
    //private Product_Release_Master__c releaseMaster;
    ApexPages.StandardController standardController;
    
    private string action = null;
    public String buttonsRender {set;}
    public String blockRender {set;}
     
    public boolean isEdit {get;set;}
    public ControllerProductConfiguration(ApexPages.StandardController pcController){
        standardController = pcController;
        this.pc = (Product_Configuration__c)pcController.getRecord();
        isEdit = false;
        //If page is coming from a edit link, url contains retURL
        if(ApexPages.currentPage().getParameters().get('retURL') != null){
            isEdit = true;
        }
    }

    //Get all platforms that have not been added or existing platforms to be deleted
    public List<License_Option_Master__c> getAllLicenseOptions(){
        List<License_Option_Master__c> lineItems = new List<License_Option_Master__c>();
        if(action == ADD)
            lineItems = getAllLicenseOptionsWithAction(ADD);
        else if(action == DEL)
            lineItems = getAllLicenseOptionsWithAction(DEL);
            
        return lineItems;
    }

    public List<License_Option_Master__c> getAllLicenseOptionsWithAction(String action){
        List<License_Option_Master__c> lineItems = new List<License_Option_Master__c>();
        
        //Return none
     //    if(pc.Product__c==null){
         if(pc.Internal_Product__c==null){

      return lineItems;
        }
        Set<Id> loMasters = new Set<Id>();
        try{
            for(List<Product_License_Option__c> productLicenceOptions : [   
                    select License_Option__c
                    from Product_License_Option__c 
                    where Brand__c =:pc.Brand__c and 
                    Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c
                    ])
            {
                for(Product_License_Option__c lo : productLicenceOptions){
                    loMasters.add(lo.License_Option__c);    
                }
            }
        }catch(Exception e){}
        
        if(action == ADD){
            
            //Get product license options that are match the brand, release and product 
            lineItems = 
                [select name, id, Description__c, License_Option_ID__c
                from License_Option_Master__c
                where id not in :loMasters 
                order by Description__c];
            
        }else if(action == DEL){
        
            lineItems = 
                [select name, id, Description__c, License_Option_ID__c
                from License_Option_Master__c
                where id in :loMasters 
                order by Description__c];
        }
        return lineItems;   
        
    }
    
    //Save License Options and create/delete ProductLicenseOption objects as needed
    public PageReference saveLicenseOption(){
        List<Product_License_Option__c> prodLOs = new List<Product_License_Option__c>();
        List<String> foundIds = getCheckBoxIds();

        if(action==ADD){
            List<License_Option_Master__c> addedLOs = 
                    [   select id, name, Description__c, License_Option_ID__c 
                        from License_Option_Master__c 
                        where id in:foundIds]; 
            
            
            //For each of these values, create new entry in contraint table
            for(License_Option_Master__c loMaster : addedLOs){
                
                    //create new entry in contraint table 
                    Product_License_Option__c prodLO = new Product_License_Option__c();
                    prodLO.License_Option__c = loMaster.id;
                    prodLO.Brand__c = pc.brand__c;
                    //prodLO.Release__c = pc.Release_Value__c;
                    prodLO.product__c = pc.Product_Name__c;
                    prodLO.ProductConfig__c = pc.id;
                    prodLOs.add(prodLO);
            }
            
            if(prodLOs.size()>0){
                insert prodLOs;
            }
        }else if(action==DEL){
            List<Product_License_Option__c> toBeDeletedLicenseOptions = 
                    [select id from Product_License_Option__c 
                    where brand__c =: pc.brand__c and Release__c =: pc.Release_Value__c and product__c =: pc.Product_Name__c and License_Option__c in:foundIds ];   
            
            if(toBeDeletedLicenseOptions.size()>0){
                delete toBeDeletedLicenseOptions;
            }
        }
        
        return viewConfiguration();     
    }   


    public List<Component_Master__c> getAllComponents(){
        List<Component_Master__c> lineItems = new List<Component_Master__c>();
        if(action == ADD)
            lineItems = getAllComponentsWithAction(ADD);
        else if(action == DEL)
            lineItems = getAllComponentsWithAction(DEL);
            
        return lineItems;
        
    }
    
    public List<Component_Master__c> getAllComponentsWithAction(String action){
        List<Component_Master__c> lineItems = new List<Component_Master__c>();
        
        //Return none
        if(pc.Product__c==null){


          return lineItems;
        }
        Set<Id> compMasters = new Set<Id>();
        try{
            for(List<Product_Component__c> productComponents : [    
                    select Component__c
                    from Product_Component__c 
                    where Brand__c =:pc.Brand__c and 
                    Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c
                    ])
            {
                for(Product_Component__c comp : productComponents){
                    compMasters.add(comp.Component__c); 
                }
            }
        }catch(Exception e){}
        
        if(action == ADD){
            
            //Get product component that are match the brand, release and product 
            //lineItems = 
                for(List<Component_Master__c> componentsMaster : [  
            
                    select name, id, Component_Description__c, Component_Name__c, Component_Status__c, Product_Manager__r.Name
                    from Component_Master__c
                    where id not in :compMasters 
                    order by Component_Name__c]){
                        
                    for(Component_Master__c c : componentsMaster){
                        lineItems.add(c);   
                    }     
               }
            
        }else if(action == DEL){
        
                for(List<Component_Master__c> componentsMaster : [  
                    select name, id, Component_Description__c, Component_Name__c, Component_Status__c, Product_Manager__r.Name
                    from Component_Master__c
                    where id in :compMasters 
                    order by Component_Name__c]){
                        
                    for(Component_Master__c c : componentsMaster){
                        lineItems.add(c);   
                    }     
                    
                }
        }
        return lineItems;       
    
    }
    
    public List<Component_Master__c> getCurrentComponents(){
        List<Product_Component__c> productComponents = 
                [select Component__c 
                from Product_Component__c 
                where Brand__c =:pc.Brand__c and Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c];
        
        List<Id> compMasters = new List<Id>();
            for(Product_Component__c db : productComponents){
                compMasters.add(db.Component__c);   
            }
        
        List<Component_Master__c> lineItems = 
                [select name, Component_Description__c, Component_Name__c, Component_Status__c, Product_Manager__r.Name
                from Component_Master__c
                where id in :compMasters 
                order by Component_Description__c];
        
        return lineItems;
    }
    public PageReference edit(){
        isEdit = true;
        return null;
    }
    //Save Components and create/delete ProductComponent objects as needed
    public PageReference saveComponent(){
        List<Product_Component__c> prodComponents = new List<Product_Component__c>();
        List<String> foundIds = getCheckBoxIds();

        if(action==ADD){
            List<Component_Master__c> addedComponents = 
                    [   select id, name, Component_Description__c, Component_Name__c, Component_Status__c, Product_Manager__r.Name 
                        from Component_Master__c 
                        where id in:foundIds]; 
            
            
            //For each of these values, create new entry in contraint table
            for(Component_Master__c compMaster : addedComponents){
                
                    //create new entry in contraint table 
                    Product_Component__c prodComp = new Product_Component__c();
                    prodComp.Component__c = compMaster.id;
                    prodComp.Brand__c = pc.brand__c;
                    //prodComp.Release__c = pc.Release_Value__c;
                    prodComp.product__c = pc.Product_Name__c;
                    prodComp.ProductConfig__c = pc.id;
                    prodComponents.add(prodComp);
            }
            
            if(prodComponents.size()>0){
                insert prodComponents;
            }
        }else if(action==DEL){
            List<Product_Component__c> toBeDeletedComponents = 
                    [select id from Product_Component__c 
                    where brand__c =: pc.brand__c and Release__c =: pc.Release_Value__c and product__c =: pc.Product_Name__c and Component__c in:foundIds ];    
            
            if(toBeDeletedComponents.size()>0){
                delete toBeDeletedComponents;
            }
        }
        
        return viewConfiguration();     
    }
    
    //Get the Platforms to show based on the action.    
    public List<Platform_Master__c> getAllPlatformsWithAction(String action){
        List<Platform_Master__c> lineItems = new List<Platform_Master__c>();
        List<Product_Platform__c> productPlatforms = new List<Product_Platform__c>();
        
        //Return none
        if(pc.Product__c==null){
            return lineItems;
        }
        
        if(action == ADD){
            productPlatforms = 
                [select name, platform__c, platform_version__c, platform_master__c
                from Product_Platform__c 
                where Brand__c =:pc.Brand__c and Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c];
            
            List<Id> platformMasters = new List<Id>();
            for(Product_Platform__c platform : productPlatforms){
                platformMasters.add(platform.platform_master__c);   
            }
            lineItems = 
                [select name, id, platform__c, platform_version__c
                from Platform_Master__c
                where id not in :platformMasters 
                order by platform__c, platform_version__c];
            
        }else if(action == DEL){
            productPlatforms = 
                [select name, platform__c, platform_version__c, platform_master__c
                from Product_Platform__c 
                where Brand__c =:pc.Brand__c and Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c];
            
            List<Id> platformMasters = new List<Id>();
            for(Product_Platform__c platform : productPlatforms){
                platformMasters.add(platform.platform_master__c);   
            }
            lineItems = 
                [select name, id, platform__c, platform_version__c
                from Platform_Master__c
                where id in :platformMasters 
                order by platform__c, platform_version__c];
        }
        return lineItems;   
    }
    
    //Get all platforms that have not been added or existing platforms to be deleted
    public List<Platform_Master__c> getAllPlatforms(){
        List<Platform_Master__c> lineItems = new List<Platform_Master__c>();
        if(action == ADD)
            lineItems = getAllPlatformsWithAction(ADD);
        else if(action == DEL)
            lineItems = getAllPlatformsWithAction(DEL);
            
        return lineItems;
    }
    
    //Action to save and add/delete platforms as needed
    public PageReference savePlatform(){
        List<Product_Platform__c> productPlatforms = new List<Product_Platform__c>();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        
        List<String> foundIds = getCheckBoxIds();

        if(action==ADD){
            List<Platform_Master__c> addedPlatforms = [select id, name, platform__c, platform_version__c from Platform_Master__c 
                                                                where id in:foundIds]; 
            
            
            //For each of these values, create new entry in contraint table
            for(Platform_Master__c platMaster : addedPlatforms){
                
                    //else, create new entry in contraint table 
                    Product_Platform__c prodPlat = new Product_Platform__c();
                    prodPlat.platform_master__c = platMaster.id;
                    prodPlat.Brand__c = pc.brand__c;
                    //prodPlat.Release__c = pc.Release_Value__c;
                    prodPlat.product__c = pc.Product_Name__c;
                    prodPlat.Platform__c = platMaster.platform__c;
                    prodPlat.platform_version__c = platMaster.platform_version__c;
                    prodPlat.product_master__c = pc.id;
                    productPlatforms.add(prodPlat);
            }
            
            if(productPlatforms.size()>0){
                insert productPlatforms;
            }
        }else if(action==DEL){
            List<Product_Platform__c> toBeDeletedPlatforms = 
                    [select id from Product_Platform__c 
                    where brand__c =: pc.brand__c and Release__c =: pc.Release_Value__c and product__c =: pc.Product_Name__c and platform_master__c in:foundIds ];  
            
            if(toBeDeletedPlatforms.size()>0){
                delete toBeDeletedPlatforms;
            }
        }
        
        return viewConfiguration();
    }

    public List<Platform_Master__c> getCurrentPlatforms(){
        List<Product_Platform__c> productPlatforms = 
                [select platform_master__c
                from Product_Platform__c 
                where Brand__c =:pc.Brand__c and Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c];
        
        List<Id> platformMasters = new List<Id>();
            for(Product_Platform__c platform : productPlatforms){
                platformMasters.add(platform.platform_master__c);   
            }
        
        List<Platform_Master__c> lineItems = 
                [select name, platform__c, platform_version__c
                from Platform_Master__c
                where id in :platformMasters 
                order by platform__c, platform_version__c];
        
        return lineItems;
    }
    
    public List<Database_Master__c> getCurrentDatabases(){
        List<Product_Database__c> productDatabases = 
                [select database_master__c
                from Product_Database__c 
                where Brand__c =:pc.Brand__c and Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c];
        
        List<Id> dbMasters = new List<Id>();
            for(Product_Database__c db : productDatabases){
                dbMasters.add(db.database_master__c);   
            }
        
        List<Database_Master__c> lineItems = 
                [select name, database__c, database_version__c
                from Database_Master__c
                where id in :dbMasters 
                order by database__c, database_version__c];
        
        return lineItems;
    }
    public List<License_Option_Master__c> getCurrentLicenseOptions(){
        List<Product_License_Option__c> productLicenseOptions = 
                [select License_Option__c
                from Product_License_Option__c 
                where Brand__c =:pc.Brand__c and Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c];
        
        List<Id> loMasters = new List<Id>();
            for(Product_License_Option__c db : productLicenseOptions){
                loMasters.add(db.License_Option__c);    
            }
        
        List<License_Option_Master__c> lineItems = 
                [select name, Description__c, License_Option_ID__c
                from License_Option_Master__c
                where id in :loMasters 
                order by Description__c];
        
        return lineItems;
    }
    
    //Get all the databases to be added or need to be deleted
    public List<Database_Master__c> getAllDatabases(){
       
        List<Database_Master__c> lineItems = new List<Database_Master__c>();
        if(action == ADD)
            lineItems = getAllDatabasesWithAction(ADD);
        else if(action == DEL)
            lineItems = getAllDatabasesWithAction(DEL);
            
        return lineItems;
    }
    
    public List<Database_Master__c> getAllDatabasesWithAction(String action){
        List<Database_Master__c> lineItems = new List<Database_Master__c>();
        
        //Return none
        if(pc.Product__c==null){
            return lineItems;
        }
        Set<Id> dbMasters = new Set<Id>();
        try{
            for(List<Product_Database__c> productDatabases : [  select database_master__c
                                                                from Product_Database__c 
                                                                where Brand__c =:pc.Brand__c and 
                                                                Release__c =:pc.Release_Value__c and product__c = : pc.Product_Name__c
                                                                ])
            {
                for(Product_Database__c db : productDatabases){
                    dbMasters.add(db.database_master__c);   
                }
            }
        }catch(Exception e){}
        
        if(action == ADD){
            
            //Get product databases that are match the brand, release and product 
            lineItems = 
                [select name, id, database__c, database_version__c
                from Database_Master__c
                where id not in :dbMasters 
                order by database__c, database_version__c];
            
        }else if(action == DEL){
        
            lineItems = 
                [select name, id, database__c, database_version__c
                from Database_Master__c
                where id in :dbMasters 
                order by database__c, database_version__c];
        }
        return lineItems;   
    }
    
    //Save Database and create/delete ProductDatabase objects as needed
    public PageReference saveDatabase(){
        List<Product_Database__c> dbPlatforms = new List<Product_Database__c>();
        List<String> foundIds = getCheckBoxIds();

        if(action==ADD){
            List<Database_Master__c> addedPlatforms = 
                    [   select id, name, database__c, database_version__c 
                        from Database_Master__c 
                        where id in:foundIds]; 
            
            
            //For each of these values, create new entry in contraint table
            for(Database_Master__c dbMaster : addedPlatforms){
                
                    //create new entry in contraint table 
                    Product_Database__c prodDB = new Product_Database__c();
                    prodDB.database_master__c = dbMaster.id;
                    prodDB.Brand__c = pc.brand__c;
                    //prodDB.Release__c = pc.Release_Value__c;
                    prodDB.product__c = pc.Product_Name__c;
                    prodDB.database__c = dbMaster.database__c;
                    prodDB.database_version__c = dbMaster.database_version__c;
                    prodDB.ProductConfig__c = pc.id;
                    dbPlatforms.add(prodDB);
            }
            
            if(dbPlatforms.size()>0){
                insert dbPlatforms;
            }
        }else if(action==DEL){
            List<Product_Database__c> toBeDeletedPlatforms = 
                    [select id from Product_Database__c 
                    where brand__c =: pc.brand__c and Release__c =: pc.Release_Value__c and product__c =: pc.Product_Name__c and database_master__c in:foundIds ];  
            
            if(toBeDeletedPlatforms.size()>0){
                delete toBeDeletedPlatforms;
            }
        }
        
        return viewConfiguration();     
    }   

    //Get all the checkboxes and find the Ids of each
    public List<String> getCheckBoxIds(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
        
        List<String> foundIds = new List<String>();
        String errMsg = '';
        for(String key : params.keySet()){
            
            String value = params.get(key);
            errMsg = errMsg + 'key: ' + key + ' value: ' + value + '\n';
            if(key.startsWith(CHK_PREFIX)){
                String id = key.substring(4);   
                foundIds.add(id);
            }   
        }
        
        return foundIds;
        
    }
    
    public PageReference viewConfiguration(){
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductConfiguration?id=' + pc.Id);
        return pageRef;
        
    }
    public PageReference viewComponents(){
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductComponents?id=' + pc.Id);
        return pageRef;
        
    }
    public PageReference actionAddComponents(){
        action = ADD;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductComponents?id=' + pc.Id);
        return pageRef;
    }
    public PageReference actionDeleteComponents(){
        action = DEL;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductComponents?id=' + pc.Id);
        return pageRef;
    }
    
    public PageReference actionAddLicenseOptions(){
        action = ADD;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductLicenseOptions?id=' + pc.Id);
        return pageRef;
    }
    public PageReference actionDeleteLicenseOptions(){
        action = DEL;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductLicenseOptions?id=' + pc.Id);
        return pageRef;
    }
    
    public PageReference actionAddPlatforms(){
        action = ADD;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductPlatforms?id=' + pc.Id);
        return pageRef;
    }
    public PageReference actionDeletePlatforms(){
        action = DEL;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductPlatforms?id=' + pc.Id);
        return pageRef;
    }
    public PageReference actionAddDatabases(){
        action = ADD;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductDatabases?id=' + pc.Id);
        return pageRef;
    }
    public PageReference actionDeleteDatabases(){
        action = DEL;
        PageReference pageRef;
        pageRef = new PageReference('/apex/ProductDatabases?id=' + pc.Id);
        return pageRef;
    }
    
    
    //Check to see if Release and Product Development has been selected before allowing any
    //Add or Delete buttons
    public String getButtonsRender(){
        if(pc.ProductRelease__c != null && pc.Product__c != null && isEdit)
            return 'true';
        
        return 'false';
        
    }
    
    //Determines the condition to display the page blocks of all the objects related to this Configuration
    public String getBlockRender(){
        if(pc.ProductRelease__c != null && pc.Product__c != null)
            return 'true';
        
        return 'false';
        
    }
    
    public String getProdAction(){
        return action;  
    }
    /**    
    public List<Platform_Master__c> sortStandard(List<Platform_Master__c> prods,   
        String sortField) { 
         List<Platform_Master__c> resultList = new List<Platform_Master__c>(); 
         Map<String, List<Platform_Master__c>> prodMap = new Map<String, List<Platform_Master__c>>(); 
         for(Platform_Master__c p:prods) { 
            String key = (String)p.get(sortField); 
             if(prodMap.get(key) == null) { 
                    prodMap.put(key, new List<Platform_Master__c>()); 
            } 
             prodMap.get(key).add(p); 
         } 
         List<String> keys = new List<String>(prodMap.keySet()); 
         keys.sort(); 
         for(String key:keys) { resultList.addAll(prodMap.get(key)); } 
         return resultList; 
    } 
    
    public void debug(String message){
        Messaging.SingleEmailMessage mail = new
        Messaging.SingleEmailMessage();

          //mail.setToAddresses( new String[]{'phi@appirio.com'} );
          mail.setToAddresses( new String[]{'aslam.bari@metacube.com'} );
          mail.setSubject('Howdy!');
          mail.setPlainTextBody(message);
        
          Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} );
    }*/
}