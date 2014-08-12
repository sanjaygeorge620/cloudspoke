public class LX_SetRecordIDs
{
    /* Class Name   : SetRecordIDs 
    * Description   : This is a utility class to execute the general functionality from the Case triggers. 
    * Created By   : Arun thakur
    * Created Date : 04-29-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    ----------------------------------------------------------------------------------------------------------------------------
    * Gulzar                    04-29-2013                                 Initial Version

    */
    
    
    // case  Record Type - Simple customer
public Static String CaseLeadConversionRecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CaseLeadConversionRecordType')!=null?Lx_SetRecordIDs__c.getAll().get('CaseLeadConversionRecordType').Value__c:'').getRecordTypeId();

// SAP record Sales organization  Record Type - Sold To Sales Org
public Static String SAPRecordSalesOrgRecordTypeID = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('SAPRecordSalesOrgRecordType')!=null?Lx_SetRecordIDs__c.getAll().get('SAPRecordSalesOrgRecordType').Value__c:'').getRecordTypeId();


// Lead  Record Type - Simple customer
public Static String LeadSimpleCustomerRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LeadSimpleCustomer')!=null?Lx_SetRecordIDs__c.getAll().get('LeadSimpleCustomer').Value__c:'').getRecordTypeId();

// Lead  Record Type - Simple Partner
public Static String LeadSimplePartnerRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LeadSimplePartner')!=null?Lx_SetRecordIDs__c.getAll().get('LeadSimplePartner').Value__c:'').getRecordTypeId();

// Lead  Record Type - Locked
public Static String LeadLockedRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LeadLocked')!=null?Lx_SetRecordIDs__c.getAll().get('LeadLocked').Value__c:'').getRecordTypeId();

// Lead  Record Type - Unlocked
public Static String LeadUnlockedRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LeadUnlocked')!=null?Lx_SetRecordIDs__c.getAll().get('LeadUnlocked').Value__c:'').getRecordTypeId();


// pse_Project Record Type - Professional Services
public Static String ProjectProfServicesRecordTypeId = pse__Proj__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('PSEProjProfRecType')!=null?Lx_SetRecordIDs__c.getAll().get('PSEProjProfRecType').Value__c:'').getRecordTypeId();

// pse_Project Record Type - ISS Implementation Project
public Static String ProjectISSImplRecordTypeId = pse__Proj__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('PSEProjISSRecType')!=null?Lx_SetRecordIDs__c.getAll().get('PSEProjISSRecType').Value__c:'').getRecordTypeId();

// Case Record Type - PurchaseRequest
public Static String CasePurchaseRequestRecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Case_PurchaseRequest')!=null?Lx_SetRecordIDs__c.getAll().get('Case_PurchaseRequest').Value__c:'').getRecordTypeId();

// Case Record Type - BusinessCardRequest
public Static String CaseBusinessCardRequestRecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Case_BusinessCardRequest')!=null?Lx_SetRecordIDs__c.getAll().get('Case_BusinessCardRequest').Value__c:'').getRecordTypeId();

// Case Record Type - Mobile Request
public Static String CaseMobileRequestRecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Case_MobileRequest')!=null?Lx_SetRecordIDs__c.getAll().get('Case_MobileRequest').Value__c:'').getRecordTypeId();

// Case Record Type - New Order Request
public Static String CaseNewOrderRecordTypeId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CaseNewOrderRecordTypeName')!=null?Lx_SetRecordIDs__c.getAll().get('CaseNewOrderRecordTypeName').Value__c:'').getRecordTypeId();

// Case Record Type - Account_Change_Request
public Static String LockISSEnrollmentRecordType=LX_Program_Enrollment__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LockISSEnrollmentRecordType')!=null?Lx_SetRecordIDs__c.getAll().get('LockISSEnrollmentRecordType').Value__c:'').getRecordTypeId();
public Static String CaseAccountChangeRequestRecordId = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Account_Change_Request')!=null?Lx_SetRecordIDs__c.getAll().get('Account_Change_Request').Value__c:'').getRecordTypeId();

public Static String VIRRecordtypeID = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('VIRRecordtypeID')!=null?Lx_SetRecordIDs__c.getAll().get('VIRRecordtypeID').Value__c:'').getRecordTypeId();

public Static String SpiffRecordtypeID = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('SpiffRecordtypeID')!=null?Lx_SetRecordIDs__c.getAll().get('SpiffRecordtypeID').Value__c:'').getRecordTypeId();

