/******************************************************************************
Name     : SetProdConfNameBeforeInsert
Purpose  : Set Name of new inserted ProductConfig equal to product name of
           related internal product.
Author   : Aashish Mathur
Date     : June 25, 2009
******************************************************************************/

trigger SetProdConfNameBeforeInsert on Product_Configuration__c (before insert, before update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<ID> idSet = new Set<ID>();
    for (Product_Configuration__c prodConf : Trigger.new)
        idSet.add(prodConf.Product__c);
    
    Map<ID, Product2> idToProdDevMap = new Map<ID, Product2>([select id,
            Name from Product2 where id in :idSet]);
    
    for (Product_Configuration__c prodConf : Trigger.new)
        if (idToProdDevMap.get(prodConf.Product__c) != null)
            prodConf.Name = idToProdDevMap.get(prodConf.Product__c).Name;
}