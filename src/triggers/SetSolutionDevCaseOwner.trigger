/******************************************************************************

Name     : SetSolutionDevCaseOwner

Purpose  : Set the caseowner based on status and specific field on case

Author   : jennifer dauernheim

Date     : January 12, 2010

******************************************************************************/


trigger SetSolutionDevCaseOwner on Case (after update, after insert) {
        
//Loop through triggers
//for each trigger check record type
//get recordtypeID for solution development record type
//RecordType SolutionDevRecordTypeID = [select Id from RecordType where name = 'Solution Development' and sobjectType = 'Case' Limit 1];


    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
    
Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
Id recordTypeId = rtMapByName.get('Solution Development').getRecordTypeId();

list<ID> caseidSet = new list<ID>();

//for each trigger that is solution dev record type, check status
//for matching status, set case owner to appropriate field
    for (case caseRec : Trigger.new){
        
         system.debug('Record Type ID = ' + caseRec.RecordTypeID);
         system.debug('solutionDevRecordtype = ' + recordTypeId);
//for loop of the triggers and [i]
 
           if (caseRec.RecordTypeID == recordTypeId){
             
               if (Trigger.isInsert || (Trigger.IsUpdate && Trigger.new[0].Status != Trigger.old[0].Status) ){
                 caseidSet.add(caseRec.id);
                 system.debug('within if');
                 //call assignSolutionOwnerName
                
                     system.debug('right before assign solution owner');
                     AssignSolutionOwner.AssignSolutionOwnerName(caseidSet);
            
             }
         }
    }   

}