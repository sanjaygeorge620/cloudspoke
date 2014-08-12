/*Class Name: LX_Opp_Ready_for_Finalization
** Description: This is a class for updating the 'Ready for Finalization' field of the primary quote of an opportunity on 
                clicking the'Finalize Pricing' button.
* Built By: Deloitte
* Created On   : 06/18/2013

*--------------------------------------------------------------------
*Modification Log:
*----------------
*Developer                      Date              Version         Description
*-------------------------------------------------------------------------------------------------
*Veenu Trerhan                18-June-2013          1.0             Created
*/


global class LX_Opp_Ready_for_Finalization{

//Variable to store the Opportunity ID.
public static string  OppId;

public static list<BigMachines__Quote__c> BMQuoteList=new list<BigMachines__Quote__c>();

   
   /*
    * 
    * Description : Global method to call the primary quote on the opportunity as finalized
    * Param - : opportunity id
    * Returns : null
   */
   Webservice static void GetOpp(string OppId1){
        OppId=OppId1;
        getPrimaryQuote();
    }

   /*
    * Description : Static method that updates the primary quote on the opportunity
    * Param - : none
    * Returns : null
   */

    global static void getPrimaryQuote(){
        
        // get the primary quote on the opportunity.
        BMQuoteList=[SELECT id,LX_Ready_for_Finalization__c,BigMachines__Is_Primary__c,BigMachines__Opportunity__c
                     FROM BigMachines__Quote__c 
                     WHERE BigMachines__Opportunity__c=:OppId AND BigMachines__Is_Primary__c=true];
        
        //iterate on the quotes and check the Primary quote as finalized.             
        for(BigMachines__Quote__c BQuote : BMQuoteList){
            BQuote.LX_Ready_for_Finalization__c=true; 
    }
    try{
        update BMQuoteList;
    }catch(exception ex){
        LX_CommonUtilities.createExceptionLog(ex);//Exception log ,Veenu Trehan 6/18/13       
    }   
             
    }
    
    Webservice static void uncheckFinalize(string OppId1){
        OppId=OppId1;
        uncheckQuote();
    }


   /*
    * Description : Static method that updates the primary quote on the opportunity as unfinalized.
    * Param - : none
    * Returns : null
   */
    global static void uncheckQuote(){
        // get the primary quote on the opportunity.
        BMQuoteList=[SELECT id,LX_Ready_for_Finalization__c,BigMachines__Is_Primary__c,BigMachines__Opportunity__c
                     FROM BigMachines__Quote__c 
                     WHERE BigMachines__Opportunity__c=:OppId];
        //iterate on the quotes and check the Primary quote as finalized.             
        for(BigMachines__Quote__c BQuote : BMQuoteList){
            BQuote.LX_Ready_for_Finalization__c=false; 
    }
    try{
        update BMQuoteList;
    }catch(exception ex){
        LX_CommonUtilities.createExceptionLog(ex);//Exception log ,Veenu Trehan 6/18/13       
    }   
             
    }


}