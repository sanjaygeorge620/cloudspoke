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
        
    public with sharing class LX_CustomSoldtoLookupRMA {

      //Decalare all the static constants for the class
      private static final string LX_ASC            = 'ASC';
      private static final string LX_DESC           = 'DESC';
      private static final string LX_SOLD           = 'SOLD';
      private static final string LX_Active         = 'Active';
      private static final string LX_MPSType        = 'MPS';
      private static final string LeadConversionRecordTypeID = LX_SetRecordIDs.CaseLeadConversionRecordTypeId ;
      //2/26/14 VT added
      private static final string LX_Party_Role= 'MANAGED SERVICES CUSTOMER';
      //4/23/14 VT added 
      private static final string Opp_DivisionISS        = 'ISS';
      private static final string SalesTypeMPSAddOn      ='MPS Software Add On';
    //////
      private static final string LX_ORDER_BY       = ' order by ';
      private static final string LX_SOLD_TO_QUERY  = 'select id, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, LX_Payment_Terms_Description__c, LX_Sold_To__r.Name,LX_Sold_To__r.LX_Name__c,LX_Sold_To__r.LX_Account__r.Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Default_Payment_Terms__c,LX_Sold_To__r.LX_Currency__c,  LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' AND LX_Status__c=\''+LX_Active+'\' AND (LX_Sold_To__r.LX_MDM_Act__c != NULL) AND ';
      //vt 2/26: added party role condition to the end of the query 
      private static final string LX_SOLD_TO_QUERY3 ='(LX_Sold_To__r.LX_Party_Role_Formula_Hidden__c=\'';
      private static final string LX_SOLD_TO_QUERY1 = '\' ) AND LX_Sales_Org1__c = \'';
      private static final string LX_SOLD_TO_QUERY4 = '\') OR LX_Sold_To__r.LX_Account__r.Global_Ultimate_D_U_N_S__c =\''; 
      private static final string LX_SOLD_TO_QUERY2 = '\' AND LX_Currency__c =\''; 
      private static final string LX_QUERY2         = '\' AND LX_Sold_To_Sales_Org__r.LX_Sales_Org1__c = \' AND LX_Sold_To__r.LX_Status__c = \''+LX_Active+'\'';
      private static final string LX_SoldtoID       = 'soldtoID';
      private static final string newSoldToPage     = '/apex/LX_Request_for_New_Bill_to_Ship_to';
      private static       string MDMAccountNo      = '';
      private static       string globalDunsNo      = '';
      private string selectedRecord                 = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.selectedRecord);
      
      public map<string,string> MapOpptoCasePaymentTerm =  new map<string,string>{'ZN30'=>'Net 30 Days','ZN45'=>'Net 45 Days',
                                                                                              'ZCWO'=>'Cash With Order'}   ;  

      public string CaseExtn{get;set;}
      //List of Wrapper to hold the record values onto the page.
      private list<customSoldToWrapper> resultList  = new list<customSoldToWrapper>();
      // sumedha added variables to include pagination
       private list<customSoldToWrapper> totalResultList  = new list<customSoldToWrapper>();
       private list<LX_SAP_Record_Sales_Org__c> SoldTo = new list<LX_SAP_Record_Sales_Org__c>();


      // Variable to store the Opportunity ID for the opportunity.  
      private string accountID;
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
      public RMAController RMArecord = new RMAController();
      Public Account acctRec ;
      Public LX_RMA__C RMAStanRecord = new LX_RMA__C();
      Public Boolean formRender {get;set;}


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


        Public LX_CustomSoldtoLookupRMA(RMAController cnt)
        {
            this.RMArecord = cnt;
        }
        
        Public LX_CustomSoldtoLookupRMA(Apexpages.StandardController controller)
        {   
            formRender = true;
            this.RMAStanRecord = (LX_RMA__C)controller.getrecord();
        }
        
        Public Pagereference viewPage()
        {
            ID id = Apexpages.currentpage().getparameters().get('id');
            Pagereference detailPage = new Pagereference('/apex/RMAdetailPage?id='+id);
            detailPage.setredirect(true);
            return detailPage;
        }
        
        Public Pagereference editPage()
        {   
            system.debug('***************************************'+RMArecord.recordRMA.LX_RMA_Submitted__c);
            system.debug('***************************************'+RMArecord.profileCheck);
            if(RMArecord.recordRMA.LX_RMA_Submitted__c && (!(RMArecord.profileCheck)))
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'The record is submitted and do not have the approriate permission to edit the record.'));
                formRender =false;
                return null;
            }
            else
            {
                ID id = Apexpages.currentpage().getparameters().get('id');
                Pagereference editPage = new Pagereference('/apex/RMAeditPage?id='+id+'&mode=edit');
                editPage.setredirect(true);
                return editPage;
            }
        }
        
        Public Pagereference newPage()
        {
            //ID id = Apexpages.currentpage().getparameters().get('id');
            Pagereference newPage = new Pagereference('/apex/RMAeditPage?mode=new');
            newPage.setredirect(true);
            return newPage;
        }
        
        
        Public pagereference soldTo()
        {
            
            
            if(RMArecord.recordRMA.LX_account__C!=null)
            {
            Pagereference pg1 = new pagereference('/apex/LX_CustomSoldToRMA?accountID='+ RMArecord.recordRMA.LX_Account__c);
            pg1.setredirect(false);
            return pg1;
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Account before adding Sold To'));
                return null;
            }
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
      public void onload(){

        isError = false;
        index = 0;
        pagenum = 0;
        clicknext = FALSE; 
        DontShow = false;
        count = 1;
            String partnerAcc ='';
            
                try{
                accountID= ApexPages.currentPage().getParameters().get('accountID');
                system.debug('Accountid----->'+accountID);
                       List<account> acctReclist;
                        //If there is no Account associated to the opportunity, throw an error.
                        if(accountID == null){
                                 isError = true;
                                 ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Account_Error);
                                 ApexPages.addMessage(message);
                        }
                        else
                        //Query Account for the required fields
                        acctReclist =[Select id,MDM_Account_Number__c,CurrencyIsoCode, LX_Country_Code__c from account where id =:accountID limit 1];
                     
                        
                        if(acctReclist!=null&&acctReclist.size()>0){
                        //Check on the type of the RecordType and then construct the query.
                            acctRec = acctReclist[0];
                           query = LX_SOLD_TO_QUERY + 'LX_Sold_To__r.LX_MDM_Act__c=\''+acctRec.MDM_Account_Number__c+'\'' ;
                           
                        }
                        else{
                            isError=true;
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
                   
              system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+finalquery);  
            try{  
                // Created this query for testdata  
                //list<LX_SAP_Record_Sales_Org__c> testData = [select RecordType.DeveloperName,LX_Sold_To__r.LX_Account__c,LX_Sales_Org1__c, LX_Currency__c from LX_SAP_Record_Sales_Org__c];
                    
                //Query for the Sold To based on the values.
                system.debug('Final Query----->'+finalQuery   + LX_ORDER_BY + sortFullExp + '');
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
          public pagereference updateopp(){
          
          return null;
          }
          
          
          
        public pageReference updateRMAEdit(){
            string selectedID = null;
            LX_SAP_Record_Sales_Org__c soldToNum;
            //Loop over the Displayed Wrapper list and find the selected Sold To ID
            if(resultList!=null&&resultList.size()>0){
                for(customSoldToWrapper wrap :resultList){
                    if(wrap.selected == true){
                        // Assign the selected Sold To Record ID to the selectedID variavle.
                        selectedID = wrap.soldToObject.id;
                        soldToNum  = wrap.soldToObject;
                        System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+selectedID);
                        break;
                        
                    }
                }
            }
            else{
                                 isError = true;
                                 ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'No Results were found for the Query');
                                 ApexPages.addMessage(message);
            
            }
            //Assign the selected record to RMA record.
            
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^'+RMArecord.recordRMA);
            RMArecord.recordRMA.put('LX_Sold_To_New__c',soldToNum.id);
            RMArecord.recordRMA.put('LX_Sold_To_ID__c',soldToNum.LX_Sold_To__r.LX_Sold_To_ID__c );
            Pagereference pg =new Pagereference('/apex/RMAEditpage?id='+RMArecord.recordRMA.id);
            
            pg.setredirect(false);
            System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&'+pg);
            return pg;
        }
        
        /*
         * 
         * Description : This method is called on the load of the page to ask the user to rectify any errors that are there on the page.
         * Param - : None
         * Returns : Null
        */
        /* public pageReference onLoad(){
            if(isError){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_Rectify_Error);
                ApexPages.addMessage(message);
             }   
            return null;
        } */
      
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
      public void requestSoldTo(){
           
            //String ;
            Contact con= new contact();
            List<Case> CaseList = [Select id from Case where RecordTypeid=:LeadConversionRecordTypeID  AND accountid=:accountID AND LX_Sold_To_Number_Request_Status__c='Submitted to MDM' and status!='Closed'];
            //System.debug('%%%%%%%%%%%%%%%%%%%%%%'+Sp.size()); 
            List<User> UsrList =[select email, id from user where id=:UserInfo.getUserid()];  
            if(UsrList!=null&&UsrList.size()>0){
            List <Contact> ConList = [select id, Name from Contact where email=:UsrList[0].email AND RecordType.Name = 'Resource contact'];
            con = ConList [0];
            }
            List<Sales_Organization__c> SalesOrgList = [Select id,Name,LX_Country_Code__c,Status__c from Sales_Organization__c where LX_Country_Code__c=:acctRec.LX_Country_Code__c and Status__c='Active' AND LX_Default__c=true];
            
            
            if( CaseList!=null&& CaseList.Size()>0 ){  
            
               // PageReference PageRef  = new PageReference ();
                // PageRef.setredirect(false);
                                  isError = true;
                                 ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.Sold_to_Status_Submitted);
                                 ApexPages.addMessage(message);
                // return null; 
            }
            else{
                
                caseExtn='/500/e?retURL=%2F'+acctRec.Id+'&RecordType='+LeadConversionRecordTypeID +'&ent=Case&cas4_lkid='+acctRec.Id+'&'+Label.LX_MDM_Account_Request_Status+'='+Label.Lead_Conversion_Status_NotSubmitted+'&'+Label.LX_Case_Subject+'=Sold To request for Account&cas5='+Label.LX_Case_SFDC_Account_with_Sold_To+'&cas11=Account&cas24='+acctRec.CurrencyIsoCode;
                system.debug('caseExtn ---->'+caseExtn );
                if(Con!=null){
                    caseExtn +=+'&'+Label.LX_Case_Contact_Name+'_lkid='+Con.id;
                }
                if(SalesOrgList!=null&&SalesOrgList.size()>0){
                    caseExtn += '&CF+Label.LX_Sales_Org_Country_Case+_lkid='+SalesOrgList[0].id+'&CF+Label.LX_Sales_Org_Country_Case='+SalesOrgList[0].Name;
                }
                system.debug('caseExtn ---->'+caseExtn );
            }
              PageReference PageRef  = new PageReference ('/'+caseExtn);
             
                  //return PageRef; 
               
            }   
        
       
      
        /*
         * 
         * Description : This method just refreshes/rerenders the page. 
         * Param - : None
         * Returns : PageReference to the new create Bill To Ship To Page.
        */
    /*  public Pagereference createSoldto(){
        
        //create a page reference for the New Sold To page.  
        Pagereference pg = new Pagereference(newSoldToPage); // '/apex/LX_Request_for_New_Bill_to_Ship_to?oppId='+oppId+'&type='+type);
        
        //put the relevant parameters in the url
        pg.getParameters().put(LX_OpportunityHelper.oppId,oppId);
        pg.getParameters().put(LX_OpportunityHelper.type,typeOfRecord);
        pg.setredirect(true); 
        return pg;
      } */
     
      
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