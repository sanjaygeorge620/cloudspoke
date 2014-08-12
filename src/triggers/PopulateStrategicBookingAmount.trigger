/*
Created by Lalit Malav 12.4.2012

Created to populate Opportunity's Strategic Booking Amount by sum of the Total Price field of all Opportunity Products where Strategic field is checked.  

*/

trigger PopulateStrategicBookingAmount on Opportunity (before update) {
    
        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
  
    
    List<String> Oppids = new List<String>();
    List<OpportunityLineItem> oppLiList = new List<OpportunityLineItem>();
    List<Opportunity> OppToBeUpdated  = new List<Opportunity>();
    for(Opportunity opp : Trigger.new)
    {
        Oppids.add(opp.id);
    }
    Map<Id, Opportunity> oppMap = new  Map<Id, Opportunity>([Select id,  (Select TotalPrice From OpportunityLineItems where Strategic__c = true) From Opportunity where id in :Oppids]);
    Decimal SumOfTotalPrice = 0.0;
    for(Opportunity opp : Trigger.new)
    {
        oppLiList = oppMap.get(opp.id).OpportunityLineItems; 
            for(OpportunityLineItem OLI: oppLiList)
            {
                SumOfTotalPrice = SumOfTotalPrice+OLI.TotalPrice;
            }
            opp.Strategic_Booking_Amount__c = SumOfTotalPrice;
        
    }
}