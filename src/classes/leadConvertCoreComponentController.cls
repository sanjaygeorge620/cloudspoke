/* Class Name   : ComponentControllerBase
    * Description :  This is the controller for the leadConvertCoreComponent
    * Created By   : Sanjay George
    * Created Date : 26-06-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sanjay George            30-06-2014               1001                Initial Version
    */

  

  /*
    
*/
    public with sharing class leadConvertCoreComponentController extends ComponentControllerBase {
       public enum QueryCondition {LeadName, LeadDUNS, LeadGlobalDuns, LeadHQDuns}
       private final static selectoption SelectSalestypeDefault = new selectOption('New Project','New Project');
       private final static selectoption SelectSalestypeNone = new selectOption('None','None');
       public string SelectedAccName{get;set;}
       private final static Set<String> setUSCountries = new Set<String>{'US','United States','USA'};
       public  integer PARAM_QUERY_SIZE {get{return 100;}set;}
       public string SalesCurrency{set;get;}
       private List<Recordtype> RecordtypeList;
       public List<leadConvertController.AccountWrapper> AccWrapperList{get;set;}
       public List<leadConvertController.AccountWrapper> AccCreateWrapperList{get;set;}
       
       public Integer salesTypeIdentifier{get;set;}
       
       public  boolean IfCustomer{set;get{
        if(AccRtTypeName!=null && AccRtTypeName ==LX_SetRecordIDs.L5LocationCustomerAccountRecordId )
                   IfCustomer = true;
               else{
                    IfCustomer = false;
                    //leadConvert.LX_Do_you_need_to_create_an_opportunity__c = 'No';
                   }
               
               return IfCustomer;
       }}
        // Product Type Selected Value
        public string ProductTypeSelected{get;set;} 
        public boolean Technology{get{System.debug('@@@@ImTechnology'+Technology);return Technology;}set;} 
        public boolean SoftwareSoln{get{System.debug('@@@@ImSoftwareSoln'+SoftwareSoln);return SoftwareSoln;}set;}  
        public boolean MPS{get{System.debug('@@@@ImMPS'+MPS);return MPS;}set;}
       
       // Map storing all the possible listoptions for the Product type and Sales Type Relationship
       
        private Map<string, Set<String>> MapProductTypeSalesTypeOptions;
        private Set<String> ProductTypeSet;
        public string AccRtTypeName{get;set;}
        public List<SelectOption> ProductTypeOptions{get{
           if(ProductTypeOptions==null){
                ProductTypeOptions= new  List<SelectOption> ();
                for(string opt: ProductTypeSet){
                    if(opt!=null)
                        ProductTypeOptions.add(new selectoption(opt,opt));
                }
                
            }
            return ProductTypeOptions;
        
        }set;}
    public list<SelectOption> SalesTypeOptions{get{
      if(SalesTypeOptions==null){
        SalesTypeOptions = new list<SelectOption>();
        SalesTypeOptions.add(new selectOption('None','None'));
      }
        
      
      return SalesTypeOptions ;
      
        
    
    }set;}
   
     // Sales Type Selected Value
    public string SalesTypeSelected{get;set;}          
    // prefix for the label of existing accounts
    private final string EXISTING = 'Attach to existing: ';
    private String AccRecordTypeID;
    // checkbox on the component indicating if there will be an email sent to the owner 
    public boolean sendOwnerEmail {get; set;}
    
    // This will hold the Opportunity for the Opportunity name on the comonent 
    public Opportunity opportunityID {get; set;}
    
    // Checkbox on the component indicating if an Opportunity should be created
    public Boolean CreateOppty{get{
    if(leadConvert.LX_Do_you_need_to_create_an_opportunity__c=='Yes')
        return true;
    else 
        return false;
    } 
    set;}
    //public Boolean doNotCreateOppty  {get;set;}
    
    // This will hold the owner of Lead
    public Contact contactID {
        get {
            if (contactId == null) {
            string leadConvert_ownerId = leadConvert.ownerId;
                if(leadConvert_ownerId.startswith('005'))
                    contactID = new Contact(OwnerId = leadConvert_ownerId );
                else
                    contactID = new Contact();
            }
            return contactId;
        }
        set;
    }
    
    //THis is set by the <apex:attribute> and is the lead to convert
    public Lead leadConvert {
        get; 
        set {
            //the first time this is set, the select list of Accounts will be populated 
            if (accounts == null) {
                system.debug('leadConvert set to ' + value);
                
                leadConvert = value;
                
                //populate the Account dropdown based on the lead
                populateAccounts(); 
                
            }
        }
    }
    
    // the list of accounts in the select list
    public List<SelectOption> accounts {get; set;}
    
    // the selected account in the select list of accounts
    public string selectedAccount {get; set;}
    
    //Constructor
    public leadConvertCoreComponentController() {
        AccCreateWrapperList = new List<leadConvertController.AccountWrapper> ();
        AccWrapperList = new List<leadConvertController.AccountWrapper> ();
        sendOwnerEmail=true;
        
        Technology=false; SoftwareSoln=false; MPS=false;
        System.debug('@@@TechnologySoftwareSolnMPS' + Technology +SoftwareSoln + MPS);
        // create a new Opportunity which will hold the Opportuniy name set by the user
        opportunityId = new Opportunity();
        MapProductTypeSalesTypeOptions = new Map<string, Set<String>>();
        // set the selected Account to NONE by default
        selectedAccount = 'NONE';
        
        List<LX_Opp_RecordType__c> OppRecordTypeList= LX_Opp_RecordType__c.getall().values();
        Set<String> TempOptions;
        
        for(LX_Opp_RecordType__c opprec: OppRecordTypeList){
        /*  ProductTypeSet = new Set<String>();
            if(opprec.LX_Product_Type__c!=null&&opprec.LX_Product_Type__c.contains(';')){
                
                ProductTypeSet.addall(opprec.LX_Product_Type__c.split(';'));
            }
            else if(opprec.LX_Product_Type__c!=null){
                ProductTypeSet.add(opprec.LX_Product_Type__c);
            }
                        system.debug('ProductTypeSet-->'+(ProductTypeSet));*/
            System.debug('@@@oppRec.LX_Product_Type__c' + opprec.LX_Product_Type__c + opprec.LX_Sales_Type__c);
            if(opprec.LX_Product_Type__c!=null&&opprec.LX_Product_Type__c!=''&&opprec.LX_Sales_Type__c!=null&&opprec.LX_Sales_Type__c!=''&&MapProductTypeSalesTypeOptions.containskey(opprec.LX_Product_Type__c)){
                TempOptions = MapProductTypeSalesTypeOptions.get(opprec.LX_Product_Type__c);
                
              //  TempOptions.add(new selectoption(opprec.LX_Sales_Type__c,opprec.LX_Sales_Type__c));
                TempOptions.add(opprec.LX_Sales_Type__c);
                System.debug('@@@TempOptions1' + TempOptions.size() + TempOptions);
                MapProductTypeSalesTypeOptions.put(opprec.LX_Product_Type__c,TempOptions);
            }
            else if(opprec.LX_Product_Type__c!=null &&opprec.LX_Sales_Type__c!=null ){
                TempOptions = new Set<String>();
                //TempOptions.add(new selectoption(opprec.LX_Sales_Type__c,opprec.LX_Sales_Type__c));
                TempOptions.add(opprec.LX_Sales_Type__c);
                System.debug('@@@TempOptions2' + TempOptions.size() + TempOptions);
                MapProductTypeSalesTypeOptions.put(opprec.LX_Product_Type__c,TempOptions);
            }
           
        
        }
         
    }
    
    /*
    Function to Reset the Sales Type Value
    */
    
    public void ResetSalesType(){
      //   SalesTypeSelected=SelectSalestypeNone.getValue();
      system.debug('TEech+ MPS+ Software Solution--->'+LeadConvert.Technology__c+LeadConvert.MPS__c+LeadConvert.Software_Solutions__c);
        String Selected ='';
        if(leadConvert.MPS__c){
            System.debug('@@@MPS2');
            Selected ='MPS';     
        }
        if(leadConvert.Software_Solutions__c){
            if(Selected ==''){
                System.debug('@@@SoftwareSoln1');
                Selected ='Software Solutions';
            }
            else{
                System.debug('@@@SoftwareSoln2');
                 Selected +=';Software Solutions';
            }
            
        }
        if(leadConvert.Technology__c){
            if(Selected ==''){
                System.debug('@@@Technology1');
                Selected ='Technology';
            }
            else{
                System.debug('@@@Technology2');
                 Selected +=';Technology';
            }
           
        }
           
      system.debug('Selected-->'+Selected+'MapProductTypeSalesTypeOptions.keyset()'+MapProductTypeSalesTypeOptions.keyset()+MapProductTypeSalesTypeOptions.get(Selected ));
      SalesTypeOptions.clear();  
      SalesTypeSelected='';
      if(Selected !=''&&MapProductTypeSalesTypeOptions.containskey(Selected )&&MapProductTypeSalesTypeOptions.get(Selected )!=null){
            system.debug('MapProductTypeSalesTypeOptions>>>'+MapProductTypeSalesTypeOptions);
            Set<String> TempList = MapProductTypeSalesTypeOptions.get(Selected);
            List<SelectOption> lstSalesTypeOptions;
            system.debug('TempList>>>'+TempList);
            if(TempList.contains(SelectSalestypeDefault.getValue())){
                //SalesTypeOptions.add(SelectSalestypeDefault );
                //TempList.remove(SelectSalestypeDefault.getValue());
                lstSalesTypeOptions = new List<SelectOption>();        
                for(String str: TempList){
                    SelectOption salesTypeOptionVar = new SelectOption(str,str);
                    lstSalesTypeOptions.add(salesTypeOptionVar);
                }
                SalesTypeOptions.addall(lstSalesTypeOptions);
                SalesTypeSelected=SelectSalestypeDefault.getValue() ;
            }
            else{
                SalesTypeOptions.add(SelectSalestypeNone );
                lstSalesTypeOptions = new List<SelectOption>();
                for(String str: TempList){
                    SelectOption salesTypeOptionVar = new SelectOption(str,str);
                    lstSalesTypeOptions.add(salesTypeOptionVar);
                }
                SalesTypeOptions.addall(lstSalesTypeOptions);
                boolean flag1= false;
                for(SelectOption so: SalesTypeOptions){
                    if(so.getValue()==SalesTypeSelected){
                        flag1=true;
                    }
                }
                if(!flag1)
                    SalesTypeSelected = SelectSalestypeNone.getValue();
                
            }
            
      }
      else{
          
          SalesTypeOptions.add(SelectSalestypeNone);
         // SalesTypeSelected=SelectSalestypeNone.getValue();
      }
    }
    
    // Find an Account using SOSL based on the given company name
    private Account [] findCompany (string SearchValue,leadConvertCoreComponentController.QueryCondition  QueryType) {
         String AccRtTypeName;
         List <Account> accountsFound = new List<Account>();
        system.debug('recordtypeName==>'+leadConvert);
        if(leadConvert!=null&&leadConvert.Recordtype.developerName==Label.LX_Lead_Simple_Partner){
            AccRtTypeName = Label.LX_Account_Location_Partner;
        }
        else if(leadConvert!=null&&leadConvert.Recordtype.developerName==Label.LX_Lead_Simple_Customer){
            AccRtTypeName = Label.LX_Account_Location_Customer;
        }
        if(AccRtTypeName !=''&&AccRtTypeName !=null){
            RecordtypeList= [select id, name from Recordtype where developername = :AccRtTypeName and SObjectType='Account' limit 1];
            AccRecordTypeID = RecordtypeList[0].id;
        
           }
        //perform the SOSL query
        List<List<SObject>> searchList;
        system.debug('DUNS-->'+SearchValue);
        system.debug('----->'+QueryType+QueryCondition.LeadDUNS);
        if(QueryType==QueryCondition.LeadName){
        /*searchList = [
            FIND :SearchValue
            IN NAME FIELDS 
            RETURNING 
            Account(
                Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name,TR_Status__c,DunsNumber,Global_Ultimate_D_U_N_S__c, RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry  where RecordTypeid = :AccRecordTypeID
            )
        ];*/
        accountsFound  = [Select Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name,TR_Status__c,DunsNumber,Global_Ultimate_D_U_N_S__c, RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account where RecordTypeid = :AccRecordTypeID AND Name=:SearchValue];
        }
        
        else if(QueryType==QueryCondition.LeadDUNS&& SearchValue!=null&&SearchValue!='null*'){
        accountsFound  = [Select Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name,TR_Status__c,DunsNumber,Global_Ultimate_D_U_N_S__c, RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account where RecordTypeid = :AccRecordTypeID AND DunsNumber =:SearchValue];
      /*  searchList = [ 
            FIND :SearchValue
            IN DunsNumber FIELDS 
            RETURNING 
            Account(
                Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name, RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry  where RecordTypeid = :AccRecordTypeID
            )
        ];
        system.debug(searchList );       */ 
        }
        else if (QueryType==QueryCondition.LeadGlobalDuns&&SearchValue!=null && SearchValue!='null*'){
          accountsFound =[select Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name,TR_Status__c,DunsNumber,Global_Ultimate_D_U_N_S__c, RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account  where Global_Ultimate_D_U_N_S__c =:SearchValue AND RecordTypeid = :AccRecordTypeID and TR_Status__c='On' AND Physical_Country__c=:leadConvert.Physical_Country__c];
         /* searchList = [
            FIND :SearchValue
            IN Global_Ultimate_D_U_N_S__c FIELDS 
            RETURNING 
            Account(
                Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name, TR_Status__c,RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry  where Global_Ultimate_D_U_N_S__c =:SearchValue AND RecordTypeid = :AccRecordTypeID and TR_Status__c='On'
            )
        ];  */
        }
        else if(QueryType==QueryCondition.LeadHQDuns&&SearchValue!=null && SearchValue!='null*'){
          accountsFound =[select Id, 
                Name,Party_Role__c,Party_Type__c,owner.Name,TR_Status__c,DunsNumber,Global_Ultimate_D_U_N_S__c, RecordType.Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account  where DunsNumber =:SearchValue AND RecordTypeid = :AccRecordTypeID and TR_Status__c='On' AND Physical_Country__c=:leadConvert.Physical_Country__c];
   
        }
        
        
        if(searchList!=null){
        accountsFound = new List<Account>();
        for (List <sobject> sObjs : searchList) {
            
            for (sObject s : sObjs) {
                
                //add the account that was found to the list of found accounts
                accountsFound.add((Account) s);
            }   
        }
        }
        // return the list of found accounts
        return accountsFound;
    }
    
   
    
    //populate the list of Accounts in the dropdown
    private void populateAccounts() {

         String AccRtTypeName;
        system.debug('recordtypeName==>'+leadConvert);
        if(leadConvert!=null&&leadConvert.Recordtype.developerName==Label.LX_Lead_Simple_Partner){
            AccRtTypeName = Label.LX_Account_Location_Partner;
        }
        else if(leadConvert!=null&&leadConvert.Recordtype.developerName==Label.LX_Lead_Simple_Customer){
            AccRtTypeName = Label.LX_Account_Location_Customer;
        }
        if(AccRtTypeName !=''&&AccRtTypeName !=null){
            RecordtypeList= [select id, name from Recordtype where developername = :AccRtTypeName and SObjectType='Account' limit 1];
            }
        if (leadConvert != null) {
            boolean createnewAccount = false;
            Account [] accountsFound;
            string company = leadConvert.Company;
            
            if(leadConvert.RecordType.developerName == Label.LX_Lead_Simple_Partner){
                if(leadConvert.Was_Datacom_Used__c==true)
                    accountsFound = findCompany(company + '%',QueryCondition.LeadName);
                    createnewAccount = true;
            }
            else { 
                if(leadConvert.Was_Datacom_Used__c==true){
                    accountsFound = findCompany(leadConvert.D_U_N_S_Number__c,QueryCondition.LeadDUNS);//D_U_N_S_Number__c
                    if(accountsFound.size()==0)
                        accountsFound = findCompany(leadConvert.GlobalDunsNumber__c,QueryCondition.LeadGlobalDuns);
                    if(accountsFound.size()==0)
                      accountsFound = findCompany(leadConvert.ParentOrHqDunsNumber__c,QueryCondition.LeadHQDuns);
                    if(leadConvert.TR_Status__c!='On'&&accountsFound.size()==0){
                        createnewAccount = true;
                    }
                    
                }
                
                
            }
            if(LX_CreditAppLead_Utility.GlobalDataAdmin(UserInfo.getUserId(),UserInfo.getProfileId() )){
                system.debug('System admin access');
                accountsFound = findCompany(company + '*',QueryCondition.LeadName);
                createnewAccount = true;
            }
            
            
            // find any accounts that match the SOSL query in the findCompany() method  
            //accountsFound = findCompany(company + '*',1);
            
            accounts = new List<selectOption>();
             // if there is at least 1 account found add a NONE option and a Create New Account option
      //       String PhysicalAddress;
          boolean selectedacc = false;
            if(createnewAccount == true){
                accounts.add(new SelectOption('NONE', '-None-'));
                
                accounts.add(new SelectOption('NEW',  company ));
            //    PhysicalAddress = +'\n'+ +'\n'++'\n'+leadConvert.Country+'\n';
                //selectedacc =(selectedaccount!=null&&selectedaccount=='NEW')?true:false;
                system.debug(RecordtypeList[0].Name);
                
                AccCreateWrapperList.add(new leadConvertController.AccountWrapper(company,leadConvert.Street,leadConvert.City,leadConvert.State,leadConvert.Country,leadConvert.TR_Status__c,
                                                                            leadConvert.LX_Party_Role__c,leadConvert.LX_Party_Type__c,leadConvert.LX_Account_Owner__r.Name , 
                                                                            selectedacc ,'NEW',leadConvert.D_U_N_S_Number__c,leadConvert.GlobalDunsNumber__c));
            }
            if (accountsFound != null && accountsFound.size() > 0) {
                
               
                // for each account found, add an option to attach to the existing account
                for (Account a : accountsFound) {
                  //  PhysicalAddress = +'\n'+a.BillingCity+'\n'+a.BillingState+'\n'+a.BillingPostalCode+'\n'+a.BillingCountry;
                    //selectedacc =(selectedaccount!=null&&selectedaccount==a.id)?true:false;
                    accounts.add(new SelectOption(a.Id, EXISTING + a.Name));
                     AccWrapperList.add(new leadConvertController.AccountWrapper(a.Name,a.BillingStreet,a.BillingCity,a.BillingState,a.BillingCountry,a.TR_Status__c,
                                                                            a.Party_Role__c,a.Party_Type__c,a.owner.Name , 
                                                                            selectedacc ,a.id,a.DunsNumber,a.Global_Ultimate_D_U_N_S__c));
                }
                
            }
            
            
            
            //the default opportunity name will be the lead's company
            opportunityId.Name = company + '-';
        }
        
        else system.debug('leadConvert = null');
            
    }
    
    // when the selected account in the select list of accounts changes this method is called 
    public PageReference accountChanged() {
    system.debug('-----> '+leadConvert.LX_expected_to_close_within_5_days__c);
        resetCheck();
        // if either the NONE option or the Create New Account option is selected, the Opportuniy Name is set to the lead's company
        if (selectedAccount == 'NEW' || selectedAccount == 'NONE') {
            opportunityId.Name = leadConvert.Company  + '-';
            
        }

        else {
            // otherwise find the account's Id and Name that was selected and set the Opportuity name to that Account
            Account [] a = [
                SELECT Id, Name 
                FROM Account WHERE Id = :selectedAccount and RecordTypeid = :AccRecordTypeID];
            
            if (a.size() > 0) {
                opportunityId.Name = a[0].Name + '-';
            }
            
        }
        return null;
    }
    
    //this gets called when an existing accout gets looked up via the lookup magnifying glass
    public PageReference accountLookedUp() {
        system.debug('!!! Account looked up --> ' + contactId.AccountId );
        
        //find the Id and Nmae of the Account that was looked up        
        Account [] a = [
            SELECT Id, Name 
            FROM Account WHERE Id = :contactId.AccountId];
        
        if (a.size() > 0) {
            
            // add the locked up account to the slect list
            accounts.add(new SelectOption(a[0].Id, EXISTING + a[0].Name));
            
            // set the selected account to the one that was just looked up by default
            selectedAccount = a[0].Id;
            
            // set the Opportunity name to the account's name that was looked up
            opportunityId.Name = a[0].Name + '-';
            
            system.debug('accounts --> ' + accounts);
        }
        
        return null;
    }
    
    // set up the Lead Status pick list
    public List<SelectOption> LeadStatusOption {
        
        get {
            
            
            if(LeadStatusOption == null) {
                
                LeadStatusOption = new List<SelectOption>();
                
                //get the lead statuses
                LeadStatus [] ls = [select MasterLabel from LeadStatus where IsConverted=true order by SortOrder];
                
                // if there is more than 1 lead status option, add a NONE option  
                if (ls.size() > 1) {
                    LeadStatusOption.add(new SelectOption('NONE', '-None'));
                }
                
                // add the rest of the lead status options
                for (LeadStatus convertStatus : ls){
                    LeadStatusOption.add(new SelectOption(convertStatus.MasterLabel, convertStatus.MasterLabel));
                } 
                
            }
            
            return LeadStatusOption;
        }
        set;
    }
    public List<selectOption> getSalesOrgSelectOptions(){

                
                List<selectOption> SessionCurrencyValues = new List<SelectOption>();
                
                system.debug('User.salesRegion_quote__c == '+leadConvert.Physical_Country__c);
                List<Sales_Organization__c> lstSalesOrg = null;
                User Usr = [select id,LX_Country__c, LX_Region__c from user where id =:Userinfo.getUserId() limit 1 ];
                String Region ='%'+ Usr.LX_Country__c+'%';
                //If selected country is "US" then we have to select sales org record which has Sales Org value as "5050"
                if(setUSCountries.contains(Usr.LX_Country__c))
                {
                                lstSalesOrg = [select id,LX_IsDefault__c,Name from Sales_Organization__c where   
                                Name  in :setUSCountries and LX_IsDefault__c = true and Sales_Organization__c =: Label.lx_Sales_Org and Status__c='Active'];
                }
                else
                {
                                lstSalesOrg = [select id,LX_IsDefault__c,Name from Sales_Organization__c where 
                                Name  like :Region  and LX_IsDefault__c =true and Status__c ='Active'];
                                if(lstSalesOrg==null){
                                    Region ='%'+ Usr.LX_Region__c +'%';
                                    lstSalesOrg = [select id,LX_IsDefault__c,Name from Sales_Organization__c where 
                                    Name  like :Region  and LX_IsDefault__c =true and Status__c ='Active'];
                                }
                }
                
                
                  //system.debug('LX_IsDefault__c== '+LX_IsDefault__c);                                                
                                system.debug('lstSalesOrg=='+ lstSalesOrg);
                                
                                Sales_Organization__c objSalesOrg = ((lstSalesOrg == null || lstSalesOrg.size() <= 0) ? null : lstSalesOrg[0]);
                                system.debug('objSalesOrg == '+objSalesOrg);                        
                                if(objSalesOrg != null)
                                {
                                                for(Sales_Org_Currency__c obj : [select id,name,Currency_Name__r.Name from Sales_Org_Currency__c where Sales_Organization__c =: objSalesOrg.Id])
                                                {
                                                                system.debug('obj == '+obj);
                                                                //if(m_SessionCurrency == null) m_SessionCurrency = obj.Currency_Name__r.Name;
                                                                SessionCurrencyValues.add(new Selectoption(obj.Currency_Name__r.Name,obj.Currency_Name__r.Name));
                                                }
                                                system.debug('SessionCurrencyValues == '+SessionCurrencyValues);
                                }
                                
                                else {
                                    Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Unexpected error has occured. Please try again later.'));
                                }
                               
                               SessionCurrencyValues.add(new Selectoption('--Other Currencies--','--Other Currencies--')) ;
                               if(Schema.getGlobalDescribe().get('CurrencyType')!=null){      
                                List<CurrencyType> CurrencyList= [SELECT ISOCode FROM CurrencyType WHERE IsActive=TRUE];
                               
                               
                                for(CurrencyType cntry: CurrencyList){
                                    SessionCurrencyValues.add(new Selectoption(cntry.IsoCode,cntry.IsoCode) );
                                }
                                }
                              //  SessionCurrencyValues.add
                return SessionCurrencyValues;

}

    public void resetCheck(){
        for(LeadConvertController.AccountWrapper Acc:AccWrapperList){
            if(Acc.selectedAccountName!=selectedAccount)
                Acc.SelectAccount = false;
            else
                Acc.SelectAccount = true;
            
            system.debug('Name-->'+Acc.selectedAccountName+'-->'+selectedAccount);
           
        
        }
        for(LeadConvertController.AccountWrapper Acc: AccCreateWrapperList ){
            if(Acc.selectedAccountName!=selectedAccount)
                Acc.SelectAccount = false;
            else
                Acc.SelectAccount = true;
            
            system.debug('Name-->'+Acc.selectedAccountName+'-->'+selectedAccount);
           
        
        }
        
    }
    
}