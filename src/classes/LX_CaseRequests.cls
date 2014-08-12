/*
Class Name : LX_CaseRequests 
Description : Class to create cases when SAP project request and WBS requests are created
Created By : MAruthi Kolla (makolla@deloitte.com)
Created Date : 13-12-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Maruthi Kolla       13-12-2013        1000                   Initial Version
*************************************************************************/


Public Class LX_CaseRequests {

 /*
     * Description : Method to call a method to create the Cases for WBS requests.
     * Param - : WBS request IDs
     * Returns : null
    */
Public Static void create_WBS_cases(Set<ID> id_list)
{
    // Building a map of WBS request records
    Map<ID,WBS_Request__c> wbs_objs = new Map<ID,WBS_Request__c>([Select id,name,LX_Account_Name__c,LX_Sold_To__c,LX_Company_code__r.Company_Code_Value__c,LX_Company_code_description__c,LX_Company_code__r.name,LX_Opportunity__r.name, LX_Opportunity__r.Opportunity_Number__c, LX_Investment_Time__c,LX_Project__r.name from WBS_Request__c where id in :id_list]);
    for (ID wbs_req : wbs_objs.keyset())
    {
        create_WBS_case(wbs_objs.get(wbs_req));
    }
}

 /*
     * Description : Method to call a method to create the Cases for SAP project requests.
     * Param - : SAP Project request IDs
     * Returns : null
    */
Public Static void create_SAP_cases(Set<ID> id_list)
{
    list<case> caseList = new list<case>();
    // Building a map of SAP Project request records
    Map<ID,SAP_Project_Request__c> sap_objs = new Map<ID,SAP_Project_Request__c>([Select id,name,Request_Type__c,Opportunity__r.Account.name,Opportunity__r.Opportunity_Number__c, Company_code__r.name,Company_code__r.Company_Code_Value__c,Company_code__r.Company_Code_Description__c,Opportunity__r.name,Sold_To_s__r.name, Sold_To_s__r.LX_SAP_Sold_To_ID__c, Division__c, Project_Class__c,Opportunity__r.LX_Sold_To_New__r.LX_Sales_Org1__c,Opportunity__r.LX_Sold_To_New__r.Sales_Org_Name__c from SAP_Project_Request__c where id in :id_list]);
    for (ID sap_req : sap_objs.keyset())
    {
        caseList.add(create_sap_case(sap_objs.get(sap_req)));
    }
    System.database.insert(caseList);
}

 /*
     * Description : Method to create the Case for WBS request.
     * Param - : WBS request records
     * Returns : null
    */
static void create_WBS_case(WBS_Request__c wbs_obj)
{
     Case cs = new case();
     String requestDetail;
     
     //Building the case 'Request' field with WBS request detials
     requestDetail = '<h3 align ="center">'+LX_PSEHelperClass.Case_WBS_request_subject +'</h3>';
     requestDetail = requestDetail + '<h4> Request Details </h4>' ;
     requestDetail = requestDetail + '<table border ="1"><tr><td> Account Name </td><td>' + wbs_obj.LX_Account_Name__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Opportunity Name </td><td>' + wbs_obj.LX_Opportunity__r.name +'</td></tr>'; 
     requestDetail = requestDetail + '<tr><td> Opportunity Number </td><td>' + wbs_obj.LX_Opportunity__r.Opportunity_Number__c +'</td></tr>'; 
     requestDetail = requestDetail + '<tr><td> Sold To </td><td>' + wbs_obj.LX_Sold_To__c +'</td></tr>';
//     requestDetail = requestDetail + '<tr><td> Company Code </td><td>' + wbs_obj.LX_Company_code__r.name +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Company Code </td><td>' + wbs_obj.LX_Company_code__r.Company_Code_Value__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Company Code Description </td><td>' + wbs_obj.LX_Company_code_description__c +'</td></tr>'; 
//     requestDetail = requestDetail + '<tr><td> Company Code Description </td><td>' + wbs_obj.LX_Company_code_description__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Project </td><td>' + wbs_obj.LX_Project__r.name +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Investment Time </td><td>' + wbs_obj.LX_Investment_Time__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> WBS request </td><td>' + wbs_obj.name +'</td></tr></table>';
     requestDetail = requestDetail + '</br>Below is the link to access the WBS Request record:</br>';
     requestDetail = requestDetail + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+wbs_obj.id+'">Click Here</a>';
     Database.DMLOptions dmo = new Database.DMLOptions();
     dmo.assignmentRuleHeader.assignmentRuleId= ID.valueof(Label.LX_Assignment_Rule_ID);
     dmo.EmailHeader.TriggerUserEmail = true;
     
     //Populating the case with some required values
     cs.RecordTypeId= Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(LX_PSEHelperClass.CaseSAPProjRecordType).getRecordTypeId();
     //cs.ownerid= Id.valueOf(Label.LX_SAP_Project_WBS_Request);
     //cs.ownerid ='005i0000000ZKWl';
     cs.type = LX_PSEHelperClass.Case_type;
     cs.status= 'Open-Working';
     //cs.impact__c = LX_PSEHelperClass.Case_impact ;
     //cs.Urgency__c = LX_PSEHelperClass.Case_urgency;
     cs.Origin = LX_PSEHelperClass.Case_WBS_origin; 
     cs.Request__c=requestDetail ;
     cs.subject = LX_PSEHelperClass.Case_WBS_request_subject;
     cs.WBS_Request__c=wbs_obj.id;
     cs.setOptions(dmo);
     insert cs;
}

 /*
     * Description : Methods to create the Case for SAP project request.
     * Param - : SAP Project request records
     * Returns : case
    */
Public Static case create_sap_case(SAP_Project_Request__c sap_obj)
{
     Case cs = new case();
     String requestDetail;
     
     //Building the case 'Request' field with SAP Project request detials
     requestDetail = '<h3 align ="center">'+LX_PSEHelperClass.Case_sap_project_subject +'</h3>';
     requestDetail = requestDetail + '<h4> Request Details </h4>' ;
     requestDetail = requestDetail + '<table border ="1"><tr><td> Account Name </td><td>' + sap_obj.Opportunity__r.Account.name +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Opportunity Name </td><td>' + sap_obj.Opportunity__r.name +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Opportunity Number </td><td>' + sap_obj.Opportunity__r.Opportunity_Number__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Project Company Code </td><td>' + sap_obj.Opportunity__r.LX_Sold_To_New__r.LX_Sales_Org1__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Project Company Description </td><td>' + sap_obj.Opportunity__r.LX_Sold_To_New__r.Sales_Org_Name__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> SAP project request </td><td>' + sap_obj.name +'</td></tr>';
     //requestDetail = requestDetail + '<tr><td> Project Name </td><td>' + sap_obj.project__r.name +'</td></tr>';  //Opportunity__r.Opportunity_Number__c
     requestDetail = requestDetail + '<tr><td> Sold To </td><td>' + sap_obj.Sold_To_s__r.LX_SAP_Sold_To_ID__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Division </td><td>' + sap_obj.Division__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Project Class </td><td>' + sap_obj.Project_Class__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Request Type </td><td>' + sap_obj.Request_Type__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Company Code </td><td>' + sap_obj.Company_code__r.Company_Code_Value__c +'</td></tr>';
     requestDetail = requestDetail + '<tr><td> Company Description </td><td>' + sap_obj.Company_code__r.Company_Code_Description__c +'</td></tr></table>';
      requestDetail = requestDetail + '</br>Below is the link to access the WBS Request record:</br>';
     requestDetail = requestDetail + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+sap_obj.id+'">Click Here</a>';
     
     Database.DMLOptions dmo = new Database.DMLOptions();
     dmo.assignmentRuleHeader.assignmentRuleId= ID.valueof(Label.LX_Assignment_Rule_ID);
     dmo.EmailHeader.TriggerUserEmail = true;
     
     //Populating the case with some required values
     cs.RecordTypeId= Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(LX_PSEHelperClass.CaseSAPProjRecordType).getRecordTypeId();
     //cs.ownerid= Id.valueOf(Label.LX_SAP_Project_WBS_Request);
     //cs.ownerid ='005i0000000ZKWl';
     cs.type = LX_PSEHelperClass.Case_type;
     cs.status= 'Open-Working';
     //cs.impact__c = LX_PSEHelperClass.Case_impact ;
     //cs.Urgency__c = LX_PSEHelperClass.Case_urgency;
     cs.Origin = LX_PSEHelperClass.Case_WBS_origin; 
     cs.Request__c=requestDetail ;
     cs.subject = LX_PSEHelperClass.Case_sap_project_subject;
     cs.SAP_Project_Request__c=sap_obj.id;
     cs.setOptions(dmo);
     //insert cs;
    return cs;
 }
 
 }