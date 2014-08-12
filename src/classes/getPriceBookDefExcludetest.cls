@istest(seealldata = true)
private class  getPriceBookDefExcludetest{

 public static testmethod void m1(){
 list<Price_Book_Definition__c> pbdlst = new list<Price_Book_Definition__c>();
 Price_Book_Definition__c pbd = new Price_Book_Definition__c();
 pbd.Name = 'test';
 pbd.Type__c = 'SMSA';
 pbd.Discount_Type__c = 'Amount';
 pbd.Discount_Value__c = 4;
 pbdlst.add(pbd);
 insert pbdlst;
 
 Product_Model__c pm = new Product_Model__c();
 pm.Name = 'testa';
 insert pm;
 
     // Create a new product
Product2 product = new Product2();
product.Name='Additional Client Licenses';
product.IsActive=true;
product.Profit_Center__c = 'test';
product.Family = 'Family';
product.Failover_Environments_Allowed__c = 4;
product.Test_Environments_Allowed__c = NULL;
product.Part_Number__c = 'test';
insert product ;
 
Price_Book_Exclude__c pbe = new Price_Book_Exclude__c();
pbe.Price_Book_Definition__c = pbd.id;
//pbe.Product_Model__c = pm.id;
pbe.Product__c = product.id;
insert pbe;
 
getPriceBookDefExclude.getPriceBookDefExclude(pbdlst);

 
 
 
 
  }
  
  
}