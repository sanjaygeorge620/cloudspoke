/* Class Name   : PRM_WebServiceCallout_Dev_WithoutBatch
* Description   : POC : Web Service Callout to Big machines to auto create Quote and Quote Products
* Created By   : Sanjay Chaudhary
* Created Date :  06-24-2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay Chaudhary          06-24-2014                                Initial Version
* Shubhashish Rai           06-26-2014                                Added logic for retrieving details of the Opportunity and passing the same to BM
*/

global class  PRM_WebServiceCallout_Dev_WithoutBatch {

    Webservice static String sendNotification(string OppId, String OppName) {
                
        final String strSuccess = Label.LX_Return_String_PRM_BM_Callouts ;
        final String strFailed = Label.LX_Failed_Return_String_PRM_BM_Callouts;
        final String strFailedContactAdmin = Label.LX_Failed_Contact_Admin_Return_String_PRM_BM_Callouts;
        final String strQuoteExists = Label.LX_Quote_Exists_Return_String_PRM_BM_Callouts;
        final String strSiteDownForMaintenace = Label.LX_BigMachines_DownTime;
        final String strSiteDownForMaintenanceReturnString = Label.LX_Site_Down_For_Maintenance_BigMachines_Return_String;
        
        String sessionId = '';
        String bmid = '';
        String bmusername = Label.LX_Bigmachines_UserName;
        String bmpassword = Label.LX_Bigmachines_UserPassword;
        String bmOrgName = Label.LX_Bigmachines_OrgName;
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        List<Opportunity> oppList = new List<Opportunity>();
        List<BigMachines__Quote__c> bmQuoteList= new List<BigMachines__Quote__c>();
        
        RecordType caseRecordTypeQuickBid = [Select id, Name from RecordType where sObjectType = 'Case' and Name = 'Quick Bid Case'];
        List<Group> quickBidsSupportQueue = [Select id from Group where type = 'Queue' and DeveloperName = 'LX_Quick_Bids_Support_Queue'];
        
        String queryString = 'Select id,Name,Opportunity_Number__c, LX_Quick_Bid_Type__c,CurrencyIsoCode,LX_Quick_Bid_Integration_Error__c, LX_Quick_Bid_Integration_Error_Message__c, End_Date__c, AccountId ,Account.Name, CloseDate, Begin_Date__c, LX_End_User_Account__c, MPS__c, LX_Reason_for_Discount_Rebate__c, LX_Quote_Category__c, Sales_Organization_value__c, Sales_Organization_Geo__c, Sales_Organization__c, Sales_Organization__r.LX_Sales_Group__c,Sales_Organization__r.Name, Sales_Organization__r.LX_Sales_Office__c , Sales_Organization__r.CurrencyIsoCode, pse__Region__c from Opportunity where Id in (\'' + OppID + '\')';
        
        String oppIntegrationErrorMsg = '';
        String caseDescription = '';
        boolean hasErrorOccured = false;
        boolean isOppDataCorrect = true;
        
        try{
            oppList = Database.query(queryString);
            System.debug('**@@@oppList**' + oppList);
        }
        
        catch(Exception ex){
            System.debug('**Query Opportunity Attributes Exception**'+ex);
        }
        
        try{
            bmQuoteList = [Select id from BigMachines__Quote__c where BigMachines__Opportunity__c=: OppId AND BigMachines__Status__c != 'Cancelled'];
            System.debug('@@@ bmQuoteList ' + bmQuoteList.size());
        }
        catch(Exception ex){
            System.debug('@@@ error' + ex);
        }
        
        if(bmQuoteList.size()>0){
            return strQuoteExists;
        }

// Callout 1        
// BM Login Method - Start : Log into Big Machines via Integration User and return session Id .
       
        String SoapXMLBody = '';
        SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:soap.bigmachines.com"><soapenv:Header><urn:xsdInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="?"><urn:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/security/Security.xsd</urn:schemaLocation></urn:xsdInfo><urn:category soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="?">Security</urn:category></soapenv:Header><soapenv:Body><urn:login><urn:userInfo><urn:username>'+bmusername+'</urn:username><urn:password>'+bmpassword+'</urn:password></urn:userInfo></urn:login></soapenv:Body></soapenv:Envelope>';
        req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);
//      req.setCompressed(true); // otherwise we hit a limit of 32000

        try 
        {
            res = http.send(req);
            system.debug ('BM Login Call Response'+res.toString()+res.getbody());
            String BMSessionbody = res.getbody() ; 
            Integer startSession = BMSessionbody.indexOf('<bm:sessionId>',0) + '<bm:sessionId>'.length(); 
            Integer endSession = BMSessionbody.indexOf('</bm:sessionId>',0);
            if(startSession != (-1 + '<bm:sessionId>'.length()) || endSession != -1){
                sessionId =  BMSessionbody.substring(startSession,endSession);
                system.debug ('**BM Login Call Session Id = **'+ sessionId) ; 
            }
            else{
                if(BMSessionbody.contains(strSiteDownForMaintenace)){
                    hasErrorOccured = true;
                    
                    List<Contact> contactListForCase= [Select id, Email from Contact where Email=: UserInfo.getUserEmail() and RecordType.Name = 'Resource Contact'];
                    System.debug('@@@ contactListForCase'+ contactListForCase);
                    
                    oppList[0].LX_Quick_Bid_Integration_Error__c = true;
                    oppList[0].LX_Quick_Bid_Integration_Error_Message__c = 'BigMachines site down for maintenance. Quote not created for the opportunity.';
                    oppList[0].LX_In_Approval_Process_Quick_Bid__c  = true;
                    
                    Case csInstance = new Case();
                    
                    csInstance.LX_Opportunity__c = OppId;
                    csInstance.RecordTypeId = caseRecordTypeQuickBid.Id;
                    csInstance.Description = 'BigMachines site down for maintenance. Quote not created for the opportunity.';
                    csInstance.OwnerId = quickBidsSupportQueue[0].id;
                    csInstance.Subject = 'Quick Bids Exception'  + ' - ' + oppList[0].Opportunity_Number__c + ' - ' + String.valueOf(Date.today()); 
                    csInstance.Status = 'New';
                    csInstance.Priority = 'High';
                    csInstance.Origin = 'Opportunity';
                    if(contactListForCase.size()>0)
                        csInstance.ContactId = contactListForCase[0].id;        
                    try{
                        Database.update(oppList[0]);
                        Database.insert(csInstance);
                    }
                    catch(Exception ex){
                        LX_CommonUtilities.createExceptionLog(ex);
                        System.debug('@@@ ' + ex);                         
                    }
                    return strSiteDownForMaintenanceReturnString ;
                }
                Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
                Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
                if(startExceptionMessage != (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage != -1){
                    String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                    System.debug('@@@ ' + exceptionMsg);
                                        
                oppIntegrationErrorMsg+= '\n\nException Type: Authentication Failed' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 1 - Login Failed to Big Machines';
                caseDescription+= '\n\nException Type: Authentication Failed' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 1 - Login Failed to Big Machines';
                hasErrorOccured = true;
                
               }           
            }
            System.debug('**BM Login Callout 1 Response: **'+res.toString());       
        } 
        
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 1 BM login error: **'+ e);
            LX_CommonUtilities.createExceptionLog(e);
                           
                oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 1 - Login Failed to Big Machines';
                caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 1 - Login Failed to Big Machines';
                hasErrorOccured = true;                         
        }
// BM Login Method - End        

// Callout 2
// BM Create Transaction Method - Start : Use session Id and return Big Machines Transaction id 'bmId'       
        SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:soap.bigmachines.com"><soapenv:Header><urn:xsdInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="true"><urn:schemaLocation>https://'+bmOrgName+'.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/commerce/quickstart_commerce_process.xsd</urn:schemaLocation></urn:xsdInfo><urn:category soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="false">Commerce</urn:category><urn:userInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="false"><urn:sessionId>'+sessionId+'</urn:sessionId></urn:userInfo></soapenv:Header><soapenv:Body><urn:createTransaction><urn:transaction><urn:process_var_name>quickstart_commerce_process</urn:process_var_name><urn:return_specific_attributes><urn:documents><urn:document><urn:var_name>quote_process</urn:var_name><urn:attributes><urn:attribute>_document_number</urn:attribute></urn:attributes></urn:document></urn:documents></urn:return_specific_attributes></urn:transaction></urn:createTransaction></soapenv:Body></soapenv:Envelope>';
        system.debug ('Create Transaction XML = '+SoapXMLBody);
        req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);
              
        try 
        {
            res = http.send(req);
            system.debug ('BM Create Transaction Response'+res.toString()+res.getbody()); 
            String BMSessionbody = res.getbody() ; 
            System.debug('**Create Transaction Callout 2 Response: **'+res.toString()); 
            Integer startSession = BMSessionbody.indexOf('<bm:id>',0) + '<bm:id>'.length(); 
            Integer endSession = BMSessionbody.indexOf('</bm:id>',0);
            if(startSession!=(-1 + '<bm:id>'.length()) || endSession != -1){
                bmId =  BMSessionbody.substring(startSession,endSession); 
                system.debug ('**BM Create Transaction Response BMID = **'+ bmId) ;                 
            }
            else{
                Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
                Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
                if(startExceptionMessage != (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage != -1){
                    String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                    System.debug('@@@ ' + exceptionMsg);
                                    
                    oppIntegrationErrorMsg+= '\n\nException Type: Create Transaction(Transaction Id) Failed' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 2 - Failed to create the transaction Id';
                    caseDescription+= '\n\nException Type: Create Transaction(Transaction Id) Failed' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 2 - Failed to create the transaction Id';                
                    hasErrorOccured = true;                  
                 }
            }
        } 
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 2 get bm id error: **'+ e);
            LX_CommonUtilities.createExceptionLog(e);

            oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 2 - Failed to generate the Transaction Id';
            caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 2 - Failed to generate the Transaction Id';
            hasErrorOccured = true; 
        }
