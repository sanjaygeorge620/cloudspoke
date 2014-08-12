/*
Class Name : LX_BMQuoteHelper
Description : Helper class to consolidate all the methods used in the various BM Quote related trigger
Created By : Rahul Raghunathan (rraghunathan@deloitte.com)
Created Date : 14-02-2014
Modification Log:
-------------------------------------------------------------------------
Developer            Date            Modification ID        Description
-------------------------------------------------------------------------
Rahul Raghunathan    14-02-2014        1000               Initial Version
Sumedha Kucherlapati 08-02-2014        1001               Added logic to sync create 
                                                          share records for opportunity  
Praveen Sadineni     05-14-2014        US3588             Share Quote with Opportunity Owner and Team Members with All Access                                                          
                                                             
*************************************************************************/
global with sharing class LX_BMQuoteHelper {
   
   
    public static boolean futureCalled  = false;

    
   /*
   * Description : Method called from the child Opportunity button to manually create MQLIs.
   *               The share quote method is then called to create share records for this opportunity to all related quotes
   * Param       : Opportunity ID
   * Return Type : Null
   */
    
    
    webservice static void createMQLi(id childId){
        boolean bypassTrigger = false;
        boolean deleteTrigger = false;
        
        //get the current user permission and bypass it so that the users dont have any problem syncing
        LX_Profile_Exclusion__c currentUserPermission = LX_Profile_Exclusion__c.getvalues(UserInfo.getUserId());
        
        if(currentUserPermission == null){
            currentUserPermission  = new LX_Profile_Exclusion__c(SetupOwnerId=UserInfo.getUserId(),Bypass__c=true);
            insert currentUserPermission;
            deletetrigger = true;
        }
        ID OppId ;
        
        if(currentUserPermission.Bypass__c){
            bypassTrigger = true;
        }else{
            bypassTrigger = false;
            currentUserPermission.Bypass__c = true;
            update currentUserPermission;
        }
        
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            list<Opportunity> childOpp = [select id, Master_Opportunity__c from Opportunity where id =:childId limit 1]; 
            
            for(Opportunity opp :childOpp){
                OppId = opp.Master_Opportunity__c; 
            }
            
            
        list<id> childIds = new list<id>();
        childIds.add(childId);
        LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
        
        
        map<id,Opportunity>oppMap =  new map<id,Opportunity>([SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,
                                                              MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,
                                                              (Select LX_Country_Code__c, id, CurrencyIsoCode, Master_Opportunity__c From ChildOpportunities__r 
                                                                where id =:childIds) 
                                                              FROM Opportunity 
                                                              WHERE Id = :OppId limit 1]);
                                                              
       map<id,OpportunityLineItem> lineItems= new map <id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c 
                                                                                from OpportunityLineItem
                                                                                where OpportunityId=:oppMap.keyset()]); 
       Map<Id,List<OpportunityLineItem>> Olimp = new Map<Id,List<OpportunityLineItem>>();
       for(OpportunityLineItem oli : lineItems.values()){
       
           if(Olimp.get(oli.OpportunityId) == null)
             Olimp.put(oli.OpportunityId, new List<OpportunityLineItem >{oli});
             else
             Olimp.get(oli.OpportunityId).add(oli);
           
       }                                                                         
        map<id,Opportunity> childOppMap = new map<id,Opportunity>();    
         map<id,Id> childIdsMap = new map<id,Id>();                                                 
        for(Opportunity opp:oppMap.values()){
            for(Opportunity child:opp.ChildOpportunities__r){
                childOppMap.put(child.id,child);
                childIdsMap.put(child.id,opp.id);
            }
        }
        
        delete [select id from LX_Master_Quote_Line_Item__c where lx_Opportunity__c = :childIds];
        
        LX_OpportunityLineItemHelper.mqliUpdate1(oppMap,childOppMap,lineItems,Olimp,childIdsMap);
        }catch (exception ex){
            Database.rollback(sp);
            LX_CommonUtilities.createExceptionLog(ex);
        }
        
        //update the current user permission
        if(!bypassTrigger ){
            currentUserPermission.Bypass__c = false;
            update currentUserPermission;
        }
        
        if(deleteTrigger){
            delete currentUserPermission;
        }
         
        
    }

   /*
   * Description : Method called from Quote sharing button on Opportunity to query for all related quotes and construct a map.
   *               The share quote method is then called to create share records for this opportunity to all related quotes
   * Param       : Opportunity ID
   * Return Type : Null
   */
    
    webservice static void constructquoOppMap(Id OppId){
        Map<ID,ID> quoOppMap = new Map<ID,ID>();
        for(BigMachines__Quote__c  bmQuote : [SELECT ID,BigMachines__Opportunity__c FROM BigMachines__Quote__c WHERE BigMachines__Opportunity__c =:OppId]){
            quoOppMap.put(bmQuote.id,bmQuote.BigMachines__Opportunity__c);
        }   
        if(!quoOppMap.isEmpty()){
          System.debug('>>>>>>>Quote Map from trigger LX_BMQuoteHelper >>>>>>>>'+quoOppMap);
          shareQuotes(quoOppMap);
        }
    }
    
   /*
   * Description : Method called from the Opportunity Team Member to share the Quote with them..
   * Param       : lineItem Ids
   * Return Type : Null
   */
    @future
    public static void shareQuoteWithTeamMembers(set<string> oppTeamList){
    
        map<string,set<string>> OppIDTeamMemberMap          = new map<string,set<string>>();                
        map<string,OpportunityTeamMember> oppTeamMember     = new map<string,OpportunityTeamMember>();
        map<string,BigMachines__Quote__Share> BMShareMap    = new map<string,BigMachines__Quote__Share>();
        map<string,string> QuoteOppMap                      = new map<string,string>();
        set<id> QuoteIds        = new set<id>();
        set<id> userIds         = new set<id>();
        list<BigMachines__Quote__Share> updateShare = new list<BigMachines__Quote__Share>();
        list<BigMachines__Quote__Share> deleteShare = new list<BigMachines__Quote__Share>();
         
        for(string st :oppTeamList){
            list<string> splitResult = st.split('-');
            userIds.add(splitResult[1]);
                
            if(OppIDTeamMemberMap.containsKey(splitResult[0])){
                set<string> resultList = OppIDTeamMemberMap.get(splitResult[0]);
                
                if(!resultList.contains(splitResult[1])){
                    resultList.add(splitResult[1]);
                    OppIDTeamMemberMap.put(splitResult[0],resultList);
                }
                
            }else{
                OppIDTeamMemberMap.put(splitResult[0], new set<string>{splitResult[1]});
            }
        }
        
        for(OpportunityTeamMember opp :[select id,OpportunityAccessLevel,userId,OpportunityId from OpportunityTeamMember where OpportunityId =:OppIDTeamMemberMap.KeySet()]){
            oppTeamMember.put(opp.OpportunityId+'-'+opp.userID,opp);
        }
        
        for(BigMachines__Quote__c quote:[SELECT ID,BigMachines__Opportunity__c FROM BigMachines__Quote__c WHERE BigMachines__Opportunity__c =:OppIDTeamMemberMap.KeySet()]){
            QuoteIds.add(quote.id);
            QuoteOppMap.put(quote.BigMachines__Opportunity__c,quote.id);
        }
        
        for(BigMachines__Quote__Share share: [select ParentId,UserOrGroupId from BigMachines__Quote__Share where ParentID =:QuoteIds and UserOrGroupId =:userIds]){
            BMShareMap.put(share.parentID+'-'+share.UserOrGroupId, share);
        }
        
        for(string st :oppTeamList){
                list<string> splitResult = st.split('-');
                if(BMShareMap.containsKey(QuoteOppMap.get(splitResult[0])+'-'+splitResult[1])){
                    deleteShare.add(BMShareMap.get(QuoteOppMap.get(splitResult[0])+'-'+splitResult[1]));                    
                }
                
                if(oppTeamMember.containsKey(st) && QuoteOppMap.get(splitResult[0]) != null){
                    updateShare.add(new BigMachines__Quote__Share(RowCause = 'Manual', AccessLevel = oppTeamMember.get(st).OpportunityAccessLevel, ParentId = QuoteOppMap.get(splitResult[0]), UserOrGroupId = oppTeamMember.get(st).UserId));
                }
                
            }
     
         if(deleteShare.size() > 0){
            delete deleteShare;
         }      
         
         if(updateShare.size() > 0){
            insert updateShare;
         }
                
    }
    
