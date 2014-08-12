@isTest(seeAlldata=true)
private class testNeworderNotify{

    static testmethod void m1(){
        List<String> lst = new List<String>{'Prospecting'};
        Opportunity opp = Data_Opportunity.createOpportunity(lst,1)[0];
        
        Product2 p2 = new Product2(Name='Test Product for Opportunity for Lexmark production',isActive=true);
        insert p2;

        Pricebook2 pb = [Select id from pricebook2 where isStandard=true];
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;

        Test.startTest(); 
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=opp.Id, Quantity=1, TotalPrice=99);
        insert oli;
        
        Contact con = new Contact();
        con.lastname='testOCntact';
        con.phone='123455';
        insert con;
        
        OpportunityContactrole ocr = new OpportunityContactrole();
        ocr.OpportunityId = opp.id;
        ocr.ContactId = con.id;
        ocr.isPrimary=true;
        insert ocr;
        
        Concession_Form__c cf = new Concession_Form__c();
        cf.Opportunity__c = opp.Id;
        cf.primary__c = true;
        insert cf;
             
        NewOrderNotify obj = new NewOrderNotify ();
        List<NewOrderNotify.LineItemWrapper> lstItems  = new List<NewOrderNotify.LineItemWrapper>();
        lstItems.add(new NewOrderNotify.LineItemWrapper(oli,oli.pricebookentry.product2.name));
        obj.setOpportunityId(opp.id);
        obj.getOpportunityId();
        obj.setupPrimaryContact();
        obj.loadConcessionForm();
        obj.loadSalesTeam();
        obj.loadLineItems();
       Test.stopTest();
        
    }
    
     static testmethod void m2(){
        List<String> lst = new List<String>{'Prospecting'};
        Opportunity opp = Data_Opportunity.createOpportunity(lst,1)[0];
        
        Product2 p2 = new Product2(Name='Test',isActive=true);
        insert p2;

        Pricebook2 pb = [Select id from pricebook2 where isStandard=true];
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;

        Test.starttest(); 
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=opp.Id, Quantity=1, TotalPrice=99);
        insert oli;
        
        Contact con = new Contact();
        con.lastname='testOCntact';
        con.phone='123455';
        insert con;
        
        OpportunityContactrole ocr = new OpportunityContactrole();
        ocr.OpportunityId = opp.id;
        ocr.ContactId = con.id;
        ocr.isPrimary=true;
        insert ocr;
        
        Concession_Form__c cf = new Concession_Form__c();
        cf.Opportunity__c = opp.Id;
        cf.primary__c = true;
        insert cf;
        
    
        NewOrderNotify obj = new NewOrderNotify ();
        List<NewOrderNotify.LineItemWrapper> lstItems  = new List<NewOrderNotify.LineItemWrapper>();
        lstItems.add(new NewOrderNotify.LineItemWrapper(oli,oli.pricebookentry.product2.name));
        obj.setOpportunityId(opp.id);
        obj.getOpportunityId();
        obj.setupPrimaryContact();
        obj.loadConcessionForm();
        obj.loadSalesTeam();
        obj.loadLineItems();
        Test.stoptest();
        
    }

}