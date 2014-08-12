trigger SetRequesterOnPublishedPriceBook on Published_Price_Book__c (before update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    for(Published_Price_Book__c publishedPriceBook : Trigger.New){
         if(publishedPriceBook.Set_Requester__c){
            publishedPriceBook.Requester__c = System.UserInfo.getUserId();
         } else{
            publishedPriceBook.Requester__c = Null;
                     }
    }
}