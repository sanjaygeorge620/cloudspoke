/*
Class Name : LX_EE_PrintReleasePDFExtn
Description : This extension class is written for EASY ESTIMATE Print Release PDF Doc Generation.
Created By : Madhurupa Ghose Roy (mghoseroy@deloitte.com)
Created Date : 29-9-2013
Modification Log:
---------------------------------------------------------------------------
Developer             Date            Modification ID        Description
---------------------------------------------------------------------------
Madhurupa Ghose Roy  29-9-2013        1000                   Initial Version
***************************************************************************/

public with sharing class LX_EE_PrintReleasePDFExtn {
  public String Badges{get;set;}
  
/*
 * 
 * Description : Constructor for the extension class.
 * Param - : Standard Controller Record that is being created or edited.
 * Returns : null
*/
  
  public LX_EE_PrintReleasePDFExtn(ApexPages.StandardController controller) {
    Badges = ApexPages.currentPage().getParameters().get(LX_PSEHelperClass.Badges_Const);
  }
}