// BM Create Transaction Method - End 
        if(sessionId!=null && sessionId!=''){
            caseDescription+= '\n\nSession Id: ' + sessionId;
            oppIntegrationErrorMsg+= '\n\nSession Id: ' + sessionId;
        }
        if(bmId!=null && bmId!=''){
            caseDescription+= '\n\nTransaction Id: ' + bmId;
            oppIntegrationErrorMsg+= '\n\nTransaction Id: ' + bmId;            
        }

//Logic for querying the opportunity and populating the additional SOAP XML Body : Begin
//Moved to the top so as to take care of exception handling and case creation: Shubhashish Rai - 5 August, 2014

        
        String SoapXMLBodyAdd;
        SoapXMLBodyAdd = ' ';
        if(oppList.size()>0){
            Opportunity oppInstance = oppList[0];
            if(oppInstance.End_Date__c!=null){
                Date dEndDate = oppList[0].End_Date__c;
                DateTime dtEndDate = dateTime.newInstance(dEndDate.year(), dEndDate.month(),dEndDate.day(),0,0,0);
                System.debug('**@@@dEndDate Date**' + dEndDate);
                System.debug('**@@@dtEndDate**' + dtEndDate);
                SoapXMLBodyAdd += '<bm:endDate_quote>' + dEndDate + '</bm:endDate_quote>';
            }
            if(oppInstance.Begin_Date__c!=null){
                Date dBeginDate = oppList[0].Begin_Date__c;
                DateTime dtBeginDate = dateTime.newInstance(dBeginDate.year(), dBeginDate.month(),dBeginDate.day(),0,0,0);
                System.debug('**@@@dBeginDate Date**' + dBeginDate );
                System.debug('**@@@dtBeginDate **' + dtBeginDate );
                SoapXMLBodyAdd += '<bm:startDate_quote>' + dBeginDate + '</bm:startDate_quote>';
            }

// Standard Quick Bids will always have a Customer. 
            if(oppInstance.LX_Quick_Bid_Type__c == 'Standard'){
                SoapXMLBodyAdd += '<bm:isThisQuoteForASpecificEndUserCustomer_Quote>Yes</bm:isThisQuoteForASpecificEndUserCustomer_Quote>';
            }
// Demo Quick Bids might not have a Customer. Pending Design , in the mean time set to Yes. 
            if(oppInstance.LX_Quick_Bid_Type__c == 'Demo'){
                SoapXMLBodyAdd += '<bm:isThisQuoteForASpecificEndUserCustomer_Quote>Yes</bm:isThisQuoteForASpecificEndUserCustomer_Quote>';
            }
            if(oppInstance.MPS__c){
                SoapXMLBodyAdd += '<bm:isThisQuoteForManagedPrintServices_Quote>Yes</bm:isThisQuoteForManagedPrintServices_Quote>';
            }
            if(!oppInstance.MPS__c){
                SoapXMLBodyAdd += '<bm:isThisQuoteForManagedPrintServices_Quote>No</bm:isThisQuoteForManagedPrintServices_Quote>';
            }
// Standard Quick Bids should have quote category as Special Bid Traditional and should not be null. 
// Demo Quick Bids might have quote category Special Bid Traditional. Pending Design , in the mean time set to Special Bid Traditional. 
            if(oppInstance.LX_Quote_Category__c!=null && oppInstance.LX_Quote_Category__c!=''){
                SoapXMLBodyAdd += '<bm:quoteCategory_quote>' + oppInstance.LX_Quote_Category__c + '</bm:quoteCategory_quote>' ;
            }
            if(oppInstance.LX_Quick_Bid_Type__c!=null && oppInstance.LX_Quick_Bid_Type__c!=''){
                SoapXMLBodyAdd += '<bm:quickBidType_Quote>'+oppInstance.LX_Quick_Bid_Type__c+'</bm:quickBidType_Quote>' ; 
            }                       
            if(oppInstance.Sales_Organization_Geo__c!=null && oppInstance.Sales_Organization_Geo__c!=''){
                SoapXMLBodyAdd += '<bm:salesGeo_quote>' + oppInstance.Sales_Organization_Geo__c + '</bm:salesGeo_quote>';
            }
            if(oppInstance.Sales_Organization__r.LX_Sales_Group__c!=null && oppInstance.Sales_Organization__r.LX_Sales_Group__c!=''){
                SoapXMLBodyAdd += '<bm:salesGroup_quote>' + oppInstance.Sales_Organization__r.LX_Sales_Group__c + '</bm:salesGroup_quote>';
            }
            if(oppInstance.Sales_Organization_value__c !=null && oppInstance.Sales_Organization_value__c != ''){
                SoapXMLBodyAdd += '<bm:salesOrg_quote>' + oppInstance.Sales_Organization_value__c + '</bm:salesOrg_quote>';
            }
            if(oppInstance.Sales_Organization__r.LX_Sales_Office__c !=null && oppInstance.Sales_Organization__r.LX_Sales_Office__c != ''){
                SoapXMLBodyAdd += '<bm:salesOffice_quote>' + oppInstance.Sales_Organization__r.LX_Sales_Office__c + '</bm:salesOffice_quote>';
            }
            if(oppInstance.Sales_Organization__r.Name !=null){
                SoapXMLBodyAdd += '<bm:salesRegion_quote>' + oppInstance.Sales_Organization__r.Name + '</bm:salesRegion_quote>';
            }
            if(oppInstance.CurrencyIsoCode !=null && oppInstance.CurrencyIsoCode != ''){
                SoapXMLBodyAdd += '<bm:sessionCurrency_quote>' + oppInstance.CurrencyIsoCode + '</bm:sessionCurrency_quote>';
            }
        }
        System.debug('**@@@SoapXMLBodyAdd**' + SoapXMLBodyAdd );
