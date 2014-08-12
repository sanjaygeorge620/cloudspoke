trigger LX_WBSElement on WBS_Element__c (Before insert , before update) {

    Map<id,string> MapCompanyCode = new map<id,string>();
    Map<string,string> MapCode_Companydesc = new map<string,string>();
    List<Company_Code__c> CompanyCodeList;
    for(WBS_Element__c  wbs: Trigger.new){
        if((Trigger.Isupdate&&Trigger.oldmap.get(wbs.id).Company_Code__c!=wbs.Company_Code__c)||(Trigger.isInsert&&wbs.Company_Code__c!=null)){
           MapCompanyCode.put(wbs.id,wbs.Company_Code__c); 
        }
    }
    if(MapCompanyCode.size()>0){
        CompanyCodeList =[select Company_Code_Description__c, Company_Code_Value__c from Company_Code__c where Company_Code_Value__c in:MapCompanyCode.values()];
        for(Company_Code__c C_code: CompanyCodeList ){
            MapCode_Companydesc .put(C_code.Company_Code_Value__c ,C_code.Company_Code_Description__c );
        }
        if(MapCode_Companydesc.size()>0){
            for(WBS_Element__c  wbs: Trigger.new){
                 if(MapCompanyCode.containskey(wbs.id)&&MapCode_Companydesc.containskey(MapCompanyCode.get(wbs.id))){
                     wbs.Company_Code_Name__c = MapCode_Companydesc.get(MapCompanyCode.get(wbs.id));
                 }
            }
        }
    }
    
}