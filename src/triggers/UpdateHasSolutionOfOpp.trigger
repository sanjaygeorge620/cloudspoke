/* Trigger Name    : UpdateHasSolutionOfOpp 
 * Description   : Trigger on offering object to update the no. of offerings on Opportunity and to update the HAs Solution Checkbox

 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
* Developer                  Date        Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
  * Veenu Trehan              9-20-2013                        Updated the trigger
*/
trigger UpdateHasSolutionOfOpp on Solution_Business_Process__c (after insert, after update,  after delete, after undelete) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    system.debug('####in trigger UpdateHasSolutionOfOpp ');
    //list of opps to update the offering count
    List<Opportunity> oppListToUpdate = new List<Opportunity>();
    // map of opportunity of value
    map<id,Opportunity> oppMap = new map<id,Opportunity>();
    //set of opportunities accessed in the offering records
    Set<Id> oppIds = new Set<Id>();
    List<Opportunity> lstOpp=new List<Opportunity>();
    
    if(trigger.isInsert||trigger.IsUpdate){
        for(Solution_Business_Process__c sol: trigger.new){
            System.debug('Solution Status');
            if(sol.Solution_Status__c == 'Sold' && sol.Opportunity__c != null){
                System.debug('Solution Status'+sol.Solution_Status__c);
                Opportunity opp = new Opportunity (Id= sol.Opportunity__c,Has_Solution__c = True);
                oppMap.put(opp.id,opp);
                //oppListToUpdate.add(opp);
                System.debug('>>>>Opp>>>>'+oppListToUpdate);
                } 
            //Kapil Reddy Sama,6/18/2013 Uncheck the Has Solution check box on the Oppty if either the status or opportunity is changed. 
            if(trigger.isUpdate){         
               if((sol.Solution_Status__c != 'Sold'  && sol.Opportunity__c != null )){  //uncheck the Has Solution if the status is changed         
                    Opportunity opp = new Opportunity (Id = sol.Opportunity__c,Has_Solution__c = false);
                    System.debug('Update Solutions');
                    //oppListToUpdate.add(opp);            
                    oppMap.put(opp.id,opp);
               } 
               
               //if the Oppty is changed ,uncheck the Has Solution on the previous Oppty 
               if(trigger.oldMap.get(sol.id).solution_status__c == 'Sold' && 
                        trigger.oldMap.get(sol.id).opportunity__c != null && trigger.oldMap.get(sol.id).opportunity__c != sol.opportunity__c ){
                        
                    Opportunity opp = new Opportunity (Id = trigger.oldMap.get(sol.id).opportunity__c,Has_Solution__c = false);
                    //oppListToUpdate.add(opp);             
                    oppMap.put(opp.id,opp);               
               }                  
            }
        }
}
        //to add the Opportunity id's to the list
        if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
            for(Solution_Business_Process__c off : trigger.new){
                oppIds.add(off.Opportunity__c);
                system.debug('Opp IDs at insert--->'+oppIds);
            }
        }
        //to add the Opportunity id's to the list
        if(trigger.isUpdate || trigger.isdelete){
            for(Solution_Business_Process__c off : trigger.old){
                oppIds.add(off.Opportunity__c);
                system.debug('Opp IDs at delete--->'+oppIds);
            }
        }
        
       //Query all the opps in the set to get the number of the child records in the related list
        lstOpp = [Select id,No_of_Offering__c, (Select id, name from Solutions_Business_Process__r) from Opportunity where Id in:oppIds];
        System.debug('List of Opps'+lstOpp);
        //Updates the No of Offering field on Oppotunity
        if(lstOpp.size()>0){
            system.debug('#####size of list 1'+lstOpp.size());
            for(Opportunity Opp: lstOpp){
                 if(oppMap.containsKey(Opp.id)){
                     Opportunity op = oppMap.get(Opp.id);
                     op.No_of_Offering__c = opp.Solutions_Business_Process__r.size();
                     oppMap.put(op.id,op);
                    }else{
                         Opportunity op = new Opportunity(id = Opp.id);
                         op.No_of_Offering__c = opp.Solutions_Business_Process__r.size();
                         oppMap.put(op.id,op);
                    }
                  
                 //opp.No_of_Offering__c = opp.Solutions_Business_Process__r.size();
                 }    
                //update lstOpp;
                 update oppMap.values();
        }
    //update the opportunity records
       
}