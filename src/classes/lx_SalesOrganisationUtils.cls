/*Class Name   : lx_SalesOrganisationUtils
* Description   : Util Class to hadle business logic for sales organisation object
* Created By   : Srinivas Pinnamaneni
* Created Date : 09-11-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Srinivas Pinnamaneni     09-11-2013            US2872                Initial Version

*/
public  class lx_SalesOrganisationUtils {

    public void updateDefaultCheck(Set<String> setCountryCodes,Set<Id> setIds)
    {
        //US2872: Get records which matches country code in the input parameter and Default check is checked.
        list<Sales_Organization__c> lstSalesOrg = [select id,LX_Default__c,LX_Country_Code__c 
                                                   from Sales_Organization__c
                                                   where LX_Country_Code__c in : setCountryCodes and LX_Default__c =: true and Id not in: setIds];
        
        //US2872: Check if list has return any records if not return from this method
        if(lstSalesOrg == null || lstSalesOrg.size() <= 0) return;
        
        //US2872: Update default check to unchecked for the records
        for(Sales_Organization__c obj: lstSalesOrg)
        {
            obj.LX_Default__c = false;
            
        }
        
        //US2872: Update the list of sales org records
        update lstSalesOrg;
    
    }
    
    public void MandatoryCheck(Set<String> setCountryCodes, List<Sales_Organization__c> lstSalesOrgDetails)
    {
        Set<String> setDefaultCountryCodes = new Set<String>();
        //US2872: Get records based on country codes
        for(Sales_Organization__c objRecord : [select LX_IsDefault__c,LX_Country_Code__c from Sales_Organization__c where    
                                               LX_Country_Code__c in: setCountryCodes])
        {
            system.debug('objRecord == '+objRecord);
            if(objRecord.LX_IsDefault__c)
                setDefaultCountryCodes.add(objRecord.LX_Country_Code__c);
        }
        system.debug('setDefaultCountryCodes == '+setDefaultCountryCodes);
        for(Sales_Organization__c objSales : lstSalesOrgDetails)
        {
            system.debug('objSales == '+objSales);
            if(!setDefaultCountryCodes.contains(objSales.LX_Country_Code__c)&&objSales.LX_Country_Code__c!='US')//9/26:SKuch changed
            {
                objSales.addError('Default value should be selected for atleast one country code record');
            }
        }
    
    }
    
    
}