/*
Class Name : PRM_WebServiceCallout_Batch
Description : Batch class to create the products based on the configuration ID
Created By : Shubhashish Rai (shrai@deloitte.com)
Created Date : 2-7-2014
Modification Log:
-------------------------------------------------------------------------
Developer            Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai      2-7-2014         1000                   Initial Version

*************************************************************************/


global class PRM_WebServiceCallout_Batch implements Database.Batchable<String>,Database.Stateful,Database.AllowsCallouts{
    List<String> lstSoapXMLBody;
    String sessionId;
    String bmId;
    String OppId;
    String OppName;
    global PRM_WebServiceCallout_Batch (List<String> lstSoapXMLBodyValues, String sessId, String bId,String OppId, String OppName){
        lstSoapXMLBody = new List<String>();
        lstSoapXMLBody.addAll(lstSoapXMLBodyValues);
        sessionId = sessId;
        bmId = bId;
        this.OppId = OppId;
        this.OppName = OppName;
        System.debug('@@@lstSoapXMLBody' + lstSoapXMLBody );
        System.debug('@@@lstSoapXMLBodyValues' + lstSoapXMLBody );
        System.debug('@@@sessionId ' + sessionId );   
        System.debug('@@@sessId' + sessId);
        System.debug('@@@bmId' + bmId);
        System.debug('@@@bId' + bId);
        System.debug('@@@this.OppId' + this.OppId);
        System.debug('@@@OppId' + OppId);
        System.debug('@@@this.OppName' + this.OppName);
        System.debug('@@@OppName' + OppName);
    }
    global List<String> start(Database.BatchableContext BC){
        return lstSoapXMLBody;
    }
    global void execute(Database.BatchableContext BC, List<String> Scope){
        for(String strSoapXMLBodyValues: Scope){
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            String SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Configuration</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/config/lexmark/lexmark_productline_lexmark_model.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:configure xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:item><bm:segment>lexmark</bm:segment><bm:product_line>lexmark_productline</bm:product_line><bm:model>lexmark_model</bm:model></bm:item><bm:responseIncludes><bm:price>true</bm:price><bm:spare>true</bm:spare><bm:bom>true</bm:bom><bm:attributeLabel>false</bm:attributeLabel><bm:previousValue>false</bm:previousValue><bm:displayedValue>false</bm:displayedValue><bm:hideInTransactionAttributes>true</bm:hideInTransactionAttributes><bm:ruleDetails>true</bm:ruleDetails><bm:transaction><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:document_var_name>quote_process</bm:document_var_name><bm:id>'+bmId+'</bm:id></bm:transaction></bm:responseIncludes><bm:attributes><bm:attribute bm:_variableName="pleaseInputYourPartsString"><bm:value>';
            System.debug('@@@strSoapXMLBodyValues' + strSoapXMLBodyValues);
            SoapXMLBody +=strSoapXMLBodyValues;
            SoapXMLBody +='</bm:value></bm:attribute></bm:attributes></bm:configure></soapenv:Body></soapenv:Envelope>';
            System.debug ('Send Products from SFDC to BM** '+SoapXMLBody);
            req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
            req.setMethod('POST');
            req.setBody(SoapXMLBody); 
            req.setTimeout(120000);
             
            try {
                res = http.send(req);
                system.debug ('BM Update Transaction 5 Response'+res.toString()+res.getbody()); 
            }
            catch(System.CalloutException e) 
            {
                System.debug('Callout 6 error - Update Transaction Error: '+ e);
                System.debug(res.toString());
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();    
        String SoapXMLBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>'+sessionId+'</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>'+bmId+'</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>DevLexmark</bm:buyer_company_name><bm:supplier_company_name>DevLexmark</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="'+bmId+'"  bm:buyer_company_name="DevLexmark" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="DevLexmark"><bm:quoteName_quote>'+OppName+'</bm:quoteName_quote><bm:crmOpportunityId_quote>'+OppId+'</bm:crmOpportunityId_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>save_quote</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';
        System.debug ('Update Transaction save_quote 2** '+SoapXMLBody);
        req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req.setMethod('POST');
        req.setBody(SoapXMLBody); 
        req.setTimeout(120000); 
        
        try {
            res = http.send(req);
            system.debug ('BM Update Transaction 6 Response'+res.toString()+res.getbody()); 
        }
        catch(System.CalloutException ex) 
        {
            System.debug('Callout 7 error - Save Quote Error: '+ ex);
            System.debug(res.toString());
        }             
    }
}