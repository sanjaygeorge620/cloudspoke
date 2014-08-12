@isTest(seealldata = true)
private class testlastViewed_RA   {

   public static testmethod void RAlastrev () {
   
 Remote_Access__c remacc = new Remote_Access__c();
   Account acc = Data_Account.createAccount3();
   remacc.Name = 'test';
   remacc.Account__c = acc.Id;
   insert remacc;
    
  ApexPages.StandardController sc = new ApexPages.standardController(remacc);
     lastViewed_RA lvr = new  lastViewed_RA(sc);
   
   String str = lvr.getLongDate();
   lvr.cDT = System.today();
   
   lvr.updateField();
  
   }
   
 }