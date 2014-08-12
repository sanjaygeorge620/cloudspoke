/* Trigger Name   : LX_DefaultExchangeRate
    * Description   : This Trigger is to Defualt the Exchange Rate on 'Countries in Scope'  
    *                
    * Created By   : Sanjay Chaudhary
    * Created Date : 02-05-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sanjay Chaudhary            02-05-2014         HPQC 2044                      Initial Version    
    */

trigger LX_DefaultExchangeRate on LX_Countries_In_Scope__c (before insert, before update) {

    Map <Id,String> IdCurrencyMap = new Map <Id, String> ();
    Map <Id,String> IdOpptyCurrencyMap = new Map <Id, String> ();
    Map <String, Decimal> curRateMap = new Map <String, Decimal> ();
    
    for (LX_Countries_In_Scope__c lxc: Trigger.new) {
        if (Trigger.isInsert || (Trigger.isUpdate && (Trigger.oldMap.get(lxc.Id).LX_Currency__c != lxc.LX_Currency__c))) 
            {
            IdCurrencyMap.put(lxc.Id, lxc.LX_Currency__c);
            IdOpptyCurrencyMap.put (lxc.Id,lxc.LX_Opportunity_Currency__c); 
            }                          
            } 
            
    if (IdCurrencyMap.size()>0 && IdOpptyCurrencyMap.size()>0)
        {
            for (CurrencyType cr: [Select IsoCode, ConversionRate from CurrencyType])
            curRateMap.put (cr.IsoCode, cr.ConversionRate);
            
            if (curRateMap.size()>0)
            {
            for (LX_Countries_In_Scope__c lx: Trigger.new)            
            lx.LX_Exchange_Rate__c = String.valueof(((curRateMap.get(IdCurrencyMap.get(lx.Id)))/ (curRateMap.get(IdOpptyCurrencyMap.get(lx.Id)))).SetScale(6) ); 
            }
        }            
}