// Callout 3
// BM Save Quote - Begin : Use the same bmid and perform the Save Operation by calling 'save_quote' method.  

        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://'+bmOrgName+'.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>'+bmOrgName+'</bm:buyer_company_name><bm:supplier_company_name>'+bmOrgName+'</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="'+bmOrgName+'" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="'+bmOrgName+'"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:isQuickBid_quote>true</bm:isQuickBid_quote>';
        if(SoapXMLBodyAdd != ' ')
        SoapXMLBody += SoapXMLBodyAdd ;
        SoapXMLBody += '<bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>save_quote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction save_quote '+SoapXMLBody);
        req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody); 
        req.setTimeout(20000); 
        
        try {
            res = http.send(req);
            system.debug ('**BM Save Quote Callout 3 Response**'+res.toString()+res.getbody()); 
            String BMSessionbody = res.getbody();
                Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
                Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
                if(startExceptionMessage!= (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage!= -1){
                    String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                    System.debug('@@@ ' + exceptionMsg);
                                       
                    oppIntegrationErrorMsg+= '\n\nException Type: Failed to Save the Quote Header' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 3 - Failed to create the quote header';
                    caseDescription+= '\n\nException Type: Failed to Save the Quote Header' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 3 - Failed to create the quote header';
                    hasErrorOccured = true;                     
                }
        }
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 3 Save Quote Header error** '+ e);
            LX_CommonUtilities.createExceptionLog(e);
            
             oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 3 - Failure to save the quote header';
             caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 3 - Failure to save the quote header';
             hasErrorOccured = true; 
        }
               
