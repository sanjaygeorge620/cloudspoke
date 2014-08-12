/* Class Name   : LX_pse_recordtypeSelection
    * Description  : This class is a controller class for LX_PSE_Proj_RecordTypeSelection.
    * Created By   : Maruthi Kolla
    * Created Date : 1/28/2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla              1/28/2014             1000                   Initial Version
*/    
    
Public Class LX_pse_recordtypeSelection
{
Public Static pse__Proj__c  proj_obj = new pse__Proj__c();
Public Static STAR__c star_obj = new STAR__c();
Public Static String lstPickvals;
public String recordTypes {get; set;}
Public String Star_ID;

Public LX_pse_recordtypeSelection()
{
Star_ID = ApexPages.currentPage().getParameters().get('starID');
}

public PageReference CancelURL(){
      PageReference pageRef = new PageReference('/'+Star_ID);
      return pageRef.setRedirect(true);
    }
    
Public pagereference continueToRequest()
{
//Creating a pse_proj__c with STAR__c record information
star_obj = [select recordtypeid,Name,ownerid,Account__c,Opportunity__c,Description__c from STAR__c where id = :Star_ID];
Recordtype pre_sales_recordtype =[Select id from Recordtype where name='Pre-Sales' and sobjecttype ='pse__Proj__c']; 
Recordtype consulting_recordtype =[Select id from Recordtype where name='Consulting' and sobjecttype ='pse__Proj__c']; 
if(recordTypes.equals(LX_PSEHelperClass.Proj_PreSales))
//proj_obj.recordTypeID = Label.Project_RecordType_PreSales_ID;
proj_obj.recordTypeID = pre_sales_recordtype!=null?pre_sales_recordtype.id:null;
else if(recordTypes.equals(LX_PSEHelperClass.Proj_Assessment))
proj_obj.recordTypeID = consulting_recordtype!=null?consulting_recordtype.id:null;
//proj_obj.recordTypeID = Label.LX_Project_RecordType_Assessment_ID;
//proj_obj.recordtypeid = '012i0000000PCqg';
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

Pagereference pg = new pagereference('/'+proj_obj.id+'/e?retURL=%2F'+proj_obj.id);
return pg;
}

Public String populate_TimeZone(String value)
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