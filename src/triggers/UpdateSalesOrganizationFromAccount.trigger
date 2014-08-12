/**********************
* Updated By - Hemlata(Appirio Offshore)
* Updated Date - July 2012
* Description - Case 00030358
**********/
trigger UpdateSalesOrganizationFromAccount on Opportunity ( before insert, before update) 
{
  Set<Id> setAccountIds = new Set<Id>();
  for(Opportunity opportunity : trigger.New)
  {
    /* old control block - updated for US1383 - we always set/validate this field now
    if ((trigger.isinsert && opportunity.Sales_Organization_Value__c != null)|| 
                    (trigger.isupdate && trigger.oldMap.get(opportunity.id).Sales_Organization_Value__c != opportunity.Sales_Organization__r.Sales_Organization__c 
                                  && opportunity.Sales_Organization_Value__c != null))
    */
    if(opportunity.AccountId != null)
      setAccountIds.add(opportunity.AccountId);
    if(opportunity.Primary_Partner__c != null)
      setAccountIds.add(opportunity.Primary_Partner__c);
  }
  
  if (!setAccountIds.isEmpty()) 
  {
    Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,coverage_id__r.Sales_Organization__c 
                                                      FROM Account 
                                                      WHERE Id in :setAccountIds and coverage_id__r.Sales_Organization__c != null]);
    for(Opportunity Opp : Trigger.new)
    {
      if(accountMap.containsKey(opp.Primary_Partner__c))
      { 
        if(Opp.Primary_Partner__c != null && (Account__c.getAll().containsKey(Opp.AccountTypeUpdate__c)))
        {                    
          Opp.Sales_Organization__c = accountMap.get(opp.Primary_Partner__c).coverage_id__r.Sales_organization__c;
        }  
        else if(Opp.Primary_Partner__c != null && (!Account__c.getAll().containsKey(Opp.AccountTypeUpdate__c)))
        {
        if(accountMap.containsKey(opp.AccountId))
         { 
        Opp.Sales_Organization__c = accountMap.get(opp.AccountId).coverage_id__r.Sales_organization__c;
         }        
        } 
      } 
      else if(accountMap.containsKey(opp.AccountId))
      { 
        Opp.Sales_Organization__c = accountMap.get(opp.AccountId).coverage_id__r.Sales_organization__c;
      }
    }
  } 
}