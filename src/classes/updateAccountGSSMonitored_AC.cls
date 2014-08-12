public without sharing class updateAccountGSSMonitored_AC
{
    public static void updateGSSMonitored(List<Account> lstNew, Map<Id, Account> lstOld)
    {
        Map<Id,Integer> mapCountEnrollement = new Map<Id,Integer>();
        mapCountEnrollement = countEnrollment(lstNew);
        for(Account acc : lstNew)
        {
            if(acc.Party_Role__c == 'Alliance Partner/OEM' && acc.Account_Status__c == 'Active' && (acc.Party_Role__c != lstOld.get(acc.id).Party_Role__c || acc.Account_Status__c != lstOld.get(acc.id).Account_Status__c) && mapcountEnrollement.containsKey(acc.Id))
            {
                acc.GSS_Monitored__c = 'Level 2';   
            }    
        }  
    }
    
    public static Map<Id,Integer> countEnrollment(List<Account> lstAccount)
    {
        Map<Id, Integer> mapCount = new Map<Id, Integer>();
        List<LX_Program_Enrollment__c> lstEnrollment = new List<LX_Program_Enrollment__c>([Select id, LX_Account__c, LX_Enrollment_Status__c 
                                                                                           from LX_Program_Enrollment__c 
                                                                                           where LX_Enrollment_Status__c = 'Active' 
                                                                                           and LX_Account__c in :lstAccount]);
        for (LX_Program_Enrollment__c es : lstEnrollment)
        {
            if(mapCount.get(es.LX_Account__c) == null)
            {
                mapCount.put(es.LX_Account__c,1);
            }
            else
            {
                mapCount.put(es.LX_Account__c, mapCount.get(es.LX_Account__c)+1);
            }
        }                                                                                   
        return mapCount;
    }
}