public class LX_Lead_util{

private static string LX_StatusMDM =Label.LX_Lead_Conversion_Status_MDM;
private static string LX_StatusSoldTo =Label.LX_Lead_Conversion_Status_SoldTo;
private static string LX_StatusSoldToMDM =Label.LX_Lead_Conversion_Status_MDMSoldTo;
private static string LX_StatusNotSubmitted =Label.Lead_Conversion_Status_NotSubmitted;
Public Static Map<String,String> mapCustomSetting = new Map<String,String>();
public static set<id> CreatedAccountIDSet = new set<id>();



public static case ConvertLeadCaseCreate( Database.LeadConvertResult LeadResult, Lead ld,Boolean AcctCreationExp  ){

    Case cs = new Case(Subject='Lead Conversion Flag Case', origin='Lead',RecordTypeID=LX_SetRecordIDs.CaseLeadConversionRecordTypeId );
    if(LeadResult!=null ){
    
        if(LeadResult.getContactId() !=null)
            cs.Contactid = LeadResult.getContactId();
        
        if(LeadResult.getAccountId() !=null)
            cs.Accountid = LeadResult.getAccountId() ;
        if(LeadResult.getAccountId() !=null)
            cs.LX_Opportunity__c= LeadResult.getOpportunityId() ;
        if(ld.LX_Additional_Comments__c!=null)
            cs.LX_MDM_Comments__c = ld.LX_Additional_Comments__c;
        if(ld.Business_Unit__c!=null)
            cs.LX_Division__c = ld.Business_Unit__c;
        if(ld.LX_Payment_Terms__c!=null)
            cs.LX_Payment_Terms__c = ld.LX_Payment_Terms__c;
        if( ld.LX_Do_you_need_to_create_an_opportunity__c=='Yes')
        cs.LX_Highest_Month_Revenue__c= String.valueof(System.Today().Month());
        
        //Populating address same as to that of account address US:US4252
        Account objAcc = [SELECT Name, BillingStreet, BillingCity, BillingState,BillingPostalCode, Physical_Country__c from Account where ID =:cs.Accountid];
         if(objAcc != null)
          {
            cs.LX_Name__c= objAcc.Name; 
            cs.LX_Physical_City__c = objAcc.BillingCity;
            cs.LX_Physical_Country__c = objAcc.Physical_Country__c;
            cs.LX_Physical_Postal_Code__c = objAcc.BillingPostalCode;
            cs.LX_Physical_State__c = objAcc.BillingState;
            cs.LX_Physical_Street_Address__c = objAcc.BillingStreet;
          }

        
    }
    system.debug('AcctCreationExp -->'+AcctCreationExp );
    if(AcctCreationExp ){
        cs.Type = LX_StatusSoldToMDM ;
        //cs.LX_MDM_Account_Request_Status__c = LX_StatusNotSubmitted ;
    }
    else if(!AcctCreationExp ){
        cs.Type = LX_StatusMDM ;
        cs.CurrencyIsoCode = ld.CurrencyIsoCode;
        cs.LX_Sold_To_Number_Request_Status__c = LX_StatusNotSubmitted ;
    }
  


return cs;
}
/*
Function to populate the case for Locked and Unlocked Lead

*/
public static case PopulateLockedUnlockedCase(Lead ld){
    Case cs = new case(Subject='Lead Conversion Flag Case' ,RecordTypeID=LX_SetRecordIDs.CaseLeadConversionRecordTypeId, Origin='Lead' );
      if(ld.ConvertedContactId !=null)
            cs.Contactid = ld.ConvertedContactId ;
        
        if(ld.ConvertedAccountId!=null)
            cs.Accountid = ld.ConvertedAccountId;
        if(ld.LX_Additional_Comments__c!=null)
            cs.LX_MDM_Comments__c = ld.LX_Additional_Comments__c;
        if(ld.Business_Unit__c!=null)
            cs.LX_Division__c = ld.Business_Unit__c;
        if(ld.LX_Payment_Terms__c!=null)
            cs.LX_Payment_Terms__c = ld.LX_Payment_Terms__c;
    
        cs.Type = LX_StatusMDM ;
        //cs.LX_MDM_Account_Request_Status__c = LX_StatusNotSubmitted ;
        cs.LX_Sold_To_Number_Request_Status__c = LX_StatusNotSubmitted ;
        cs.CurrencyIsoCode = ld.CurrencyIsoCode;
       
        return cs;

}

public static void PopulateOnwerFields (Lead L){
//added custom settings to update the party role and type picklists
for(LX_Party_Role_type__c customSettingValue : LX_Party_Role_type__c.getall().values())
     mapCustomSetting.put(customSettingValue.LX_Value__c,customSettingValue.name);
    
if(L.recordtypeID == LX_SetRecordIDs.LeadSimpleCustomerRecordTypeId || L.recordtypeID == LX_SetRecordIDs.LeadSimplePartnerRecordTypeId)
{  
    if(L.recordtypeID == LX_SetRecordIDs.LeadSimplePartnerRecordTypeId)
    {
    L.LX_Party_Role__c = mapCustomSetting.get(L.LX_Desribe_the_primar__c);
    
    L.LX_Party_Type__c= mapCustomSetting.get(L.Describe_the_nature_of_the_Partner_s_bus__c);
    }

        if(L.DMR_on_Lead__c == null&& String.valueof(L.ownerid).startswith('005'))
            L.DMR_on_Lead__c = L.ownerid;
        if(L.LX_Account_Owner__c == null&& String.valueof(L.ownerid).startswith('005')){
            List<User> ulist = [Select id, LX_Ability_to_Create_Accounts__c from User where id=:L.ownerid limit 1];
            if(ulist!=null&&ulist[0].LX_Ability_to_Create_Accounts__c=='Yes')
                L.LX_Account_Owner__c = L.ownerid;
        }
}
}
}