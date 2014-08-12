/* Class Name   : lx_Offer_Utils 
* Description   : This is a utility class to handle trigger events on Offer object
* Created By   : Srinivas Pinnamaneni
* Created Date : 23-12-2013 
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Srinivas Pinnamaneni     23-12-2013                                  Initial Version

*/
public class lx_Offer_Utils {
       
    /* Description : Assigns matching sales org record based on the country selected.
    *  Param - lstOfferRecords : Collection of offer records 
    *  Param - setCountries : Collection of Country records 
    *  Returns :  null.
    */
    public static void AssignSalesOrg(list<LX_Offer__c> lstOfferRecords,Set<String> setCountries){
        
        //Declare a MAP to store country and record id
        Map<String, ID> mapCountryIDs = new Map<String, ID>();
        //Query Sales Org object and get the matching country default record. 
        for(Sales_Organization__c objSalesOrg : [select id,LX_IsDefault__c,Name from Sales_Organization__c
                                                where Name in: setCountries and LX_IsDefault__c =: true])
            {
                //Add records to the map 
                mapCountryIDs.put(objSalesOrg.Name,objSalesOrg.Id);
            }
            
        //Check if MAP is null if yes them return from the method
        if(mapCountryIDs == null || mapCountryIDs.size() <= 0) return;
        
        //Iterate offer records and assign the sales org value to the record.
        for(LX_Offer__c objOffer : lstOfferRecords)
        {
            //check if country populated in offer is not null
            if(objOffer.salesRegion_quote__c == null) break;
            
            //Check if Sales Org is not empty then we should not assign value
            if(objOffer.Sales_Organization__c != null) break;
            
            //Assign Sales Org value here
            objOffer.Sales_Organization__c = mapCountryIDs.get(objOffer.salesRegion_quote__c);

        }
    }
    
    public static void offerQuoteAssociation(Map<id,LX_Offer__c> mapOfferRecordsNew,set<id> offerIdSet,Map<id,LX_Offer__c> mapOfferRecordsOld){
        //get all the quotes related to these offers.
        list<BigMachines__Quote__c> bmQuotes = [Select id,Offer__c from BigMachines__Quote__c where Offer__c in :offerIdSet];
        set<id> quoteOfferSet = new set<id>();
        //Get all the offer ID
        for(BigMachines__Quote__c quote : bmQuotes){
            if(quote.offer__c != null){
                quoteOfferSet.add(quote.Offer__c);
            }
        }
        
        if(quoteOfferSet != null && !quoteOfferSet.isEmpty()){
            for(LX_Offer__c offer:mapOfferRecordsNew.values()){
                if(quoteOfferSet.contains(offer.id) && (offer.salesRegion_quote__c  != mapOfferRecordsOld.get(offer.id).salesRegion_quote__c || offer.Sales_Organization__c  != mapOfferRecordsOld.get(offer.id).Sales_Organization__c || offer.Lx_Quote_Currency__c != mapOfferRecordsOld.get(offer.id).Lx_Quote_Currency__c)){
                   offer.addError('Sales Org cannot be changed. There is a quote associated with this Offer'); 
                   // offer.addError('Quote is associated to this offer. You can\'t change Sales Org,Sales Currency and Sales Region. ');                    
                }
            }
        }
    }
    /* Description : Validate the currency on offer.
    *  Param - lstOfferRecords : Collection of offer records 
    *  Returns :  null.
    */
    public static void validateCurrency(list<LX_Offer__c> lstOfferRecords){
        
        // set used to store sales organization ids
        Set<ID> salesorgSet = new Set<ID>();
        // Map to store sales org id and set of available currencies in it
        Map<ID,set<String>> currencyValuesMap = new Map<ID,set<String>>(); 
        
        for(LX_Offer__c objOffer : lstOfferRecords){                   
          if(objOffer.Sales_Organization__c != null){
                salesorgSet.add(objOffer.Sales_Organization__c);
          }
        }
        if(salesOrgSet.size()>0){
        // query for salesorg and store available currencies in a map to check if currency selected on Offer is in this list
        for(Sales_Organization__c org : [SELECT id,sales_organization__c,Name,LX_Country_Code__c,LX_Default__c,LX_Available_Currencies__c
                                          FROM Sales_Organization__c 
                                          WHERE ID IN :salesOrgSet]){
        
         if(org.LX_Available_Currencies__c != null){
             String currencyValues = org.LX_Available_Currencies__c;
             System.debug('>>>>>>Curre Values>>>>'+currencyValues);
             set<String> currVal = new set<String>();
             currVal.addAll(currencyValues.split(';'));
             currencyValuesMap.put(org.id,currVal); // <salesorg,currencies>
            }                                 
         } 
        if(!currencyValuesMap.isEmpty()){
          for(LX_Offer__c offer : lstOfferRecords){
              if(offer.Lx_Quote_Currency__c != null){
                  System.debug('>>>>>>>Curre Validation>>>>>');
                 if(currencyValuesMap.containsKey(offer.sales_organization__c) 
                   && !currencyValuesMap.get(offer.sales_organization__c).contains(offer.Lx_Quote_Currency__c))
                 {
                   offer.addError('The Quote Currency for your offer is not valid for this Sales organization');
                 }
               }
             }
          }        
        }
    } 
}