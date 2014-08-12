/* Class Name   : PRM_WebServiceCallout 
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

global class  PRM_WebServiceCallout {

    Webservice static void sendNotification(string OppId, String OppName) {
                
        String sessionId = '';
        String bmid = '';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
// BM Login Method - Start : Log into Big Machines via Integration User and return session Id .
       
        String SoapXMLBody = '';
        SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:soap.bigmachines.com"><soapenv:Header><urn:xsdInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="?"><urn:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/security/Security.xsd</urn:schemaLocation></urn:xsdInfo><urn:category soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="?">Security</urn:category></soapenv:Header><soapenv:Body><urn:login><urn:userInfo><urn:username>vapoosarla</urn:username><urn:password>vadhar67$</urn:password></urn:userInfo></urn:login></soapenv:Body></soapenv:Envelope>';
        req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
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
            sessionId =  BMSessionbody.substring(startSession,endSession); 
            system.debug ('BM Login Call Session Id = '+ sessionId) ;       
        } 
        
        catch(System.CalloutException e) 
        {
            System.debug('Callout 1 error: '+ e);
            System.debug(res.toString());
        }
// BM Login Method - End        

// BM Create Transaction Method - Start : Use session Id and return Big Machines Transaction id 'bmId'       
        SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:soap.bigmachines.com"><soapenv:Header><urn:xsdInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="true"><urn:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</urn:schemaLocation></urn:xsdInfo><urn:category soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="false">Commerce</urn:category><urn:userInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="false"><urn:sessionId>'+sessionId+'</urn:sessionId></urn:userInfo></soapenv:Header><soapenv:Body><urn:createTransaction><urn:transaction><urn:process_var_name>quickstart_commerce_process</urn:process_var_name><urn:return_specific_attributes><urn:documents><urn:document><urn:var_name>quote_process</urn:var_name><urn:attributes><urn:attribute>_document_number</urn:attribute></urn:attributes></urn:document></urn:documents></urn:return_specific_attributes></urn:transaction></urn:createTransaction></soapenv:Body></soapenv:Envelope>';
        system.debug ('Create Transaction XML = '+SoapXMLBody);
        req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);
        
        
        try 
        {
            res = http.send(req);
            system.debug ('BM Create Transaction Response'+res.toString()+res.getbody()); 
            String BMSessionbody = res.getbody() ; 
            Integer startSession = BMSessionbody.indexOf('<bm:id>',0) + '<bm:id>'.length(); 
            Integer endSession = BMSessionbody.indexOf('</bm:id>',0);
            bmId =  BMSessionbody.substring(startSession,endSession); 
            system.debug ('BM Create Transaction Response BMID = '+ bmId) ;       
        } 
        catch(System.CalloutException e) 
        {
            System.debug('Callout 2 error: '+ e);
            System.debug(res.toString());
        }
// BM Create Transaction Method - End 

//Logic for querying the opportunity and populating the additional SOAP XML Body : Begin

        List<Opportunity> oppList = new List<Opportunity>();
        String queryString = 'Select id,End_Date__c, AccountId ,Account.Name, CloseDate, Begin_Date__c, LX_End_User_Account__c, MPS__c, LX_Reason_for_Discount_Rebate__c, LX_Quote_Category__c, Sales_Organization_value__c, Sales_Organization_Geo__c, Sales_Organization__c, Sales_Organization__r.LX_Sales_Group__c, Sales_Organization__r.LX_Sales_Office__c , Sales_Organization__r.CurrencyIsoCode, pse__Region__c from Opportunity where Id in (\'' + OppID + '\')';
        try{
            oppList = Database.query(queryString);
            System.debug('@@@oppList' + oppList);
        }
        
        catch(Exception ex){
            System.debug(ex);
        }
        
        String SoapXMLBodyAdd;
        SoapXMLBodyAdd = ' ';
        if(oppList.size()>0){
            Opportunity oppInstance = oppList[0];
            if(oppInstance.End_Date__c!=null){
                Date dEndDate = oppList[0].End_Date__c;
                DateTime dtEndDate = dateTime.newInstance(dEndDate.year(), dEndDate.month(),dEndDate.day(),0,0,0);
                System.debug('@@@dEndDate Date' + dEndDate);
                System.debug('@@@dtEndDate' + dtEndDate);
                SoapXMLBodyAdd += '<bm:endDate_quote>' + dEndDate + '</bm:endDate_quote>';
            }
            if(oppInstance.Begin_Date__c!=null){
                Date dBeginDate = oppList[0].Begin_Date__c;
                DateTime dtBeginDate = dateTime.newInstance(dBeginDate.year(), dBeginDate.month(),dBeginDate.day(),0,0,0);
                System.debug('@@@dBeginDate Date' + dBeginDate );
                System.debug('@@@dtBeginDate ' + dtBeginDate );
                SoapXMLBodyAdd += '<bm:startDate_quote>' + dBeginDate + '</bm:startDate_quote>';
            }
            if(oppInstance.AccountId!=null){
                 SoapXMLBodyAdd += '<bm:sFDCAccountIDJQ_quote>' + oppInstance.AccountId + '</bm:sFDCAccountIDJQ_quote>';
            }
             if(oppInstance.Account.Name!=null && oppInstance.Account.Name!=''){
                 SoapXMLBodyAdd += '<bm:sFDCAccountName_quote>' + oppInstance.Account.Name + '</bm:sFDCAccountName_quote>';
            }
            if(oppInstance.LX_End_User_Account__c!=null){
                SoapXMLBodyAdd += '<bm:isThisQuoteForASpecificEndUserCustomer_Quote>Yes</bm:isThisQuoteForASpecificEndUserCustomer_Quote>';
            }
            if(oppInstance.LX_End_User_Account__c==null){
                SoapXMLBodyAdd += '<bm:isThisQuoteForASpecificEndUserCustomer_Quote>No</bm:isThisQuoteForASpecificEndUserCustomer_Quote>';
            }
            if(oppInstance.MPS__c){
                SoapXMLBodyAdd += '<bm:isThisQuoteForManagedPrintServices_Quote>Yes</bm:isThisQuoteForManagedPrintServices_Quote>';
            }
            if(!oppInstance.MPS__c){
                SoapXMLBodyAdd += '<bm:isThisQuoteForManagedPrintServices_Quote>No</bm:isThisQuoteForManagedPrintServices_Quote>';
            }
            
            //Shubhashish - Need to confirm on this field
            if(oppInstance.LX_Reason_for_Discount_Rebate__c!=null && oppInstance.LX_Reason_for_Discount_Rebate__c!=''){
                SoapXMLBodyAdd += '<bm:areYouProvidingLineSeriesDiscounting_Quote>Yes</bm:areYouProvidingLineSeriesDiscounting_Quote>';
            }
            if(oppInstance.LX_Reason_for_Discount_Rebate__c==null){
                SoapXMLBodyAdd += '<bm:areYouProvidingLineSeriesDiscounting_Quote>No</bm:areYouProvidingLineSeriesDiscounting_Quote>';
            }
            if(oppInstance.LX_Quote_Category__c!=null && oppInstance.LX_Quote_Category__c!=''){
                SoapXMLBodyAdd += '<bm:quoteCategory_quote>' + oppInstance.LX_Quote_Category__c + '</bm:quoteCategory_quote>' ;
            }
            //Hardcoding Quote Category attribute in the callout when Quote Category is not filled on the Opportunity
            if(oppInstance.LX_Quote_Category__c==''){
                SoapXMLBodyAdd += '<bm:quoteCategory_quote>Special Bid Traditional</bm:quoteCategory_quote>' ; 
            }
            if(oppInstance.Sales_Organization_Geo__c!=null && oppInstance.Sales_Organization_Geo__c!=''){
                SoapXMLBodyAdd += '<bm:salesGeo_quote>' + oppInstance.Sales_Organization_Geo__c + '</bm:salesGeo_quote>';
            }
            if(oppInstance.Sales_Organization__r.LX_Sales_Group__c!=null && oppInstance.Sales_Organization__r.LX_Sales_Group__c!=''){
                SoapXMLBodyAdd += '<bm:salesGroup_quote>' + oppInstance.Sales_Organization__r.LX_Sales_Group__c + '</bm:salesGroup_quote>';
            }
            if(oppInstance.Sales_Organization__r.LX_Sales_Group__c==''){
                SoapXMLBodyAdd += '<bm:salesGroup_quote></bm:salesGroup_quote>';
            }
            if(oppInstance.Sales_Organization_value__c !=null && oppInstance.Sales_Organization_value__c != ''){
                SoapXMLBodyAdd += '<bm:salesOrg_quote>' + oppInstance.Sales_Organization_value__c + '</bm:salesOrg_quote>';
            }
            if(oppInstance.Sales_Organization__r.LX_Sales_Office__c !=null && oppInstance.Sales_Organization__r.LX_Sales_Office__c != ''){
                SoapXMLBodyAdd += '<bm:salesOffice_quote>' + oppInstance.Sales_Organization__r.LX_Sales_Office__c + '</bm:salesOffice_quote>';
            }
            if(oppInstance.Sales_Organization__r.LX_Sales_Office__c == ''){
                SoapXMLBodyAdd += '<bm:salesOffice_quote></bm:salesOffice_quote>';
            }
            if(oppInstance.pse__Region__c !=null){
                SoapXMLBodyAdd += '<bm:salesRegion_quote>' + oppInstance.pse__Region__c + '</bm:salesRegion_quote>';
            }
            if(oppInstance.pse__Region__c ==null){
                SoapXMLBodyAdd += '<bm:salesRegion_quote></bm:salesRegion_quote>';
            }
            if(oppInstance.Sales_Organization__r.CurrencyIsoCode !=null && oppInstance.Sales_Organization__r.CurrencyIsoCode != ''){
                SoapXMLBodyAdd += '<bm:sessionCurrency_quote>' + oppInstance.Sales_Organization__r.CurrencyIsoCode + '</bm:sessionCurrency_quote>';
            }
        }
        System.debug('@@@SoapXMLBodyAdd' + SoapXMLBodyAdd );

//Logic for querying the opportunity and populating the additional SOAP XML Body : End

// BM Update Transaction Method - Begin : Use bmId and create Quote with Default Values to overcome Validation rules within Big Machines.
//                                        by calling 'quickBidDefaults' method within Big Machines. 
/*        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>DevLexmark</bm:buyer_company_name><bm:supplier_company_name>DevLexmark</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="DevLexmark" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="DevLexmark"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>quickBidDefaults</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction quickBidDefaults ='+SoapXMLBody);
        req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);  
    
        try {
            res = http.send(req);
            system.debug ('BM Update Transaction 1 Response'+res.toString()+res.getbody()); 
        }
        catch(System.CalloutException e) 
        {
            System.debug('Callout 2 error: '+ e);
            System.debug(res.toString());
        }
*/        
// BM Update Transaction Method - End 

