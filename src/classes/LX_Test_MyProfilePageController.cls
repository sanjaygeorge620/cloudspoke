@isTest(SeeAllData = true)
private class LX_Test_MyProfilePageController {
    static testMethod void testSave() {    
      
      
      Account A = new Account(name='Account4TestMethod2');       

        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';

        A.MDM_Sold_To_Number__c = '56A47657';
        A.Physical_Country__c = 'USA';
        A.BillingCity = 'NYC';
        A.LX_Country_Code__c = 'AI';

        A.BillingCountry  = 'USA';
        A.LX_Geo__c = 'EMEA';
        A.MPS_Qualification__c = 'MPS';
        A.LXK_Region__c = 'USA';
        A.TR_Status__c = 'On';
        A.ISS_Coverage_Method__c = 'Face to Face';
        A.ISS_Coverage_Model__c ='Enterprise';

        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Primary_Sector_Focus__c = 'Manufacturing';  
        insert A;
        
         Contact con = new Contact(
                           LastName='Test Contact ',
                           firstName='TestFirst',
                           AccountId = A.Id,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email= 'abc@lexmark.com',
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           License_Contact__c=true,
                           Accounting_Contact__c = true,
                           areas_of_need__c = 'Content',
                          pse__Is_Resource__c = true,
                          pse__Is_Resource_Active__c = true,
                           phone='123456789',
                           MobilePhone='9123456789',
                            Fax='9123456789',
                           Status__c = 'Active' ,
                           Industry__c = 'Manufacturing',
                           Lx_Lexmark_Vertical__c='Manufacturing');
      
      insert con;
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
    User adminUser = new User(alias = 'xmn', email='cstandarduser@lexmark.com', 
                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                  localesidkey='en_US', profileid = adminProfile.Id, 
                  timezonesidkey='America/Los_Angeles',LX_region__c='NE',legacy_company__c='Perceptive', username='standarduse23zx45rt6yr@lexmark.com', contact = con);
    Insert adminUser;
    
    List<Profile> ProfileId = [select id from Profile where Name = 'Perceptive Customer Portal User' limit 1];
    
    system.runas(adminUser)
    {
            String randFax = Math.rint(Math.random() * 1000) + '5551234';
            
            MyProfilePageController controller = new MyProfilePageController();
            //System.assertEquals(adminUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            //System.assert(controller.isEdit == false, 'isEdit should default to false');
            controller.edit();
            //System.assert(controller.isEdit == true);
            
            controller.cancel();
           //System.assert(controller.isEdit == false);
            
            controller.getUser().Fax = randFax;
            controller.save();
            controller.changePassword();
            //Contact con = new Contact();
            controller.callSetContactFields(con);
            controller.getIsEdit();
           // System.assert(controller.isEdit == false);
           
           }
        }
        
       
    
    
}