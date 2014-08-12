/* Class Name : LX_EE_WorkgroupOCRExtnTest
 * Description : This test class is written to test LX_EE_WorkgroupOCRExtn CLass.
 * Created By : Akanksha Gupta
 * Created Date : 11-28-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Akanksha Gupta       11-28-2013       1000                  Initial Version
 
 */
@isTest(seealldata=true)
private class LX_EE_WorkgroupOCRExtnTest
{
    static testmethod void m1(){
    test.starttest();
      Double LicenseCost =0;
      Double FirstYearSupport =0;
      Double Licensing =0;
      Double Installation =0;
      Double ProjectManagement =0;
      Double Travel =0;

     Map<String,STAR_Easy_Estimate__c> mcs = STAR_Easy_Estimate__c.getall();
     
     List<STAR_Easy_Estimate__c> list_of_data = new List<STAR_Easy_Estimate__c>();
     
     if(mcs.get('WOCR_Lessthan25')==null)
     {
     STAR_Easy_Estimate__c easy_estimate_data = new STAR_Easy_Estimate__c();
     easy_estimate_data.Name='WOCR_Lessthan25';
     easy_estimate_data.License_WOCR__c = 500;
     easy_estimate_data.Installation__c=1600;
     easy_estimate_data.Project_Management__c=1600;
     easy_estimate_data.Travel__c=1000;
     list_of_data.add(easy_estimate_data);
     }
     
     if(mcs.get('WOCR_Between26and250')==null)
     {
     STAR_Easy_Estimate__c easy_estimate_data2 = new STAR_Easy_Estimate__c();
     easy_estimate_data2.Name='WOCR_Between26and250';
     easy_estimate_data2.License_WOCR__c = 500;
     easy_estimate_data2.Installation__c=3200;
     easy_estimate_data2.Project_Management__c=3200;
     easy_estimate_data2.Travel__c=1500;
     list_of_data.add(easy_estimate_data2);
     }
     if(list_of_data.size()>0)
     insert list_of_data;
     
    List<Opportunity> lstOpp = Data_Opportunity.createOpportunity(new List<String>{'Qualification'},1);
    //ApexPages.currentPage().getParameters().put('oppId','006c0000008iUfz'); 
    ApexPages.currentPage().getParameters().put('oppId',lstOpp[0].Id); 
    STAR__c st = new STAR__c();
   
    ApexPages.StandardController sc = new ApexPages.StandardController(st);

    LX_EE_WorkgroupOCRExtn eewocr= new LX_EE_WorkgroupOCRExtn(sc);
    eewocr.PSObj.LX_Conversion_Rate__c = 2; 
    eewocr.PSObj.LX_Number_of_devices__c = 50; 
    eewocr.PSObj.LX_Customer_Type__c = LX_PSEHelperClass.Canada_Const; 
    eewocr.Calculations();
    eewocr.GenerateDoc();
   
    LX_EE_WorkgroupOCRExtn eewocr2= new LX_EE_WorkgroupOCRExtn(sc); 
    eewocr2.Calculations();
    eewocr2.GenerateDoc();
    eewocr2.PSObj.LX_Conversion_Rate__c = 2; 
    eewocr2.PSObj.LX_Number_of_devices__c = 20; 
    eewocr2.Calculations();
    eewocr2.GenerateDoc();
    
    test.stoptest();


}

}