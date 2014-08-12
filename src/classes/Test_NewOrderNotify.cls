/**
 * Test Class for NewOrderNotify
 */
@isTest
private class Test_NewOrderNotify {

    static testMethod void testNewOrderNotify() {
        /* createAccount */ 
        Account acc = Data_Account.createAccount2();
        //Account acc = createAccount();
        //System.assert(acc.id != null);
        /* create Opportunity */
        Opportunity opp = createOportunity(acc.Id);
        //System.assert(opp.id != null);
          Test.StartTest();
        List<Contact> contacts;
        
        List<OpportunityLineItem> quoteLineItems;
        List<OpportunityContactRole> oppContactRoles;
        List<OpportunityTeamMember> oppTeamMember;
        Concession_Form__c concessionForm;
        List<Product2> products;
        try{
            /* create Contacts */
            contacts = createContacts(acc.Id,3);
            /* create OpportunityContactRole */ 
            oppContactRoles = createOpportunityContactRoles(opp.Id,contacts);
            
            List<User> users = createUsers();
                        /* Create OpportunityTeamMember */
            oppTeamMember = createOpportunityTeamMember(opp.Id,users);
            /* Create concession Form */
            concessionForm = createConcessionForm(opp.Id,users.get(0).id,users.get(1).id);
            /* Create Products */
            products = createProduct(3);
            /* Create Quote Line Items */
            quoteLineItems = createOpportunityLineItems(opp.Id,products);
        }catch(Exception ex){ 
            //System.debug('-------Exception-------'+ex);
        }  
      
        NewOrderNotify testController = new NewOrderNotify();
        testController.setOpportunityId(opp.id);
        ////System.assertEquals(opp.id,testController.getOpportunityId());
        if(contacts != null && contacts.size() > 0 ){
            //System.assertEquals(testController.orderNotifyData.primaryContact, contacts.get(0).Name +', '+contacts.get(0).Phone);
        }
        ////System.assertEquals(testController.orderNotifyData.lineItems.size(),quoteLineItems.size());
        testController.callwrapProductName('This is the name of a famous product');
        testController.callwrapProductName('ProductName');
             Test.StopTest();   
    }
    
/*public static Account createAccount(){
       Account A = new Account(name='Account4TestMethod');
       A.Address_Edit_States__c = 'Rajasthan';
       insert A;
       return A;
   }
*/
   public static Opportunity createOportunity(ID accountID)
   {
        //Create a new Opportunity
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = accountID;
        opp1.Name = 'Opportunity4TestMethod';
        opp1.CloseDate = Date.today();
        opp1.StageName = 'Postponed';
        opp1.Type = 'Renewal';
        insert opp1;
        return opp1;
   }
      
   public static List<Contact> createContacts(Id accountId,Integer size){
    List<Contact> contacts = new List<Contact>();
    Set<Id> contactIds = new Set<Id>();
    Contact con;
    for(Integer i =0;i<size;i++){
        con = new Contact(LastName='Test Contact '+i+DateTime.Now(),AccountId = accountId,Contact_Role__c ='Executive', Region__c='NA',email='test'+i+'@gmail.com',phone='1234'+i);
        contacts.add(con);
    }
    insert contacts;
    for(Contact con1 : contacts){
        contactIds.add(con1.Id);
    }
    contacts = new List<Contact>();
    for(Contact con1 : [select Id,Name,LastName,AccountId,Contact_Role__c,Region__c,email,phone from Contact where id in : contactIds]){
        contacts.add(con1);
    }
    return contacts;
   }
   
   public static List<OpportunityContactRole> createOpportunityContactRoles(Id opportunityId, List<Contact> contacts){
    List<OpportunityContactRole> oppContactRoles = new List<OpportunityContactRole>();
    OpportunityContactRole oppContactRole; 
    for(Contact con : contacts){
        oppContactRole = new OpportunityContactRole();
        oppContactRole.ContactId = con.Id;
        oppContactRole.OpportunityId = opportunityId;
        if(oppContactRoles.size()==0){
            oppContactRole.IsPrimary = true;    
        }
        if(oppContactRoles.size()==1){
            oppContactRole.Role = 'Licenses';
        }else{
            oppContactRole.Role = 'Invoices';
        }
        
        oppContactRoles.add(oppContactRole);
    }
    insert oppContactRoles;
    return oppContactRoles;
   }
   
