// THIS CODE IS NOT FINAL
public class LX_ChildAccount_Extension
 {

    public LX_ChildAccount_Extension(ApexPages.StandardController controller)
    {

    }
    public List<Account> getChidAccountList()  
    
      {      
      String theId = ApexPages.currentPage().getParameters().get('id');
      return [ select Id,name ,LX_Default_Bill_To__c,LX_SMSA__c,LX_Collection__c from account where parentid=:theId];
      }  
}