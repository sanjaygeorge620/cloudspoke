@IsTest(SeeAllData=true)
public with sharing class Data_ProductModels {
    public static List<Product_Model__c> createProductModels(Integer size){
        List<Product_Model__c> productModels = new List<Product_Model__c>();
        Product_Model__c pm;
        for(Integer i =0; i< size;i++){
            pm = new Product_Model__c(Name = 'Test Model '+i,Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support');
            if(i==0){
                pm.Model__c = 'TestM-'+i;
                pm.Asset_Required__c = true;
            }
            productModels.add(pm);
        }
        insert productModels;
        return productModels;
        
    }
    static testMethod void testTestData() {
         List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
         System.assertEquals(pmList.size(),3); 
    }  
}