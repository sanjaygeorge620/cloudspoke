trigger UpdateTimeCardsTrg on WBS_Element_Project__c (after insert, after update) {

    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    
    Set<Id> stWPIds = new Set<Id>();
    Set<Id> stProjIds= new Set<Id>();
    List<pse__timecard_header__c> lstCardsToUpdate = new List<pse__timecard_header__c>();
    
    for(WBS_Element_Project__c  wep : trigger.new){
        stWPIds.add(wep.Id);
        stProjIds.add(wep.Project__c);
    }
 // Shubhashish - 24 January - Changed the order of for loop and the query for getting the mpTimes   
    Map<Id, pse__timecard_header__c> mpTimes = new Map<Id, pse__timecard_header__c>([select id,pse__Project__c,SAP_Eligible__c,pse__Project_Methodology__c,Company_Number__c from pse__timecard_header__c where WBS_Element_Id__c = null and pse__Project__c in:stProjIds]);
    
    Map<Id, WBS_Element_Project__c> mpWEP = new Map<Id, WBS_Element_Project__c>([select id,Project__c ,WBS_Element__r.name,WBS_Element__r.Company_Code__c,WBS_Element__c from WBS_Element_Project__c where Id in: stWPIds]);
    
    for(WBS_Element_Project__c wep: mpWEP.values()){ 
        for(pse__timecard_header__c ph : mpTimes.values()){
            if(ph.pse__Project__c == wep.Project__c && ph.SAP_Eligible__c == 'true'){
                if(wep.WBS_Element__r.name.startsWith('B') && (ph.pse__Project_Methodology__c == 'Billable Hourly' || ph.pse__Project_Methodology__c == 'Fixed Price Hours')){
                    if(ph.Company_Number__c == wep.WBS_Element__r.Company_Code__c){
                        ph.WBS_Element_Id__c = wep.WBS_Element__c;
                        lstCardsToUpdate.add(ph);
                    }
                }
                else if (wep.WBS_Element__r.name.startsWith('P') && (ph.pse__Project_Methodology__c == 'MPS')){
                    if(ph.Company_Number__c == wep.WBS_Element__r.Company_Code__c){
                        ph.WBS_Element_Id__c = wep.WBS_Element__c;
                        lstCardsToUpdate.add(ph);
                    }               
                }
                
            }
        }

    }
    
    if(lstCardsToUpdate.size()>0)
    update lstCardsToUpdate;
    
    
}