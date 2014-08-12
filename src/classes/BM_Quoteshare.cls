public class BM_Quoteshare
{

Public static String SessionID;
public static string quotenumber; 
public static string transactionid;
public static string userstream;
public static string username; 
public static string password;
public static string soapURL;


public BM_Quoteshare()
{
SessionID = '';
username = '';
password = '';
soapURL = '';
}

public List<String> doCallOut(string qnum,string tid,string ustream)
{
quotenumber = qnum;
transactionid = tid;
userstream = ustream;

List<String> retList = new List<String>();

List<BigMachines__Configuration_Record__c> sitesetup = new List<BigMachines__Configuration_Record__c>();

sitesetup = [select ID,BigMachines__API_Login__c,BigMachines__API_Password__c,SOAP_URL__c from BigMachines__Configuration_Record__c where BigMachines__Is_Primary__c = True];

if(!sitesetup.isEmpty() && !String.isBlank(sitesetup[0].BigMachines__API_Login__c) && !String.isBlank(sitesetup[0].SOAP_URL__c) && !String.isBlank(sitesetup[0].BigMachines__API_Password__c))
{
username = sitesetup[0].BigMachines__API_Login__c;
password = sitesetup[0].BigMachines__API_Password__c;
soapURL = sitesetup[0].SOAP_URL__c;

getSessionID();
retList.addall(toForwardStepAction());
retList.addall(fromForwardStepAction());
}
else
{
retList.add('Invalid Bigmachines Site Setup');
}

return retList;
}


Public static void getSessionID()
{
String startXML0 = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">';
startXML0 += '<soapenv:Header>';
String startXML1 = '<bm:category xmlns:bm="urn:soap.bigmachines.com">Security</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com">';
String startXML2 = '<bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/security/Security.xsd</bm:schemaLocation>';
startXML2 += '</bm:xsdInfo>';
startXML2 += '</soapenv:Header>';
startXML2 += '<soapenv:Body>';
startXML2 += '<bm:login xmlns:bm="urn:soap.bigmachines.com"> <bm:userInfo><bm:username>';
startXML2 += username;
startXML2 += '</bm:username><bm:password>';
startXML2 += password;
String startXML3 = '</bm:password><bm:sessionCurrency/></bm:userInfo></bm:login></soapenv:Body></soapenv:Envelope>';

String fullXML = startXML0 + startXML1 + startXML2 + startXML3;
//startXML4 + startXML5 + startXML6 + startXML7 + startXML8 + startXML9;

System.debug('$$$$$fullXML' +fullXML);

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

  //    req.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req.setEndpoint(soapURL);
        req.setMethod('GET');
        req.setBody(fullXML);
       // req.setCompressed(true); // otherwise we hit a limit of 32000
            
        try {
            res = http.send(req);
        }
catch(System.CalloutException e) 
        {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }

System.debug('----------------' +res.getBody());

// Generate the HTTP response as an XML stream
    XmlStreamReader reader = res.getXmlStreamReader();

    // Read through the XML
    while(reader.hasNext()) 
    {
      System.debug('Event Type:----' + reader.getEventType());
      if (reader.getEventType() == XmlTag.START_ELEMENT) 
      {
        System.debug('--------------' +reader.getLocalName());
          if(reader.getLocalName() == 'SessionID')
          {
          while (reader.hasNext()) 
          {
        if (reader.getEventType() == XmlTag.END_ELEMENT) 
        {
            break;
        }
              else if (reader.getEventType() == XmlTag.CHARACTERS) 
              {
                  System.debug('--------------' +reader.getText());
                  SessionID = reader.getText();
             
              }
        reader.next();
          }
          } 
      }
      reader.next();
    }
}

public static List<String> toForwardStepAction()
{

List<String> strList = new List<String>();

String ForwardXML = '';

ForwardXML += '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>';
ForwardXML += SessionID;
ForwardXML += '</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category><bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://devlexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header><soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>';
ForwardXML += transactionid;         //'147787963';
ForwardXML += '</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>';
ForwardXML += 'DevLexmark';
ForwardXML += '</bm:buyer_company_name><bm:supplier_company_name>';
ForwardXML += 'DevLexmark';
ForwardXML += '</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="';
ForwardXML += transactionid;        //'147787963';
ForwardXML += '" bm:buyer_company_name="';
ForwardXML += 'DevLexmark';
ForwardXML += '" bm:buyer_user_name="sfdcintegrationuser" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="';
ForwardXML += 'DevLexmark';
ForwardXML += '"><bm:forwardToSalesTeam_quote>';
ForwardXML += userstream;          //'DavidEagan,carolynkidder,praveensadineni';
ForwardXML += '</bm:forwardToSalesTeam_quote></bm:quote_process></bm:data_xml><bm:action_data><bm:action_var_name>';
ForwardXML += 'toForwardStepAction';
ForwardXML += '</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';

System.debug('$$$$$ForwardXML' +ForwardXML);


        HttpRequest req1 = new HttpRequest();
        HttpResponse res1 = new HttpResponse();
        Http http1 = new Http();

 //     req1.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req1.setEndpoint(soapURL);
        req1.setMethod('GET');
        req1.setBody(ForwardXML);
       // req.setCompressed(true); // otherwise we hit a limit of 32000
            
        try {
            res1 = http1.send(req1);
        }
catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res1.toString());
        }
System.debug('$$$$$CALL2' +res1.getBody());

