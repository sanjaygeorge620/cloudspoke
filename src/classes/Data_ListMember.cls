/**************************************************************
Class Name   : Data_ListMember
Created by   : Srikanth Seela
Created Date : June 22nd, 2011
Modified By : 
Modified Date : 
Purpose      : Class for creating a List Member
***************************************************************/
@isTest
public class Data_ListMember{

public static List_Member__c createListMember(){
    
    //Create  a Contact
    Account acc = Data_Account.createAccount2();
    List<Contact> contact = Data_Contact.createContacts(acc.Id,1);  
   
    //Create a List
    List__c lst = Data_List.createList();
            
    List_Member__c lmo = new List_Member__c();
    
    lmo.Contact__c=contact[0].id;
    lmo.Name='Test Name';
    lmo.List__c=lst.id;
    
    insert lmo;
    return lmo;
    }
static testMethod void testListMemberData(){
        
       try
       {
           List_Member__c lstmem = Data_ListMember.createListMember();
           List<List_Member__c> lstmems = new List<List_Member__c>();
           
           System.debug('List being tested: '+lstmems);
           
           lstmems=[SELECT OwnerId from List_Member__c where id= :lstmem.id];
           
           System.assertNotEquals(lstmems[0].id,null);
           System.assertEquals(lstmem.id,lstmems[0].id);
           System.assertNotEquals(lstmem.id,null); 
       }
       catch(exception e)
       {
           System.debug(e);
       }
          
    }     
}