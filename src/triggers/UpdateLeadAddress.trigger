trigger UpdateLeadAddress on Lead (before insert, before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update

    List<Lead>accountList = new List<Lead>();
    string convertedLeadState;
    set<String> conSet = new set<String>();
    Map<Id,Perceptive_Config_Value__c> configMap;
    Map<String,String> valueMap;
    set<String> stateSet = new set<String>();
    Map<Id,Perceptive_Config_Value__c> stateMap;
    Map<String,String> valueStateMap;
        
    for(Lead lr: Trigger.New){
        if(lr.Country != '' & lr.Country != null){
            system.debug('*****************new lead country'+lr.Country);
            conSet.add(lr.Country);
         }
        if(lr.State != '' & lr.State != null){
            if(lr.State.length() == 2){
                stateSet.add(lr.State);
             }   
         }                         
    }
    system.debug('*****************new conset size'+conset.size());
    if(conSet.size()>0){
        configMap =  new Map<Id,Perceptive_Config_Value__c>([select Id,Name,Value__c from Perceptive_Config_Value__c 
                                                        where Perceptive_Config_Value__c.Perceptive_Config_Option__r.Name = 'Countries' and Name in :conSet]);
        valueMap = new Map<String,String>();                                                
        
        for(Perceptive_Config_Value__c pc:configMap.values()){
            system.debug('*****************new pc name'+pc.name);
            system.debug('*****************new pc value'+pc.Value__c);
            valueMap.put(pc.Name,pc.Value__c);        
        }
        system.debug('*****************valueMap size'+valueMap.size());  
    }
    
    if(stateset.size()>0){
        stateMap = new Map<Id,Perceptive_Config_Value__c>([select Id,Name,Value__c from Perceptive_Config_Value__c where Perceptive_Config_Value__c.Perceptive_Config_Option__r.Name = 'States' 
                                                            and Name in :stateSet]);    
        valueStateMap = new Map<String,String>();                                                
        
        for(Perceptive_Config_Value__c pc1:stateMap.values()){
            valueStateMap.put(pc1.Name,pc1.Value__c);        
        }
    } 
     
     for (Lead  LeadRec : Trigger.new){
                
                LeadRec.ISR_Map_Acct__c = LeadRec.ISR_LEAD__c; //Added by Manoj for ISR Mapping to Account  
 
                if((LeadRec.Street != '' & LeadRec.Street != null)& LeadRec.Street != LeadRec.Physical_Street_Address__c){
                    LeadRec.Physical_Street_Address__c = LeadRec.Street;
                } 

                if((LeadRec.City != null  & LeadRec.City != '') & LeadRec.City != LeadRec.Physical_City__c){
                    LeadRec.Physical_City__c = LeadRec.City;
                } 
                
                //The below code is to handle the US1118 ans US944 by Manoj Kolli on 3/2/2012
                    //if((LeadRec.Country != '' & LeadRec.Country != null) & LeadRec.Country != LeadRec.Physical_Country__c){
                    if((LeadRec.Physical_Country__c != '' & LeadRec.Physical_Country__c != null) & LeadRec.Country != LeadRec.Physical_Country__c){ 
                    System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Physical_Country__c);
                    System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Country); 
                       // if(valueMap.containsKey(LeadRec.Country)){
                           // LeadRec.Physical_Country__c = valueMap.get(LeadRec.Country);
                            System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Physical_Country__c);
                            System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Country);
                         //}
                       // else{
                           // LeadRec.Physical_Country__c = LeadRec.Country;
                            LeadRec.Country = LeadRec.Physical_Country__c;
                            System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Physical_Country__c);
                            System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Country);
                        // }    
                      }
                    /*else{
                            LeadRec.Physical_Country__c = LeadRec.Country;
                            System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Physical_Country__c);
                            System.debug('********LeadRec.Physical_Country__c******'+LeadRec.Country);
                        } */
                
                 
                if(LeadRec.State != '' & LeadRec.State != null) {
                    system.debug('LeadRec.Country:' + LeadRec.Country);
                    system.debug('LeadRec.International_State_Province__c:'+LeadRec.International_State_Province__c);
                    system.debug('LeadRec.State:'+LeadRec.State);                                                  
                    
                    If((LeadRec.Physical_Country__c != 'United States'  & (LeadRec.Physical_Country__c != 'USA' & LeadRec.Physical_Country__c != 'US')) ){               
                        If(LeadRec.International_State_Province__c != LeadRec.State){
                            LeadRec.International_State_Province__c = LeadRec.State;
                        }    
                    }else {
                        system.debug('LeadRec.State.length(): ' + LeadRec.State.length());
                        /*if(LeadRec.State.length() == 2){
                            convertedLeadState = [select Value__c 
                                                        from Perceptive_Config_Value__c 
                                                        where Perceptive_Config_Value__c.Perceptive_Config_Option__r.Name = 'States' 
                                                        and Name = :leadRec.State].Value__c;
                            system.debug(convertedLeadState);
                        }else{
                            convertedLeadState = LeadRec.State;
                        }                           
                        if(convertedLeadState != LeadRec.Physical_State__c ){
                            LeadRec.Physical_State__c = convertedLeadState;
                        }*/
                        
                        if(LeadRec.State.length() == 2 ){
                            if(valueStateMap.containsKey(LeadRec.State)){
                                convertedLeadState = valueStateMap.get(LeadRec.State);
                                system.debug(convertedLeadState);
                            }
                            else{
                                convertedLeadState = LeadRec.State;
                            }
                        }
                        else{
                            convertedLeadState = LeadRec.State;
                        } 
                                                  
                        if(convertedLeadState != LeadRec.Physical_State__c ){
                            LeadRec.Physical_State__c = convertedLeadState;
                        }
                    }
                } 
 
                if((LeadRec.PostalCode != '' & LeadRec.PostalCode != Null) & LeadRec.PostalCode != LeadRec.Physical_Postal_Code__c){
                    LeadRec.Physical_Postal_Code__c = LeadRec.PostalCode;
                }
 
                /*Commented based upon the US944
                if((LeadRec.Country != '' & LeadRec.Country != null) & LeadRec.Country != LeadRec.Physical_Country__c){
                    LeadRec.Physical_Country__c = LeadRec.Country;
                }*/ 
                
                system.debug('LeadRec: ' + LeadRec);             
     }
}