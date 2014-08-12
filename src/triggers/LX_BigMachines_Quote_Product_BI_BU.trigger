/*
Class Name : LX_BigMachines_Quote_Product_BI_BU
Description : As per US4116 to keep the Price on Quote Products & Opportunity Pricelist products in sync. 
Created By : Shubhashish Rai (sanchaudhary@deloitte.com)
Created Date : 25-July-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai    25-July-2014                            Created 
*************************************************************************/

trigger LX_BigMachines_Quote_Product_BI_BU on BigMachines__Quote_Product__c (before insert, before update) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // Added Bypass code
    
    List<id> oppListId = new List<id>();
    Map<id, BigMachines__Quote_Product__c> mpQuoteProduct = new Map<id, BigMachines__Quote_Product__c>();
    List<LX_Opportunity_Pricelist_Product__c> oppPricelistProdListUpdate = new List<LX_Opportunity_Pricelist_Product__c>();
    
    if(trigger.isupdate){
        for(BigMachines__Quote_Product__c bmQuoteProduct : trigger.new){
            mpQuoteProduct.put(bmQuoteProduct.id, bmQuoteProduct);
//            if(trigger.oldMap.get(bmQuoteProduct.id).BigMachines__Sales_Price__c != null && bmQuoteProduct.BigMachines__Sales_Price__c!=null){
                if(trigger.oldMap.get(bmQuoteProduct.id).BigMachines__Sales_Price__c != bmQuoteProduct.BigMachines__Sales_Price__c && bmQuoteProduct.LX_Opportunity_Record_Type_Id__c == Label.LX_QuickBid_RecordTypeId){
                    oppListId.add(bmQuoteProduct.LX_Opportunity_Id__c);                    
                }
//            }
        }
        System.debug('@@@ ' + oppListId);
        System.debug('@@@ size' + oppListId.size());
        
        Map<id,LX_Opportunity_Pricelist_Product__c> mpBmQuoteProductOppPricelistProd ;
        
        
        if(oppListId.size()>0){
            List<LX_Opportunity_Pricelist_Product__c> oppPriceListProdList = new List<LX_Opportunity_Pricelist_Product__c>();
            oppPriceListProdList = [Select id,LX_Part_Number__c,  LX_Sales_Price__c, LX_Discount__c, LX_Quantity__c, LX_Total_Requested_Discount__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in : oppListId];
            System.debug('@@@ oppPriceListProdList size' + oppPriceListProdList.size());
           
            for(BigMachines__Quote_Product__c bmQuoteProduct : trigger.new){
                for(LX_Opportunity_Pricelist_Product__c oppPriceList: oppPriceListProdList ){
                    if(trigger.oldMap.get(bmQuoteProduct.id).BigMachines__Sales_Price__c != null && bmQuoteProduct.BigMachines__Sales_Price__c != null){
                        if(bmQuoteProduct.Name==oppPriceList.LX_Part_Number__c && trigger.oldMap.get(bmQuoteProduct.id).BigMachines__Sales_Price__c != bmQuoteProduct.BigMachines__Sales_Price__c){
                            oppPriceList.LX_Sales_Price__c = bmQuoteProduct.BigMachines__Sales_Price__c;
                            oppPriceList.LX_Bigmachines_Discount_Per_Unit__c = bmQuoteProduct.LX_Approved_Discount__c ;
                            oppPricelistProdListUpdate.add(oppPriceList); 
                        }
                    }
                }
            }
        }
    }
    
    if(trigger.isinsert){
        for(BigMachines__Quote_Product__c bmQuoteProduct : trigger.new){
             if(bmQuoteProduct.BigMachines__Sales_Price__c!=null && bmQuoteProduct.LX_Opportunity_Record_Type_Id__c == Label.LX_QuickBid_RecordTypeId ){
                oppListId.add(bmQuoteProduct.LX_Opportunity_Id__c);
             }
        }
        
        if(oppListId.size()>0){
        List<LX_Opportunity_Pricelist_Product__c> oppPriceListProdList = new List<LX_Opportunity_Pricelist_Product__c>();
            oppPriceListProdList = [Select id,LX_Part_Number__c,  LX_Sales_Price__c, LX_Discount__c, LX_Quantity__c, LX_Total_Requested_Discount__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in : oppListId];
        
            for(BigMachines__Quote_Product__c bmQuoteProduct : trigger.new){
                for(LX_Opportunity_Pricelist_Product__c oppPriceList: oppPriceListProdList ){
                    if(bmQuoteProduct.Name==oppPriceList.LX_Part_Number__c){
                        oppPriceList.LX_Sales_Price__c = bmQuoteProduct.BigMachines__Sales_Price__c;
                        oppPriceList.LX_Bigmachines_Discount_Per_Unit__c = bmQuoteProduct.LX_Approved_Discount__c ;
                        oppPricelistProdListUpdate.add(oppPriceList); 
                    }
                }
            }
        }
    }
    if(oppPricelistProdListUpdate.size()>0){
        try{
            Database.update(oppPricelistProdListUpdate);
        }
        catch(Exception ex){
            System.debug('**@@@ Quote Product to Price List Product Exception** ' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
    }
}