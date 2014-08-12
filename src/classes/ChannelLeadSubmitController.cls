public class ChannelLeadSubmitController Extends SitesController 
{
    public id SelectedLead{get; set;}
    public map<ID,Campaign_Clone__c> cclmp = new map<ID,Campaign_Clone__c>();
//-------------------------------------------------------------------------------
// Lead
//-------------------------------------------------------------------------------
          
    public Lead_Clone__c newLead{
          get {
              if (newLead == null)
                newLead = new Lead_Clone__c();            //sets to Channel.new queue
                                
                Account PartnerAccount = SITE_ACCOUNT;
                NewLead.Primary_Partner__c = PartnerAccount.id;
                NewLead.Lead_RecordType__c = getRecordtypeID('lead','Unlocked');
                //UAT
                //NewLead.ownerId = '00GQ00000015vF4';
                //PROD
              //  NewLead.ownerId='00G70000001f6Lr'; 
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
             
             NewLead.Campaign_Clone_name__c = SelectedLead;
             if(cclmp.containskey(SelectedLead))
             {
             NewLead.Campaign__c = cclmp.get(SelectedLead).Campaign__c;
             }   
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
                    Pg = page.Channelleaddetails;
                    Pg.getParameters().put('id', NewLead.Id);
                    Pg.setRedirect(true);
                  return Pg;
        }

 public List<SelectOption> getPartnerCampaign() 
 {
  list<SelectOption> options = new list<SelectOption>();
  options.add(new SelectOption('','Select Campaign'));
  System.debug('SiteAccountID' +SITE_ACCOUNT.ID);
  string str = (String.valueof(SITE_ACCOUNT.ID)).SubString(0,15);
    System.debug('SiteAccountID' +str);
  for(Campaign_Clone__c Ccl : [Select ID,Campaign__c,Campaign_Name__c,Name,Account__c from Campaign_Clone__c where Parent_Campaign_Account__c=:str])
  {
  cclmp.put(Ccl.id,ccl);
  options.add(new SelectOption(ccl.id,ccl.Name));  
  } 
  return options;
 }
    

}