     public static List<OpportunityTeamMember> createOpportunityTeamMember(Id OpportunityId,List<User> users){
    List<OpportunityTeamMember> opportunityTeamMembers = new List<OpportunityTeamMember>();
    
    //create Opportunity Team Member              
    OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
    opportunityTeamMember.OpportunityId = OpportunityId;
    opportunityTeamMember.TeamMemberRole = 'AEX';
    opportunityTeamMember.UserId = UserInfo.getUserId();
    opportunityTeamMembers.add(opportunityTeamMember);
   
    OpportunityTeamMember opportunityTeamMember1 = new OpportunityTeamMember();
    opportunityTeamMember1.OpportunityId = OpportunityId;
    opportunityTeamMember1.TeamMemberRole = 'ISR';
    opportunityTeamMember1.UserId = users.get(1).Id;
    opportunityTeamMembers.add(opportunityTeamMember1);
    
    OpportunityTeamMember opportunityTeamMember2 = new OpportunityTeamMember();
    opportunityTeamMember2.OpportunityId = OpportunityId;
    opportunityTeamMember2.TeamMemberRole = 'Manager';
    opportunityTeamMember2.UserId = users.get(1).Id;
    opportunityTeamMembers.add(opportunityTeamMember2);
    
    OpportunityTeamMember opportunityTeamMember3 = new OpportunityTeamMember();
    opportunityTeamMember3.OpportunityId = OpportunityId;
    opportunityTeamMember3.TeamMemberRole = 'AEX';
    opportunityTeamMember3.UserId = users.get(2).Id;
    opportunityTeamMembers.add(opportunityTeamMember3);
   
    OpportunityTeamMember opportunityTeamMember4 = new OpportunityTeamMember();
    opportunityTeamMember4.OpportunityId = OpportunityId;
    opportunityTeamMember4.TeamMemberRole = 'ISR';
    opportunityTeamMember4.UserId = users.get(3).Id;
    opportunityTeamMembers.add(opportunityTeamMember4);
    
    OpportunityTeamMember opportunityTeamMember5 = new OpportunityTeamMember();
    opportunityTeamMember5.OpportunityId = OpportunityId;
    opportunityTeamMember5.TeamMemberRole = 'Manager';
    opportunityTeamMember5.UserId = users.get(4).Id;
    opportunityTeamMembers.add(opportunityTeamMember5);
    insert opportunityTeamMembers;
    return opportunityTeamMembers;
   }
   
   public static Concession_Form__c createConcessionForm(Id oppId,Id userId1,Id userId2){
    Concession_Form__c concessionForm = new Concession_Form__c();
    concessionForm.Opportunity__c = oppId;
    concessionForm.AEX_Manager__c = userId1;
    concessionForm.Account_Executive__c = userId2;
    concessionForm.Initiating_Department__c = 'Sales';
    concessionForm.Standard_License_Proposal_Amount__c = 0;
    concessionForm.Proposed_Licensed_Amount_1__c = 0;
    concessionForm.License_Conc_Comment__c = 'test license concession';
    concessionForm.Standard_Prof_Srvcs_Proposal_Amount__c = 0;
    concessionForm.Proposed_Prof_Srvcs_Amount_1__c = 0;
    concessionForm.Prof_Srvcs_Concession_Comment__c = 'test prof srvcs';
    concessionForm.Standard_Tech_Srvcs_Proposal_Amount__c = 0;
    concessionForm.Proposed_Tech_Srvcs_Amount_1__c = 0;
    concessionForm.Tech_Srvcs_Concession_Comment__c = 'test tech srvcs';
    concessionForm.Standard_3rd_Party_Proposal_Amount__c = 0;
    concessionForm.Proposed_3rd_Party_Amount_1__c = 0;
    concessionForm.X3rd_Party_Concession_Comment__c = 'test 3rd party';
    concessionForm.Concession_Category__c = 'License Exchange';
    concessionForm.Account_Executive_Understands_Terms__c = true;
    
    
    insert concessionForm;
    return concessionForm;
   }
   
