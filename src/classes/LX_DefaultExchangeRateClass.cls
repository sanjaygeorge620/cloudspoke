/* Class Name   : LX_DefaultExchangeRateClass
    * Description   : This class is a controller for "Default Exchange Rate" Button on 'Countries in Scope'  
    *                to Default the Exchange Rate back from over-ridden rate. 
    *                
    * Created By   : Sanjay Chaudhary
    * Created Date : 02-05-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sanjay Chaudhary            02-05-2014        HPQC 2044                       Initial Version    
    */

global class LX_DefaultExchangeRateClass {
   WebService static void DefaultExchangeRateMethod(String countryids) {

    Map <Id,String> IdCurrencyMap = new Map <Id, String> ();
    Map <String, Decimal> curRateMap = new Map <String, Decimal> ();
    Map <Id,String> IdOpptyCurrencyMap = new Map <Id, String> ();
    List <LX_Countries_In_Scope__c> cscope = new List <LX_Countries_In_Scope__c> ();
 
    for (CurrencyType cr: [Select IsoCode, ConversionRate from CurrencyType])
    curRateMap.put (cr.IsoCode, cr.ConversionRate);
               
    for (LX_Countries_In_Scope__c lxc: [Select Id,LX_Currency__c,LX_Opportunity_Currency__c from LX_Countries_In_Scope__c where id =: countryids] )  {     
    IdCurrencyMap.put(lxc.Id, lxc.LX_Currency__c); 
    IdOpptyCurrencyMap.put (lxc.Id,lxc.LX_Opportunity_Currency__c); 
    } 
     
    for (LX_Countries_In_Scope__c lx: [Select Id,LX_Exchange_Rate__c from LX_Countries_In_Scope__c where id =: countryids] ) {                   
     lx.LX_Exchange_Rate__c = String.valueof(((curRateMap.get(IdCurrencyMap.get(lx.Id)))/ (curRateMap.get(IdOpptyCurrencyMap.get(lx.Id)))).SetScale(6) );
     cscope.add(lx);}
    
    Update cscope ;
    }
}