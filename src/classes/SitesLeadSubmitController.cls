public class SitesLeadSubmitController Extends SitesController {

//-------------------------------------------------------------------------------
// Lead
//-------------------------------------------------------------------------------
          
    public Lead newLead{
          get {
              if (newLead == null)
                newLead = new Lead(
               /*               lastname=''
                              , Company = ''
                                , Phone = ''
                                , firstname = ''
                                , Title = ''
                                , lead_type__c = ''
                                , Department__c = ''
                                , Industry = ''
                                , Email = ''
                                , Website = ''
                                , Sector__c = ''
                                , Manufacturer__c = ''
                                , budget__c = ''
          //                      , competitor_solution__c = ''
                                , Need_Objectives__c = ''
                                , Host_Application__c = ''
                                , Current_solution__c = ''
                                , Timeline__c = ''
                                , Preferred_Language__c = ''
                                , Tradeshow_Notes__c = ''
                                , Region__c = ''
                                , Physical_Country__c = ''
                                , Physical_street_Address__c = ''
                                , Physical_street_Address_2__c = ''
                                , Physical_City__c = ''
                                , Physical_State__c = ''
                                , Physical_postal_Code__c = ''
                                , International_State_Province__c = ''  */

                                );            //sets to Channel.new queue
                                 Account PartnerAccount = SITE_ACCOUNT;
                NewLead.Primary_Partner__c = PartnerAccount.id;
                NewLead.recordtypeid = getRecordtypeID('lead','Unlocked');
                //UAT
                //NewLead.ownerId = '00GQ00000015vF4';
                //PROD
                //NewLead.ownerId='00G70000001f6Lr';
                // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.ChannelNewQueueId'.
                NewLead.ownerId=LX_SetRecordIDs.ChannelNewQueueId;              
                newLead.Reason_For_Conversion__c = 'Sales';
              return NewLead;
            }
          set;
          }
        
          
    
//-------------------------------------------------------------------------------
// Submit Lead - Channel Portal
//-------------------------------------------------------------------------------

    public pagereference SubmitLead(){
             
             Savepoint LeadSP = Database.setSavepoint();
                
                try {
                      insert NewLead;
                    } catch (DMLException e) {
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting lead'));
                          ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesLadSubmitController.SubmitLead','High','DML');
                          
                          //Rollback
                          Database.rollback(LeadSP);
                      return null;
                    }
                    
                
                    
                    //Redirect to case details
                    PageReference Pg;
                    Pg = page.leaddetails;
                    Pg.getParameters().put('id', NewLead.Id);
                    Pg.setRedirect(true);
                  return Pg;
        }
        
}