/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-17-2013
 *
 * Author : Kapil Reddy Sama  
 * 
 * Description : Extension used to create Bil To Ship Sap record sales org.

**/ 

public with sharing class LX_Sap_Record_Sales_Org_BillTo_Extension {
         
    public LX_SAP_Record__c oSRec{get;set;}    
    public string recordtype{get;set;}
    public List<LX_Sales_Organization_Wrapper> SalesOrg{get;set;}  
    private String sSoldToId;
    private string salesOrganization;
    private string oppId; 
        
    public LX_Sap_Record_Sales_Org_BillTo_Extension(ApexPages.StandardController controller) {//Contructor
        oppId = ApexPages.currentPage().getParameters().get('oppId');
        //Added record type id parameter VT 6/20
        if(Apexpages.currentPage().getParameters().get('type')=='SELL') {
        recordtype = 'Ship To';}
        else if(Apexpages.currentPage().getParameters().get('type')=='BILL'){
        recordtype = 'Bill To';}
        
        Opportunity opp = [SELECT id,Name,LX_Sold_To_New__r.LX_Sold_To__c,Sales_Organization_value__c from Opportunity where id = :oppId];
        sSoldToId = opp.LX_Sold_To_New__r.LX_Sold_To__c;
        salesOrganization = opp.Sales_Organization_value__c;    
        Id idRecordType;
        if(recordtype == 'Bill To'){     
            idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Bill To').getRecordTypeId();
        }else if(recordtype == 'Ship To'){
                idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
                }
                                
        oSRec = new LX_SAP_Record__c(LX_Sold_To__c = opp.LX_Sold_To_New__r.LX_Sold_To__c,RecordTypeId=idRecordType);
        SalesOrg = new List<LX_Sales_Organization_Wrapper>();
        for(LX_SAP_Record_Sales_Org__c  record: [Select Name,LX_Sold_To__c,LX_Sales_Org1__c  from LX_SAP_Record_Sales_Org__c 
                                                                                             where LX_Sold_To__c=:sSoldToId and LX_Sales_Org1__c = :salesOrganization and RecordType.Name='Sold To Sales Org' ]) {
              
               SalesOrg.add(new LX_Sales_Organization_Wrapper(record));
        }
    }
    
    public class LX_Sales_Organization_Wrapper  {
        public LX_SAP_Record_Sales_Org__c  oSalesOrg{get; set;}
        public Boolean selected {get; set;}

        //Initialize the wrapper
        public LX_Sales_Organization_Wrapper(LX_SAP_Record_Sales_Org__c  oSOrg) {
            oSalesOrg =  oSOrg;
            selected = true;
        }
    }
    
   
    
    public PageReference saveRecord()//Insert Bill To or Ship To records and corresponding sap record sales org records
    {   
        Savepoint sp = Database.setSavepoint();
        try{
            insert oSRec;
        
            List<LX_SAP_Record_Sales_Org__c > listSelectedOrg = new List<LX_SAP_Record_Sales_Org__c>();       
            for(LX_Sales_Organization_Wrapper record: SalesOrg) {
                if(record.selected == true) {
                    listSelectedOrg.add(record.oSalesOrg);
                }
            }
            
            LX_SAP_Record_Sales_Org__c oBillOrg;
            List<LX_SAP_Record_Sales_Org__c> listBillOrg = new List<LX_SAP_Record_Sales_Org__c>();
            Id idRecordType ;
            if(recordtype == 'Bill To'){
                idRecordType = Schema.SObjectType.LX_SAP_Record_Sales_Org__c.getRecordTypeInfosByName().get('Bill To Sales Org').getRecordTypeId();
            }else if(recordtype == 'Ship To'){
                idRecordType = Schema.SObjectType.LX_SAP_Record_Sales_Org__c.getRecordTypeInfosByName().get('Ship To Sales Org').getRecordTypeId();
            }
            for(LX_SAP_Record_Sales_Org__c  record: listSelectedOrg) {
               oBillOrg = new LX_SAP_Record_Sales_Org__c(LX_Sales_Org1__c=record.LX_Sales_Org1__c,LX_Status__c='Pending',RecordTypeId=idRecordType);
               if(recordtype == 'Bill To'){
                oBillOrg.LX_Bill_To__c = oSRec.Id;
               }
                else if(recordtype == 'Ship To'){
                    oBillOrg.LX_Ship_To__c = oSRec.Id;
                }
                
               listBillOrg.add(oBillOrg);
            }
            
            insert listBillOrg;
            Opportunity opp = new Opportunity(id=oppId);
            /*if(recordtype == 'Bill To')
                opp.LX_Bill_To_New__c = listBillOrg[0].id;
                else if(recordtype == 'Ship To')
                    opp.LX_Ship_To_New__c = listBillOrg[0].id;
            update opp;*/
        }
        catch(Exception ex){
            System.debug('ex-->'+ex);
            Database.rollback(sp);
        }
        PageReference pageRef = new PageReference('/' + oppId);
        return pageRef;
        
    }
                
}