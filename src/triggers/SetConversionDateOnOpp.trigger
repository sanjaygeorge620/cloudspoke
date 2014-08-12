trigger SetConversionDateOnOpp on Opportunity (after insert, after update) {

    
    /******************************************************************************

Name     : SetConversionDateOnOpp

Purpose  : set the conversion dates on opportunity if not done through the process of moving from stage to stage

Author   : jennifer dauernheim

Date     : May 17, 2010

******************************************************************************/
       //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  


    List<ID> oppIDSet = new List<ID>();
    //List<RecordType>recordTypeList = new List<RecordType>([select id from RecordType where Name = 'Additional Services']);
  
    for (Opportunity oppRec : Trigger.new){
        If(oppRec.RecordTypeId != '01270000000LyH6'){
            If(trigger.isInsert || (Trigger.IsUpdate && Trigger.new[0].StageName != Trigger.old[0].StageName)) {
                oppIDSet.add(oppRec.ID);
                system.debug('idSet:' + oppIDset);
            }
        }    
    } 
    
    if(oppIDSet.size()>0){
            system.debug('right before updateOppConversionDate');
            if(!test.isRunningTest())
            UpdateOppConversion.updateOppConversionDate(oppIDset);
    }  


}