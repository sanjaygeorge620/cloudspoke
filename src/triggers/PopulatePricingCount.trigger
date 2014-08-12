trigger PopulatePricingCount on Pricing__c (after insert, after delete) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    List<Pricing__c> pricingList = Trigger.isInsert ? Trigger.new : Trigger.old;

    List<Id> pricingIds = new List<Id>();
    for (Pricing__c p : pricingList) {
        pricingIds.add(p.Product_Name__c);
    }
    
    List<Product2> products = [
            select
                id,
                (select id from pricing__r),
                pricing_count__c
            from
                product2
            where
                id in :pricingIds];

    for (Product2 product : products) {
        product.pricing_count__c = product.pricing__r.size();
        // if there are no pricing records, disable tier pricing
        if (product.pricing_count__c == 0) {
            product.tier_pricing__c = false;
        }
    }
    update products;
}