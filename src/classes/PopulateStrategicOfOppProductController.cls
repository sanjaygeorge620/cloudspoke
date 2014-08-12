/* This Controller's static method updateOpportunities will be called from  PopulateStrategicOfOppProduct trigger.
    This method will iterate over related OpportunityLineItem to set summarised TotalPrice of Strategic field.
*/
public with sharing class PopulateStrategicOfOppProductController
{
    
    //Static boolean field to avoid recurrisive Trigger execution fom Opportunity trigger.
    public static boolean bUpdateOpportunities = false;
    public static void updateOpportunities(List<OpportunityLineItem>lstNewOpportunityLineItems)
    {
    system.debug('I am Here');
        if(!bUpdateOpportunities)
        {
            set<Id>setOpportunityIds = new set<Id>();
            for(OpportunityLineItem objOLI : lstNewOpportunityLineItems)
            {
                setOpportunityIds.add(objOLI.OpportunityId);
            }
            
            List<Opportunity> lstOpportunities = [Select id, Strategic_Booking_Amount__c, (Select TotalPrice From OpportunityLineItems where Strategic__c = true) From Opportunity where id in :setOpportunityIds];
            Decimal dSumOfTotalPrice = 0.0;
            List<OpportunityLineItem> lstOPLIs = new List<OpportunityLineItem>();
            List<Opportunity> lstOpportunitiesToUpdate = new List<Opportunity>();
            if(lstOpportunities != null && lstOpportunities.size() > 0)
            {
                for(Opportunity objOpportunity : lstOpportunities)
                {
                    dSumOfTotalPrice = 0.0;
                    lstOPLIs = objOpportunity.OpportunityLineItems; 
                    for(OpportunityLineItem objOLI: lstOPLIs)
                    {
                         system.debug('Total Amount***'+objOLI.TotalPrice);
                        dSumOfTotalPrice = dSumOfTotalPrice + objOLI.TotalPrice;
                    }
                   
                    system.debug('Strategic Booking Amount!!!'+objOpportunity.Strategic_Booking_Amount__c);
                    if(dSumOfTotalPrice > 0 && dSumOfTotalPrice != objOpportunity.Strategic_Booking_Amount__c)
                    {
                        objOpportunity.Strategic_Booking_Amount__c = dSumOfTotalPrice;
                        lstOpportunitiesToUpdate.add(objOpportunity);
                    }
                }
                if(lstOpportunitiesToUpdate != null && lstOpportunitiesToUpdate.size() > 0)
                    update lstOpportunitiesToUpdate;
            }
            bUpdateOpportunities = true;
        }
    }
}