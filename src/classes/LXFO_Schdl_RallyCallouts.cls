/* Class Name   : LXFO_Schdl_RallyCallouts 
* Description   : Apex class to poll for updates on user story table in Rally
* Created By   : Sanjay George
* Created Date : 03-23-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay George          03-26-2013                1000                 Initial Version

*/

// Global Class to Schedule regular fetching of Data from Rally
global class LXFO_Schdl_RallyCallouts implements Schedulable {
 global void execute(SchedulableContext sc) {
       
        
        LXFO_RallyCalloutMappingUtility.fetchUS_Rally(); 
        
   }
  /* global void schedule(){
   
        Id jobid = System.schedule('Rally Sync every 1/2 Hours','0 30 * * * ?',new LXFO_Schdl_RallyCallouts());
        System.debug(jobid);
       
   }*/
}