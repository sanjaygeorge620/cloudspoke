/*
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 5/16/2013
 *
 * Author : Akanksha Gupta
 * 
 * Description : This class is used to capture the exceptions occurring in the application into the system.
 *
 */
 public class LX_CommonUtilities {
  public static boolean lX_ByPass = false;
 public static boolean lX_Oppt_ByPass = false;
 static Map<String, Schema.RecordTypeInfo> mapRecordTypes;
 Public Static List<pse__Permission_Control__c> perControlList = new List<pse__Permission_Control__c>();
/*
 *
 * Description : This function is used for inserting the exception occurred into the system.
 * Param - Exception Record ex
 * Returns :  None.
 *
*/

    public static void createExceptionLog(exception ex)
    {
                string exceptionDescription = 'Exception Description:'+ex.getMessage()+'\n'+
                'Exception Type:'+ex.getTypeName()+'\n'+
                'Exception StackTrace:'+ex.getStackTraceString();
                insert (new LX_Exceptions_Log__c(LX_Exception_Description__c= exceptionDescription )); 
    }

 /*
 *
 * Description : This function is used for inserting the exception occurred into the system.
 * Param - String ex:containing the description of the exception occurred. 
 * Returns :  None.
 *
*/

    public static void createExceptionLog(string ex){
                string exceptionDescription = ex;
                insert (new LX_Exceptions_Log__c(LX_Exception_Description__c= exceptionDescription )); 
    }
    
   public static boolean ByPassBusinessRule()
    {   
        // Get current profile custom setting.
        LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
        // Get current Organization custom setting.
        LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
        // Get current User custom setting.
        LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
        
        // Allow the trigger to skip the User/Profile/Org based on the custom setting values
        if(LXUser != null)
        {
            lX_ByPass = LXUser.Bypass__c;
            lX_Oppt_ByPass = LXUser.LX_Opt__c;
        }
        else if(LXProfile != null)
        {
            lX_ByPass = LXProfile.Bypass__c;
            lX_Oppt_ByPass = LXProfile.LX_Opt__c;
        }
        else if(LXOrg != null)
        {
            lX_ByPass = LXOrg.Bypass__c;
            lX_Oppt_ByPass = LXOrg.LX_Opt__c;
        }
        
        return lX_ByPass;
    }
    
    /*
    *Description : Method used get the record type id based on the record type name.
    */
    public static Id GetRecordTypeId(string strRecordTypeName){
          
         // get the describtion of the SObject like Record type
         if(mapRecordTypes == null){
             schema.Describesobjectresult sobjdescribe = Opportunity.sObjectType.getDescribe();
             // Fetch the Record type info
             mapRecordTypes = sobjdescribe.getRecordTypeInfosByName();
         }  
         Schema.Recordtypeinfo objRecordTypeInfo;
         objRecordTypeInfo = mapRecordTypes.get(strRecordTypeName);
         system.debug('objRecordTypeInfo '+objRecordTypeInfo +'********'+'strRecordTypeName'+strRecordTypeName);
         return objRecordTypeInfo.getRecordTypeId();
         }
    
    Public Static void createPermissionCont(Set<ID> resources1 , Set<ID> projects1, ID userids)
    {
    for(ID id1 :resources1){
         pse__Permission_Control__c perControl = new pse__Permission_Control__c();
         perControl.pse__User__c = userids;          
         perControl.pse__Resource__c = id1;
         perControl.pse__Staffing__c
           = perControl.pse__Expense_Entry__c
           = perControl.pse__Expense_Ops_Edit__c
           = perControl.pse__Timecard_Entry__c
           = perControl.pse__Timecard_Ops_Edit__c
           = perControl.pse__Billing__c
           = perControl.pse__Invoicing__c
           = true;
         perControlList.add(perControl);
    }
             
        for(ID id1 :projects1){
         pse__Permission_Control__c perControl = new pse__Permission_Control__c();
         perControl.pse__User__c = userids;          
         perControl.pse__Project__c = id1;
         perControl.pse__Staffing__c
           = perControl.pse__Expense_Entry__c
           = perControl.pse__Expense_Ops_Edit__c
           = perControl.pse__Timecard_Entry__c
           = perControl.pse__Timecard_Ops_Edit__c
           = perControl.pse__Billing__c
           = perControl.pse__Invoicing__c
           = true;
         perControlList.add(perControl);
        }
        insert perControlList;
    }
    
 }