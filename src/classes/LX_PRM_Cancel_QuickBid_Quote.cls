/* Class Name   : LX_PRM_Cancel_QuickBid_Quote
* Description   : Web Service Callout to Big machines to cancel the Quick Bid Quote.As per US4202.  
* Created By   : Sanjay Chaudhary
* Created Date :  07-31-2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay Chaudhary          07-31-2014                                Initial Version
*/

global class  LX_PRM_Cancel_QuickBid_Quote {

    Webservice static String cancelQuickBidQuote(string OppId, String OppName) {
                
        String sessionId = '';
        String bmid = '';
        String bmusername = Label.LX_Bigmachines_UserName;
        String bmpassword = Label.LX_Bigmachines_UserPassword;
        String bmOrgName = Label.LX_Bigmachines_OrgName;
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        final String strSuccess = Label.LX_Return_String_PRM_BM_Callouts ;
        final String strFailed = Label.LX_Failed_Return_String_PRM_BM_Callouts;
        final String strSiteDownForMaintenace = Label.LX_BigMachines_DownTime;
        final String strSiteDownForMaintenanceReturnString = Label.LX_Site_Down_For_Maintenance_BigMachines_Return_String;        

        List<Contact> contactCurrentList= [Select id,Email from Contact where Email=: UserInfo.getUserEmail() and RecordType.Name = 'Resource Contact'];
        RecordType caseRecordTypeQuickBid = [Select id, Name from RecordType where sObjectType = 'Case' and Name = 'Quick Bid Case'];
        List<Group> quickBidsSupportQueue = [Select id from Group where type = 'Queue' and DeveloperName = 'LX_Quick_Bids_Support_Queue'];
        
        String oppIntegrationErrorMsg = '';
        String caseDescription = '';
        boolean hasErrorOccured = false;
        boolean isOppDataCorrect = true;

        String queryString = 'Select id,Name,Opportunity_Number__c, LX_Quick_Bid_Type__c,CurrencyIsoCode,LX_Quick_Bid_Integration_Error__c, LX_Quick_Bid_Integration_Error_Message__c, End_Date__c, AccountId ,Account.Name, CloseDate, Begin_Date__c, LX_End_User_Account__c, MPS__c, LX_Reason_for_Discount_Rebate__c, LX_Quote_Category__c, Sales_Organization_value__c, Sales_Organization_Geo__c, Sales_Organization__c, Sales_Organization__r.LX_Sales_Group__c,Sales_Organization__r.Name, Sales_Organization__r.LX_Sales_Office__c , Sales_Organization__r.CurrencyIsoCode, pse__Region__c from Opportunity where Id in (\'' + OppID + '\')';
        List<Opportunity> oppList = new List<Opportunity>();
        
        try{
            oppList = Database.query(queryString);
            System.debug('**@@@oppList**' + oppList);
        }
        
        catch(Exception ex){
            System.debug('**Query Opportunity Attributes Exception**'+ex);
        }

// get the bmid of the Quote to be cancelled.         
        List<BigMachines__Quote__c> bmQuote = [Select Id,BigMachines__Transaction_Id__c from BigMachines__Quote__c where BigMachines__Opportunity__c =:oppId and BigMachines__Status__c !='Cancelled'] ;
        if(bmQuote.size()>0){
        bmid = bmQuote[0].BigMachines__Transaction_Id__c ;                
// Callout 1        
// BM Login Method - Start : Log into Big Machines via Integration User and return session Id .
       
        String SoapXMLBody = '';
        SoapXMLBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:soap.bigmachines.com"><soapenv:Header><urn:xsdInfo soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="?"><urn:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/security/Security.xsd</urn:schemaLocation></urn:xsdInfo><urn:category soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="?">Security</urn:category></soapenv:Header><soapenv:Body><urn:login><urn:userInfo><urn:username>'+bmusername+'</urn:username><urn:password>'+bmpassword+'</urn:password></urn:userInfo></urn:login></soapenv:Body></soapenv:Envelope>';
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
                    oppList[0].LX_Quick_Bid_Integration_Error_Message__c = 'BigMachines site down for maintenance. Quote not cancelled for the opportunity.';
                    oppList[0].LX_In_Approval_Process_Quick_Bid__c  = true;
                    
                    Case csInstance = new Case();
                    
                    csInstance.LX_Opportunity__c = OppId;
                    csInstance.RecordTypeId = caseRecordTypeQuickBid.Id;
                    csInstance.Description = 'BigMachines site down for maintenance. Quote not cancelled for the opportunity.';
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
            System.debug('**BM Login Callout 1 Response: **'+res.toString());       
            } 
        }
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 1 BM login error: **'+ e);
            oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 1 - Login Failed to Big Machines';
            caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 1 - Login Failed to Big Machines';
            hasErrorOccured = true;      
        }
