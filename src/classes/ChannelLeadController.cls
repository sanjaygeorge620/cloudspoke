public class ChannelLeadController extends SitesPartnerController {
//-------------------------------------------------------------------------------
// Lead Detail
//-------------------------------------------------------------------------------    

 private string ControllerID; 
    public ChannelLeadController() {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
            System.debug('@@@@@@@@@@@@@@@@@@@@@Controller Id'+ControllerID);
            //System.debug('**********************SITES ACCOUNT TYPE'+SITE_ACCOUNT.Type);
      }



//-------------------------------------------------------------------------------
// Lead Details
//-------------------------------------------------------------------------------
    public Lead_Clone__c getLeadDetails(){
        System.debug('****************Entering into getlead details');
        Lead_Clone__c leadDetails;
        try{
            leadDetails= [SELECT Annual_Revenue__c,
             Authority__c,
              Budget__c,
               Campaign__c,
                Company__c,
                 Competitor__c,
                  Contact_Role__c,
                   CreatedById, 
                   CreatedDate,
                    CurrencyIsoCode,
                     Current_Solution__c,
                     Campaign_Clone_name__r.name,
                      D_U_N_S_Number__c, 
                      Data_com_Key__c,
                       IsDeleted,
                        Department__c,
                         Description__c,
                          Do_Not_Call__c,
                           Email__c,
                            Email_Opt_Out__c,
                             Fax__c,
                              Fax_Opt_Out__c,
                               First_Name__c,
                                HooversId__c,
                                 Host_Application__c,
                                  Host_Manufacturer__c,
                                   Industry__c,
                                    International_State_Province__c,
                                     Job_Role__c,
                                      LastActivityDate,
                                       LastModifiedById,
                                        LastModifiedDate,
                                         Last_name__c,
                                         name,
                                          Name__c, 
                                          DMR_on_Lead__c,
                                           Lead_RecordType__c,
                                            Lead_Source__c,
                                             Lead_Source_Most_Recent__c,
                                              Lead_Source_Original__c,
                                               Lead_Status__c,
                                                Lead_Type__c,
                                                 Mobile__c,
                                                  Most_Recent_Activity_Date__c,
                                                   Most_Recent_Buy_Signal_Date__c, 
                                                   Need_Objectives__c,
                                                    No_of_Employees__c,
                                                     Opportunity_Lead_Notes__c,
                                                      OwnerId,
                                                       Parent_Lead__c,
                                                        Phone__c,
                                                         Physical_City__c,
                                                          Physical_Country__c,
                                                           Physical_Postal_Code__c,
                                                            Physical_State__c,
                                                             Physical_Street_Address__c,
                                                              Physical_Street_Address_2__c,
                                                               Preferred_Language__c,
                                                                Primary_Partner__c,
                                                                 Reason_for_Conversion__c,
                                                                  Id, Region__c,
                                                                   Sector__c,
                                                                    SystemModstamp,
                                                                     Timeline__c,
                                                                      Title__c,
                                                                       Website__c,
                                                                        Where_are_you_in_your_decision__c 
                                                                        
                           FROM Lead_Clone__c
                            where 
                               id=:ControllerID and
                               Primary_Partner__c=:SITE_ACCOUNT.ID and
                               Primary_Partner__c!='' 
                           ];
                       System.debug('**********Lead Details Name'+Leaddetails.Name);   
                       system.debug('Site Account Id:' +SITE_ACCOUNT.ID);  
                        
                         
                       system.debug('Controller Id:' +ControllerID);
          } catch(QueryException e){
            system.debug('Site Account Id:' +SITE_ACCOUNT.ID);
            system.debug('Controller Id:' +ControllerID);
                        throw new NoDataFoundException();
                     }
           
            return leadDetails;
        }
        
    
        
//-------------------------------------------------------------------------------
// Lead opp Details
//-------------------------------------------------------------------------------
    public Lead_Clone__c getLeadDetail(){
        System.debug('****************Entering into getlead detail');
        Lead_Clone__c leadDetail;
        try{
            leadDetail= [SELECT Company__c,Authority__c,Budget__c,Department__c,Description__c,Host_Application__c,Host_Manufacturer__c,Industry__c,name,
                        Name__c,Need_Objectives__c,OwnerId,Id, Region__c,Sector__c,Timeline__c,Opportunity_Name__c,Close_Date__c,Stage__c,Hot_Buttons__c,
                        Next_Step__c,Decision_Criteria__c,Secondary_Host_Manufacturer__c,Secondary_Host_Application__c,Server_Operating_System__c
                                                                        
                           FROM Lead_Clone__c
                            where 
                               id=:ControllerID  
                           ];
                       System.debug('**********Lead Detail Name'+Leaddetail.Name);   
                       system.debug('Site Account Id:' +SITE_ACCOUNT.ID);  
                        
                         
                       system.debug('Controller Id:' +ControllerID);
          } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return leadDetail;
        } 
        
          
  


    
//-------------------------------------------------------------------------------
// Lead Landing Pages
//-------------------------------------------------------------------------------    
     
     public list<Lead_Clone__c> getLeads_Pending()
     {
        list<Lead_Clone__c> Lclones = getLeads('Pending');
       return Lclones;
     }   
     
      public list<Lead_Clone__c> getLeads_Approved()
     {
        list<Lead_Clone__c> Lclones = getLeads('Approved');
       return Lclones;
     }  
     
      public list<Lead_Clone__c> getLeads_Denied()
     {
        list<Lead_Clone__c> Lclones = getLeads('Declined');
       return Lclones;
     }  
     
     
       
    //Reusable getter
    public list<Lead_Clone__c> getLeads(String Status)
    {
        list<Lead_Clone__c> LeadList = [Select  
                                            name,
                                            Name__c,
                                            company__c,
                                            title__c,
                                            lead_Type__c
                                    From Lead_clone__c
                                    where Primary_Partner__c=:SITE_ACCOUNT.ID and
                                          Primary_Partner__c!='' and Overall_Status__c =: Status
                                          ];
                                          
        system.debug('Site Account TYPE:' +SITE_ACCOUNT); 
        
        return LeadList ;
    }
    
//-------------------------------------------------------------------------------
// Redirecting to Lead Creation Landing Pages
//-------------------------------------------------------------------------------  

    
     public PageReference RedirectNewLead() {
                  
        PageReference pg;
        system.debug('Site Account TYPE:' +SITE_ACCOUNT.Type);
        
        if(SITE_ACCOUNT.Type != 'Partner-OEM' ){
                                     
             pg = new PageReference('/apex/ChannelLeadWebSubmit');
             
          }
        else{
                        
            pg = new PageReference('/apex/ChannelOpportunitySubmit');
          }
        return pg;
    }


}