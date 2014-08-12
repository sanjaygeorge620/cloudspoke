/*
 * This class is used to get all pricebook definition exclude records 
 * based on the Pricbook definition records passed to it.
 *
 * @author Jennifer Dauernheim 12/22/2011
 */

public with sharing class getPriceBookDefInclude {
    
    public static Map<String, Price_Book_Include__c> getPriceBookDefInclude(List<Price_Book_Definition__c> DefList){
        Map<String, Price_Book_Include__c> priceBookDefIncludeMap = new Map<String, Price_Book_Include__c> ();    //string is price book def id + productModel or price book def id + product
        List<Price_Book_Include__c> priceBookInclude = new List<Price_Book_Include__c>();
        
        priceBookInclude = [select
                                  id
                                , Price_book_definition__c
                                , Product__c
                                , Product_Model__c
                                , Name                  //exclude ID
                            from Price_Book_Include__c
                            where Price_book_definition__c in :DefList];
                            
        if (priceBookInclude.size()>0){
            //for every record that comes back from the include, we need to populate the map with all the records related to the pricebook definition record
            for (Price_Book_Include__c  priceBookIncludeRec : priceBookInclude){
                boolean priceBookDefKeyfound;   
                string includeProduct;
                string includeProductModel;
                
                //add product row to table if record is available
                system.debug('priceBookIncludeRec.Product__c:' + priceBookIncludeRec.Product__c);
                if (priceBookIncludeRec.Product__c != null){
                    includeProduct = priceBookIncludeRec.Price_book_definition__c+ '-' + priceBookIncludeRec.Product__c;
                    if (priceBookDefIncludeMap.containsKey(includeProduct)){            //check to see if the Existing priceBookDefIncludeMap Contains anything
                        priceBookDefKeyfound = true;                                                                //does the existing priceBookDefIncludeMap have the keyset of the include record, we don't need to add it again             
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefIncludeMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefIncludeMap.put(includeProduct,priceBookIncludeRec);
                    }
                
                }   
                system.debug('priceBookDefIncludeMap - after product add: ' + priceBookDefIncludeMap);  
                
                //add product model row to table if record is available
                system.debug('priceBookIncludeRec.Product_Model__c:' + priceBookIncludeRec.Product_Model__c);
                if (priceBookIncludeRec.Product_Model__c != null){
                    includeProductModel = priceBookIncludeRec.Price_book_definition__c+ '-' + priceBookIncludeRec.Product_Model__c;
                    if (priceBookDefIncludeMap.containsKey(includeProductModel)){           //check to see if the Existing priceBookDefIncludeMap Contains anything
                        priceBookDefKeyfound = true;                                                            //does the existing priceBookDefIncludeMap have the keyset of the include record, we don't need to add it again         
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefIncludeMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefIncludeMap.put(includeProductModel,priceBookIncludeRec);
                    }
                
                }   
                 
                //add pricebookdef to table if record is available
                
                
                    includeProduct = priceBookIncludeRec.Price_book_definition__c;
                    if (priceBookDefIncludeMap.containsKey(includeProduct)){            //check to see if the Existing priceBookDefIncludeMap Contains anything
                        priceBookDefKeyfound = true;                                                                //does the existing priceBookDefIncludeMap have the keyset of the include record, we don't need to add it again             
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefIncludeMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefIncludeMap.put(includeProduct,priceBookIncludeRec);
                    }
                
                    
                
                
                system.debug('priceBookDefIncludeMap - after product Model add: ' + priceBookDefIncludeMap);    
            }           
        
        }
        
        return priceBookDefIncludeMap;
        
        
        
    }
}