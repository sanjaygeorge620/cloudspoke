trigger SetPricingRequester on Pricing__c (before update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code

  for(Pricing__c pricing : trigger.New){
    if (pricing.Set_Requester__c) {
      pricing.Requester__c = System.Userinfo.getUserId();
    }
    else {
      pricing.Requester__c = Null;
    }
  }
}