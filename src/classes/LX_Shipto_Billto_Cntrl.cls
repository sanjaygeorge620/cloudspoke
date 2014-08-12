/* Class Name   : LX_Shipto_Billto_Cntrl  
    * Description : This class is the controller for the Bill To/ Ship To selection page.
    * Created By   : Sumedha K./ Rahul Raghunathan
    * Created Date : 05-16-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            05-16-2013               1000                Initial Version    
    * Arun thakur           08-29-2013              M-00325             SYNC with DATA1A
    */
    


public with sharing class LX_Shipto_Billto_Cntrl{

  //Decalare all the static constants for the class
  private list<searchClass> allSapValues = new list<searchClass>();    
 
  transient private LX_ShiptoBillto_Stub.BillToShipToWSOutput stubOutput;
  public boolean shipMore {get;set;}
  public boolean billMore {get;set;}
  
  // Hardcoded list for testing
  public List<LX_shipbillWrapper> wrap{get;set;}
  public List<LX_shipbillWrapper> wrap1{get;set;}
  // to be deleted
  public List<LX_shipbillWrapper> res{get;set;}
  public List<LX_shipbillWrapper> res1{get;set;}
  public Boolean Filter1{get;set;}

  public Boolean Filter{get;set;}
  public Boolean saveBill{get;set;}
  public Boolean saveShip{get;set;}
  public boolean isInitial{get;set;}
  //Decalare all the static constants for the class
  private static final string LX_ASC                = 'ASC';
  private static final string LX_DESC               = 'DESC';
  private static final string LX_SELL               = 'SELL';
  private static final string LX_BILL               = 'BILL';
  private static final string LX_SHIP               = 'SHIP';  
  private static final string LX_DEFAULT            = 'default';  
  private static final string LX_TRUE               = 'true';
  private static final string LX_CERTIFACTELOC      = '/resource/Certificate_SAP';
  private static final integer LX_DEFAULTPAGESIZE   = 50;
  private static final string newSoldToPage         = '/apex/LX_Request_for_New_Bill_to_Ship_to';
  private static LX_SAP_Integration__c sapCredentials = LX_SAP_Integration__c.getValues('Bill To Ship To');
  //Deaclare all the constants for the input fields and variables.
  private static final string LX_INPUT1     = 'input1';
  private static final string LX_INPUT2     = 'input2';
  private static final string LX_INPUT3     = 'input3';
  private static final string LX_INPUT4     = 'input4';
  private static final string LX_INPUT5     = 'input5';
  private static final string LX_INPUT6     = 'input6';
  private static final string LX_INPUT7     = 'input7';
  private static final string LX_INPUT8     = 'input8';
  private static final string LX_INPUT9     = 'input9';
  private static final string LX_INPUT10    = 'input10';

  private static final string LX_BILLTONAME             = 'billToName';
  private static final string LX_BILLTOCOMPANY          = 'billToCompany';
  private static final string LX_BILLTOADDRESS1         = 'billToAddress';
  private static final string LX_BILLTOADDRESS2         = 'billToAddress2';
  private static final string LX_BILLTOCITY             = 'billToCity';
  private static final string LX_BILLTOSTATEORPROVINCE  = 'billToStateOrProvince';
  private static final string LX_BILLTOPOSTALCODE       = 'billToPostalCode';
  private static final string LX_BILLTOCOUNTRY          = 'billToCountry';
  private static final string LX_BILLTOID               = 'billToID';
  private static final string LX_BILLTOEMAILID          = 'billToEmailID';

  
  private static final string LX_SHIPTONAME             = 'shipToName';
  private static final string LX_SHIPTOCOMPANY          = 'shipToCompany';
  private static final string LX_SHIPTOADDRESS          = 'shipToAddress';
  private static final string LX_SHIPTOADDRESS2         = 'shipToAddress2';
  private static final string LX_SHIPTOCITY             = 'shipToCity';
  private static final string LX_SHIPTOSTATEORPROVINCE  = 'shipToStateOrProvince';
  private static final string LX_SHIPTOPOSTALCODE       = 'shipToPostalCode';
  private static final string LX_SHIPTOCOUNTRY          = 'shipToCountry';
  private static final string LX_SHIPTOID               = 'shipToID';
  private static final list<String> exceptionList       = new list<string>{'ALL_OR_NONE_OPERATION_ROLLED_BACK','ALREADY_IN_PROCESS','ASSIGNEE_TYPE_REQUIRED','BAD_CUSTOM_ENTITY_PARENT_DOMAIN','BCC_NOT_ALLOWED_IF_BCC_COMPLIANCE_ENABLED','BCC_SELF_NOT_ALLOWED_IF_BCC_COMPLIANCE_ENABLED','CANNOT_CASCADE_PRODUCT_ACTIVE','CANNOT_CHANGE_FIELD_TYPE_OF_APEX_REFERENCED_FIELD','CANNOT_CREATE_ANOTHER_MANAGED_PACKAGE','CANNOT_DEACTIVATE_DIVISION','CANNOT_DELETE_LAST_DATED_CONVERSION_RATE','CANNOT_DELETE_MANAGED_OBJECT','CANNOT_DISABLE_LAST_ADMIN','CANNOT_ENABLE_IP_RESTRICT_REQUESTS','CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY','CANNOT_MODIFY_MANAGED_OBJECT','CANNOT_RENAME_APEX_REFERENCED_FIELD','CANNOT_RENAME_APEX_REFERENCED_OBJECT','CANNOT_REPARENT_RECORD','CANNOT_RESOLVE_NAME','CANNOT_UPDATE_CONVERTED_LEAD','CANT_DISABLE_CORP_CURRENCY','CANT_UNSET_CORP_CURRENCY','CHILD_SHARE_FAILS_PARENT','CIRCULAR_DEPENDENCY','COMMUNITY_NOT_ACCESSIBLE','CUSTOM_CLOB_FIELD_LIMIT_EXCEEDED','CUSTOM_ENTITY_OR_FIELD_LIMIT','CUSTOM_FIELD_INDEX_LIMIT_EXCEEDED','CUSTOM_INDEX_EXISTS','CUSTOM_LINK_LIMIT_EXCEEDED','CUSTOM_TAB_LIMIT_EXCEEDED','DELETE_FAILED','DEPENDENCY_EXISTS','DUPLICATE_CASE_SOLUTION','DUPLICATE_CUSTOM_ENTITY_DEFINITION','DUPLICATE_CUSTOM_TAB_MOTIF','DUPLICATE_DEVELOPER_NAME','DUPLICATE_EXTERNAL_ID','DUPLICATE_MASTER_LABEL','DUPLICATE_SENDER_DISPLAY_NAME','DUPLICATE_USERNAME','DUPLICATE_VALUE','EMAIL_NOT_PROCESSED_DUE_TO_PRIOR_ERROR','EMPTY_SCONTROL_FILE_NAME','ENTITY_FAILED_IFLASTMODIFIED_ON_UPDATE','ENTITY_IS_ARCHIVED','ENTITY_IS_DELETED','ENTITY_IS_LOCKED',' ENVIRONMENT_HUB_MEMBERSHIP_CONFLICT','ERROR_IN_MAILER','FAILED_ACTIVATION','FIELD_CUSTOM_VALIDATION_EXCEPTION','FIELD_FILTER_VALIDATION_EXCEPTION','FILTERED_LOOKUP_LIMIT_EXCEEDED','HTML_FILE_UPLOAD_NOT_ALLOWED','IMAGE_TOO_LARGE','INACTIVE_OWNER_OR_USER','INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY','INSUFFICIENT_ACCESS_OR_READONLY','INVALID_ACCESS_LEVEL','INVALID_ARGUMENT_TYPE','INVALID_ASSIGNEE_TYPE','INVALID_ASSIGNMENT_RULE','INVALID_BATCH_OPERATION','INVALID_CONTENT_TYPE','INVALID_CREDIT_CARD_INFO','INVALID_CROSS_REFERENCE_KEY','INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD','INVALID_CURRENCY_CONV_RATE','INVALID_CURRENCY_CORP_RATE','INVALID_CURRENCY_ISO','INVALID_EMAIL_ADDRESS','INVALID_EMPTY_KEY_OWNER','INVALID_FIELD','INVALID_FIELD_FOR_INSERT_UPDATE','INVALID_FIELD_WHEN_USING_TEMPLATE','INVALID_FILTER_ACTION','INVALID_ID_FIELD','INVALID_INET_ADDRESS','INVALID_LINEITEM_CLONE_STATE','INVALID_MASTER_OR_TRANSLATED_SOLUTION','INVALID_MESSAGE_ID_REFERENCE','INVALID_OPERATION','INVALID_OPERATOR','INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST','INVALID_PARTNER_NETWORK_STATUS','INVALID_PERSON_ACCOUNT_OPERATION','INVALID_READ_ONLY_USER_DML','INVALID_SAVE_AS_ACTIVITY_FLAG','INVALID_SESSION_ID','INVALID_STATUS','INVALID_TYPE','INVALID_TYPE_FOR_OPERATION','INVALID_TYPE_ON_FIELD_IN_RECORD','IP_RANGE_LIMIT_EXCEEDED','LICENSE_LIMIT_EXCEEDED','LIGHT_PORTAL_USER_EXCEPTION','LIMIT_EXCEEDED','LOGIN_CHALLENGE_ISSUED','LOGIN_CHALLENGE_PENDING','LOGIN_MUST_USE_SECURITY_TOKEN','MALFORMED_ID','MANAGER_NOT_DEFINED','MASSMAIL_RETRY_LIMIT_EXCEEDED','MASS_MAIL_LIMIT_EXCEEDED','MAXIMUM_CCEMAILS_EXCEEDED','MAXIMUM_DASHBOARD_COMPONENTS_EXCEEDED','MAXIMUM_HIERARCHY_LEVELS_REACHED','MAXIMUM_SIZE_OF_ATTACHMENT','MAXIMUM_SIZE_OF_DOCUMENT','MAX_ACTIONS_PER_RULE_EXCEEDED','MAX_ACTIVE_RULES_EXCEEDED','MAX_APPROVAL_STEPS_EXCEEDED','MAX_FORMULAS_PER_RULE_EXCEEDED','MAX_RULES_EXCEEDED','MAX_RULE_ENTRIES_EXCEEDED','MAX_TASK_DESCRIPTION_EXCEEDED','MAX_TM_RULES_EXCEEDED','MAX_TM_RULE_ITEMS_EXCEEDED','MERGE_FAILED','MISSING_ARGUMENT','NONUNIQUE_SHIPPING_ADDRESS','NO_APPLICABLE_PROCESS','NO_ATTACHMENT_PERMISSION','NO_INACTIVE_DIVISION_MEMBERS','NO_MASS_MAIL_PERMISSION','NUMBER_OUTSIDE_VALID_RANGE','NUM_HISTORY_FIELDS_BY_SOBJECT_EXCEEDED','OP_WITH_INVALID_USER_TYPE_EXCEPTION','OPTED_OUT_OF_MASS_MAIL','PACKAGE_LICENSE_REQUIRED','PORTAL_USER_ALREADY_EXISTS_FOR_CONTACT','PRIVATE_CONTACT_ON_ASSET','RECORD_IN_USE_BY_WORKFLOW','REQUEST_RUNNING_TOO_LONG','REQUIRED_FIELD_MISSING','SELF_REFERENCE_FROM_TRIGGER','SINGLE_EMAIL_LIMIT_EXCEEDED','STANDARD_PRICE_NOT_DEFINED','STORAGE_LIMIT_EXCEEDED','STRING_TOO_LONG','TABSET_LIMIT_EXCEEDED','TEMPLATE_NOT_ACTIVE','TERRITORY_REALIGN_IN_PROGRESS','TEXT_DATA_OUTSIDE_SUPPORTED_CHARSET','TOO_MANY_APEX_REQUESTS','TOO_MANY_ENUM_VALUE','TRANSFER_REQUIRES_READ','UNABLE_TO_LOCK_ROW','UNDELETE_FAILED','UNKNOWN_EXCEPTION','UNSPECIFIED_EMAIL_ADDRESS','UNSUPPORTED_APEX_TRIGGER_OPERATION','UNVERIFIED_SENDER_ADDRESS','WEBLINK_ouSIZE_LIMIT_EXCEEDED','WEBLINK_URL_INVALID','WRONG_CONTROLLER_TYPE'};

    
  // Variable to store the sort direction for the columns
  private String sortDirection = 'ASC';  
  // Variable to store the field on which the sorting is going to happen.
  private String sortExp = 'BillShipID';


  public string operationType {get;set;}
  
  // Variable to store wrapper class value
  public List<LX_ShipBillWrapper> shipToWrapper{get;set;}
  // Variable to store wrapper class value
  public List<LX_ShipBillWrapper> billToWrapper{get;set;}
  //Variable to store Opportunity list to be displayed on VF page
  public List<Opportunity> oppList{get;set;}
  //Variable to store project list to be displayed on VF page  
  public pse__Proj__c project;

  // Variable to store the Opportunity ID for the Bill To/Ship To operations.  
  private string oppId = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.oppId);
  // Variable to store the type of operation.  
  private string typeofRecord= ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.type);
  // Variable to store the project ID for the Bill To/Ship To operations
  private string projId = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.projID);
  // Variable to store the new Order Request ID for the Bill To/Ship To operations
  public string newOrderId{get;set;} 
  private string newOrderOppId = ApexPages.currentPage().getParameters().get('opp');  

  public Boolean sellButton {get;set;}
  
  //List of input variables that would be used to get the filter the outputs.     
  public string input1{get;set;}
  public string input2{get;set;}
  public string input3{get;set;}
  public string input4{get;set;}
  public string input5{get;set;}
  public string input6{get;set;}
  public string input7{get;set;}
  public string input8{get;set;}
  public string input9{get;set;}  
  public string input10{get;set;}
  

 // Map variables to store the search paramter variable name from stub class
  private Map<String,String> billsearch;
  private Map<String,String> shipsearch;
  // Map to store the input parameters entered
  private Map<String,String> inputParams;
  public opportunity opp1{get;set;}  
  public Boolean isError{get;set;}
  public string BillToShipToRequestURL{get;set;}
  public string retURL{get;set;}
 public Contact objContact {get; set;}
    /*
     * 
     * Description : Constructor method for the LX_Shipto_Billto_Cntrl class.
     * Param - : None.
     * Returns : null
    */
    public LX_Shipto_Billto_Cntrl(){
    operationType = '';
    newOrderId = ApexPages.currentPage().getParameters().get(LX_OpportunityHelper.newOrderID);  
    
    //If new order request id is passed then its a new order bill to ship to transaction. else it is a opportunity/project bill to ship transaction. 
    if(newOrderId != null){
            operationType = LX_New_Order_Request__c.sObjectType.getDescribe().getLabel();
    }else{
        //If project id is passed then its a project bill to ship to transaction. else it is a opportunity bill to ship transaction. 
        if(projId != null){
            operationType = pse__Proj__c.sObjectType.getDescribe().getLabel();
        }else if(oppId != null){
            operationType = Opportunity.sObjectType.getDescribe().getLabel();
        }
    }


    //initialise all the flags;  
    billmore = false;
    shipmore = false;
    isInitial = true;
    isError = false;
    saveBill=false;
    saveShip=false;

    //depending on the type of the opertion initialise create Bill To or create Ship To button.
    if(typeofRecord == LX_SELL){
        sellButton = TRUE;
    }else if(typeofRecord == LX_BILL){
        sellButton = FALSE;
    }


    // Map variable storing search criteria variable to be searched
    billsearch = new Map<String,String>{LX_INPUT1 => LX_BILLTONAME,LX_INPUT2 => LX_BILLTOCOMPANY,LX_INPUT3 => LX_BILLTOADDRESS1,LX_INPUT4 => LX_BILLTOADDRESS2,LX_INPUT5 => LX_BILLTOCITY,LX_INPUT6 => LX_BILLTOSTATEORPROVINCE,LX_INPUT7 => LX_BILLTOPOSTALCODE,LX_INPUT8 => LX_BILLTOCOUNTRY,LX_INPUT9 => LX_BILLTOID,LX_INPUT10 => LX_BILLTOEMAILID};
    shipsearch = new Map<String,String>{LX_INPUT1 => LX_SHIPTONAME,LX_INPUT2 => LX_SHIPTOCOMPANY,LX_INPUT3 => LX_SHIPTOADDRESS,LX_INPUT4 => LX_SHIPTOADDRESS2,LX_INPUT5 => LX_SHIPTOCITY,LX_INPUT6 => LX_SHIPTOSTATEORPROVINCE,LX_INPUT7 => LX_SHIPTOPOSTALCODE,LX_INPUT8 => LX_SHIPTOCOUNTRY,LX_INPUT9 => LX_SHIPTOID};
    billToWrapper = new List<LX_ShipBillWrapper>();
  
    //Query on Opportunity and get all the fields needed for the validation. 
    if(newOrderId != null){
    oppList = [SELECT ID,Name,LX_Bill_To_ID__c,LX_Ship_to_ID__c,Sales_Organization_value__c,Sales_Organization__r.Sales_Organization__c, 
               LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c 
               FROM Opportunity 
               WHERE ID =:newOrderOppId LIMIT 1];
    }else{
    oppList = [SELECT ID,Name,LX_Bill_To_ID__c,LX_Ship_to_ID__c,Sales_Organization_value__c,Sales_Organization__r.Sales_Organization__c, 
               LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c 
               FROM Opportunity 
               WHERE ID =:oppId LIMIT 1];
    }
    Opportunity oppToBeValidated;
    
    for(Opportunity opp :oppList){
        oppToBeValidated = opp;
    }
    
    if(oppToBeValidated == null){
        //If there is no opportunity ensure that you throw an error.
        isError = true;
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,System.Label.LX_Opportunity_Setup);
        ApexPages.addMessage(message);
    }    
    else if(oppToBeValidated.LX_Sold_To_New__c == NULL && 
       oppToBeValidated.LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c == NULL && 
       oppToBeValidated.Sales_Organization_value__c == NULL){
        // If there is no Sold To and Sales Organization on the opportunity then throw an error
        isError = true;
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,System.Label.LX_Opportunity_Sold_To_and_Sales_Org);
        ApexPages.addMessage(message);
    }else if(oppToBeValidated.LX_Sold_To_New__c == NULL && 
             oppToBeValidated.LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c == NULL){
        // If there is no Sold To on the Opportunity then throw an error.
        isError = true;
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,System.Label.LX_Opportunity_Sold_To);
        ApexPages.addMessage(message);
    }else if(oppToBeValidated.Sales_Organization_value__c == NULL){
        // If there is no sales organization on the opportunity throw an error.
        isError = true;
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,System.Label.LX_Opportunity_Sales_Org);
        ApexPages.addMessage(message);
    }else{
    
    isError = false;
    //Load the certifcate information from the static resource.
    PageReference pr = new PageReference(LX_CERTIFACTELOC);
    //Generate the Blob information.
    Blob content ;
    content = pr.getContent();  
    string cert = EncodingUtil.base64Encode(content);
    
    //Variable from the stub class.
    LX_ShiptoBillto_Stub.LXKBillToShipToDetailsFromSAPECCToSFDC_webservices_getBillToShipToDetailsWS_Port stubInst = 
        new LX_ShiptoBillto_Stub.LXKBillToShipToDetailsFromSAPECCToSFDC_webservices_getBillToShipToDetailsWS_Port ();
    
    LX_ShiptoBillto_Stub Stub = new LX_ShiptoBillto_Stub();
 
    //Set the username and password    
    Blob headerValue = Blob.valueOf(sapCredentials.LX_User_Name__c + ':' + sapCredentials.LX_Password__c);
    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
    
    stubInst.inputHttpHeaders_x = new map<string,string>();
    
    stubInst.inputHttpHeaders_x.put('Authorization', authorizationHeader);
    
    //Pass the certificate loaded from the static resource.
    stubInst.clientCert_x=cert;
    
    //Load the Endpoint from the custom setting.
    //stubInst.endpoint_x = System.Label.LX_Opp_Enpoint_URL;
    stubInst.endpoint_x = sapCredentials.LX_End_Point__c;
    
    //Load the Password for the certificate.
    stubInst.clientCertPasswd_x= sapCredentials.LX_Certificate_Password__c;
    
    //Set the timeout to 2 minutes. Load this from the custom setting.
    //stubInst.timeout_x=120000;
    stubInst.timeout_x= Integer.valueOf(sapCredentials.Time_Out__c);


   
    LX_ShiptoBillto_Stub.BillToShipToWSInput stubInput = new LX_ShiptoBillto_Stub.BillToShipToWSInput();

    // Passing input parameters for web callout
    stubInput.soldToID      = oppToBeValidated.LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c ; 
    stubInput.salesOrgID    = oppToBeValidated.Sales_Organization__r.Sales_Organization__c ; 
    
    
   
   // Perform the callout only once when the page is loaded.
   stubOutput = stubInst.processBillToShipToDetails(stubInput);
    
    if(stubOutput.WSStatus.Status.toUpperCase() == 'COMPLETED'){    
       shipToWrapper = new List<LX_shipbillWrapper>();
       billToWrapper = new List<LX_shipbillWrapper>();
    
        LX_shipbillWrapper ship,bill;
        
        //Save the values returned from the callout and use it for further processing.
        if(stubOutput.WSStatus.ShipToCount  != '0'){
            for(LX_ShiptoBillto_Stub.ShipToDetails stubShip: stubOutput.ShipToDetails){
                allSapValues.add(new searchClass(LX_SHIP,stubShip));
             }
        }
    
        if(stubOutput.WSStatus.BillToCount!= '0'){
            for(LX_ShiptoBillto_Stub.BillToDetails stubbill : stubOutput.BillToDetails){
                allSapValues.add(new searchClass(LX_BILL,stubbill));
             } 
        }
         
         //Sort the data based on the sort logic
         allSapValues.sort();
        
           for(searchClass currentRecord :allSapValues){
                //load the 1st 50 Ship To Record for the Page. 
                if(currentRecord.fieldValueMap.get(LX_OpportunityHelper.type)==LX_SHIP){
                    if(shipToWrapper.size() <= LX_DEFAULTPAGESIZE){
                            shipToWrapper.add(convertSearchClassWrapperToLXWrapper(currentRecord));
                    }
    
                }
                // If there are more there 50 ship to record an message that there are more than 50 Ship To Records.
                if(shipToWrapper.size() > LX_DEFAULTPAGESIZE){
                        shipmore = true;
                        ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error,System.Label.LX_Opportunity_Refine_Search);
                        ApexPages.addMessage(message);
                        break;
                }
                
           }
           
           for(searchClass currentRecord :allSapValues){
                //load the 1st 50 Ship To Record for the Page.
                if(currentRecord.fieldValueMap.get(LX_OpportunityHelper.type)==LX_BILL){
                    if(billToWrapper.size() <= LX_DEFAULTPAGESIZE){
                            billToWrapper.add(convertSearchClassWrapperToLXWrapper(currentRecord));
                    }
                }
                // If there are more there 50 ship to record an message that there are more than 50 Ship To Records.
                if(billToWrapper.size() > LX_DEFAULTPAGESIZE){
                        billmore = true;
                        ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error,System.Label.LX_Opportunity_Refine_Search);
                        ApexPages.addMessage(message);
                        break;
                }
                
           }  
       }else{
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error,'There has been an error while connecting to the SAP system. Please contact your administrator.');
            ApexPages.addMessage(message);
       }  
           
     
     } // end of else from line 87
   
       /*
       if(billmore){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.INFO,'There are more records in the search than what is displayed on the screen. Please optimize your search for better results');
                ApexPages.addMessage(message);
       }
       
       if(shipmore){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.INFO,'There are more records in the search than what is displayed on the screen. Please optimize your search for better results');
                ApexPages.addMessage(message);
       }*/
   
    }
     

    /*
     * 
     * Description : This method just refreshes/rerenders the page. 
     * Param - : None
     * Returns : PageReference to the new create Bill To Ship To Page.
    */
    public Pagereference createShipBill(){
        //create a page reference for the New Sold To page.  
        Pagereference pg = new Pagereference(newSoldToPage); // '/apex/LX_Request_for_New_Bill_to_Ship_to?oppId='+oppId+'&type='+type);
        
        //put the relevant parameters in the url
        pg.getParameters().put(LX_OpportunityHelper.oppId,oppId);
        pg.getParameters().put(LX_OpportunityHelper.type,typeOfRecord);
        pg.setredirect(true); 
        return pg;
    }
 

    /*
    * 
    * Description : This method filters the values to be displayed on the search screen based on the paremeters 
    * parameters selected by the user.
    * Param - : None.
    * Returns : None.
    */
    public Pagereference searchBill(){
          
        //clear the result list before filtering based on search criteria
        isInitial = false;
        billMore = false;
        billToWrapper = new List<LX_shipbillWrapper>();
        
        //populate the values on which we have to serach or filter the values.
        inputParams = new Map<String,String>();
        if(input1 != NULL && input1.trim() != ''){
            inputParams.put(LX_INPUT1,input1);
        }
        if(input2 != NULL && input2.trim() != ''){
            inputParams.put(LX_INPUT2,input2);
        }
        if(input3 != NULL && input3.trim() != ''){
            inputParams.put(LX_INPUT3,input3);
        }
        if(input4 != NULL && input4.trim() != ''){
            inputParams.put(LX_INPUT4,input4);
        }
        if(input5 != NULL && input5.trim() != ''){
            inputParams.put(LX_INPUT5,input5);
        }
        if(input6 != NULL && input6.trim() != ''){
            inputParams.put(LX_INPUT6,input6);
        }
        if(input7 != NULL && input7.trim() != ''){
            inputParams.put(LX_INPUT7,input7);
        }
        if(input8 != NULL && input8.trim() != ''){
            inputParams.put(LX_INPUT8,input8);
        }
        if(input9 != NULL && input9.trim() != ''){
            inputParams.put(LX_INPUT9,input9);
        }
        if(input10 != NULL && input10.trim() != ''){
            inputParams.put(LX_INPUT10,input10);
            System.debug('Adding input parameter 10 to map : '+inputParams);
        }
        
        //Now search for all the values based on the input parameters selected.
        for(searchClass currentRecord :allSapValues){
            
            // Reset the found string to true.          
            Boolean foundString = true;   
            System.debug('currentRecord being searched : '+currentRecord.fieldValueMap.get(LX_BILLTOEMAILID));
            // search for only bill to values.
            if(currentRecord.fieldValueMap.get(LX_OpportunityHelper.type)==LX_BILL){
                // iterate over the parameter on which we have to search
                System.debug('Input parameters : '+inputParams);
                for(string fieldToBeChecked :inputParams.keySet()){
                    System.debug('Field to be checked : '+billsearch.get(fieldToBeChecked));
                    System.debug('Current value to be checked : '+currentRecord.fieldValueMap.get(billsearch.get(fieldToBeChecked)));
                    // If Bill To value on which we are searching is null then break. As it AND search.
                    if((currentRecord.fieldValueMap.get(billsearch.get(fieldToBeChecked)) == null)){
                        //set the foundstring as false.
                        System.debug('Found Null');
                        foundString = false;
                        break;                                                              
                    }
                    
                    // If Bill To value on which we are searching is not found then break. As it AND search.
                    if(!(currentRecord.fieldValueMap.get(billsearch.get(fieldToBeChecked)).ToLowerCase().contains(inputParams.get(fieldToBeChecked).ToLowerCase()))){
                        //set the foundstring as false.
                        foundString = false;
                        break;
                    }
                }
                
                // If all the parameters on which the search is performed is satisfied and the size of the display wrapper size is less than default 
                // size then add it to the page wrapper.
                if(foundString){
                    if(billToWrapper.size() <= LX_DEFAULTPAGESIZE){
                        System.debug('Found Bill to : Search string = '+input10);
                        billToWrapper.add(convertSearchClassWrapperToLXWrapper(currentRecord));
                    }
                }   
            }
            // If there are more there 50 bill to record an message that there are more than 50 Ship To Records.
            if(billToWrapper.size() > LX_DEFAULTPAGESIZE){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error,System.Label.LX_Opportunity_Refine_Search);
                ApexPages.addMessage(message);
                break;
            }
                            
        }    
          
        return null;
    }
 
    /*
    * 
    * Description : This method filters the values to be displayed on the search screen based on the paremeters 
    * parameters selected by the user.
    * Param - : None.
    * Returns : None.
    */
    public Pagereference searchShip(){
        //clear the result list before filtering based on search criteria
        shipmore = false;
        isInitial = false;
        shipToWrapper = new List<LX_shipbillWrapper>();

        //populate the values on which we have to serach or filter the values.
        inputParams = new Map<String,String>();
        if(input1 != NULL && input1.trim() != ''){
            inputParams.put(LX_INPUT1,input1);
        }
        if(input2 != NULL && input2.trim() != ''){
            inputParams.put(LX_INPUT2,input2);
        }
        if(input3 != NULL && input3.trim() != ''){
            inputParams.put(LX_INPUT3,input3);
        }
        if(input4 != NULL && input4.trim() != ''){
            inputParams.put(LX_INPUT4,input4);
        }
        if(input5 != NULL && input5.trim() != ''){
            inputParams.put(LX_INPUT5,input5);
        }
        if(input6 != NULL && input6.trim() != ''){
            inputParams.put(LX_INPUT6,input6);
        }
        if(input7 != NULL && input7.trim() != ''){
            inputParams.put(LX_INPUT7,input7);
        }
        if(input8 != NULL && input8.trim() != ''){
            inputParams.put(LX_INPUT8,input8);
        }
        if(input9 != NULL && input9.trim() != ''){
            inputParams.put(LX_INPUT9,input9);
        }
        //Now search for all the values.
        for(searchClass currentRecord :allSapValues){
            Boolean foundString = true;   
            // serach for only ship to values.
            if(currentRecord.fieldValueMap.get(LX_OpportunityHelper.type)==LX_SHIP){
                //iterate over the input parameters on which we have to perform the search
                for(string fieldToBeChecked :inputParams.keySet()){
                    // If Ship To value on which we are searching is null then break. As it AND search.
                    if((currentRecord.fieldValueMap.get(shipsearch.get(fieldToBeChecked)) == null)){
                        //set the foundstring as false.
                        foundString = false;
                        break;                                                              
                    }
                    // If Ship To value on which we are searching is not found then break. As it AND search.
                    if(!(currentRecord.fieldValueMap.get(shipsearch.get(fieldToBeChecked)).ToLowerCase().contains(inputParams.get(fieldToBeChecked).ToLowerCase()))){
                        foundString = false;
                        break;
                    }
                }

                // If all the parameters on which the search is performed is satisfied and the size of the display wrapper size is less than default 
                // size then add it to the page wrapper.
                if(foundString){
                    if(shipToWrapper.size() <= LX_DEFAULTPAGESIZE){
                        shipToWrapper.add(convertSearchClassWrapperToLXWrapper(currentRecord));
                    }
                }   
            }

            // If there are more there 50 ship to record an message that there are more than 50 Ship To Records.
            if(shipToWrapper.size() > LX_DEFAULTPAGESIZE){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error,System.Label.LX_Opportunity_Refine_Search);
                ApexPages.addMessage(message);
                break;
            }
        }    
        return null;
    }
        
    /*
     * 
     * Description : This method updates the Ship To details onto the opportunity/project
     * Param - : None
     * Returns : null
    */
    public Pagereference updateShipTo(){
        updateOpp(LX_SHIP);
        return null;    
    }
 
    /*
     * 
     * Description : This method updates the Bill To details onto the opportunity/project
     * Param - : None
     * Returns : null
    */
    public Pagereference updateBillTo(){
        updateOpp(LX_BILL);
        return null;    
    }
 
    /*
     * 
     * Description : Depending on the type os the operation, the bill to and ship to information is updated onto the 
     * opportunity or project. 
     * Param - : The type of operation i.e. SHIP for updating ship to information and BILL for updating bill to information.
     * Returns :  null
    */
    public Pagereference updateOpp( string typeOfOperation){
                 //string typeOfOperation = 'BILL';
        // Declare the boolean which tracks if the opportunity/project needs to be updated.
        Boolean updateOpp = false;
        // Declare the sobject variable. Depending on the type of opeartion, initialise it 
        // a pse_Proj__c instance or Opportunity instance.
        sObject OpptoUpdate; 
        if(newOrderId != null){
            OpptoUpdate = new LX_New_Order_Request__c(id=newOrderId);
        }else{
        if(projId != null){
            OpptoUpdate = new pse__Proj__c(id=projId);
        }else{
            OpptoUpdate = new Opportunity(id=oppId);
        }
        }
        //Declare instances of LX_ShipbillWrapper to store the selected Bull to and ship to.
        LX_shipbillWrapper selectedBillTo, selectedShipTo;
        
        // initialise the flags for no bill to and ship to.
        Boolean noBill = true;
        Boolean noShip= true;

        // Depending on the type of operation initailise the flags.
        if(typeOfOperation == LX_BILL){
            saveBill = true;
            saveShip = false;
        }else{
            saveShip = true;
            saveBill = false;
        }

        if(saveBill == TRUE){
            saveShip = false;
            // iterate over the Bill Wrapper class and see if any of record is selected.
            for(LX_shipbillWrapper bill :billToWrapper){
                //If the record is selected then update the SOBJECT with the selected values.
                if(bill.Selected){
                    system.debug('>>>>>>>>>>>>>>>>'+bill);
                    //update the required flags accordingly.
                    updateOpp                           = true;
                    noBill                              = false;
                    OpptoUpdate.put('LX_Bill_To_Company__c',bill.Company);
                  //  OpptoUpdate.put('LX_Bill_To_Name__c',bill.billShipName);
                    OpptoUpdate.put('Bill_To_Name__c',bill.billShipName);
          
                    OpptoUpdate.put('LX_Bill_To_ID__c', bill.BillShipID);
                    OpptoUpdate.put('LX_Bill_To_Address__c',bill.Address1);
                    OpptoUpdate.put('LX_Bill_To_Address_2__c',bill.Address2);
                    OpptoUpdate.put('LX_Bill_To_Country__c',bill.Company);
                    OpptoUpdate.put('LX_Bill_To_City__c',bill.City);
                    OpptoUpdate.put('LX_Bill_To_State__c',bill.State);
                    OpptoUpdate.put('LX_Bill_To_Country__c',bill.Country);
                    OpptoUpdate.put('LX_Bill_To_Postal__c',bill.PostalCode);
                    OpptoUpdate.put('LX_Bill_To_Email_Address__c',bill.billEmail);
                    system.debug('>>>>>>>OpptoUpdate12>>>>>>>>'+OpptoUpdate);
                    break;
                } 
            }
        }
        
        if(saveShip == TRUE){
            // iterate over the Ship Wrapper class and see if any of record is selected.
             saveBill = false;    
             for(LX_shipbillWrapper ship :shipToWrapper){
                //If the record is selected then update the SOBJECT with the selected values.
                if(ship.Selected){
                   // update the required flags accordingly.
                   updateOpp                            = true;
                   noShip                              = false;
                   OpptoUpdate.put('LX_Ship_To_Company__c',ship.Company);
                   OpptoUpdate.put('Ship_To_Name__c',ship.billShipName);
                   OpptoUpdate.put('LX_Ship_to_ID__c',ship.BillShipID);
                   OpptoUpdate.put('LX_Ship_to_Address__c',ship.Address1);
                   OpptoUpdate.put('LX_Ship_to_Address_2__c',ship.Address2);
                   OpptoUpdate.put('LX_Ship_to_Country__c',ship.Company);
                   OpptoUpdate.put('LX_Ship_to_City__c',ship.City);
                   OpptoUpdate.put('LX_Ship_to_State__c',ship.State);
                   OpptoUpdate.put('LX_Ship_to_Country__c',ship.Country);
                   OpptoUpdate.put('LX_Ship_to_Postal__c',ship.PostalCode);
                   break;
                } 
            }
        }
     
     // If no ship to was selected then blank out the opportunity/project
     if((saveShip)&&(noShip)){
           updateOpp = true;
           OpptoUpdate.put('LX_Ship_To_Company__c','');
           OpptoUpdate.put('Ship_To_Name__c','');
           OpptoUpdate.put('LX_Ship_to_ID__c','');
           OpptoUpdate.put('LX_Ship_to_Address__c','');
           OpptoUpdate.put('LX_Ship_to_Address_2__c','');
           OpptoUpdate.put('LX_Ship_to_Country__c','');
           OpptoUpdate.put('LX_Ship_to_City__c','');
           OpptoUpdate.put('LX_Ship_to_State__c','');
           OpptoUpdate.put('LX_Ship_to_Country__c','');
           OpptoUpdate.put('LX_Ship_to_Postal__c','');
        
     }
    // If no bill to was selected then blank out the opportunity/project
     if((saveBill)&&(noBill)){
            updateOpp = true;
            OpptoUpdate.put('LX_Bill_To_Company__c','');
            OpptoUpdate.put('Bill_To_Name__c','');
            OpptoUpdate.put('LX_Bill_To_ID__c','');
            OpptoUpdate.put('LX_Bill_To_Address__c','');
            OpptoUpdate.put('LX_Bill_To_Address_2__c','');
            OpptoUpdate.put('LX_Bill_To_Country__c','');
            OpptoUpdate.put('LX_Bill_To_City__c','');
            OpptoUpdate.put('LX_Bill_To_State__c','');
            OpptoUpdate.put('LX_Bill_To_Country__c','');
            OpptoUpdate.put('LX_Bill_To_Postal__c','');
            OpptoUpdate.put('LX_Bill_To_Email_Address__c','');
            
     }

    

    try{
        // if there has been any modification on the  sobject, update the sobject.
        system.debug('>>>>>>>OpptoUpdate>>>>>>>>'+OpptoUpdate);
        if(updateOpp){  
            update OpptoUpdate;
        }
                    
        // if it was a save Bill To Operation then update the corresponding Bill To message.    
        if((saveBill)&& !(noBill)){
            isError = false;
            saveShip = false;
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.INFO,System.Label.LX_Opportunity_Update_Bill_To+' '+operationType+'.');
            ApexPages.addMessage(message);
        }

        // if it was a save Ship to Operation then update the corresponding Ship To message.    
        if((saveShip)&&(!noShip)){
            isError = false;
            saveBill = false;
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.INFO,System.Label.LX_Opportunity_Update_Ship_To+' '+operationType+'.');
            ApexPages.addMessage(message);
        }
               
        // if its save bill to operation and there is no  bill to information selected then update the page with the message "Cleared Bill To Information"
        if((saveBill)&& (noBill)){
            isError = false;
            saveShip = false;
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error, System.Label.LXOpportunity_Clear_Bill_To+' '+operationType+'.');
            ApexPages.addMessage(message);
        }

        // if its save ship to operation and there is no  ship to information selected then update the page with the message "Cleared Ship To Information"
        if((saveShip)&&(noShip)){
            isError = false;
            saveBill = false;
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.Error,System.Label.LXOpportunity_Clear_Ship_To+' '+operationType+'.');
            ApexPages.addMessage(message);
        }
               
    }catch(Exception ex){
        // Update the user there has been an error whenever there is an exception.
        saveBill = false;
        saveShip = false;
        isError = true;
        System.debug('************');
        //ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,System.Label.LX_Opportunity_Sys_Admin);
        string currentError = ex.getMessage();
        string errorToBeDisplayed = '';
        for(string exceptionMessage :exceptionList){
            if(currentError.contains(exceptionMessage)){
                errorToBeDisplayed = currentError.substringAfterLast(exceptionMessage);
            }        
        }

        if((errorToBeDisplayed == null) || (errorToBeDisplayed.trim() == '')){
            errorToBeDisplayed =System.Label.LX_Opportunity_Sys_Admin;
        }        
        
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,errorToBeDisplayed );
        ApexPages.addMessage(message);
       // create the exception record.
        //LX_CommonUtilities.createExceptionLog(ex);
       updateOpp = false;
       return null;
    }
    
       updateOpp = false;
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
     * 
     * Description : This method is called when a user clicks on 'Modify Bill to' button.
     * It redirects the VF page to a standard 'Case' new page
     * Param - : None
     * Returns : Null
    */
     public Pagereference modifyBilltoInfo(){
       for(LX_shipbillWrapper billto :billToWrapper){
           if(billto.Selected){
           // If there is a SAP Bill to selected, the respected column values are passed to Case fields through URL
               String urlStringBill = ''+Label.LX_Case_Subject+'=Bill To change request for Opportunity ['+EncodingUtil.urlEncode(opp1.Name,'UTF-8')+']&retURL=%2F'+opp1.Id+'&CF'+Label.LX_Case_Internal_Account+'='+EncodingUtil.urlEncode(opp1.Account.Name,'UTF-8')+'&CF'+Label.LX_Case_Internal_Account+'_lkid='+opp1.Account.Id+'&RecordType='+Label.LX_Case_Sold_To_RecordTypeId+'&ent=Case&'+Label.LX_Case_Request_Change+'=<h3>Modify Bill To:</h3><table width=600 border=1><tr><th width=200>Opportunity</th><td><a href=/'+opp1.Id+' >'+EncodingUtil.urlEncode(opp1.Name,'UTF-8')+'</a></td></tr>'+BillToShipToRequestURL+'<tr><th>Sold To ID</th><td>'+opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c+'</td></tr><tr><th>Sales Organization</th><td>'+opp1.Sales_Organization_value__c+'</td></tr>';
               
               

               // Check to ensure the values being passed are not null
               if(opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Name__c != NULL)
                  urlStringBill =   urlStringBill+'<tr><th>Customer Name</th><td>'+EncodingUtil.urlEncode(opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Name__c,'UTF-8')+'</td></tr>';
               if(billto.billShipName != NULL)
                   urlStringBill =  urlStringBill+'<tr><th>Bill To Name</th><td>'+EncodingUtil.urlEncode(billto.billShipName,'UTF-8')+'</td></tr>';
            
                   urlStringBill =  urlStringBill+'<tr><th>Street/House No</th><td>'+StreetLineHTML+'</td></tr>';
               if(billto.Address1 != NULL)
                   urlStringBill =  urlStringBill+'<tr><th>Bill To Address1</th><td>'+EncodingUtil.urlEncode(billto.Address1,'UTF-8')+'</td></tr>';
               if(billto.Address2 != NULL)
                    urlStringBill = urlStringBill+'<tr><th>Bill To Address2</th><td>'+EncodingUtil.urlEncode(billto.Address2,'UTF-8')+'</td></tr>';
              if(billto.City != NULL)
                    urlStringBill = urlStringBill+'<tr><th>Bill To City</th><td>'+EncodingUtil.urlEncode(billto.City,'UTF-8')+'</td></tr>';
               if(billto.State != NULL)
                    urlStringBill =  urlStringBill+'<tr><th>Bill To Region/State</th><td>'+EncodingUtil.urlEncode(billto.State,'UTF-8')+'</td></tr>';
               if(billto.Country != NULL)
                    urlStringBill = urlStringBill+'<tr><th>Bill To Country</th><td>'+EncodingUtil.urlEncode(billto.Country,'UTF-8')+'</td></tr> ';

               urlStringBill = urlStringBill+'<tr><th>Bill To Postal Code</th><td>'+EncodingUtil.urlEncode(billto.PostalCode,'UTF-8')+'</td></tr><tr><th>Bill To ID</th><td>'+billto.BillShipID+'</td></tr><tr><th>Bill To Email Address</th><td>'+EncodingUtil.urlEncode(billto.billEmail,'UTF-8')+'</td></tr><tr><th>Preferred Language</th><td></td></tr><tr><th>Search Term</th><td></td></tr><tr><th>Requestor</th><td><a href=/'+UserInfo.getUserId()+' >'+UserInfo.getFirstName()+'%20'+UserInfo.getLastName()+'</a></td></tr><tr><th>Additional Comments</th><td></td></tr></table>';                                   
               
               
               return new Pagereference('/500/e?'+urlStringBill);
          }
       }
       return null;
     }
     /*
     * 
     * Description : This method is called when a user clicks on 'Modify Ship To' button.
     * It redirects the VF page to a standard 'Case' new page
     * Param - : None
     * Returns : Null
    */
     public Pagereference modifyShiptoInfo(){
       for(LX_shipbillWrapper shipto : ShiptoWrapper)
       {
         if(shipto.Selected){
             // If there is a SAP Ship to selected, the respected column values are passed to Case fields through URL
                String urlStringShip = ''+Label.LX_Case_Subject+'=Ship To change request for Opportunity ['+EncodingUtil.urlEncode(opp1.Name,'UTF-8')+']&retURL=%2F'+opp1.Id+'&'+Label.LX_Case_Type+'='+Label.LX_Case_Type_Val+'&CF'+Label.LX_Case_Internal_Account+'='+EncodingUtil.urlEncode(opp1.Account.Name,'UTF-8')+'&cas5=Change%20Request&CF'+Label.LX_Case_Internal_Account+'_lkid='+opp1.Account.Id+'&RecordType='+Label.LX_Case_Sold_To_RecordTypeId+'&ent=Case&'+Label.LX_Case_Request_Change+'=<h3>Modify Bill To:</h3><table width=600 border=1><tr><th width=200>Opportunity</th><td><a href=/'+opp1.Id+' >'+EncodingUtil.urlEncode(opp1.Name,'UTF-8')+'</a></td></tr>'+BillToShipToRequestURL+'<tr><th>Sold To ID</th><td>'+opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c+'</td></tr><tr><th>Sales Organization</th><td>'+opp1.Sales_Organization_value__c+'</td></tr>';

                // Check to ensure the values being passed are not null
               if(opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Name__c != NULL)
                  urlStringShip =  urlStringShip+'<tr><th>Customer Name</th><td>'+EncodingUtil.urlEncode(opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Name__c,'UTF-8')+'</td></tr>';
               if(shipto.billShipName != NULL)
                   urlStringShip = urlStringShip+'<tr><th>Ship to Name</th><td>'+EncodingUtil.urlEncode(shipto.billShipName,'UTF-8')+'</td></tr>';
            
                   urlStringShip = urlStringShip+'<tr><th>Street/House No</th><td>'+StreetLineHTML+'</td></tr>';
               if(shipto.Address1 != NULL)
                   urlStringShip =  urlStringShip+'<tr><th>Ship to Address1</th><td>'+EncodingUtil.urlEncode(shipto.Address1,'UTF-8')+'</td></tr>';
               if(shipto.Address2 != NULL)
                    urlStringShip = urlStringShip+'<tr><th>Ship to Address2</th><td>'+EncodingUtil.urlEncode(shipto.Address2,'UTF-8')+'</td></tr>';
              if(shipto.City != NULL)
                    urlStringShip = urlStringShip+'<tr><th>Ship to City</th><td>'+EncodingUtil.urlEncode(shipto.City,'UTF-8')+'</td></tr>';
               if(shipto.State != NULL)
                    urlStringShip = urlStringShip+'<tr><th>Ship To Region/State</th><td>'+EncodingUtil.urlEncode(shipto.State,'UTF-8')+'</td></tr>';
               if(shipto.Country != NULL)
                    urlStringShip = urlStringShip+'<tr><th>Ship to Country</th><td>'+EncodingUtil.urlEncode(shipto.Country,'UTF-8')+'</td></tr> ';
                                   
               urlStringShip = urlStringShip+'<tr><th>Ship to Postal Code</th><td>'+EncodingUtil.urlEncode(shipto.PostalCode,'UTF-8')+'</td></tr><tr><th>Bill To ID</th><td>'+shipto.BillShipID+'</td></tr><tr><th>Bill To Email Address</th><td>'+EncodingUtil.urlEncode(shipto.billEmail,'UTF-8')+'</td></tr><tr><th>Preferred Language</th><td></td></tr><tr><th>Search Term</th><td></td></tr><tr><th>Requestor</th><td><a href=/'+UserInfo.getUserId()+' >'+UserInfo.getFirstName()+'%20'+UserInfo.getLastName()+'</a></td></tr><tr><th>Additional Comments</th><td></td></tr></table>';               
               
               return new Pagereference('/500/e?'+urlStringShip);
         }
       }
       return null;
     }
    /*
     * 
     * Description : This method is called on the load of the page.
     * It loads all the required parameters for the operation and load the corresponding attributes for the 
     * create bill to / ship to operation.
     * Param - : None
     * Returns : Null
    */
    public String StreetLineHTML{get;set;}
    public Pagereference onLoad()
    {
        //If there is no error then proceed.
        if(!isError){
            //Query for all the fields on the opportunity.
             //Query for all the fields on the opportunity.
         if(newOrderId != null){
             opp1 = [SELECT id,name,LX_Sold_To_New__r.LX_Sold_To__r.LX_Name__c,Sales_Organization_value__c,Account.MDM_Account_Number__c,AccountId,Account.Parent.Id,
                      Account.Parent.Name,Account.Name, LX_Sold_To_New__r.LX_Sales_Org1__c,LX_Sold_To_New__c,CurrencyIsoCode ,LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c
                      FROM opportunity 
                      WHERE id = :newOrderOppId];
        }else{
        opp1 = [SELECT id,name,LX_Sold_To_New__r.LX_Sold_To__r.LX_Name__c,Sales_Organization_value__c,Account.MDM_Account_Number__c,AccountId,Account.Parent.Id,
                      Account.Parent.Name,Account.Name, LX_Sold_To_New__r.LX_Sales_Org1__c,LX_Sold_To_New__c,CurrencyIsoCode ,LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c
                      FROM opportunity 
                      WHERE id = :oppId];
        }
                      //Added by arun thakur 17Sep 2013
                       List<Contact> ListContac=[select Name,Id from contact where pse__Salesforce_User__c=:UserInfo.getUserID()];
                    if(!ListContac.IsEmpty())
                     objContact=ListContac[0];
                     
                      
            if(opp1.LX_Sold_To_New__r!=null)
            {        
                System.debug('========arun:opp1.LX_Sold_To_New__r.LX_Sold_To__r.LX_Sold_To_ID__c='+opp1.LX_Sold_To_New__r.LX_Sales_Org1__c);
                if(opp1.LX_Sold_To_New__r.LX_Sales_Org1__c=='5097')
                {
                    StreetLineHTML='<tr><th>Street 4</th><td></td></tr>';
                }
                else
                {
                    StreetLineHTML='<tr><th>Street 2</th><td></td></tr>';       
                }   
            }          
                      
            // IF THE project id is not null then set the project parameters for the create bill to/ ship to request.   
             if(projID!=null)
             {
                pse__Proj__c ObjProject=[select Id,Name from pse__Proj__c where id=:projID];
                retURL='/'+ObjProject.Id;
                BillToShipToRequestURL='<tr><th width=200>Project</th><td><a href=/'+ObjProject.Id+'>'+ObjProject.Name+'</a></td></tr>';
             }
             else
             {
                retURL='/'+opp1.Id;
                BillToShipToRequestURL='';
             }
        }
     return null;
    }
    
    // Variable to store the sortExpression
    public String sortExpression{
         get
         {
            return sortExp;
         }
         set
         {
           //if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp){
             sortDirection = (sortDirection == LX_ASC)? LX_DESC : LX_ASC;
           }
           else{
             sortDirection = LX_ASC;
           }
           sortExp = value;
         }
    }

  
    /*
     * 
     * Description : The getter method for the sort direction variable.
     * Param - : None
     * Returns : sortdirection for the column.
    */
    public String getSortDirection()
         {
            //if no column is selected then assign the Ascending direction.
            if (sortExpression == null || sortExpression == ''){
                return LX_ASC;
            }
            else{
                return sortDirection;
            }
    }
  
    /*
     * 
     * Description : The setter method for the sort direction variable.
     * Param - : sortdirection.
     * Returns : Null
    */
    public void setSortDirection(String sortDir){
        sortDirection = sortDir;
    }

    /*
     * 
     * Description : The based on the tab selected, the data is sorted by default conditions.
     * Param - : sortdirection.
     * Returns : Null
    */
    public void sortFilter(){
        if(filter == TRUE){ // called when bill to tab is selected
            LX_ShipBillWrapper.sortBy =  sortExpression+sortDirection;
            billtoWrapper.sort();
        }else{ // called when ship to tab is selected
            LX_ShipBillWrapper.sortBy =  sortExpression+sortDirection;
            shiptoWrapper.sort();
        }
    }
        
    /*
     * 
     * Description : this class the searchClass Variable to the BillTo/ Ship To wrapper variable.
     * Param - : searchClass variable..
     * Returns : Bill To/ Ship To variable
    */
    public LX_ShipBillWrapper convertSearchClassWrapperToLXWrapper(searchClass input){
            
            LX_ShipBillWrapper returnValue = new LX_ShipBillWrapper();
            // Depending on the type of the variable create the Bill To/ Ship To variable.
            if(input.fieldValueMap.get(LX_OpportunityHelper.type) == LX_BILL){
                //Get the values accordingly
                returnValue.billShipName = input.fieldValueMap.get(LX_BILLTONAME);
                returnValue.Company = input.fieldValueMap.get(LX_BILLTOCOMPANY);
                returnValue.Address1 = input.fieldValueMap.get(LX_BILLTOADDRESS1);
                returnValue.Address2 = input.fieldValueMap.get(LX_BILLTOADDRESS2);
                returnValue.City = input.fieldValueMap.get(LX_BILLTOCITY);                               
                returnValue.State = input.fieldValueMap.get(LX_BILLTOSTATEORPROVINCE);                           
                returnValue.PostalCode = input.fieldValueMap.get(LX_BILLTOPOSTALCODE);                           
                returnValue.Country = input.fieldValueMap.get(LX_BILLTOCOUNTRY);                                                                                                                         
                returnValue.BillShipID = input.fieldValueMap.get(LX_BILLTOID);
                returnValue.billEmail = input.fieldValueMap.get(LX_BILLTOEMAILID);
                
                
                if((input.fieldValueMap.get(LX_DEFAULT) != null)&&(input.fieldValueMap.get(LX_DEFAULT).toLowerCase().trim() ==LX_TRUE)){
                    returnValue.isDefault = true;
                }else{
                    returnValue.isDefault = false;
                }
            }else{
                //Get the values accordingly
                returnValue.billShipName = input.fieldValueMap.get(LX_SHIPTONAME);
                returnValue.Company = input.fieldValueMap.get(LX_SHIPTOCOMPANY);
                returnValue.Address1 = input.fieldValueMap.get(LX_SHIPTOADDRESS);
                returnValue.Address2 = input.fieldValueMap.get(LX_SHIPTOADDRESS2);
                returnValue.City = input.fieldValueMap.get(LX_SHIPTOCITY);                               
                returnValue.State = input.fieldValueMap.get(LX_SHIPTOSTATEORPROVINCE);                           
                returnValue.PostalCode = input.fieldValueMap.get(LX_SHIPTOPOSTALCODE);                           
                returnValue.Country = input.fieldValueMap.get(LX_SHIPTOCOUNTRY);                                                                                                                         
                returnValue.BillShipID = input.fieldValueMap.get(LX_SHIPTOID);                           
            }
            return returnValue;
    }
        
   /* Class Name   : searchClass   
    * Description : This class is used for store the values that were got through the initial search.
    * Created By   :  Rahul Raghunathan
    * Created Date : 07-11-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Rahul R            07-11-2013               1000                Initial Version    
    */
    public class searchClass implements Comparable{
            // Only one member variable. It stores the values in map with the field name as key and it value as value.
            map<string,string> fieldValueMap = new map<string,string>();
            
            /*
             * 
             * Description : Constructor for the class. 
             * Param - : type of varibale. 'BILL' for bill to and 'SHIP' for ship to 
             * Param - : LX_ShiptoBillto_Stub.BillToDetails instance
             * Returns : none.
            */
            public searchClass(string Type,LX_ShiptoBillto_Stub.BillToDetails stubbill){
                    if(Type == LX_BILL){
                            this.fieldValueMap.put(LX_BILLTONAME,stubbill.billToName);
                            this.fieldValueMap.put(LX_BILLTOCOMPANY,stubbill.billToCompany);
                            this.fieldValueMap.put(LX_BILLTOADDRESS1,stubbill.billToAddress);
                            this.fieldValueMap.put(LX_BILLTOADDRESS2,stubbill.billToAddress2);
                            this.fieldValueMap.put(LX_BILLTOCITY,stubbill.billToCity);                               
                            this.fieldValueMap.put(LX_BILLTOSTATEORPROVINCE,stubbill.billToStateOrProvince);                         
                            this.fieldValueMap.put(LX_BILLTOPOSTALCODE,stubbill.billToPostalCode);                           
                            this.fieldValueMap.put(LX_BILLTOCOUNTRY,stubbill.billToCountry);                                                                                                                         
                            this.fieldValueMap.put(LX_BILLTOID,stubbill.billToID);
                            this.fieldValueMap.put(LX_DEFAULT,stubbill.SMSARenewalBillTo);
                            this.fieldValueMap.put(LX_BILLTOEMAILID,stubbill.billToEmailID);
                            this.fieldValueMap.put(LX_OpportunityHelper.type,LX_BILL);     
                            System.debug('Inside search class : fieldValueMap value : '+fieldValueMap);                     
                    }
            }
            
                    
            /*
             * 
             * Description : Constructor for the class. 
             * Param - : type of varibale. 'BILL' for bill to and 'SHIP' for ship to 
             * Param - : LX_ShiptoBillto_Stub.ShipToDetails instance
             * Returns : none.
            */
            public searchClass(string Type,LX_ShiptoBillto_Stub.ShipToDetails stubship){            
            if(Type == LX_SHIP){
                            this.fieldValueMap.put(LX_SHIPTONAME,stubship.shipToName);
                            this.fieldValueMap.put(LX_SHIPTOCOMPANY,stubship.shipToCompany);
                            this.fieldValueMap.put(LX_SHIPTOADDRESS,stubship.shipToAddress);
                            this.fieldValueMap.put(LX_SHIPTOADDRESS2,stubship.shipToAddress2);
                            this.fieldValueMap.put(LX_SHIPTOCITY,stubship.shipToCity);                               
                            this.fieldValueMap.put(LX_SHIPTOSTATEORPROVINCE,stubship.shipToStateOrProvince);                         
                            this.fieldValueMap.put(LX_SHIPTOPOSTALCODE,stubship.shipToPostalCode);                           
                            this.fieldValueMap.put(LX_SHIPTOCOUNTRY,stubship.shipToCountry);                                                                                                                         
                            this.fieldValueMap.put(LX_SHIPTOID,stubship.shipToID);                           
                            this.fieldValueMap.put(LX_OpportunityHelper.type,LX_SHIP);                          
                            
                    }
            }

        /*
        * 
        * Description : Impletmentation of the compareTo method of the comparable interface.
        * Param - : instance of the SearchClass.
        * Returns : +1 if it is greater. -1 if it is less and 0 if they are the same.
        */
         public Integer compareTo(Object testObject) {
                searchClass compareObject = (searchClass)testObject;
                //Check of the type of variable are the same.
                if(fieldValueMap.get(LX_OpportunityHelper.type) == compareObject.fieldValueMap.get(LX_OpportunityHelper.type)){
                    //This record is for Bill To Records.
                    if(compareObject.fieldValueMap.get(LX_OpportunityHelper.type) == LX_BILL){
                        //First check on the Default variable.
                        if (!(fieldValueMap.get(LX_DEFAULT) == compareObject.fieldValueMap.get(LX_DEFAULT))){
                            if((compareObject.fieldValueMap.get(LX_DEFAULT)!= null) &&(compareObject.fieldValueMap.get(LX_DEFAULT).trim().tolowerCase()==LX_TRUE)){
                                return 1;
                            }else{
                                return -1;
                            }
                        }else{
                            //Check on the Bill email ID. Always check on Ascending.
                            if (!(fieldValueMap.get(LX_BILLTOEMAILID) == compareObject.fieldValueMap.get(LX_BILLTOEMAILID))){
                                if((fieldValueMap.get(LX_BILLTOEMAILID) != null)){
                                    return fieldValueMap.get(LX_BILLTOEMAILID).compareTo(compareObject.fieldValueMap.get(LX_BILLTOEMAILID))*-1;
                                }else{
                                    return 1;
                                }
                            }else{
                                //Check on the Bill and Province. Always check on Ascending.
                            if (!(fieldValueMap.get(LX_BILLTOSTATEORPROVINCE) == compareObject.fieldValueMap.get(LX_BILLTOSTATEORPROVINCE))){
                                if((fieldValueMap.get(LX_BILLTOSTATEORPROVINCE) != null)){
                                    return fieldValueMap.get(LX_BILLTOSTATEORPROVINCE).compareTo(compareObject.fieldValueMap.get(LX_BILLTOSTATEORPROVINCE));
                                }else{
                                    return -1;
                                }
                            } else{
                                //if Province is the same then check on the city.
                                if (!(fieldValueMap.get(LX_BILLTOCITY) == compareObject.fieldValueMap.get(LX_BILLTOCITY))){
                                    if((fieldValueMap.get(LX_BILLTOCITY) != null)){
                                        return fieldValueMap.get(LX_BILLTOCITY).compareTo(compareObject.fieldValueMap.get(LX_BILLTOCITY));
                                    }else{
                                        return -1;
                                    }
                                }                               
                            }                              
                         }
                            return -1;                              
                        }                   
                    }else{//Check on the Bill and Province. Always check on Ascending.
                            if (!(fieldValueMap.get(LX_SHIPTOSTATEORPROVINCE) == compareObject.fieldValueMap.get(LX_SHIPTOSTATEORPROVINCE))){
                                if((fieldValueMap.get(LX_SHIPTOSTATEORPROVINCE) != null)){
                                    return fieldValueMap.get(LX_SHIPTOSTATEORPROVINCE).compareTo(compareObject.fieldValueMap.get(LX_SHIPTOSTATEORPROVINCE));
                                }else{
                                    return -1;
                                }
                            }else{
                                // If they are of the same province then check on the city.
                                if (!(fieldValueMap.get(LX_SHIPTOCITY) == compareObject.fieldValueMap.get(LX_SHIPTOCITY))){
                                    if((fieldValueMap.get(LX_SHIPTOCITY) != null)){
                                        return fieldValueMap.get(LX_SHIPTOCITY).compareTo(compareObject.fieldValueMap.get(LX_SHIPTOCITY));
                                    }else{
                                        return -1;
                                    }
                                }                               
                            }
                            return -1;                      
                        }   
                }else{
                    // if the variable is Bill To then it should be at top else move to the bottom.
                    if((compareObject.fieldValueMap.get(LX_OpportunityHelper.type) == LX_BILL)){
                        return 1;
                    }else{
                        return -1;
                    }
                }
          }
      }        
}