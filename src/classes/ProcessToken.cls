public with sharing class ProcessToken {

@Future

    public static void ProcessToken(Set<ID> oppIdSet, List<String> TokenType) {
         //for all opps that need to be processed - get all opportunity line items with a category = TokenType & processed flag = null
         system.debug('tokentype list: ' + tokenType);
        List<OpportunityLineItem> oppRecListBreakOut = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppRecList = new List<OpportunityLineItem> ([select id, 
                                                                                   Opportunity.accountID, 
                                                                                   OpportunityId,
                                                                                   unitprice,
                                                                                   Base_Price__c,
                                                                                   currencyISOcode,
                                                                                   PricebookEntry.Product2Id,
                                                                                   Quantity,
                                                                                   Processed__c,
                                                                                   Processed_Date__c,
                                                                                   Token_Type__c
                                                                                   from OpportunityLineItem 
                                                                                   where Token_Type__c In :TokenType 
                                                                                         and Processed__c <> True
                                                                                         and Opportunityid in :oppIdSet]);
        system.debug('Opportunity Line Items: ' + oppRecList);
        system.debug('Opportunity Line Items List Size: ' + oppRecList.size());
        system.debug('tokentype.size(): ' + tokenType.size());
        If (oppRecList.size() > 0){ 
            //process out records to process into list
            for (integer r=0; r<TokenType.size();r++){
                system.debug('token type:' + tokentype[r]);

                for(OpportunityLineItem lineItem : oppRecList) {
                    system.debug('opp line item token type:' + lineItem.Token_Type__c);
                    if (lineItem.Token_Type__c == tokenType[r] ){
                        oppRecListBreakOut.add(lineItem);
                    }
                }
                system.debug('oppRecListBreakOut size:'+ oppRecListBreakOut.size());                        
                List<Token__c> NewTokens = new List<Token__c>();  
                
            //for each record in the oppRecList - create a oken record for each quantity populating the data from the opportunity Line item
                If(oppRecListBreakOut.size() > 0){
                    for(OpportunityLineItem lineItem : OppRecListBreakOut) {        //go through each record pull back\
                        system.debug('LineItem: ' + lineitem);
                        system.debug('Quantity: '+ lineItem.Quantity);
                        for (Integer Q = 0; Q < lineItem.Quantity; Q++){                            //for each record's quantity - create a token record
                           
                            Token__c tempTokenRec = new Token__c();
                            tempTokenRec.Account__c = lineItem.Opportunity.accountID;
                            tempTokenRec.Opportunity__c = lineItem.Opportunityid;
                            tempTokenRec.Product__c = lineItem.PricebookEntry.Product2Id;
                            tempTokenRec.Base_Price__c = lineItem.Base_Price__c;
                            tempTokenRec.Sale_Price__c = lineItem.unitprice;
                            tempTokenRec.currencyISOcode = lineItem.currencyISOcode;
                            tempTokenRec.token_type__c = lineItem.token_type__c;
                            system.debug('TempTokenRec: ' + tempTokenRec);
                            NewTokens.add(tempTokenRec);
                            system.debug('Size of new tokens: ' + NewTokens.size());   
                            if (newTokens.size() > 10) {
                                system.debug('Opportunity Line Items - after update: ' + oppRecList);
                                insert   NewTokens;
                                NewTokens.clear();
                            }
                        }  //end for loop per quantity   
                        lineItem.Processed__c = True;
                        lineItem.Processed_Date__c = system.now();
            
                    }
                    If (newTokens.size()>0) {           ///this should update the last few of the tokens left in the batch
                        system.debug('Opportunity Line Items - after update: ' + oppRecList);
                                insert   NewTokens;
                    }
                
                }
                newTokens.clear();
                oppRecListBreakOut.clear();
            }
            system.debug('update opportunities');
            update oppRecList;              //update the processed flag
        } 
    }
 
}