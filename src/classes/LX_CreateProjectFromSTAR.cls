/* Class Name   : LX_CreateProjectFromSTAR
    * Description  : This class creates a 'Pre-Sales' project record from a STAR request.
    * Created By   : Maruthi Kolla
    * Created Date : 11/25/2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla              11/25/2013              1000                   Initial Version
*/    
    
Global Class LX_CreateProjectFromSTAR
{
Public Static pse__Proj__c  proj_obj = new pse__Proj__c();
Public Static STAR__c star_obj = new STAR__c();
Public Static String lstPickvals;

Webservice Static ID create_PresalesProj(String starID)
{
//Creating a pse_proj__c with STAR__c record information
star_obj = [select recordtypeid,Name,ownerid,Account__c,Opportunity__c,Description__c from STAR__c where id = :starID];
proj_obj.recordtypeid = '012i0000000PCqg';
proj_obj.name = star_obj.Name;
proj_obj.pse__Account__c = star_obj.Account__c;
proj_obj.pse__Opportunity__c = star_obj.Opportunity__c ;
proj_obj.Description_Comments__c = star_obj.Description__c;
proj_obj.pse__Billing_Type__c = 'Pre-Sales';

//Inserting the pse_proj__c record
insert  proj_obj;

//Updating STAR__c record
star_obj.project__c = proj_obj.id;
star_obj.Status__c =Label.LX_Star_status;
Update star_obj;

return proj_obj.id;
}

Webservice Static String populate_TimeZone(String value)
    {
    String pick_value;
    Schema.DescribeFieldResult star_TimeZone = Star__C.Time_Zone__c.getDescribe();
    List<Schema.PicklistEntry> timezone_values = star_TimeZone.getPicklistValues();
    for (Schema.PicklistEntry a : timezone_values) 
   {
   lstPickvals = a.getvalue();
   if(lstPickvals.contains(value))
   {
   pick_value=lstPickvals;
   break;
   }
   }
   return EncodingUtil.urlEncode(pick_value,'UTF-8');
   }
}