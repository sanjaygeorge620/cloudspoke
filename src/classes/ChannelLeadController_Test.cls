@isTest(seeAllData=true)
public class ChannelLeadController_Test  {
    
    static testMethod void testChannelLeadController_Test() 
    {  
    
    
        
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing'+system.now(), languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='standcheckssssardusesdsdr@lexmark.com',LX_Region__c='NE', Legacy_Company__c = 'Lexmark' );
         Insert adminUser;
         
        //system.runas(adminUser)
        //{
            Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
              
            Account acc = Data_Account.createAccount3();
            acc.recordtypeid = [select id from RecordType where sobjecttype = 'Account' and ID= :LX_SetRecordIDs.AccountPartnerUnlockedRecordTypeId].id;
            update acc;
            system.debug('Partner ID' +acc.ID);
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            List<ID>contactIDs = new List<ID>();
            for(Contact contactRec: contacts)
            {
                contactIDs.add(contactRec.id);
            }    
            List<User> userList = Data_User_CustomerPortal.createUser_CustomerPortal(1, contactIds, 'System Administrator');  
            System.debug('***********'+userlist[0].AccountId);
            System.debug('***********'+userlist[0]);
            
           
            Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');   
             Lead newLead = Data_Lead.createLeads(pCam.id);     
             NewLead.City='Chicago';
             NewLead.postalcode='2342135';
             NewLead.state='US';
             NewLead.street='asdfasd';
             NewLead.Primary_Partner__c = acc.id;
             NewLead.recordtypeid = [select id from RecordType where sobjecttype = 'Lead' and developerName = 'Unlocked'].id;
         //  NewLead.ownerId = '00GQ00000015We9';
             newLead.Reason_For_Conversion__c = 'Sales';
             
             Update newLead;
            
            Schema.DescribeSObjectResult des = Schema.SObjectType.Lead; 
            Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
            Id MRrtId = rtMap.get('Unlocked').getRecordTypeId();   
            //Account pcct = [SELECT ID,Type FROM Account where Type like 'Partner-Channel level%' limit 1];
            
            // System.runAs(userList[0]) 
              //   {  
                
             Lead_CLone__c ld = new lead_clone__c();
             ld.Lead_RecordType__c = MRrtId;
             ld.Primary_Partner__c = acc.ID;
             ld.Reason_For_Conversion__c = 'Sales'; 
             ld.company__c = 'Tect Channel';
             ld.First_Name__c = 'Testing';
             ld.Last_name__c = 'Test Last name 1234556789987654321';
             ld.Title__c = 'Test Title';
             ld.Department__c = 'Advancement';
             ld.Industry__c = 'Agriculture';
             ld.Phone__c = '27973663';
             Ld.Email__c = 'Test@Channel.com';
             Ld.Website__c = 'Testchannel.com';
             Ld.Sector__c = 'Federal';
             Ld.Lead_Type__c = 'Partner';
             Ld.Host_Manufacturer__c = 'Datatel';
             Ld.Budget__c = 'Test Budget';
             Ld.Need_Objectives__c = 'Access Security';
             Ld.Host_Application__c = 'ActiveCampus';
             Ld.Current_Solution__c = 'Homegrown';
            
             Ld.Timeline__c = 'Test TIme';
             Ld.Preferred_Language__c = 'English';
             Ld.Opportunity_Lead_Notes__c = 'Test opportunity lead';
             Ld.Region__c = 'APAC';
             Ld.Physical_Country__c = 'Armenia';
             Ld.Physical_Street_Address__c = 'Sultan Bazr' ;
             Ld.Physical_Street_Address_2__c = 'chaderghat';
             Ld.physical_city__c = 'armistan';
                
                Insert ld;
                    
            system.debug('Inserted Lead' + ld);            
            
            system.debug('UserLIst' + UserList);
                    
                    
                  
                 
                    Test.setCurrentPageReference(new PageReference('Page.ChannelLeaddetails')); 
                    ApexPages.currentPage().getParameters().put('id',ld.id );
                    ApexPages.currentPage().getParameters().put('retURL','' );
                    ChannelLeadController controller = new ChannelLeadController();
                    
                    //system.assertequals(controller.getLeadDetails().id,newLead.id);
                    try      
                    {
                        controller.getLeadDetails();
                    }
                    catch(exception e)
                    {
                        System.debug(e);
                    }
                    controller.getLeadDetail();                        
                    integer num = [Select  count()
                                  From Lead o  
                                  where  o.Primary_Partner__c=:acc.id ];
                              
                               
                    //system.assertequals(controller.getLeads().size(),num); 
                    controller.getLeads_Pending();
                    controller.getLeads_Approved();
                    controller.getLeads_Denied();
                    
                    controller.RedirectNewLead();
                    
                 }
        //}
}