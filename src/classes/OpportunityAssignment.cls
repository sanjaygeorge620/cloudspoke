public class OpportunityAssignment {
  public static void assignOpty(List<Opportunity> oldOpts, List<Opportunity> newOpts)
    {
        
       /* List<Opportunity> opts = new List<Opportunity>();  
        Opportunity opty = null; 
        Opportunity newOpty = null;  
        Opportunity oldOpty = null;
        List<UserTerritory> trtryList = new List<UserTerritory>();
        UserTerritory usrTrtry = null;     USI Commented*/ 
              
        // If the Opportunity Owner changes, assign “Territory” in opportunity, based on the Owner’s territory.
     /*    if (newOpts!=null && newOpts.size()>0)  {
           for (Integer i =0; i< newOpts.size(); i++) {           
                newOpty = newOpts[i];
                if (oldOpts != null)
                    oldOpty = oldOpts[i];
                 // if the opty owner has changed
                if ((oldOpty == null) || (newOpty.OwnerId != oldOpty.OwnerId)){
                    // get user territory based on the user Id
                    trtryList =  [Select u.TerritoryId from UserTerritory u where u.UserId = :newOpty.OwnerId and isactive=true limit 1];
                    if (trtryList.size()>0) { usrTrtry = trtryList[0];}
                    // you got the territory id     
                    //then assign the opportunity to that user's territory
                    opty = [SELECT Id, TerritoryId FROM Opportunity where Id = :newOpts[i].Id];
                    if (usrTrtry != null) {
                        opty.TerritoryId = usrTrtry.TerritoryId;
                    }
                    else {
                        opty.TerritoryId = null;
                    }
                    opts.add(opty);
                }//ift
            } //for
             if (opts != null)
                update opts;
        }*/
    }


    
    static testMethod void testOptyAssignment()
    {
         // create array of Opty objects    
         // call updateOpty function  
         // verify results  System.assertEquals(...);
       /* List<Opportunity> oldOpts = new List<Opportunity>();
        List<Opportunity> newOpts = new List<Opportunity>();
        
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 2);       
                
        Opportunity opp = test_Opportunities[0];
        oldOpts.add(opp);
        
        Opportunity opp2 = test_Opportunities[1];
        opp2.OwnerId = '00570000001EqOr';//different  owner
        
        newOpts.add(opp2);
        
        assignOpty(oldOpts, newOpts);
        UserTerritory u = [Select u.TerritoryId from UserTerritory u where u.UserId = :opp2.OwnerId limit 1];
        Opportunity updateOpty = [Select Id, TerritoryId, OwnerId From Opportunity where Id = :opp2.Id];
 
        System.assertNotEquals('00570000001EqOrAAK', updateOpty.OwnerId);
        System.assertNotEquals('04TT00000000D90MAE', updateOpty.TerritoryId);*/
        
    }
}