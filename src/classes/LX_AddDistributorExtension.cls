/*
Class Name : LX_AddDistributorExtension
Description : Extension class for adding end customer by clicking on the 'Add Distributor' related list button on the 'Opportunity Party' list from an Opportunity
Created By : Shubhashish Rai (shrai@deloitte.com)
Created Date : 14-July-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai   14-July-2014           1000               Initial Version
*************************************************************************/

public with sharing class LX_AddDistributorExtension{
    public Id oppId{get;set;}
    public boolean oppPartyListExists {get;set;}
    public boolean pgBlockRenderMain {get;set;}
    
    public LX_AddDistributorExtension(){
        oppId= ApexPages.currentPage().getParameters().get('oppId');        
        String queryOppPartyString = 'Select id, Name from LX_Opportunity_Parties__c where LX_Opportunity__c in (\'' + oppId + '\') and LX_Opportunity_Party_Type__c = \'Distributor\'' ;
        List<LX_Opportunity_Parties__c> oppPartyList = new List<LX_Opportunity_Parties__c>();
        List<User> partnerUserList = new List<User>();
        List<LX_SAP_Record__c> sapRecordSoldToList = new List<LX_SAP_Record__c>();
        List<LX_SAP_Record_Sales_Org__c> sapRecordSalesOrgList = new List<LX_SAP_Record_Sales_Org__c>();
        
        oppPartyListExists = false;
        
        try{
            oppPartyList = Database.query(queryOppPartyString);
            partnerUserList = [Select id, Contact.Account.MDM_Account_Number__c from User where id=: UserInfo.getUserId()];
            System.debug('@@@oppPartyList ' + oppPartyList );
            if(partnerUserList[0].Contact.Account!=null){
                if(partnerUserList[0].Contact.Account.MDM_Account_Number__c != null && partnerUserList[0].Contact.Account.MDM_Account_Number__c!=''){
                    sapRecordSoldToList = [Select id, LX_Sold_To__c, LX_MDM_Act__c from LX_SAP_Record__c where LX_MDM_Act__c =:  partnerUserList[0].Contact.Account.MDM_Account_Number__c];
                    if(sapRecordSoldToList[0].LX_Sold_To__c!=null){
                        sapRecordSalesOrgList = [Select id, LX_Sales_Org1__c, LX_Sold_To__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c =: sapRecordSoldToList[0].LX_Sold_To__c];
                    }
                }
            }
        }
        catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }
        if(oppPartyList.size()>0){
            pgBlockRenderMain = false;
            PageReference pgRefErrorOppPartyExists = onlyOneDistributorAllowed();
            oppPartyListExists = true;
        }        
    }
   public PageReference onlyOneDistributorAllowed(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Only_One_Distributor_Allowed));    
       return null;    
    }
   public PageReference cancelLogic(){
        PageReference PageRef  = new PageReference ('/'+oppId);
        return PageRef ;
    }
}