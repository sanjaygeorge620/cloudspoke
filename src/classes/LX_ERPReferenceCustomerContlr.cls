/*
Class Name : LX_ERPReferenceCustomerContlr
Description : Controller for the Erp Reference customer and the end user fields.
Created By : Veenu Trehan(vtrehan@deloitte.com)
Created Date :12/10/2013
Modification Log:
-------------------------------------------------------------------------
Developer                Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan            12/10/2013        1000                   Initial Version
Sumedha Kucherlapati    12/11/2013                               Modified to add the logic for erp ref customer
Rashi Joshi             12/15.2013                               Merged the logic for end user and erp ref customer 
*************************************************************************/
public with sharing class LX_ERPReferenceCustomerContlr{

  //Decalare all the static constants for the class
  private static final string LX_ASC            = 'ASC';
  private static final string LX_DESC           = 'DESC';
  private static final string LX_SOLD           = 'SOLD';
  private static final string LX_Active         = 'Active';
  private static final string LX_ORDER_BY       = ' order by ';
  private static final string LX_MPSType        = 'MPS';
   //4/23/14 VT added 
  private static final string Opp_DivisionISS        = 'ISS';
  private static final string SalesTypeMPSAddOn      ='MPS Software Add On';
  // sold to query
  private static final string LX_SOLD_TO_QUERY  = 'select id, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_MDM_Act__c != NULL) AND (LX_Sold_To__r.LX_MDM_Act__c = \'';
  private static final string LX_SOLD_TO_QUERY_MPS  = 'select id, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_MDM_ID__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c,LX_Sold_To__r.LX_Party_Type__c,LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c = \'';
  private static final string LX_Party_Role= 'MANAGED SERVICES CUSTOMER';

  // zidc query  
  private static final string LX_ZIDC_QUERY  =  'select id, LX_Name__c, Name,LX_ZIDC_ID__c,LX_Status__c,CurrencyIsoCode from LX_SAP_Record__c where LX_MDM_Act__c != NULL AND LX_Status__c = \''+LX_Active+'\' AND RecordType.DeveloperName = \'LX_ZIDC\' AND LX_MDM_Act__c = \'';
  private static final string LX_SOLD_TO_ZIDC_QUERY_MPS_ADDon  =  'select id, LX_Name__c, Name,LX_ZIDC_ID__c,LX_Status__c,CurrencyIsoCode from LX_SAP_Record__c where LX_MDM_Act__c != NULL AND LX_Status__c = \''+LX_Active+'\' AND RecordType.DeveloperName = \'LX_ZIDC\' AND LX_MDM_ID__c = \'';
  private static final string LX_ZIDC_QUERY_MPS  =  'select id, LX_Name__c,LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c, Name,LX_ZIDC_ID__c,LX_Status__c,CurrencyIsoCode from LX_SAP_Record__c where LX_Status__c = \''+LX_Active+'\' AND RecordType.DeveloperName = \'LX_ZIDC\' AND LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c = \'';
  private static final string LX_SOLD_TO_QUERY_MPS_ADDon  = 'select id, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, LX_Payment_Terms_Description__c, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_MDM_ID__c != NULL) AND (LX_Sold_To__r.LX_MDM_ID__c = \'';
  private static final string LX_SOLD_TO_QUERY1 = '\' ) AND LX_Sales_Org1__c = \'';
  private static final string LX_SOLD_TO_QUERY2 = '\' AND LX_Currency__c =\''; 
  // sumedha 1/20 commented as not part of logic private static final string LX_ZIDC_QUERY2 = '\' AND CurrencyIsoCode =\''; 
  private static final string LX_QUERY2         = '\' AND LX_Sold_To_Sales_Org__r.LX_Sales_Org1__c = \' AND LX_Sold_To__r.LX_Status__c = \''+LX_Active+'\'';
  private static final string newSoldToPage     = '/apex/LX_Request_for_New_Bill_to_Ship_to';
  private static final string LX_SoldtoID       = 'soldtoID';

  //List of Wrapper to hold the record values onto the page.
  private list<customSoldToWrapper> resultList  = new list<customSoldToWrapper>();

  // sumedha added variables to include pagination
   private list<customSoldToWrapper> totalResultList  = new list<customSoldToWrapper>();
   private list<LX_SAP_Record_Sales_Org__c> SoldTo = new list<LX_SAP_Record_Sales_Org__c>();
  
  private list<customZIDCWrapper> resultZIDCList= new list<customZIDCWrapper>();
  
  // list of SAP Record to hold values from the ZIDC query
  private list<LX_SAP_Record__c> ZIDC = new list<LX_SAP_Record__c>();
  
  private string selectedRecord                 = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.selectedRecord);
  // Variable to store the typeOfRecord that we have to perform the search on.      
  private string typeOfRecord                   = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.type);
  // Variable to store the AccountID for the opportunity.
  private string accountId                      = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.accountId);
  // Variable to store the Opportunity ID for the opportunity.  
  private string oppId                          = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.oppId);
  // Variable to store Sold to ID while updating Bill to and Ship to
  private string soldtoID   = '';
  // Variable to store the initialQuery String for sold to records.
  private string query          = '';
  // Variable to store the initialQuery String for ZIDC records.
  private string queryZIDC      = '';
  // Variable to store the condition for the query for sold to records.
  private string condition      = '';         
  // Variable to store the condition for the query for ZIDC records.
  private string conditionZIDC  = '';  
  // Variable to store the sort direction for the columns
  private String sortDirection = 'ASC';  
  // Variable to store the field on which the sorting is going to happen.
  private String sortExp = 'name';  
  // Variable that checks if the page can be loaded correctly or not.
  public Boolean isError{get;set;}
  public Boolean flag{get;set;}

  public string input1{get;set;}
  public string input2{get;set;}
  public string input3{get;set;}
  public string input4{get;set;}
  public string input5{get;set;}
  public string input6{get;set;}
  public string input7{get;set;}
  public string input8{get;set;}
  public Opportunity opp {get; set;}
  public Contact objContact {get; set;}
