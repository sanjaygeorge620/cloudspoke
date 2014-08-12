/*
Class Name : LX_TestCtrl_EditPBCurrency
Description : -Test class for coverage of Ctrl_EditPBCurrency_TierPricingOverride 
Created By : Arun thakur(arunsingh6@deloitte.com)
Created Date : 10-6-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Arun thakur      10-6-2013        1000                   Initial Version
*************************************************************************/


@isTest
private class LX_TestCtrl_EditPBCurrency
{

/*   Description: Test method for covering Ctrl_EditPBCurrency_TierPricingOverride
     Param - No Parameters
     Returns - Void
 */
static testMethod void myUnitTest() 
{

        //Create Product 
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
        List<Product2> product = Data_Product.createProduct(pmList);   
        for(product2 pr : product)
        {
        pr.Cost__c = 1000;
        pr.Exclude_from_Pricebook__c = True;
        pr.Fair__c = 123;
        pr.IS_Exclude_From_Price_Book__c = True;
        }
        
        update product;
        
        Price_Book_Currency_Override__c ObjPriceBookCurrencyOverride=new Price_Book_Currency_Override__c();
        ObjPriceBookCurrencyOverride.Product__c=product[0].Id;
        ObjPriceBookCurrencyOverride.Override_Price__c=20;
        ObjPriceBookCurrencyOverride.IsActive__c=true;
        ObjPriceBookCurrencyOverride.Sales_Organization__c='Product';
        insert ObjPriceBookCurrencyOverride;
        
        
        Pricing__c ObjPricing=new Pricing__c();
        ObjPricing.Tier_Minimum__c=10;
        ObjPricing.Cost__c=10;
        ObjPricing.Proposed_Cost__c=100;
        ObjPricing.Fair_Market_Value__c=80;
        ObjPricing.Product_Name__c =product[0].Id;
        insert ObjPricing;      
        
        
        Tier_Pricing_Override__c ObjTierPricingOverride=new Tier_Pricing_Override__c();
        ObjTierPricingOverride.Exception_Value__c=20;
        ObjTierPricingOverride.IsActive__c=true;
        ObjTierPricingOverride.Price_Book_Currency_Override__c=ObjPriceBookCurrencyOverride.Id;
        ObjTierPricingOverride.Product_Name__c= product[0].Id;
        ObjTierPricingOverride.PricingRecord__c=ObjPricing.id;
        insert ObjTierPricingOverride;
        
        PageReference pageRef = Page.EditPBCurrencyandTierPricingOverride;
        pageRef.getParameters().put('prodId', product[0].Id);
        pageRef.getParameters().put('pbcoId', ObjPriceBookCurrencyOverride.Id);//Price Book Currency Override
        Test.setCurrentPage(pageRef);

        Tier_Pricing_Override__c TempObjTierPricingOverride=new Tier_Pricing_Override__c();
         Test.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController(TempObjTierPricingOverride); 
        Ctrl_EditPBCurrency_TierPricingOverride controller = new Ctrl_EditPBCurrency_TierPricingOverride (stdController); 
        controller.addTierPricingExceptionValues();
        controller.addTierPricingExceptionValues();
        controller.returnToProd();
       
         Test.stopTest();  
      
        
        

}


}