//  @future            //Praveen Removing Future annotation

    public static void shareQuotes(map<id,id> quoOppMap){
        
        // Variable used to store row cause to Quote share records
         String rowCauseManual = 'Manual';
        // Variable used to store access level to Quote share records
        String quoteAccessLevel = 'Edit' ;
        // Map variable to store Quote Id and Quote object
        Map<Id,BigMachines__Quote__c> quoObjMap = new Map<Id,BigMachines__Quote__c>([select id,OwnerID,Lx_Account__c from BigMachines__Quote__c where id =:quoOppMap.keySet() and Lx_Account__c != null]);
        // Map variable to store Opportunity Id and its Owner
        Map<Id,Id> oppOwnerMap = new Map<Id,Id>();
        // Map variable to store Opportunity Id and Opportunity Team members user Id
        Map<Id,List<Id>> oppTeamMembers = new Map<Id,List<Id>>();
        // Map variable to store Opportunity owner and related Managers upto three level
        Map<Id,List<Id>> oppOwnerManagerMap = new Map<Id,List<Id>>();
        // List variable to store Quote share records
        List<BigMachines__Quote__Share> quoteShareRecs = new List<BigMachines__Quote__Share>();
        // Variable to store user or group Id being added to share records. Used as check point to make sure no duplicate share record is created for same user
        set<Id> userOrGroupID = new set<Id>();
        set<Id> AccIDSet = new set<Id>();
        Map<ID,Map<ID,String>> access_Level_Map = new Map<ID,Map<ID,String>>();
        Map<string,String> AcctTeam_OppAccess = new Map<string,String>();
            
        if(quoOppMap.size()>0)
        {
            for(id qu_id : quoObjMap.keyset())
            {
                AccIDSet.add(quoObjMap.get(qu_id).Lx_Account__c);                
            }
            
        for(Opportunity opp : [SELECT ID, OwnerID, AccountID FROM Opportunity WHERE Id IN :quoOppMap.values()])
        {
               oppOwnerMap.put(opp.Id,opp.OwnerId);
        }
        List<AccountShare> ActShare_Lst = [Select id,AccountId,AccountAccessLevel,ContactAccessLevel,CaseAccessLevel,OpportunityAccessLevel,UserOrGroupId,rowCause
                                            from AccountShare where AccountId IN :AccIDSet and rowCause in  ('Team','Owner') and OpportunityAccessLevel != 'None'];
            
            if(!ActShare_Lst.isEmpty())
            {
               for(AccountSHare aSH : ActShare_Lst)
               {                   
                       AcctTeam_OppAccess.put(aSH.AccountId + '--' + aSH.UserOrGroupId,aSH.OpportunityAccessLevel);
               }
            }
            
        
            for(Account atm : [select id,OwnerID,(SELECT AccountAccessLevel,AccountId,TeamMemberRole,UserId FROM Account.AccountTeamMembers where AccountAccessLevel in ('Edit','All','Read')) from Account where id IN :AccIDSet])
            {
                map<ID,String> temp_map = new map<ID,String>();
                temp_map.put(atm.OwnerID,'Edit');
                access_Level_Map.put(atm.id,temp_map);
                if(access_Level_Map.containsKey(atm.id))
                {                    
                    if(!atm.AccountTeamMembers.isEmpty())
                    {
                        for(AccountTeamMember atmb : atm.AccountTeamMembers)
                        {
                            if(AcctTeam_OppAccess.containsKey(atmb.AccountId + '--' +atmb.UserId))
                            {
                    access_Level_Map.get(atm.id).put(atmb.UserId,AcctTeam_OppAccess.get(atmb.AccountId + '--' +atmb.UserId));
                            }
                        }
                    }
                }                
            }
            
            
        for(OpportunityTeamMember opTeam : [SELECT OpportunityAccessLevel,OpportunityId,UserId FROM OpportunityTeamMember WHERE OpportunityId IN :quoOppMap.values() AND OpportunityAccessLevel in ('Edit','All') AND User.IsActive = TRUE]){    // Added OpportunityAccessLevel = All  Praveen 05-14
             if(!oppTeamMembers.containsKey(opTeam.OpportunityId))
             {
              oppTeamMembers.put(opTeam.OpportunityId,new List<Id>{opTeam.UserId});
             }
             else 
             {
              oppTeamMembers.get(opTeam.OpportunityId).add(opTeam.UserId);
             }
        }

        if(!oppOwnerMap.isEmpty())
        {

         for(User us : [SELECT Id, ManagerId, Manager.ManagerId, Manager.Manager.ManagerId FROM User WHERE Id IN: oppOwnerMap.values()])
        {
                oppOwnerManagerMap.put(us.Id,new List<Id>{us.Id,us.ManagerId,us.Manager.ManagerId,us.Manager.Manager.ManagerId});
        } 
             for(Id qId : quoOppMap.keySet())
             {
             // To share records to Opportunity Sales Team
            if(!oppTeamMembers.isEmpty())
            {
                 if(oppTeamMembers.containsKey(quoOppMap.get(qId)))
                    {
                      for(Id opteamId : oppTeamMembers.get(quoOppMap.get(qId)))
                      {
                           // Check to make sure UserId is not NULL and os not Owner of Quote (in which case the share record is already created)
                           // and a share record is not already created
                           if(opteamId != NULL && opteamId != quoObjMap.get(qId).OwnerId && !userOrGroupID.contains(opteamId))
                           {
                               userOrGroupID.add(opteamId);
                               quoteShareRecs.add(new BigMachines__Quote__Share(RowCause = rowCauseManual, AccessLevel = quoteAccessLevel, ParentId = qId, UserOrGroupId = opteamId)) ;
                           }
                       }
                    }
                   
            }
             // To share records to Opportunity Owner Managers upto three levels
            if(!oppOwnerManagerMap.isEmpty())
            {
               if(quoOppMap.containsKey(qId) && oppOwnerMap.containsKey(quoOppMap.get(qId)) && oppOwnerManagerMap.containsKey(oppOwnerMap.get(quoOppMap.get(qId)))){
                   for(Id managId : oppOwnerManagerMap.get(oppOwnerMap.get(quoOppMap.get(qId))))
                   {
                      // Check to make sure UserID is not NULL and not equal to Quote Owner ID 
                      if(managId != NULL && quoObjMap.containsKEy(qId) &&managId != quoObjMap.get(qId).OwnerId)
                      {
                        if(!userOrGroupID.contains(managId))
                        {
                            quoteShareRecs.add(new BigMachines__Quote__Share(RowCause = rowCauseManual, AccessLevel = quoteAccessLevel, ParentId = qId, UserOrGroupId = managId)) ;
                         }
                      }
                   }
                }        
             }
            if(!access_Level_Map.isEmpty())     
            {
                if(access_Level_Map.containsKey(quoObjMap.get(qId).Lx_Account__c))
                {
                    for(id i : access_Level_Map.get(quoObjMap.get(qId).Lx_Account__c).keyset())
                    {
                        system.debug('----------------' +i);
                        system.debug('----------------' +access_Level_Map.get(quoObjMap.get(qId).Lx_Account__c).get(i));
                        quoteShareRecs.add(new BigMachines__Quote__Share(RowCause = rowCauseManual, AccessLevel = access_Level_Map.get(quoObjMap.get(qId).Lx_Account__c).get(i), ParentId = qId, UserOrGroupId = i)) ;                        
                    }
                    
                }
                
                
            }
                 
           }
             try{
                  if(quoteShareRecs.size()>0){
                    upsert quoteShareRecs;
                  }
                }catch(Exception ex){
                    LX_CommonUtilities.createExceptionLog(ex);
                }
           }
       }
   
    }

}