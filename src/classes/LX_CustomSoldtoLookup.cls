/* Class Name   : LX_CustomSoldtoLookup 
    * Description   : This class is a controller for "LX_CustomSalesOrgLookup" page to provide 
    *                a selection of SAP Sales Org records and link an Opportunity to a Sold to
    * Created By   : Sumedha K.
    * Created Date : 05-08-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            05-08-2013               1000                Initial Version  
    * Sumedha K.            02-22-2014               1001                Made changes to logic to add different filter criteria for MDM account if type = 'MPS'  
    * Michael F             06-17-2014               1002                Showing errors when updating the opportunity to end users. (was just closing before)
    * Sanjay George         06-18-2014               1003                Added the page referece for Request Sold To functionality
    */
    
public with sharing class LX_CustomSoldtoLookup {

  //Decalare all the static constants for the class
  private static final string LX_ASC            = 'ASC';
  private static final string LX_DESC           = 'DESC';
  private static final string LX_SOLD           = 'SOLD';
  private static final string LX_Active         = 'Active';
  private static final string LX_MPSType        = 'MPS';
  //NJ 08/05/14 commented out
  //private static final string LeadConversionRecordTypeID = LX_SetRecordIDs.CaseLeadConversionRecordTypeId ;
  //2/26/14 VT added
  private static final string LX_Party_Role= 'MANAGED SERVICES CUSTOMER';
  //4/23/14 VT added 
  private static final string Opp_DivisionISS        = 'ISS';
  private static final string SalesTypeMPSAddOn      ='MPS Software Add On';
//////
  private static final string LX_ORDER_BY       = ' order by ';
  private static final string LX_SOLD_TO_QUERY  = 'select id, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, LX_Payment_Terms_Description__c, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where (RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_MDM_Act__c != NULL) AND (LX_Sold_To__r.LX_MDM_Act__c = \'';
  //vt 2/26: added party role condition to the end of the query 
  private static final string LX_SOLD_TO_QUERY_MPS  = 'select id, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, LX_Payment_Terms_Description__c, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_MDM_ID__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c,LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where (RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c = \'';
  private static final string LX_SOLD_TO_QUERY_MPS_ADDon  = 'select id, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, LX_Payment_Terms_Description__c, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where (RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_MDM_ID__c != NULL) AND (LX_Sold_To__r.LX_MDM_ID__c = \'';
  private static final string LX_SOLD_TO_QUERY3 ='(LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c=\'';
  private static final string LX_SOLD_TO_QUERY1 = '\' ) AND LX_Sales_Org1__c = \'';
  private static final string LX_SOLD_TO_QUERY5 = '\' AND LX_Sales_Org1__c = \'';
  private static final string LX_SOLD_TO_QUERY4 = '\') OR (LX_Sold_To__r.LX_Account__r.Global_Ultimate_D_U_N_S__c =\''; 
  private static final string LX_SOLD_TO_QUERY2 = '\' AND LX_Currency__c =\''; 
  private static final string LX_QUERY2         = '\' AND LX_Sold_To_Sales_Org__r.LX_Sales_Org1__c = \' AND LX_Sold_To__r.LX_Status__c = \''+LX_Active+'\'';
  private static final string LX_SoldtoID       = 'soldtoID';
  private static final string newSoldToPage     = '/apex/LX_Request_for_New_Bill_to_Ship_to';
  private static       string MDMAccountNo      = '';
  private static       string globalDunsNo      = '';

  public boolean isGlobalSearch {get;set;}
  public boolean showGlobalSearch {get;set;}
  private boolean IsAccountMDMized ;
  public map<string,string> MapOpptoCasePaymentTerm =  new map<string,string>{'ZN30'=>'Net 30 Days','ZN45'=>'Net 45 Days',
                                                                                          'ZCWO'=>'Cash With Order'}   ;  

  //List of Wrapper to hold the record values onto the page.
  private list<customSoldToWrapper> resultList  = new list<customSoldToWrapper>();
  // sumedha added variables to include pagination
   private list<customSoldToWrapper> totalResultList  = new list<customSoldToWrapper>();
   private list<LX_SAP_Record_Sales_Org__c> SoldTo = new list<LX_SAP_Record_Sales_Org__c>();
  
  private string selectedRecord                 = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.selectedRecord);
  // Variable to store the typeOfRecord that we have to perform the search on.      
  private string typeOfRecord                   = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.type);
  // Variable to store the AccountID for the opportunity.
  private string accountId                      = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.accountId);
  // Variable to store the Opportunity ID for the opportunity.  
  private string oppId                          = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.oppId);
  // Variable to store Sold to ID while updating Bill to and Ship to
  private string soldtoID   = '';
  // Variable to store the initialQuery String;
  private string query          = '';
  // Variable to store the condition for the query.
  private string condition      = '';         
  // Variable to store the sort direction for the columns
  private String sortDirection = 'ASC';  
  // Variable to store the field on which the sorting is going to happen.
  private String sortExp = 'name';  
  // Variable that checks if the page can be loaded correctly or not.
  public Boolean isError{get;set;}
  
  public string input1{get;set;}
  public string input2{get;set;}
  public string input3{get;set;}
  public string input4{get;set;}
  public string input5{get;set;}
  public string input6{get;set;}
  public string input7{get;set;}
  public string input8{get;set;}
  public string MDM1 {get;set;} 
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
  public LX_CustomSoldtoLookup(){
    IsAccountMDMized = false;
    showGlobalSearch = false;

    string globalSearchParam = ApexPages.currentPage().getParameters().get('global');

    if(globalSearchParam != null && globalSearchParam != '') {

        isGlobalSearch = true;
    }
    else {

        isGlobalSearch = false;
    }

    
    isError = false;
    index = 0;
    pagenum = 0;
    clicknext = FALSE; 
    DontShow = false;
    count = 1;
        String partnerAcc ='';
        
            try{
                if(oppID != NULL)
                {
                

                    // Query on the Opportunity and get all the required parameters 
                     opp = [Select ID,Name,Type,Account.MDM_ID__c,Primary_Partner__c,LX_Opportunity_Division__c,Payment_Terms__r.SAP_Code__c,Software_Solutions__c,LX_Sales_Type__c,Primary_Partner__r.MDM_ID__c,Account.Name,Opportunity.Primary_Partner__r.MDM_Account_Number__c ,Opportunity.Account.MDM_Account_Number__c,Primary_Partner__r.ParentId, AccountID,Account.ParentId,Sales_Organization__r.Sales_Organization__c,Sales_Organization__r.name, Sales_Organization_value__c,CurrencyIsoCode, Billing_Currency__c, Primary_Partner__r.Global_Ultimate_D_U_N_S__c, Account.Global_Ultimate_D_U_N_S__c from Opportunity where id =: oppID LIMIT 1];
                     opp.Name= opp.Name.remove('#');//ADDED by arun ,remove Name # chars
                     
                     if(opp.LX_Opportunity_Division__c == Opp_DivisionISS) {

                        showGlobalSearch = true;
                     }

                     List<Contact> ListContac=[select Name,Id from contact where pse__Salesforce_User__c=:UserInfo.getUserID()];
                    if(!ListContac.IsEmpty())
                     objContact=ListContac[0];
                     
                    if(opp.Primary_Partner__c!=null)
                    {
                        opp.Account.MDM_ID__c=opp.Primary_Partner__r.MDM_ID__c;
                        opp.Account.MDM_Account_Number__c=opp.Primary_Partner__r.MDM_Account_Number__c;
                        
                    }
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
                        MDMAccountNo = '';
                        globalDunsNo = '';
                        System.debug('Opp.Type>>>>>'+opp.Type);
                        //If the partner account is defined on the opportunity, then use the partner account for all the queries.
                        if(opp.Primary_Partner__c != null){
                        
                            globalDunsNo = opp.Primary_Partner__r.Global_Ultimate_D_U_N_S__c;
                            //If the Primary Partner does not have a parent account set up. Then throw an error
                            //if(opp.Primary_Partner__r.parentID != null){
                                //accountIDForSoldTo  = opp.Primary_Partner__r.parentId;
                               if(opp.Type == LX_MPSType||(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true &&opp.LX_Sales_Type__c!=SalesTypeMPSAddOn)){
                                MDMAccountNo        = opp.Primary_Partner__r.MDM_ID__c;
                              }else{
                                MDMAccountNo        = opp.Primary_Partner__r.MDM_Account_Number__c;
                              }
                            //}else{
                             //isError = true;
                             //ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Parent_Account_For_Partner);
                             //ApexPages.addMessage(message);
                            //}
                        }else{
                            globalDunsNo = opp.Account.Global_Ultimate_D_U_N_S__c;
                            //If there partner is not setup then use the account.
                            //If the Account doesnot have a parent account setup. Then throw an error.
                           //if(opp.Account.ParentId != NULL){
                             //  accountIDForSoldTo     = opp.Account.ParentId;
                            if(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true &&opp.LX_Sales_Type__c!=SalesTypeMPSAddOn){
                               MDMAccountNo         = opp.Account.MDM_ID__c;
                             }else{
                               MDMAccountNo         = opp.Account.MDM_Account_Number__c;                             
                            }
                           //}else if(opp.Account.ParentId == NULL){
                             //isError = true;
                             //ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Parent_Account);
                             //ApexPages.addMessage(message);
                           //}
                        }
                    /*
                    if(opp.Type == LX_MPSType){
                       query = LX_SOLD_TO_QUERY_MPS + LX_Party_Role+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.CurrencyIsoCode+'\'' ;
                       system.debug('@@@@@@(opp.Type'+opp.Type);
                    }else if(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true && opp.LX_Sales_Type__c!=SalesTypeMPSAddOn){
                        system.debug('Bazinga... q2');
                        query = LX_SOLD_TO_QUERY_MPS_ADDon + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.CurrencyIsoCode+'\'' ;
                    }else{
                       system.debug('Bazinga... q3');
                       query = LX_SOLD_TO_QUERY + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.CurrencyIsoCode+'\'' ;
                    }
                    */

                    if(isGlobalSearch && showGlobalSearch) {

                       if(opp.Type == LX_MPSType){
                           query = LX_SOLD_TO_QUERY_MPS + LX_Party_Role+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+LX_SOLD_TO_QUERY4+globalDunsNo+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+LX_SOLD_TO_QUERY5+opp.Sales_Organization__r.Sales_Organization__c+'\')';
                           system.debug('@@@@@@(opp.Type'+opp.Type);
                        }else if(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true && opp.LX_Sales_Type__c!=SalesTypeMPSAddOn){
                            system.debug('Bazinga... q2');
                            query = LX_SOLD_TO_QUERY_MPS_ADDon + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+LX_SOLD_TO_QUERY4+globalDunsNo+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+LX_SOLD_TO_QUERY5+opp.Sales_Organization__r.Sales_Organization__c+'\')';
                        }else{
                           system.debug('Bazinga... q3');
                           query = LX_SOLD_TO_QUERY + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+LX_SOLD_TO_QUERY4+globalDunsNo+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+LX_SOLD_TO_QUERY5+opp.Sales_Organization__r.Sales_Organization__c+'\')';
                        }
                    }
                    else {


                      if(opp.Type == LX_MPSType){
                         query = LX_SOLD_TO_QUERY_MPS + LX_Party_Role+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+'\')' ;
                         system.debug('@@@@@@(opp.Type'+opp.Type);
                      }else if(opp.LX_Opportunity_Division__c==Opp_DivisionISS && opp.Software_Solutions__c==true && opp.LX_Sales_Type__c!=SalesTypeMPSAddOn){
                          system.debug('Bazinga... q2');
                          query = LX_SOLD_TO_QUERY_MPS_ADDon + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+'\')' ;
                      }else{
                         system.debug('Bazinga... q3');
                         query = LX_SOLD_TO_QUERY + MDMAccountNo+LX_SOLD_TO_QUERY1+opp.Sales_Organization__r.Sales_Organization__c+LX_SOLD_TO_QUERY2+Opp.Billing_Currency__c+'\')' ;
                      }          
                    }
                        system.debug('query ******'+query);
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
    


  public PageReference turnOnGlobalSearch() {
      
      PageReference pr = new PageReference('/apex/LX_CustomSalesOrgLookup?accountId=' + accountId + '&selectedRecord=' + selectedRecord + '&type=' + typeOfRecord + '&oppId=' + oppId + '&global=true');
      return pr.setRedirect(true);
  }

  public PageReference turnOffGlobalSearch() {

      PageReference pr = new PageReference('/apex/LX_CustomSalesOrgLookup?accountId=' + accountId + '&selectedRecord=' + selectedRecord + '&type=' + typeOfRecord + '&oppId=' + oppId);
      return pr.setRedirect(true);
  }



    /*
     * 
     * Description : Based on the parameters selected on the page for filtering and then would construct wrapper data accordingly.
     * Param - : None
     * Returns :  null
    */
    public PageReference viewSoldToData() {
        
        

        system.debug('query ******'+query);
        system.debug('globalsearch **********'+isGlobalSearch);

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
            Soldto = Database.query(finalQuery   + LX_ORDER_BY + sortFullExp + '');
            totalRecords = SoldTo.size();
            system.debug('size@@'+totalRecords );
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
        /*  commented by sumedha to call the same logic from a common method "search method"
        resultList = new list<customSoldToWrapper>();
            resultList.clear();
                
            //Iterate over the queried records and generate the wrapper list to be displayed on the page.
            for(LX_SAP_Record_Sales_Org__c org :SoldTo){
                // If the record is a selected record then ensure that the checked record is selected.
                if(selectedRecord != '' && selectedRecord != null && org.id == selectedRecord){
                    resultList.add(new customSoldToWrapper(org,true));
                }else
                    resultList.add(new customSoldToWrapper(org,false));
                }
         */
        searchdata();
            }catch (exception ex){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_UnknownError);       
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
    public boolean dmlSuccess {get{if(dmlSuccess==null) dmlSuccess=false; return dmlSuccess;}set;}  
    public pageReference updateOpp(){
        string selectedID = null;
        //Loop over the Displayed Wrapper list and find the selected Sold To ID
        for(customSoldToWrapper wrap :resultList){
            if(wrap.selected == true){
                // Assign the selected Sold To Record ID to the selectedID variavle.
                selectedID = wrap.soldToObject.id;
                break;
            }
        }
        //Creat a new Opportunity and assign the selected Sold To to the opportunity.
        Opportunity opp;
        opp = new Opportunity (id = oppId , LX_Sold_To_New__c = selectedID);
        try{       
            update opp;
            dmlSuccess =true;
        }catch(DMLException ex){
            dmlSuccess =false;
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR, ex.getDMLmessage(0));
            ApexPages.addMessage(message);
            // Log the error in the common utilities class
            LX_CommonUtilities.createExceptionLog(ex);
            
        }catch(Exception ex){
            dmlSuccess =false;
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR, Label.LX_UnknownError + ' ' + ex.getmessage());
            ApexPages.addMessage(message);

            // Log the error in the common utilities class
            LX_CommonUtilities.createExceptionLog(ex);
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
    public Pagereference Go(){
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
     * Description : This method just refreshes/rerenders the page. 
     * Param - : None
     * Returns : Null
    */
      public Pagereference Cancel(){
        return null;
      }
      
     /*
     USI Update: 06/18
     Function Name: requestSoldTo
     Description : This method redirects user to Case creation page, prepopulating the known values.
     */
    public PageReference requestSoldTo(){
        Account objAcct = [SELECT Name, MDM_ID__c from Account where ID =:opp.Accountid];
            if(objAcct!= null){ 
                 if(objAcct.MDM_ID__c!=null){
                     IsAccountMDMized = true;
                 }
             }
       
        if(!IsAccountMDMized){
            isError = true;
             ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.SoldTo_Account_NonMDMized);
             ApexPages.addMessage(message);
             return null; 
        }
        //NJ 08/05/14
        //List<Case> CaseList = [Select id from Case where RecordTypeid=:LeadConversionRecordTypeID  AND LX_Opportunity__c=:Opp.id AND LX_Sold_To_Number_Request_Status__c='Submitted to MDM' and status!='Closed'];
        List<Case> CaseList = [Select id from Case where LX_Opportunity__c=:Opp.id AND LX_Sold_To_Number_Request_Status__c='Submitted to MDM' and status!='Closed'];
        //System.debug('%%%%%%%%%%%%%%%%%%%%%%'+Sp.size()); 
           
       /* If(ls!=null &&ls[0].LX_Sold_to_Status__c!='Submitted to MDM'&& Sp.size() > 0 )
        {
          String sold='/500/e?CF'+Label.LX_CaseOpportunityID+'='+encodingUtil.urlencode(opp.Name,'UTF-8')+'&CF’+Label.LX_CaseOpportunityID+’_lkid='+Opp.id + '&' + Label.LX_Case_Subject+ '=Sold To request for Opportunity'+ EncodingUtil.urlEncode(opp.Name, 'UTF-8') + '&retURL=%2F' + opp.Id + '&' +Label.LX_Case_Internal_Account+ '_lkid=' +opp.Account.Id+ '&'+ Label.LX_Case_Contact_Name+'=' + EncodingUtil.urlEncode(objContact.Name, 'UTF-8') + '&' +Label.LX_Case_Contact_Name+ '=_lkid' +objContact.Id+ '&RecordType='+Label.LX_Case_SoldTo_RecordTypeId+'&ent=Case&'+Label.LX_Case_Request_Change+'=<h3>Create Sold To:</h3><table width=600 border=1><tr><th width=200>Opportunity</th><td><a href=\'/'+opp.Id+'\' >'+encodingUtil.urlencode(opp.Name,'UTF-8')+'</a></td></tr><tr><th>MDM ID</th><td>'+opp.Account.MDM_ID__c+'</td></tr><tr><th>MDM Account Number</th><td>'+opp.Account.MDM_Account_Number__c+'</td></tr><tr><th>Currency</th><td>'+opp.CurrencyIsoCode+'</td></tr><tr><th>Sales Organization</th><td>'+opp.Sales_Organization_value__c+'</td></tr><tr><th>Payment Terms</th><td></td></tr><tr><th>Requestor</th><td><a href=\'/'+User.Id+'\' >'+Userinfo.getFirstName()+'%20'+Userinfo.getLastName()+'</a></td></tr><tr><th>Salesperson Notes</th><td></td></tr></table>';
           PageReference PageRef  = new PageReference ('/'+ sold);
          
           //update opp;
           return PageRef;
        }*/
        
        
        if( CaseList!=null&& CaseList.Size()>0 ){  
        
           // PageReference PageRef  = new PageReference ();
            // PageRef.setredirect(false);
                              isError = true;
                             ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.Sold_to_Status_Submitted);
                             ApexPages.addMessage(message);
             return null; 
        }
        else{
            
            String caseExtn='500/e?'+Label.LX_Case_Subject+'=Sold To request for Opportunity ['+ EncodingUtil.urlEncode(opp.Name, 'UTF-8') + ']&cas4=' + EncodingUtil.urlEncode(opp.Account.Name, 'UTF-8') + '&cas4_lkid=' + opp.Account.Id + '&CF' + Label.LX_Case_Opportunity_Field + '=' + EncodingUtil.urlEncode(opp.Name, 'UTF-8') + '&CF' + Label.LX_Case_Opportunity_Field + '_lkid=' + opp.Id + '&' + Label.LX_Case_Type + '='+Label.LX_Lead_Conversion_Status_MDMSoldTo+'&retURL=%2F' + opp.Id + '&' + Label.LX_Case_Contact_Name + '=' + objContact.Name + '&' + Label.LX_Case_Contact_Name + '_lkid=' + objContact.Id + '&RecordType=' + Label.LX_Lead_Conversion_Record_TypeId + '&' + Label.LX_MDM_Account_Request_Status + '=Not Submitted to MDM' + '&cas24=' + opp.Billing_Currency__c + '&' + Label.LX_Case_Sold_To_Number_Request_Status + '=Submitted to MDM&ent=Case &CF00Nf0000000rdgb='+EncodingUtil.urlEncode(opp.Sales_Organization__r.name, 'UTF-8')+'&CF00Nf0000000rdgb_lkid='+EncodingUtil.urlEncode(opp.Sales_Organization__c,'UTF-8')+'&cas11='+EncodingUtil.urlEncode('Opportunity', 'UTF-8');
            
            //Form the URl with address params US:4252
            Account objAcc = [SELECT Name, BillingStreet,BillingCity,BillingState,BillingPostalCode, Physical_Country__c from Account where ID =:opp.Accountid];
            system.debug('----->'+objAcc);
            if(objAcc != null){ 
             
             string strTempStreet = objAcc.BillingStreet != null ? objAcc.BillingStreet: '';
             string strTempCity = objAcc.BillingCity != null ? objAcc.BillingCity : ''; 
             string strTempState = objAcc.BillingState != null ? objAcc.BillingState : '';
             string strTempPostalCode = objAcc.BillingPostalCode != null ? objAcc.BillingPostalCode : '';
             string strTempCountry = objAcc.Physical_Country__c != null ? objAcc.Physical_Country__c: '';
             string strTempAcctName = objAcc.Name != null ? objAcc.Name : '';
             string strAddrURLParams = '&'+Label.LeadConv_ContactName+'='+  strTempAcctName +
                                       '&'+Label.LeadConv_PhysicalStreetAddress+'='+ strTempStreet+
                                       '&'+Label.LeadConv_PhysicalCity+'='+strTempCity+
                                       '&'+Label.LeadConv_PhysicalState+'='+strTempState+
                                       '&'+Label.LeadConv_PhysicalPostalCode+'='+strTempPostalCode+
                                       '&'+Label.LeadConv_PhysicalCountry+'='+strTempCountry;
 
             system.debug('----->'+strAddrURLParams);
             caseExtn = caseExtn + strAddrURLParams;
              system.debug('----->'+caseExtn); 
             }
            
            if(opp.Payment_Terms__c!=null){
                caseExtn += '&00Ni00000070gFD='+MapOpptoCasePaymentTerm.get(opp.Payment_Terms__r.SAP_Code__c);
            }
          PageReference PageRef  = new PageReference ('/'+caseExtn);
         
              return PageRef; 
           
        }   
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
  
  /* getter method for the resultList variable
  */
  public list<customSoldToWrapper> getresultList(){
    return this.resultList;
  }
  
    /* Class Name   : customSoldToWrapper
    * Description   : This is the wrapper class used to hold the SOld To Details alsong with selction status for each record.
    * Created By   : Sumedha K.
    * Created Date : 05-08-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            05-08-2013               1000                Initial Version    
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
}