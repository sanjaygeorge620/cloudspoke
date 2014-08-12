@isTest (SeeAllData = true)
public class LX_Test_ContactUtils{

    public static account acc = Data_Account.createAccount4();
    public static list<Contact> lstCon ;
    
    
    public static void setUpData(){
        lstCon = Data_Contact.createContacts(acc.id,5);
    }


}