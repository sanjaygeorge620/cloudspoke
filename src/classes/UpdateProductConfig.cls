public with sharing class UpdateProductConfig {
@Future

    public static void UpdateProductConfig(Set<ID> prodConfigIds) {
    	
   
    List<Product_Configuration__c> productConfigs = new List<Product_Configuration__c>();
    List<Product_Configuration__c> configs = new List<Product_Configuration__c>([Select id, 
        																					status__c ,
        																					ProductRelease__r.Status__c
        																					from Product_Configuration__c 
        																					where productRelease__c IN :prodConfigIds]);
	      																					
                // TODO: Create an inner for loop to loop through the releases list
            system.debug('config size:' + configs.size());
            for (Product_Configuration__c configList : configs){
                configlist.status__c = configList.ProductRelease__r.status__C;
                productConfigs.add(configList);
                system.debug('Productconfigs size:' + ProductConfigs.size());
                if (productConfigs.size()> 100){
                    update productConfigs;
                    productConfigs.clear();
                }
            }
            if (productConfigs.size()>0) {
                update productConfigs;
                productConfigs.clear();
            }
    
 	}
}