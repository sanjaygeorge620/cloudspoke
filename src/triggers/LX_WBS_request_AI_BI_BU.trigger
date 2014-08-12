/*
Class Name : LX_WBS_request_AI_BI_BU
Description : Trigger to create automated cases on WBS record creation.
Created By : Maruthi Kolla (makolla@lexmark.com)
Created Date : 13-12-2013
Modification Log:
-------------------------------------------------------------------------
Developer Date Modification ID Description
-------------------------------------------------------------------------
Maruthi Kolla 13-12-2013 1000 Initial Version
*************************************************************************/

trigger LX_WBS_request_AI_BI_BU on WBS_Request__c (after insert,before insert, before update){

//Added ByPass Logic on 12/23/2013
if(LX_CommonUtilities.ByPassBusinessRule()) return;
 
Set<ID> wbs_projectIDs = new Set<ID>();
Map<ID,ID> map_OPP_Proj = new Map<ID,ID>();
Set<ID> proj_oppIDS = new Set<ID>();
MAP<ID,Set<String>> map_oppID_Companycode = new MAp<ID,Set<String>>();
Set<ID> wbs_company_codes = new Set<ID>();
Map<ID,Company_Code__c> map_company_codes ;
Set<ID> id_set = new Set<ID>();
//Variable added for defect 1717:
MAP<ID,Set<String>> map_ProjID_Companycode = new MAp<ID,Set<String>>();


if(Trigger.isafter && Trigger.isinsert)
{
    //Collecting the WBS request ids and calling method to create cases.
    For(WBS_Request__c req: Trigger.new)
    id_set.add(req.id);
    LX_CaseRequests.create_wbs_cases(id_set);
}


if(Trigger.isbefore)
{
    //Collecting the related company codes and projects for WBS requests
    for(WBS_Request__c wbs_requests : Trigger.new)
    {
    wbs_projectIDs.add(wbs_requests.LX_Project__c);
    if(Trigger.isinsert)
    wbs_company_codes.add(wbs_requests.LX_Company_code__c);
    }   
    
    // Querying for Pse_projects with project list on WBS requests.
    List<pse__Proj__c> project_records = [Select pse__Opportunity__c from pse__Proj__c where id in :wbs_projectIDs];

    //Building a map of project and opportunity ids.
    for(pse__Proj__c pse_proj: project_records)
    {
    proj_oppIDS.add(pse_proj.pse__Opportunity__c);
    map_OPP_Proj.put(pse_proj.id,pse_proj.pse__Opportunity__c);
    }

    if(Trigger.isinsert)
    {
    //Querying for company codes and WBS elements
    map_company_codes = new Map<ID,Company_Code__c>([Select Company_Code_Value__c from Company_Code__c where id in :wbs_company_codes]);
    List<WBS_Element_Project__c> wbs_elements = [Select LX_Company_Code_value__c,Opportunity__c from WBS_Element_Project__c where Opportunity__c in :proj_oppIDS];

    // Added for defect 1717: Querying existing WBS requests on the projects.
    List<WBS_Request__c> lst_wbs_requests = [Select LX_Project__c,LX_Company_code__c from WBS_Request__c where LX_Project__c in : wbs_projectIDs]; //Added for defect 1717
    
    //Logic to Build a map of project ids and associated company codes from WBS requests.
        For(WBS_Request__c wbs_request_records : lst_wbs_requests)
            {
            Set<String> temp_Company_codes ;
            if(map_ProjID_Companycode.containskey(wbs_request_records.LX_Project__c))
            {
            temp_Company_codes =map_ProjID_Companycode.get(wbs_request_records.LX_Project__c) ;
            temp_Company_codes.add(wbs_request_records.LX_Company_code__c);
            }
            else
            {
            temp_Company_codes= new Set<String>();
            temp_Company_codes.add(wbs_request_records.LX_Company_code__c);
            }
            map_ProjID_Companycode.put(wbs_request_records.LX_Project__c,temp_Company_codes);
        }
        
        
        //Logic to Build a map of opportunity id and set of <WBS Element company codes>.
        For(WBS_Element_Project__c wbs_element_records : wbs_elements)
        {
        Set<String> temp_Company_code ;
        if(map_oppID_Companycode.containskey(wbs_element_records.Opportunity__c))
        {
        temp_Company_code =map_oppID_Companycode.get(wbs_element_records.Opportunity__c) ;
        temp_Company_code.add(wbs_element_records.LX_Company_Code_value__c);
        }
        else
        {
        temp_Company_code= new Set<String>();
        temp_Company_code.add(wbs_element_records.LX_Company_Code_value__c);
        }
        map_oppID_Companycode.put(wbs_element_records.Opportunity__c,temp_Company_code);
        }
    }


    for(WBS_Request__c wbs_requests : Trigger.new)
    {
    Boolean temp_flag = false;
    //Populating the WBS Request opportunity with associated project opportunity.
    if(Trigger.isInsert || Trigger.isUpdate)
    wbs_requests.LX_Opportunity__c = map_OPP_Proj.get(wbs_requests.LX_Project__c);

        //Logic to populate an error message to prevent creating multiple WBS requests on Projects.
        if(Trigger.isinsert)
        {
            if(map_company_codes.containskey(wbs_requests.LX_Company_code__c))
            {
                String comp_value = map_company_codes.get(wbs_requests.LX_Company_code__c).Company_Code_Value__c;
                if(map_oppID_Companycode.get(map_OPP_Proj.get(wbs_requests.LX_Project__c))!=null){
                    if(map_oppID_Companycode.get(map_OPP_Proj.get(wbs_requests.LX_Project__c)).contains(comp_value))
                    temp_flag = true;
                }
                
                // Added for Defect 1717: Preventing multiple WBS requests with the same company code on the project.
                if(map_ProjID_Companycode.containskey(wbs_requests.LX_Project__c)){
                    if(map_ProjID_Companycode.get(wbs_requests.LX_Project__c).contains(wbs_requests.LX_Company_code__c))
                    temp_flag = true;
                }
            }           
            
            // Populating an error message
            if(temp_flag)
            wbs_requests.addError('There is already a WBS record or request made that matches your criteria  please cancel and use the existing record or wait for the record to be created.');
        }
    }
}

}