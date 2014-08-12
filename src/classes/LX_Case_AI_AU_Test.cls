/* Class Name   : LX_Case_AI_AU_Test 
* Description   : Test class for LX_Case_AI_AU_BI_BU
* Created By   : Sanjay George
* Created Date : 18-02-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay George          18-02-2013                1000                 Initial Version

*/

@isTest(seeAlldata=true)
private class LX_Case_AI_AU_Test {

/*Description:This is the test method written to test LX_Case_AI_AU by passing test data for Account and Contact object.
*Param:None
*Returns:VOID
*/ 
public static string getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    static testmethod void m1(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
           // User u3=lstUsers[2];
           u2.LX_Geo__c='Asia Pacific';
            u2.ManagerId = u1.id;
            update u2;
            test.startTest();
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Account Change Request' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                
                req2.setWorkitemId(getWorkItemId(cse.id));
                
                // Submit the request for approval
               /// Approval.ProcessResult result2 =  Approval.process(req2);
                
                // Verify the results
                //System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                
                //System.assertEquals(
                //    'Approved', result2.getInstanceStatus(), 
                //    'Instance Status'+result2.getInstanceStatus());
               set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
               
            }  
            test.stopTest();         
            }


static testmethod void m2(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
            u2.LX_Geo__c='Asia Pacific';
           // User u3=lstUsers[2];
          u2.ManagerId = null;
            update u2;
            test.startTest();
            try{
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Account Change Request' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                
               set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
               
            } 
            }
            catch (Exception e)
            {
                System.debug('Manager cannot be null');
             }
             test.stopTest();          
}
static testmethod void m3(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
           // User u3=lstUsers[2];
           u2.LX_Geo__c='EMEA';
            u2.ManagerId = u1.id;
            update u2;
            test.startTest();
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Account Change Request' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                
                Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                
                req2.setWorkitemId(getWorkItemId(cse.id));
                
                // Submit the request for approval
              //  Approval.ProcessResult result2 =  Approval.process(req2);
                
                // Verify the results
                //System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                
                //System.assertEquals(
                //    'Approved', result2.getInstanceStatus(), 
                //    'Instance Status'+result2.getInstanceStatus());
                set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
               
            }  
            test.stopTest();         
            }
static testmethod void m4(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
           // User u3=lstUsers[2];
           u2.LX_Geo__c='Latin America';
            u2.ManagerId = u1.id;
            update u2;
            test.startTest();
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Account Change Request' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                
                Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                req2.setWorkitemId(getWorkItemId(cse.id));
                
                // Submit the request for approval
                //Approval.ProcessResult result2 =  Approval.process(req2);
                
                // Verify the results
                //System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                
                //System.assertEquals(
                //    'Approved', result2.getInstanceStatus(), 
                //    'Instance Status'+result2.getInstanceStatus());
               set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
               
            } 
            test.stopTest();          
            }
static testmethod void m5(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
           // User u3=lstUsers[2];
           u2.LX_Geo__c='North America';
            u2.ManagerId = u1.id;
            update u2;
            test.startTest();
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Account Change Request' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
               // req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                
                req2.setWorkitemId(getWorkItemId(cse.id));
                
                // Submit the request for approval
                //Approval.ProcessResult result2 =  Approval.process(req2);
                
                // Verify the results
                //System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                
                //System.assertEquals(
                //    'Approved', result2.getInstanceStatus(), 
                //    'Instance Status'+result2.getInstanceStatus());
               set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
               
            }    
            test.stopTest();       
            }
static testmethod void m6(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
           // User u3=lstUsers[2];
           u2.LX_Geo__c='Null Test';
            u2.ManagerId = u1.id;
            update u2;
            test.startTest();
            try
            {
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Account Change Request' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
               // req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                
                req2.setWorkitemId(getWorkItemId(cse.id));
                // Submit the request for approval
                //Approval.ProcessResult result2 =  Approval.process(req2);
                
                // Verify the results
                //System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                
                //System.assertEquals(
               //    'Approved', result2.getInstanceStatus(), 
                //    'Instance Status'+result2.getInstanceStatus());
                
                
               set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
            }           
            }
            catch(Exception e)
            {
                System.debug('Region not correct. Queue not found');
            }
            test.stopTest();
            }
static testmethod void m7(){
            
            Profile p = [Select id from profile where name='System Administrator'];
            List<User> lstUsers = Data_User.createUser(2,new List<Id>{p.id});
            User u1 = lstUsers[0];
            User u2 = lstUsers[1];
           // User u3=lstUsers[2];
           u2.LX_Geo__c='North America';
            u2.ManagerId = u1.id;
            update u2;
            test.startTest();
            System.RunAs(u2){
                RecordType rec = [Select id from RecordType where name='Admin' and sobjectType='Case'];                
                
                Account acc = Data_account.createAccount3();
                List<Contact> lstcon = Data_contact.createContacts(acc.id,1);
                Case cse = new Case();
                cse.ContactId=lstcon[0].Id;
                cse.type='Problem';
                cse.Status='New';
                cse.recordTypeId = rec.Id;
                cse.Impact__c = 'User';
                cse.Urgency__c='Low';
                cse.Origin='Cases';
                insert cse;
                try{
                Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
               // req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                
                req2.setWorkitemId(getWorkItemId(cse.id));
                
                // Submit the request for approval
                //Approval.ProcessResult result2 =  Approval.process(req2);
              
                // Verify the results
                //System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                
                //System.assertEquals(
                //    'Approved', result2.getInstanceStatus(), 
                //    'Instance Status'+result2.getInstanceStatus());
                }
                catch(Exception e)
                {
                    System.debug(e);
                }
               set<id> OwnerSet= new set<id>();
                OwnerSet.add(cse.OwnerId);
                map<id,user> UserMap = new Map<id,user>([Select id , managerid from user where id in:ownerSet]);
               
            } 
            test.stopTest();          
            }
}