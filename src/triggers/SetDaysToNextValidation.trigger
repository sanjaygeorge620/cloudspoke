trigger SetDaysToNextValidation on List__c (before insert) {

  if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code

    //fetch the days from perceptive config value X   
    Perceptive_Config_Value__c[] x = [SELECT Value__c FROM Perceptive_Config_Value__c where name = 'X'];
    
    string days;
    if(x!=null && x.size() > 0)
       days=x[0].Value__c;
       
    
    //for each List Record set the days
    for(List__c lo:Trigger.New){        
        if(days != null)
            lo.Days_to_Next_Validation__c=integer.valueOf(days);
    }

}