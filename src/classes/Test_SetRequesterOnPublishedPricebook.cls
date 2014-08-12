/**
 *
 */
@isTest
private class Test_SetRequesterOnPublishedPricebook {

    static testMethod void testSetRequester() {
        Price_Book_Maker__c priceBookMaker = createPriceBookMaker();
        List<Published_Price_Book__c> publishedPriceBooks = CreatePublishedPriceBooks(priceBookMaker.id);
        publishedPriceBooks.get(0).Set_Requester__c = true;
        publishedPriceBooks.get(2).Set_Requester__c = true;
        update publishedPriceBooks;
        Set<Id> publishedPriceBookIdSet = new Set<Id>();
        System.debug('---Megha--'+publishedPriceBooks);
        for(Published_Price_Book__c publishedPriceBook : publishedPriceBooks){
            publishedPriceBookIdSet.add(publishedPriceBook.id);
        }
        Integer count = 0;
        for(Published_Price_Book__c ppb : [select Id, Requester__c from Published_Price_Book__c where id in : publishedPriceBookIdSet]){
            if(Math.mod(count, 2)==0){
            //VT 8/25 Commented    System.assertEquals(ppb.Requester__c, System.UserInfo.getUserId());
            }else{
                System.assertEquals(ppb.Requester__c, null);
            }
            count++;
        }
        
    }
    
    public static List<Published_Price_Book__c> CreatePublishedPriceBooks(String pbmId){
        
        List<Published_Price_Book__c> publishedPbs = new List<Published_Price_Book__c>();
        Published_Price_Book__c ppb1 = new Published_Price_Book__c(Price_Book_Maker_ID__c =pbmId,Price_Book_Type__c='Product',Name='Test PPB - 1');
        publishedPbs.add(ppb1);
    
        Published_Price_Book__c ppb2 = new Published_Price_Book__c(Price_Book_Maker_ID__c =pbmId,Price_Book_Type__c='SMSA',Name='Test PPB - 2');
        publishedPbs.add(ppb2);
    
        Published_Price_Book__c ppb3 = new Published_Price_Book__c(Price_Book_Maker_ID__c =pbmId,Price_Book_Type__c='VSOE',Name='Test PPB - 3',isParent__c =true);
        publishedPbs.add(ppb3);
    
        insert publishedPbs;
        return publishedPbs;
  }
  
  public static Price_Book_Maker__c createPriceBookMaker(){
    Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Submitted');
    insert priceBookMaker;
    return priceBookMaker;
  }
}