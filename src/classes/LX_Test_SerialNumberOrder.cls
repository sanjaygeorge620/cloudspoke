/* Class Name : LX_Test_SerialNumberOrder
 * Description : This test class is written to test LX_SerialNumberOrder CLass.
 * Created By : Swati Sharma
 * Created Date : 28-07-2014
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date              Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Swati Sharma       27-07-2014         Initial Version
 
 */
 @isTest
private class LX_Test_SerialNumberOrder{
  static testmethod void unittest()
  {
      
      system.Test.setCurrentPage(page.LX_Serial_Number_Sales_Order_Form);
       
              Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2(); 
       
        Account A = new Account(name='Account4TestMethod2');       
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc2.id;
        A.MDM_Sold_To_Number__c = '56A47657';
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.Primary_Sector_Focus__c = 'Manufacturing'; 
        A.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        insert A;  
             
        Account B = new Account(name='Account4TestMethod2');       
        B.BillingState= 'AndhraPradesh';  
        B.Name = 'testAccount2';
        B.Sector__c = 'State/Local';
        B.Type = 'Customer';  
        B.Party_Role__c = 'Perpetual';
        B.Party_Type__c =  'Commercial';
        B.Coverage_ID__c = gc2.id;
        B.MDM_Sold_To_Number__c = '56A47657';
        B.LX_Sales_Team_Assigned__c='Manufacturing';
        B.Physical_Country__c = 'USA';
        B.BillingCountry  = 'USA';
        B.Primary_Sector_Focus__c = 'Manufacturing'; 
        B.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
        insert B;  
        SAP_Contract__c SC = new SAP_Contract__c();
        SC.Account__c = a.id;
        insert sc;
        SAP_Sales_Order__c salesOrder = new SAP_Sales_Order__c();
         
      
        salesOrder.Account_DEV_Channel__c= a.id;
        salesorder.SAP_Contract__c= sc.id;
        salesorder.SAP_Contract_Number__c = '3454';
        insert salesOrder ;
        product2 p = new product2();
        p.name = 'PRD';
        insert p;
        Opportunity o = new Opportunity();
        o.name = 'Opp1';
        o.StageName = 'Qualifying';
        o.CloseDate = date.today();
        insert o;
        List<Serial_number__C> sn = new  List<Serial_number__C> ();
        LX_Serial_Number_Sales_Order__c so = new LX_Serial_Number_Sales_Order__c();
         ApexPages.StandardController controller2 = new ApexPages.StandardController(so);
       System.currentPageReference().getParameters().put('index', '0');
        LX_SerialNumberOrder sno1 = new LX_SerialNumberOrder(controller2);
      
          sno1.getSNList();
        sno1.updateserialNumberList();
        sno1.updateSNList();
          sno1.save_form();
       sno1.submit();
        sno1.getSNList();
        sno1.updateserialNumberList();
        sno1.addSerialNumberOrder();
       
       
        so.LX_Partner_Account__c =A.id;
        
        so.LX_Customer_Account__c = B.id;
       so.LX_Bill_To_Name__c = 'ABCD';
        so.LX_Bill_To_Email_Address__c = 'ABC@Lexmark.com'; 
        insert so;
        System.currentPageReference().getParameters().put('id', so.id);
        list<serial_number__c> listsn = new list<serial_number__c>();
        serial_number__c sn1 = new serial_number__c();
          ApexPages.StandardController controller = new ApexPages.StandardController(so);
        LX_SerialNumberOrder sno = new LX_SerialNumberOrder(controller);
        
        for(integer i = 0; i<1; i++)
        {    
            sn1.Partner_Account__c= A.id;
            sn1.Serial_Number__c= string.valueof(1234 + i);
            sn1.Serial_Number_Sales_Order__c = so.id;
            sn1.SAP_Sales_Order__c = salesorder.id;
            sn1.Opportunity__c = o.id;
            sn1.Part_Number__c = string.valueof(1234 + i);
            sn1.SAP_Contract_Number__c = sc.id;
            listsn.add(sn1);
            
            
        }
        insert listsn;
        sn1.Partner_Account__c= A.id;
            sn1 = new serial_number__c();
            sn1.Serial_Number__c= string.valueof(1235);
            sn1.SAP_Sales_Order__c = salesorder.id;
            sn1.Opportunity__c = o.id;
            sn1.Part_Number__c = string.valueof(1235);
            sn1.SAP_Contract_Number__c = sc.id;
            insert sn1;
        ApexPages.StandardController controller1 = new ApexPages.StandardController(so);
        sno = new LX_SerialNumberOrder(controller1);
       
        sno.save_form();
       sno.submit();
        sno.getSNList();
        sno.updateserialNumberList();
        sno.addSerialNumberOrder();
        System.currentPageReference().getParameters().put('index', '2');
        sno.removeSerialNumberOrder();
        
        sno.addSerialNumberOrder();
        sno.updateserialNumberList();

        sno.save_form();
        sno.submit();
        sn1.License_Activated__c = true;
        sno.activate();
        sno.UpdateAccName();
        sno.ClearAccName();
         so.LX_Bill_To_Name__c = null;
        so.LX_Bill_To_Email_Address__c = null;
        update so;
        sno.submit();
  }
}