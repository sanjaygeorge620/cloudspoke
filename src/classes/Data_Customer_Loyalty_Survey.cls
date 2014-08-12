@istest(seeAllData = true)
public class Data_Customer_Loyalty_Survey
{
    public static Survey_MKT_Customer_Loyalty__c createSurvey(Id AccountId) {

            List<Contact> ctlist = Data_Contact.createContacts_nonAccountingContact(AccountId,1);
            Survey_MKT_Customer_Loyalty__c clt = new Survey_MKT_Customer_Loyalty__c();  
        
            for(Contact ct: ctlist )
            {
            clt.Likelihood_to_Recommend__c= 51; 
            clt.Account_Name__c=AccountId;
            clt.Contact_Name__c =ct.Id; 
            clt.Reason_for_Recommendation__c = 'Test Recommendation Reason for Recommendation';
            clt.Requests_Follow_Up__c = TRUE;
            
            }
            insert clt; 
            return clt;
            }
            
    static testMethod void testTestData() {
            Account A = Data_Account.createAccount();
            Survey_MKT_Customer_Loyalty__c newSurvey = Data_Customer_Loyalty_Survey.createSurvey(A.Id);
            //System.assert(newSurvey.Name!=null);
            }
}