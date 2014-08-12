@isTest(seeAlldata=true)
private class Test_AssetCloneSharing {

    static testMethod void myUnitTest() {
    Account acc1 = Data_Account.createAccount();
    Contact NewContact = new Contact (
        FirstName = 'xyzFirst',
        LastName = 'XyZLast',
        //line changed - waveoc
        AccountId = acc1.Id,
        Email = 'xyzmail@mail.com'
    );

    //line added - waveoc
    insert newContact;
    
    Account acc = Data_Account.createAccount();
            Account accReseller = Data_Account.createAccount(); 
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
            
            //     Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
            

              
            Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIDs); 
            list<User> PartnerPortalList = new List<user>([select id from user where contactID in :contactIDs]);

       
 
                Asset_Clone__c assetRec = new Asset_Clone__c();
     
                assetRec.account__c = acc.id;
                assetRec.name = 'testing assetRec';
                insert assetRec;
                
           Set<ID> assetIds = new Set<ID>();
           assetIds.add(assetRec.id);
           
          
         userrole userROle=[select id,name from userrole limit 1];    
         Profile adminProfile = [select id from profile where name like '%Channel Portal%'limit 1]; 
         User adminUser = [select id,name from user where id=: userinfo.getUserId()];
        // Perceptive Channel Portal Admin  
        // System Administrator  
        system.runas(adminUser)
    {

            
           RecordSharing_Asset_Clone.manualShare_Asset_Clone_Read(assetIds);   
           
     }      
           
           //system.debug('asset_ShareRecords:' + [select id, userOrGroupID from Asset_Clone__Share where parentID = :assetRec.id]);
            
            Account accReseller2 = Data_Account.createAccount(); 
            accReseller2.RecordTypeID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getInstance('L5LocationPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getInstance('L5LocationPartnerAccountRecordName').Value__c:'').getRecordTypeId();
            update accReseller2 ;
            
            List<Contact> contacts2 = Data_Contact.createContacts(accReseller2.Id,1);
            list<ID>contactIDs2 = new list<ID>();

            for(Contact contactRec: contacts2){
                contactIDs2.add(contactRec.id);

            }   
            Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIDs2); 
            
            set<id> assetListIds= new set<id>();
            assetListIds.add(assetRec.id);
            set<id> acctListIds = new set<id>();
            acctListIds.add(AccReseller.id);
            system.debug('acctlistids:' + acctListIds);
            
            //User userRec = [Select id from user where contactId = :contactIDs[0]];
            //system.debug('userRec:' + userRec);
            List<asset_Clone__Share> assetShareList = new List<asset_Clone__share>( [select userorGroupID from Asset_Clone__Share where parentID = :assetRec.id]);
            system.debug('assetShareList :' + assetShareList );
            
            Database.deleteResult dr = Database.delete(assetShareList[0] ,false);
            system.debug('saveResult:' + dr);
            //system.assertEquals(True, dr.isSuccess());
            
            RecordSharing_Removal_Asset_Clone.manualShare_Asset_Clone_Removal(assetListIds, acctListIds);
  
            assetRec.account__c = accReseller2.ID;
            update assetRec;
      
                
    }
}