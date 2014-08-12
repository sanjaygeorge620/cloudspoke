@isTest
private class SitesLeadController_Test {

    static testMethod void myUnitTest () {
    try{
        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
            Account acc = Data_Account.createAccount();
            acc.recordtypeid = [select id from RecordType where sobjecttype = 'Account' and developerName = 'Partner_Unlocked'].id;
            update acc;
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            List<ID>contactIDs = new List<ID>();
            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);
            }    
            List<User> userList = Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIds); 
            
            Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');   
             Lead newLead = Data_Lead.createLeads(pCam.id);     
             
             NewLead.Primary_Partner__c = acc.id;
             NewLead.recordtypeid = [select id from RecordType where sobjecttype = 'Lead' and developerName = 'Unlocked'].id;
         //    NewLead.ownerId = '00GQ00000015We9';
             newLead.Reason_For_Conversion__c = 'Sales';
             Update newLead;
            
            system.debug('UserLIst' + UserList);
                            
                 System.runAs(userList[0]) {
                    Test.setCurrentPageReference(new PageReference('Page.Leaddetails')); 
                    ApexPages.currentPage().getParameters().put('id',newLead.id );
                    ApexPages.currentPage().getParameters().put('retURL','' );
                    SitesLeadController controller = new SitesLeadController();
                    
                    system.assertequals(controller.getLeadDetails().id,newLead.id);
                    
                                            
                    integer num = [Select  count()
                                  From Lead o  
                                  where  o.Primary_Partner__c=:acc.id ];
                              
                               
                    system.assertequals(controller.getLeads().size(),num); 
                 }
                 }catch(Exception e)
              {
                  System.debug( e.getMessage());
              }
    }
}