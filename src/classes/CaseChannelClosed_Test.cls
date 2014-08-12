@isTest(SeeAllData = true)
private class CaseChannelClosed_Test {


    static testMethod void CaseChannelClosed_Test() {

        Account acc = Data_Account.createAccount();
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            List<ID>contactIDs = new List<ID>();
            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);
            }    
            //List<User> userList = Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIds);  
            //system.debug('userList:' + userlist);
            //System.runAs(userList[0]) {
     
        
        List<Case> cases = Data_Case.createCase(acc, contacts[0], 'Partner-Channel', 1); 
        Case caseRec = cases[0];
        caseRec.Status = 'Closed'   ;
        //update caseRec;
        URL_Parameter__c obj = new URL_Parameter__c();
        obj.Name = 'Org Host0007';
        obj.URL_Value__c = 'http://test.com';
        insert obj;
        
        CaseChannelClosed.CaseChannelClosed(cases[0], contacts[0]);
            //}

    }
}