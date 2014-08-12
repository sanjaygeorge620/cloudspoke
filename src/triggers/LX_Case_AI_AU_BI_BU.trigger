/* Trigger Name  : LX_Case_AI_AU_BI_BU
 * Description   : This is a trigger that checks and assigns Account Change request cases for approval and then assign them to queue.
 * Created By    : Sanjay George(Deloitte)
 * Created Date  : 07-08-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Sanjay George        07-08-2013                       Initial Version
 * Akhanksha G          23-12-2013                       Updated Star functioanlity
 * Sanjay Chaudhary    02-26-2013                        Updated such that the Case Owner Change for 'Account Change Request' cases 
 *                                                       only happen on Status Change and when Status = "Approved' .                                                                                  
 */
 
 trigger LX_Case_AI_AU_BI_BU on Case (after insert, after update,before insert,before update) {
  // Functionality to provide Bypass logic
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    // Automated Case Functionality
    List<WBS_Request__c> wbs_requests = new List<WBS_Request__c>();
    List<SAP_Project_Request__c> sap_requests = new List<SAP_Project_Request__c>();
    // List of cases being passed for Approval
    List<Case> CaseList = new List<Case>();
    // Set to store Case owners
    set<id> OwnerSet= new set<id>();
    ID recordids = null; 
    List<ID> lstCaseIds = new List<ID>();
    string paymentterm1;
    Set<ID> setCasesToUpdate = new Set<ID>();
    Set<ID> setCaseIds = new Set<ID>();
    Set<ID> setCaseAccountIds = new Set<ID>();
    Set<ID> setCaseOpporIds = new Set<ID>();
    Set<ID> setCaseSalesOrgIds = new Set<ID>();
    Set<ID> setCaseContactIds = new Set<ID>();
    Map<String,Case> mapOfCaseSoldTo = new Map<String,Case>();
    //Set<String> caseSoldToIds = new Set<String>();
    Map<ID,ID> mapOfCaseAcconts = new Map<ID,ID>();
    Map<ID,ID> mapOfCaseOpportunity = new Map<ID,ID>();
    Map<ID,ID> mapOfSAPAccounts = new Map<ID,ID>();
    MAp<String,String> mapOfPaymentTerms = new Map<String,String>();
    Map<ID,Case> mapOfSAPrecordCase = new Map<ID,Case>();
    Set<String> sapSoldToIDs = new Set<String>();
    List<LX_SAP_Record__c>  listExistingSapRecords = new List<LX_SAP_Record__c>();
    List<LX_SAP_Record__c>  listSapRecords = new List<LX_SAP_Record__c>();
    Map<ID,Account> mapCaseAccounts;
    Map<ID,Opportunity> mapCaseOpportunity;
    List<LX_SAP_Record_Sales_Org__c> lstSAPRecordSalesOrg = new List<LX_SAP_Record_Sales_Org__c>();
    Map<String,String> mapSalesOrg = new Map<String,String>();
  
    // Qeury to find the user of the record
    List<Contact> AccountChangeConList = [select name,id from contact where Email= :UserInfo.getUserEmail() limit 1];
    //ID recordids = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(LX_PSEHelperClass.CaseSAPProjRecordType).getRecordTypeId();
    // Loop to find the list of owners assocaited for the Trigger.new list
    Database.DMLOptions dlo = new Database.DMLOptions();
    // enable auto email creation on a case insertion - added by sumedha 2/13/2014
    // dlo.EmailHeader.triggerAutoResponseEmail = true;
     dlo.EmailHeader.triggerUserEmail= true;
     
    for(Case cse: Trigger.new){
        // Populating all the formual fields and BI BU fields
        
        if(Trigger.isAfter){
            if(cse.Recordtypeid==LX_SetRecordIDs.CaseAccountChangeRequestRecordId &&cse.Status=='New'){
                CaseList.add(cse);
                OwnerSet.add(cse.Ownerid);
            }
        }
        // Checking the condition satifying the 'Account Change Request' record type and then find the contact assocaited with the record.
        if(Trigger.isBefore&&cse.status=='New'&&cse.Contact==null&&cse.Recordtypeid==LX_SetRecordIDs.CaseAccountChangeRequestRecordId){
            if(AccountChangeConList.size()>0){
                system.debug('Inner Loop'+AccountChangeConList[0]);
                cse.Contactid=AccountChangeConList[0].id;
                
            }
        }
        
        if(Trigger.isbefore && cse.recordtypeid==LX_SetRecordIDs.CaseLeadConversionRecordTypeId)
        {
            setCasesToUpdate.add(cse.id);
            setCaseAccountIds.add(cse.accountid);
            setCaseOpporIds.add(cse.LX_Opportunity__c);
            //setCaseSalesOrgIds.add(cse.LX_Sales_Organization_Country__c);
            //System.debug('SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS'+setCaseSalesOrgIds);
            setCaseContactIds.add(cse.contactid);
            
            if(Trigger.isinsert && (cse.type ==Label.LX_Lead_Conversion_Status_MDMSoldTo || cse.type ==Label.LX_Case_SFDC_Account_with_Sold_To))
            {
                setCaseIds.add(cse.id);         
                mapOfCaseAcconts.put(cse.id,cse.Accountid);
                mapOfCaseOpportunity.put(cse.id,cse.LX_Opportunity__c);
            }
        }
            
    }
    
    map<id,user> UserMap;
    if(OwnerSet.size()>0){
        // Map to store userid and manager id
        UserMap = new Map<id,user>([Select id , managerid from user where id in:OwnerSet]);
    }
    
    case cs;
    // Checking the condition satifying the 'Account Change Request' record type and then submit it for approval
    for(Case cse: Trigger.new){
        if(Trigger.isAfter){
           if(cse.status=='Approved'&&cse.Recordtypeid==LX_SetRecordIDs.CaseAccountChangeRequestRecordId && cse.status != Trigger.oldmap.get(cse.Id).Status )
            {   
                System.debug('Inside line 63 >>>>>>>');
                lstCaseIds.add(cse.Id);
            }
           else
            {
                if(cse.Recordtypeid==LX_SetRecordIDs.CaseAccountChangeRequestRecordId &&cse.Status=='New'){
                system.debug('Test-->>>>>>>>'+UserMap.get(cse.ownerid));
                      if(UserMap.containskey(cse.ownerid)&&UserMap.get(cse.ownerid).managerid!=null){
                            if(!LX_CaseTriggger_util.submitforApproval(cse.id,UserMap.get(cse.ownerid).managerid ))
                                cse.adderror('Record could not be submitted for approval');
                        }
                        else if(UserMap.containskey(cse.ownerid)){
                            cse.adderror('Owner Manager cannot be null');
                        }
                      
                    
                    
                }
            }
            
        } 
    }
    
    if(!lstCaseIds.isEmpty() && !LX_CaseTriggger_util.isFuture){
         System.debug('>>>>>>>>>lstCaseIds>>>>>>>>>'+lstCaseIds);
        LX_CaseTriggger_util.updateOwnership(lstCaseIds);
        
     }
    
    // Code Added for updating fields : START
    
    if(Trigger.isBefore)
    {
        Map<Id,Contact> caseContacts = new Map<Id,Contact>([Select pse__Region__r.name from contact WHERE ID IN :setCaseContactIds]);
        Map<Id,Account> caseAccounts = new Map<Id,Account>([Select id,DunsNumber,MDM_ID__c,MDM_Account_Number__c from Account WHERE ID IN :setCaseAccountIds]);
        Map<Id,Opportunity> caseOpportunities = new Map<Id,Opportunity>([Select Sales_Organization_value__c,Sales_Organization__r.name,Payment_Terms__r.SAP_Code__c from opportunity WHERE ID IN :setCaseOpporIds]);
        //Map<ID,Sales_Organization__c> caseSalesOrganizations = new Map<ID,Sales_Organization__c>([Select name,Sales_Organization__c from Sales_Organization__c where id in :setCaseSalesOrgIds]);
        //system.debug('caseSoldTos-->'+caseSalesOrganizations );
        system.debug('caseOpportunities-->'+caseOpportunities );
        //Querying case recordtype 
        recordids = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(LX_PSEHelperClass.CaseSAPProjRecordType).getRecordTypeId();
        LX_CaseTriggger_util.LX_CaseFieldPopulation(Trigger.new, Trigger.old);
        
        for(Case csRec : Trigger.new)
        {
         if(Trigger.isbefore && csRec.recordtypeid==LX_SetRecordIDs.CaseLeadConversionRecordTypeId)
            setCaseSalesOrgIds.add(csRec.LX_Sales_Organization_Country__c);
        }
        Map<ID,Sales_Organization__c> caseSalesOrganizations = new Map<ID,Sales_Organization__c>([Select name,Sales_Organization__c from Sales_Organization__c where id in :setCaseSalesOrgIds]);
        
            For(Case cs1: Trigger.new)
            {paymentterm1='';
                if(Trigger.isinsert)
                { 
                    //Checking for 'SAP project request' record type and closed cases.
                    if(cs1.recordtypeID == recordids  && cs1.status =='Closed')
                    {
                        if(cs1.WBS_Request__c !=null)
                        {
                            //Building WBS requests with status to update
                            WBS_Request__c wbs_req = new WBS_Request__c(id=cs1.WBS_Request__c, LX_Case_Status__c='Closed');
                            wbs_requests.add(wbs_req);
                        }
                        if(cs1.SAP_Project_Request__c !=null)
                        {
                            //Building SAP Project requests with status to update
                            SAP_Project_Request__c sap_req = new SAP_Project_Request__c (id=cs1.SAP_Project_Request__c, Case_Status__c='Closed');
                            sap_requests.add(sap_req);
                        }
                    }
                
                //Checking for 'SAP project request' record type and not closed cases.
                    else if(cs1.recordtypeID == recordids  && cs1.status !='Closed')
                    {
                        if(cs1.WBS_Request__c !=null)
                        {
                            //Building WBS requests with status to update
                            WBS_Request__c wbs_req = new WBS_Request__c(id=cs1.WBS_Request__c, LX_Case_Status__c='Open');
                            wbs_requests.add(wbs_req);
                           // cs1.status ='Open-Working';
                        }
                        if(cs1.SAP_Project_Request__c !=null)
                        {
                            //Building SAP Project requests with status to update
                            SAP_Project_Request__c sap_req = new SAP_Project_Request__c (id=cs1.SAP_Project_Request__c, Case_Status__c='Open');
                            sap_requests.add(sap_req);
                           // cs1.status ='Open-Working';
                        }   
                    }
                    
                }
                if(Trigger.isupdate)
                {
                    if(cs1.recordtypeID ==recordids && cs1.status =='Closed' && Trigger.oldMap.get(cs1.id).status!='Closed')
                    {
                        if(cs1.WBS_Request__c !=null)
                        {
                            //Building WBS requests with status to update
                            WBS_Request__c wbs_req = new WBS_Request__c(id=cs1.WBS_Request__c, LX_Case_Status__c='Closed');
                            wbs_requests.add(wbs_req);
                        }
                        if(cs1.SAP_Project_Request__c !=null)
                        {
                            //Building SAP Project requests with status to update
                            SAP_Project_Request__c sap_req = new SAP_Project_Request__c (id=cs1.SAP_Project_Request__c, Case_Status__c='Closed');
                            sap_requests.add(sap_req);
                        }
                    }
                    else if (cs1.recordtypeID ==recordids && cs1.status !='Closed')
                    {
                        if(cs1.WBS_Request__c !=null)
                        {
                            //Building WBS requests with status to update
                            WBS_Request__c wbs_req = new WBS_Request__c(id=cs1.WBS_Request__c, LX_Case_Status__c='Open');
                            wbs_requests.add(wbs_req);
                            //cs1.status ='Open-Working';
                        }
                        if(cs1.SAP_Project_Request__c !=null)
                        {
                            //Building SAP Project requests with status to update
                            SAP_Project_Request__c sap_req = new SAP_Project_Request__c (id=cs1.SAP_Project_Request__c, Case_Status__c='Open');
                            sap_requests.add(sap_req);
                            //cs1.status ='Open-Working';
                        }
                    }
                }
                
                if(cs1.recordtypeid==LX_SetRecordIDs.CaseLeadConversionRecordTypeId){
                  //  LX_CaseTriggger_util.LX_CaseFieldPopulation(Trigger.new, Trigger.old);
                    cs1.LX_Sales_Organization__c = caseSalesOrganizations.get(cs1.LX_Sales_Organization_Country__c)!=null?caseSalesOrganizations.get(cs1.LX_Sales_Organization_Country__c).name:null;
                    system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDD'+caseSalesOrganizations.get(cs1.LX_Sales_Organization_Country__c));
                    cs1.LX_Sales_Organization_Number__c = caseSalesOrganizations.get(cs1.LX_Sales_Organization_Country__c)!=null?caseSalesOrganizations.get(cs1.LX_Sales_Organization_Country__c).Sales_Organization__c:null;
                    cs1.LX_Case_Contact_Region__c= caseContacts.get(cs1.contactid)!=null?caseContacts.get(cs1.contactid).pse__Region__r.name:null;
                    cs1.LX_D_U_N_S_Number__c= caseAccounts.get(cs1.accountid)!=null?caseAccounts.get(cs1.accountid).DunsNumber:null;
                    
                    if(Trigger.isInsert&&(cs1.type == Label.LX_Lead_Conversion_Status_MDMSoldTo || cs1.type == Label.LX_Case_Type_SFDC_Account_with_Sold_To|| (cs1.Origin=='Account' || cs1.Origin=='Opportunity')))
                    {    
                        String temp_MDM_ID = caseAccounts.get(cs1.accountid)!=null?caseAccounts.get(cs1.accountid).MDM_Account_Number__c:null ;                
                        cs1.LX_MDM_ID__c=temp_MDM_ID;
                        cs1.LX_MDM_Account_Number__c=caseAccounts.get(cs1.accountid)!=null?caseAccounts.get(cs1.accountid).MDM_ID__c:null;              
                        if(temp_MDM_ID !=null)
                        cs1.LX_Block_MDM_Account_Creation__c=true;
                    }
                }
            }
        
        //Updating WBS request records
        if(wbs_requests.size()>0)
            update wbs_requests;
        
        //Updating SAP Project request records
        if(sap_requests.size()>0)
            update sap_requests;
    }
     // Code Added for updating fields : END
     
    // Logic added to create SoldTo record and Sold to sales organization
    if(Trigger.isbefore && Trigger.isinsert && FirstRun_Check.FirstRun_LX_Case_trigger)
    {
        For(String paymentTerm : Label.LX_Matching_Payment_Terms.split(','))
        {
            List<String> tempString = paymentTerm.split('\\\\');
            mapOfPaymentTerms.put(tempString[0],tempString[1]);
        }
    
    mapCaseAccounts= new Map<Id,Account>([Select id,name,MDM_ID__c,MDM_Account_Number__c, LX_Country_Code__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where id in :mapOfCaseAcconts.values()]);
    
        
    for(Case  csRec : Trigger.new)
    {
            Account tempAcc = mapCaseAccounts.get(mapOfCaseAcconts.get(csRec.id)) ;
            if(tempAcc!=null)
            listSapRecords.add(new LX_SAP_Record__c(LX_Account__c=tempAcc.id,LX_Status__c ='Inactive',LX_Name__c = tempAcc.name, Recordtypeid =LX_SetRecordIDs.SAPRecordSoldToId, LX_MDM_Act__c= tempAcc.MDM_Account_Number__c,LX_MDM_ID__c=tempAcc.MDM_ID__c,LX_Physical_City__c=csRec.LX_Physical_City__c,
                                    LX_Physical_Country__c=csRec.LX_Physical_Country__c,
                                    LX_Physical_Postal_Code__c=csRec.LX_Physical_Postal_Code__c,
                                    LX_Physical_State__c=csRec.LX_Physical_State__c,
                                    LX_Physical_Street_Address__c=csRec.LX_Physical_Street_Address__c));
    }
    
    if(listSapRecords.size()>0)
    insert listSapRecords;
    
    For(LX_SAP_Record__c saprecordIDs : [Select LX_Account__c from LX_SAP_Record__c where LX_Account__c in :mapOfCaseAcconts.values()])
        mapOfSAPAccounts.put(saprecordIDs.LX_Account__c,saprecordIDs.id);
        
        for(Sales_Organization__c salesOrg:[Select LX_Country_Code__c,Sales_Organization__c from Sales_Organization__c where LX_Default__c=true and status__C='Active'])
        mapSalesOrg.put(salesOrg.LX_Country_Code__c,salesOrg.Sales_Organization__c);
     
        
    for(Case  csRec : Trigger.new)
    {
        csRec.LX_Sold_To_Record__c = mapOfSAPAccounts.get(csRec.accountid)!=null?mapOfSAPAccounts.get(csRec.accountid):null;
        mapOfSAPrecordCase.put(mapOfSAPAccounts.get(csRec.accountid),csRec);
    }
    
    For(LX_SAP_Record__c sapRecor: listSapRecords)
    {   
        Account tempAcc = mapCaseAccounts.get(sapRecor.LX_Account__c);
        if(mapOfSAPrecordCase.get(sapRecor.id).origin == 'Lead' || mapOfSAPrecordCase.get(sapRecor.id).origin == 'Opportunity')
        lstSAPRecordSalesOrg.add(new LX_SAP_Record_Sales_Org__c(LX_Sales_Org1__c=mapOfSAPrecordCase.get(sapRecor.id).LX_Sales_Organization_Number__c,Sales_Org_Name__c=mapOfSAPrecordCase.get(sapRecor.id).LX_Sales_Organization__c,LX_Currency__c=mapOfSAPrecordCase.get(sapRecor.id).CurrencyIsoCode,LX_Default_Payment_Terms__c=mapOfPaymentTerms.get(mapOfSAPrecordCase.get(sapRecor.id).LX_Payment_Terms__c),LX_Payment_Terms_Description__c =mapOfSAPrecordCase.get(sapRecor.id).LX_Payment_Terms__c,LX_Sold_To__c=sapRecor.id,LX_Status__c='InActive',Recordtypeid=LX_SetRecordIDs.SAPRecordSalesOrgRecordTypeID ));
        else if(mapOfSAPrecordCase.get(sapRecor.id).origin == 'Account')
        lstSAPRecordSalesOrg.add(new LX_SAP_Record_Sales_Org__c(LX_Sales_Org1__c=mapSalesOrg.get(tempAcc.LX_Country_Code__c)!=null?mapSalesOrg.get(tempAcc.LX_Country_Code__c):null,Sales_Org_Name__c=tempAcc.BillingCountry,LX_Currency__c=mapOfSAPrecordCase.get(sapRecor.id).CurrencyIsoCode,LX_Default_Payment_Terms__c=mapOfPaymentTerms.get(mapOfSAPrecordCase.get(sapRecor.id).LX_Payment_Terms__c),LX_Payment_Terms_Description__c =mapOfSAPrecordCase.get(sapRecor.id).LX_Payment_Terms__c,LX_Sold_To__c=sapRecor.id,LX_Status__c='InActive',Recordtypeid=LX_SetRecordIDs.SAPRecordSalesOrgRecordTypeID ));
    }
    insert lstSAPRecordSalesOrg;
    FirstRun_Check.FirstRun_LX_Case_trigger=false;
    } 
   
}