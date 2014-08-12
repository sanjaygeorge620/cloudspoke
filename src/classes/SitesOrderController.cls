public class SitesOrderController extends SitesController {
    
//-------------------------------------------------------------------------------
// Opportunity Detail
//-------------------------------------------------------------------------------    

 private string ControllerID; 
    public SitesOrderController() {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
      }



    //-------------------------------------------------------------------------------
// Order Details
//-------------------------------------------------------------------------------
    string OrderDetailsOpportunityID;
    Order__c orderDetails;
     string OrderDetailsID;
    public Order__c getOrderDetails(){
        
        try{
            orderDetails= [select name
                                , AEX__c
                                , AEX_Email__c
                                , ISR__c
                                , ISR_Email__c
                                , Close_Date__c
                                , Amount__c
                                , Bill_To__c
                                , Ship_To__c
                                , Project_Contact__c 
                                , opportunity__c
                                , status__c
                                , Account__c
                                , ID
                           from Order__c
                           where 
                               id=:ControllerID and
                               Account__c=:SITE_ACCOUNT.ID and
                               Account__c!='' 
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           OrderDetailsOpportunityID = orderDetails.opportunity__c;
           OrderDetailsID = orderDetails.id;
           return orderDetails;
        }
        
  public list<Order_Detail__c> getOpportunityLineItems(){
        list<Order_Detail__c>  opptyLineItems;
        try{
            opptyLineItems = [Select  o.id, 
                                      o.Name,
                                      o.Quantity__c,
                                      o.createddate
                              From Order_Detail__c o  
                              where   
                               o.Order__c=:ControllerID
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return opptyLineItems;
        }
     



    
//-------------------------------------------------------------------------------
// Orders Landing Pages
//-------------------------------------------------------------------------------    
    
    //all Orders
    public list<Order__c> getOrders(){
        list<Order__c> orders= [Select name
                                        , AEX__c
                                        , AEX_Email__c
                                        , ISR__c
                                        , ISR_Email__c
                                        , Close_Date__c
                                        , Amount__c
                                        , Bill_To__c
                                        , Ship_To__c
                                        , Project_Contact__c 
                                        , opportunity__c
                                        , status__c
                                        , Account__c
                                    From Order__c
                                    where Account__c=:SITE_ACCOUNT.ID and
                                          Account__c!=''
                                          ];
        
        return orders;
    }
    

}