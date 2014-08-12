trigger UpdateOpportunityLineItemDates on Opportunity (before insert,before update) 
{

        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 

    //used for support user creation
  //  Set<ID> opportunityIDSet = new Set<ID>();             //set to hold the contact IDs to be processed
    Date oppContractEndDate;
    Date mydate = Date.today();
    Map<ID, Opportunity> OpportunityRecMap = new Map<ID, Opportunity>();   
    List<Opportunity> opptoUpdate = new List<Opportunity>();
       
            String[] oppTypeSet = new String[]{'New Solution','New Logo'};

    
    
    
    for (Opportunity oppRec : Trigger.new)
    {         //get all contacts that need to process
            
            //********need to add check to make sure only process once.
            
        if ((trigger.isinsert && FirstRun_Check.FirstRun_UpdateOpportunityLineItems)||(trigger.isupdate 
                &&  (trigger.oldMap.get(oppRec.id).QAStatus__c != 'Complete' 
                || trigger.oldMap.get(oppRec.id).Contract_End_Date__c != OppRec.Contract_End_Date__c )
                && FirstRun_Check.FirstRun_UpdateOpportunityLineItems)
             )
             {          //only process opps that are at Complete - license contact & invoice contact are required.
         //   opportunityIDSet.Add(opprec.ID);
              opportunityRecMap.put(opprec.id, oppRec);
              oppContractEndDate = oppRec.Contract_End_Date__c;
              system.debug('opportunityrecMap:' + opportunityrecMap);
              FirstRun_Check.FirstRun_UpdateOpportunityLineItems = False;
        }
        
    }
    system.debug('opportunityRecMap.size(): '+ opportunityRecMap.size());
    system.debug('opportunityRecMap.keyset()'+ opportunityRecMap.keyset());
    if (opportunityRecMap.size() > 0){
      
        //update only opportunities that are set to QA_status = 'Complete' and recordtype contains 'New Logo'
        for(Opportunity oppRec : opportunityRecMap.Values())
        {
            Date oneYearDate = mydate.addYears(1);
            system.debug('oneYearDate: ' + oneYearDate);
            oppContractEndDate = oneYearDate.addDays(-1);
            system.debug('oppRec.Contract_End_Date__c: '+ oppRec.Contract_End_Date__c);
            Date currentOppContractEndDate = oppRec.Contract_End_Date__c;
            
 /*           list<RecordType> recordTypeList = new List<RecordType>([select id
                                                                    from RecordType
                                                                    where name in ('New Logo-New'
                                                                                , 'New Logo-Affiliate'
                                                                                , 'New Logo-RFP'
                                                                                , 'Additional Services') ]);
  */          
            if(oppRec.QALevel2Approved__c == True){
                boolean endDateSet = false;
                oppRec.Begin_Date__c = mydate;
                for( string oppType : oppTypeSet){
                    if (oppRec.Type == oppType){
                    //set contract end date = today+1year - 1 day;
                        OpportunityRecMap.get(oppRec.id).Contract_End_Date__c = oppContractEndDate;
                        OppRec.End_Date__c = oppContractEndDate;
                        endDateSet = true;
                     }
                }
                if(endDateSet == false)
                { 
                    if (currentOppContractEndDate > oppContractEndDate)
                    {
                        oppRec.End_Date__c = currentOppContractEndDate;
                        system.debug('currentoppcontractendDate>');
                    }
                    Else 
                    {
                        if ((currentOppContractEndDate <= oppContractEndDate) || (currentOppContractEndDate == null))
                        {
                             oppRec.End_Date__c = oppContractEndDate;
                             system.debug('currentoppcontractendDate< or null');
                        }
                    }   
                }                
            }
            opptoUpdate.add(oppRec);
        }   
        
        List<OpportunityLineItem> OppLineItemList = new List<OpportunityLineItem>([select id
                                                                                        , start_Date__c
                                                                                        , end_date__c
                                                                                        , opportunityId
                                                                                        from OpportunityLineItem
                                                                                        where  Product_Family__c = :System.Label.LX_Opp_Prod 
                                                                                        and  opportunityID in :opportunityRecMap.keyset()]);
        system.debug('OppLineItemList.size():' + OppLineItemList.size());
        system.debug('OppLineItemList:'+ OppLineItemList);
        
        if(OppLineItemList.size()>0)
        {
            //loop through OppLineItemList to set the start and end dates based on the information on the opportunity
            for(OpportunityLineItem oppLineItemrec : OppLineItemList){
                oppLineItemRec.End_Date__c = OpportunityRecMap.get(oppLineItemrec.opportunityID).Contract_End_Date__c;
                if (OpportunityRecMap.get(oppLineItemrec.opportunityID).QALevel2Approved__c == True){
                    oppLineItemRec.Start_Date__c = mydate;
                }
            } 
            update OppLineItemList;
        }                                                                               
          
    }           
                        
}