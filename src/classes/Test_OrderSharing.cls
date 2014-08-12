@isTest(seeAllData=true)
private class Test_OrderSharing {

    static testMethod void myUnitTest() {
        

  //     Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            test.starttest();
            //RecordType rr1 = [select id,name from RecordType where sobjecttype = 'Account' limit 1];
            Account acc = Data_Account.createAccount();
            Account accReseller = Data_Account.createAccount(); 
            //accReseller.RecordTypeID = LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
            accReseller.RecordTypeID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getInstance('L5LocationPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getInstance('L5LocationPartnerAccountRecordName').Value__c:'').getRecordTypeId();
            accReseller.Type = 'Partner';
            update accReseller ;
            
            
            acc.Reseller_ID__c = accReseller.id;
            update acc;
            
            List<Contact> contacts = Data_Contact.createContacts(accReseller.Id,1);
            
            list<ID>contactIDs = new list<ID>();

            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);

            }   

              
            //Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIDs); 
            //list<User> PartnerPortalList = new List<user>([select id from user where contactID in :contactIDs]);

  /*              String [] stageList = new List<String>();
                stageList.add('Negotiation');
                List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);    
                Opportunity opp = test_opportunities[0];
    */           
 
                Order__c orderRec = new Order__c();
      //          orderRec.opportunity__c = opp.id;
                orderRec.account__c = acc.id;
                orderRec.name = 'testing orderRec';
                insert orderRec;
                
                Order_Detail__c OrderDetailRec = new Order_Detail__c();
                OrderDetailRec.Name = 'SMSA-CaptureNow Adrenaline';
                OrderDetailRec.Order__c = orderRec.id;
              //  OrderDetailRec.Order_Reseller_Account__c=acc.id;
                insert OrderDetailRec;
                
           Set<ID> OrderIds = new Set<ID>();
           OrderIds.add(orderRec.id);
           RecordSharing_Order.manualShare_Order_Read(OrderIds);   
           
           
           
           system.debug('Order_ShareRecords:' + [select id, userOrGroupID from Order__Share where parentID = :orderRec.id]);
            
           Account accReseller2 = Data_Account.createAccount(); 
            accReseller2.RecordTypeID = LX_SetRecordIDs.L5LocationPartnerAccountRecordId;//commented by arun on 27may 2013 rr1.Id;
            update accReseller2 ;
             List<Contact> contacts2 = Data_Contact.createContacts(accReseller2.Id,1);
            
            list<ID>contactIDs2 = new list<ID>();

            for(Contact contactRec: contacts2){
                contactIDs2.add(contactRec.id);

            }   
           // Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIDs2); 
            
            set<id> OrderListIds = new set<id>();
            orderListIds.add(orderRec.id);
            set<id> acctListIds = new set<id>();
            acctListIds.add(AccReseller.id);
            system.debug('acctlistids:' + acctListIds);
            
            //User userRec = [Select id from user where contactId = :contactIDs[0]];
            //system.debug('userRec:' + userRec);
            List<Order__Share> OrderShareList = new List<Order__share>( [select userorGroupID from Order__Share where parentID = :orderRec.id]);
            system.debug('OrderShareList :' + OrderShareList );
            
            Database.deleteResult dr = Database.delete(OrderShareList[0] ,false);
            system.debug('saveResult:' + dr);
//            system.assertEquals(True, dr.isSuccess());
            
            RecordSharing_Removal_Order.manualShare_Order_Removal(orderListIds, acctListIds);
  
            orderRec.account__c = accReseller2.ID;
            update orderRec;
            
          
            test.stoptest();


              
                
                
                
    }
}