   public Static List<User> createUsers(){
        //create user for Team Member
    List<User> users = new List<User>();
    Profile profile;
    for(Profile p : [select Id from Profile where Name ='//System Administrator' limit 1]){
        profile = p;
    }
    User u = new User(Username = 'unknown.Manager@perceptivesoftware.com',
                      LastName = 'Manager',
                      FirstName = 'Unknown'+Date.today().day(),
                      Email = 'process.admin@perceptivesoftware.com',
                      Alias = 'uMan'+Date.today().day(),
                      CommunityNickname = 'uMan12',
                      TimeZoneSidKey = 'America/Chicago',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      LanguageLocaleKey = 'en_US'
                      );
    if(profile != null){
        u.ProfileId = profile.Id;
    }
    users.add(u); 
    User u1 = new User(Username = 'unknown'+Date.today().day()+'1.Manager@perceptivesoftware.com',
                      LastName = 'Manager',
                      FirstName = 'Unknown'+Date.today().day()+'1',
                      Email = 'process1.admin@perceptivesoftware.com',
                      Alias = 'uMan'+Date.today().day()+'1',
                      CommunityNickname = 'uMan121',
                      TimeZoneSidKey = 'America/Chicago',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      LanguageLocaleKey = 'en_US'
                      );
    if(profile != null){
        u1.ProfileId = profile.Id;
    }
    users.add(u1);
    User u2 = new User(Username = 'unknown'+Date.today().day()+'2.Manager@perceptivesoftware.com',
                      LastName = 'Manager',
                      FirstName = 'Unknown'+Date.today().day()+'2',
                      Email = 'process2.admin@perceptivesoftware.com',
                      Alias = 'uMan'+Date.today().day()+'2',
                      CommunityNickname = 'uMan122',
                      TimeZoneSidKey = 'America/Chicago',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      LanguageLocaleKey = 'en_US'
                      );
    if(profile != null){
        u2.ProfileId = profile.Id;
    }
    users.add(u2); 
    User u3 = new User(Username = 'unknown'+Date.today().day()+'3.Manager@perceptivesoftware.com',
                      LastName = 'Manager',
                      FirstName = 'Unknown'+Date.today().day()+'3',
                      Email = 'process3.admin@perceptivesoftware.com',
                      Alias = 'uMan'+Date.today().day()+'3',
                      CommunityNickname = 'uMan123',
                      TimeZoneSidKey = 'America/Chicago',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      LanguageLocaleKey = 'en_US'
                      );
    if(profile != null){
        u3.ProfileId = profile.Id;
    }
    users.add(u3); 
    User u4 = new User(Username = 'unknown'+Date.today().day()+'4.Manager@perceptivesoftware.com',
                      LastName = 'Manager',
                      FirstName = 'Unknown'+Date.today().day()+'4',
                      Email = 'process4.admin@perceptivesoftware.com',
                      Alias = 'uMan'+Date.today().day()+'4',
                      CommunityNickname = 'uMan14',
                      TimeZoneSidKey = 'America/Chicago',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      LanguageLocaleKey = 'en_US'
                      );
    if(profile != null){
        u4.ProfileId = profile.Id;
    }
    users.add(u4); 
    insert users;
    return users;
  }
  
   public Static List<Product2> createProduct(Integer size){
    return createProduct(size, false);
   }
   public Static List<Product2> createProduct(Integer size, boolean tier_pricing){
    List<Product2> prodList = new List<Product2>();
    Product2 prdObj;
    for(Integer i =0;i<size;i++){
         prdObj = new Product2(name='testproduct - '+i, family='Development',
                               Tier_Pricing__c = tier_pricing,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+i);
         prodList.add(prdObj);
   }
   prdObj = new Product2(name='This is a test product for testing of the wrap product Name',family='Development');
   prodList.add(prdObj);
   insert prodList;
   return prodList;
  }
  
 
  public static List<OpportunityLineItem> createOpportunityLineItems(Id oppId,List<Product2> products){
    List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
    for(Product2 prod : products){
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        PricebookEntry pb = new PricebookEntry();
        pb.Pricebook2Id = [select Id from Pricebook2 where Name = 'Standard Price Book'].get(0).Id;
        pb.Product2Id = prod.id;
        pb.UnitPrice = 5;
        pb.IsActive = true;
        insert pb;
        
        opportunityLineItem.OpportunityId = oppId;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.PricebookEntryId = pb.Id;
        opportunityLineItem.TotalPrice = 5;
        opportunityLineItems.add(opportunityLineItem);
    }
    insert opportunityLineItems;
    return opportunityLineItems;
  } 
}