// BM Save Quote - Begin : Use the same bmid and perform the Save Operation by calling 'save_quote' method.  

        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>DevLexmark</bm:buyer_company_name><bm:supplier_company_name>DevLexmark</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="DevLexmark" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="DevLexmark"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote>';
        if(SoapXMLBodyAdd != ' ')
        SoapXMLBody += SoapXMLBodyAdd ;
// Hardcode values as per done in 'quickBidDefaults' method within Big Machines
//      SoapXMLBody += '<bm:endDate_quote>2015-07-01 06:00:00</bm:endDate_quote><bm:startDate_quote>2014-07-08 06:00:00</bm:startDate_quote><bm:isThisQuoteForASpecificEndUserCustomer_Quote>Yes</bm:isThisQuoteForASpecificEndUserCustomer_Quote><bm:isThisQuoteForManagedPrintServices_Quote>No</bm:isThisQuoteForManagedPrintServices_Quote><bm:areYouProvidingLineSeriesDiscounting_Quote>No</bm:areYouProvidingLineSeriesDiscounting_Quote><bm:quoteCategory_quote>Special Bid Traditional</bm:quoteCategory_quote><bm:salesGeo_quote>NA</bm:salesGeo_quote><bm:salesGroup_quote></bm:salesGroup_quote><bm:salesOrg_quote>1012</bm:salesOrg_quote><bm:salesOffice_quote></bm:salesOffice_quote><bm:salesRegion_quote>France</bm:salesRegion_quote><bm:sessionCurrency_quote>EUR</bm:sessionCurrency_quote>';
        SoapXMLBody += '<bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>save_quote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction save_quote '+SoapXMLBody);
        req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);  
        
        try {
            res = http.send(req);
            system.debug ('BM Update Transaction 2 Response'+res.toString()+res.getbody()); 
        }
        catch(System.CalloutException e) 
        {
            System.debug('Callout 4 error: '+ e);
            System.debug(res.toString());
        }        
