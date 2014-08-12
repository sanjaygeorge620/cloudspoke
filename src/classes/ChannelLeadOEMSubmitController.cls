public class ChannelLeadOEMSubmitController Extends SitesPartnerController 
{


//-------------------------------------------------------------------------------
// Lead
//-------------------------------------------------------------------------------
          
    public Lead_Clone__c newLead{
          get {
              if (newLead == null)
                newLead = new Lead_Clone__c();            //sets to Channel.new queue
                                
                Account PartnerAccount = SITE_ACCOUNT;
                NewLead.Account_ID__c = PartnerAccount.ID;
                NewLead.Primary_Partner__c = PartnerAccount.id;
                system.debug('*****************************PartnerAccount ID'+PartnerAccount.ID);
                system.debug('*****************************SITE_ACCOUNT ID'+SITE_ACCOUNT.ID);
                NewLead.Opportunity_Owner__c = PartnerAccount.OwnerId;
                NewLead.Budget__c = 'OEM Partner';
                NewLead.Authority__c = 'OEM Partner';
                NewLead.Need_Objectives__c = 'OEM Partner';
                NewLead.Timeline__c = 'OEM partner';
                NewLead.Hot_Buttons__c = 'OEM partner';
                NewLead.Decision_Criteria__c = 'OEM partner';
                NewLead.Description__c = 'OEM Generated Opportunity';
                
                
                
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
                    Pg = page.ChannelOpportunitydetails;
                    Pg.getParameters().put('id', NewLead.Id);
                    Pg.setRedirect(true);
                  return Pg;
        }

    

}