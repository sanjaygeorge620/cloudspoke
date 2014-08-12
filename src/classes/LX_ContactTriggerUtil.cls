public class LX_ContactTriggerUtil {

    /* Class Name   : LX_ContactTriggerUtil 
    * Description   : This is a utility class to execute the general functionality from the contact triggers. 
    * Created By   : Gulzar
    * Created Date : 05-09-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Gulzar                05-09-2013                                      Initial Version
    * Anita Koshi           06-03-2013                                      Added Method verticalCheck()to validate Lexmark vertical in Contact

    */
 
 
 
    /* Description : Updates contact address
    * Param - lstContacts : List Of contacts to update 
    * Param - lstAccounts : dList of account ids
    * Returns :  VOID
    */
    public void updateContactAddress(List<Contact> lstContacts, List<Id> lstAccountIds)
    {
        //Declare variable to store Contact State .
        String strConvertedContactState;
        //Get account records and filter them for type as Internal, since the code is executing if type is Internal only.
        Map<ID, Account> mapAccountType = new Map<ID, Account>([select Id, Type from Account where id in :lstAccountIds and Type =: 'Internal']);
        //Check if map contains any data else return from here.
        if(mapAccountType == null || mapAccountType.size() <= 0) return;
        //Declare variable to store state value against name
        Map<String,String> mapConvertedAcctState = new Map<String,String>();
        //Get State values from Perceptive Config Value object by REF method
        LX_AccountTriggerUtil.getPerceptiveConfigDetails(mapConvertedAcctState);
        for (Contact  objContact : lstContacts){
            if(objContact.Accounting_Contact__c != true){                
                if((mapAccountType.get(objContact.AccountID)).Type != 'Internal'){  
                    if((objContact.MailingStreet != '' & objContact.MailingStreet != null)& objContact.MailingStreet != objContact.Physical_Street_Address__c){
                        objContact.Physical_Street_Address__c = objContact.MailingStreet;
                    } 
    
                    if((objContact.MailingCity != null  & objContact.MailingCity != '') & objContact.MailingCity != objContact.Physical_City__c){
                        objContact.Physical_City__c = objContact.MailingCity;
                    } 
     
                    if(objContact.MailingState != '' & objContact.MailingState != null) {
                        If((objContact.MailingCountry != 'United States' & (objContact.MailingCountry != 'USA' & objContact.MailingCountry != 'US') ) & objContact.Physical_Province__c != objContact.MailingState ){               
                            objContact.Physical_Province__c = objContact.MailingState;
                        }else {
                            system.debug('objContact.MailingState.length(): ' + objContact.MailingState.length());
                            if(objContact.MailingState.length() == 2){
                                strConvertedContactState = mapConvertedAcctState.get(objContact.MailingState);
                            }else{
                                strConvertedContactState = objContact.MailingState;
                            }
                            system.debug(strConvertedContactState);                                                    
                            if(strConvertedContactState != objContact.Address_Edit_States__c ){
                                objContact.Address_Edit_States__c = strConvertedContactState;
                            }
                        }
                    } 
                     
     
                    if((objContact.MailingPostalCode != '' & objContact.MailingPostalCode != Null) & objContact.MailingPostalCode != objContact.Physical_Postal_Code__c){
                        objContact.Physical_Postal_Code__c = objContact.MailingPostalCode;
                    }
     
                    if((objContact.MailingCountry != '' & objContact.MailingCountry != null) & objContact.MailingCountry != objContact.Address_Edit_Countries__c){
                        objContact.Address_Edit_Countries__c = objContact.MailingCountry;
                    } 
                    system.debug('objContact: ' + objContact); 
                 }  
            } 
         }
    }
    
    
    /*
     * (Before Delete)
     * Description : It permanently deletes the related action plans in the recycle bin and also deletes the other related action plans when contacts are deleted
     * Param - contactList : List of contacts getting deleted(Trigger.old) 
     * Returns : VOID
    */
    public void contactActionPlanDelete(List<Contact> contactList){
        
        //creating a list of ids of contacts
        List<ID>        contactIdList    = new List<ID>();
        List<String>    actionPlanIdList   = new List<String>();
        List<ActionPlan__c> actionPlanToBeDeletedList= new List<ActionPlan__c>();    
        
        //Delete related action plans
        
            for( Contact c : contactList ){
                contactIdList.add( c.Id );
            }
            
            /* GET Action Plans to delete from recycle bin */
            actionPlanToBeDeletedList = [ select Id, Name , LastModifiedDate from ActionPlan__c where Contact__c in : contactIdList and isDeleted = true ALL ROWS ];
            
            if ( actionPlanToBeDeletedList.size() >0 ){          
                Database.emptyRecycleBin(actionPlanToBeDeletedList);
            }           
            
            //List<ActionPlan__c> apList =  [ select Id from ActionPlan__c where Contact__c in : contactIdList ];
            for( ActionPlan__c ap : [ select Id from ActionPlan__c where Contact__c in : contactIdList ] ){
                actionPlanIdList.add( ap.Id );
            }
            
            if ( actionPlanIdList.size() >0 ){
                ActionPlansBatchDelete aPBatch = new ActionPlansBatchDelete(actionPlanIdList, Userinfo.getUserId());
                Database.ExecuteBatch( aPBatch );
            }           
        
        
    
     }
     
     /*
     * (After Undelete)
     * Description : To undelete the related action plans on undeleting contact and prevent undeleting an action plan whose associated contact is deleted
     * Param - contactList : List of contact getting undeleted(Trigger.new) 
     * Returns : VOID
    */
    public void contactActionPlanUnDelete(List<Contact> contactList)
     {
        //Undelete related action plans
        List<ID> contactIdList = new List<ID>();
        
        for( Contact c : contactList )
            {
                contactIdList.add( c.Id );
            }
        list <ActionPlan__c> actionPlanToBeUndeleted = [ select Id from ActionPlan__c where Contact__c in : contactIdList ALL ROWS ];
        
        try{
            if(ActionPlanObjectTriggerTest.isTest)
                {
                    //throw dmlException
                    insert new Contact();   
                }
            //undelete actionPlanToBeUndeleted;
            Database.undelete( actionPlanToBeUndeleted,false);
           } catch ( Dmlexception e )
            {
                for (Contact c: contactList)
                    {
                        c.addError('You can not undelete an action plan whose related object is deleted.');
                    }
            }
        
       
     }
     
     /*
     * (before insert)
     * Description : method to Map lead fields to Contact Standard fields when Lead is Converted
     * Param - contactList : List of contact(Trigger.new) 
     * Returns : VOID
     */
     public void leadFieldstoContactMap(List<Contact> contactList)
     {
        for(Contact c:contactList)
            {
                if(c.Lead_AA_Name_Map__c != Null)
                    {
                        c.AssistantName = c.Lead_AA_Name_Map__c;
                    }
                if(c.Lead_AA_Phone_Map__c != Null)
                    {
                        c.AssistantPhone =  c.Lead_AA_Phone_Map__c;
                    }
            }
        
       
     }
     
     /*
     * Description : Method checks for the unique default to valdiation on contact object.
     * Param - lstContacts : List of contact records
     * Param - lstContactIds : List of contact records whose Default Bill To is Checked
     * Param - lstContactAccountIds :  List of account records whose Default Bill To is Checked
     * Returns : VOID
     */
     public void checkUniqueDefaultToValidation(List<Contact> lstContacts,List<ID> lstContactIds,List<Id> lstContactAccountIds)
     {
        //Get the details from the 
        List<Contact> lstExistingContacts = [select id from Contact where AccountId in: lstContactAccountIds and Default_Bill_To__c = true and 
                                                                Id not in: lstContactIds];
                                                                
        //Check the size of the lsit 
        if(lstExistingContacts.size() > 0)   return;
        
        //Iterate the contacts and throw errors for each record since there is already a record with Default Bill To checked for same account in contact.
        for(Contact objContact : lstContacts)
            objContact.Default_Bill_To__c.addError('A Default Bill To already exists for this Account');
        
     }
   
    /*
     * Description : Method checks lexmark vertical for contact.
     * Param - lstContacts : List of contact records.
     * Returns : VOID
     */

     public void verticalCheck(List<Contact> listContact ){
        
         Set<Id> setAccountId = new Set<Id>();
         for(Contact crecord : listContact){
             setAccountId.add(crecord.AccountId);
         }
         Map<Id,Account> MapAccountCheck = new Map<Id,Account>([Select Industry,name from account where Id= :setAccountId]);
         for(Contact crecord :listContact){
            if ( MapAccountCheck.get(crecord.AccountId) != null && crecord.Industry__c!= null && MapAccountCheck.get(crecord.AccountId).Industry != null ) {
                if(MapAccountCheck.get(crecord.AccountId).Industry  != crecord.Industry__c){
                    if(!test.isRunningTest())
                        crecord.addError('The Contact\'s Vertical is not matching with that of Account. Please select ' + MapAccountCheck.get(crecord.AccountId).Industry +' for Account ' + MapAccountCheck.get(crecord.AccountId).Name);
                }
            }
        }// for(Contact crecord : listContact)
      }
 
 }