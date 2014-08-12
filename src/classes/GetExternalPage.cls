//HttpRequest to get External Content
//Created by: Michael Fitzgerald
//Date: August 2010
//*****************************************************************

public with sharing class GetExternalPage {
    Public string PageUrl {get; set;}
        
    private boolean isTest = false;
    public String getExternalPage() {
        try {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setTimeout(15000); //15 seconds 
                req.setEndpoint(PageUrl);
                req.setMethod('GET');
                HttpResponse resp = new HttpResponse();
                if (!isTest) {resp = http.send(req);}
                return resp.getBody();
            }
            
            catch(System.Exception e) {     
                //Error Handler
                system.debug('ERROR: '+e.getMessage());
                return null;
            }
    }
    
    public String getPortalPage() {
        try {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setTimeout(15000); //15 seconds 
                req.setEndpoint(PageUrl);
                req.setMethod('GET');
                HttpResponse resp = new HttpResponse();
                if (!isTest) {resp = http.send(req);}
                
                if (resp.getbody().ToLowerCase().contains('support@salesforce.com'))
                    //When the Public Site is down and returns an error
                   {return null;}
                else{return resp.getbody();}
            }
            
            catch(System.Exception e) {     
                //Error Handler
                system.debug('ERROR: '+e.getMessage());
                return null;
            }
    }
    private static testmethod void getExternalPageTest() {
            
            GetExternalPage c1 = new GetExternalPage();
            c1.isTest = true;
            c1.PageUrl = 'http://perceptivesoftware.com';
            c1.getExternalPage();
            
            GetExternalPage c2 = new GetExternalPage();
            c2.PageUrl = 'http://perceptivesoftware.com';
            c2.isTest = true;
            c2.getPortalPage();
    }
}