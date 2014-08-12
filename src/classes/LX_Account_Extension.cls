public class LX_Account_Extension
 {

    public LX_Account_Extension(ApexPages.StandardController controller)
    {

    }
      public List<Account> getChidAccountList()    
      {      
          String sId = ApexPages.currentPage().getParameters().get('id');
          return [ select Id,name ,LX_Default_Bill_To__c,LX_SMSA__c,LX_Collection__c from account where parentid=:sId limit :Limits.getLimitDMLRows()];
      } 
      public List<Contact> getContactList()    
      {      
          String sId = ApexPages.currentPage().getParameters().get('id');
          return [ select Id,Name,Title,Job_Role__c, Phone,Email,Portal_User_Type__c,status__c from contact where accountid=:sId and status__c='Active' limit :Limits.getLimitDMLRows()];
      } 
}