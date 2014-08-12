/******************************************************************************
Name     : DeleteProductConfig
Purpose  : Delete related "Product Configs".
Author   : Deepesh Makkar
Date     : June 25, 2009
******************************************************************************/

trigger DeleteProductConfig on ProductRelease__c (before delete) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
    // Trigger Switch
    Boolean LX_Switch = false; 
    static integer index = 0;    
    // Get current profile custom setting.
    LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
    // Get current Organization custom setting.
    LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
    // Get current User custom setting.
    LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
    
    // Allow the trigger to skip the User/Profile/Org based on the custom setting values
    if(LXUser != null)
        LX_Switch = LXUser.Bypass__c;
    else if(LXProfile != null)
        LX_Switch = LXProfile.Bypass__c;
    else if(LXOrg != null)
        LX_Switch = LXOrg.Bypass__c;
    if(LX_Switch)
        return;    


  List <Product_Configuration__c> toDelete = new List<Product_Configuration__c>();
  
  for(List<Product_Configuration__c> configs : [Select id from Product_Configuration__c where ProductRelease__c in :Trigger.oldMap.keySet()] ) {
    if(toDelete.size() + configs.size() > 1000) {
      delete toDelete;
      toDelete = new List<Product_Configuration__c>();
    }
    
    toDelete.addAll(configs);
  }
  
  if(toDelete.size() > 0)
    delete toDelete;
}