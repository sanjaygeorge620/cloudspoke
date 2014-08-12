/*
 * This class is used to get all pricebook definition exclude records 
 * based on the Pricbook definition records passed to it.
 *
 * @author Jennifer Dauernheim 12/22/2011
 */

public with sharing class getPriceBookDefExclude {
    
    public static Map<String, Price_Book_Exclude__c> getPriceBookDefExclude(List<Price_Book_Definition__c> DefList){
        Map<String, Price_Book_Exclude__c> priceBookDefExcludeMap = new Map<String, Price_Book_Exclude__c> ();    //string is price book def id + productModel or price book def id + product
        List<Price_Book_Exclude__c> priceBookExclude = new List<Price_Book_Exclude__c>();
        
        priceBookExclude = [select
                                  id
                                , Price_book_definition__c
                                , Product__c
                                , Product_Model__c
                                , Name                  //exclude ID
                            from Price_Book_Exclude__c
                            where Price_book_definition__c in :DefList];
                            
        if (priceBookExclude.size()>0){
            //for every record that comes back from the exclude, we need to populate the map with all the records related to the pricebook definition record
            for (Price_Book_Exclude__c  PricebookExcludeRec : priceBookExclude){
                boolean priceBookDefKeyfound;   
                string excludeProduct;
                string excludeProductModel;
                
                //add product row to table if record is available
                system.debug('PricebookExcludeRec.Product__c:' + PricebookExcludeRec.Product__c);
                if (PricebookExcludeRec.Product__c != null){
                    excludeProduct = PricebookExcludeRec.Price_book_definition__c+ '-' + PricebookExcludeRec.Product__c;
                    if (priceBookDefExcludeMap.containsKey(excludeProduct)){            //check to see if the Existing priceBookDefExcludeMap Contains anything
                        priceBookDefKeyfound = true;                                                                //does the existing priceBookDefExcludeMap have the keyset of the exclude record, we don't need to add it again             
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefExcludeMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefExcludeMap.put(excludeProduct,PricebookExcludeRec);
                    }
                
                }   
                system.debug('priceBookDefExcludeMap - after product add: ' + priceBookDefExcludeMap);  
                
                //add product model row to table if record is available
                system.debug('PricebookExcludeRec.Product_Model__c:' + PricebookExcludeRec.Product_Model__c);
                if (PricebookExcludeRec.Product_Model__c != null){
                    excludeProductModel = PricebookExcludeRec.Price_book_definition__c+ '-' + PricebookExcludeRec.Product_Model__c;
                    if (priceBookDefExcludeMap.containsKey(excludeProductModel)){           //check to see if the Existing priceBookDefExcludeMap Contains anything
                        priceBookDefKeyfound = true;                                                            //does the existing priceBookDefExcludeMap have the keyset of the exclude record, we don't need to add it again         
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefExcludeMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefExcludeMap.put(excludeProductModel,PricebookExcludeRec);
                    }
                
                }   
                system.debug('priceBookDefExcludeMap - after product Model add: ' + priceBookDefExcludeMap);    
            }           
        
        }
        
        return priceBookDefExcludeMap;
        
        
    }
}