// BM Save Quote - End     

// BM importPricelistProductsForQuickBid - Begin : Use the same bmid and perform the importPricelistProductsForQuickBid Operation .  

            SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>DevLexmark</bm:buyer_company_name><bm:supplier_company_name>DevLexmark</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="DevLexmark" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="DevLexmark"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:isQuickBid_quote>true</bm:isQuickBid_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>importPricelistProductsForQuickBid</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
            System.debug ('Update Transaction importPricelistProductsForQuickBid '+SoapXMLBody);
            req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
            req.setMethod('POST');
            req.setBody(SoapXMLBody);  
            req.setTimeout(60000);
            try {
                res = http.send(req);
                system.debug ('BM Update Transaction 3 Response'+res.toString()+res.getbody()); 
            }
            catch(System.CalloutException e) 
            {
                System.debug('Callout 5 error: '+ e);
                System.debug(res.toString());
            }   
// BM fetchPricelistProducts - End  

// BM Save Quote 2 - Begin : Use the same bmid and perform the Save Operation by calling 'save_quote' method.  

        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>DevLexmark</bm:buyer_company_name><bm:supplier_company_name>DevLexmark</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="DevLexmark" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="DevLexmark"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>save_quote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction save_quote 2** '+SoapXMLBody);
        req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);  
        
        try {
            res = http.send(req);
            system.debug ('BM Update Transaction 4 Response'+res.toString()+res.getbody()); 
        }
        catch(System.CalloutException e) 
        {
            System.debug('Callout 6 error: '+ e);
            System.debug(res.toString());
        }        
// BM Save Quote 2 - End 
  
    }
}