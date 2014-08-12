@isTest
public with sharing class Data_Product {

     public static List<Product2> createProduct(List<Product_Model__c> pmList){ 
            
        List<Product2> prodList = new List<Product2>();
        Integer i = 0;
         
        String varAlias = string.valueof(system.currentTimeMillis());
        system.debug('varAlias' + varAlias);
        Integer aliaslength = varAlias.length();  
        for(Product_Model__c pm : pmList ){
                Product2 product = new Product2();       
                product.Name = 'testAccount';
                product.Part_Type__c='Licensed Software';
                product.Tier_Pricing__c = false;
                product.BigMachines_Category__c ='Training';
                
                product.Status__c = 'General Availability';
                product.Part_Number__c = 'PRO-'+i+varAlias;
                product.Product_Model__c= pm.id;
                product.Environment__c = 'Test';
                product.core_Product__c = true;
                product.Replicate_Full_Environment__c = true;
                product.Exclude_from_Test_Clone__c = true;
                product.Exclude_from_Failover_Clone__c = true;
                product.Test_Environments_Needed__c = 2;
                product.Failover_Environments_Needed__c = 2;
            prodList.add(product);
            i++;
        }
        insert prodList;  
        List<Product_Sub_Item__c> productSubItemList = new List<Product_Sub_Item__c>();
        
        Product2 parentProd = new Product2(name='testproduct', Part_Type__c='Licensed Software',
                               Tier_Pricing__c = false,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+varAlias,
                               Environment__c = 'Test');
                                parentProd.core_Product__c = true;
                            parentProd.Replicate_Full_Environment__c = true;
                            parentProd.Exclude_from_Test_Clone__c = true;
                            parentProd.Exclude_from_Failover_Clone__c = true;
                            parentProd.Test_Environments_Needed__c = 2;
                            parentProd.Failover_Environments_Needed__c = 2;     
       insert parentProd;
                               
        for(Product2 product : prodList){
          productSubItemList.add(new Product_Sub_Item__c(Product__c = product.Id , Parent_Product__c = parentProd.id ));
        }
        insert productSubItemList;     
        return prodList;  
     }
     

      static testMethod void testTestData() {
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
        List<Product2> product = Data_Product.createProduct(pmList);   
        for(product2 pr : product)
        {
        pr.Cost__c = 1000;
        pr.Exclude_from_Pricebook__c = True;
        pr.Fair__c = 123;
        pr.IS_Exclude_From_Price_Book__c = True;
        }
        
        update product;
         System.assertEquals(product.size(),3); 
        }    
       
      }