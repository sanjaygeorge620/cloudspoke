trigger SetForcastFamily on Product_Model__c(before insert,before update) {



 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
Set<Id> pmIdSet= new Set<Id>();
List<Product2> ProList = new List<Product2>();
  
    for(Product_Model__c pmObj : Trigger.New){
      pmIdSet.add(pmObj.Id);
    }
    if(pmIdSet.size()>0){
      ProList=[Select Id,Family,Product_Model__c,LX_Originating_Division__c from Product2 where Product_Model__c IN :pmIdSet and  Product_Model__c  != null];
    }
    if(trigger.IsInsert){
    for(Product_Model__c pmObj1 : Trigger.New){
      for(Product2 p2:ProList){
        if(pmObj1.id==p2.Product_Model__c){
          if(p2.LX_Originating_Division__c=='Perceptive'){
            p2.Family=pmObj1.Series__c;
          }
          else{
            p2.Family=pmObj1.Line__c;
          }  
        }
      }
    } 
  }  
  if(trigger.IsUpdate){
    for(Product_Model__c pmObj1 : Trigger.New){
      for(Product2 p2:ProList){
        if(pmObj1.id==p2.Product_Model__c){
          if(p2.LX_Originating_Division__c=='Perceptive'){
            p2.Family=pmObj1.Series__c;
          }
          else{
            p2.Family=pmObj1.Line__c;
          }  
        }
      }
    } 
  } 
  update proList;
}