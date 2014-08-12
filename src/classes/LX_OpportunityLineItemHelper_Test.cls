@isTest(seeAllData=true)
private class LX_OpportunityLineItemHelper_Test{
    public static Account AccForOpp;
    public static Opportunity TestOpp;
    public static List<Opportunity> childOppList;
    public static List<Opportunity> newOppList;
    public static List<OpportunityLineItem> oppLineList;
    public static Map<Id,Opportunity> testMapOpp;
    public static Map<Id,Opportunity> testMapChildOpp;
    public static Map<Id,OpportunityLineItem> testMapOppLineItem;
    public static List<LX_Master_Quote_Line_Item__c> testMQLI;
    public static Set<String> testOLIStringSet;
    public static List<User> testUserList;
    
    public static testmethod void m1(){
    
    list<Sales_Organization__c> sales = [select id,LX_Country_Code__c from Sales_Organization__c where LX_Country_Code__c = 'IN' or LX_Country_Code__c = 'US' limit 2];
         List<Opportunity> testOppList = new List<Opportunity>();
        for (Integer i = 0; i < 3; i++) {            
            testOppList.add(new Opportunity(
                Name = 'TestOpp' + i,
                StageName = 'Upside',
                LX_Country_Code__c = 'US',
                CloseDate = System.Today()));
        }

        for(Sales_Organization__c sa:sales){
            if(sa.LX_Country_Code__c == 'IN'){
                testOppList[1].Sales_Organization__c = sa.id;
            }else if(sa.LX_Country_Code__c == 'US'){
                testOppList[0].Sales_Organization__c = sa.id;
            }

        testOppList[0].id = null;
        testOppList[1].id = null;
        testOppList[2].id = null;
        LX_OpportunityHelper.isTestBypass = true;
        insert testOppList;


            
            
            }

         //for(Integer i = 1; i < 1; i++){
            testOppList[1].Master_Opportunity__c = testOppList[0].id;
        //}
        update testOppList;

            
        Product2 prod2 = new Product2(
            Name = 'testName',
            IsActive=true);
        insert prod2;
        
        Pricebook2 standardPB = [
                SELECT id
                FROM Pricebook2
                WHERE isStandard = true];
        
        PricebookEntry price = new PricebookEntry(
            UseStandardPrice = false,
            Pricebook2Id = standardPB.Id,
            UnitPrice = 1.0,
            IsActive = true,
            Product2Id = prod2.Id);
        insert price;
            
        List<OpportunityLineItem> testOppLineItemsList = new List<OpportunityLineItem>();
        for (Opportunity currentOpportunity : testOppList) {
            for (Integer i = 0; i < 4; i++) {
                testOppLineItemsList.add(new OpportunityLineItem(
                    OpportunityId = currentOpportunity.Id,
                    Quantity = 1.0,
                    TotalPrice = 1.0,
                    Part_Number__c = '82S0145',
                    PricebookEntryId = price.Id, Product_Family__c='metered',Line__c = 'Supplies'));
             //   currentOpportunity.Product_Family__c = 
            }
        }
        Set<ID> testOppLineItemSet = new Set<ID>();
        testOLIStringSet = new Set<String>();
        
        testOppLineItemsList[0].Line__c = 'Test';
        testOppLineItemsList[1].Product_Family__c = 'Test';
        testOppLineItemsList[1].Line__c= 'Test';
        testOppLineItemsList[2].Line__c = 'Supplies';
        testOppLineItemsList[2].Product_Family__c = 'Test';
        testOppLineItemsList[3].Line__c = 'Services';
        testOppLineItemsList[3].Product_Family__c = 'Test';
        
        insert testOppLineItemsList;  
        
        testOppLineItemSet.add(testOppLineItemsList[0].id);
        testOLIStringSet.add(String.ValueOf(testOppLineItemsList[0].id));
        
        testOppLineItemSet.add(testOppLineItemsList[1].id);
        testOLIStringSet.add(String.ValueOf(testOppLineItemsList[1].id));
        
        testOppLineItemSet.add(testOppLineItemsList[2].id);
        testOLIStringSet.add(String.ValueOf(testOppLineItemsList[2].id));
        
        testOppLineItemSet.add(testOppLineItemsList[3].id);
        testOLIStringSet.add(String.ValueOf(testOppLineItemsList[3].id));
        
        list<BigMachines__Quote__c > BMList= new list<BigMachines__Quote__c >();
        BigMachines__Quote__c quoteRec = new BigMachines__Quote__c();
        quoteRec.BigMachines__Opportunity__c = testOppList[0].id;
        quoteRec.BigMachines__Is_Primary__c = true;
        
        BigMachines__Quote__c quoteRec1 = new BigMachines__Quote__c();
        quoteRec1.BigMachines__Opportunity__c = testOppList[1].id;
        quoteRec1.BigMachines__Is_Primary__c = true;
        
        BigMachines__Quote__c quoteRec2 = new BigMachines__Quote__c();
        quoteRec2.BigMachines__Opportunity__c = testOppList[2].id;
        quoteRec2.BigMachines__Is_Primary__c = true;
        BMList.add(quoteRec1 );
        BMList.add(quoteRec2 );
        BMList.add(quoteRec);
        insert BMList;
       // insert quoteRec1;
        //insert quoteRec2;
                
        System.debug('QuoteRec Opportunity --> ' + quoteRec.BigMachines__Opportunity__c);
        System.debug('QuoteRec IsPrimary --> ' +quoteRec.BigMachines__Is_Primary__c);
        
        System.debug('QuoteRec1 Opportunity --> ' +quoteRec1.BigMachines__Opportunity__c);
        System.debug('QuoteRec1 isPrimary --> ' +quoteRec1.BigMachines__Is_Primary__c);
        
        System.debug('QuoteRec2 Opportunity --> ' +quoteRec2.BigMachines__Opportunity__c);
        System.debug('QuoteRec2 isPrimary --> ' +quoteRec2.BigMachines__Is_Primary__c);
        
        String PartyProductLinestr1 = '%' + label.LX_LineService_Parts + '%';
        String PartyProductLinestr2 = '%' + label.LX_LineSupplies + '%';
         
         list<LX_Quote_Party__c > QpList= new list<LX_Quote_Party__c >();
        LX_Quote_Party__c testRec = new LX_Quote_Party__c();
        testRec.LX_Purchasing_Method_from_Lexmark__c = 'Direct';     
        testRec.LX_partyProductLine__c = PartyProductLinestr1 ;
        testRec.LX_Quote__c = quoteRec.id;
        QpList.add(testRec );
        //insert testRec;
        
        LX_Quote_Party__c testRec1 = new LX_Quote_Party__c();
        testRec1.LX_Purchasing_Method_from_Lexmark__c = 'Indirect';
        testRec1.LX_partyProductLine__c = PartyProductLinestr2 ;
        testRec1.LX_Quote__c = quoteRec1.id;
         QpList.add(testRec1 );
        //insert testRec1;
        insert QpList;
         LX_OpportunityLineItemHelper hInstance = new LX_OpportunityLineItemHelper();
            string m1 = LX_OpportunityLineItemHelper.ContractType1;
            string m2 = LX_OpportunityLineItemHelper.ContractType2;
            string m3 = LX_OpportunityLineItemHelper.ContractType3;
            string m4 = LX_OpportunityLineItemHelper.ContractType4;
            string m5 = LX_OpportunityLineItemHelper.ContractType5;
            string m6 = LX_OpportunityLineItemHelper.PurchasingMethod1;
            string m7 = LX_OpportunityLineItemHelper.PurchasingMethod2;
            string m8 = LX_OpportunityLineItemHelper.TimingOfDiscount1;
            string m9 = LX_OpportunityLineItemHelper.TimingOfDiscount2;
        
        // PopulateLX_Contract_Type(testOppLineItemSet);
       //  PopulateLX_Contract_Type  
       test.startTest();
       LX_OpportunityLineItemHelper.mqliUpdate1Future(testOppList[0].Id);
       LX_OpportunityLineItemHelper.MqliDelete(testOLIStringSet);
           /*newOppList = new List<Opportunity>();
           newOppList = [Select id,LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,
                            MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,LX_Country_Code__c,CurrencyIsoCode,Master_Opportunity__c,
                            (Select LX_Country_Code__c, id, CurrencyIsoCode, Master_Opportunity__c From ChildOpportunities__r) 
                            FROM Opportunity]; 
           testMapOpp = new Map<id,Opportunity>();
           for(Opportunity o: newOppList){
               testMapOpp.put(o.Id,o);
           }
           childOppList = new List<Opportunity>();
           childOppList = [Select id,LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,Master_Opportunity__c,
                            MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,LX_Country_Code__c ,CurrencyIsoCode
                            FROM Opportunity where Master_Opportunity__c = :newOppList[0].Id];
           testMapChildOpp = new Map<id,Opportunity>();
           for(Opportunity tempChildOpp: childOppList ){
               testMapChildOpp.put(tempChildOpp.Id, tempChildOpp);
           }
           oppLineList = new List<OpportunityLineItem>();
           oppLineList = [Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,
                          Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,
                          LX_Extra_Parts_Info__c
                          FROM OpportunityLineItem where OpportunityId = :newOppList[0].Id];
           testMapOppLineItem = new Map<id,OpportunityLineItem>();
           for(OpportunityLineItem tempChildOppLine : oppLineList ){
               testMapOppLineItem.put(tempChildOppLine.Id, tempChildOppLine);
           }
           LX_OpportunityLineItemHelper.mqliUpdate1Future(testOppList[0].Id);
           testMQLI = new List<LX_Master_Quote_Line_Item__c>();
           LX_OpportunityLineItemHelper.mqliUpdate1(testMapOpp,testMapChildOpp,testMapOppLineItem);
           Set<string> tempIds = new Set<String>();
           for(Opportunity o1: newOppList){
               tempIds.add(String.ValueOf(o1.Id));
           }
           LX_OpportunityLineItemHelper.MqliDelete(tempIds);
           */
        //Added to increase coverage in class LX_OpportunityRecordTypeSelectionContrlr   
        AccForOpp=new account(name='Test AccForOpp',
                                       License_Closed_Opp_Total__c=-100,
                                       //CurrencyIsoCode='USD-U.S. Dollar',
                                        LXK_Region__c='India',
                                       LX_Geo__c='APAC',
                                       Physical_Country__c='India',
                                       BillingCountry='India',
                                       RecordTypeID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId());
        TestOpp=new Opportunity(Name='Test Opp',CloseDate=system.today(),
                                          StageName='Developing',sector__c='Banking',
                                          ForecastCategoryName='Closed',
                                          Budget__c='aaa',
                                          Authority__c='aaa',
                                          Objectives__c='aaa',
                                          Timeline__c='aaa',
                                          Next_Steps__c='aaa',
                                          Area_of_Interest_s__c='aaa',
                                          Qualification_Level__c='Level1',
                                          Technology__c = True,
                                          LX_Sales_Type__c='New Project', 
                                          Reason_for_Conversion__c='Enterprise Government'
                                          );
        insert AccForOpp;
        TestOpp.Accountid=AccForOpp.id;
        insert TestOpp;                                        
        ApexPages.StandardController sc = new ApexPages.standardController(TestOpp);
        LX_OpportunityRecordTypeSelectionContrlr OppCntrlr=new LX_OpportunityRecordTypeSelectionContrlr(sc);
        PageReference pageRef1; 
        pageRef1 = OppCntrlr.change_sales();
        List<Selectoption> optionList = new List<Selectoption>();
        optionList = OppCntrlr.sales_list();
        Id recordId = OppCntrlr.GetRecordTypeId('MPS');
        
        testUserList = new List<User>();
        testUserList = [Select id from User where Legacy_Company__c != 'Lexmark' And IsActive = True];
        System.RunAs(testUserList[0]){
        OppCntrlr.RecordTypeLogic();
        }
       test.stopTest();
    }
}