// BM Save Quote - End     

// Callout 4
// Send Products from SFDC to BM - Begin  : Use the same bmid and send Products to BM by Dynamic retrieval of Opportunity Pricelist Products .
// Querying the Opportunity Pricelist Products based on the OppId
        List<LX_Opportunity_Pricelist_Product__c> lstOppPricelistProd = new List<LX_Opportunity_Pricelist_Product__c>();
        String queryOppPricelistProd = 'Select id, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Quantity__c, LX_Discount__c,LX_Total_Requested_Discount__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c IN (\'' + oppId + '\')';
        try{
            lstOppPricelistProd = Database.query(queryOppPricelistProd);
            System.debug('**@@@lstOppPricelistProd**' + lstOppPricelistProd);
        }
        catch(Exception ex){
            System.debug('**Query Price List Product Exception**'+ex);
        
        }

//Sending Pricelist Products in the format - 2354208$2$100$Amt#2354236$4$300$Amt. Syntax is Product_Number$Quantity$Requested_Discount$Amt (Amt means Amount Off in BM discount Type) - Every pricelist product separated by # 

        String SoapXMLBodyValues = '';
        Integer lstIterator = 0;
        List<String> lstSoapXMLBodyValues = new List<String>();
        Map<String,List<LX_Opportunity_Pricelist_Product__c>> configIdPricelistProductMap = new Map<String,List<LX_Opportunity_Pricelist_Product__c>>();
        for(LX_Opportunity_Pricelist_Product__c oppPricelistProd: lstOppPricelistProd){
            if(configIdPricelistProductMap.get(oppPricelistProd.Parent_ID__c)!=null){
                List<LX_Opportunity_Pricelist_Product__c> tempOppPricelistProduct = new List<LX_Opportunity_Pricelist_Product__c>();
                tempOppPricelistProduct = configIdPricelistProductMap.get(oppPricelistProd.Parent_ID__c);
                tempOppPricelistProduct.add(oppPricelistProd);
                configIdPricelistProductMap.put(oppPricelistProd.Parent_Id__c,tempOppPricelistProduct);
            }
            else{
                List<LX_Opportunity_Pricelist_Product__c> tempOppPricelistProduct = new List<LX_Opportunity_Pricelist_Product__c>();
                tempOppPricelistProduct.add(oppPricelistProd);
                configIdPricelistProductMap.put(oppPricelistProd.Parent_Id__c,tempOppPricelistProduct);
            }
        }
        System.debug('**@@@configIdPricelistProductMap**' + configIdPricelistProductMap.size() + configIdPricelistProductMap);
        
        for(String str: configIdPricelistProductMap.keyset()){
            SoapXMLBodyValues = '';
            lstIterator = 0;

            for(LX_Opportunity_Pricelist_Product__c oppPricelistProd: configIdPricelistProductMap.get(str)){
                lstIterator++;
                if(oppPricelistProd.LX_Part_Number__c != null && oppPricelistProd.LX_Part_Number__c != ''){
                    SoapXMLBodyValues +=oppPricelistProd.LX_Part_Number__c + '$';
                }
                //else if LX_Part_Number__c is null or blank then parse as 0
                if(oppPricelistProd.LX_Part_Number__c == null || oppPricelistProd.LX_Part_Number__c == ''){
                    SoapXMLBodyValues += '0$';
                }
                if(oppPricelistProd.LX_Quantity__c != null){
                    SoapXMLBodyValues +=oppPricelistProd.LX_Quantity__c + '$';
                }
                if(oppPricelistProd.LX_Quantity__c == null || oppPricelistProd.LX_Quantity__c == 0){
                    SoapXMLBodyValues +='0$';
                }
                if(oppPricelistProd.LX_Discount__c != null){
                    SoapXMLBodyValues += oppPricelistProd.LX_Discount__c + '$Amt';
                }
                if(oppPricelistProd.LX_Discount__c == null || oppPricelistProd.LX_Discount__c == 0){
                    SoapXMLBodyValues +='0$Amt';
                }
                if(lstIterator!=configIdPricelistProductMap.get(str).size()){
                    SoapXMLBodyValues +='#';
                }
            }
            lstSoapXMLBodyValues.add(SoapXMLBodyValues);
            System.debug('**@@@configId**' + str);
            SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Configuration</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://'+bmOrgName+'.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/config/lexmark/lexmark_productline_lexmark_model.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:configure xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:item><bm:segment>lexmark</bm:segment><bm:product_line>lexmark_productline</bm:product_line><bm:model>lexmark_model</bm:model></bm:item><bm:responseIncludes><bm:price>true</bm:price><bm:spare>true</bm:spare><bm:bom>true</bm:bom><bm:attributeLabel>false</bm:attributeLabel><bm:previousValue>false</bm:previousValue><bm:displayedValue>false</bm:displayedValue><bm:hideInTransactionAttributes>true</bm:hideInTransactionAttributes><bm:ruleDetails>true</bm:ruleDetails><bm:transaction><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:document_var_name>quote_process</bm:document_var_name><bm:id>'+bmId+'</bm:id></bm:transaction></bm:responseIncludes><bm:attributes><bm:attribute bm:_variableName="pleaseInputYourQuickBidPartsString"><bm:value>';
            System.debug('**@@@SoapXMLBodyValues**' + SoapXMLBodyValues);
            SoapXMLBody +=SoapXMLBodyValues ;
            SoapXMLBody +='</bm:value></bm:attribute></bm:attributes></bm:configure></soapenv:Body></soapenv:Envelope>';
            System.debug ('**Send Products from SFDC to BM** '+SoapXMLBody);
            req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
            req.setMethod('POST');
            req.setBody(SoapXMLBody); 
            req.setTimeout(40000);
             
            try {
                res = http.send(req);
                system.debug ('**BM Send Products Callout 4 Response**'+res.toString()+res.getbody()); 
                String BMSessionbody = res.getbody();
                Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
                Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
                if(startExceptionMessage!= (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage!= -1){
                    String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                    System.debug('@@@ ' + exceptionMsg);
               
                oppIntegrationErrorMsg+= '\n\nException Type: Failed to insert products on the quote' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 4 - Failed to add products on the quote';
                caseDescription+= '\n\nException Type: Failed to insert products on the quote' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 4 - Failed to add products on the quote';
                hasErrorOccured = true;                                     
                }
            }
            catch(System.CalloutException e) 
            {
                System.debug('**Callout 4 Product Insert error: **'+ e);
                LX_CommonUtilities.createExceptionLog(e);
                
                oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 4 - Failure to insert the products on the opportunity';
                caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 4 - Failure to insert the products on the opportunity';
                hasErrorOccured = true; 
              }
        }
// Send Products from SFDC to BM - End

// Callout 5
// BM Save Quote after Product Insert- Begin : Use the same bmid and perform the Save Operation by calling 'save_quote' method.  

        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://'+bmOrgName+'.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>'+bmOrgName+'</bm:buyer_company_name><bm:supplier_company_name>'+bmOrgName+'</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="'+bmOrgName+'" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="'+bmOrgName+'"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>save_quote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction save_quote 2** '+SoapXMLBody);
        req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);  
        
        try {
            res = http.send(req);
            system.debug ('**BM save quote after Products Callout 5 Response**'+res.toString()+res.getbody()); 
            String BMSessionbody = res.getbody();
                Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
                Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
                
                if(startExceptionMessage!= (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage!= -1){
                    String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                    System.debug('@@@ ' + exceptionMsg);
                    
                oppIntegrationErrorMsg+= '\n\nException Type: Save quote failed after adding the products on the quote' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 5 - Save quote failed after adding the products';
                caseDescription+= '\n\nException Type: Save quote failed after adding the products on the quote' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 5 - Save quote failed after adding the products';
                hasErrorOccured = true;              
                    
                }
        }
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 5 After Product Insert error: **'+ e);
                LX_CommonUtilities.createExceptionLog(e);
                
                oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 5 - Error while saving quote after inserting products';
                caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 5 - Error while saving quote after inserting products';
                hasErrorOccured = true;                 
        }        
