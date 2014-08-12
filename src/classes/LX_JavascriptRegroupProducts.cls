global class LX_JavascriptRegroupProducts{
    
    webservice static void reGrouping(Id OppId){
        OpportunityLineItemGrouping.UpdateLineItemGroupingInfo(new Set<Id>{oppId});    
    }

}