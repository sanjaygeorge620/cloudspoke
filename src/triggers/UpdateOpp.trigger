trigger UpdateOpp on opportunity(before insert,before update)
  {
 
        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 

 
     Map<Id,Profile> pfMap = new Map<Id,profile>([Select Id,Name from Profile where Name = 'Marketing' or Name = 'Marketing Admin' or Name = 'Marketing User']);
   if(pfMap.containsKey(UserInfo.getProfileId()))
    {    
     Set<Id> oppids = new Set<Id>();
     Set<Id> oppPreQualIds = new Set<Id>();
     
    if(Trigger.isInsert)
    { 
     for(opportunity op: trigger.new)
     {     
         If (op.StageName == 'Developing')//VT changed Stagename due to change in stage map
         {
              if (op.Amount == 0.00 || op.Amount == null)
             {
                 op.Amount = 50000; 
             }
             
             op.Closedate = System.today() +  366;
         }
         else If (op.StageName == 'Qualifying ')
         {
          op.Amount = 0.00; 
             op.Closedate = System.today() +  366;   
         }
     }
     }
     
   if(Trigger.isUpdate)
    { 
     for(opportunity op: trigger.new)
     {     
     opportunity old_opp = Trigger.oldmap.get(op.id);
     
         If (op.StageName == 'Developing' && old_opp.StageName != 'Developing')//VT changed Stagename due to change in stage map
         {
             oppids.add(op.Id);
         }
         else If (op.StageName == 'Qualifying ' && old_opp.StageName != 'Qualifying ')
         {
             oppPreQualIds.add(op.Id);
         }
     }
     
     for(ID i: oppids)
     {
        opportunity opp = Trigger.newmap.get(i);
             if (opp.Amount == 0.00 || opp.Amount == null)
             {
                 opp.Amount = 50000; 
             }
             
             opp.Closedate = System.today() +  366;
     }
      
     
     for(ID i: oppPreQualIds) 
     { 
             opportunity opp = Trigger.newmap.get(i);
             opp.Amount = 0.00; 
             opp.Closedate = System.today() +  366;
         
     }      
     
     
     }
     
     }                           
  }