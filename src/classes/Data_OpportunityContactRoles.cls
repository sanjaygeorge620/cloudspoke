@isTest
public class Data_OpportunityContactRoles {
    
    public static List<OpportunityContactRole> createOpportunityContactRoles(Id opportunityId, List<Contact> contacts){
        List<OpportunityContactRole> oppContactRoles = new List<OpportunityContactRole>();
        //get opportunity
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
    
    static testMethod void testTestData() {
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);  
    String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
      List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList, 3,acc,Contacts); 
      List<OpportunityContactRole> contactRoles = Data_OpportunityContactRoles.createOpportunityContactRoles(test_opportunities[0].id, contacts);       
      System.assert(contacts.size()> 0); 
    }
}