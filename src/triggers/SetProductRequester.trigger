//VT7/15: modifying to make it before insert, before update
//to update the product family field based on originating division and product family/product line
trigger SetProductRequester on Product2 (before update,before insert) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
  Set<Id> proIdSet= new Set<Id>();  
  Map<id,Product_Model__c> PromoMap = new Map<id,Product_Model__c>();  
    
      for(Product2 Testprod : Trigger.New){
        proIdSet.add(Testprod.Product_Model__c);
      }
      
      if(proIdSet.size()>0){
        PromoMap.putAll([Select Division__c,Line__c,Series__c from Product_Model__c where Id IN :proIdSet]);
      }
      
      if(trigger.IsInsert){
      for(Product2 productVar : Trigger.New){
          if(PromoMap.containsKey(productVar.Product_Model__c)){
            if(productVar.LX_Originating_Division__c=='Perceptive'){
              productVar.Family=PromoMap.get(productVar.Product_Model__c).Series__c;
            }
            else{
              productVar.Family=PromoMap.get(productVar.Product_Model__c).Line__c;
            }
          }
      }         
    }
    

    if(trigger.IsUpdate){
    //VT7/15 added the if condition while changing trigger from before update to BIBU    
      for(Product2 productVar : Trigger.New){
          if(PromoMap.containsKey(productVar.Product_Model__c)){
            if((productVar.Product_Model__c != trigger.OldMap.get(productVar.id).Product_Model__c)||(trigger.OldMap.get(productVar.id).LX_Originating_Division__c!=productVar.LX_Originating_Division__c)){
              if(productVar.LX_Originating_Division__c=='Perceptive'){
                productVar.Family=PromoMap.get(productVar.Product_Model__c).Series__c;
              }
              else{
                productVar.Family=PromoMap.get(productVar.Product_Model__c).Line__c;
              }
              if(productVar.Set_Requester__c){
                productVar.Requester__c = System.Userinfo.getUserId();
              }
              else{
                productVar.Requester__c =Null; 
              }  
            }
          }
      }          
  }
}