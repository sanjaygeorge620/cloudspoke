@isTest(SeeallData = True)
public class Channel_Delete_Test
{
static testMethod void test()
{
 Account acc = Data_Account.createAccount();
 List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);
 List<Case>cases = Data_Case.createCase(acc, contacts[0], 'Product Support', 1); 
 
 queuesobject qu = [SELECT CreatedById, QueueId, Id, SobjectType, SystemModstamp FROM QueueSobject where queue.name = 'Channel.Delete'][0];
  
 cases[0].OwnerID = qu.Queueid;
 
 update cases;
 Test.Starttest();
 
 cases[0].Ready_To_Delete__c = true; 
 Update cases;
 
 test.Stoptest();
 
}


}