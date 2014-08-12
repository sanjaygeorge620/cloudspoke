@isTest
private class Test_ChangeListMemberOwner{
  static testMethod void checkSubscribedListOnwer(){     
         List_Member__c lstmem = Data_ListMember.createListMember();
         List<List_Member__c> lstmems = new List<List_Member__c>();      
         lstmems=[SELECT OwnerId,Subscribed_List_Owner__c from List_Member__c where id= :lstmem.id];
        //VT 8/25 COmmented system.assertnotEquals(lstmems[0].Subscribed_List_Owner__c,null);
       }
}