public Static String MDFrecordtypeId= LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('MDFrecordtypeId')!=null?Lx_SetRecordIDs__c.getAll().get('MDFrecordtypeId').Value__c:'').getRecordTypeId();

public Static String logisticsOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Logistics')!=null?Lx_SetRecordIDs__c.getAll().get('Logistics').Value__c:'').getRecordTypeId();

public Static String promotionOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Promotion')!=null?Lx_SetRecordIDs__c.getAll().get('Promotion').Value__c:'').getRecordTypeId();

public Static String sbcOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Special Bid Channel')!=null?Lx_SetRecordIDs__c.getAll().get('Special Bid Channel').Value__c:'').getRecordTypeId();

public Static String priceProtectionOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Price Protection')!=null?Lx_SetRecordIDs__c.getAll().get('Price Protection').Value__c:'').getRecordTypeId();

public Static String nonQuoteOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Non-Quote Offer')!=null?Lx_SetRecordIDs__c.getAll().get('Non-Quote Offer').Value__c:'').getRecordTypeId();

public Static String pricelistOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Pricelist Offer')!=null?Lx_SetRecordIDs__c.getAll().get('Pricelist Offer').Value__c:'').getRecordTypeId();

public Static String childOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Childoffer')!=null?Lx_SetRecordIDs__c.getAll().get('Childoffer').Value__c:'').getRecordTypeId();
//public Static String parentOfferId = LX_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Parentoffer')!=null?Lx_SetRecordIDs__c.getAll().get('Parentoffer').Value__c:'').getRecordTypeId();

public Static String SAPRecordSoldToId = LX_SAP_Record__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Sold To')!=null?Lx_SetRecordIDs__c.getAll().get('Sold To').Value__c:'').getRecordTypeId();
    
  //Program enrollment ISS Record type
public Static String ISSPartnerEnrollment=LX_Program_Enrollment__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('ISSProgramEnrollment')!=null?Lx_SetRecordIDs__c.getAll().get('ISSProgramEnrollment').Value__c:'').getRecordTypeId();
//Program enrollment PSW Record type
public Static String PSWPartnerEnrollment=LX_Program_Enrollment__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('PSWProgramEnrollment')!=null?Lx_SetRecordIDs__c.getAll().get('PSWProgramEnrollment').Value__c:'').getRecordTypeId();



//Global Account :Enrollment Offers record ID
public static string EnrollmentOffersId =LX_Program_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('EnrollmentOffers')!=null?Lx_SetRecordIDs__c.getAll().get('EnrollmentOffers').Value__c:'').getRecordTypeId();

//Global Account :Program Offers  record ID
public static string ProgramOffersId =LX_Program_Offer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('ProgramOffers')!=null?Lx_SetRecordIDs__c.getAll().get('ProgramOffers').Value__c:'').getRecordTypeId();  

//Global Account :Account record ID
//public static string CompetitorPartnerInfluencerCompetitorId=LX_Competitor_Influencer_and_Partner__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerCompetitor')!=null?Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerCompetitor').Value__c:'').getRecordTypeId();

//Global Account :Account record ID
public static string CompetitorPartnerInfluencerInfluencerId=LX_Competitor_Influencer_and_Partner__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerInfluencer')!=null?Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerInfluencer').Value__c:'').getRecordTypeId();

//Global Account :Account record ID
public static string CompetitorPartnerInfluencerPartnerId=LX_Competitor_Influencer_and_Partner__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerPartner')!=null?Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerPartner').Value__c:'').getRecordTypeId();

//Global Account :Account record ID
public static string InfluencerPartnerId=Opportunity_Influencer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('InfluencerPartner')!=null?Lx_SetRecordIDs__c.getAll().get('InfluencerPartner').Value__c:'').getRecordTypeId();

//Rahul commeneted this code as it is no longer valid
//Global Account :Account record ID
//public static string InfluencerInfluencerId=Opportunity_Influencer__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('InfluencerInfluencer')!=null?Lx_SetRecordIDs__c.getAll().get('InfluencerInfluencer').Value__c:'').getRecordTypeId();

//Global Account :Account record ID
//public static string CompetitorPartnerInfluencerPartnerId=LX_Competitor_Influencer_and_Partner__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Partner')!=null?Lx_SetRecordIDs__c.getAll().get('CompetitorPartnerInfluencerPartner').Value__c:'').getRecordTypeId();


