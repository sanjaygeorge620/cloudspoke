@isTest(seealldata = true)
private class testOrder_Products  {
public static testmethod void orderprod () {


 Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;

Order__c ord = new Order__c();
ord.Name = 'test';
ord.Opportunity__c=opp.Id;
insert ord;
  
  
  // Create a new product
Product2 product = new Product2();
product.Name='Additional Client Licenses';
product.IsActive=true;
insert product ;
 
 
//Create a custom pricebook
Pricebook2 pb= [select Id,IsActive from PriceBook2 where IsStandard=True];
if(pb!=null)
{
pb.IsActive = true;
update pb;
}
// Create a pricebook entry for custom pricebook
PricebookEntry pbe = new PricebookEntry();
pbe.UseStandardPrice = false;
pbe.Pricebook2Id=pb.id;
pbe.Product2Id=product.id;
pbe.IsActive=true;
pbe.UnitPrice=100.0;
//pbe.UseStandardPrice =true;
insert pbe;
 
 
OpportunityLineItem NewRec = new OpportunityLineItem();
NewRec.UnitPrice=200;
NewRec.Quantity=3;
NewRec.OpportunityId=opp.Id;
NewRec.PricebookEntryId=pbe.id;
//NewRec.Product2id =product.id;
insert NewRec;
 
 
  ApexPages.StandardController sc = new ApexPages.standardController(ord);
  ApexPages.currentPage().getParameters().put('id',ord.id);
  Order_Products ordprod = new Order_Products(sc);
  
  ordprod.getOrderLineItems();
                 }
                 
       }