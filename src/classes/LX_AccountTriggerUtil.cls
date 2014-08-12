public class LX_AccountTriggerUtil {

    /* Class Name   : LX_AccountTriggerUtil 
    * Description   : This is a utility class to do the basic functionlity from the account trigger
    * Created By   : Gulzar
    * Created Date : 08-05-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Gulzar          08-05-2013                                 Initial Version
    
    */
    
    /* Description : It accepts collection of account records and updates Physical Street Address, Physical City, Physical Province Other and Physical State.
    *  Param - lstAccounts : Collection of account records 
    *  Returns :  VOID
    */
    public void updateAccountAddress(List<Account> lstAccounts)
    {/*
       //Declare local variables which are in the method scope.
       string strConvertedAcctState;
       Map<String, String> mapConvertedAcctState = new Map<String, String>();
       //Get the records from Perceptive Config Value object for Config Option is "States" and add the to MAP.
       getPerceptiveConfigDetails(mapConvertedAcctState);
       
       //Iterate list of accounts and update address
       for (Account objAccount : lstAccounts) 
       {
            //if Billing Street <> "" & Billing Street <> physical address, Update physical Address = billing Street 
            if(objAccount.BillingStreet != null & objAccount.BillingStreet != objAccount.Physical_Street_Address__c){
                    objAccount.Physical_Street_Address__c = objAccount.BillingStreet;
            } 
            //if Billing city <> "" & Billing City <> physical city, Update physical city = billing City 
            if(objAccount.BillingCity != null & objAccount.BillingCity != objAccount.Physical_City__c){
                    objAccount.Physical_City__c = objAccount.BillingCity;
            } 
            if(objAccount.BillingState != '' & objAccount.BillingState != null) {
                    if((objAccount.BillingCountry != 'United States' & (objAccount.BillingCountry != 'USA' & objAccount.BillingCountry != 'US') )& 
                                                    objAccount.Physical_Province_Other__c != objAccount.BillingState ){             
                            objAccount.Physical_Province_Other__c = objAccount.BillingState;
                    }else {
                            system.debug('objAccount.BillingState.length(): ' + objAccount.BillingState.length());
                            if(objAccount.BillingState.length() == 2){
                                    try{
                                        if(mapConvertedAcctState != null && mapConvertedAcctState.containsKey(objAccount.BillingState)){
                                                strConvertedAcctState = mapConvertedAcctState.get(objAccount.BillingState);
                                                system.debug('converted account state' + strConvertedAcctState);
                                                system.debug('converted account state' + strConvertedAcctState);
                                        }else {
                                                ErrorLogUtility.createErrorRecord('ConvertedAcctStateMap not include Billing State','UpdateAccountAddress','Low',objAccount.BillingState);
                                        }                               
                                    }catch (Exception e){
                                        system.debug('in exception');
                                        ErrorLogUtility.createErrorRecord(e.getMessage(),'UpdateAccountAddress','Low',objAccount.BillingState);
                                    }                       
                                
                            }else{
                                    strConvertedAcctState = objAccount.BillingState;
                            }                           
                            if(strConvertedAcctState != objAccount.Physical_State__c ){
                                objAccount.Physical_State__c = strConvertedAcctState;
                            }
                        }
                    } 
                    //if Billing postal code <> "" & Billing postal code <> physical postal code, Update physical postal code = billing postal code 
                    if(objAccount.BillingPostalCode != null & objAccount.BillingPostalCode != objAccount.Physical_Postal_Code__c){
                        objAccount.Physical_Postal_Code__c = objAccount.BillingPostalCode;
                    }
                    //if Billing country <> "" & Billing postal code <> physical postal code, Update physical postal code = billing postal code 
                    if(objAccount.BillingCountry != null  & objAccount.BillingCountry != objAccount.Physical_Country__c){
                        objAccount.Physical_Country__c = objAccount.BillingCountry;
                    } 
                    system.debug('objAccount: ' + objAccount);        

                }
         */
    }
    /* Description : Gets the Perceptive Config records 
    *  Param - mapConvertedAcctState : This parameter id passed 'By Ref' method, adding the values in this map 
    *  Returns :  VOID
    */
    public static void getPerceptiveConfigDetails(Map<String, String> mapConvertedAcctState)
    {
        //Get the records from Perceptive Config Value object for Config Option is "States" and add the to MAP.
                                                            
       for(Perceptive_Config_Value__c objConfig : [select Name, Value__c 
                                                    from Perceptive_Config_Value__c 
                                                    where Perceptive_Config_Value__c.Perceptive_Config_Option__r.Name = 'States'])
       {
           mapConvertedAcctState.put(objConfig.Name, objConfig.Value__c);
        
       }

    }
    
    
    /*
     * (Before Delete)
     * Description : It permanently deletes the related action plans in the recycle bin and also deletes the other related action plans when accounts are deleted
     * Param - accountList : List of accounts getting deleted(Trigger.old) 
     * Returns : VOID
    */
    public void accountActionPlanDelete(List<Account> accountList)
    {

      set<ID>       accountIdset  = new set<ID>();
      List<String>  actionPlanIdList  = new List<String>();
      List<ActionPlan__c>  actionPlanToBeDeletedList = new List<ActionPlan__c>();
       
      
      
          for( Account a : accountList )
          {
             accountIdset.add( a.Id );
          }
  
          //GET Action Plans to delete from recycle bin 
          actionPlanToBeDeletedList = [ select Id, Name , LastModifiedDate from ActionPlan__c where Account__c in : accountIdset and isDeleted = true ALL ROWS ];
       
          if ( actionPlanToBeDeletedList.size() >0 )
          {       
             Database.emptyRecycleBin(actionPlanToBeDeletedList);
          }
  
          //Get all action plans associated with Accounts
          for( Account a : [Select (Select Id , isDeleted From Action_Plans__r) From Account a where Id in : accountIdset])
          {
             if (a.Action_Plans__r.size() >0 )
             {
                 for(ActionPlan__c ap :a.Action_Plans__r )
                 {          
                     actionPlanIdList.add(ap.Id);
                 }
             }
          }
      
          if ( actionPlanIdList.size() >0 )
          {     
             ActionPlansBatchDelete aPBatch = new ActionPlansBatchDelete(actionPlanIdList, Userinfo.getUserId());
             Database.ExecuteBatch( aPBatch );
          }
      
  
    }

    /*
     * (After Undelete)
     * Description : To undelete the related action plans on undeleting account and prevent undeleting an action plan whose associated account is deleted
     * Param - accountList : List of accounts getting undeleted(Trigger.new) 
     * Returns : VOID
    */
    public void accountActionPlanUnDelete(List<Account> accountList)
    {

        set<ID>   accountIdset  = new set<ID>();
        Database.UndeleteResult[] undelErrorsResult;
  
        //Undelete related action plans
  
    
        for( Account a : accountList )
            {
                accountIdset.add( a.Id );
            }
        list <ActionPlan__c> actionPlanList = [ select Id, Name , LastModifiedDate from ActionPlan__c where Account__c in : accountIdset and isDeleted = true ALL ROWS ];
       
        try{
               if(ActionPlanObjectTriggerTest.isTest)
               {
                   //throw dmlException
                   insert new Contact();  
               }
         
               undelErrorsResult =Database.undelete( actionPlanList,false);
           } catch ( Dmlexception e )
             {        
                 for (Account a: accountList)
                 {
                     a.addError('You can not undelete an action plan whose related object is deleted.');
                 }
             }
  
     }


    /*
     * (Before Update)
     * Description : To update the originating partner of the accounts from the related opportunity
     * Param : Trigger.new..list of accounts being updated
     * Returns : VOID
    */
    public void updateOriginatingPartner(List<Account> accountList, Map<id,Account> accountIdOldMap, Map<id,Account> accountIdNewMap)
     {
        Set<Id> accountIdSet = new Set<Id>();
        for(Account acc:accountList)
            {
                if(acc.Originating_Partner__c == null && acc.Type == 'Customer' && accountIdOldMap.get(acc.Id).Type == 'Prospect')
                {
                    accountIdSet.add(acc.Id);              
                }
            }
        Map<id, Account> accountMap = new Map<Id, Account>([Select Id,Originating_Partner__c ,(Select Primary_Partner__c,StageName From Opportunities where StageName = 'Closed Won' And Primary_Partner__c != null order by LastModifiedDate desc Limit 1) From Account where Id In: accountIdSet]); 
        for(Account acc: accountMap.values())
            {
                if(acc.Opportunities.size() > 0)
                    accountIdNewMap.get(acc.id).Originating_Partner__c = acc.Opportunities.get(0).Primary_Partner__c;
            }
        
      
     }
     
    /* Description : Generates Bill and Ship to details and creates case
    *  Param - lstAccounts : Collection of account records whose name is changed or updated 
    *  Returns :  VOID
    */
    public void createCaseWithBillDetails(List<Account> lstAccounts)
    {
        //Get the case help desk record id.
        String strCaseHelpDeskRcTyID = LX_SetRecordIDs.CaseHelpDeskRecordTypeId;
        //Check whether this record type is active or not.
        Boolean isActive = LX_SetRecordIDs.isActiveRecordType(strCaseHelpDeskRcTyID,'Case');
        Map<Id,Contact> mapAccoutingContacts = new Map<Id,Contact>([select Id, Accounting_Contact__c from Contact where AccountId in : lstAccounts and Accounting_Contact__c = true]);
        if((mapAccoutingContacts.values().size() > 0) && (isActive)){
            createCaseOnAccountingContact.createCase(mapAccoutingContacts.keySet(), Id.valueOf(strCaseHelpDeskRcTyID));
        }
        else if(mapAccoutingContacts.values().size() > 0){
         ID recordTypeId = [select Id, Name from RecordType where Name = 'Master Record' and SobjectType in ('Case') and isActive = true limit 1].Id;
         createCaseOnAccountingContact.createCase(mapAccoutingContacts.keySet(), recordTypeId);
       }

    }
    
    /*
     * (Before Update,Insert)
     * Description : set the user name on the account based on the sector/region from the Config Table
     * Param : accountList(Trigger.new)
     * Returns : VOID
    */
    public void updateCSA(List<Account> accountList)
     {
        //Update Matches by Sector -  NOTE THE SORT: Region is last
        if( FirstRun_Check.FirstRun_UpdateCSA)
            {
                for(Perceptive_Config_Value__c ConfigRecords : [Select p.Name, p.Value__c, p.Perceptive_Config_Option__r.Name 
                                                                From Perceptive_Config_Value__c p 
                                                                where p.Perceptive_Config_Option__r.Perceptive_Config_Group__r.key__c = 'Account_Settings' and
                                                                (p.Perceptive_Config_Option__r.Name = 'CSA-Sector' or
                                                                p.Perceptive_Config_Option__r.Name = 'CSA-Region')
                                                                order by p.Perceptive_Config_Option__r.Name desc
                                                                ])
                //Above query will always return only 2 records
                {
                    for (Account Accounts : accountList)
                        {
                            //set by region 
                            if(ConfigRecords.Perceptive_Config_Option__r.Name=='CSA-Region' && ConfigRecords.name==Accounts.Region__c){
                                Accounts.CSA__c = ConfigRecords.Value__c;  
                            //set by sector
                            }else if(ConfigRecords.Perceptive_Config_Option__r.Name=='CSA-Sector' && ConfigRecords.name==Accounts.sector__c){
                                Accounts.CSA__c = ConfigRecords.Value__c;  
                            }
                        }
                
                }
                FirstRun_Check.FirstRun_UpdateCSA = false;
            }
     }
    

}