// sumedha - added pagination variables
  public Integer totalRecords{get;set;} // stores total records returned by query
  public Integer page{get; set;} // to display records returned on UI
  public Integer count=1; // Variable to store counter value
  public Integer index{get;set;} // to set offset
  private Integer Limit_querysize=10;
  public Boolean DontShow {get; set; }
  
  public Boolean clicknext {get; set;}  //This boolean stores the state of the next and last button
  public Boolean clickprev {get; set;}  //This boolean stores the state of the previous and first button
  public Integer pagenum {get; set;}  // This boolean stores the total number of pages during pagination
  
  

  // Variable to store the sortExpression
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

     
     /*****************************************************
    * Name             : firstpage
    * Description      : loads the 1st 50 records on the page.
    * Input Parameters : None
    * Return           : None
    ******************************************************/     
     public PageReference firstpage(){
           count=1;
           index = 0;
           clicknext = true;
           clickprev = false;
           searchData();
         return null;
      }
      
   /*****************************************************
    * Name             : previous
    * Description      : loads the 1st 50 records or the previous 50 records on the page.
    * Input Parameters : None
    * Return           : None
    ******************************************************/
      public PageReference previous() {
            count--;
           
            clicknext = TRUE;
            if((index - 50) < 0){
                index = 0;
                clickprev = false;
                return null;
            }else{
                index -= 50;
                clicknext = true;
                clickprev = true;
            }
            if(count == 1){
                clickprev = FALSE;
            }               
        searchData();
        return null;
       }

   /*****************************************************
    * Name             : next
    * Description      : loads the last 50 records or the next 50 records on the page.
    * Input Parameters : None
    * Return           : None
    ******************************************************/
    public PageReference next() {
        count++;
        clicknext = TRUE;
         if(count == pagenum){
           lastpage();
         }else{
            if((index + 50)> totalRecords){
                clicknext = false;
                return null;
            }else{
                index += 50;
                clickprev = true;
            }
        searchData();
        }
        return null;
     }
    
   /*****************************************************
    * Name             : lastpage
    * Description      : loads the last 50 records on the page.
    * Input Parameters : None
    * Return           : None
    ******************************************************/
     public PageReference lastpage(){
       count=pagenum;
       clicknext= TRUE;
        
            if((index + 50)> totalRecords){
                clicknext = false;
                return null;
            }else{                
                index = (totalRecords/50)*50;
                clickprev = true;
                clicknext = false;
            }
        System.debug('>>>>>>index>>>'+index);
        searchData();
        return null;
     }
  

    /*
     * 
     * Description : This is the constructor. This methods queries for the opportunity and corresponding parameters required for setting up the Sold To on the Opportunity.
     * Throw the appropriate error meessage if any of the pre-requistes are not met.
     * Param - : The Opportunity ID passed over the URL.
     * Param - : The current sold To record ID passed over the URL.
     * Param - : The type of transaction passed over the URL.
     * Param - : The Account ID passed over the URL.
     * Returns :  null
    */
  public LX_ERPReferenceCustomerContlr(){
    isError = false;
    index = 0;
    pagenum = 0;
    clicknext = FALSE; 
    count = 1;    flag = false;
        String partnerAcc ='';
        
            try{
                if(oppID != NULL)
                {

                    // Query on the Opportunity and get all the required parameters 
                     opp = [Select ID,Name,Type,LX_ERP_Reference_Customer_Lookup__c ,LX_Opportunity_Division__c,Software_Solutions__c,LX_Sales_Type__c,End_Customer__c ,Account.MDM_ID__c,Primary_Partner__c,Primary_Partner__r.MDM_ID__c,Account.Name,Opportunity.Primary_Partner__r.MDM_Account_Number__c ,Opportunity.Account.MDM_Account_Number__c,Primary_Partner__r.ParentId, AccountID,Account.ParentId,Sales_Organization__r.Sales_Organization__c, Sales_Organization_value__c,CurrencyIsoCode from Opportunity where id =: oppID LIMIT 1];
                     opp.Name= opp.Name.remove('#');//ADDED by arun ,remove Name # chars


                     List<Contact> ListContac=[select Name,Id from contact where pse__Salesforce_User__c=:UserInfo.getUserID()];
                    if(!ListContac.IsEmpty())
                     objContact=ListContac[0];
                     
                   
                    // If there is no sales org present, throw an error 
                    if(opp.Sales_Organization_value__c == null){
                             isError = true;
                             ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_NO_Sales_Org_Error);
                             ApexPages.addMessage(message);
                    }
                    
                    //If there is no Account associated to the opportunity, throw an error.
                    if(opp.Account == null){
                             isError = true;
                             ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Account_Error);
                             ApexPages.addMessage(message);
                    }
                    
                    //Check on the type of the RecordType and then construct the query.
                   if(typeOfRecord == LX_SOLD && oppID != NULL){
                       string accountIDForSoldTo = '';
                       string MDMAccountNo = '';
                       //MDMAccountNo         = opp.Account.MDM_Account_Number__c;
                       
                       if(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true &&opp.LX_Sales_Type__c!=SalesTypeMPSAddOn){
                           MDMAccountNo         = opp.Account.MDM_ID__c;
                         }else{
                           MDMAccountNo         = opp.Account.MDM_Account_Number__c;                             
                        }
                       System.debug('>>>>>opp.Type>>>>>'+opp.Type);
                       if(opp.Type == LX_MPSType){
                         query = LX_SOLD_TO_QUERY_MPS + LX_Party_Role + LX_SOLD_TO_QUERY1 + opp.Sales_Organization__r.Sales_Organization__c + LX_SOLD_TO_QUERY2 + Opp.CurrencyIsoCode+ '\'' ;
                         queryZIDC = LX_ZIDC_QUERY_MPS + LX_Party_Role +'\'';
                       }else if(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true && opp.LX_Sales_Type__c!=SalesTypeMPSAddOn){
                        MDMAccountNo=opp.Account.MDM_ID__c;
                        query = LX_SOLD_TO_QUERY_MPS_ADDon + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.CurrencyIsoCode+'\'' ;
                        queryZIDC = LX_SOLD_TO_ZIDC_QUERY_MPS_ADDon  +MDMAccountNo+'\''; //LX_ZIDC_QUERY2+ Opp.CurrencyIsoCode+'\'';
                        }else{
                         query = LX_SOLD_TO_QUERY + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.CurrencyIsoCode+'\'' ;
                         queryZIDC = LX_ZIDC_QUERY +MDMAccountNo+'\''; //LX_ZIDC_QUERY2+ Opp.CurrencyIsoCode+'\'';
                       }
                        system.debug('query ******'+query);
                        system.debug('queryZIDC ******'+queryZIDC);
                    }
                    
            }else{
                //Throw an error if the opportuunity is not setup.
                 isError = true;
                 ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_Opportunity_Not_SetUp);
                 ApexPages.addMessage(message);
            }
                //Call the method to populate the record.
                if(!isError){       
                    viewSoldToData();
                }
            }catch (exception ex){
                //Throw an error on screen when an exception occurs.
                isError = true;
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_UnknownError);
                ApexPages.addMessage(message);
                //log the exception error.
                LX_CommonUtilities.createExceptionLog(ex);              
            }
     
  }
    
    /*
     * 
     * Description : Based on the parameters selected on the page for filtering and then would construct wrapper data accordingly.
     * Param - : None
     * Returns :  null
    */
    public PageReference viewSoldToData() {
        
        //Declare the constants    
        String NullLast = 'NULLS LAST';
        string sortFullExp = '';
        
        //build the full sort expression
        //If the Sort Direction is Ascending, then Push the Nulls at the bottom of the list
        if(sortDirection == LX_ASC){
            sortFullExp = sortExpression  + ' ' + sortDirection;
        }
        else{
            sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + NullLast;
        }
               
        //query the database based on the sort expression
        string finalQuery  = query + condition;
               
            
        try{  
            // Created this query for testdata  
            //list<LX_SAP_Record_Sales_Org__c> testData = [select RecordType.DeveloperName,LX_Sold_To__r.LX_Account__c,LX_Sales_Org1__c, LX_Currency__c from LX_SAP_Record_Sales_Org__c];
                
            //Query for the Sold To based on the values.
            SoldTo= Database.query(finalQuery   + LX_ORDER_BY + sortFullExp + '');
                
            //Based on the results of the query, re inititalise the wrapper class. The clear here is not necessary.
         // sumedha - commented to add to searchdata() as part of pagination lines 340-341
         //resultList = new list<customSoldToWrapper>();
         //   resultList.clear();
            if(SoldTo.size()>0){ 
            totalRecords = SoldTo.size();
            if(totalRecords > 50){
                 clicknext   = true;         
            }else{
                 clicknext = false;
            }
            pagenum=(totalRecords/50);
          if(math.mod(totalRecords,50)!= 0)
           {
             pagenum = pagenum+1;
           }
       
          page=totalRecords;
          if(page > 0){
               if((math.mod(page,50))==0)
                 page=index+50;
               else
                page= index+page;
           }
           searchData();
          /* sumedha - commented to add to searchdata() as part of pagination//Iterate over the queried records and generate the wrapper list to be displayed on the page.
            for(LX_SAP_Record_Sales_Org__c org :SoldTo){
                // If the record is a selected record then ensure that the checked record is selected.
                if(selectedRecord != '' && selectedRecord != null && org.id == selectedRecord){
                    resultList.add(new customSoldToWrapper(org,true));
                }else
                    resultList.add(new customSoldToWrapper(org,false));
                }*/
            }else{
               System.debug('******view sold to in else');
                        if(opp.Sales_Organization_value__c == null)
                        {
                            isError = true;
                            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_NO_Sales_Org_Error);
                            ApexPages.addMessage(message);
                        }
                        else{
                            flag=true;
                            viewZIDCData();
                        }
            }           
                
            }catch (exception ex){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_UnknownError);       
            }
        return null;
    }
    
    /*
     * 
     * Description : Based on the parameters selected on the page for filtering and then would construct wrapper data accordingly.
     * Param - : None
     * Returns :  null
    */ 
    public PageReference viewZIDCData() {
    System.debug('******in viewZIDCData');
    //Declare the constants    
        String NullLast = 'NULLS LAST';
        string sortFullExp = '';
        flag = true;
        resultZIDCList.clear();
        //build the full sort expression
        //If the Sort Direction is Ascending, then Push the Nulls at the bottom of the list
        if(sortDirection == LX_ASC){
            sortFullExp = sortExpression  + ' ' + sortDirection;
        }
        else{
            sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + NullLast;
        }
               
        //query the database based on the sort expression
        string finalQuery  = queryZIDC + conditionZIDC ;
        //Query for the ZIDC based on the values.
        try{  
            // Created this query for testdata  
            //list<LX_SAP_Record_Sales_Org__c> testData = [select RecordType.DeveloperName,LX_Sold_To__r.LX_Account__c,LX_Sales_Org1__c, LX_Currency__c from LX_SAP_Record_Sales_Org__c];
           
            //Query for the Sold To based on the values.
            ZIDC.clear();
           // resultZIDCList.clear();
            ZIDC= Database.query(finalQuery   + LX_ORDER_BY + sortFullExp + '');
           
         }catch(exception ex){
                 system.debug('query*****'+finalQuery   + LX_ORDER_BY + sortFullExp + '');
                 system.debug('exception-->'+ex);
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_UnknownError); 
                ApexPages.addMessage(message);     
        }
        if(ZIDC.size()>0){       
            totalRecords = ZIDC.size();
            if(totalRecords > 50){
                 clicknext   = true;         
            }else{
                 clicknext = false;
            }
            pagenum=(totalRecords/50);
          if(math.mod(totalRecords,50)!= 0)
           {
             pagenum = pagenum+1;
           }
       
          page=totalRecords;
          if(page > 0){
               if((math.mod(page,50))==0)
                 page=index+50;
               else
                page= index+page;
           }
            //Based on the results of the query, re inititalise the wrapper class. The clear here is not necessary.
             searchZIDCData();
             
         /* sumedha - commented for pagination -  resultZIDCList = new list<customZIDCWrapper>();
            
            //Iterate over the queried records and generate the wrapper list to be displayed on the page.
            for(LX_SAP_Record__c org :ZIDC)
            {
                // If the record is a selected record then ensure that the checked record is selected.
                if(selectedRecord != '' && selectedRecord != null && org.id == selectedRecord)
                {
                    resultZIDCList.add(new customZIDCWrapper(org,true));
                }else
                    resultZIDCList.add(new customZIDCWrapper(org,false));
            }
           */ 
        }
        
        else{
            
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Record); 
            ApexPages.addMessage(message);
        }
        
              return null;   
            
        }


    /*
     * 
     * Description : This method updates the opportunity with the selected Sold To.
     * Throw the appropriate error meessage if any of the pre-requistes are not met.
     * Param - : The Opportunity ID passed over the URL.
     * Returns :  null
    */
  
    public pageReference updateEndUserOpp(){
        string selectedID = null;
        string soldtoID = null;
        //Loop over the Displayed Wrapper list and find the selected Sold To ID
        for(customSoldToWrapper wrap :resultList){
            if(wrap.selected == true){
                // Assign the selected Sold To Record ID to the selectedID variable.
                selectedID = wrap.soldToObject.id;
                soldtoID = wrap.soldToObject.LX_Sold_To__r.LX_Sold_To_ID__c;
                break;
            }
        }
        //Creat a new Opportunity and assign the selected Sold To to the opportunity.
        Opportunity opp;
        opp = new Opportunity (id = oppId , LX_ERP_Reference_Customer_Lookup__c = selectedID, End_Customer__c = soldtoID);
        try{       
            update opp;
            System.debug('********************'+opp.LX_ERP_Reference_Customer_Lookup__c+'^^^^'+oppId+'&&&&&'+opp.Id );
        }catch(Exception ex){
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_UnknownError);
            ApexPages.addMessage(message);
             System.debug('Exception'+ex.getMessage());
            // Log the error in the common utilities class
            LX_CommonUtilities.createExceptionLog(ex);
        }
        return null;
    }
    
       /*
     * 
     * Description : This method updates the opportunity record with ERP Customer data. 
     * Param - : None
     * Returns : Null
    */
      public Pagereference updateERPCustomer(){
         
        System.debug('In save method');
        
        String sapID ='';
        String sapNumber='';
        Opportunity opp;
        if(resultList.size()>0 && resultZIDCList.size()==0){
        
        System.debug('In result set '+resultList.size());
            
        for(customSoldToWrapper c: resultList )
        {        
            if(c.selected ==true)
            {
                sapID = c.SoldToObject.LX_Sold_To__r.Id;
                sapNumber = (c.SoldToObject.LX_Sold_To__r).LX_Sold_To_ID__c;
                        
            }
        }
        System.debug('Updating erp customer field '+sapID+'Sap Number'+sapNumber);
        opp = new Opportunity (id = oppId , LX_ERP_Reference_Customer_Lookup__c = sapID , End_Customer__c  = sapNumber);
            
        }
        else if(resultZIDCList.size()>0)
        {
            for(customZIDCWrapper c: resultZIDCList )
            {
                System.debug('***in for ZIDC'); 
                if(c.selected ==true)
                {
                    sapID = c.ZIDCObject.Id;
                    sapNumber = c.ZIDCObject.LX_ZIDC_ID__c;
                }
            }
            
            opp = new Opportunity (id = oppId , LX_ERP_Reference_Customer_Lookup__c = sapID , End_Customer__c = sapNumber);
    
        }else
        {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'No results found.');
            ApexPages.addMessage(message);
       
        }
        try{
        update opp;
        System.debug('Opportunity after update'+opp.LX_ERP_Reference_Customer_Lookup__c);
        }catch (exception ex){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_UnknownError);       
            }
        
        return null;
      }
    
    /*
     * 
     * Description : This method is called on the load of the page to ask the user to rectify any errors that are there on the page.
     * Param - : None
     * Returns : Null
    */
    public pageReference onLoad(){
        if(isError){
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_Rectify_Error);
            ApexPages.addMessage(message);
         }   
        return null;
    }
  
    /*
     * 
     * Description : This method constructs the query for the Sold To Data based on the filters selected byt the user.
     * Param - : None
     * Returns : Null
    */
    public Pagereference GoSoldto(){
        index = 0;
        pagenum = 0;
        clicknext = FALSE; 
        count = 1;
        clickprev = FALSE;
        condition = '';
        if(input1 != NULL && input1.trim() != ''){
            condition = condition + 'AND LX_Sold_To__r.LX_Name__c LIKE \'%' + input1 + '%\' ';
        }
        if(input2 != NULL && input2.trim()!= ''){
            condition = condition + 'AND LX_Sold_To__r.LX_Sold_To_ID__c LIKE \'%' + input2 + '%\' ';
        }
        if(input3 != NULL && input3.trim() != '' ){
            condition = condition + 'AND LX_Default_Payment_Terms__c LIKE \'%' + input3 + '%\' ';
        }
        if(input4 != NULL && input4.trim() != ''){
            condition = condition + 'AND LX_Currency__c = \'' + input4 + '\' ';
        }
        if(input5 != NULL && input5.trim() != ''){
            condition = condition + 'AND LX_Sales_Org1__c LIKE \'%' + input5 + '%\'';
        }
        // Once the query condition has been constructed, call the viewSoldToData method to create the wrapper data to be dispayed on the page.        
        viewSoldToData();
        return null;
    }
    
     /*
     * 
     * Description : This method constructs the query for the ZIDC Data based on the filters selected by the user.
     * Param - : None
     * Returns : Null
    */
    public Pagereference Go(){
        index = 0;
        pagenum = 0;
        clicknext = FALSE; 
        count = 1;
        clickprev = FALSE;
        conditionZIDC = '';
        System.debug('***In go ZIDC');
        System.debug('***input1'+input1);
        System.debug('***input2'+input2);
   
        if(input1 != NULL && input1.trim() != ''){
            conditionZIDC = conditionZIDC + 'AND  Name LIKE \'%' + input1 + '%\' ';
        }
        if(input2 != NULL && input2.trim()!= ''){
            conditionZIDC = conditionZIDC + 'AND LX_ZIDC_ID__c =\'' + input2+'\'';
        }
       System.debug('***conditionZIDC'+conditionZIDC);
        // Once the query condition has been constructed, call the viewSoldToData method to create the wrapper data to be dispayed on the page.        
   
        viewZIDCData();
        return null;
    }
    
    /*
     * 
     * Description : This method just refreshes/rerenders the page. 
     * Param - : None
     * Returns : Null
    */
      public Pagereference Cancel(){
        return null;
      }
    public Pagereference searchData(){
      resultList = new list<customSoldToWrapper>();
      //resultList.clear();
      System.debug('>>>count>>>'+count+'>>>>>>pagenum>>>>>>'+pagenum);
      if(count != pagenum && totalRecords > 0){
     // if(totalRecords > 0){
         System.debug('*************');
            for(integer i=index; i <(index+50); i++){
            System.debug('>>>>>>>>>i>>>>>>>>>>>'+i);
            //Iterate over the queried records and generate the wrapper list to be displayed on the page.
                // If the record is a selected record then ensure that the checked record is selected.
                if(selectedRecord != '' && selectedRecord != null && SoldTo[i].id == selectedRecord){
                    resultList.add(new customSoldToWrapper(SoldTo[i],true));
                }else{
                    resultList.add(new customSoldToWrapper(SoldTo[i],false));
                }
           }
       }else{
              if(totalRecords > 0 && count == pagenum){
               //  for(integer i=index; i <(index+(math.mod(totalRecords,50))); i++){
                for(integer i=index; i <(totalRecords); i++){
                 if(selectedRecord != '' && selectedRecord != null && SoldTo[i].id == selectedRecord){
                        resultList.add(new customSoldToWrapper(SoldTo[i],true));
                    }else{
                        resultList.add(new customSoldToWrapper(SoldTo[i],false));
                    }
                 }
             }
       }
       System.debug('>>>>>result list size>>>>'+resultList.size());
       return null;
     } 
     
     public Pagereference searchZIDCData(){
      resultZIDCList = new list<customZIDCWrapper>();
      System.debug('>>>count>>>'+count+'>>>>>>pagenum>>>>>>'+pagenum);
      if(count != pagenum && totalRecords > 0){
        System.debug('*************');
            for(integer i=index; i <(index+50); i++){
            System.debug('>>>>>>>>>i>>>>>>>>>>>'+i);
            //Iterate over the queried records and generate the wrapper list to be displayed on the page.
                // If the record is a selected record then ensure that the checked record is selected.
                if(selectedRecord != '' && selectedRecord != null && ZIDC[i].id == selectedRecord){
                    resultZIDCList.add(new customZIDCWrapper(ZIDC[i],true));
                }else{
                    resultZIDCList.add(new customZIDCWrapper(ZIDC[i],false));
                }
           }
        }else{
              if(totalRecords > 0 && count == pagenum){
               //  for(integer i=index; i <(index+(math.mod(totalRecords,50))); i++){
                for(integer i=index; i <(totalRecords); i++){
                 if(selectedRecord != '' && selectedRecord != null && ZIDC[i].id == selectedRecord){
                        resultZIDCList.add(new customZIDCWrapper(ZIDC[i],true));
                    }else{
                        resultZIDCList.add(new customZIDCWrapper(ZIDC[i],false));
                    }
                 }
             }
       }
       System.debug('>>>>>result list size>>>>'+resultList.size());
       return null;
     }
     
      
    /*
     * 
     * Description : This method just refreshes/rerenders the page. 
     * Param - : None
     * Returns : PageReference to the new create Bill To Ship To Page.
    */
  public Pagereference createSoldto(){
    
    //create a page reference for the New Sold To page.  
    Pagereference pg = new Pagereference(newSoldToPage); // '/apex/LX_Request_for_New_Bill_to_Ship_to?oppId='+oppId+'&type='+type);
    
    //put the relevant parameters in the url
    pg.getParameters().put(LX_OpportunityHelper.oppId,oppId);
    pg.getParameters().put(LX_OpportunityHelper.type,typeOfRecord);
    pg.setredirect(true); 
    return pg;
  }
 
  
  
  /* getter method for the resultList variable
  */
  public list<customSoldToWrapper> getresultList(){
    return this.resultList;
  }
  
  /* getter method for the resultZIDCList variable
  */
  public list<customZIDCWrapper> getresultZIDCList(){
    return this.resultZIDCList;
  }
  
  /* getter method for the ZIDC variable
  */
    public list<LX_SAP_Record__c> getZIDC(){
    return this.ZIDC ;
  }
  
  
    /* Class Name   : customSoldToWrapper
    * Description   : This is the wrapper class used to hold the SOld To Details alsong with selction status for each record.
    * Created By   : Sumedha K.
    * Created Date : 12-10-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            12-10-2013               1000                Initial Version    
    */
  public class customSoldToWrapper{
    //Boolean to let us know the 
    public Boolean selected{get;set;}
  
    //SAP sales Org object to store the Sold To Object for each line.
    public LX_SAP_Record_Sales_Org__c soldToObject{get;set;}
    
    /*
     * 
     * Description : Comstructor for the class.
     * Param - : None
     * Returns :  null
    */
    public customSoldToWrapper(LX_SAP_Record_Sales_Org__c soldToObject,boolean isSelected){
        this.soldToObject = soldToObject;       
        this.selected     = isSelected;
    }   
  }
  
  /* Class Name   : customZIDCWrapper
    * Description   : This is the wrapper class used to hold the ZIDC Details along with selection status for each record.
    * Created By   : Rashi J.
    * Created Date : 12-10-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Rashi J.            12-10-2013               1000                Initial Version    
    */
   public class customZIDCWrapper{
    //Boolean to let us know the 
    public Boolean selected{get;set;}
  
    //SAP sales Org object to store the Sold To Object for each line.
    public LX_SAP_Record__c ZIDCObject{get;set;}
    
    /*
     * 
     * Description : Comstructor for the class.
     * Param - : None
     * Returns :  null
    */
    public customZIDCWrapper(LX_SAP_Record__c ZIDCObject,boolean isSelected){
        this.ZIDCObject= ZIDCObject;       
        this.selected     = isSelected;
    }   
  }
}