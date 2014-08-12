public class LX_PseProjUtilityClass {

    public static Map<Id,Set<ID>> getWBSElements( set<id> setOpps)
    {
        //Create a Map to store Opps and related WBS records
        Map<Id,set<ID>> mapOppWBS = new Map<Id,Set<ID>>();
        List<WBS_Element__c> lstWBSElements = new List<WBS_Element__c>();
        
        //Check whether the selected opportunity has already defined wbs element records.
        system.debug(setOpps);
                
        for(WBS_Element_Project__c  WbsPrj: [SELECT WBS_Element__c ,Opportunity__c FROM WBS_Element_Project__c  where WBS_Element__r.Active__c =true AND WBS_Element__r.WBS_Type__c= 'Costing' AND Opportunity__c in:setOpps]){     
        Set<ID> wbs_elements_ids = new Set<ID>();
            if(mapOppWBS.containskey(WbsPrj.Opportunity__c )){           
               wbs_elements_ids = mapOppWBS.get(WbsPrj.Opportunity__c);
               wbs_elements_ids.add(WbsPrj.WBS_Element__c);               
               mapOppWBS.put(WbsPrj.Opportunity__c ,wbs_elements_ids);
            }
            else{
            wbs_elements_ids.add(WbsPrj.WBS_Element__c);
                mapOppWBS.put(WbsPrj.Opportunity__c ,wbs_elements_ids);
            }
                        
        
        }
                    
        //return map 
        return mapOppWBS;
    
    }
    
    public static boolean createWBSProject(List<pse__Proj__c> triggernew){
    
        set<id> Oppids = new set<id>();
        List<WBS_Element_Project__c> ListWBS = new List<WBS_Element_Project__c>();
        WBS_Element_Project__c TempWBSPrj;
        for(pse__Proj__c prj: Triggernew){
         if((prj.recordtypeid == LX_SetRecordIDs.ProjectISSImplRecordTypeId) || (prj.recordtypeid == LX_SetRecordIDs.ProjectProfServicesRecordTypeId))
            {
            Oppids.add(prj.pse__Opportunity__c);
            }
        }
        Map<Id,Set<ID>> Map_opp_WBSList = getWBSElements(Oppids);
    
        for(pse__Proj__c prj: Triggernew){
          if((prj.recordtypeid == LX_SetRecordIDs.ProjectISSImplRecordTypeId) || (prj.recordtypeid == LX_SetRecordIDs.ProjectProfServicesRecordTypeId))
            {
            if(Map_opp_WBSList.containskey(prj.pse__Opportunity__c)){
                for(id idval: Map_opp_WBSList.get(prj.pse__Opportunity__c)){
                    TempWBSPrj = new WBS_Element_Project__c (WBS_Element__c = idval, Project__c= prj.id, Opportunity__c =prj.pse__Opportunity__c );
                    ListWBS.add(TempWBSPrj );
                }
            }
           }
        }
        try{
            insert ListWBS;
            
        }
        catch(DMLException e){
            return false;
        }
        return true;
    }

}