// BM Save Quote after Product Insert- Begin : - End

// Callout 6
// BM Call Approval Process : Begin
        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://'+bmOrgName+'.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>'+bmOrgName+'</bm:buyer_company_name><bm:supplier_company_name>'+bmOrgName+'</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="'+bmOrgName+'" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="'+bmOrgName+'"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>submit_quote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction submit_quote** '+SoapXMLBody);
        req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);          
        
        try {
            res = http.send(req);
            system.debug ('**BM submit_quote after Products save Callout 6 Response**'+res.toString()+res.getbody());
            String BMSessionbody = res.getbody();
                Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
                Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
                if(startExceptionMessage!= (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage!= -1){
                    String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                    System.debug('@@@ ' + exceptionMsg);

                oppIntegrationErrorMsg+= '\n\nException Type: Approval Process couldn\'t be invoked' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 6 - Approval Process couldn\'t be invoked';
                caseDescription+= '\n\nException Type: Approval Process couldn\'t be invoked' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 6 - Approval Process couldn\'t be invoked';
                hasErrorOccured = true;       
                }
        }
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 6 invoke approval process error: **'+ e);
                LX_CommonUtilities.createExceptionLog(e);
                 
                oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 6 - Error while invoking approval process';
                caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 6 - Error while invoking approval process';
                hasErrorOccured = true;                 
                   
        }
