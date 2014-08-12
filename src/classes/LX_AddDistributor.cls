/*
Class Name : LX_AddDistributor
Description : Extension class for adding Quick Bid Distributor Information. As per User Story US4166
Created By : Sanjay Chaudhary (sanchaudhary@deloitte.com)
Created Date : 24-July-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Sanjay Chaudhary   24-July-2014           1000               Initial Version
*************************************************************************/

public class LX_AddDistributor {

// Declare Variables   
    public Id OppId{get;set;}
    public boolean isPaginationRequired{get;set;}
    public Integer totalRecs = 50000;
    public boolean OnsubmitQuckBidopPnlSelectedDistributor {get;set;}
    public boolean filterFormRendered{get;set;}
    public boolean filterPageBlockRendered{get;set;}
    public boolean mainFormRender{get;set;}
    public boolean mainPageBlockRender{get;set;}
    public String countryFilter{get;set;} 
    public String cityFilter{get;set;}   
    public boolean outputPanelSelectedDistributor{get;set;}
    public boolean currentSelectionRender{get;set;}
    
// Declare list for the Wrapper/Container class    
    public List<accountWrapper> accountWrapperList{get;set;}
    public List<accountWrapper> savedDistributorWrapperList {get;set;}

// The Extension Constructor     
    public LX_AddDistributor(ApexPages.StandardController controller) {
        oppId =  ApexPages.currentPage().getParameters().get('oppId');
        filterFormRendered = true;
        filterPageBlockRendered = true; 
        mainFormRender = true;
        mainPageBlockRender = true; 
        OnsubmitQuckBidopPnlSelectedDistributor = false; 
        outputPanelSelectedDistributor = false ;
        currentSelectionRender = true;
        getDynamicDistributorFilter ();    
        
        opportunity opp = [select id,LX_In_Approval_Process_Quick_Bid__c from opportunity where id=: oppId];
        if(opp != null){
         if(opp.LX_In_Approval_Process_Quick_Bid__c)
            OnsubmitQuckBidopPnlSelectedDistributor = true;
        }
        
        savedDistributorWrapperList = new List<accountWrapper>();        
        for (LX_Opportunity_Parties__c op:[Select id, Name, LX_Account__c, LX_Account_Name__c, LX_Account_Street__c, LX_Account_City__c,LX_Account_State__c, LX_Account_Postal_Code__c, LX_Account_Country__c,LX_Account_Duns_Number__c, LX_Account_Phone__c, LX_Account_Website__c, LX_Account_Text__c, LX_Account_Street_Text__c, LX_Account_City_Text__c, LX_Account_State_Text__c, LX_Account_Postal_Code_Text__c, LX_Account_Country_Text__c, LX_Account_Phone_Text__c, LX_Account_Website_Text__c from LX_Opportunity_Parties__c where LX_Opportunity__c =: oppId and LX_Opportunity_Party_Type__c = 'Distributor'])
        {
            accountWrapper aw = new accountWrapper ();
            aw.AccountId = op.Id;
            aw.AccountName = op.LX_Account_Name__c;
            aw.AccountStreet = op.LX_Account_Street__c;
            aw.AccountCity = op.LX_Account_City__c ;
            aw.AccountState = op.LX_Account_State__c ;
            aw.AccountPostalCode = op.LX_Account_Postal_Code__c ;
            aw.AccountCountry = op.LX_Account_Country__c ;
            savedDistributorWrapperList.add(aw);                         
        }
        
        if (savedDistributorWrapperList.size()>0) { 
        if(OnsubmitQuckBidopPnlSelectedDistributor){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LX_OnSubmitted_OppCustomer_Message));   
        }
        else{ 
        outputPanelSelectedDistributor = true ; 
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Only one Distributor can be selected. Please delete the current selection before selecting the new Distributor'));  
        }
        mainPageBlockRender = false;
        filterPageBlockRendered = false;        
        }
        
        if (savedDistributorWrapperList.size()==0) {
            outputPanelSelectedDistributor = false ;
            currentSelectionRender = false ;
        }
        system.debug ('***savedDistributorWrapperList***'+savedDistributorWrapperList);
        
    }
// Delete Logic
    public void inlineDeleteLogic(){
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');
        List<LX_Opportunity_Parties__c> oppPartyListDistributor = [Select id from LX_Opportunity_Parties__c where LX_Opportunity__c=: oppIdVar and LX_Opportunity_Party_Type__c = 'Distributor'];        
        if(oppPartyListDistributor.size()>0){
            try{
                Database.delete(oppPartyListDistributor);
                savedDistributorWrapperList.clear();
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                LX_CommonUtilities.createExceptionLog(ex);
            }
        }
        System.debug('@@@ in Delete Logic');
        mainPageBlockRender = true;
        filterPageBlockRendered = true;
        outputPanelSelectedDistributor = false;     
    }


