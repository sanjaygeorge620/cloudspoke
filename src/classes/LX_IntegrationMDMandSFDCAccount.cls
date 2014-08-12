/*
 * ©Lexmark Front Office 2013, all rights reserved
 * Created Date : 09/05/2013
 * Author : Arun thakur(arunsingh6@deloitte.com)
 * Description : Update L5 Account record and maintain account Hierarchy .
 *Flow:
 *Create L2,L3 and L4 account record if missed from Account hierarchy.
 *Update L5 Account record.  
 */
 public class LX_IntegrationMDMandSFDCAccount 
{

/*
L1:Account Record type : Global.
L2:Account Record type :Domestic. 
L3:Account Record type: Legal . 
L4:Account Record type : MDM Customer and MDM Partner.  
L5:Account Record type : Location-Customer, Location-Partner and Sold-to-Partner.

Expected Response Fields:
MDM ID
MDM Account ID
Portal Request ID
MDM Account ID Copy
Party Group
Party Role
Party Type
Old MDM Account ID
Old MDM ID
MDM Account Status
Grade
Service Qualified 
Document Folder ID
DNB Worflow Status
Portal Request Scenario
*/
    public void DoAccountUpdateFromWebHttpRequest()
    {
    
    //MDM Web Server Response 
        //L5 Exists :Value duplicate record, required marge to existing L5.  
        //L4 Exists : Update L5 to be assigned to correct L4
        //L3 Exists : Create L4 in SFDC and Update L5.
        //L2 Exists : Create L3,L4 in SFDC and update L5 to be assigned to L4
        //L1 Exists : Create L2-L4 Hierarchy and update L5 to be assigned to L4 
        
    //Get Account Record Type IDs from static classLX_SetRecordIDs :Used static custom setting to avoid hardcode Ids
    
    String L1GlobalAccountRecordId=LX_SetRecordIDs.L1GlobalAccountRecordId;
    String L2DomesticAccountRecordId=LX_SetRecordIDs.L2DomesticAccountRecordId;
    String L3LegalAccountRecordId=LX_SetRecordIDs.L3LegalAccountRecordId;
    
    String L4MDMCustomerAccountRecordId=LX_SetRecordIDs.L4MDMCustomerAccountRecordId;
    String L4MDMPartnerAccountRecordId=LX_SetRecordIDs.L4MDMPartnerAccountRecordId;
    
    String L5LocationCustomerAccountRecordId=LX_SetRecordIDs.L5LocationCustomerAccountRecordId;
    String L5LocationPartnerAccountRecordId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
    //String L5SoldToPartnerAccountRecordId=LX_SetRecordIDs.L5SoldToPartnerAccountRecordId;
    
    
        

    }
}