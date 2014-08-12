/******************************************************************************

Name     : SetRFPProjectFields

Purpose  : set fields on the rfp Project based on the Opportunity data

Author   : jennifer dauernheim

Date     : March 17, 2010

******************************************************************************/

trigger SetRFPProjectFields on rfp_projects__c (after insert, after update) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code     
//Loop through triggers
    set <ID> rfpIDSet = new Set<ID>();
    set <ID> rfpoppIDSet = new Set<ID>();
    set <ID> UserIDSet = new Set<ID>();
    
        for (rfp_projects__c rfpRec : Trigger.new){
            //for any project updated, add to ID set

      if((trigger.isInsert)||((trigger.isUpdate) && (rfpRec.Opportunity__c != trigger.oldMap.get(rfpRec.id).Opportunity__c)) ){
              rfpIDSet.add(rfpRec.id);
              rfpoppIDSet.add(rfpRec.opportunity__c);
      }
        }
        
        system.debug('rfpoppidset set: ' + rfpoppIDSet);
        system.debug('rfpidset set: ' + rfpIDSet);
            
        map<ID, Opportunity> oppRecMap = New Map<ID, Opportunity>([select id, ownerid, ISR__c, owner.name, ISR__r.name, SE__c,(Select UserId, TeamMemberRole From OpportunityTeamMembers where TeamMemberRole = 'Systems Engineer') from Opportunity where id in :rfpoppIDSet ]);  //list of all opportunities that matched from the projects sent through with the trigger
         //****************
         for(opportunity opp:oppRecMap.values()){
         UserIDSet.add(opp.ownerid);
         } 
            //**************************
        
        map<ID, User> UserMap = New Map<ID, user>([select id, ManagerId from User where id in:UserIDSet]);
        //map of opp id, owner user id
        map<id,id> OppUserMap=new map<id,id>();
        for(opportunity opp:oppRecMap.values()){
        OppUserMap.put(opp.id,UserMap.get(opp.ownerId).ManagerId);
        }
        
        
        list<rfp_projects__c> rfpProjectList = [select id, Account_Executive__c,Inside_Sales_Representative__c, Sales_Engineer__c, Sales_Manager__c,opportunity__c from rfp_projects__c where id in :rfpIDSet];    //list of all rfpProjects that were sent in throught he trigger
        system.debug('rfpProjectList' + rfpProjectList);    
              
        List<rfp_projects__c> UpdateRFPProjectList = new List<rfp_projects__c>();           //List to hold all projects updated with their correct information 
        
        //for (rfp_projects__c rfpRec : Trigger.new){        
        for(rfp_projects__c UpdateRFPProjectRec : rfpProjectList) {
                            
            system.debug('rfpRec:' + UpdateRFPProjectRec.id);
            string UpdateOpp = 'No';
            system.debug('opportunity__c' +  UpdateRFPProjectRec.opportunity__c);
            if (UpdateRFPProjectRec.Account_Executive__c != oppRecMap.get(UpdateRFPProjectRec.opportunity__c).OwnerId){
                UpdateRFPProjectRec.Account_Executive__c = oppRecMap.get(UpdateRFPProjectRec.opportunity__c).OwnerId;
                system.debug('rfpRec:' + UpdateRFPProjectRec.Account_Executive__c);
                updateOpp = 'Yes';
                UpdateRFPProjectList.add(UpdateRFPProjectRec);
            }
           
            UpdateRFPProjectRec.Sales_Manager__c =OppUserMap.get(UpdateRFPProjectRec.opportunity__c);
            
            
            if((oppRecMap.get(UpdateRFPProjectRec.opportunity__c).OpportunityTeamMembers.size() > 0)){
            UpdateRFPProjectRec.Sales_Engineer__c=oppRecMap.get(UpdateRFPProjectRec.opportunity__c).OpportunityTeamMembers[0].UserId;
            }
            
            /*if (UpdateRFPProjectRec.Sales_Engineer__c != oppRecMap.get(UpdateRFPProjectRec.opportunity__c).SE__c){
                UpdateRFPProjectRec.Sales_Engineer__c = oppRecMap.get(UpdateRFPProjectRec.opportunity__c).SE__c;
                system.debug('rfpRec:' + UpdateRFPProjectRec.Sales_Engineer__c);
                updateOpp = 'Yes';
            }
            if (UpdateRFPProjectRec.Inside_Sales_Representative__c != oppRecMap.get(UpdateRFPProjectRec.opportunity__c).ISR__c){
                UpdateRFPProjectRec.Inside_Sales_Representative__c = oppRecMap.get(UpdateRFPProjectRec.opportunity__c).ISR__c;
                system.debug('rfpRec:' + UpdateRFPProjectRec.Inside_Sales_Representative__c);
                updateOpp = 'Yes';
            }
            if (updateOpp == 'Yes'){
                update UpdateRFPProjectRec;
            } */    
            
        }
        
        if(UpdateRFPProjectList.size() > 0){
            update UpdateRFPProjectList;
        }
 
}