// Filter Logic on Click of Search Button    
    public void getDynamicDistributorFilter (){
    
    String strFilter = ''; 

// Get the Opportunity Account's Country
        List<Opportunity> OpptyList = new List<Opportunity> ();
        OpptyList = [Select Id, accountId,account.BillingCountry from Opportunity where id=: OppId];
        String physicalCountry = OpptyList[0].account.BillingCountry ;
/*    
// Get the Sales Org of the Opportunitie's Account. 
        List<Opportunity> alist;
        List<LX_SAP_Record__c> sapRecList ;
        List <LX_SAP_Record_Sales_Org__c> sapSlsOrgList ;

        if (OppId != null || OppId != '')       
            alist = [Select Id, accountId,account.MDM_Account_Number__c from Opportunity where id=: OppId];
        if (alist.size()>0)
            sapRecList = [Select Id,LX_MDM_Act__c from LX_SAP_Record__c where LX_MDM_Act__c =:alist[0].account.MDM_Account_Number__c];
        if (sapRecList.size()>0)
            sapSlsOrgList = [Select Id,LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c =:sapRecList[0].Id];

// Create a set of All MDM Account #s with the same Sales Org  as the Opportunitie's Account. 
        Set<String> sapSalesOrgSet ;
        Set<String> sapRecSet ;      
        if (sapSlsOrgList.size()>0) {      
            sapSalesOrgSet = new Set<String>();
            for (LX_SAP_Record_Sales_Org__c s:[Select Id,LX_Sold_To__c from LX_SAP_Record_Sales_Org__c where LX_Sales_Org1__c=:sapSlsOrgList[0].LX_Sales_Org1__c])
                    sapSalesOrgSet.add(s.LX_Sold_To__c);
            }
        if (sapSalesOrgSet.size()>0) {           
           sapRecSet = new Set<String>();
            for (LX_SAP_Record__c s: [Select Id,LX_MDM_Act__c from LX_SAP_Record__c where Id=: sapSalesOrgSet ])
                    sapRecSet.add(s.LX_MDM_Act__c);
            }
        
        system.debug ('***alist***'+alist);
        system.debug ('***sapRecList***'+sapRecList);
        system.debug ('***sapSlsOrgList***'+sapSlsOrgList);
        system.debug ('***sapSalesOrgSet***'+sapSalesOrgSet);
        system.debug  ('***sapRecSet***'+sapRecSet);
*/
        
        system.debug ('***cityFilter***'+cityFilter);

// Default Query for Party Role = Distributor                         
        List<Account> accList ;
//        String query = 'Select Id,MDM_Account_Number__c,Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account Where Party_Role__c = \'Distributor\' AND Type = \'Partner\' AND Physical_Country__c like\'%'+physicalCountry+'%\'  ';
          String query = 'Select Id,MDM_ID__c,MDM_Account_Number__c,Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account Where (MDM_Account_Number__c != null or MDM_ID__c != null)and Party_Role__c = \'Distributor\' AND Type = \'Partner\' AND Physical_Country__c like\'%'+physicalCountry+'%\'  ';

// Update Query as per City Filter
        if (cityFilter != null && cityFilter != '')          
               strFilter = ' AND BillingCity like\'%'+cityFilter+'%\'';    
                                    
// Exceute Query
        try {
            system.debug('***Query***'+query+strFilter+' order by Name');
            accList = Database.query(query+strFilter+' order by Name');}
        catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);}        

// Query the SAP Records for the matching MDM Account # & matching MDM Id
    Set<String> sapRecSet = new Set<String>();
    Set<String> sapRecSetControl = new Set<String>();
    for (Account a:accList){
        sapRecSet.add(a.MDM_Account_Number__c);
        sapRecSet.add(a.MDM_ID__c);
    }

    List<LX_SAP_Record__c> sapRecList = new List<LX_SAP_Record__c> ();
    if (sapRecSet.size()>0)
        sapRecList = [Select Id,LX_MDM_Act__c,LX_MDM_ID__c from LX_SAP_Record__c where (LX_MDM_Act__c =:sapRecSet or LX_MDM_ID__c=:sapRecSet)and recordtype.name='Sold To' and LX_Status__c ='Active'];

    for(LX_SAP_Record__c sap:sapRecList){
        sapRecSetControl.add(sap.LX_MDM_ID__c);
        sapRecSetControl.add(sap.LX_MDM_Act__c);        
        }
    
// Setting Account Wrapper List to display the Search Results on the VF Page.     
    accountWrapperList = new List<accountWrapper>();
    if (accList.size()>0){
    for (Account a:accList){
// Only add the Account to the Account Wrapper List it contains a valid Sold To.  
      if (sapRecSetControl.contains(a.MDM_Account_Number__c) || sapRecSetControl.contains(a.MDM_ID__c)){ 
        accountWrapper aw = new accountWrapper ();
        aw.AccountId = a.Id;
        aw.AccountName = a.Name;
        aw.AccountStreet = a.BillingStreet;
        aw.AccountCity = a.BillingCity ;
        aw.AccountState = a.BillingState ;
        aw.AccountPostalCode = a.BillingPostalCode ;
        aw.AccountCountry = a.BillingCountry ;
        accountWrapperList.add(aw);
        }
    }          
 }        
// Check if No Distributor is Returned from the Query. 
    if(accountWrapperList.size()== 0){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No distributor in your Sales Org Or No distributor match the search criteria')); 
//       return null;
    } 
}

