/*
 * Description  : Extension Class to create Bill To from Contact
 * Created By   : Anita Koshi
 * Created On   : 14-Jun-13

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Anita Koshi           14-Jun-13          Initial version
 * 
*/

public class LX_SAP_Record_BillTo_Extension {  
    
    public LX_SAP_Record__c oSRec{get;set;}
    public String sSoldToId{get;set;}
    public List<LX_Sales_Organization_Wrapper> SalesOrg{get;set;}  
    
    public LX_SAP_Record_BillTo_Extension(ApexPages.StandardController controller) {
    
        Id idContact=ApexPages.currentPage().getParameters().get('ConId');
        Id idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Bill To').getRecordTypeId();
        Contact oCont = [Select Id,FirstName,LastName,Email,Language__c,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode from Contact where Id =:idContact];
        oSRec = new LX_SAP_Record__c(LX_Contact_First_Name__c=oCont.FirstName,LX_Contact_Last_Name__c=oCont.LastName,LX_Email__c=oCont.Email,LX_Physical_Street_Address__c=oCont.MailingStreet,LX_Physical_City__c=oCont.MailingCity,LX_Physical_State__c=oCont.MailingState,LX_Physical_Country__c=oCont.MailingCountry,LX_Physical_Postal_Code__c=oCont.MailingPostalCode,RecordTypeId=idRecordType);
    }
     // This is the wrapper/container class. 
    public class LX_Sales_Organization_Wrapper  {
        public LX_SAP_Record_Sales_Org__c  oSalesOrg{get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. 
        public LX_Sales_Organization_Wrapper(LX_SAP_Record_Sales_Org__c  oSOrg) {
            oSalesOrg =  oSOrg;
            selected = false;
        }
    }
    public void getSoldToOrg()
    {
       // system.debug('>>>>>>>>>>>>>>>>>>>>>'+pnSoldTo);       
        SalesOrg= new List<LX_Sales_Organization_Wrapper>();
        for(LX_SAP_Record_Sales_Org__c  record: [Select Name,LX_Sold_To__c,LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where LX_Sold_To__c=:sSoldToId and RecordType.Name='Sold To Sales Org' ]) {
              
               SalesOrg.add(new LX_Sales_Organization_Wrapper(record));
        }
    }
    
    public PageReference saveRecord()
    {
        insert oSRec;
    
        List<LX_SAP_Record_Sales_Org__c > listSelectedOrg = new List<LX_SAP_Record_Sales_Org__c>();       
        for(LX_Sales_Organization_Wrapper record: SalesOrg) {
            if(record.selected == true) {
                listSelectedOrg.add(record.oSalesOrg);
            }
        }
        System.debug('These are the selected Org...' + listSelectedOrg);
        
        LX_SAP_Record_Sales_Org__c oBillOrg;
        List<LX_SAP_Record_Sales_Org__c> listBillOrg = new List<LX_SAP_Record_Sales_Org__c>();
        Id idRecordType = Schema.SObjectType.LX_SAP_Record_Sales_Org__c.getRecordTypeInfosByName().get('Bill To Sales Org').getRecordTypeId();
        for(LX_SAP_Record_Sales_Org__c  record: listSelectedOrg) {
           oBillOrg = new LX_SAP_Record_Sales_Org__c(LX_Bill_To__c=oSRec.Id,LX_Sales_Org1__c=record.LX_Sales_Org1__c,LX_Status__c='Pending',RecordTypeId=idRecordType);
           listBillOrg.add(oBillOrg);
        }
        insert listBillOrg;
        PageReference pageRef = new PageReference('/' + oSRec.Id);
        return pageRef;
        
    }
    
}