/**
 * Author : Pruthvi Ayireddy
 * Date: 04/01/2014
 * Description : TestClass for the 'CustomerLoyaltySurveyAfterTrigger' which updates all the corresponding contacts and 'TaskonContactTrigger'
 *          which creates a task on contact whenever there is an update in the Customer Loyalty Survey Fields.
 *          
 */

@isTest(seeAllData = True)
public class NetPromoterAdditions_Test{
    
    public static testMethod void myUnitTest() {
       
            // Data_Account is the generic method with test data for account object.
            Account A = Data_Account.createAccount();
                 
            List<Contact> ctlist = Data_Contact.createContacts_nonAccountingContact(A.Id,1);
        	
        	Survey_MKT_Customer_Loyalty__c clt = Data_Customer_Loyalty_Survey.createSurvey(A.Id);
            
            }
}