// Generate the HTTP response as an XML stream
    XmlStreamReader reader = res1.getXmlStreamReader();

    // Read through the XML
    while(reader.hasNext()) 
    {
      System.debug('Event Type:----' + reader.getEventType());
      if (reader.getEventType() == XmlTag.START_ELEMENT) 
      {
        System.debug('--------------' +reader.getLocalName());
          if(reader.getLocalName() == 'exceptionMessage')
          {
          while (reader.hasNext()) 
          {
        if (reader.getEventType() == XmlTag.END_ELEMENT) 
        {
            break;
        }
              else if (reader.getEventType() == XmlTag.CHARACTERS) 
              {
                  System.debug('--------------' +reader.getText());
                  strList.add(reader.getText());             
              }
        reader.next();
          }
          } 
          
            //Success-------------------
          else if(reader.getLocalName() == 'message')
          {
          while (reader.hasNext()) 
          {
        if (reader.getEventType() == XmlTag.END_ELEMENT) 
        {
            break;
        }
              else if (reader.getEventType() == XmlTag.CHARACTERS) 
              {
                  System.debug('--------------' +reader.getText());
                  strList.add(reader.getText());             
              }
        reader.next();
          }
          }
      }
      reader.next();
    }

return strList;
}

public static List<String> fromForwardStepAction()
{
List<String> strList = new List<String>();

String ForwardXML2 = '';

ForwardXML2 += '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header>';
ForwardXML2 += '<bm:userInfo xmlns:bm="urn:soap.bigmachines.com"><bm:sessionId>';
ForwardXML2 += sessionid;
ForwardXML2 += '</bm:sessionId></bm:userInfo><bm:category xmlns:bm="urn:soap.bigmachines.com">Commerce</bm:category>';
ForwardXML2 += '<bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com"><bm:schemaLocation>https://DevLexmark.bigmachines.com/bmfsweb/devlexmark/schema/v1_0/commerce/quickstart_commerce_process.xsd</bm:schemaLocation></bm:xsdInfo></soapenv:Header>';
ForwardXML2 += '<soapenv:Body><bm:updateTransaction xmlns:bm="urn:soap.bigmachines.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><bm:transaction><bm:id>';
ForwardXML2 +=  transactionid;      //'147787963';
ForwardXML2 += '</bm:id><bm:process_var_name>quickstart_commerce_process</bm:process_var_name><bm:buyer_company_name>';
ForwardXML2 += 'DevLexmark';
ForwardXML2 += '</bm:buyer_company_name><bm:supplier_company_name>';
ForwardXML2 += 'DevLexmark';
ForwardXML2 += '</bm:supplier_company_name><bm:data_xml><bm:quote_process bm:bs_id="';
ForwardXML2 += transactionid;       //'147787963';
ForwardXML2 += '" bm:buyer_company_name="';
ForwardXML2 += 'DevLexmark';
ForwardXML2 += '" bm:buyer_user_name="';
ForwardXML2 += 'sfdcintegrationuser';
ForwardXML2 += '" bm:currency_pref="USD" bm:data_type="0" bm:document_name="Quote" bm:document_number="1" bm:document_var_name="quote_process" bm:process_var_name="quickstart_commerce_process" bm:supplier_company_name="';
ForwardXML2 += 'DevLexmark';
ForwardXML2 += '"><bm:quoteName_quote>';
ForwardXML2 +=  quotenumber;                   //'2014-3925';    
ForwardXML2 += '</bm:quoteName_quote>';
ForwardXML2 += '<bm:forwardToSalesTeam_quote>';
ForwardXML2 +=  userstream;          
ForwardXML2 += '</bm:forwardToSalesTeam_quote>';
ForwardXML2 += '</bm:quote_process>';
ForwardXML2 += '</bm:data_xml><bm:action_data><bm:action_var_name>'; 
ForwardXML2 += 'fromForwardStepAction';

ForwardXML2 += '</bm:action_var_name></bm:action_data></bm:transaction></bm:updateTransaction></soapenv:Body></soapenv:Envelope>';

System.debug('$$$$$ForwardXML2' +ForwardXML2);

        HttpRequest req1 = new HttpRequest();
        HttpResponse res1 = new HttpResponse();
        Http http1 = new Http();

//      req1.setEndpoint('https://devlexmark.bigmachines.com/v1_0/receiver');
        req1.setEndpoint(soapURL);
        req1.setMethod('GET');
        req1.setBody(ForwardXML2);

            
        try {
            res1 = http1.send(req1);
        }
catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res1.toString());
        }
System.debug('$$$$$' +res1.getBody());

// Generate the HTTP response as an XML stream
    XmlStreamReader reader = res1.getXmlStreamReader();

    // Read through the XML
    while(reader.hasNext()) 
    {
      System.debug('Event Type:----' + reader.getEventType());
      if (reader.getEventType() == XmlTag.START_ELEMENT) 
      {
        System.debug('--------------' +reader.getLocalName());
          if(reader.getLocalName() == 'exceptionMessage')
          {
          while (reader.hasNext()) 
          {
        if (reader.getEventType() == XmlTag.END_ELEMENT) 
        {
            break;
        }
              else if (reader.getEventType() == XmlTag.CHARACTERS) 
              {
                  System.debug('--------------' +reader.getText());
                  strList.add(reader.getText());             
              }
        reader.next();
          }
          } 
          //Success-------------------
          else if(reader.getLocalName() == 'message')
          {
          while (reader.hasNext()) 
          {
        if (reader.getEventType() == XmlTag.END_ELEMENT) 
        {
            break;
        }
              else if (reader.getEventType() == XmlTag.CHARACTERS) 
              {
                  System.debug('--------------' +reader.getText());
                  strList.add(reader.getText());             
              }
        reader.next();
          }
          }
      }
      reader.next();
    }


return strList;
}


}