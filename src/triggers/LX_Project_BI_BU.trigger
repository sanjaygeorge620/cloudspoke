trigger LX_Project_BI_BU on pse__Proj__c (After Insert) {

/*
    set<id> Oppids = new set<id>();
    List<WBS_Element_Project__c> ListWBS = new List<WBS_Element_Project__c>();
    WBS_Element_Project__c TempWBSPrj;
    for(pse__Proj__c prj: Trigger.new){
    if(prj.recordtypeid == LX_SetRecordIDs.ProjectISSImplRecordTypeId)
        Oppids.add(prj.pse__Opportunity__c);
    }
    Map<Id,List<ID>> Map_opp_WBSList = LX_PseProjUtilityClass.getWBSElements(Oppids );
    
    
    for(pse__Proj__c prj: Trigger.new){
    System.debug('***************'+Prj.id);
        if(Map_opp_WBSList.containskey(prj.pse__Opportunity__c)){
            for(id idval: Map_opp_WBSList.get(prj.pse__Opportunity__c)){
                TempWBSPrj = new WBS_Element_Project__c (WBS_Element__c = idval, Project__c= prj.id, Opportunity__c =prj.pse__Opportunity__c );
                ListWBS.add(TempWBSPrj );
            }
        }
    }
    insert ListWBS;*/
}