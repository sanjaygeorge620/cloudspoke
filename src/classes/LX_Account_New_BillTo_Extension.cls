public class LX_Account_New_BillTo_Extension {  
    
    public LX_SAP_Record__c oSRec{get;set;}
    public String sSoldToId{get;set;}
    public List<LX_Sales_Organization_Wrapper> SalesOrg{get;set;}  
    
    public LX_Account_New_BillTo_Extension(ApexPages.StandardController controller) {
    
        Id idAccount=ApexPages.currentPage().getParameters().get('AccId');
        Id idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Bill To').getRecordTypeId();
        Account oAccount = [Select Id,Name from Account where Id =:idAccount];
        oSRec = new LX_SAP_Record__c(LX_Name__c = oAccount.Name);
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