@isTest(seealldata = true)
private class testLX_Enrollment_ProgramsController    {

   public static testmethod void enrctrlprg () {
   
   
 LX_Partner_Program__c pp = new LX_Partner_Program__c();
 RecordType rec = [Select id from Recordtype where developername='LX_Global_ISS_Partner_Level' and SobjecttYpe='LX_Partner_Program__c' limit 1];
 RecordType rec1 = [Select id from Recordtype where developername='Master_Program' and SobjecttYpe='LX_Partner_Program__c' limit 1];
 pp.RecordTypeId = rec1.id;
 pp.Name = 'test';
 insert pp;
 
 Account acc = new Account();
 RecordType rec2 = [Select id from Recordtype where name='Location Partner' and SobjecttYpe='Account'];
 acc.Name = 'New';
 acc.BillingCountry= 'India';
 acc.Physical_Country__c= 'India';
 acc.LX_Geo__c= 'EMEA';
 acc.LXK_Region__c = 'Africa';
 acc.Partner_MPS_Capability_Score__c = 4;
 acc.Partner_ISS_Solutions_Capability_Score__c = 544;
 acc.Party_Type__c = 'Alliance Partner';
 acc.Partner_ISS_Capability_Segment__c = 'Copier Dealer';
 acc.ISS_Coverage_Method__c = 'Face To Face';
 acc.recordtypeId = rec2.Id;
 insert acc;
 
 System.currentPageReference().getParameters().put('accountID',acc.id);
 System.currentPageReference().getParameters().put('programid',pp.id);
 LX_Enrollment_ProgramsController enrprctrl = new LX_Enrollment_ProgramsController();
 
 
 
 PageReference pr = enrprctrl.searchPartnerPrograms();
 System.currentPageReference().getParameters().put('accountID',acc.id);
 PageReference pr1 =enrprctrl.search();
 string str = enrprctrl.getFormTag();
 
 string str1 = enrprctrl.getTextBox();
 
  
   }
   
   
 }