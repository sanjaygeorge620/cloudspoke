public class LX_CheckClosedOpportunities {
    /* Class Name   : LX_CheckClosedOpportunities 
    * Description   : This is a class written to get StageName of a Closed Opportunity. 
    * Created By   : Rahul Raghunathan
    * Created Date : 22-07-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Rahul Raghunathan        22-07-2013               1000                Initial Version    
    */

    public Opportunity opp {get;set;}    
    
    public LX_CheckClosedOpportunities (ApexPages.StandardController controller) {
   /*  Description : This is a Constructor. It gets opportunity's stageName.
    *  Param - controller: Standard Controller 
    *  Returns :  VOID
    */
        opp = [Select id,stageName from Opportunity where id = :ApexPages.currentPage().getParameters().get('Id')];   
                     
    }
}