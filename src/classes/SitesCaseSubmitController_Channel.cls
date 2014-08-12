/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public class SitesCaseSubmitController_Channel Extends SitesPartnerController {

//-------------------------------------------------------------------------------
// Cases
//-------------------------------------------------------------------------------
          
    public case NewCase{
          get {
              if (NewCase == null)
                NewCase = new case( Origin='web');
              return NewCase;
            }
          set;
          }
     
          
    public attachment attachment{
          get {
              if (attachment == null)
                attachment = new attachment();
              return attachment;
            }
          set;
          }      
//-------------------------------------------------------------------------------
// Submit Case - Customer Portal
//-------------------------------------------------------------------------------

    public pagereference SubmitCase(){
    
    Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
     Id rtId = rtMap.get('Partner-Channel').getRecordTypeId();
             
             Savepoint CaseSP = Database.setSavepoint();
             
                NewCase.Account = SITE_ACCOUNT;
                NewCase.contact = SITE_CONTACT;
                // Story S-97014 by Hemlata
                if (SITE_ACCOUNT.Type=='Partner-OEM' || SITE_ACCOUNT.Type=='ISYS - OEM' || SITE_ACCOUNT.Type=='BW- OEM' ||SITE_ACCOUNT.Type=='Pallas – OEM') {
                	newCase.recordTypeID = rtMap.get('Product Support').getRecordTypeId();
                } else {
                  newCase.recordTypeID = rtMap.get('Partner-Channel').getRecordTypeId();
                }
                newCase.origin = 'Web';
                try {
                      insert NewCase;
                      case CaseRec = [select CaseNumber, subject, id from case where id =:newCase.id];
                     CaseChannelSubmitted.CaseChannelSubmitted(CaseRec , SITE_CONTACT);
                    } catch (DMLException e) {
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting case'));
                          ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseSubmitController_Channel.SubmitCase','High','DML');
                          
                          //Rollback
                          Database.rollback(CaseSP);
                      return null;
                    }
                    
                        
                    
                    //Redirect to case details
                    PageReference Pg;
                    Pg = page.casedetails_channel;
                    Pg.getParameters().put('id', NewCase.Id);
                    Pg.setRedirect(true);
                  return Pg;
        }
        
    


           
        
          
    private string FormatNullValues(string myval){
    /*Formatting Values*/
          if (myval==null){
              myval=' ';
          }
          return myval;
          }
                
    

}