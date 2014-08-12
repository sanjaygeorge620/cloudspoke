public class Ctrl_EditPBCurrency_TierPricingOverride {

    public string prodId {get;set;}
    public string pbcoId{get;set;}
    
    public Product2 product{get;set;}   
    public Price_Book_Currency_Override__c pbco {get; set;}
    public Price_Book_Currency_Override__c pbco2 {get; set;}
    
    public List<Tier_Pricing_Override__c> tpo2 {get; set;}
    public List<Tier_Pricing_Override__c> tpoList {get; set;}
    public List<CurrencyandTierPricingWrapper> ctpwList {get; set;}
    
    public class CurrencyandTierPricingWrapper {

        public Decimal tierMinimum {get;set;}
        public Decimal listPrice {get; set;}
        public Decimal exepValue {get;set;}
        
        public boolean IsActive {get;set;}
        
        public Tier_Pricing_Override__c tpo {get; set;}
        Public String name{get; set;}
        
        public CurrencyandTierPricingWrapper(Tier_Pricing_Override__c localTPO) { //Pricing__c tierRec) {
            tpo = new Tier_Pricing_Override__c();
            if(localTPO != null) {
                tpo = localTPO;
                name = localTPO.Name;
                tierMinimum  = localTPO.Pricing_Record_Tier_Minimum__c;
                IsActive = localTPO.IsActive__c;
                listPrice = localTPO.Pricing_Record_Cost__c;
                exepValue = localTPO.Exception_Value__c;
            }          
        }
    }
    

    public Ctrl_EditPBCurrency_TierPricingOverride(ApexPages.StandardController controller) {
    
        prodId = ApexPages.currentPage().getParameters().get('prodId');
        pbcoId = ApexPages.currentPage().getParameters().get('pbcoId');
        ctpwList = new List<CurrencyandTierPricingWrapper>();
        pbco = new Price_Book_Currency_Override__c();
        pbco.Product__c = +prodId;
        
        this.pbco2 = [Select Id, Name, Override_Price__c, Product__c, Sales_Organization__c, Type__c, Include_In_Standard_Price_Books__c, CurrencyIsoCode
                      From Price_Book_Currency_Override__c
                      Where Id = :pbcoId];
        
        this.product = [select id, name, Family , Part_Type__c, Price_Type__c FROM Product2 Where Id =:prodId];
        pbco.Type__c = product.Part_Type__c;
        
        this.product = [select id, name, Family, Part_Type__c, Price_Type__c FROM Product2 Where Id =:prodId];
        
        if(prodId != null && prodId != '') {                
            
            
            this.tpo2 = [Select Id, Name, CurrencyISOCode, Exception_Value__c, IsActive__c, Price_Book_Currency_Override__c, PricingRecord__c, Pricing_Record_Cost__c, Pricing_Record_Tier_Minimum__c, Product_Name__c 
                         From Tier_Pricing_Override__c where Price_Book_Currency_Override__c=:pbcoId Order by Pricing_Record_Tier_Minimum__c ASC];

            Set<Id> existPricRecIdSet = new Set<Id>();
            
            for(Tier_Pricing_Override__c tpo: tpo2) {
                existPricRecIdSet.add(tpo.PricingRecord__c);
                CurrencyandTierPricingWrapper ctpw = new CurrencyandTierPricingWrapper(tpo);
                ctpwList.add(ctpw);
            }   
                    
            for(Pricing__c pri: [Select Id, Name, Cost__c, Fair_Market_Value__c, Parent_Product__c, Product_Name__c, Tier_Minimum__c, Type__c From Pricing__c Where Product_Name__c = :prodId]) {
                if(!existPricRecIdSet.contains(pri.Id)) {
                    Tier_Pricing_Override__c tpo = null;
                    CurrencyandTierPricingWrapper ctpw = new CurrencyandTierPricingWrapper(tpo);
                    ctpw.tpo.PricingRecord__c = pri.Id;
                    ctpw.tpo.Price_Book_Currency_Override__c = pbcoId; 
                    ctpw.tierMinimum  = pri.Tier_Minimum__c;
                    ctpw.listPrice = pri.Cost__c;
                    ctpwList.add(ctpw);                    
                }
            }
        }
    }
    
    public PageReference addTierPricingExceptionValues(){
    
       
        boolean goodToSave = True;
        
        update pbco2;
        
        //update tpo2;
        //upsert tpo2;
        /*
        
        if (pbco.Override_Price__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Override Price is a required field. Please enter an Override Price to continue.'));
                goodToSave = false;
        }
        */
        
        if (goodToSave != true){
            return null;
        }
        
        if (goodToSave == true){
        
                for(CurrencyandTierPricingWrapper ctpw: ctpwList) {
                    ctpw.tpo.currencyISOCode = pbco.CurrencyISOCode;
                    if(ctpw.tpo.Exception_value__c == null) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Exception Value is a required field. Please enter a value for each row to continue.'));
                        return null;
                    }
                }
                
                //insert pbco;
                tpoList = new List<Tier_Pricing_Override__c>();
                for(CurrencyandTierPricingWrapper ctpw: ctpwList) {
                    ctpw.tpo.currencyISOCode = pbco2.CurrencyISOCode;
                }
                for(CurrencyandTierPricingWrapper ctpw: ctpwList) {
                    tpoList.add(ctpw.tpo);
                }
                
                if(!tpoList.isEmpty()) {
                    upsert tpoList;
                }
        }
        
        PageReference newPage = new PageReference ('/'+pbcoId);
            newPage.setRedirect(true);
            return newPage;

        
    }
    
    public PageReference returnToProd(){
    
        PageReference newPage = new PageReference ('/'+pbcoId);
            newPage.setRedirect(true);
            return newPage;
 
    
    }

}