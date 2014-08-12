@isTest(seeAllData=true)
public class Test_LX_UpdateOpportunitrySalesOrg{

      static testmethod void m1(){
        Account acc = Data_account.createAccount2();
        List<Contact> lstcon = Data_Contact.createContacts(acc.Id,2);
        user u = [Select id from User where profile.Name = 'System Administrator' and isActive = true limit 1];
        system.runAs(u){
        
        List<Opportunity> lstOpp = Data_Opportunity.createOpportunity3(new List<String> {'Prospecting','Closed Won'}, 2,acc,lstcon);
        LX_UpdateOpportunitrySalesOrg.updateOpportunity(lstOpp);
        
        

        
        }
    }
    
    static testmethod void m2(){
        Account acc = Data_account.createAccount2();
        List<Contact> lstcon = Data_Contact.createContacts(acc.Id,2);
        user u = [Select id from User where profile.Name = 'System Administrator' and isActive = true limit 1];
        system.runAs(u){
        
        LX_Opportunity_Sales_Org__c lop=new LX_Opportunity_Sales_Org__c();
        lop.LX_CountryCode__c='AE';
        lop.Name='CS100';
        insert lop;
        
        Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today(),LX_Country_Code__c='AE'); 
        insert Opp1;
        List<opportunity> lst=new List<opportunity>();
        lst.add(opp1);
        LX_UpdateOpportunitrySalesOrg.updateOpportunity(lst);

        
        }
    }

}