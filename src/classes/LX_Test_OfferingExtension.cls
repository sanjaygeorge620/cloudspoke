/* Class Name    : LX_Test_OfferingExtension 
 * Description   : This is a test class written for trigger " LX_OfferingExtension "
 * Created By    :Veenu Trehan (Deloitte)
 * Created Date  : 8-17-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                  Date        Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
  * Veenu Trehan              9-26-2013                        Initial Version
 */
@isTest(SeeAllData=true)
public class LX_Test_OfferingExtension {
 static testMethod void createQuote(){
    
    Id idRecordType = Schema.SObjectType.Solution_Business_Process__c.getRecordTypeInfosByName().get('Technology').getRecordTypeId();
    //Account acc = Data_Account.createAccount3();
    list<Opportunity> Opprec=Data_Opportunity.createOpportunity(new List<String>{'Qualifying'},1 );
    test.startTest() ;
    Solution_Business_Process__c OffRec=new Solution_Business_Process__c(Business_Solution__c='Admissions',
                                                                        RecordTypeID=idRecordType,
                                                                        Opportunity__c=Opprec[0].Id,
                                                                        Account__c=Opprec[0].AccountId,
                                                                        Solution_Notes__c='abc',
                                                                        Solution_Status__c='Sold',
                                                                        Sector__c='State/Local');
    insert OffRec;                                                                  
    ApexPages.Standardcontroller SC=new ApexPages.Standardcontroller(Opprec[0]);
    
    LX_OfferingExtension Off=new LX_OfferingExtension(SC);
    off.SelectedOfferingId=OffRec.Id;
    off.DeleteOffering();                                                   
    test.stopTest();
 }
}