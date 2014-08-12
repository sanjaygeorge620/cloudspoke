/*
Class Name : LX_AddCustomerExtension
Description : Extension class for adding end customer by clicking on the 'Add Customer' related list button on the 'Opportunity Party' list from an Opportunity
Created By : Shubhashish Rai (shrai@deloitte.com)
Created Date : 14-July-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai   14-July-2014           1000               Initial Version
*************************************************************************/

public with sharing class LX_AddCustomerExtension_Clone{
    public Id oppId{get;set;}
    public boolean pgBlockRenderMain{get;set;}
    public boolean pgBlockDataDotComRender{get;set;}
    public boolean oppPartyListExists{get;set;}
    public boolean noRecordsFromSearchExists{get;set;}
    public boolean outputPanelSelectedCustomer{get;set;}
    public boolean IsSubmittedforQuickBid{get;set;}
    public boolean outputPanelSbmttoApprvl {get;set;}
    
    public List<DataCloudCompanyWrapper> dataCloudWrapperList{get;set;}
    public List<DataCloudCompanyWrapper> savedDataCloudWrapperList{get;set;}
    public List<SelectOption> countriesList = new List<SelectOption>();
    public List<Account> accoutSearchList = new List<Account>();
    
    public String companyNameForm{get;set;}
    public String physicalCityForm{get;set;}
    public String physicalState{get;set;}
    public String physicalZip{get;set;}
    public String physicalCountry{get;set;}
    public String phoneNumberFromForm{get;set;}
    public String websiteFromForm{get;set;}
    
    public String DataDotComSelectedRecord{get;set;}
    public Lead lInstance{get;set;}
    
    public Integer totalRecs = 50000;  
    public boolean prev{get;set;}
    public boolean nxt{get;set;}
    
    public boolean prev_SavedProducts{get;set;}
    public boolean nxt_SavedProducts{get;set;}
    
    private boolean isLastPage = false;
    private integer OffsetSize = 0;
    private integer LimitSize = Integer.valueOf(Label.LX_Page_Limit_PRM_SearchResults);
    
    public LX_AddCustomerExtension_Clone(ApexPages.StandardController controller){
         lInstance = new Lead();
        oppId= ApexPages.currentPage().getParameters().get('oppId');        
        String queryOppPartyString = 'Select id, Name, LX_Account__c, LX_Account_Name__c, LX_Account_Street__c, LX_Account_City__c,LX_Account_State__c, LX_Account_Postal_Code__c, LX_Account_Country__c,LX_Account_Duns_Number__c, LX_Account_Phone__c, LX_Account_Website__c, LX_Account_Text__c, LX_Account_Street_Text__c, LX_Account_City_Text__c, LX_Account_State_Text__c, LX_Account_Postal_Code_Text__c, LX_Account_Country_Text__c, LX_Account_Phone_Text__c, LX_Account_Website_Text__c from LX_Opportunity_Parties__c where LX_Opportunity__c in (\'' + oppId + '\') and LX_Opportunity_Party_Type__c = \'Customer\'' ;
        List<LX_Opportunity_Parties__c> oppPartyList = new List<LX_Opportunity_Parties__c>();
        pgBlockRenderMain = true;
        pgBlockDataDotComRender = false;
        oppPartyListExists = false;
        noRecordsFromSearchExists = false;
        IsSubmittedforQuickBid = false;
        opportunity opp = [select id,LX_In_Approval_Process_Quick_Bid__c from opportunity where id=: oppId];
        if(opp != null){
         if(opp.LX_In_Approval_Process_Quick_Bid__c)
            IsSubmittedforQuickBid = true;
        }
        prev = true;
        nxt = false;
        try{
            oppPartyList = Database.query(queryOppPartyString);
            System.debug('@@@oppPartyList ' + oppPartyList );
        }
        catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }
        DataCloudCompanyWrapper dSavedCloudWrapper = new DataCloudCompanyWrapper();
        if(oppPartyList.size()>0){
            pgBlockRenderMain = false;
            outputPanelSelectedCustomer = true;
            
            savedDataCloudWrapperList = new List<DataCloudCompanyWrapper>();
            
            if(oppPartyList[0].LX_Account__c!=null){
                if(oppPartyList[0].LX_Account_Name__c!=null && oppPartyList[0].LX_Account_Name__c!='')
                    dSavedCloudWrapper.Name = oppPartyList[0].LX_Account_Name__c;
                if(oppPartyList[0].LX_Account_Street__c!=null && oppPartyList[0].LX_Account_Street__c!='')
                    dSavedCloudWrapper.Street = oppPartyList[0].LX_Account_Street__c;
                if(oppPartyList[0].LX_Account_City__c!=null && oppPartyList[0].LX_Account_City__c!='')
                    dSavedCloudWrapper.City = oppPartyList[0].LX_Account_City__c;
                if(oppPartyList[0].LX_Account_State__c!=null && oppPartyList[0].LX_Account_State__c!='')
                    dSavedCloudWrapper.State = oppPartyList[0].LX_Account_State__c;
                if(oppPartyList[0].LX_Account_Postal_Code__c!=null && oppPartyList[0].LX_Account_Postal_Code__c!='')
                    dSavedCloudWrapper.Zip = oppPartyList[0].LX_Account_Postal_Code__c;
                if(oppPartyList[0].LX_Account_Country__c!=null && oppPartyList[0].LX_Account_Country__c!='')
                    dSavedCloudWrapper.Country = oppPartyList[0].LX_Account_Country__c;
                if(oppPartyList[0].LX_Account_Duns_Number__c!=null && oppPartyList[0].LX_Account_Duns_Number__c!='')
                    dSavedCloudWrapper.DunsNumber = oppPartyList[0].LX_Account_Duns_Number__c;
                if(oppPartyList[0].LX_Account_Phone__c!=null && oppPartyList[0].LX_Account_Phone__c!='')
                    dSavedCloudWrapper.Phone = oppPartyList[0].LX_Account_Phone__c;
                if(oppPartyList[0].LX_Account_Website__c!=null && oppPartyList[0].LX_Account_Website__c!='')
                    dSavedCloudWrapper.Website = oppPartyList[0].LX_Account_Website__c;
        }
        else{
                if(oppPartyList[0].LX_Account_Text__c!=null && oppPartyList[0].LX_Account_Text__c!='')
                    dSavedCloudWrapper.Name = oppPartyList[0].LX_Account_Text__c;
                if(oppPartyList[0].LX_Account_Street_Text__c!=null && oppPartyList[0].LX_Account_Street_Text__c!='')
                    dSavedCloudWrapper.Street = oppPartyList[0].LX_Account_Street_Text__c;
                if(oppPartyList[0].LX_Account_City_Text__c!=null && oppPartyList[0].LX_Account_City_Text__c!='')
                    dSavedCloudWrapper.City = oppPartyList[0].LX_Account_City_Text__c;
                if(oppPartyList[0].LX_Account_State_Text__c!=null && oppPartyList[0].LX_Account_State_Text__c!='')
                    dSavedCloudWrapper.State = oppPartyList[0].LX_Account_State_Text__c;
                if(oppPartyList[0].LX_Account_Postal_Code_Text__c!=null && oppPartyList[0].LX_Account_Postal_Code_Text__c!='')
                    dSavedCloudWrapper.Zip = oppPartyList[0].LX_Account_Postal_Code_Text__c;
                if(oppPartyList[0].LX_Account_Country_Text__c!=null && oppPartyList[0].LX_Account_Country_Text__c!='')
                    dSavedCloudWrapper.Country = oppPartyList[0].LX_Account_Country_Text__c;
             /*   if(oppPartyList[0].LX_Account_Duns_Number__c!=null && oppPartyList[0].LX_Account_Duns_Number__c!='')
                    dSavedCloudWrapper.DunsNumber = oppPartyList[0].LX_Account_Duns_Number__c;*/
                if(oppPartyList[0].LX_Account_Phone_Text__c!=null && oppPartyList[0].LX_Account_Phone_Text__c!='')
                    dSavedCloudWrapper.Phone = oppPartyList[0].LX_Account_Phone_Text__c;
                if(oppPartyList[0].LX_Account_Website_Text__c!=null && oppPartyList[0].LX_Account_Website_Text__c!='')
                    dSavedCloudWrapper.Website = oppPartyList[0].LX_Account_Website_Text__c;        
        }
           savedDataCloudWrapperList.add(dSavedCloudWrapper);
            
        if(outputPanelSelectedCustomer ==true && IsSubmittedforQuickBid == true){
          outputPanelSelectedCustomer = false;
          outputPanelSbmttoApprvl = true;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_OnSubmitted_OppCustomer_Message));          
        }
        else{
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Only_One_Opp_Party_Allowed));          
           }
        }
    }
    //Getter to initialize the values of the country on the form - retrieved from the Opportunity - Opportunity Country field
    public List<SelectOption> getcountriesList(){
       List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = LX_Countries_In_Scope__c.LX_Country__c.getDescribe();
       List<Schema.PicklistEntry> listPicklistEntry = fieldResult.getPicklistValues();
       
       options.add(new SelectOption('','--None--'));
            
       for( Schema.PicklistEntry pickEntryVar : listPicklistEntry)
       {
          options.add(new SelectOption(pickEntryVar.getLabel(), pickEntryVar.getValue()));
       }       
       return options;
    }
    public PageReference onlyOneOppPartyAllowed(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Only_One_Opp_Party_Allowed));    
       return null;    
    }
    public PageReference cancelLogic(){
        PageReference PageRef  = new PageReference ('/'+oppId);
        return PageRef ;
    }
    public PageReference saveLogic(){
        LX_Opportunity_Parties__c oppParty = new LX_Opportunity_Parties__c();
        List<DataCloudCompanyWrapper> dataCloudWrapperListSelected = new List<DataCloudCompanyWrapper>();
        String DunsNumberCompany;
        List<Account> accountList = new List<Account>();
        
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');

        for(DataCloudCompanyWrapper dCloudCompanyWrapper: dataCloudWrapperList){
            if(dCloudCompanyWrapper.isSelected){
                dataCloudWrapperListSelected.add(dCloudCompanyWrapper);
            }
        }
        System.debug('@@@dataCloudWrapperListSelected' + dataCloudWrapperListSelected);
        if(dataCloudWrapperListSelected.size()==0){
            PageReference pRef = NoAccountSelected();
            return pRef;
        }
        if(dataCloudWrapperListSelected.size()>1){
            PageReference pRef = MultipleAccountsSelected();
            return pRef;
        }
        else{
            DunsNumberCompany =  dataCloudWrapperListSelected[0].DunsNumber;
            String queryAccount = 'Select id, Name,MDM_Account_Number__c,MDM_ID__c,Physical_Country__c, Type,TR_Status__c from Account where DunsNumber = \'' + DunsNumberCompany +'\'';
                try{
                    accountList = Database.query(queryAccount);
                    System.debug('@@@accountList' + accountList);
                }
                catch(Exception ex){
                    LX_CommonUtilities.createExceptionLog(ex);
                }
            if(accountList.size()>0){ 
                if(accountList[0].type != 'Customer' || accountList[0].TR_Status__c == 'On'){
                    PageReference pRef = CustomerNotEligible();
                    return null; 
                }
                else{
                    Integer countSapRcdMdmAccountNo = 0;
                    Integer countSapRcdMdmId = 0;
                    if(accountList[0].MDM_Account_Number__c!='' && accountList[0].MDM_Account_Number__c!=null)
                        countSapRcdMdmAccountNo = [Select count() from  LX_SAP_Record__c where LX_Status__c = 'Active' and recordtype.name='Sold To' and LX_MDM_Act__c =: accountList[0].MDM_Account_Number__c];
                    if(countSapRcdMdmAccountNo==0){
                        if(accountList[0].MDM_ID__c!=null && accountList[0].MDM_ID__c!='')
                            countSapRcdMdmId = [Select count() from LX_SAP_Record__c where LX_Status__c = 'Active' and recordtype.name='Sold To' and LX_MDM_ID__c =: accountList[0].MDM_ID__c];    
                        if(countSapRcdMdmId ==0){
                            PageReference pRef = NoActiveSoldTo();
                            return null;
                        }
                    }
                    List <LX_SAP_Record__c> sapRecordList = new List <LX_SAP_Record__c>();
                    List <LX_SAP_Record__c> sapRecordZIDCList = new List <LX_SAP_Record__c>();
                    List <LX_SAP_Record_Sales_Org__c> soldToSalesOrgList = new List <LX_SAP_Record_Sales_Org__c>();
                    List <LX_SAP_Record_Sales_Org__c> zidcSalesOrgList = new List <LX_SAP_Record_Sales_Org__c>();
                    
                    if (accountList[0].MDM_Account_Number__c != null){
                        sapRecordList = [Select Id,LX_MDM_Act__c, Name from LX_SAP_Record__c where LX_MDM_Act__c =:accountList[0].MDM_Account_Number__c and recordtype.name='Sold To' and LX_Status__c='Active'];
                        sapRecordZIDCList = [Select Id,LX_MDM_Act__c, Name from LX_SAP_Record__c where LX_MDM_Act__c =:accountList[0].MDM_Account_Number__c and recordtype.name='ZIDC' and LX_Status__c='Active'];
                    }
                    if(sapRecordList.size()>0)
                        soldToSalesOrgList = [Select Id,Name,Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c =:sapRecordList[0].Id and LX_Status__c='Active' ];
                    if(sapRecordZIDCList.size()>0)
                        zidcSalesOrgList = [Select Id,Name,Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c =:sapRecordZIDCList[0].Id and LX_Status__c='Active'];
                    
                    oppParty.LX_Account__c = accountList[0].id;
                    oppParty.LX_Opportunity__c = oppIdVar ;
              //      opportunityList[0].LX_Quote_Category__c = 'Special Bid Traditional';
                    oppParty.LX_Opportunity_Party_Enrollment_Status__c = 'Active';
                    if (sapRecordList.size()>0 )
                        oppParty.LX_Sold_To__c =  sapRecordList[0].Id;
                    if (sapRecordZIDCList.size()>0 )
                         oppParty.LX_ZIDC__c = sapRecordZIDCList[0].Id;
                    if (soldToSalesOrgList.size()>0 )
                         oppParty.LX_Account_Sales_Organization__c = soldToSalesOrgList[0].Id;
                    if (zidcSalesOrgList.size()>0 && soldToSalesOrgList.size()==0  )
                         oppParty.LX_Account_Sales_Organization__c = zidcSalesOrgList[0].Id;
                         
                    oppParty.LX_Product_Line_Items__c = 'Printers;Options';
                    oppParty.LX_Opportunity_Party_Type__c = 'Customer';
                    oppParty.LX_Claiming_Party__c = 'None';
                    oppParty.LX_Purchasing_Method__c = 'Indirect';
                    oppParty.LX_Quote_Type__c = 'Standard';
                    oppParty.LX_Ship_Debit__c = 'None';
                    oppParty.LX_Timing_of_Discount__c = 'Back-end';
                    oppParty.LX_Comments__c = 'Quick Bid Customer';
                    oppParty.LX_Pending_Account_Creation__c = false;
                    oppParty.LX_Opportunity_Party_Type__c = 'Customer';
                    System.debug('@@@oppParty' + oppParty);
                    try{
                       Database.insert(oppParty); 
              //         Database.update(opportunityList[0]);
                    }
                    catch(Exception ex){
                       LX_CommonUtilities.createExceptionLog(ex); 
                    }
                }
            }
            else if(accountList.size()==0){

                oppParty.LX_Account_Text__c = dataCloudWrapperListSelected[0].name;
          //      opportunityList[0].LX_Quote_Category__c = 'Special Bid Traditional';
                oppParty.LX_Account_City_Text__c = dataCloudWrapperListSelected[0].city;
                oppParty.LX_Account_State_Text__c = dataCloudWrapperListSelected[0].state;
                oppParty.LX_Account_Postal_Code_Text__c = dataCloudWrapperListSelected[0].zip;
                oppParty.LX_Account_Country_Text__c = dataCloudWrapperListSelected[0].country;
                if(dataCloudWrapperListSelected[0].phone!=null && !(dataCloudWrapperListSelected[0].phone.contains('+**.')) && dataCloudWrapperListSelected[0].phone!='')
                    oppParty.LX_Account_Phone_Text__c= dataCloudWrapperListSelected[0].phone;
                if(dataCloudWrapperListSelected[0].website!=null && dataCloudWrapperListSelected[0].website!='')
                    oppParty.LX_Account_Website_Text__c= dataCloudWrapperListSelected[0].website;

                oppParty.LX_Pending_Account_Creation__c = true;
                oppParty.LX_ZIDC__c = Label.LX_Bigmachines_GenericZIDC ;
                oppParty.LX_Product_Line_Items__c = 'Printers;Options';
                oppParty.LX_Claiming_Party__c = 'None';
                oppParty.LX_Purchasing_Method__c = 'Indirect';
                oppParty.LX_Ship_Debit__c = 'None';
                oppParty.LX_Timing_of_Discount__c = 'Back-end';
                oppParty.LX_Opportunity_Party_Type__c = 'Customer'; 
                oppParty.LX_Opportunity__c = oppIdVar ;
                System.debug('@@@oppParty' + oppParty+'**ZIDC**'+oppParty.LX_ZIDC__c);
                try{
                   Database.insert(oppParty); 
                }
                catch(Exception ex){
                   LX_CommonUtilities.createExceptionLog(ex); 
                }
                
                System.debug('@@@@lInstance ' + lInstance);
            }
        PageReference PageRef  = new PageReference ('/'+oppId);
        return PageRef ;
        }
    }
    public void inlineDeleteLogic(){
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');
        List<LX_Opportunity_Parties__c> oppPartyListCustomer = [Select id from LX_Opportunity_Parties__c where LX_Opportunity__c=: oppIdVar and LX_Opportunity_Party_Type__c = 'Customer'];        
        if(oppPartyListCustomer.size()>0){
            try{
                Database.delete(oppPartyListCustomer);
                savedDataCloudWrapperList.clear();
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                LX_CommonUtilities.createExceptionLog(ex);
            }
        }
        System.debug('@@@ in Delete Logic');
        pgBlockRenderMain = true;
        outputPanelSelectedCustomer = false;     
    }
    public PageReference saveLogicOverRide(){
        LX_Opportunity_Parties__c oppParty = new LX_Opportunity_Parties__c();
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId'); 
        oppParty.LX_Opportunity__c = oppIdVar ;
        if((companyNameForm == null || companyNameForm == '') || (physicalCityForm == null || physicalCityForm == '') || (physicalState==null || physicalState == '') || (physicalCountry==null || physicalCountry=='')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Enter_All_Details_Customer)); 
            return null; 
        }
        
     //Shubhashish - Commented some of the null checks on the fields to address performance issues.
     //   if(companyNameForm!=null && companyNameForm!=''){
            oppParty.LX_Account_Text__c = companyNameForm;
     //   }
     //   if(physicalCityForm!=null && physicalCityForm!=''){
            oppParty.LX_Account_City_Text__c = physicalCityForm;
     //   }
     //   if(physicalState!=null && physicalState!=''){
            oppParty.LX_Account_State_Text__c = physicalState;
     //   }
        if(physicalZip!=null && physicalZip!=''){
            oppParty.LX_Account_Postal_Code_Text__c = physicalZip;
        }
     //   if(physicalCountry!=null && physicalCountry!=''){
            oppParty.LX_Account_Country_Text__c = physicalCountry;
     //   }
        if(phoneNumberFromForm!=null && phoneNumberFromForm!=''){
            oppParty.LX_Account_Phone_Text__c= phoneNumberFromForm;
        }
        if(websiteFromForm!=null && websiteFromForm!=''){
            oppParty.LX_Account_Website_Text__c= websiteFromForm;
        }
        
        oppParty.LX_Pending_Account_Creation__c = true;
        oppParty.LX_ZIDC__c = Label.LX_Bigmachines_GenericZIDC ;
        oppParty.LX_Opportunity_Party_Type__c = 'Customer';
        oppParty.LX_Product_Line_Items__c = 'Printers;Options';
        oppParty.LX_Claiming_Party__c = 'None';
        oppParty.LX_Purchasing_Method__c = 'Indirect';
        oppParty.LX_Ship_Debit__c = 'None';
        oppParty.LX_Timing_of_Discount__c = 'Back-end'; 
        
       // lstOpportunity[0].LX_Quote_Category__c = 'Special Bid Traditional';
        System.debug('@@@oppParty' + oppParty+'**ZIDC**'+oppParty.LX_ZIDC__c);
        try{
           Database.insert(oppParty); 
        //   Database.update(lstOpportunity[0]);
           
        }
        catch(Exception ex){
           LX_CommonUtilities.createExceptionLog(ex); 
        }
        
        PageReference PageRef  = new PageReference ('/'+oppId);
        return PageRef ;           
    }
    public PageReference CustomerNotEligible(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Customer_Not_Eligible));    
       return null;        
    }
    public PageReference NoAccountSelected(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Account_Selected));    
       return null;
    }
    public PageReference MultipleAccountsSelected(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LX_Multiple_Accounts_Selected));    
       return null;
    }
    public PageReference NoActiveSoldTo(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Active_Sold_To_Error_Message));    
       return null;        
    }

    public void searchLogic(){
        physicalCountry = lInstance.Physical_Country__c;
        String queryDataCloudCount = 'Select count() from DataCloudCompany ';
        String queryDataCloud = 'SELECT Id, City, CompanyId, Country, Description, DunsNumber, ExternalId, Fax, Industry, IsInactive, IsOwned, NaicsCode, NaicsDesc, Name, NumberOfEmployees, Ownership, Phone, Sic, SicDesc, Site, State, Street, TickerSymbol, TradeStyle, Website, YearStarted, Zip FROM DatacloudCompany';
        queryDataCloud+= ' WHERE IsInactive=false';
        queryDataCloudCount+=' WHERE IsInactive=false';
        System.debug('@@@physicalCountry' + physicalCountry);
        
        if(companyNameForm!=null && companyNameForm!=''){
            queryDataCloud+= ' AND Name like \'' +  companyNameForm + '\'';
            queryDataCloudCount+= ' AND Name like \'' +  companyNameForm + '\'';
        }
        if(physicalCityForm!=null && physicalCityForm!=''){
            queryDataCloud+= ' AND City like \'' +  physicalCityForm + '\'';
            queryDataCloudCount+= ' AND City like \'' +  physicalCityForm + '\'';
        }
        if(physicalState!=null && physicalState!=''){
            queryDataCloud+= ' AND State =\'' +  physicalState + '\'';
            queryDataCloudCount+= ' AND State =\'' +  physicalState + '\'';
        }
        if(physicalZip!=null && physicalZip!=''){
            queryDataCloud+= ' AND Zip like \'' +  physicalZip + '\'';
            queryDataCloudCount+= ' AND Zip like \'' + physicalZip + '\'';
        }
        if(physicalCountry!=null && physicalCountry!=''){
            queryDataCloud+= ' AND Country = \'' +  physicalCountry + '\'';
            queryDataCloudCount+= ' AND Country = \'' + physicalCountry + '\'';
        } 
        if(websiteFromForm!=null && websiteFromForm!=''){
            queryDataCloud+= ' AND Website like \'' + websiteFromForm + '\'';
            queryDataCloudCount = ' AND Website like \''+ websiteFromForm + '\'';
        }        
        
        queryDataCloud+= ' Order by Country LIMIT: LimitSize OFFSET: OffsetSize';
        
        System.debug('@@@queryDataCloud' + queryDataCloud);
        System.debug('@@@ limitsize' + LimitSize);
        System.debug('@@@ offsetSize' + OffsetSize);
        List<DatacloudCompany> lstDataCloudCompany = new List<DatacloudCompany>();
        try{
            lstDataCloudCompany = Database.query(queryDataCloud);
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
        
        String strDunsNumber = '(';
        Integer lstIterator = 1;       
        dataCloudWrapperList = new List<DataCloudCompanyWrapper>();
        Map<String, Account> mapDunsNumberAccount = new Map<String, Account>();
        try{
            for(DataCloudCompany dataCloudRecord: lstDataCloudCompany){
                DataCloudCompanyWrapper dCloudCompanyWrapper = new DataCloudCompanyWrapper(dataCloudRecord);
                dataCloudWrapperList.add(dCloudCompanyWrapper);
                if(dCloudCompanyWrapper.DunsNumber != null){
                    if(lstIterator!=lstDataCloudCompany.size() && !(dCloudCompanyWrapper.DunsNumber.contains('***')) && dCloudCompanyWrapper.DunsNumber!=null && dCloudCompanyWrapper.DunsNumber!=''){
                        strDunsNumber+= '\'' + dCloudCompanyWrapper.DunsNumber + '\',';
                    }
                    else if (lstIterator==lstDataCloudCompany.size()){
                        if(!(dCloudCompanyWrapper.DunsNumber.contains('***')) && dCloudCompanyWrapper.DunsNumber!=null && dCloudCompanyWrapper.DunsNumber!='')
                            strDunsNumber+= '\'' + dCloudCompanyWrapper.DunsNumber + '\'';    
                    }
                }
                lstIterator++;
            }
            System.debug('@@@ ' + strDunsNumber );
            if(strDunsNumber.endsWith(',')){
                Integer lengthStr = strDunsNumber.length() - 1;
                strDunsNumber = strDunsNumber.substring(0, lengthStr );      
            }
            System.debug('@@@ ' + strDunsNumber );
            if(strDunsNumber!='('){
                strDunsNumber+= ')';
                String queryStringAccDunsNumber = 'Select id, DunsNumber from Account where DunsNumber in ' + strDunsNumber;
                for(Account acc: Database.query(queryStringAccDunsNumber)){
                    mapDunsNumberAccount.put(acc.DunsNumber, acc);    
                }
                if(dataCloudWrapperList.size()>0){
                    for(DataCloudCompanyWrapper dCloudCompanyWrapper: dataCloudWrapperList){
                        if(mapDunsNumberAccount.containsKey(dCloudCompanyWrapper.DunsNumber)){
                            dCloudCompanyWrapper.doesAccountExist = true;       
                        }
                    }
                }
            }
            if(dataCloudWrapperList.size() < LimitSize && OffsetSize==0){
                nxt = true;
                prev = true;
            }
            else if(dataCloudWrapperList.size() < LimitSize){
                nxt = true;
                prev = false;
            }
        }
        catch(Exception ex){
            System.debug('@@@ exception' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
        if(dataCloudWrapperList.size()>0){
            pgBlockDataDotComRender = true;
        }
        if(dataCloudWrapperList.size()==0){
            noRecordsFromSearchExists=true;
            pgBlockDataDotComRender = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_No_Results_Returned_Add_Customer));
        }
    }
    //Function to make sure that only one checkbox is checked at a particular time
    public void unselectOthers(){
        System.debug('@@@In Unselectothers()');
        System.debug('@@@dataCloudWrapperList ' + dataCloudWrapperList.size());

        DataDotComSelectedRecord = DataDotComSelectedRecord.trim();
        DataDotComSelectedRecord = DataDotComSelectedRecord.toLowerCase();
        
        System.debug('@@@DataDotComSelectedRecord' + DataDotComSelectedRecord); 
        if(dataCloudWrapperList.size()==1){
            return ;
        }
        for(DataCloudCompanyWrapper dInstance: dataCloudWrapperList){
            //Concatenation in the format: {!dataCloudWrapper.name}+{!dataCloudWrapper.city}+{!dataCloudWrapper.state}+{!dataCloudWrapper.zip}+{!dataCloudWrapper.country}+{!dataCloudWrapper.website}+{!dataCloudWrapper.DunsNumber}
           //{!dataCloudWrapper.name}+{!dataCloudWrapper.city}+{!dataCloudWrapper.state}+{!dataCloudWrapper.zip}+{!dataCloudWrapper.country}+{!dataCloudWrapper.website}+{!dataCloudWrapper.DunsNumber}
            String dataDotComRecordConcatenated = dInstance.Name + '+' + dInstance.City + '+' ;//+ dInstance.State  + '+' + dInstance.zip  + '+' + dInstance.country  + '+' + dInstance.DunsNumber;
            if(dInstance.State ==null || dInstance.State==''){
                System.debug('@@@ state is blank' + dInstance.State);
                dataDotComRecordConcatenated+= '' + '+';
            }
            else{
                System.debug('@@@ state is blank' + dInstance.State);
                dataDotComRecordConcatenated+= dInstance.State + '+';            
            }
            if(dInstance.zip == null || dInstance.zip == ''){
                System.debug('@@@ zip is blank' + dInstance.zip);
                dataDotComRecordConcatenated+= '' + '+';            
            }
            else{
                System.debug('@@@ zip is blank' + dInstance.zip);
                dataDotComRecordConcatenated+= dInstance.zip + '+';              
            }
            if(dInstance.country == null || dInstance.country == ''){
                System.debug('@@@ country is blank' + dInstance.country);
                dataDotComRecordConcatenated+= '' + '+';             
            }
            else{
                System.debug('@@@ country is blank' + dInstance.country);
                dataDotComRecordConcatenated+= dInstance.country + '+';             
            }
            dataDotComRecordConcatenated+= dInstance.DunsNumber;
            System.debug('@@@dataDotComRecordConcatenated' + dataDotComRecordConcatenated);
            
            dataDotComRecordConcatenated = dataDotComRecordConcatenated.trim();
            dataDotComRecordConcatenated = dataDotComRecordConcatenated.toLowerCase();
            
            System.debug('@@@dataDotComRecordConcatenated' + dataDotComRecordConcatenated);
          //  System.debug('@@@dInstance.Id ' + dInstance.Id + ' ' + dInstance.isSelected + dataDotComRecordConcatenated);
            if(dInstance.isSelected && DataDotComSelectedRecord!=dataDotComRecordConcatenated){
                dInstance.isSelected = false;               
            }
            else if(DataDotComSelectedRecord==dataDotComRecordConcatenated){
                dInstance.isSelected = true;  
            }
        }
    }
    public void FirstPage()
    {   
        OffsetSize = 0;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        System.debug('@@@1' + OffSetSize);
        searchLogic();
    }
    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        system.debug('OffsetSize == '+OffsetSize);
        searchLogic();
    }
    
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        searchLogic();
    }
    public void LastPage()
    {
        Integer totalPageNumber = getTotalPages();
        OffsetSize = (totalPageNumber - 1)*LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        System.debug('@@@1' + OffSetSize);
        System.debug('@@@2' + totalrecs);
        System.debug('@@@3' + LimitSize);
        searchLogic();
    }
    public Integer getTotal_size()
    {
        return totalRecs;
    }
  
    
    public integer getTotalPages()
    {
        if(math.mod(totalRecs,LimitSize) > 0)
        {
          return totalRecs/LimitSize + 1;
        }
        else
        {
            return (totalRecs/LimitSize);
        }
    } 
    //Wrapper class for DataCloudCompany records    
    public class DataCloudCompanyWrapper{
        public boolean isSelected{get;set;}
        public DatacloudCompany obj{get;set;}
        public Id Id{get;set;}
        public string name {get;set;}
        public string street {get;set;}
        public string city {get;set;}
        public string state {get;set;}
        public string zip {get;set;}
        public string country{get;set;}
        public string DunsNumber{get;set;}
        public boolean isowned{get;set;}
        public string CompanyId{get;set;}
        public string Phone{get;set;}
        public String Website{get;set;}
        public String Sic{get;set;}
        public String SicDesc{get;set;}
        public boolean doesAccountExist{get;set;}
        public DataCloudCompanyWrapper(DatacloudCompany r){
          this.isSelected = false;
          this.id = r.id;
          this.obj = r;
          this.name = r.name;
          this.street = r.street;                        
          this.City = r.City;
          this.State = r.state;
          this.Zip = r.zip;
          this.country = r.country;
          this.DunsNumber = r.DunsNumber;
          this.isowned = r.isowned;
          this.CompanyId = r.CompanyId;
          this.Phone=r.Phone;
          this.Website=r.Website;
          this.Sic = r.Sic;
          this.SicDesc = r.SicDesc;
          this.doesAccountExist = false;
        }
        public DataCloudCompanyWrapper(){
            this.isSelected = false;
            this.doesAccountExist = false;
        }
    }
}