trigger UpdateAccountAddress on Account (before insert, before update) {
    /*
     List<Account>accountList = new List<Account>();
    string convertedAcctState;
    Map<String, String> convertedAcctStateMap = new Map<String, String>();
     for (Account  acctRec : Trigger.new){
        system.debug('acctRec.type: ' + acctRec.Type);
        if (acctRec.Type == 'Suspect'){
            accountList.add(acctRec);
         }   
     }
     system.debug('accountList.size(): ' + accountList.size());
     if(accountList.size()>0 ){
        //create map of states
        List<Perceptive_Config_Value__c> convertedAcctStateList = [select Name, Value__c 
                                                        from Perceptive_Config_Value__c 
                                                        where Perceptive_Config_Value__c.Perceptive_Config_Option__r.Name = 'States'] ;
        system.debug(convertedAcctStateList);
        
        if(convertedAcctStateList.size() > 0){
            for(Perceptive_Config_Value__c ValueRec : convertedAcctStateList){
                convertedAcctStateMap.put(ValueRec.Name, ValueRec.Value__c);
            }
        }

     for (Account acctRec : accountList) {
                //if Billing Street <> "" & Billing Street <> physical address, Update physical Address = billing Street 
                if(acctRec.BillingStreet != null & acctRec.BillingStreet != acctRec.Physical_Street_Address__c){
                    acctRec.Physical_Street_Address__c = acctRec.BillingStreet;
                } 
                //if Billing city <> "" & Billing City <> physical city, Update physical city = billing City 
                if(acctRec.BillingCity != null & acctRec.BillingCity != acctRec.Physical_City__c){
                    acctRec.Physical_City__c = acctRec.BillingCity;
                } 
                if(acctRec.BillingState != '' & acctRec.BillingState != null) {
                    If((acctRec.BillingCountry != 'United States' & (acctRec.BillingCountry != 'USA' & acctRec.BillingCountry != 'US') )& acctRec.Physical_Province_Other__c != acctRec.BillingState ){             
                        acctRec.Physical_Province_Other__c = acctRec.BillingState;
                    }else {
                        system.debug('acctRec.BillingState.length(): ' + acctRec.BillingState.length());
                        if(acctRec.BillingState.length() == 2){
                        //  convertedAcctState = [select Value__c from Perceptive_Config_Value__c where Perceptive_Config_Value__c.Perceptive_Config_Option__r.Name = 'States' and Name = :acctRec.BillingState].Value__c; 
                            try{
                                If(convertedAcctStateMap.containsKey(acctRec.BillingState)){
                                    convertedAcctState = convertedAcctStateMap.get(acctRec.BillingState);
                                    system.debug('converted account state' + convertedAcctState);
                                    system.debug('converted account state' + convertedAcctState);
                                }Else {
                                    ErrorLogUtility.createErrorRecord('ConvertedAcctStateMap not include Billing State','UpdateAccountAddress','Low',acctRec.BillingState);
                                }                               
                            }catch (Exception e){
                                system.debug('in exception');
                                ErrorLogUtility.createErrorRecord(e.getMessage(),'UpdateAccountAddress','Low',acctRec.BillingState);
                            }                       
                            
                        }else{
                            convertedAcctState = acctRec.BillingState;
                        }                           
                        if(convertedAcctState != acctRec.Physical_State__c ){
                            acctRec.Physical_State__c = convertedAcctState;
                        }
                    }
                } 
                
                
                
                //if Billing postal code <> "" & Billing postal code <> physical postal code, Update physical postal code = billing postal code 
                if(acctRec.BillingPostalCode != null & acctRec.BillingPostalCode != acctRec.Physical_Postal_Code__c){
                    acctRec.Physical_Postal_Code__c = acctRec.BillingPostalCode;
                }
                //if Billing country <> "" & Billing postal code <> physical postal code, Update physical postal code = billing postal code 
                if(acctrec.BillingCountry != null  & acctrec.BillingCountry != acctRec.Physical_Country__c){
                    acctRec.Physical_Country__c = acctrec.BillingCountry;
                } 
                system.debug('acctrec: ' + acctRec);        
            }
     }

    */
}