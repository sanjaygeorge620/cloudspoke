/*Trigger Name   : lx_SalesOrganisation_BI_BU
* Description   : Trigger to change field values based on business criteria
* Created By   : Srinivas Pinnamaneni
* Created Date : 09-11-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Srinivas Pinnamaneni     09-11-2013            US2872                Initial Version

*/

trigger lx_SalesOrganisation_BI_BU on Sales_Organization__c (before insert,before update,after insert,after update) {

    //US2872:Get the records which have checked default column
    //US2872: Create a variable to store Country Codes.
    Set<String> setCountryCodes = new Set<String>();
    //Us2872: Instantiate object for lx_SalesOrganisationUtils class
    lx_SalesOrganisationUtils objSalesOrgUtility = new lx_SalesOrganisationUtils();
     Set<Id> setIds = new Set<Id>();
    //US2872:Atleast one country code record should have checked default
    Set<String> setValidateCountryCodes = new Set<String>();
    static Map<ID,Map<String,boolean>> mapDefaultCountryCodes = new Map<Id,Map<String,boolean>>();
    List<Sales_Organization__c> lstSalesOrg = new List<Sales_Organization__c>();
    for(Sales_Organization__c objSalesOrg : trigger.new)
    { 
        system.debug('objSalesOrg ===== '+objSalesOrg);
        if(objSalesOrg.LX_Default__c != true)
        {
            setValidateCountryCodes.add(objSalesOrg.LX_Country_Code__c);
            lstSalesOrg.add(objSalesOrg);
        }
        //US2872:Check id the old value and new value are different in update operation.
        if(objSalesOrg.LX_Default__c != null &&  objSalesOrg.LX_Default__c && (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(objSalesOrg.id).LX_Default__c != objSalesOrg.LX_Default__c)) && trigger.isAfter)
        {
            //US2872:Add this record to the set variable
            if(objSalesOrg.LX_Country_Code__c !=null){
                setCountryCodes.add(objSalesOrg.LX_Country_Code__c);
                setIds.add(objSalesOrg.Id);
            }
        }
    }
    
    
    if(trigger.isAfter)
    {
        //US2872:Check if set has any values else return
        if(setCountryCodes.size() <= 0) return;
        //US2872:Call method in the utility class to update default value.
        objSalesOrgUtility.updateDefaultCheck(setCountryCodes,setIds);
    }
    
    if(trigger.isBefore)
    {
        //US2872:Call method in the utility class to update default value.
        objSalesOrgUtility.MandatoryCheck(setValidateCountryCodes,lstSalesOrg);
    }
    
    
    

}