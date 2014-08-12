/* Trigger Name  : LX_BM_Quote_AI_AU
 * Description   : This trigger is used to populate the number of BigMachines Quotes present on an Opportunity
 * Created By    : Sumedha Kuchlapatti(Deloitte)
 * Created Date  : 6-10-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Sumedha Kuchlapatti  06-10-2013                       Initial Version
 * Srinivas Pinnamaneni 07-22-2013                       Migrated to QA
 * Veenu Trehan         08-25-2013
 * Sumedha Kucherlapati 09-05-2013                       Added logic to share record to related Opportunity Owner's managers upto 3 level
 * Sumedha Kucherlapati 09-06-2013                       Added logic to share record to related Opportunity Team Members (Sales Team)
 */

trigger LX_BM_Quote_AI_AU on BigMachines__Quote__c (after Insert,after Update,  before Delete, after unDelete) 
{
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code   
    system.debug('>>>>>>>>>>>>>>>>>>>>>Inside the trigger>>>>>>>>>>>');
     // Map variable to store Quote Id and related Opportuntiy Id
        Map<Id,Id> quoOppMap = new Map<Id,Id>();

    //Get the list of Opportunity Ids for which the Bigmachines Quotes were updated.  
    set<ID> oppID = new set<ID>();
    set<ID> deletedQuote = new set<ID>();
    set<ID> alloppID = new set<ID>();
    Map<ID,Boolean> oppReadforVerMap = new Map<ID,Boolean>();
    Map<ID,Boolean> oppFinal   = new Map<ID,Boolean>();
    Map<ID,Integer> oppNumber = new Map<ID,Integer>();
  
    //string to update the opp
    list<string> oppStringToUpdate = new list<string>();
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(BigMachines__Quote__c  bmQuote : Trigger.New)
            {
                system.debug('bmQuote == '+bmQuote);
                //VT 5/13 commented alloppID.add(bmQuote.BigMachines__Opportunity__c);
                if(Trigger.isInsert && bmQuote.BigMachines__Opportunity__c != NULL)
                {
                    oppID.add(bmQuote.BigMachines__Opportunity__c);                    
                }
                /*if((trigger.IsInsert && bmQuote.BigMachines__Is_Primary__c == TRUE) ||(trigger.isUpdate && bmQuote.BigMachines__Is_Primary__c == TRUE && trigger.oldMap.get(bmQuote.ID).BigMachines__Is_Primary__c!=true )){
                    oppReadforVerMap.put(bmQuote.BigMachines__Opportunity__c,bmQuote.LX_Ready_for_Finalization__c);
                    alloppID.add(bmQuote.BigMachines__Opportunity__c);
                }*/
                
                alloppID.add(bmQuote.BigMachines__Opportunity__c);
                if(bmQuote.BigMachines__Is_Primary__c == TRUE)
                {
                    oppReadforVerMap.put(bmQuote.BigMachines__Opportunity__c,bmQuote.LX_Ready_for_Finalization__c);
                }
            }
            system.debug('oppID == '+oppID);
            system.debug('oppReadforVerMap == '+oppReadforVerMap);
            system.debug('alloppID == '+alloppID);
        }
    }
    //In the insert trigger populate the Opportunity Ids for which the Quotes have been deleted/Undeleted.
    if((Trigger.isBefore) && (Trigger.isDelete || Trigger.isUndelete)){
        for(BigMachines__Quote__c  bmQuote : Trigger.Old)
        {
                if(bmQuote.BigMachines__Opportunity__c != NULL)
                {
                    oppID.add(bmQuote.BigMachines__Opportunity__c);
                    if(trigger.isDelete && trigger.isBefore)
                    {
                        deletedQuote.add(bmQuote.id);
                        alloppID .add(bmQuote.BigMachines__Opportunity__c);
                    }
                }
        }
    }
       
    //Generate the Opportunities for which the Quotes were created or modified
  //  if(oppReadforVerMap.size() > 0){   
    if(alloppID.size() > 0 || deletedQuote.size()>0)
    {
        if(Trigger.isInsert){
        Map<ID,Opportunity> mapOpp = new Map<ID,Opportunity>([SELECT ID,LX_No_of_BM_Quotes__c,LX_Ready_for_Finalization__c, (Select Id From BigMachines__BigMachines_Quotes__r where id != :deletedQuote) FROM Opportunity WHERE ID IN :alloppID]);
        system.debug('mapOpp == '+mapOpp);
        if(!mapOpp.isEmpty())
        {
            for(Opportunity opp :mapOpp.values())
            {
            system.debug('opp == '+opp);
                if(oppID.size()>0 && oppID.contains(opp.ID))
                {
                system.debug('Big Machines == '+opp.BigMachines__BigMachines_Quotes__r.size());
                    if(opp.ID != null)
                    {
                        oppNumber.put(opp.ID,opp.BigMachines__BigMachines_Quotes__r.size());
                        system.debug('oppNumber in loop == '+opp.BigMachines__BigMachines_Quotes__r.size());
                    }
                
                //opp.LX_No_of_BM_Quotes__c = opp.BigMachines__BigMachines_Quotes__r.size();
                }
                if(oppReadforVerMap.containsKey(opp.id)) 
                {
                    if(opp.ID != null){
                        oppFinal.put(opp.ID,oppReadforVerMap.get(opp.ID));
                    }

                   //opp.LX_Ready_for_Finalization__c = oppReadforVerMap.get(opp.ID);
                }
             } 
             system.debug('oppFinal == '+oppFinal);
                system.debug('oppNumber == '+oppNumber);
        system.debug('LX_BMQuoteHelper.futureCalled == '+LX_BMQuoteHelper.futureCalled);                
             try {
             
                //Rahul//Because of the recurssion, we have adde the method to ensure that all the future methods is called only once  
               if(!LX_BMQuoteHelper.futureCalled){
              
                    if(oppNumber.size() > 0 || oppFinal.size() > 0)
                        LX_OpportunityHelper.updateOppFromQuote(oppFinal,oppNumber);
               }
             }
             catch(Exception ex){
                 LX_CommonUtilities.createExceptionLog(ex);
             }
         }
     }
}
     // Sumedha - Added logic to create share records on After insert and After update
     if(Trigger.isAfter && (Trigger.isInsert)){ //commented by sumedha march 9th 2014 -|| Trigger.isUpdate)){

       

         for(BigMachines__Quote__c quo : Trigger.new){
              //quoObjMap.put(quo.Id,quo);
              if(quo.BigMachines__Opportunity__c != NULL)
              {
               quoOppMap.put(quo.Id,quo.BigMachines__Opportunity__c);
              }
            }
            
            if(quoOppMap.size() > 0){
             //   if(!LX_BMQuoteHelper.futureCalled)            //Commented out the Future Static Variable as a 
             //   {                                             //part of making the LX_BMQuoteHelper.shareQuotes method synchronous -- Praveen 05/20/14
                LX_BMQuoteHelper.shareQuotes(quoOppMap);
             //   }
            }
     }
 //  if(oppNumber.size() > 0 || oppFinal.size() > 0 || quoOppMap.size() > 0)
   if(oppNumber.size() > 0 || oppFinal.size() > 0)
   {
    LX_BMQuoteHelper.futureCalled = true;//Set the future method flag to false indicating that future method has been called.  
    }
}