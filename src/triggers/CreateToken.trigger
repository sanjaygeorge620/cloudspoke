trigger CreateToken on Opportunity (after update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
/*  When opportunity  QA Status is set to complete,
        get all opportunity Line items that have category = "Training"& processed flag is null
*/

        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 

     List<String> TokenTypeList = new List<String>();   
     Set<ID> oppIdSet = new Set<ID>();
     //get listing of all opportunities that have Complete status
     for (Opportunity  OppRec : Trigger.new){
                    
          if ( (OppRec.SAP_Status__c == 'SUBMITTED' || OppRec.SAP_Status__c == 'OVERRIDE') 
                && System.Trigger.oldMap.get(OppRec.Id).SAP_Status__c != 'SUBMITTED'
                && System.Trigger.oldMap.get(OppRec.Id).SAP_Status__c != 'OVERRIDE') {


                oppIdSet.add(oppRec.id);
                system.debug('oppIdSet:' + oppIdSet);
            
         }   
     }
     system.debug('FirstRun Training Token: ' + FirstRun_CreateToken_Training.FirstRun);
     if (FirstRun_CreateToken_Training.FirstRun && OppIdset.size()> 0){   
        FirstRun_CreateToken_Training.FirstRun = False;  
        List<Perceptive_Config_Value__c> ValueList = new List<Perceptive_Config_Value__c>([select Value__c 
                                                                                           from Perceptive_Config_Value__c
                                                                                           where Name = 'TokenType']);
        system.debug('valueList.size(): ' + valueList.size());
        If(valueList.size()>0){
            For(Perceptive_Config_Value__c ValueListRec : ValueList){
                TokenTypeList.add(ValueListRec.Value__c);
            }
            if(!test.isRunningTest())
            ProcessToken.ProcessToken(oppIdSet,TokenTypeList );   
        } 
     }
    
}