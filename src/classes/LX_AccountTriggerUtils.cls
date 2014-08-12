/* Class Name   : LX_AccountTriggerUtils 
* Description   : This is a utility class to update the Rating and Country_Account_Rating__c columns on account object.
* Created By   : Sanjay George
* Created Date : 13-08-2013 
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay George            13-08-2013                                  Initial Version
* Kapil                    10-29-2013           1001                   Removed the describe statement for Recordtype in line 145
*/

Public Class LX_AccountTriggerUtils{

    Static Object newValue,oldValue ;
    Static String returnNewValue,returnOldValue ;
    Static Map<id,User> MapIdUser;
    Static set<id> SetUserid = new Set<id>();
    public static Map<String,Double> conversion_rates = new Map<String,Double>();
    public static list<CurrencyType> currencyTypeList; 
    
    /* Description : It accepts collection of account records and updates Rating and Country Account Rating.
    *  Param - NewAccList : Collection of account records 
    *  Returns :  Map<Id,List<String>> : return map of account ids with list of rating values.
    */
    public static map<id,List<String>> RatingCalc(list<Account> NewAccList){
        map<id,List<String>> OppidRating = new map<id,List<String>>();
        list<string> RatingValue;  
        if(!(conversion_rates.size()>0))  {
            currencyTypeList= [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];   
            for(CurrencyType curr: currencyTypeList )
            {  
                conversion_rates.put(curr.IsoCode,curr.ConversionRate);   
            }
        }
        for(account acc: NewAccList){
           
           Double conversionRate1 =conversionRateCalc(acc.CurrencyIsoCode);
           System.debug(conversionRate1);
            RatingValue = new list<string>();
            if(acc.type=='Customer'){
                if(acc.LX_Sales_Team_Assigned__c=='Retail'){
                     acc.Rating = compareValue(acc.AnnualRevenue!=null?((acc.AnnualRevenue)/conversionRate1):acc.AnnualRevenue,10000000000L, 1000000000L, 500000000L);
                     //acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?acc.Annual_Revenue_In_Country_Override__c:acc.AnnualRevenue,10000000000L, 1000000000L, 500000000L);
                     acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?((acc.Annual_Revenue_In_Country_Override__c)/conversionRate1):acc.Annual_Revenue_In_Country_Override__c,10000000000L, 1000000000L, 500000000L);
                }
                else if(acc.LX_Sales_Team_Assigned__c=='Manufacturing'){
                    acc.Rating = compareValue(acc.AnnualRevenue!=null?((acc.AnnualRevenue)/conversionRate1):acc.AnnualRevenue,15000000000L, 5000000000L, 2000000000L); /*was 500000000L FEB.10.2014*/
                   // acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?acc.Annual_Revenue_In_Country_Override__c:acc.AnnualRevenue,15000000000L, 5000000000L, 500000000L);
                    acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?((acc.Annual_Revenue_In_Country_Override__c)/conversionRate1):acc.Annual_Revenue_In_Country_Override__c,15000000000L, 5000000000L, 500000000L);
                }
                else if(acc.LX_Sales_Team_Assigned__c=='Banking'){
                
                    acc.Rating = compareValue(acc.AnnualRevenue!=null?((acc.AnnualRevenue)/conversionRate1):acc.AnnualRevenue, 10000000000L, 1000000000L, 500000000L);
                    //acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?acc.Annual_Revenue_In_Country_Override__c:acc.AnnualRevenue,10000000000L, 1000000000L, 500000000L);
                    acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?((acc.Annual_Revenue_In_Country_Override__c)/conversionRate1):acc.Annual_Revenue_In_Country_Override__c,10000000000L, 1000000000L, 500000000L);
                    } 
                else if(acc.LX_Sales_Team_Assigned__c=='Insurance'){
                    acc.Rating = compareValue(acc.AnnualRevenue!=null?((acc.AnnualRevenue)/conversionRate1):acc.AnnualRevenue,15000000000L, 5000000000L, 500000000L);
                    //acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?acc.Annual_Revenue_In_Country_Override__c:acc.AnnualRevenue,15000000000L, 5000000000L, 500000000L);
                    acc.Country_Account_Rating__c= compareValue(acc.Annual_Revenue_In_Country_Override__c!=null?((acc.Annual_Revenue_In_Country_Override__c)/conversionRate1):acc.Annual_Revenue_In_Country_Override__c,15000000000L, 5000000000L, 500000000L);
                } 
                else if(acc.LX_Sales_Team_Assigned__c=='Healthcare'){
                    acc.Country_Account_Rating__c= compareValue(acc.Bed_Count__c!=null?((acc.Bed_Count__c)/conversionRate1):acc.Bed_Count__c,500L, 260L, 100L);
                    acc.Rating = compareValue(acc.System_Wide_Bed_Count__c!=null?((acc.System_Wide_Bed_Count__c)/conversionRate1):acc.System_Wide_Bed_Count__c,500L, 260L, 100L);
                } 
                else if(acc.LX_Sales_Team_Assigned__c=='Education'){
                    acc.Rating = compareValue(acc.Institution_Enrollment__c!=null?((acc.Institution_Enrollment__c)/conversionRate1):acc.Institution_Enrollment__c,50000L, 15000L, 5000L);
                    acc.Country_Account_Rating__c= compareValue(acc.Student_Count__c!=null?((acc.Student_Count__c)/conversionRate1):acc.Student_Count__c,50000L, 15000L, 5000L);
                   
                } 
                else if(acc.LX_Sales_Team_Assigned__c=='National Government'){
                    acc.Rating = compareValue(acc.Employees_Global__c!=null?((acc.Employees_Global__c)/conversionRate1):acc.Employees_Global__c,25000L,2000L,1000L);
                    acc.Country_Account_Rating__c= compareValue(acc.Employees_Override__c!=null?((acc.Employees_Override__c)/conversionRate1):(acc.NumberOfEmployees!=null?((acc.NumberOfEmployees)/conversionRate1):acc.NumberOfEmployees),25000L,2000L,1000L);
                    
                } 
                else if(acc.LX_Sales_Team_Assigned__c=='State & Local Government'){
                    acc.Rating = compareValue(acc.Employees_Global__c!=null?((acc.Employees_Global__c)/conversionRate1):acc.Employees_Global__c,10000L,5000L,1000L);
                    acc.Country_Account_Rating__c= compareValue(acc.Employees_Override__c!=null?((acc.Employees_Override__c)/conversionRate1):(acc.NumberOfEmployees!=null?((acc.NumberOfEmployees)/conversionRate1):acc.NumberOfEmployees),10000L,5000L,1000L);
                } 
           }
                RatingValue.add(acc.Rating);
                RatingValue.add(acc.Country_Account_Rating__c);
                OppidRating.put(acc.id,RatingValue);
           
        }
        return OppidRating;
    }
    
    /* Description : This is a method to populate the conversion rates.
    *  Param - String : the ISOcode of the account.
    *  Returns : Double: The conversion rate
    */
    
    Private static double conversionRateCalc(String isoCode1)
    {
    /*Map<String,Double> conversion_rates = new Map<String,Double>();
    for(CurrencyType curr: [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE])
    {  
    conversion_rates.put(curr.IsoCode,curr.ConversionRate);   
    }*/
    double convRate =conversion_rates.get(isoCode1);
    return convRate;
    }
    
    /* Description : Compares the value and limit from the input parameters and based on some conditions returning constant values accordingly.
    *  Param - Deciaml Value : Actual value from Employees_Override__c column in account object.
    *  Param - Long limit1 : Constant value 10000L.
    *  Param - Long limit2 : Constant value 5000L.
    *  Param - Long limit3 : Constant value 1000L.
    *  Returns : String : Assumed values are 'Tier 0','Tier 1','Tier 2'
    */
    private static string compareValue(Decimal Value, Long limit1, Long limit2, Long limit3){
        String returnValue;
       // if(Value==null)
          //  returnValue='Tier 3';
        if(Value>=limit1)
            returnValue='Tier 0';
        else if(Value<limit1&&Value>=limit2)
            returnValue='Tier 1';
        else if (Value<limit2&&Value>=limit3)
            returnValue='Tier 2';
        else if ( Value  < limit3 && Value > 0)
            returnValue='Tier 3';
        else if(Value == null || Value == 0)
            returnValue='Unknown';
        return returnValue;
    }
    
    public static void updatedPrimaryISSSegment(List<Account> lstAccounts)
    {
        for(Account objAccount : lstAccounts)
        {
            if(Populating_ISS_Internal_Segment__c.getAll() != null && Populating_ISS_Internal_Segment__c.getAll().get(objAccount.Party_Type__c) != null)
                objAccount.Primary_ISS_Internal_Segment__c = Populating_ISS_Internal_Segment__c.getAll().get(objAccount.Party_Type__c).Value__c;

        
        }
    
    }
    
    /* Description : Copies old Address values on Account on lead conversion.
    *  Case : 00652504
    */
    public static void updatedBillingAddress(List<Account> lstAccounts, Map<Id,Account> mapOldAccounts)
    {
       // system.debug('In lstAccounts == '+lstAccounts);
        //Id nonMDMRecordTypeID2  = LX_SetRecordIDs1.NonMDMAccountRecordId;
        Id nonMDMRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Non-MDM Account').getRecordTypeId();
        system.debug('lead convert check 1 id nonmdm is >>>>>>>>>>>>'+nonMDMRecordTypeID);
        //system.debug('lead convert check 1 id nonmdm is >>>>>>>>>>>>'+nonMDMRecordTypeID2);        
        for(Account objAccount : lstAccounts)
        {           
            system.debug('objAccount.LX_Converted_Lead_ID_Hidden__c >>>>>>>>>>>>'+objAccount.LX_Converted_Lead_ID_Hidden__c);
            system.debug('objAccount.recordTypeId >>>>>>>>>>>>'+objAccount.recordTypeId);
            system.debug('objAccount.LX_Lead_Convert_Check__c >>>>>>>>>>>>'+objAccount.LX_Lead_Convert_Check__c);
            if(objAccount.LX_Converted_Lead_ID_Hidden__c != null && objAccount.recordTypeId != nonMDMRecordTypeID && objAccount.LX_Lead_Convert_Check__c == true)
            {
                system.debug('inside correct loop >>>>>>>>>>>>');
                Account oldAccount = mapOldAccounts.get(objAccount.Id);
                system.debug('oldAccount.LX_StreetHidden__c >>>>>>>>>>>>'+oldAccount.LX_StreetHidden__c);
                objAccount.BillingStreet = oldAccount.LX_StreetHidden__c;
                objAccount.BillingCity = oldAccount.LX_CityHidden__c;
                objAccount.BillingState = oldAccount.LX_StateHidden__c;
                objAccount.BillingPostalCode = oldAccount.LX_Postalcodehidden__c;
                objAccount.BillingCountry = oldAccount.LX_CountryHidden__c;
                objAccount.LX_Lead_Convert_Check__c = false;
                
            }
            else {
                Account oldAccount = mapOldAccounts.get(objAccount.Id);
                objAccount.LX_StreetHidden__c = oldAccount.BillingStreet;
                objAccount.LX_CityHidden__c = oldAccount.BillingCity;
                objAccount.LX_StateHidden__c = oldAccount.BillingState;
                objAccount.LX_Postalcodehidden__c = oldAccount.BillingPostalCode;
                objAccount.LX_CountryHidden__c = oldAccount.Physical_Country__c;              
            }
            
        }
        
    
    }
}