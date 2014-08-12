trigger UpdateProfitCenter on Product2 (before insert, before update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
  private list<Product2> listOfproduct = new list<Product2>();
  /* 
    if product insert, then it checks whether Brand and Library are not null. If so, it further add this in to list of product for update the profit center.
  */
  if(Trigger.isInsert){
    for(Product2 product: Trigger.new){
     if(product.Brand__c != '' && product.Library__c != ''){       
       listOfproduct.add(product);
      }
    }
  }
  /*
    If product get update, it check whether brand and library change its previous value.
  */
  if(Trigger.isUpdate){
   for(Product2 product : Trigger.new){
    if(Trigger.newMap.get(product.Id).Library__c != Trigger.oldMap.get(product.Id).Library__c || Trigger.newMap.get(product.Id).Brand__c != Trigger.oldMap.get(product.Id).Brand__c){
        listOfproduct.add(product); 
    }
   }
  }
  if(listOfproduct.size() > 0){   
    updateProfitCenter(listOfproduct);
  }
  /*
    Profit center got update based on the respective condition.
  */
  private void updateProfitCenter(list<Product2> products){
    for(Product2 product :products){
      if(product.Library__c == 'ECM' && product.brand__c == 'Perceptive'){
        product.Profit_Center__c = '30001';
      }
      else if(product.Library__c == 'ECM' && product.brand__c == 'OEM'){
        product.Profit_Center__c = '30002';
      }
      else if(product.Library__c == 'ECM' && product.brand__c == 'Dell'){
        product.Profit_Center__c = '30003';
      }
      else if(product.Library__c == 'BPM' && product.brand__c == 'Perceptive'){
        product.Profit_Center__c = '30101';
      }
      else if(product.Library__c == 'BPM' && product.brand__c == 'OEM'){
        product.Profit_Center__c = '30102';
      }
      
      else if(product.Library__c == 'Data Capture' && product.brand__c == 'Perceptive'){
        product.Profit_Center__c = '30201';
      }
      else if(product.Library__c == 'Data Capture' && product.brand__c == 'OEM'){
        product.Profit_Center__c = '30202';
      }
      else if(product.Library__c == 'Search' && product.brand__c == 'Perceptive'){
        product.Profit_Center__c = '30301';
      }
      else if(product.Library__c == 'Search' && product.brand__c == 'OEM'){
        product.Profit_Center__c = '30302';
      }
    }
  }
  
}