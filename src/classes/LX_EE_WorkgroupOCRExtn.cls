/*
Class Name : LX_EE_WorkgroupOCRExtn
Description : This extension class is written for EASY ESTIMATE Workgroup OCR record creation and related calculations.
Created By : Madhurupa Ghose Roy (mghoseroy@deloitte.com)
Created Date : 29-9-2013
Modification Log:
---------------------------------------------------------------------------
Developer             Date            Modification ID        Description
---------------------------------------------------------------------------
Madhurupa Ghose Roy  29-9-2013        1000                   Initial Version
***************************************************************************/

public with sharing class LX_EE_WorkgroupOCRExtn {
  public STAR__c PSObj {get;set;}
  public Double LicenseCost {get;set;}
  public Double FirstYearSupport {get;set;}
  public Double Licensing {get;set;}
  public Double Installation {get;set;}
  public Double ProjectManagement {get;set;}
  public Double Travel {get;set;}
  public Double Temp {get;set;}
  public String opp{get;set;}
  public String oppoID{get;set;}
  public Decimal PerDeviceConvMin{get;set;}
  public Decimal PerDeviceConvMax{get;set;}
  public Decimal LicensingMin{get;set;}
  public Decimal LicensingMax{get;set;}
  public Decimal PSMin{get;set;}
  public Decimal PSMax{get;set;}
  public Decimal TotalMin{get;set;}
  public Decimal TotalMax{get;set;}
  public Decimal ASMin{get;set;}
  public Decimal ASMax{get;set;}
  Public Map<String,STAR_Easy_Estimate__c> mcs = STAR_Easy_Estimate__c.getall();
  public List<String> errorList{get;set;} //CRC Review Modification (Madhu: 1/30/2014)
  
/*
 * 
 * Description : Constructor for the extension class.
 * Param - : Standard Controller Record that is being created or edited.
 * Returns : null
*/
    
  public LX_EE_WorkgroupOCRExtn(ApexPages.StandardController controller) {
   oppoID = ApexPages.currentPage().getParameters().get('oppID');
    //Query the wanted fields from Opportunity that would have to be pre-populated on the Pre Sales Project Request Page.
    List<Opportunity> opp_list = [select Name,AccountId,Account.name,Account.LX_Geo__c from Opportunity where id =: oppoID LIMIT 1];
    Opportunity oppr = opp_list[0];
    String uid=UserInfo.getUserId();
    User u =[Select Name,Legacy_Company__c from User where id=: uid];
    PSObj=new STAR__c();
    errorList=new list<string>(); //CRC Review Modification (Madhu: 1/30/2014)
    PSObj.Licensing_and_1st_year_support_min_value__c=0;
    PSObj.Licensing_and_1st_year_support_max_value__c=0;
    PSObj.Profession_services_min_value__c=0;
    PSObj.Profession_services_max_value__c=0;
    PSObj.Total_min_value__c=0;
    PSObj.Total_max_value__c=0;
    PSObj.Per_device_min_value__c=0;
    PSObj.Per_device_max_value__c=0;
    PSObj.Anuual_support_renewal_after_year1_min_v__c=0;
    PSObj.Anuual_support_renewal_after_year1_max_v__c=0;
    PSObj.Type_of_Request__c = 'Easy Estimate: Workgroup OCR';
    PSObj.Name = PSObj.Type_of_Request__c;
    PSObj.Geo__c = oppr.Account.LX_Geo__c;
    if(u.Legacy_Company__c == null || u.Legacy_Company__c == 'Lexmark')
    PSObj.Division__c = 'ISS';
    else
    PSObj.Division__c = 'PSW';
    PSObj.Opportunity__c = ApexPages.currentPage().getParameters().get('oppID');
    opp=PSObj.Opportunity__c;
    PSObj.Account__c = oppr.AccountId;
    PSObj.RecordTypeId = ApexPages.currentPage().getParameters().get(LX_PSEHelperClass.RecordType_Const);
    if(PSObj.RecordTypeId==null){
      PSObj.RecordTypeId= STAR__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(LX_PSEHelperClass.EasyEstimateRecordType).getRecordTypeId();
    }
    PSObj.LX_Customer_Name__c = oppr.Account.name;
  }
    
/*
 * 
 * Description : This method is written for Workgroup OCR Calculations.
 * Param - : no parameter
 * Returns : null
*/
    
  public void Calculations(){ 
    Temp=PSObj.LX_Number_of_devices__c;
    system.debug('Temp'+Temp);
    if(PSObj.LX_Number_of_devices__c>=10&&PSObj.LX_Number_of_devices__c<=250){
      LicenseCost=0;
      FirstYearSupport=0;
      Licensing=0;
      Installation=0;
      ProjectManagement=0;
      Travel=0;
      if(PSObj.LX_Number_of_devices__c>=10 && PSObj.LX_Number_of_devices__c<=25){
        Licensing=mcs.get('WOCR_Lessthan25').License_WOCR__c;
        Installation=mcs.get('WOCR_Lessthan25').Installation__c;
        ProjectManagement=mcs.get('WOCR_Lessthan25').Project_Management__c;
        Travel=mcs.get('WOCR_Lessthan25').Travel__c;
      }
      else if(PSObj.LX_Number_of_devices__c>=26 && PSObj.LX_Number_of_devices__c<=250){
        Licensing=mcs.get('WOCR_Between26and250').License_WOCR__c;
        Installation=mcs.get('WOCR_Between26and250').Installation__c;
        ProjectManagement=mcs.get('WOCR_Between26and250').Project_Management__c;
        Travel=mcs.get('WOCR_Between26and250').Travel__c;
      }
      System.debug('***************************CONVERSION RATE***********************'+PSObj.LX_Conversion_Rate__c);
      if(PSObj.LX_Conversion_Rate__c!=0){
        if(PSObj.LX_Conversion_Rate__c!=null&&PSObj.LX_Customer_Type__c==LX_PSEHelperClass.Canada_Const){   
          LicenseCost=Licensing*Temp;
          FirstYearSupport=0.20*LicenseCost;
          LicensingMin=(LicenseCost+FirstYearSupport)/PSObj.LX_Conversion_Rate__c;
          PSObj.Licensing_and_1st_year_support_min_value__c=LicensingMin.divide(1, 0, System.RoundingMode.UP);
          LicensingMax=(1.10*PSObj.Licensing_and_1st_year_support_min_value__c)/PSObj.LX_Conversion_Rate__c;
          PSObj.Licensing_and_1st_year_support_max_value__c=LicensingMax.divide(1, 0, System.RoundingMode.UP);
          PSMin=(Installation + ProjectManagement + Travel)/PSObj.LX_Conversion_Rate__c;
          PSObj.Profession_services_min_value__c=PSMin.divide(1, 0, System.RoundingMode.UP);
          PSMax=(1.10*PSObj.Profession_services_min_value__c)/PSObj.LX_Conversion_Rate__c;
          PSObj.Profession_services_max_value__c=PSMax.divide(1, 0, System.RoundingMode.UP);
          TotalMin=(PSObj.Licensing_and_1st_year_support_min_value__c+PSObj.Profession_services_min_value__c)/PSObj.LX_Conversion_Rate__c;
          PSObj.Total_min_value__c=TotalMin.divide(1, 0, System.RoundingMode.UP);
          TotalMax=(PSObj.Licensing_and_1st_year_support_max_value__c+PSObj.Profession_services_max_value__c)/PSObj.LX_Conversion_Rate__c;
          PSObj.Total_max_value__c=TotalMax.divide(1, 0, System.RoundingMode.UP);
          PerDeviceConvMin=PSObj.Total_min_value__c/(Temp*PSObj.LX_Conversion_Rate__c);
          PSObj.Per_device_min_value__c=PerDeviceConvMin.divide(1, 0, System.RoundingMode.UP);
          PerDeviceConvMax=PSObj.Total_max_value__c/(Temp*PSObj.LX_Conversion_Rate__c);
          PSObj.Per_device_max_value__c=PerDeviceConvMax.divide(1, 0, System.RoundingMode.UP);
          ASMin=(0.20*LicenseCost)/PSObj.LX_Conversion_Rate__c;
          PSObj.Anuual_support_renewal_after_year1_min_v__c=ASMin.divide(1, 0, System.RoundingMode.UP);
          ASMax=(0.20*1.10*LicenseCost)/PSObj.LX_Conversion_Rate__c;
          PSObj.Anuual_support_renewal_after_year1_max_v__c=ASMax.divide(1, 0, System.RoundingMode.UP);
        }
        else {
          LicenseCost=Licensing*Temp;
          FirstYearSupport=0.20*LicenseCost;
          LicensingMin=LicenseCost+FirstYearSupport;
          PSObj.Licensing_and_1st_year_support_min_value__c=LicensingMin.divide(1, 0, System.RoundingMode.UP);
          LicensingMax=1.10*PSObj.Licensing_and_1st_year_support_min_value__c;
          PSObj.Licensing_and_1st_year_support_max_value__c=LicensingMax.divide(1, 0, System.RoundingMode.UP);
          PSMin=Installation + ProjectManagement + Travel;
          PSObj.Profession_services_min_value__c=PSMin.divide(1, 0, System.RoundingMode.UP);
          PSMax=1.10*PSObj.Profession_services_min_value__c;
          PSObj.Profession_services_max_value__c=PSMax.divide(1, 0, System.RoundingMode.UP);
          TotalMin=PSObj.Licensing_and_1st_year_support_min_value__c+PSObj.Profession_services_min_value__c;
          PSObj.Total_min_value__c=TotalMin.divide(1, 0, System.RoundingMode.UP);
          TotalMax=PSObj.Licensing_and_1st_year_support_max_value__c+PSObj.Profession_services_max_value__c;
          PSObj.Total_max_value__c=TotalMax.divide(1, 0, System.RoundingMode.UP);
          PerDeviceConvMin=PSObj.Total_min_value__c/Temp;
          PSObj.Per_device_min_value__c=PerDeviceConvMin.divide(1, 0, System.RoundingMode.UP);
          PerDeviceConvMax=PSObj.Total_max_value__c/Temp;
          PSObj.Per_device_max_value__c=PerDeviceConvMax.divide(1, 0, System.RoundingMode.UP);
          ASMin=0.20*LicenseCost;
          PSObj.Anuual_support_renewal_after_year1_min_v__c=ASMin.divide(1, 0, System.RoundingMode.UP);
          ASMax=0.20*1.10*LicenseCost;
          PSObj.Anuual_support_renewal_after_year1_max_v__c=ASMax.divide(1, 0, System.RoundingMode.UP);
        }
      }
    }
    else {
      FirstYearSupport=0;
      PSObj.Licensing_and_1st_year_support_min_value__c=0;
      PSObj.Licensing_and_1st_year_support_max_value__c=0;
      PSObj.Profession_services_min_value__c=0;
      PSObj.Profession_services_max_value__c=0;
      PSObj.Total_min_value__c=0;
      PSObj.Total_max_value__c=0;
      PSObj.Per_device_min_value__c=0;
      PSObj.Per_device_max_value__c=0;
      PSObj.Anuual_support_renewal_after_year1_min_v__c=0;
      PSObj.Anuual_support_renewal_after_year1_max_v__c=0;
    }
  }
    
/*
 * 
 * Description : This method is written for WorkgroupOCR PDF Document Generation and page redirect.
 * Param - : no parameter
 * Returns : null
*/

  public PageReference GenerateDoc(){
  //CRC Review Modification (Madhu: 1/30/2014){
    errorList=new list<string>();
    if(PSObj.LX_Customer_Type__c==LX_PSEHelperClass.Canada_Const){
      if(PSObj.LX_Conversion_Rate__c==0){
        errorList.add(Label.ZeroConversionRate);   
      }
      if(PSObj.LX_Conversion_Rate__c==null){
        errorList.add(Label.ErrorConversionRate);  
      }
    }  
    if(PSObj.LX_Number_of_devices__c<10||PSObj.LX_Number_of_devices__c>250){
      errorList.add(Label.NumberOfDeviceError);   
    }
    if(PSObj.LX_Customer_Type__c==null){
      errorList.add(Label.ErrorCustomerType);  
    }
    if(PSObj.LX_Number_of_devices__c==null){
      errorList.add(Label.ErrorDevices);  
    }
    if(PSObj.LX_All_lexmatk_devices__c==null){
      errorList.add(Label.ErrorAllLexmark);  
    }
    
    if(errorList.size()>0){
      for(integer i=0;i<errorList.size();i++){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorList[i]));
      }
      return null;
      }
    //CRC Review Modification (Madhu: 1/30/2014)}
    if(PSObj!=null){
      try{
        insert PSObj;
      }
      catch (exception ex){
        LX_CommonUtilities.CreateExceptionLog(ex);
      }    
    }
    PageReference pageRef = new PageReference('/apex/LX_EE_WorkgroupOCRPDF?id=');
    PageRef.getParameters().put('id',PSObj.id);
    return pageRef.setRedirect(true);
  }
}