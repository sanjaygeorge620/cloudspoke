trigger PopulateFlexeraAccount on Account (after update) 
{
    
    List<Account> sendtoClass = new List<Account>();
    List<Flexera_Account__c> toInsert = new List<Flexera_Account__c>();
    
    
    for(Account acc:Trigger.New)
    {
        if((Trigger.isUpdate&&(/*(acc.IsCustomerPortal == True && trigger.oldMap.get(acc.Id).IsCustomerPortal != True)||*/
                              (/*acc.IsCustomerPortal == True && */Trigger.oldMap.get(acc.Id).Name!=acc.Name)||
                              // *** This was commented prior to org clone by USI (acc.IsCustomerPortal == True &&acc.SMA_Status__c != Trigger.oldMap.get(acc.Id).SMA_Status__c)||
                              (/*acc.IsCustomerPortal == True && */acc.MDM_Sold_To_Number__c != Trigger.oldmap.get(acc.ID).MDM_Sold_To_Number__c))))
          { 
            sendtoClass.add(acc);
          } 
    }
    
    if(!SendtoClass.isEmpty())
    {
    toInsert = CreateFlexeraAccount.Create(sendtoClass);
    }
   
   if(!toInsert.isEmpty())
   {
      
   Upsert toInsert;
   }
    
}