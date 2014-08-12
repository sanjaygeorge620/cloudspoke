trigger CreateDealmakerOpportunityTrigger on Opportunity (after insert, after update) 
{
    // TODO
    // This sample trigger is implemented to use the Opportunity's record type id to decide whether
    // or not it should create an associated Dealmaker Opoprtunity. There are other TODOs in line
    // to draw attention to the places where you need to make modifications to reflect your own
    // Record Types and Sales Processes
    private String defaultCurrencyISO = null;
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) 
    {
        Set<String> opportunityTypesSupportingAutoCreate = getOpportunityTypesSupportingAutoCreate();
        Set<String> oppsWithDealmakerOpps = getDealmakerOppsByOppId();

        List<DMAPP__DM_Opportunity_Extra__c> newDealmakerOpps = new List<DMAPP__DM_Opportunity_Extra__c>();
        for (Opportunity opp : Trigger.new ) 
        {
            // this is really just a belt and braces in case someone 
            // leaves or re-enables our own auto create behaviour
            if (!oppsWithDealmakerOpps.contains(opp.id) && opportunityTypesSupportingAutoCreate.contains(opp.recordtypeid)) 
            {           
                //Added for US3918
                List<DMAPP__DM_Sales_Process__c> lstDMSalesprocess = [select id,Name from DMAPP__DM_Sales_Process__c where Name = 'TR Enterprise Account' limit 1]; 
                
                DMAPP__DM_Opportunity_Extra__c newDealmakerOpp = new DMAPP__DM_Opportunity_Extra__c(
                DMAPP__Opportunity__c = opp.Id, 
                DMAPP__Amount__c = opp.Amount,
               // TODO 
               // Dealmaker's own triggers have some logic for automated salesprocess 
               // mapping based on the opportunity type. If you want these auto created 
               // Dealmaker opportunities to automatically move into a specific sales 
               // process you will need to set this DMAPP__Sales_Process__c field to an 
               // appropriate values (e.g. if this trigger creates dealmaker opportunities for  
               // opportunities with the record type 'Enterprise' and you also want those 
               // opportunities to move into the 'Enterprise' Sales Process, then you need to set 
               // DMAPP__Sales_Process__c to the id of the enterprise salesprocess).
               // If you DO NOT set the DMAPP__Sales_Process__c field then the users will be 
               // shown the sales process select dialog which may result in them ending up in 
               // wrong sales process.  
                 
                //DMAPP__Sales_Process__c = 'a0x20000005KobH' //Removed from existing 
                //Added for US3918               
                DMAPP__Sales_Process__c = lstDMSalesprocess[0].id    
                );//End for US3918
                
                if (UserInfo.isMultiCurrencyOrganization()) 
                {
                    newDealmakerOpp.put('CurrencyISOCode', getDefaultCurrencyISO());
                }
                newDealmakerOpps.add( newDealmakerOpp ) ;
            }
        }
        insert newDealmakerOpps;
    }
    //
    // For sanity this method should probably be written to 
    // read a list of record type ids from a custom setting
    //
    private Set<String> getOpportunityTypesSupportingAutoCreate() 
    {
        Set<String> ret = new Set<String>();
        // TODO this method returns a set of record type ids for which we wish to create 
        // Dealmaker opportunities on opportunity creates. You will need to set this list
        // accordingly for your own org / requirements..
        
        //Below record types for opportunities will be allowed
        //012i0000000MmL4AAK  -  New Sales Project           
        //012i0000000MmL5AAK  -  New Sales Project – HW      
        //012i0000000MmL6AAK  -  New Sales Project – Joint   
        //012i0000000P3Y7AAK  -  MPS                         
        //012i0000000PCqbAAG  -  Channel Opportunity     
        
        //ret.add('01220000000hM6xAAE');//removed existing one
        //Added for US3918 : 
        ret.add('012i0000000MmL4AAK'); //added preferred opportunity record types
        ret.add('012i0000000MmL5AAK');
        ret.add('012i0000000MmL6AAK');
        ret.add('012i0000000P3Y7AAK');
        ret.add('012i0000000PCqbAAG');
        //End for US3918
        return ret;
    }
    private Set<String> getDealmakerOppsByOppId() 
    {
        List<DMAPP__DM_Opportunity_Extra__c> shadows = [select id, dmapp__opportunity__c from DMAPP__DM_Opportunity_Extra__c where DMAPP__Opportunity__c in :Trigger.newMap.keySet()];
        Set<String> ret = new Set<String>();
        for (DMAPP__DM_Opportunity_Extra__c shadow : shadows) 
        {
            ret.add(shadow.dmapp__opportunity__c);
        }
        return ret;
    }
    private String getDefaultCurrencyISO() 
    {
        if (defaultCurrencyISO == null) {
            List<CurrencyType> ars = Database.query('SELECT id, ConversionRate, IsCorporate, IsoCode from CurrencyType WHERE IsCorporate=true AND isActive=true');
            defaultCurrencyISO = String.valueof(ars[0].IsoCode);
        }
    return defaultCurrencyISO;
    }
}