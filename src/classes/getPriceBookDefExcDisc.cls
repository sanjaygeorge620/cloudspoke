/*
 * This class is used to get all pricebook definition exception discount records 
 * based on the Pricbook definition records passed to it.
 *
 * @author Jennifer Dauernheim 12/22/2011
 */

public with sharing class getPriceBookDefExcDisc {
    
    public static Map<String, Exception_Discount__c> getPriceBookDefExcDisc(List<Price_Book_Definition__c> DefList){
        Map<String, Exception_Discount__c> priceBookDefExcDiscMap = new Map<String, Exception_Discount__c> ();    //string is price book def id + productModel or price book def id + product
        List<Exception_Discount__c> priceBookExcDisc = new List<Exception_Discount__c>();
        
        priceBookExcDisc = [select
                                  id
                                , Price_book_definition__c
                                , Product__c
                                , Product_Model__c
                                , Name                  //exclude ID
                                , Discount_Value__c
                                , Discount_Type__c
                            from Exception_Discount__c
                            where Price_book_definition__c in :DefList];
                            
        if (priceBookExcDisc.size()>0){
            //for every record that comes back from the ExcDisc, we need to populate the map with all the records related to the pricebook definition record
            for (Exception_Discount__c  PricebookExcDiscRec : priceBookExcDisc){
                boolean priceBookDefKeyfound;   
                string ExcDiscProduct;
                string ExcDiscProductModel;
                
                //add product row to table if record is available
                system.debug('PricebookExcDiscRec.Product__c:' + PricebookExcDiscRec.Product__c);
                if (PricebookExcDiscRec.Product__c != null){
                    ExcDiscProduct = PricebookExcDiscRec.Price_book_definition__c+ '-' + PricebookExcDiscRec.Product__c;
                    if (priceBookDefExcDiscMap.containsKey(ExcDiscProduct)){            //check to see if the Existing priceBookDefExcDiscMap Contains anything
                        priceBookDefKeyfound = true;                                                                //does the existing priceBookDefExcDiscMap have the keyset of the ExcDisc record, we don't need to add it again             
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefExcDiscMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefExcDiscMap.put(ExcDiscProduct,PricebookExcDiscRec);
                    }
                
                }   
                system.debug('priceBookDefExcDiscMap - after product add: ' + priceBookDefExcDiscMap);  
                
                //add product model row to table if record is available
                system.debug('PricebookExcDiscRec.Product_Model__c:' + PricebookExcDiscRec.Product_Model__c);
                if (PricebookExcDiscRec.Product_Model__c != null){
                    ExcDiscProductModel = PricebookExcDiscRec.Price_book_definition__c+ '-' + PricebookExcDiscRec.Product_Model__c;
                    if (priceBookDefExcDiscMap.containsKey(ExcDiscProductModel)){           //check to see if the Existing priceBookDefExcDiscMap Contains anything
                        priceBookDefKeyfound = true;                                                            //does the existing priceBookDefExcDiscMap have the keyset of the ExcDisc record, we don't need to add it again         
                    }else{
                        priceBookDefKeyfound = false;
                    }
                    system.debug('priceBookDefKeyfound: ' + priceBookDefKeyfound);                                  //does the map have a keyset matching the priceBookDefExcDiscMap?
                    
                    // if record is found already, do not add to table(map)
                    if (priceBookDefKeyfound == false){
                        priceBookDefExcDiscMap.put(ExcDiscProductModel,PricebookExcDiscRec);
                    }
                
                }   
                system.debug('priceBookDefExcDiscMap - after product Model add: ' + priceBookDefExcDiscMap);    
            }           
        
        }
        
        return priceBookDefExcDiscMap;
        
        
    }
    
    static testMethod void TestMethod1() 
{

    Test.startTest();
     List<Price_Book_Definition__c> priceBookDefs = new List<Price_Book_Definition__c>();
    Price_Book_Definition__c priceBookDef1 = new Price_Book_Definition__c(Name ='Test Price Book Def -1',
                                                                          Type__c = 'Product',
                                                                          Discount_Type__c = 'Amount',
                                                                          Discount_Value__c = 20);
                                                                         
    priceBookDefs.add(priceBookDef1);   
    Price_Book_Definition__c priceBookDef2 = new Price_Book_Definition__c(Name ='Test Price Book Def -2',
                                                                          Type__c = 'SMSA',
                                                                          Discount_Type__c = 'Percent',
                                                                          Discount_Value__c = 30);
    priceBookDefs.add(priceBookDef2);                                                                      
    Price_Book_Definition__c priceBookDef3 = new Price_Book_Definition__c(Name ='Test Price Book Def -3',
                                                                          Type__c = 'VSOE',
                                                                          Discount_Type__c = 'Percent',
                                                                          Discount_Value__c = 30);
    
    priceBookDefs.add(priceBookDef3);   
    insert priceBookDefs;
    
    List<Product_Model__c> pmList = Data_ProductModels.createProductModels(2);
    List<Product2> product = Data_Product.createProduct(pmList);   
    Exception_Discount__c ed1 = new Exception_Discount__c(Product_Model__c = pmList[0].ID,Price_Book_Definition__c = priceBookDefs[0].ID,Discount_Type__c='Amount',
    Discount_Value__c = 1200);
    insert ed1;
    getPriceBookDefExcDisc.getPriceBookDefExcDisc(priceBookDefs);
   /******Added by Veenu 6/10 ****/
    ed1.product__c=product[0].id;
    update ed1;
    getPriceBookDefExcDisc.getPriceBookDefExcDisc(priceBookDefs);
    Test.stopTest(); 
       
}
}