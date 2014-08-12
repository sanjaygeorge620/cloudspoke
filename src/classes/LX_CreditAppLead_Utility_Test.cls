/* Class Name : LX_CreditAppLead_Utility_Test
    * Description  : Test class to cover the code coverage for LX_CreditAppLead_Utility.
    * Created By   : Kolla Maruthi
    * Created Date : 25-07-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Kolla Maruthi            25-07-2014                1000              Initial Version
    
    */

@isTest(SeeAllData=true)
public class LX_CreditAppLead_Utility_Test{    
    
    /* Description : Static Test Method to create default data and call methods in the LX_CreditAppLead_Utility class
      .
    *  Param - None
    *  Returns :  None
  */ 
    Static testmethod void test(){
    List<ID> ProfileIds = new List<ID>();
    for(Profile pf: [select id, name from Profile where name IN ('Tech IS','System Administrator')])
       ProfileIds.add(pf.id);
    
    List<User> userRecords = Data_User.createUser(2,ProfileIds);
    
    List<User> userRecGeo= new List<User>();
    userRecGeo.add(new user(id=userRecords[0].id,LX_Geo__c='Asia Pacific',Manager=userRecords[1]));
    userRecGeo.add(new user(id=userRecords[1].id,LX_Geo__c='Latin America'));
    Update UserRecGeo;
    
    Lead ld = new Lead(LX_Coverage_Status__c='Active',recordtypeID=LX_SetRecordIDs.LeadSimplePartnerRecordTypeId,LX_Country_Code__c='IN',Region__c='Asia PAcific',LX_PSW_Sales_Region__c='APAC',LXK_Region__c='India',lastname ='Testing',Email='testing@test.com',City='Testing City',PostalCode='12345',Street ='Testing Street', State ='Testing State',Company='Test Company',Physical_Country__c='India',Business_Unit__c='ISS',Status='Open',RecordSubmittedForApproval__c =false,LX_ISS_Coverage_Method__c='Web');
    insert ld;
    
    Account acc= data_account.createaccount3();
    List<contact> cnt = data_contact.createContacts(acc.id,1);    
    LX_SAP_Record_Sales_Org__c sapRec = [select LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c limit 1];
    
    Case cs = new Case(recordtypeID=LX_SetRecordIDs.CaseLeadConversionRecordTypeId,contactid=cnt[0].id,status='Submitted',LX_Sales_Organization_Number__c=sapRec.LX_Sales_Org1__c);
    insert cs;
    
    System.runAs(UserRecGeo[0])
    {    
    LX_CreditAppLead_Utility.SendRecordApprovalRequest(ld.id);
    LX_CreditAppLead_Utility.SendCreditApp(cs.id,UserRecGeo[0].id);
    LX_CreditAppLead_Utility.ChangetoGDA(ld.id);
    Boolean flag = LX_CreditAppLead_Utility.createaccess();
    }
    
                
}
        
}