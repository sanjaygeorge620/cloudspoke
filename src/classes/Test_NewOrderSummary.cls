/*
 * Test class for NewOrderSummary.cls
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-09-22
 */
@isTest
private class Test_NewOrderSummary{    
    @isTest 
    static void testNewOrderSummary(){
        //Account acc = createAccount();
        Account acc = Data_Account.createAccount(); 
        System.assert(acc.id != null);
        Opportunity opp = createOportunity(acc.Id);
        System.assert(opp.id != null);
        List<Contact> contacts = createContacts(acc.Id,1);
        try{
        List<OpportunityContactRole> oppContactRoles = createOpportunityContactRoles(opp.Id,contacts);
        List<OpportunityTeamMember> oppTeamMember = createOpportunityTeamMember(opp.Id);
        }catch(Exception ex){
            System.debug('-------Exception-------'+ex);
        } 
        PageReference pg = Page.NewOrderSummary;
        pg.getParameters().put('o',opp.Id);
        Test.setCurrentPage(pg);
        
        
        NewOrderSummary newOrder = new NewOrderSummary();
        if(contacts.size() > 0){
            System.assertEquals(newOrder.contacts.primaryName, contacts.get(0).Name);
            System.assertEquals(newOrder.contacts.primaryEmail, contacts.get(0).email);
        }
    }
    
    /* generate test data */
  //  public static Account createAccount(){
       //Account A = new Account(name='Account4TestMethod');
       //A.Address_Edit_States__c = 'Rajasthan';
  //     Account A = Data_Account.createAccount(); 
  //     insert A;
  //     return A;
  // }
   public static Opportunity createOportunity(ID accountID){
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
        con = new Contact(LastName='Test Contact '+i+DateTime.Now(),Lx_Lexmark_Vertical__c = 'Manufacturing' ,AccountId = accountId,Contact_Role__c ='Executive', Region__c='NA',email='test'+i+'@gmail.com',phone='1234'+i);
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
   
   public static List<OpportunityTeamMember> createOpportunityTeamMember(Id OpportunityId){
    List<OpportunityTeamMember> opportunityTeamMembers = new List<OpportunityTeamMember>();
    List<User> users = createUsers();
    //create Opportunity Team Member              
    OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
    opportunityTeamMember.OpportunityId = OpportunityId;
    opportunityTeamMember.TeamMemberRole = 'AEX';
    opportunityTeamMember.UserId = UserInfo.getUserId();
    opportunityTeamMembers.add(opportunityTeamMember);
   
    OpportunityTeamMember opportunityTeamMember1 = new OpportunityTeamMember();
    opportunityTeamMember1.OpportunityId = OpportunityId;
    opportunityTeamMember1.TeamMemberRole = 'ISR';
    opportunityTeamMember1.UserId = users.get(0).Id;
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
   
   public Static List<User> createUsers(){
        //create user for Team Member
    List<User> users = new List<User>();
    Profile profile;
    for(Profile p : [select Id from Profile where Name ='System Administrator' limit 1]){
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
   
}