//Partner Program.Global PSW Program Category
public static string GlobalPSWProgramCategory=LX_Partner_Program__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('GlobalPSWProgramCategory').Value__c).getRecordTypeId();
//Partner Program.GlobalProgram
public static string GlobalProgram=LX_Partner_Program__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('GlobalProgram').Value__c).getRecordTypeId();
//Partner Program.LocalPSWProgram
public static string LocalPSWProgram=LX_Partner_Program__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LocalPSWProgram').Value__c).getRecordTypeId();
//Partner Program.Lock Local ISS Program
public static string LockLocalISSProgram=LX_Partner_Program__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LockLocalISSProgram').Value__c).getRecordTypeId();

//Partner Program.Local ISS Program
public static string LocalISSProgramRTID=LX_Partner_Program__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('LocalISSProgram').Value__c).getRecordTypeId();

//Partner Program.Global ISS Program Category
public static string GlobalISSProgramCategoryRTID=LX_Partner_Program__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('GlobalISSProgramCategory').Value__c).getRecordTypeId();


//Global Account :Account record ID
public static string L1GlobalAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L1GlobalAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L1GlobalAccountRecordName').Value__c:'').getRecordTypeId();

//L2 Domestic Account :Account record ID
public static string L2DomesticAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L2DomesticAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L2DomesticAccountRecordName').Value__c:'').getRecordTypeId();

//L3 Legal Account:Account record ID
public static string L3LegalAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L3LegalAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L3LegalAccountRecordName').Value__c:'').getRecordTypeId();

//L4 MDM Customer Account:Account record ID
public static string L4MDMCustomerAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L4MDMCustomerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L4MDMCustomerAccountRecordName').Value__c:'').getRecordTypeId();

//Non MDM Account:Account record ID
public static string NonMDMAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('NonMDMRecordTypeName')!=null?Lx_SetRecordIDs__c.getAll().get('NonMDMRecordTypeName').Value__c:'').getRecordTypeId();

//L4 MDM Partner Account:Account record ID
public static string L4MDMPartnerAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L4MDMPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L4MDMPartnerAccountRecordName').Value__c:'').getRecordTypeId();

//L5 Location Customer Account:Account record ID
public static string L5LocationCustomerAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L5LocationCustomerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L5LocationCustomerAccountRecordName').Value__c:'').getRecordTypeId();

//L5 Location Partner Account:Account record ID
public static string L5LocationPartnerAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L5LocationPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L5LocationPartnerAccountRecordName').Value__c:'').getRecordTypeId();

//Rahul commented
//L5 Sold To Partner Account:Account record ID Below Variable Commented as Record Type got deleted on 27th May 2013
//public static string L5SoldToPartnerAccountRecordId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L5SoldToPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L5SoldToPartnerAccountRecordName').Value__c:'').getRecordTypeId();


//Automation Admin :Contact record ID
public static string AutomationAdminContactId=Lx_SetRecordIDs__c.getAll().get('AutomationAdminContactId')!=null?Lx_SetRecordIDs__c.getAll().get('AutomationAdminContactId').Value__c: '';
//'003e0000005a9vE'; sandbox

//Automation Admin :Contact record ID
public static string ConsultantLaborCategoryId=Lx_SetRecordIDs__c.getAll().get('ConsultantLaborCategoryId')!=null?Lx_SetRecordIDs__c.getAll().get('ConsultantLaborCategoryId').Value__c:'';
//'a3De0000000CmD7EAK'; sandbox

//Opportunity Additional Services:RecordTypeId
//Rahul De-activated it

//public static string OpportunityAdditionalServicesRecordTypeId=schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('OppAdditionalServicesRecordType').Value__c).getRecordTypeId();
//Nam Deactivated it. The record type has been deleted from Opportunity.

//012i0000000LoBt
//schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('OppAdditionalServicesRecordType').Value__c).getRecordTypeId();
// 



//case Partner-Channel:RecordTypeId
//public static string CaseBusinessCardRequestTypeId='012i0000000LkBA';
//012i0000000LkBA
//Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CaseHelpDeskRecordName').Value__c).getRecordTypeId();
// 

//case Partner-Channel:RecordTypeId
//public static string CasePurchaseRequestRecordTypeId='012i0000000LkBA';
//012i0000000LkBA
//Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CaseHelpDeskRecordName').Value__c).getRecordTypeId();
//; 


//case Partner-Channel:RecordTypeId
public static string CasePartnerChannelRecordTypeId=schema.Sobjecttype.Case.getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Case_PartnerChannel').Value__c).getRecordTypeId();
//012i0000000LkBA
//Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CaseHelpDeskRecordName').Value__c).getRecordTypeId();
//; 

//case Bill To / Ship To/Sold To Case  :RecordTypeId
public static string CaseBillToShipToSoldToRecordTypeId=
Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('Case_Sold To Case').Value__c).getRecordTypeId();


