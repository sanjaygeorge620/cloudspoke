/****************************************************************************************************************************
 * Class Name  : JavaScriptUtility
 * Description   : This is Utility class called from Import PriceList button on Opportunity Price List object. 
 *                 It is used to query all the quote products on the offer's quote present on Opportunity from which
 *                 the button is clicked. An opportunity price list record is created corresponding to every quote product
 * Created By    : Sumedha Kucherlapati(Deloitte)
 * Created Date  : 12-19-2013
 * Modification Log: 
 * -------------------------------------------------------------------------------------------------------------------------
 * Developer                    Date           Modification ID       Description 
 * -------------------------------------------------------------------------------------------------------------------------
 * Sumedha Kucherlapati        12-19-2013          1000              Initial Version
 * Sumedha Kucherlapati        01-23-2014          1001              Added logic to query only those quote products from
 *                                                                   the most recently created quote which has status = finalized
 * Rahul Raghunathan           02-11-2014          1001              Modified logic to query only those quote products from
 *                                                                   the most recently created quote which has status = approved
 * Praveen Sadineni            05-21-2014          US3440            Carry over Parent_ID__c from offer products to Opportunity Pricelist Products
*****************************************************************************************************************************/
global class JavaScriptUtility{
    /*
     * 
     * Description : This is a webservice method used to perform above mentioned logic
     * Param - : The current Opportunity ID is passed over from the button.
     * Param - : The related offer ID is passed over from the button
     * Returns : Error message if none of the offer's quotes are not finalised ELSE null
     */
     
    WebService static String copyOfferQuoteProducts(string oppID, string offerID) {
        if(oppID != null && oppID != '' && offerID != null && offerID != ''){
            List<LX_Opportunity_Pricelist_Product__c> saveProdList = new List<LX_Opportunity_Pricelist_Product__c>();
            List<BigMachines__Quote__c> quoteList = [SELECT ID FROM BigMachines__Quote__c WHERE Offer__c =:offerID AND (BigMachines__Status__c = 'Finalized' or BigMachines__Status__c = 'Approved' ) ORDER BY CreatedDate DESC LIMIT 1];
            system.debug('@@quoteList' +quoteList );
            //check if the size of quote list is greater than 0
            /*if(quoteList.size() == 0){
                quoteList = [SELECT ID FROM BigMachines__Quote__c WHERE Offer__c =:offerID AND BigMachines__Status__c = 'Approved' ORDER BY CreatedDate DESC LIMIT 1];
            }*/
            
            if(quoteList.size()>0){
            List<LX_Opportunity_Pricelist_Product__c> oppPriceListProd = [SELECT ID 
                                                                            FROM LX_Opportunity_Pricelist_Product__c 
                                                                            WHERE LX_Opportunity__c =:oppID];
            try{
              if(oppPriceListProd.size()>0){
                 delete oppPriceListProd;
              }
            }catch(exception ex){
           //    LX_CommonUtilities.createExceptionLog(ex.getMessage());
               System.debug('Could not delete Pricelist Products : '+ex.getMessage());
               }
             List<BigMachines__Quote_Product__c> offerQuoteProdList =  [SELECT ID,Name,BigMachines__Sales_Price__c,BigMachines__Quantity__c,Parent_ID__c,BigMachines__Quote__r.CreatedByID, BigMachines__Product__c,CurrencyIsoCode
                                                                        FROM BigMachines__Quote_Product__c
                                                                        WHERE BigMachines__Quote__c IN :quoteList];
            
            if(offerQuoteProdList .size()>0){
              for(BigMachines__Quote_Product__c prod : offerQuoteProdList)
              {
              LX_Opportunity_Pricelist_Product__c offProd = new LX_Opportunity_Pricelist_Product__c();
              offProd.LX_Opportunity__c = oppID;
              offProd.CurrencyIsoCode=prod.CurrencyIsoCode;
              offProd.LX_Part_Number__c = prod.Name;
              offProd.LX_Product__c = prod.BigMachines__Product__c;
              offProd.LX_Sales_Price__c = prod.BigMachines__Sales_Price__c;
              offProd.Parent_ID__c = prod.Parent_ID__c;                      //Praveen -- Added for US3440 Requested by Akhila
              offProd.Quantity__c = prod.BigMachines__Quantity__c;
              saveProdList.add(offProd);
              }
             }                                         
            try{
              if(saveProdList.size()>0){
                 insert saveProdList;
               }  
            }catch(Exception ex){
            //   LX_CommonUtilities.createExceptionLog(ex);
               System.debug('Could not delete Pricelist Products : '+ex.getMessage());
            }
          }else{
            return '"there is no approved or finalized price list';
          }
       }   
         return null;
     }
}