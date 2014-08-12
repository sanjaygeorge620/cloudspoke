@isTest(seealldata=true)
public class Data_Reference_Profile{
    
    public static testmethod refedge__Reference_Basic_Information__c createReferenceProfile(){
        
        refedge__Reference_Basic_Information__c ref = new refedge__Reference_Basic_Information__c();
        
        Account acc = Data_Account.createAccount3();
        acc.MPS_Contract__c = 'Yes';
        acc.Lighthouse__c = 'Yes';
        acc.Local_Priority__c = 'Target-3';
        update acc;
        
        ref.refedge__Account__c = acc.Id;
        
        ref.refedge__Managed_Reference_Account__c = true;
        insert ref;
        
        ref.refedge__Managed_Reference_Account__c = false;
        update ref;
        
        return ref;
    }
    
    public static testmethod refedge__Reference_Basic_Information__c createReferenceProfile2(){
        
        refedge__Reference_Basic_Information__c refm = new refedge__Reference_Basic_Information__c();
        Id User=userinfo.getUserId();
        Account acct = Data_Account.createAccount3();
        acct.MPS_Contract__c = 'No';
        acct.Lighthouse__c = 'No';
        acct.Local_Priority__c = 'Target-3';
        acct.LX_Software_AEX__c = User;
        update acct;
        refm.refedge__Account__c = acct.Id;
        refm.refedge__Managed_Reference_Account__c = true;
        insert refm;
        
        refm.refedge__Managed_Reference_Account__c = false;
        update refm;
        
        return refm;
    }
}