// BM Login Method - End 

    if(sessionId!=null && sessionId!=''){
            caseDescription+= '\n\nSession Id: ' + sessionId;
            oppIntegrationErrorMsg+= '\n\nSession Id: ' + sessionId;
    }       

// Callout 2
// BM Call Cancellation Process : Begin
        SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://'+bmOrgName+'.bigmachines.com/bmfsweb/'+bmOrgName+'/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>'+bmOrgName+'</bm:buyer_company_name><bm:supplier_company_name>'+bmOrgName+'</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="'+bmOrgName+'" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="'+bmOrgName+'"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>cancelQuote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction cancelQuote** '+SoapXMLBody);
        req.setEndpoint('https://'+bmOrgName+'.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody);  
        
        try {
            res = http.send(req);
            String BMSessionbody = res.getbody();
            Integer startExceptionMessage = BMSessionbody.indexOf('<bm:exceptionMessage>',0) + '<bm:exceptionMessage>'.length(); 
            Integer endExceptionMessage = BMSessionbody.indexOf('</bm:exceptionMessage>',0);
            if(startExceptionMessage != (-1 + '<bm:exceptionMessage>'.length()) || endExceptionMessage != -1){
                String exceptionMsg = BMSessionbody.substring(startExceptionMessage,endExceptionMessage);
                System.debug('@@@ ' + exceptionMsg);
                                    
            oppIntegrationErrorMsg+= '\n\nException Type: Cancel Quote' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 2 - Cancelling the quote did not work';
            caseDescription+= '\n\nException Type: Cancel Quote' + '\nException Message: ' + exceptionMsg + '\nStep where the error occured: Step 2 - Cancelling the quote did not work';
            hasErrorOccured = true; 
            } 
            system.debug ('**BM cancelQuote Callout 2 Response**'+res.toString()+res.getbody()); 
        }
        catch(System.CalloutException e) 
        {
            System.debug('**Callout 2 invoke cancellation process error: **'+ e);
            oppIntegrationErrorMsg+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 2 - Cancelling the quote did not work';
            caseDescription+= '\n\nException Type: ' + e.getTypeName() + '\nException Message: ' + e.getMessage() + '\nStep where the error occured: Step 2 - Cancelling the quote did not work';
            hasErrorOccured = true;  
        }   
// BM Call Cancellation Process : Begin    
    }
    
    if(hasErrorOccured){
        
         oppList[0].LX_Quick_Bid_Integration_Error__c = true;
         oppList[0].LX_Quick_Bid_Integration_Error_Message__c = oppIntegrationErrorMsg;
           
            Case csInstance = new Case();
            
            csInstance.LX_Opportunity__c = OppId;
            csInstance.RecordTypeId = caseRecordTypeQuickBid.Id;
            csInstance.Description = caseDescription;
            csInstance.OwnerId = quickBidsSupportQueue[0].id;
            csInstance.Subject = 'Quick Bids Exception'  + ' - ' + oppList[0].Opportunity_Number__c + ' - ' + String.valueOf(Date.today()); 
            csInstance.Status = 'New';
            csInstance.Priority = 'High';
            csInstance.Origin = 'Opportunity';
            if(contactCurrentList.size()>0)
                csInstance.ContactId = contactCurrentList[0].Id;
            try{
                Database.update(oppList[0]);
                Database.insert(csInstance);
            } 
            catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
            }                 
                    
    }

// Unchecking the Primary Flag once the Quote has been cancelled.     
    List<BigMachines__Quote__c> bmQuoteUpdateList = new List <BigMachines__Quote__c>();
    if(bmQuote.size()>0){
        for (BigMachines__Quote__c b:bmQuote){
            b.BigMachines__Is_Primary__c = False;
            bmQuoteUpdateList.add(b);
            }
            try{
                update bmQuoteUpdateList ;         
            }
            catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
                System.debug('@@@ ' + ex);
            }
        }
    
    if(hasErrorOccured)
        return strFailed ;
    else{
        oppList[0].LX_In_Approval_Process_Quick_Bid__c  = false;
        oppList[0].Quote_Status__c = 'Cancelled';
        try{
            Database.update(oppList[0]);
        }
        catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }
        return strSuccess ;
    }
    }
}