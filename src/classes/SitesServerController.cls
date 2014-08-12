/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011

***Changes***
May 2014 | MFitzgerald | Adding Checkpoint Field to Server Query
*/

public class SitesServerController extends SitesController {


//-------------------------------------------------------------------------------
// Server
//-------------------------------------------------------------------------------
    private string ControllerID; 
    public SitesServerController() {
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
      }
    
   
   public Server__c Server{
          get {
              if (Server == null){
                 try{
                            Server = [Select 
                                s.Web_App_Server__c, 
                                s.Web_App_Server_Version__c, 
                                s.Virtual_Machine__c, 
                                s.Virtual_Machine_Type__c, 
                                s.Server_Type__c, 
                                s.Release__c,
                                release__r.name, 
                                s.Processor__c, 
                                s.Platform__c, 
                                s.Platform_Version__c, 
                                s.Machine_Name__c, 
                                s.Verified_by_Customer__r.name, 
                                s.Date_Verified_by_Customer__c, 
                                s.Database__c, 
                                s.Database_Version__c,
                                s.Client_Access__c,
                                s.Account__r.id,
                                s.checkpoint_id__c 
                         From Server__c s
                         where s.id=:ControllerID and
                                   Account__r.id=:SITE_ACCOUNT.id
                       ];
                                 } catch(QueryException e){
                                        throw new NoDataFoundException();
                                 }
                }
              return Server;
            }
          set;
          }
        
     public List<SelectOption> getRelease() {
                List<ProductRelease__c> Releases= [select id, 
                                                          Release__c
                                                   from ProductRelease__c 
                                                   where 
                                                    Brand__r.Name='ImageNow' and
                                                    (status__c ='General Availability' or
                                                     status__c ='Retirement Phase' or 
                                                     status__c ='Limited Support Phase' or
                                                     status__c ='End of Life' 
                                                    )
                                                    order by 
                                                    Release__c desc
                                                   ];
                                                                                                                                      
            List<SelectOption> options = new List<SelectOption>();
                    options.add(new SelectOption('','-- None --'));
                    for (ProductRelease__c r : Releases) {
                        options.add(new SelectOption(r.id,r.Release__c));
                     }
                return options;
          }  
       
       Public pagereference updateServer(){
               string retUrl = secureString(System.currentPageReference().getParameters().get('retURL'));
               PageReference Pg;
               
               try {
                      system.debug('Update the server: '+server);
                      server.Verified_by_Customer__c = SITE_CONTACT.ID; 
                      server.Date_Verified_by_Customer__c = datetime.now();
                      update Server;
                      
                    } catch (DMLException e) {
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Environment.'));
                          ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesServerController.updateServer','High','DML');
                      return null;
                    } 
                     
                    if (retUrl!='' && retUrl!=null){
                        Pg = new PageReference(retUrl);
                        Pg.setRedirect(true);
                        return Pg;
                    } else {                    
                        //Success!!! 
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Updated successfully!'));
                         return null;
                    }     
                  }
}