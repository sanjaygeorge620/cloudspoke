public class SitesOpportunityController extends SitesPartnerController {
    
//-------------------------------------------------------------------------------
// Opportunity Detail
//-------------------------------------------------------------------------------    

 private string ControllerID; 
    public SitesOpportunityController() {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
      }


    //-------------------------------------------------------------------------------
// Course Details
//-------------------------------------------------------------------------------
    public Order__c getOpportunityDetails(){
        Order__c  opptyDetails;
        try{
            opptyDetails = [select 
                                  Opportunity_ID__c
                                 , id
                                 , Opportunity_Account_Name__c
                                 , Opportunity_Amount__c
                                 , Opportunity_Close_Date__c
                                 , Opportunity_Stage__c
                                 , Opportunity_Sector__c
                                 , Opportunity_Probability__c 
                                 , Opportunity_Next_Step__c                               
                                 , Partner_Next_Steps__c  
                                 , Department__c
                                 , Host_Application__c
                                 , Host_manufacturer__c
                                    From Order__c 
                           where 
                               id=:ControllerID and
                               Opportunity__r.Primary_Partner__c=:SITE_ACCOUNT.ID and
                               Opportunity__r.Primary_Partner__c!='' 
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return opptyDetails;
        }
        
   public list<Order_Detail__c> getOpportunityLineItems(){
        list<Order_Detail__c>  opptyLineItems;
        try{
        if(!test.isRunningTest()){
            opptyLineItems = [Select  o.id, 
                                      o.Name,
                                      o.Quantity__c,
                                      o.createddate
                              From Order_Detail__c o  
                              where   
                               o.Order__c=:ControllerID
                               LIMIT :LIMITS.getLimitQueryRows()- LIMITS.getQueryRows()
                           ];
                           
            }               
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return opptyLineItems;
        } 
     



    
//-------------------------------------------------------------------------------
// Opportunity Landing Pages
//-------------------------------------------------------------------------------    
    //Pipeline
    public list<order__c> getOppty_pipeline(){
        list<order__c> oppty = getOpportunities('Pipeline');
       return oppty;
    }    
    
    //Best Case
    public list<order__c> getOppty_BestCase(){
        list<order__c> oppty = getOpportunities('Best Case');
       return oppty;
    }    
    //Commit
    public list<order__c> getOppty_Commit(){
        list<order__c> oppty = getOpportunities('Commit');
       return oppty; 
    } 
    
    //Closed
    public list<order__c> getOppty_Closed(){
        list<order__c> oppty = getOpportunities('Closed');
       return oppty; 
    } 
    
    //Omitted
    public list<order__c> getOppty_Omitted(){
        list<order__c> oppty = getOpportunities('Omitted');
       return oppty; 
    }      
       
    //Reusable getter
    public list<Order__c> getOpportunities(string category){
        
        
        list<Order__c> oppty = new list<Order__c>();
        //Modifed code for order sharing
        //Share order records if "Show For Portal Users" id true only for partner users.For customer users we should be able to show order records
        //Check current profile
        system.debug('getCurrentUerProfileName == '+getCurrentUerProfileName());

         
                 system.debug('category == '+category);                       
        if(getCurrentUerProfileName().indexOf('Channel Portal') >= 0)
        {
          //Logic for partner user
            oppty=      [Select  
                                   Opportunity_ID__c
                                 , id
                                 , Opportunity_Account_Name__c
                                 , Opportunity_Amount__c
                                 , Opportunity_Close_Date__c
                                 , Opportunity_Stage__c
                                 , Opportunity_Sector__c
                                 , Opportunity_Probability__c
                                 , Opportunity_Next_Step__c
                                 , Partner_Next_Steps__c
                                 , AEX__c
                                    From Order__c 
                               where Reseller_ID__c=:SITE_ACCOUNT.ID and
                               Reseller_ID__c!=''  and
                               Opportunity_Forecast_Category__c=:category and
                               Status__c = true
                               and LX_Show_For_Portal_Users__c = true
                                          ];
        }
        else
        {
            oppty= [Select  
                                   Opportunity_ID__c
                                 , id
                                 , Opportunity_Account_Name__c
                                 , Opportunity_Amount__c
                                 , Opportunity_Close_Date__c
                                 , Opportunity_Stage__c
                                 , Opportunity_Sector__c
                                 , Opportunity_Probability__c
                                 , Opportunity_Next_Step__c
                                 , Partner_Next_Steps__c
                                 , AEX__c
                                    From Order__c 
                                      where Opportunity__r.Primary_Partner__c=:SITE_ACCOUNT.ID and
                               Opportunity__r.Primary_Partner__c!=''  and
                               Opportunity_Forecast_Category__c=:category and
                               Status__c = true
                                          ];
        }
        
         system.debug('oppty == '+oppty);
        return oppty;
    }
    
    //--------------------------------------------------------------------------------->
    
    public Order__c NewOpp
    {
          get {
              if (NewOpp == null)
              {
                NewOpp = getOpportunityDetails();
                }
              return NewOpp;
            }
          set;
          }
    
    
    
    
     public pagereference SubmitOpp()
     {
             Savepoint CaseSP = Database.setSavepoint();
                
                try {
                      Update NewOpp;
                    } 
                    catch (DMLException e) 
                    {
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting Opporunity'));                          
                          Database.rollback(CaseSP);
                      return null;
                    }
                    
                    //Redirect to case details
                    PageReference Pg;
                    Pg = page.opportunitydetails;
                    Pg.getParameters().put('id', NewOpp.Id);
                    Pg.setRedirect(true);
                  return Pg;
        }
        
        
        public pagereference editOpp()
        {        
                    //Redirect to case details
                    PageReference Pg;
                    Pg = page.opportunityedit;
                    Pg.getParameters().put('id',ControllerID);
                    Pg.setRedirect(true);
                  return Pg;
        }
    

}