/* Class Name   : leadConvertController 
    * Description   : This is a main class for Custom LEad Convert Page
    * Created By   : Sanjay George
    * Created Date : 08-06-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sanjay George          08-06-2014                     1000            Initial Version
    
    */

public with sharing class leadConvertController extends PageControllerBase {
    public String AccRecordTypeID {get;set;}
    private string AccRtTypeName ;
    public List<AccountWrapper> AccWrapperList{get{
        return MyComponentController.AccWrapperList;
    }set;}
    //public boolean isconver
    // This is the lead that is to be converted
    public  Lead leadToConvert {get; set;}
    public string OppSalesCurrency {set;get;}
    // Constructor for this controller
    public leadConvertController(ApexPages.StandardController stdController) {
              
        //get the ID to query for the Lead fields
        Id leadId = stdController.getId();
        AccWrapperList = new List<AccountWrapper>();
        leadToConvert = [SELECT Id,IsConverted,LX_Country_Code__c,city,street,ParentOrHqDunsNumber__c, state,country,TR_Status__c,D_U_N_S_Number__c,GlobalDunsNumber__c,Was_Datacom_Used__c,LX_Party_Type__c,LX_Party_Role__c,MPS__c,Software_Solutions__c,Technology__c,LX_Account_Owner__r.Name, LX_Account_Owner__c,LX_Sales_Organization__c,Business_Unit__c,Status,LX_Partner_buy_directly_from_Lexmark__c,LX_Payment_Terms__c,LX_Requested_Credit_Limit__c,CurrencyIsoCode, LX_Additional_Comments__c,LX_Do_you_need_to_create_an_opportunity__c,LX_Sales_Type__c, LX_expected_to_close_within_5_days__c,Physical_Country__c, OwnerId, Name, Company, Recordtype.developerName FROM Lead WHERE Id = :leadId];
        system.debug('-----> '+leadToConvert.LX_expected_to_close_within_5_days__c);
     /*   if(leadToConvert.IsConverted){
            PrintError('Lead already converted');
            //return null;
        }*/
        LeadToConvert.Status = 'Qualified';
        // Identfying the Record Types to do further query
         if(leadToConvert !=null&&leadToConvert.Recordtype.developerName==Label.LX_Lead_Simple_Partner){
            AccRtTypeName = Label.LX_Account_Location_Partner;
        }
        else if(leadToConvert !=null&&leadToConvert.Recordtype.developerName==Label.LX_Lead_Simple_Customer){
            AccRtTypeName = Label.LX_Account_Location_Customer;
        }
        if(AccRtTypeName !=''&&AccRtTypeName !=null)
            AccRecordTypeID = [select id from Recordtype where developername = :AccRtTypeName and SObjectType='Account' limit 1].id;
        
        // Quering Sales Org for the LEad based on the Lead Country
        List<Sales_Organization__c> DefSalesOrgList = [Select id,LX_Default__c from Sales_Organization__c where Status__c='Active' and LX_Country_Code__c=:leadToConvert.LX_Country_Code__c];
        if(DefSalesOrgList!=null&&DefSalesOrgList.size()>1){
            for(Sales_Organization__c SO: DefSalesOrgList ){
                if(SO.LX_Default__c )
                    leadToConvert.LX_Sales_Organization__c = SO.id;
                
            }
        }// Defaulting to the first one if many Org's identified.
        else if(DefSalesOrgList!=null){
            leadToConvert.LX_Sales_Organization__c = DefSalesOrgList[0].id;
        }
        
        
    }

    /*
    These are instances of the components' controllers which this class will access.
    
    If you add new custom components, add an instance of the class here
    */
    public leadConvertCoreComponentController myComponentController { get; set; }
    
    /*
        These are the set methods which override the methods in PageControllerBase. 
        These methods will be called by the ComponentControllerBase class.
        
        If you add new custom components, a new overridden set method must be added here.
    */
    public override void setComponentController(ComponentControllerBase compController) {
        
        myComponentController = (leadConvertCoreComponentController)compController;
        
    }
   
   

    /*
        These are the get methods which override the methods in PageControllerBase.
        
        If you add new custom components, a new overridden get method must be added here.
    */
    public override ComponentControllerBase getMyComponentController() {
      
        return myComponentController;

    }

  
    
    
    // This method is called when the user clicks the Convert button on the VF Page
    public PageReference convertLead() {
        
        
        
        system.debug('-----> '+leadToConvert.LX_expected_to_close_within_5_days__c);
        // This is the lead convert object that will convert the lead 
        Database.LeadConvert leadConvert = new database.LeadConvert();
        
        // if a due date is set but the subject is not, then show an error 
       
        
       
        
        //set lead ID
        leadConvert.setLeadId(leadToConvert.Id);    
        
        system.debug('-----> Before controller check'+leadToConvert.LX_expected_to_close_within_5_days__c + myComponentController);
        //if the main lead convert component is not set then return
        if (myComponentController == NULL) return null;
        
        //if the Account is not set, then show an error
        if (myComponentController.selectedAccount == 'NONE')
        {
            PrintError('Please select an Account.');
            return null;
            
        }
         if ( myComponentController.IfCustomer==false &&    (leadToConvert.LX_Partner_buy_directly_from_Lexmark__c==null&&leadToConvert.LX_Partner_buy_directly_from_Lexmark__c==''))
        {
            PrintError('Please select if the \'Partner buy Directly from Lexmark\'');
            return null;
            
        }
         if ( myComponentController.IfCustomer==false && leadToConvert.LX_Partner_buy_directly_from_Lexmark__c=='Yes' && (leadToConvert.LX_Requested_Credit_Limit__c==null))
        {
            PrintError('Please enter the \'Requested Credit Limit\'' );
            return null;
            
        }
        
         if ( ! String.valueof(leadToConvert.Ownerid).startswith('005'))
        {
            PrintError('Please make sure that the Lead Owner is a User.' );
            return null;
            
        }
        
       
        if (myComponentController.IfCustomer==true &&leadToConvert.LX_Do_you_need_to_create_an_opportunity__c =='Yes' && (myComponentController.SalesTypeSelected== ''||myComponentController.SalesTypeSelected==null||myComponentController.SalesTypeSelected=='None'))
        {
            PrintError('Please select a Sales Type.');
            return null;
            
        }
        if (myComponentController.IfCustomer==true &&leadToConvert.LX_Do_you_need_to_create_an_opportunity__c =='Yes' && (myComponentController.SalesCurrency== ''||myComponentController.SalesCurrency==null))
        {
            PrintError('Please select a Currency');
            return null;
            
        }
        
        if (myComponentController.IfCustomer==true &&leadToConvert.LX_Do_you_need_to_create_an_opportunity__c =='Yes' && (leadToConvert.Technology__c== false&&leadToConvert.Software_Solutions__c==false && leadToConvert.MPS__c== false))
        {
            PrintError('Please select Product Type');
            return null;
            
        }
        if (myComponentController.IfCustomer==true &&leadToConvert.LX_Do_you_need_to_create_an_opportunity__c =='Yes' && (myComponentController.leadConvert.LX_expected_to_close_within_5_days__c== null||myComponentController.leadConvert.LX_expected_to_close_within_5_days__c==''))
        {
            PrintError('Please mention \'Is this expected to close within 5 days\'');
            return null;
            
        }
        if (myComponentController.IfCustomer==true &&leadToConvert.LX_Do_you_need_to_create_an_opportunity__c =='Yes' && leadToConvert.LX_expected_to_close_within_5_days__c=='Yes' && (leadToConvert.LX_Payment_Terms__c== null||leadToConvert.LX_Payment_Terms__c==''))
        {
            PrintError('Please mention the Payment Term');
            return null;
            
        }
        
        // otherwise set the account id
        else if (myComponentController != NULL && myComponentController.selectedAccount != 'NEW') {
            leadConvert.setAccountId(myComponentController.selectedAccount);
        }
        OppSalesCurrency = myComponentController.SalesCurrency;
        
        //leadToConvert = myComponentController.leadToConvert;
        leadToConvert.CurrencyIsoCode = OppSalesCurrency;
        leadToConvert.LX_Sales_Type__c = myComponentController.SalesTypeSelected;
       // leadToConvert.Technology__c = myComponentController.Technology;
        //leadToConvert.Software_Solutions__c = myComponentController.SoftwareSoln;
        //leadToConvert.MPS__c = myComponentController.MPS;
        System.debug('LeadUpdate-->'+leadToConvert);
        try{
            update leadToConvert;
        }
        catch(exception ex){
            system.debug('Exception-->'+ex
            );
            String e = ex.getmessage();
            if(e.contains(','))
            {
            e = e.substring(e.lastIndexOf(',')+2, e.length());
            }
            PrintError(e);
           
        }
        //set the lead convert status
        leadConvert.setConvertedStatus(myComponentController.leadConvert.Status);
        
        //set the variable to create or not create an opportunity
        leadConvert.setDoNotCreateOpportunity(!myComponentController.CreateOppty);
        
        //set the Opportunity name
        leadConvert.setOpportunityName(((!myComponentController.CreateOppty) 
            ? null : myComponentController.opportunityID.Name));
        
        //set the owner id
        leadConvert.setOwnerId(myComponentController.contactId.ownerID);
        
        //set whether to have a notification email
        leadConvert.setSendNotificationEmail(myComponentController.sendOwnerEmail);
        
        system.debug('leadConvert --> ' + leadConvert);
        try{
        Savepoint sp = Database.setSavepoint();
        //convert the lead
        Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
       
           system.debug('Lead Result----->'+leadConvertResult.success);
        // if the lead converting was a success then create a task
        if (leadConvertResult.success)
        {   case cs;
            if(myComponentController != NULL && leadToConvert.LX_expected_to_close_within_5_days__c=='Yes'&&myComponentController.selectedAccount == 'NEW'){
                cs= LX_Lead_util.ConvertLeadCaseCreate(leadConvertResult,LeadtoConvert,true);
                try{
                insert cs;
                }Catch(DMLException e){
                    PrintError(e.getmessage());
                     Database.rollback(sp);
                }
            }
            else if((myComponentController != NULL &&myComponentController.selectedAccount == 'NEW')){
                cs= LX_Lead_util.ConvertLeadCaseCreate(leadConvertResult,LeadtoConvert,false);
                try{
                insert cs;
                }Catch(DMLException e){
                    PrintError(e.getmessage());
                     Database.rollback(sp);
                }
            }
            if(cs!=null&&cs.id!=null&&leadToConvert.LX_expected_to_close_within_5_days__c=='Yes')
                LX_CreditAppLead_Utility.SendCreditApp(cs.id,leadToConvert.LX_Account_Owner__c);
            
            // make sure that the task information component is being used and check to see if the user has filled out the Subject field 
            
            
            // redirect the user to the newly created Account
            PageReference pageRef = new PageReference('/' + leadConvertResult.getAccountId());
            
            pageRef.setRedirect(true);
            
            return pageRef; 
        }
        else
        {
            Database.rollback(sp);
            
            //if converting was unsucessful, print the errors to the pageMessages and return null
            System.Debug(leadConvertResult.errors+' '+leadConvertResult.getAccountId());

            PrintErrors(leadConvertResult.errors);
            
            return null;
        }
         
         }
        catch(DMLException e){
        system.debug('Exception-->'+e
        );
        String ex = e.getmessage();
        if(ex.contains(','))
        {
        ex = ex.substring(ex.lastIndexOf(',')+2, ex.length());
        }
        PrintError(ex);
        }
        return null;

    }
    
    //this method will take database errors and print them to teh PageMessages 
    public void PrintErrors(Database.Error[] errors)
    {
        for(Database.Error error : errors)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error.message);
            ApexPages.addMessage(msg);
        }
    }
    
    //This method will put an error into the PageMessages on the page
    public void PrintError(string error) {
        ApexPages.Message msg = new 
            ApexPages.Message(ApexPages.Severity.ERROR, error);
        ApexPages.addMessage(msg);
    } 
    
     // Transfering the Lead Owner Ship to GDA
    // If Error Throw it to the User
        public pagereference ChangeOwner(){
            
            if(!LX_CreditAppLead_Utility.ChangetoGDA(leadtoConvert.id)){
                PrintError('Couldn\'t Change the Ownership for the Lead. Please Contact System Administrator');
                return null;
            }
            Pagereference pg = new PageReference('/'+leadtoConvert.id);
            return pg;
            
        }
    
    // given a date and time, where time is a string this method will return a DateTime
    private DateTime convertToDatetime(Date d, string t) {
        String timeFormat = DateTimeUtility.LocaleToTimeFormatMap().get(UserInfo.getLocale());
        
        //if the local of the user uses AM/PM 
        if (timeFormat != null && timeFormat.endsWith('a')) {
            
            //split the time into 2 strings 1 time and 1 am r pm
            string [] reminderTime = t.split(' ');
            
            //split the time into hour and minute
            string hour = reminderTime[0].split(':')[0];
            string min = reminderTime[0].split(':')[1];
            
            //get the am or pm
            string AM_PM = reminderTime[1];
            
            //turn the hour into an integer
            integer hr = Integer.valueOf(hour);
            
            //if the am/pm part of the string is PM then add 12 hours
            if (AM_PM.equalsIgnoreCase('PM')) hr += 12;
            
            //return a new DateTime based on the above information
            return (
                DateTime.newInstance(
                    d, 
                    Time.newInstance(
                        hr, 
                        Integer.valueOf(min), 
                        0,
                        0
                    )
                )
            ); 
        }
        //If the user's local does not use AM/PM and uses 24 hour time
        else {
            
            //split the time by a : to get hour and minute
            string hour = t.split(':')[0];
            string min = t.split(':')[1];
            
            //turn the hour into an integer
            integer hr = Integer.valueOf(hour);
            
            //return a new DateTime based on the above information
            return (
                DateTime.newInstance(
                    d, 
                    Time.newInstance(
                        hr, 
                        Integer.valueOf(min), 
                        0,
                        0
                    )
                )
            ); 
        }
    }
    public Pagereference CheckConverrted(){
        if(leadToConvert.isConverted){
            Pagereference pg = new pagereference('/p/lead/ViewConvertedLead/d?id='+leadToConvert.id);
            return pg;
        }
        else 
        return null;
    }
    
    public class AccountWrapper{
        Public String AccountName{set;get;}
        public string PhysicalAddress{set;get;}
        public string BillingStreet{set;get;}
        public string BillingCity{set;get;}
        public string BillingState{set;get;}
        public string BillingCountry{set;get;}
                   
        public string RecordTypeName{set;get;}
        public string PartyRole{set;get;}
        public string PartyType{set;get;}
        public string OwnerName{set;get;}
        public boolean SelectAccount{set;get;}
        public boolean newselect{set;get;}
        public string selectedAccountName{set;get;}
        public string TRStatus{set;get;}
        public string LocationDuns{set;get;}
        Public string GlobalDUNS {set;get;}
        
        public AccountWrapper(string AccountName,string BillingStreet,string BillingCity,string BillingState,string BillingCountry,string TRStatus,string PartyRole,string PartyType,string OwnerName, boolean SelectAccount, string selectedAccountName){
            this.AccountName = AccountName;
            this.PhysicalAddress = PhysicalAddress;
            this.TRStatus= TRStatus;
            this.PartyRole = PartyRole;
            this.PartyType = PartyType;
            this.OwnerName = OwnerName;
            this.SelectAccount = SelectAccount;
            newselect= false;
            this.selectedAccountName = selectedAccountName;
        }
        public AccountWrapper(string AccountName,string BillingStreet,string BillingCity,string BillingState,string BillingCountry,string TRStatus,string PartyRole,string PartyType,string OwnerName, boolean SelectAccount, string selectedAccountName, string LocationDuns, string GlobalDUNS ){
            this.AccountName = AccountName;
            this.PhysicalAddress = PhysicalAddress;
            this.TRStatus= TRStatus;
            this.PartyRole = PartyRole;
            this.PartyType = PartyType;
            this.OwnerName = OwnerName;
            this.SelectAccount = SelectAccount;
            newselect= false;
            this.selectedAccountName = selectedAccountName;
            this.BillingStreet=BillingStreet;
            this.BillingCity=BillingCity;
            this.BillingState=BillingState;
            this.BillingCountry=BillingCountry;
            this.LocationDuns=LocationDuns;
            this.GlobalDUNS =GlobalDUNS ;
        }
        
        
    
    }
}