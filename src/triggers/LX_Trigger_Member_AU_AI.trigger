trigger LX_Trigger_Member_AU_AI on LX_Territory_Member__c (after insert, after update) {


    /* Class Name   : LX_Territory_Member__c 
    * Description   : Trigger for ensuring only one territory member of a territory combo for a user can be default true so that
        it can be used to autopopulate the territory of the user on Opportunity.If a default combo already exists and 
        the default flag is checked for a new/updated record, then it gets unchecked for all the other records
    * Created By   : Veenu Trehan
    * Created Date : 05-02-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Veenu Trehan              05-02-2013                                  Initial Version

    */
    

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
    list<LX_Territory_Member__c > TerrMembersList=new list<LX_Territory_Member__c> ();//list to store territory Members which need to be updated
    list<id> UserList=new list<id>();//list of users
    set<id> TriggrNewIdSet=new set<id>();//contains a set of id of the current records which activate the trigger so as to remove them form the list of ids to be updated

//tests if it is a new record being created and the default flag is true,
//then it adds the record to a list and the id to a set

     if(trigger.isInsert){
        for(LX_Territory_Member__c TempTerrMember:trigger.new){
            if(TempTerrMember.LX_DefaultFlag__c==true){
                    UserList.add(TempTerrMember.LX_User__c);
                    TriggrNewIdSet.add(TempTerrMember.Id);
                    system.debug('insert');
                }
            }
        }
        
 //checks if the record is being updated and the new value of then default flag is true and 
 //the old value of the default flag was not true,then it adds the record to a list and the id to a set
        
    if(trigger.isUpdate){
        for(LX_Territory_Member__c TempTerrMember:trigger.new){
            if(TempTerrMember.LX_DefaultFlag__c==true &&
               trigger.oldmap.get(TempTerrMember.Id).LX_DefaultFlag__c!=true){
                    UserList.add(TempTerrMember.LX_User__c);
                    TriggrNewIdSet.add(TempTerrMember.Id);
                    system.debug('update');
            }
        }

    }
  //Query for all the territory members which have the same territory as in the record which triggers this trigger and 
  //has default flag=true  
    TerrMembersList=[SELECT Name,LX_Territory_Id__c,LX_User__c,LX_DefaultFlag__c 
                         FROM LX_Territory_Member__c 
                         WHERE LX_User__c =:UserList AND Id NOT IN :TriggrNewIdSet];

    
  //updates all the records apart from the current one to have defaultflag=false and update the records  
    for(LX_Territory_Member__c TerrMember:  TerrMembersList){
        if(TerrMember.LX_DefaultFlag__c==true){
            TerrMember.LX_DefaultFlag__c=false;
            system.debug('false');
        }
    }               
   if( TerrMembersList.size()>0){
   try{
        update TerrMembersList;
        }catch(Exception Ex){
        LX_CommonUtilities.createExceptionLog(Ex); //Exception log ,Kapil Reddy Sama 6/6/13       
        }
    }
    
    if(trigger.isInsert) {
    	
    	handler_TerritoryMember.checkDefaultTerritoryMemberToUpdateOpps(trigger.new, trigger.newMap, trigger.isUpdate);
    }
    
    if(trigger.isUpdate) {
    	
    	handler_TerritoryMember.checkDefaultTerritoryMemberToUpdateOpps(trigger.new, trigger.oldMap, trigger.isUpdate);
    }
}