// Cancel Button Logic
    public PageReference cancelLogic(){
        PageReference PageRef  = new PageReference ('/'+oppId);
        return PageRef ;
    }

// Save Button Logic 
    public PageReference saveLogic (){
    List <LX_Opportunity_Parties__c> partyList = new List <LX_Opportunity_Parties__c>();
    Set <String> accountIds = new Set<String>();
    for (accountWrapper accWrap:accountWrapperList){
// List of all the Accounts with Checkbox Selected 
        if (accWrap.selected == true){            
            accountIds.add(accWrap.AccountId);
        }
    }

    
// Check if No Distributor is Selected. 
    if(accountIds.size()==0 && accountWrapperList.size()>0){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No distributor selected. Please select a Distributor before save.')); 
       return null;
    }

// Check if more than one Distributor is Selected.     
    if(accountIds.size()>1){
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Multiple distributors selected. Please select only one Distributor before save.')); 
    return null;
    }
    
// Creating Opportunity Party Record from the Distributor Accounts Selected.      
    List<Account> aList   ;  
    if (accountIds.size()>0) {
        aList = [Select Id,MDM_ID__c,MDM_Account_Number__c,Physical_Country__c from Account where Id in : accountIds];   
        for (Account a:aList){
           LX_Opportunity_Parties__c oppParty = new LX_Opportunity_Parties__c ();
           oppParty.LX_Account__c = a.Id;
           oppParty.LX_Opportunity__c = oppId ;
           oppParty.LX_Opportunity_Party_Type__c = 'Distributor';
           oppParty.LX_Product_Line_Items__c = 'Printers;Options';
           oppParty.LX_Purchasing_Method__c = 'Direct';
           oppParty.LX_Timing_of_Discount__c = 'Back-end';
           oppParty.LX_Claiming_Party__c = 'None';
           oppParty.LX_Ship_Debit__c = 'None';
           
           
        List <LX_SAP_Record__c> sapRecordList = new List<LX_SAP_Record__c> () ;
        List <LX_SAP_Record__c> sapRecordMDMIDList = new List<LX_SAP_Record__c>() ;
        if (a.MDM_Account_Number__c != null){ 
        sapRecordList = [Select Id,LX_MDM_Act__c,LX_MDM_ID__c, Name from LX_SAP_Record__c where LX_MDM_Act__c =:a.MDM_Account_Number__c and recordtype.name='Sold To' and LX_Status__c ='Active'];
        sapRecordMDMIDList = [Select Id,LX_MDM_Act__c,LX_MDM_ID__c, Name from LX_SAP_Record__c where LX_MDM_ID__c =:a.MDM_ID__c and recordtype.name='Sold To' and LX_Status__c ='Active'];
        }
        
        List <LX_SAP_Record_Sales_Org__c> soldToSalesOrgList = new List<LX_SAP_Record_Sales_Org__c>();
        if (sapRecordList.size()>0)
            soldToSalesOrgList = [Select Id,Name,Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c =:sapRecordList[0].Id and LX_Status__c ='Active' ];
        
        List <LX_SAP_Record_Sales_Org__c> mdmidSalesOrgList =new List<LX_SAP_Record_Sales_Org__c>();
        if (sapRecordMDMIDList.size()>0)
            mdmidSalesOrgList = [Select Id,Name,Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c =:sapRecordMDMIDList[0].Id and LX_Status__c ='Active' ];
        
       system.debug('**sapRecordList**'+sapRecordList+'**soldToSalesOrgList**'+soldToSalesOrgList+'**sapRecordMDMIDList**'+sapRecordMDMIDList+'**mdmidSalesOrgList**'+mdmidSalesOrgList);
        if (sapRecordList.size()>0 )
            oppParty.LX_Sold_To__c =  sapRecordList[0].Id;
        if (sapRecordMDMIDList.size()>0 && sapRecordList.size() ==0 )
            oppParty.LX_Sold_To__c = sapRecordMDMIDList[0].Id;
        if (soldToSalesOrgList.size()>0 )
            oppParty.LX_Account_Sales_Organization__c = soldToSalesOrgList[0].Id;    
        if (mdmidSalesOrgList.size()>0 && soldToSalesOrgList.size()==0  )
            oppParty.LX_Account_Sales_Organization__c = mdmidSalesOrgList[0].Id;    
 
                  
           partyList.add(oppParty); 
        }
    }            
    try {
          if (partyList.size()>0)  insert partyList;
        }
    catch(Exception ex){
        LX_CommonUtilities.createExceptionLog(ex);} 

// On Save return the Control back to the Opportunity.      
    PageReference PageRef  = new PageReference ('/'+oppId);
    return PageRef ;
            
    }

// Wrapper/Container Class to get the selection and set the output on the VF Page. 
    public class accountWrapper {
        public boolean selected{get;set;}
        public string AccountId{get;set;}
        public string AccountName{get;set;}
        public string AccountStreet{get;set;}
        public string AccountCity{get;set;}
        public string AccountState{get;set;}
        public string AccountPostalCode{get;set;}
        public string AccountCountry{get;set;}
    }
}