// BM Call Approval Process : End  

// Integration Exception handling and Case Creation : Begin      
        List<Contact> contactList= [Select id, Email from Contact where Email=: UserInfo.getUserEmail() and RecordType.Name = 'Resource Contact'];
        System.debug('@@@ contactList'+ contactList);
        
        if(hasErrorOccured){
                    oppList[0].LX_Quick_Bid_Integration_Error__c = true;
                    oppList[0].LX_Quick_Bid_Integration_Error_Message__c = oppIntegrationErrorMsg;
                    oppList[0].LX_In_Approval_Process_Quick_Bid__c  = true;
                  //  oppList[0].Quote_Status__c  = 'Start';                    
                   
                    Case csInstance = new Case();
                    
                    csInstance.LX_Opportunity__c = OppId;
                    csInstance.RecordTypeId = caseRecordTypeQuickBid.Id;
                    csInstance.Description = caseDescription;
                    csInstance.OwnerId = quickBidsSupportQueue[0].id;
                    csInstance.Subject = 'Quick Bids Exception'  + ' - ' + oppList[0].Opportunity_Number__c + ' - ' + String.valueOf(Date.today()); 
                    csInstance.Status = 'New';
                    csInstance.Priority = 'High';
                    csInstance.Origin = 'Opportunity';
                    
                    if(contactList.size()>0)
                        csInstance.ContactId = contactList[0].id;        
                    try{
                        Database.update(oppList[0]);
                    }
                    catch(Exception ex){
                        isOppDataCorrect = false;
                        LX_CommonUtilities.createExceptionLog(ex);
                        System.debug('@@@ ' + ex);
                    }
                    try{
                        Database.insert(csInstance);
                    }
                    catch(Exception ex){
                        LX_CommonUtilities.createExceptionLog(ex);
                        System.debug('@@@ ' + ex);                    
                    }
                    if(isOppDataCorrect){
                        return strFailed;
                    }
                    else
                        return strFailedContactAdmin;
        }
        else{
            oppList[0].LX_In_Approval_Process_Quick_Bid__c  = true;
         //   oppList[0].Quote_Status__c  = 'Start';
            try{
                Database.update(oppList[0]);
            }
            catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
            }
            return strSuccess;
        }   
// Integration Exception handling and Case Creation : End 
    }
}