/*  Class Name   : LX_AcctAndContactSearch 
    * Description   : Controller for 'LX_Global_Search' page for searching Customer and Partner Accounts.
    * Created By   : Kapil
    * Created Date : 06/20/2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Kapil                 06/20/2013               1000                Initial Version
    * Nithin                08/14/2013               1001                Replaced NameLocal with Alias__c  in the query
    * Kapil                 04/09/2013               1002                Commented the debug log statements.
    * Kapil                 03/11/2014               1003                Updated the wildcard search
    */


public without sharing class LX_AcctAndContactSearch{ 

    public boolean showMoreAccFilters {get;set;}
    public boolean showMoreAccts { get; set; }
    public boolean applyAcctFilter { get; set; }    
    public String accountCountryFilter { get; set; }
    public String accountNameFilter { get; set;}
    public boolean showAccFilters { get; set; } 
    public boolean hideAccFilters { get; set; }
    public Account accForFilters{get;set;}    
    public boolean error { get; set; }
    public String searchText { get; set; }
    public boolean isPagination { get; set; }
    public boolean showAccts {get;set;}
    public String testRerender { get; set; }
    private static final string LX_ASC  = 'ASC';
    private static final string LX_DESC = 'DESC';
    private String sortExp = 'Name';  
    private String sortDirection = 'ASC';  
    public integer size {get;set;}
    public boolean showSearchResults {get;set;}
    public string accOwner {get;set;}
    //set the Sort direction
    public String sortExpression
    {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == LX_ASC)? LX_DESC : LX_ASC;
       else
         sortDirection = LX_ASC;
         sortExp = value;
     }
    }
      
    // getter method for the sortDirection    
    public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return LX_ASC;
        else
         return sortDirection;
     }
  
    // setter method for the sortDirection    
    public void setSortDirection(String sortDir)
    {  
       sortDirection = sortDir;
    }
    
    //standard set controller for pagination
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){                
                //@Nithin: Replaced NameLocal with Alias__c  in the query
                string queryString = 'Select id,Name,SMA_Status__c,owner.Name,LX_Sales_Team_Assigned__c,Alias__c,billingcountry ,Party_Type__c,TR_Status__c,footprint__c ,Account.Local_Priority__c,MPS_Qualification__c from Account where recordtype.Name in ( '+ '\'Location Partner\''+' , '+'\'Location Customer\'' +' ) order by Name limit 10000';
                //system.debug('queryString-->'+queryString);
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(5);                
            }
            return setCon;
        }set;
    }
    
    // list of Accounts to display
    public List<Account> Accounts{
        get
        {
            if(setcon != null)
                return (List<Account>)setcon.getRecords();
            else
                return null ;
        }
        set;
    }       
    
    // Initialize all the variables
    public LX_AcctAndContactSearch(){   
        showMoreAccFilters = false;
        accForFilters = new Account();     
        showAccFilters = false;
        hideAccFilters = true;
        error = false;
        showSearchResults = false;
        searchText = Apexpages.CurrentPage().getParameters().get('searchText');//Get the Search text from URL
        //system.debug('searchText -->'+searchText);
        if(searchText != null && searchText != ''){
            //searchText = string.escapeSingleQuotes(searchText);
            search();//Search for Accounts based on the search text.
        }
    }
    
    /* Description : Search for Accounts based on searchtext
    *  Param - 
    *  Returns :  Void
    */
    public void search() {
        string tempSearch = searchText;
        showMoreAccts = false;
        showSearchResults = true;
        applyAcctFilter = false;
        showAccFilters = false;
        hideAccFilters = true;
        showAccts = true;
        isPagination = false;
        string sortFullExp = '';
       if(sortDirection == LX_ASC)
           sortFullExp = sortExpression  + ' ' + sortDirection;
       else
          sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + ' NULLS LAST' ;
        error = false;   
        //searchText = Apexpages.CurrentPage().getParameters().get('searchText');//Get the Search text from URL
        string tempstr = searchText;
        if(searchtext != null ){
            tempstr = tempstr.remove('*');
            searchtext = searchtext.replace('*','%');
            //searchtext = searchtext.replaceLast('*','%');
            //searchText = string.escapeSingleQuotes(searchText);
            
        }
        if(tempstr == null || tempstr.length() < 2){
            error = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Your search term must have 2 or more characters.');
            ApexPages.addMessage(myMsg);                 
        }else{  
                //system.debug('searchText -->'+searchText);
                searchText = string.escapeSingleQuotes(searchText);
                //@Nithin: Replaced NameLocal with Alias__c in the query 
                string query = 'Select id,Name,owner.Name,SMA_Status__c,LX_Sales_Team_Assigned__c,Alias__c,billingcountry ,Party_Type__c,TR_Status__c,footprint__c ,Account.Local_Priority__c,MPS_Qualification__c  from Account Where (  name like '+'\''+searchText+'\' or Alias__c like '+'\''+searchText+'\' or billingcountry like ' +'\''+searchText+'\')'+ ' and  recordtype.Name in ( '+ '\'Location Partner\''+' , '+'\'Location Customer\'' +' ) '+'  Order By '+ sortFullExp+ ' limit 10000';
                //system.debug('query-->'+query);
                //system.debug('searchText -->'+searchText);
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query ));
                setCon.setPageSize(10);
                Accounts = setCon.getRecords();                   
                if(Accounts.isEmpty()){
                    error = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No matches found.');
                    ApexPages.addMessage(myMsg);         
                }
            }
            searchText = tempSearch ;
    }
    /* Description : Search and apply pagination
    *  Param - 
    *  Returns :  Void
    */
    public void showAccPagination() {
        //system.debug('searchText-->'+searchText);
        string tempSearch = searchText;
       //searchText = Apexpages.CurrentPage().getParameters().get('searchText');//Get the Search text from URL
       string tempstr = searchText;
       if(searchtext != null ){
            searchtext = searchtext.replace('*','%');
            tempstr = tempstr.remove('*');
            //searchtext = searchtext.replaceLast('*','%');             
            //searchText = string.escapeSingleQuotes(searchText);               
       }
       if(tempstr == null || tempstr.length() < 2){
            error = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Your search term must have 2 or more characters.');
            ApexPages.addMessage(myMsg);                 
       }
       else{
           searchText = string.escapeSingleQuotes(searchText);
           showAccts = true;
           isPagination = true;
           string sortFullExp = '';
        //build the full sort expression
           if(sortDirection == LX_ASC)
               sortFullExp = sortExpression  + ' ' + sortDirection;
           else
              sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + ' NULLS LAST' ;
            try{ 
                if(searchText != '' && searchText != null){  //Construct a query   
                    //@Nithin: Replaced NameLocal with Alias__c  in the query
                    string query = 'Select id,Name,owner.Name,LX_Sales_Team_Assigned__c,SMA_Status__c,Alias__c,billingcountry ,Party_Type__c,TR_Status__c,footprint__c ,Account.Local_Priority__c,MPS_Qualification__c from Account Where name like '+'\''+searchText+'\' ';
                    if(accForFilters.Name != '' && accForFilters.Name != null)
                    query += ' ' + ' and Name like ' + '\''+string.escapeSingleQuotes(accForFilters.Name.replace('*','%'))+'\'';
                    //@Nithin: Replaced NameLocal with Alias__c
                    if(accForFilters.Alias__c!= '' && accForFilters.Alias__c!= null)
                     query += ' '+ ' and Alias__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Alias__c.replace('*','%'))+'\'';            
                    if(accOwner != '' && accOwner != null)
                     query += ' '+ ' and owner.name like ' + '\''+string.escapeSingleQuotes(accOwner.replace('*','%'))+'\'' ;
                    if(accForFilters.billingCountry != '' && accForFilters.billingCountry != null)
                     query += ' '+ ' and billingCountry like ' + '\''+string.escapeSingleQuotes(accForFilters.billingCountry.replace('*','%'))+'\'';
                    if(accForFilters.TR_Status__c != '' && accForFilters.TR_Status__c != null)
                     query += ' '+ ' and TR_Status__c like ' + '\''+string.escapeSingleQuotes(accForFilters.TR_Status__c.replace('*','%'))+'\'' ;
                    if(accForFilters.Coverage_Status__c != '' && accForFilters.Coverage_Status__c != null)
                     query += ' '+ ' and Coverage_Status__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Coverage_Status__c.replace('*','%'))+'\'' ;
                    if(accForFilters.ISS_Coverage_Model__c != '' && accForFilters.ISS_Coverage_Model__c != null)
                     query += ' '+ ' and ISS_Coverage_Model__c like ' + '\''+string.escapeSingleQuotes(accForFilters.ISS_Coverage_Model__c.replace('*','%'))+'\'';
                    if(accForFilters.ISS_Coverage_Method__c != '' && accForFilters.ISS_Coverage_Method__c != null)
                     query += ' '+ ' and ISS_Coverage_Method__c like ' + '\''+string.escapeSingleQuotes(accForFilters.ISS_Coverage_Method__c.replace('*','%'))+'\'' ;
                    if(accForFilters.Local_Priority__c != '' && accForFilters.Local_Priority__c != null)
                     query += ' '+ ' and Local_Priority__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Local_Priority__c.replace('*','%'))+'\'' ;
                    if(accForFilters.MPS_Qualification__c != '' && accForFilters.MPS_Qualification__c != null)
                     query += ' '+ ' and MPS_Qualification__c like ' + '\''+string.escapeSingleQuotes(accForFilters.MPS_Qualification__c.replace('*','%'))+'\'' ;
                    if(accForFilters.footprint__c != '' && accForFilters.footprint__c != null)
                     query += ' '+ ' and footprint__c like ' + '\''+string.escapeSingleQuotes(accForFilters.footprint__c.replace('*','%'))+'\'' ;
                    if(accForFilters.Party_Type__c != '' && accForFilters.Party_Type__c != null)
                     query += ' '+ ' and Party_Type__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Party_Type__c.replace('*','%'))+'\'';
                    if(accForFilters.Country_Account_Rating__c != '' && accForFilters.Country_Account_Rating__c != null)
                     query += ' '+ ' and Country_Account_Rating__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Country_Account_Rating__c.replace('*','%'))+'\'';
                    if(accForFilters.LX_Sales_Team_Assigned__c != '' && accForFilters.LX_Sales_Team_Assigned__c != null)
                     query += ' '+ ' and LX_Sales_Team_Assigned__c like ' + '\''+string.escapeSingleQuotes(accForFilters.LX_Sales_Team_Assigned__c.replace('*','%'))+'\'' ;
                    if(accForFilters.Primary_ISS_Internal_Segment__c != '' && accForFilters.Primary_ISS_Internal_Segment__c != null)
                     query += ' ' + ' and Primary_ISS_Internal_Segment__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Primary_ISS_Internal_Segment__c.replace('*','%'))+'\'';
                    if(accForFilters.MPS_Capable_Partner__c != '' && accForFilters.MPS_Capable_Partner__c != null)
                     query += ' '+ ' and MPS_Capable_Partner__c like ' + '\''+string.escapeSingleQuotes(accForFilters.MPS_Capable_Partner__c.replace('*','%'))+'\''; 
                   
                    query += ' and  recordtype.Name in ( '+ '\'Location Partner\''+' , '+'\'Location Customer\'' +' ) '+ ' Order By '+ sortFullExp + ' limit 10000';      
                    //system.debug('query-->'+query);
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));  
                    setCon.setPageSize(10);   
                    //system.debug('setcon.getRecords()-->'+setcon.getRecords());                         
                    Accounts = setcon.getRecords();
                    if(!Accounts.isEmpty())
                    isPagination = true;
                }
                showMoreAccts = true;
            }catch(Exception e){                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ''+e);
                ApexPages.addMessage(myMsg);
                //LX_CommonUtilities.createExceptionLog(e);
            }
        }
       searchText = tempSearch ;
       //system.debug('searchText-->'+searchText);
    }
    
    /* Description : Set booleans for controlling the filters display
    *  Param - 
    *  Returns :  Void
    */
    public void showAccFilters() {
        showAccts = true;
        if(showAccFilters == false){
            showAccFilters = true;
            hideAccFilters = false;
        }else if(showAccFilters == true){
            showAccFilters = false;
            hideAccFilters = true;
        }
        showMoreAccFilters = false;
        showMoreAccts = true;
        isPagination = true;
        
    }
    /* Description : Apply filters and display the results.
    *  Param - 
    *  Returns :  Void
    */
    public void applyAccFilters() {
        string tempSearch = searchText;
        //system.debug('searchText-->'+searchText);
        //searchText = Apexpages.CurrentPage().getParameters().get('searchText');//Get the Search text from URL
        isPagination = false;
        error = false;
        showAccts = true;        
        string sortFullExp = '';
        //build the full sort expression
        string tempStr = searchText;
        if(sortDirection == LX_ASC)
           sortFullExp = sortExpression  + ' ' + sortDirection;
        else
          sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + ' NULLS LAST' ;
        try{
        if(searchtext != null ){
            searchtext = searchtext.replace('*','%');
                //searchtext = searchtext.replace('*','%');
                //searchtext = searchtext.removeEnd('*');
            tempStr = tempStr.remove('*');
                //searchText = string.escapeSingleQuotes(searchText);
        }
        if( tempStr == null || tempStr.length() < 2){
            error = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Your search term must have 2 or more characters.');
            ApexPages.addMessage(myMsg);                 
        }
        else{       
        if(searchText != '' && searchText != null){//Construct query
            searchText = string.escapeSingleQuotes(searchText);    
            //@Nithin: Replaced NameLocal with Alias__c  in the query    
            string query = 'Select id,Name,owner.Name,LX_Sales_Team_Assigned__c,SMA_Status__c,Alias__c,billingcountry ,Party_Type__c,TR_Status__c,footprint__c ,Account.Local_Priority__c,MPS_Qualification__c from Account Where name like '+'\''+string.escapeSingleQuotes(searchText.replace('*','%'))+'\' ';
            if(accForFilters.Name != '' && accForFilters.Name != null)
            query += ' ' + ' and Name like ' + '\''+string.escapeSingleQuotes(accForFilters.Name.replace('*','%'))+'\'';
            //@Nithin: Replaced NameLocal with Alias__c
            if(accForFilters.Alias__c != '' && accForFilters.Alias__c != null)
             query += ' '+ ' and Alias__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Alias__c.replace('*','%'))+'\'';            
            if(accOwner != '' && accOwner != null)
             query += ' '+ ' and owner.name like ' + '\''+string.escapeSingleQuotes(accOwner.replace('*','%'))+'\'';
            if(accForFilters.billingCountry != '' && accForFilters.billingCountry != null)
             query += ' '+ ' and billingCountry like ' + '\''+string.escapeSingleQuotes(accForFilters.billingCountry.replace('*','%'))+'\'';
            if(accForFilters.TR_Status__c != '' && accForFilters.TR_Status__c != null)
             query += ' '+ ' and TR_Status__c like ' + '\''+string.escapeSingleQuotes(accForFilters.TR_Status__c.replace('*','%'))+'\'' ;
            if(accForFilters.Coverage_Status__c != '' && accForFilters.Coverage_Status__c != null)
             query += ' '+ ' and Coverage_Status__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Coverage_Status__c.replace('*','%'))+'\'' ;
            if(accForFilters.ISS_Coverage_Model__c != '' && accForFilters.ISS_Coverage_Model__c != null)
             query += ' '+ ' and ISS_Coverage_Model__c like ' + '\''+string.escapeSingleQuotes(accForFilters.ISS_Coverage_Model__c.replace('*','%'))+'\'';
            if(accForFilters.ISS_Coverage_Method__c != '' && accForFilters.ISS_Coverage_Method__c != null)
             query += ' '+ ' and ISS_Coverage_Method__c like ' + '\''+string.escapeSingleQuotes(accForFilters.ISS_Coverage_Method__c.replace('*','%'))+'\'' ;
            if(accForFilters.Local_Priority__c != '' && accForFilters.Local_Priority__c != null)
             query += ' '+ ' and Local_Priority__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Local_Priority__c.replace('*','%'))+'\'' ;
            if(accForFilters.MPS_Qualification__c != '' && accForFilters.MPS_Qualification__c != null)
             query += ' '+ ' and MPS_Qualification__c like ' + '\''+string.escapeSingleQuotes(accForFilters.MPS_Qualification__c.replace('*','%'))+'%\'' ;
            if(accForFilters.footprint__c != '' && accForFilters.footprint__c != null)
             query += ' '+ ' and footprint__c like ' + '\''+string.escapeSingleQuotes(accForFilters.footprint__c.replace('*','%'))+'\'' ;
            if(accForFilters.Party_Type__c != '' && accForFilters.Party_Type__c != null)
             query += ' '+ ' and Party_Type__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Party_Type__c.replace('*','%'))+'\'';
            if(accForFilters.Country_Account_Rating__c != '' && accForFilters.Country_Account_Rating__c != null)
             query += ' '+ ' and Country_Account_Rating__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Country_Account_Rating__c.replace('*','%'))+'\'';
            if(accForFilters.LX_Sales_Team_Assigned__c != '' && accForFilters.LX_Sales_Team_Assigned__c != null)
             query += ' '+ ' and LX_Sales_Team_Assigned__c like ' + '\''+string.escapeSingleQuotes(accForFilters.LX_Sales_Team_Assigned__c.replace('*','%'))+'\'' ;
            if(accForFilters.Primary_ISS_Internal_Segment__c != '' && accForFilters.Primary_ISS_Internal_Segment__c != null)
             query += ' ' + ' and Primary_ISS_Internal_Segment__c like ' + '\''+string.escapeSingleQuotes(accForFilters.Primary_ISS_Internal_Segment__c.replace('*','%'))+'%\'';
            if(accForFilters.MPS_Capable_Partner__c != '' && accForFilters.MPS_Capable_Partner__c != null)
             query += ' '+ ' and MPS_Capable_Partner__c like ' + '\''+string.escapeSingleQuotes(accForFilters.MPS_Capable_Partner__c.replace('*','%'))+'\''; 
           
            query += ' and  recordtype.Name in ( '+ '\'Location Partner\''+' , '+'\'Location Customer\'' +' ) '+ ' Order By '+ sortFullExp + ' limit 10000';      
            //system.debug('query-->'+query);
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));  
            setCon.setPageSize(10);   
            //system.debug('setcon.getRecords()-->'+setcon.getRecords());                         
            Accounts = setcon.getRecords();
            if(!Accounts.isEmpty())
            isPagination = true;
        }
        applyAcctFilter = true;  
        }
        }catch(Exception e){                
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ''+e);
            ApexPages.addMessage(myMsg);
            //LX_CommonUtilities.createExceptionLog(e);
        }
         searchText = tempSearch ; 
         //system.debug('searchText-->'+searchText);
    } 
    
        
    /* Description : Display next set of records
    *  Param - 
    *  Returns :  Void
    */
    public void next()
    {   
        setcon.next();
    }
    /* Description : Display previous set of records
    *  Param - 
    *  Returns :  Void
    */
    
    public void previous()
    { 
        setcon.previous();
    }
    /* Description : Set boolean for showing more Accounts
    *  Param - 
    *  Returns :  Void
    */
    
    public void showMoreAccts() {
        showAccts = true;
        showAccFilters = false;
        hideAccFilters = true;
        isPagination = true;        
        showMoreAccts = true;
    }
    /* Description : Set boolean for showing more filters
    *  Param - 
    *  Returns :  Void
    */
    
    public void showMoreFilters() {
        accForFilters = new Account();
        showMoreAccFilters = true;   
    }    
    /* Description : Method for getting all the picklist values
    *  Param - Sobject obj: SObject ,string fld : picklist field
    *  Returns :  List<selectOption>
    */
    
    public static list<SelectOption> getPicklistValues(SObject obj, String fld){
      list<SelectOption> options = new list<SelectOption>();
      options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
      // Get the object type of the SObject.
      Schema.sObjectType objType = obj.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the list of picklist values for this field.
      list<Schema.PicklistEntry> values =
         fieldMap.get(fld).getDescribe().getPickListValues();
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a : values)
      { 
         options.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
      return options;
     }
    /* Description : Get the picklist values for Party_Type__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getpartyTypes() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'Party_Type__c'); //return the picklist options
    }
    /* Description : Get the picklist values for TR_Status__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getTrStatus() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'TR_Status__c'); //return the picklist options
    }
    /* Description : Get the picklist values for Coverage_Status__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getCoverageStatus() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'Coverage_Status__c'); //return the picklist options
    }
    /* Description : Get the picklist values for ISS_Coverage_Model__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getCoverageModels() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'ISS_Coverage_Model__c'); //return the picklist options
    }
    /* Description : Get the picklist values for ISS_Coverage_Method__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getCoverageMethods() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'ISS_Coverage_Method__c'); //return the picklist options
    }
    
    /* Description : Get the picklist values for Local_Priority__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getLocalPriorities() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'Local_Priority__c'); //return the picklist options
    }
    /* Description : Get the picklist values for MPS_Qualification__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getMPSQualifications() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'MPS_Qualification__c'); //return the picklist options
    }
    
    /* Description : Get the picklist values for LX_Sales_Team_Assigned__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getVerticals() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'LX_Sales_Team_Assigned__c'); //return the picklist options
    }
    /* Description : Get the picklist values for Primary_ISS_Internal_Segment__c
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getPrimaryISSInternalSegments() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
        Account acc = new Account();
        return getPicklistValues(acc,'Primary_ISS_Internal_Segment__c'); //return the picklist options
    }
    
/* Description : Get the picklist values for MPS_Capable_Partner__c
    *  Param - 
    *  Returns :  List<selectOption>
*/
    public List<selectOption> getMPSCapablePartners() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options           
        Account acc = new Account();
        return getPicklistValues(acc,'MPS_Capable_Partner__c'); //return the picklist options
    }        
        
}