public class Ctrl_NewPBCurrencyandTierPricingOverride {

    public string prodId {get;set;}
    public Product2 product{get;set;}
    public List<Tier_Pricing_Override__c> tpoList {get; set;}
    public List<CurrencyandTierPricingWrapper> ctpwList {get; set;}
    public Price_Book_Currency_Override__c pbco {get; set;}
    
    public class CurrencyandTierPricingWrapper {
        public Pricing__c tier{get;set;}
        public String exepText {get;set;}
        public Tier_Pricing_Override__c tpo {get; set;}
        
        public CurrencyandTierPricingWrapper(Pricing__c tierRec) {
            this.tier = tierRec;
            this.tpo = new Tier_Pricing_Override__c();
            this.tpo.PricingRecord__c = tierRec.Id;
            this.tpo.Product_Name__c = tierRec.Product_Name__c;
            this.tpo.IsActive__c = true ;             
        }
    }
    

    public Ctrl_NewPBCurrencyandTierPricingOverride(ApexPages.StandardController controller) {
    
        prodId = ApexPages.currentPage().getParameters().get('prodId');
        ctpwList = new List<CurrencyandTierPricingWrapper>();
        pbco = new Price_Book_Currency_Override__c();
        pbco.Product__c = prodId;
        
        this.product = [select id, name, Family, Part_Type__c, Price_Type__c FROM Product2 Where Id =:prodId];
        pbco.Type__c = product.Part_Type__c ;
        
        if(prodId != null && prodId != '') {                
            for(Pricing__c pri: [Select Id, Name, Cost__c, Fair_Market_Value__c, Parent_Product__c, Product_Name__c, Tier_Minimum__c, Type__c From Pricing__c Where Product_Name__c = :prodId]) {
                CurrencyandTierPricingWrapper ctpw = new CurrencyandTierPricingWrapper(pri);
                ctpwList.add(ctpw);
            }            
        }
    }
    
    public PageReference addTierPricingExceptionValues(){
    
        boolean goodToSave = True;
        
        if (pbco.Name == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Currency Override Name is a required field. Please enter a Currency Override Name to continue.'));
                goodToSave = false;
        }
        
        if (pbco.Product__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Product is a required field. Please pick a Product to continue.'));
                goodToSave = false;
        }
        
        if (pbco.Type__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Type is a required field. Please pick a Type to continue.'));
                goodToSave = false;
        }
        
        if (pbco.Override_Price__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Override Price is a required field. Please enter an Override Price to continue.'));
                goodToSave = false;
        }
        
        if (goodToSave != true){
            return null;
        }
        
        if (goodToSave == true){
        
                for(CurrencyandTierPricingWrapper ctpw: ctpwList) {
                    ctpw.tpo.Price_Book_Currency_Override__c = pbco.Id;
                    if(ctpw.tpo.Exception_value__c == null) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Exception Value is a required field. Please enter a value for each row to continue.'));
                        return null;
                    }
                }
                
                insert pbco;
                tpoList = new List<Tier_Pricing_Override__c>();
                for(CurrencyandTierPricingWrapper ctpw: ctpwList) {
                    ctpw.tpo.Price_Book_Currency_Override__c = pbco.Id;
                    ctpw.tpo.CurrencyIsoCode = pbco.currencyISOCode;
                    tpoList.add(ctpw.tpo);
                }
                
                if(!tpoList.isEmpty()) {
                    insert tpoList;
                }
        }
        
        PageReference newPage = new PageReference ('/'+pbco.id);
            newPage.setRedirect(true);
            return newPage;
 


        
    }
    
    public PageReference returnToProd(){
    
        PageReference newPage = new PageReference ('/'+prodid);
            newPage.setRedirect(true);
            return newPage;
    
    }
    
@isTest(SeeAllData = true)
public static void Ctrl_NewPBCurrencyandTierPricingOverrideTest(){
    
    ApexPages.StandardController sc;
    Product2 prod = new Product2(Fair__c = 1000,  Pricing_Count__c = 1000, Tier_Pricing__c = True, Name = 'Test product', Part_Type__c = 'Some Part Type', Price_Type__c = 'HR');
    insert prod;
    
    Pricing__c pricing = new Pricing__c(Cost__c = 100.00, Fair_Market_Value__c = 1000, Product_Name__c = prod.id, Tier_Minimum__c = 1000);
    insert pricing;
    
    CurrencyandTierPricingWrapper wrapper = new CurrencyandTierPricingWrapper(pricing);
    
    ApexPages.CurrentPage().getParameters().put('prodId', prod.id);
    Ctrl_NewPBCurrencyandTierPricingOverride ctrl = new Ctrl_NewPBCurrencyandTierPricingOverride(sc);
    PageReference pr = ctrl.addTierPricingExceptionValues();
    PageReference newPage = ctrl.returnToProd();
    System.assertEquals(null, pr);
    System.assertNotEquals(null, newPage);   
}

}