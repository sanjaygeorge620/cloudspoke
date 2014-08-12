trigger UpdateOppOwnerManager on Opportunity (before insert, before update) 
{    
        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  


    Set<Id> ownerIdSet = new Set<Id>();
    List<Opportunity> OpportunityToBeUpdate = new List<Opportunity>();
    Map<Id,Id> ownerManagerMap = new Map<Id,Id>();
    Map<Id,String> empNumberMap = new Map<Id,String>(); //added for US1145 by Manoj Kolli on 3/19/2012
    Map<Id,String> LegCompanyUserMap = new Map<Id,String>();//added for US1474 by Manoj Kolli on 6/7/2012
    Map<ID,User> OppOwnerMap = new Map<ID,User>();
    // make a set of owner ids on opportunity insert
    if(Trigger.isInsert)
    {
        for(Opportunity opp : Trigger.New){
            if(opp.OwnerId != null){
                ownerIdSet.add(opp.OwnerId);
                OpportunityToBeUpdate.add(opp);
            }
        }
    }
    // make a set of owner ids on opportunity update
    if(Trigger.isUpdate)
    {
        for(Opportunity opp : Trigger.new)
        {
            // if the owner is set and either Owner Manager isn't set or the Owner has changed 
            if(opp.OwnerId != null && (((opp.Owner_Manager__c == null || opp.OwnerId != Trigger.oldMap.get(opp.Id).OwnerId || opp.Employee_Number__c == null || opp.Legacy_User_Sales_Company__c == null))||(opp.Owner_Email__c == null||opp.OwnerId != Trigger.oldMap.get(opp.Id).OwnerId)))
            {
                //Added Emplyee Number in If condition for US1145 by Manoj Kolli on 3/19/2012
                //Added Legacy User Sales Company in If condition for US1474 by Manoj Kolli on 6/7/2012
                ownerIdSet.add(opp.OwnerId);
                OpportunityToBeUpdate.add(opp);
            }
        }
    }
    if(ownerIdSet.size() > 0)
    {
        //load all manager of the opportunity owners
        for(User user : [select Id,Name,Email,ManagerId,EmployeeNumber,Legacy_Company__c from User where id in : ownerIdSet])
        {
            OppOwnerMap.put(user.ID,user);
            ownerManagerMap.put(user.Id,user.ManagerId);
            empNumberMap.put(user.Id,user.EmployeeNumber); //added for US1145 by Manoj Kolli on 3/19/2012
            LegCompanyUserMap.put(user.Id,user.Legacy_Company__c); //added for US1474 by Manoj Kolli on 6/7/2012
        }
    }
    
    //set Owner Manager field
    for(Opportunity opp : OpportunityToBeUpdate)
    {
    if(opp.OwnerId != null && OppOwnerMap.containskey(opp.OwnerID))
    {
    opp.Owner_Email__c = OppOwnerMap.get(opp.OwnerID).email;
    }
        if(opp.OwnerId != null && ownerManagerMap.containsKey(opp.OwnerId))
        {
            opp.Owner_Manager__c = ownerManagerMap.get(opp.OwnerId);
        }
        //added for US1145 by Manoj Kolli on 3/19/2012
        if(opp.OwnerId != null && empNumberMap.containsKey(opp.OwnerId))
        {
            opp.Employee_Number__c = empNumberMap.get(opp.OwnerId);
        }
        //added for US1145 by Manoj Kolli on 3/19/2012
        if(opp.OwnerId != null && LegCompanyUserMap.containsKey(opp.OwnerId))
        {
            opp.Legacy_User_Sales_Company__c = LegCompanyUserMap.get(opp.OwnerId);
        }
    }
}