//case HelpDesk  :RecordTypeId
public static string CaseHelpDeskRecordTypeId=
Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('CaseHelpDeskRecordName').Value__c).getRecordTypeId();
//'012i0000000LkB5AAK'; 

//Account Prospect Locked:RecordTypeId

public static string AccountProspectLockedRecordTypeId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('AccountProspectLockedRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('AccountProspectLockedRecordName').Value__c:'').getRecordTypeId();
//Lx_SetRecordIDs__c.getAll().get('AccountProspectLockedRecordTypeId').Value__c;
//'012i0000000Liw4AAC'; 

//Account Customer Record Type Id
public static string AccountCustomerRecordTypeId =Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('AccountCustomerRecordName').Value__c).getRecordTypeId();
//'012i0000000LivyAAC'; 

//Account Internal Record Type Id
public static string AccountInternalRecordTypeId =Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('AccountInternalRecordName').Value__c).getRecordTypeId();
//'012i0000000Liw0AAC'; 

//Account Partner Locked RecordTypeId
public static string AccountPartnerLockedRecordTypeId =Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('AccountPartnerLockedRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('AccountPartnerLockedRecordName').Value__c:'').getRecordTypeId();
//'012i0000000Liw2AAC'; 

//Account Partner Locked RecordTypeId
public static string AccountPartnerUnlockedRecordTypeId =Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('AccountPartnerUnlockedRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('AccountPartnerUnlockedRecordName').Value__c:'').getRecordTypeId();
//'012i0000000Liw3AAC'; 

//HelpDesk.MDM Portal Queue Id
public static string HelpDeskMDMPortalQId =Lx_SetRecordIDs__c.getAll().get('HelpDeskMDMPortalQId').Value__c;
//'00Gi0000000ZEvpEAG'; 

/*
 * 
 * Description : Check if the current record type is avaialble or not.
 * Param - strRecordTypeId : RecordType ID
 * Param - strObjectName : Object Name
 * Returns :  Boolean - indicates active one or inactive one.
*/
public static boolean isActiveRecordType(string strRecordTypeId, string strObjectName)
{
    if(strObjectName == null) return false;
    Schema.DescribeSObjectResult objDescResult = Schema.getGlobalDescribe().get(strObjectName).getDescribe(); 
    Map<Id,Schema.RecordTypeInfo> rtMapById = objDescResult.getRecordTypeInfosById();
    Schema.RecordTypeInfo objRTInfo = rtMapById.get(strRecordTypeId);
    system.debug('objRTInfo == '+objRTInfo);
    if(objRTInfo == null) return false;
    return objRTInfo.isAvailable(); 
}

    public static Map<String,Id> mapRecordTypeWithIds = new Map<String,Id>();
    
    /*
     * 
     * Description : Gets the RecordType ID based on Sobject and Record Type Name
     * Param - strRecordTypeName : Record Type Name
     * Param - strObjectName : Object Name
     * Returns :  ID - Returns Id of the record type here.
    */
    public ID getRecordTypeID(string strRecordTypeName, string strObjectName)
    { 
        
           //Check if we store the recordtype in variable here
           if(mapRecordTypeWithIds != null && mapRecordTypeWithIds.get(strRecordTypeName) != null)
           {
                return mapRecordTypeWithIds.get(strRecordTypeName);
           }
           else
           {
               //gets type info from the schema about the object
               Schema.Sobjecttype sObjectType = schema.getGlobalDescribe().get(strObjectName);
               // checks if the Sobject type is a null
               if(sObjectType == null) return null;
               // map from Record type names to record type Info
               Map<String, Schema.RecordTypeInfo> mapRecordTypes;
               // get the describtion of the SObject like Record type
               schema.Describesobjectresult sobjdescribe = sObjectType.getDescribe();
               // Fetch the Record type info
               mapRecordTypes = sobjdescribe.getRecordTypeInfosByName();  
               Schema.Recordtypeinfo objRecordTypeInfo;
               objRecordTypeInfo = mapRecordTypes.get(strRecordTypeName);
               if(objRecordTypeInfo == null) return null;
               mapRecordTypeWithIds.put(strRecordTypeName,objRecordTypeInfo.getRecordTypeId());
               return objRecordTypeInfo.getRecordTypeId();
           }
    }



//Queue :Channel New
public static string ChannelNewQueueId='';
//'003e0000005a9vE'; sandbox

  
 // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
 // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    public static ID PortalAccountID=null;
    //'003e0000005a9vE'; sandbox    


}