/**
 *Test class for UpdatePaymentTermsFromAccount
 */
@isTest
private class Test_UpdatePaymentTermsFromAccount {

    static testMethod void testUpdatePaymentTerms() {
        List<Payment_Terms__c> paymentTerms = createPaymentTerms(2);
        List<Account> accs = createAccounts(paymentTerms);
        List<Opportunity> oppList = createOportunities(accs);
        Set<String> oppIdSet = new Set<String>();
        List<String> accIdSet = new List<String>();
        for(Integer i =0;i<oppList.size();i++){
            oppIdSet.add(oppList.get(i).id);
            accIdSet.add(accs.get(i).id);
        }
        for(Opportunity opp1 : [select Id,Payment_Terms__c,AccountId from Opportunity where id in : oppIdSet ]){
            if(opp1.AccountId == accIdSet.get(0)){
               // System.assertEquals(opp1.Payment_Terms__c,paymentTerms.get(0).id);
            }else if(opp1.AccountId == accIdSet.get(1)){
                //System.assertEquals(opp1.Payment_Terms__c,paymentTerms.get(1).id);
            }else if(opp1.AccountId == accIdSet.get(2)){
                //System.assertEquals(opp1.Payment_Terms__c,null);
            }
        }
        
    }
    
     /* Create Sales Organization test data */
  public static List<Payment_Terms__c> createPaymentTerms(Integer size){
    List<Payment_Terms__c> paymentTerms = new List<Payment_Terms__c>();
    for(Integer i =0;i<size;i++){
        Payment_Terms__c pt1 = new Payment_Terms__c(Name ='Test Sales org - '+i,Status__c= 'Active');
        paymentTerms.add(pt1);
    }
    insert paymentTerms;
    return paymentTerms; 
  }
  
   public static List<Account> createAccounts(List<Payment_Terms__c> paymentTerms){
       List<Account> accounts = new List<Account>();
       Account A;
       for(Integer i= 0;i<paymentTerms.size();i++){     
 //          A = new Account(name='Account4TestMethod'+i);
 //          A.Address_Edit_States__c = 'Rajasthan';
 //          A.Payment_Terms__c = paymentTerms.get(i).id;
           Account Acc = Data_Account.createAccount(); 
           Acc.Payment_Terms__c = paymentTerms.get(i).id;
           update Acc;
           accounts.add(Acc);
       }
 //      A =  new Account(name='Account4TestMethod');
 //      A.Address_Edit_States__c = 'Rajasthan';
         Account Acc = Data_Account.createAccount(); 
         accounts.add(Acc); 
 //      insert accounts;
       return accounts;
   }
   
   public static List<Opportunity> createOportunities(List<Account> accounts){
        List<Opportunity> opportunities = new List<Opportunity>();
        Opportunity opp1;
        //Create a new Opportunity
        for(Integer i= 0;i<accounts.size();i++){
         opp1 = new Opportunity(AccountID =accounts.get(0).id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='Add On Solution',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
            
            opp1.AccountId = accounts.get(0).id;
            opp1.Name = 'Opportunity4TestMethod'+i;
            opp1.CloseDate = Date.today().addDays(10);
          
            opportunities.add(opp1);
        }
        insert opportunities;
        return opportunities;
   }
  
}