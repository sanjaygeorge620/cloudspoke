@isTest(SeeAllData=true)
private class RMAController_TestClass{
static testmethod void TestRMAController(){
           
        Account RefAccount = new account();
        //List<Contact> contacts= new  List<Contact>();
        Contact objCont = new Contact();
        List<Opportunity> opp = new List<Opportunity>();
        opp = Data_Opportunity.createOpportunity(new string[]{'Negotiation'},1);
        
        objCont = [select LastName,firstName,AccountId,Contact_Role__c,Region__c,email,Physical_street_address__c,Physical_City__c,address_edit_countries__c,License_Contact__c,
        Accounting_Contact__c,areas_of_need__c,pse__Is_Resource__c,pse__Is_Resource_Active__c,phone,MobilePhone,Fax,Status__c,Industry__c,Lx_Lexmark_Vertical__c
           from contact where id =: Opp[0].Project_Contact__c];
        
        //objCont.id = Opp[0].Project_Contact__c;
        
        RefAccount = [select BillingState,Name,Sector__c,Type,Party_Role__c,Party_Type__c,MDM_Sold_To_Number__c,Physical_Country__c,BillingCity,LX_Country_Code__c,
              BillingCountry,LX_Geo__c,MPS_Qualification__c,LXK_Region__c,TR_Status__c,ISS_Coverage_Method__c,ISS_Coverage_Model__c,
              Primary_Sector_Focus__c,RecordTypeId from account where id =: opp[0].AccountID];
        //RefAccount.id = opp[0].AccountID;
        System.debug('opp id-----> :' + opp[0].id + 'contact id-----> :' + objCont.id + 'accountid-----> :' + RefAccount.id);
        
        RecordType objRec = [select id,name from RecordType where id =: RefAccount.RecordTypeId];
        
        //Insert a Case
        List<Case> objCase = Data_Case.createCase(RefAccount,objCont,'Bill To / Ship To Case',1);
        
        List<Product_Model__c> pdctModels = Data_ProductModels.createProductModels(5);
        List<Product2> listproducts = Data_Product.createProduct(pdctModels);
               
        System.debug('Product Models -----> :' + pdctModels[0].id + '-----> :' + pdctModels[1].id + '-----> :' + pdctModels[2].id);
        System.debug('-----> :' + pdctModels[3].id + '-----> :' + pdctModels[4].id);
        
        System.debug('Products-----> :' + listproducts[0].id + '-----> :' + listproducts[1].id + '-----> :' + listproducts[2].id);
        System.debug('-----> :' + listproducts[3].id + '-----> :' + listproducts[4].id);
        
        List<Product_Model__c> SMSApdctModels = Data_ProductModels.createProductModels(5);
        List<Product2> SMSAlistproducts = Data_Product.createProduct(pdctModels);
        
        for(integer tempint = 0; tempint < 5; tempint++)
        {
          SMSAlistproducts[tempint].SMSA_Product__c = listproducts[tempint].id;
        }
        update SMSAlistproducts;
        
        System.debug('SMSAProduct Models -----> :' + SMSApdctModels[0].id + '-----> :' + SMSApdctModels[1].id + '-----> :' + SMSApdctModels[2].id);
        System.debug('-----> :' + SMSApdctModels[3].id + '-----> :' + SMSApdctModels[4].id);
        
        System.debug('SMSAProducts-----> :' + SMSAlistproducts[0].id + '-----> :' + SMSAlistproducts[1].id + '-----> :' + SMSAlistproducts[2].id);
        System.debug('-----> :' + SMSAlistproducts[3].id + '-----> :' + SMSAlistproducts[4].id);
        
        SAP_Contract__c spContract = new SAP_Contract__c(Account__c = RefAccount.id,Opportunity__c = opp[0].id);
        insert spContract;
        System.debug('spContract id-----> :' + spContract.id);
        
        SAP_Sales_Order__c spSalesorder = new SAP_Sales_Order__c(SAP_Sales_Order_Number__c='12345',SAP_Contract__c=spContract.id,
                                                                 Account_DEV_Channel__c=RefAccount.id);
           Test.StartTest();
        insert spSalesorder;
        System.debug('spSalesorder id-----> :' + spSalesorder.id);
        
        Serial_Number__c spSerialNo = new Serial_Number__c(Customer_Account__c = RefAccount.id,Opportunity__c=opp[0].id,SAP_Contract_Number__c=spContract.id,
                                                           SAP_Sales_Order__c=spSalesorder.id,Serial_Number__c ='test',Quantity__c='123',Part_Number__c='sdfsdf');
        insert spSerialNo;
        System.debug('spSerialNoid-----> :' + spSerialNo.id);                                                           
        
        list<Serial_Number_Line_Item__c> listlineitems = new list<Serial_Number_Line_Item__c>();
        Serial_Number_Line_Item__c lineitem = null;
            for(integer cnt=1;cnt<5;cnt++)
            {
                lineitem = new Serial_Number_Line_Item__c();
                lineitem.Serial_Number_Relationship__c = spSerialNo.id;
                lineitem.Quantity__c = string.valueof(cnt);
                lineitem.Part_Number__c = string.valueof(cnt);
                lineitem.Part_Name__c = SMSAlistproducts[cnt-1].id;
                listlineitems.add(lineitem);
            }
          
        insert(listlineitems);
         
        System.debug('listlineitems-----> :' + listlineitems);
        
        
        LX_RMA__c RMA = new LX_RMA__c();
        RMA.LX_Contact__c = objCont.id;
        RMA.LX_Account__c = RefAccount.id;
        RMA.LX_Reason_for_Return__c = 'Delivered in bad condition';
        RMA.LX_Return_Type__c = 'Exchange';
        RMA.LX_SAP_Sales_Order__c = spSalesorder.id;
        RMA.LX_Case__c = objCase[0].id;
        insert RMA;
        System.debug('RMA-----> :' + RMA.id);
        
        LX_SAP_Record__c objSAPRec = new LX_SAP_Record__c(LX_Account__c = RefAccount.id);
        insert objSAPRec;
        LX_SAP_Record_Sales_Org__c objsaprecordsalesorg = new LX_SAP_Record_Sales_Org__c(LX_Currency__c='INR',LX_Bill_To__c=objSAPRec.id);
        insert objsaprecordsalesorg;
        
        //PageReference pageRef = Page.success;
        //Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(new PageReference('Page.TestPage'));
        System.currentPageReference().getParameters().put('id', RMA.id);
        System.currentPageReference().getParameters().put('RMAaccountID', objCont.id);
        System.currentPageReference().getParameters().put('mode', 'Edit');
        System.currentPageReference().getParameters().put('RMAcaseID', objCase[0].id);
        System.currentPageReference().getParameters().put('sapRecordID', objsaprecordsalesorg.id);
        System.currentPageReference().getParameters().put('LX_OpportunityHelper.type', 'LX_SELL');
            
        //LX_OpportunityHelper.type values are LX_BILL---->LX_SHIP
        RMAController controller = new RMAController();
        controller.LX_Shipto_Billto_RMACntrl();
        pagereference objpageref1 = controller.cancel2();
        pagereference objpageref2 = controller.shipTo();
        pagereference objpageref3 = controller.delete_rec();
        pagereference objpageref4 = controller.submit();
        pagereference objpageref5 =controller.edit();
        pagereference objpageref6 =controller.billTo();
        pagereference objpageref7 =controller.clearShipBill();
        //pagereference objpageref8 =controller.createShipBill();
        controller.input11 = 'test'; controller.input12 = 'test1';
        controller.input13 = 'test3';
        
        pagereference objpageref8 =controller.search();
        
        pagereference objpageref15 =controller.clearFilters();
        pagereference objpageref16 =controller.selectAll();
        pagereference objpageref17 =controller.unselectAll();
        pagereference objpageref18 =controller.save();
        pagereference objpageref9 =controller.searchBill();
        pagereference objpageref10 =controller.searchShip();
        pagereference objpageref11 =controller.updateShipTo();
        pagereference objpageref12 =controller.updateBillTo();
        pagereference objpageref13 =controller.updateOpp('LX_BILL');
        pagereference objpageref14 =controller.Cancel1();
        //pagereference objpageref15 =controller.modifyBilltoInfo();
        //pagereference objpageref16 =controller.modifyShiptoInfo();
        controller.LX_Shipto_Billto_RMACntrl();
        controller.setSortDirection('ASC');
        String strSortDirection = controller.getSortDirection();
        controller.sortFilter();
        System.debug('-----> :LX_Shipto_Billto_RMACntrl EXECUTED' );
        Test.StopTest();
    }
  }