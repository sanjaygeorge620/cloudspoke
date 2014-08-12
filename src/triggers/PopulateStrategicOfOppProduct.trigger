/*
Created by Lalit Malav 12.5.2012

Created to populate Opportunity product's Strategic  by Product's Strategic value .  

*/
trigger PopulateStrategicOfOppProduct on OpportunityLineItem (after insert, after update,before insert,before update) 
{
   if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
   
   /* List<String> ProductIds = new List<String>();
    List<String> OppLineItemIds = new List<String>();
    Map<String,String> OliIdAndProdIdMap = new Map<String,String>();
    
    for(OpportunityLineItem OLI : Trigger.new)
    {
        OppLineItemIds.add(OLI.id);
    }
    for(OpportunityLineItem oLineItem : [Select id,  PricebookEntry.Product2id From OpportunityLineItem  where id in :OppLineItemIds])
    {
        ProductIds.add(oLineItem.PricebookEntry.Product2id);
        OliIdAndProdIdMap.put(oLineItem.id, oLineItem.PricebookEntry.Product2id);
    }
    Map<Id, Product2> ProductIdandStragicMap = new Map<Id, Product2>([select id, Strategic__c ,Use_Sizing_Tool__c  from product2 where id in :ProductIds]);
    List<OpportunityLineItem> OLIToBeUpdated = new List<OpportunityLineItem>();
    for(OpportunityLineItem OLI : Trigger.new) 
    {
        OpportunityLineItem o = new OpportunityLineItem(id = OLI.id);
        o.Strategic__c = ProductIdandStragicMap.get(OliIdAndProdIdMap.get(OLI.id)).Strategic__c; 
        OLIToBeUpdated.add(o);
        system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxx');
        
        
        
    }
    
   
    
    if(OLIToBeUpdated.size()>0)
    update OLIToBeUpdated;*/
    
    //Before trigger populates Strategic checkbox field of Product. 
    if(trigger.isBefore)
    {
        set<Id>setPricebookEntryIds = new Set<Id>();
        //iterating over list of OpportunityLineItems to collect PricebookEntryIds 
        for(OpportunityLineItem objOLI : Trigger.new)
        {
            if(objOLI.PricebookEntryId != null && ((Trigger.isInsert && objOLI.PricebookEntryId != null) || (Trigger.isUpdate &&  trigger.oldMap.get(objOLI.Id).PricebookEntryId != objOLI.PricebookEntryId )))
            {
                setPricebookEntryIds.add(objOLI.PricebookEntryId);
            }
        }
        //querying on PriceBookEntry to get Product's Strategic checkbox field value.
        map<id,PricebookEntry>mapPricebookEntry = new map<id,PricebookEntry>([Select p.Product2.Strategic__c, p.Product2Id, p.Id,p.Product2.Use_Sizing_Tool__c   From PricebookEntry p where p.Id in : setPricebookEntryIds]);
       
        //iterating over OpportunityLineItem to set Strategic field value
        for(OpportunityLineItem objOLI : Trigger.new)
        {
            if(objOLI != null && objOLI.Strategic__c != true && objOLI.PricebookEntryId != null && mapPricebookEntry.containsKey(objOLI.PricebookEntryId))
            {
                PricebookEntry objPricebookEntry = mapPricebookEntry.get(objOLI.PricebookEntryId);
                if(objPricebookEntry.Product2 != null){
                    objOLI.Strategic__c = objPricebookEntry.Product2.Strategic__c;
                    
                }    
            }
        }
             
    }
    else if(Trigger.isafter )
    {
        //updateOpportunities method summarise Strategic_Booking_Amount__c field of ALL Strategic OpportunityLineitems
        list<OpportunityLineItem> OpptyLineList = new list<OpportunityLineItem>();
        for(opportunityLineItem opp:Trigger.new)
        {
        
         if(Trigger.isupdate){
         if(trigger.oldmap.get(opp.id).TotalPrice != trigger.newmap.get(opp.id).TotalPrice && opp.strategic__c ==True)
               OpptyLineList.add(opp);
              system.debug('opptylineid-----'+OpptyLineList);
              system.debug('opptyline size-----'+OpptyLineList.size());
         }else{
           OpptyLineList.add(opp);
         }
        }
        if(OpptyLineList.size()>0)
        PopulateStrategicOfOppProductController.updateOpportunities(Opptylinelist);
        
    }
}