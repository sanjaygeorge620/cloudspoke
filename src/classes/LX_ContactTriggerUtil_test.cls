@isTest(Seealldata=True)
public class LX_ContactTriggerUtil_test{


 static testmethod void  ContactUtil_Testunit1(){
            Account acc = Data_account.createaccount3();
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);     
             List<id> IdList = new List<id>{acc.id};
              List<id> ConIdList = new List<id>{contacts[0].id,contacts[1].id };
            Test.startTest();
            LX_ContactTriggerUtil Util = new LX_ContactTriggerUtil ();
             Util.updateContactAddress(contacts , IdList );
             Util.leadFieldstoContactMap(contacts );
             Util.contactActionPlanDelete(contacts );
             Util.contactActionPlanUnDelete(contacts );
             Util.checkUniqueDefaultToValidation(contacts ,ConIdList , IdList );
            Test.StopTest();
        }
        
}