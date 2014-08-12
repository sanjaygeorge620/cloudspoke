public with sharing class SitesLeadController extends SitesPartnerController {
//-------------------------------------------------------------------------------
// Lead Detail
//-------------------------------------------------------------------------------    

 private string ControllerID; 
    public SitesLeadController() {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
            System.debug('@@@@@@@@@@@@@@@@@@@@@Controller Id'+ControllerID);
      }



//-------------------------------------------------------------------------------
// Lead Details
//-------------------------------------------------------------------------------
    public Lead getLeadDetails(){
        System.debug('****************Entering into getlead details');
        Lead leadDetails;
        try{
            leadDetails= [select 
                                name,
                                company,
                                Title,
                                lead_type__c,
                                Department__c,
                                Industry,
                                Phone,
                                Email,
                                Website,
                                Sector__c,
                                Manufacturer__c,
                                budget__c,
                                competitor_solution__c,
                                competitor_solution__r.name,
                                Need_Objectives__c,
                                Host_Application__c,
                                Current_solution__c,
                                Timeline__c,
                                Preferred_Language__c,
                                Tradeshow_Notes__c,
                                Region__c,
                                Physical_Country__c,
                                Physical_street_Address__c,
                                Physical_street_Address_2__c,
                                Physical_City__c,
                                Physical_State__c,
                                Physical_postal_Code__c,
                                International_State_Province__c
                           from Lead
                            where 
                               id=:ControllerID and
                               Primary_Partner__c=:SITE_ACCOUNT.ID and
                               Primary_Partner__c!='' 
                           ];
                       System.debug('**********Lead Details Name'+Leaddetails.Name);   
                       system.debug('Site Account Id:' +SITE_ACCOUNT.ID);    
                       system.debug('Controller Id:' +ControllerID);
          } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return leadDetails;
        }
        
   
     



    
//-------------------------------------------------------------------------------
// Lead Landing Pages
//-------------------------------------------------------------------------------    
     
       
    //Reusable getter
    public list<Lead> getLeads(){
        list<Lead> LeadList = [Select  
                                            name,
                                            company,
                                            title,
                                            lead_Type__c
                                    From Lead
                                    where Primary_Partner__c=:SITE_ACCOUNT.ID and
                                          Primary_Partner__c!='' 
                                          ];
        
        return LeadList ;
    }


}