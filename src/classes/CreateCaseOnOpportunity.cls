//
// (c) 2010 Appirio , Inc.  pbondalapati@appirio.com
//
//   Create a case if opportunity stage is equal to prospecting and account record type is equal to prospect unlocked 
//
// 12/08/2010 created
//
public class CreateCaseOnOpportunity{

   /* This method checks opportunity Stage and returns true if Opportunity Stage is 'Prospecting' or 'Negotiation' or 'Closed Won' */

    public static boolean isCaseCreationRequired(String newStage , String oldStage){
        Boolean isRequired = false;
        //VT: changed the stagename based on the new stage map
        if(newStage != null 
            && (newStage != oldStage) 
            && (newStage.equals('Qualifying')|| newStage.equals('Closing') || newStage.equals('Closed Won') )){
            isRequired = True;
        }
        return isRequired;
    }
    
    
    
    public static boolean isCaseCreatedInThread = false; 
    
    /* This method is called up on after insert or update on opportnity */
    
    public static void afterInsertUpdate(Set<Id> opportunityIdSet){
            system.debug('calling createcases - in class');
            createCases(opportunityIdSet);
        
    } 
    
    
    /* This method creates cases on the basis of opportunity */
    
    @future
    public static void createCases(Set<Id> opportunityIdSet){
        Map<Id, Account> accountMap = new Map<Id,Account>();
        Map<Id,Id> opportunityAccountIdMap = new Map<Id,Id>();
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
        List<Case> caseToBeInsert = new List<Case>();
        Id recordTypeId;
        Id accountRecordTypeId;
        id accountRecordTypeId_Customer;
        id accountRecordTypeId_Internal;
        id accountRecordTypeId_PartnerLocked;        
        id accountRecordTypeId_PartnerUnlocked;
        system.debug('in createsCases: ');
        Case newCase;
        //new Case is assigned to a queue (Helpdesk.MDM Portal) so find id of this queue
        Id queueId = loadQueueId();
        system.debug('after load queue');
        // find contact Id on the basis of login user's email Id 
        Id contactId = loadContactId();
        system.debug('after load contact');

  
    /*   for(RecordType rt : [Select SobjectType, Name, Id, DeveloperName from RecordType 
                                                                         where Name in ('HelpDesk', 'Prospect Locked', 'Customer', 'Internal','Partner Locked','Partner Unlocked')  
                                                                         and SobjectType in ('Case', 'Account') ]){
    */
                        // case record type
      //     if(rt.SobjectType.equals('Case') && rt.Name.equals('HelpDesk')){
                recordTypeId = Lx_SetRecordIDs.CaseHelpDeskRecordTypeId;  //  rt.id ; 
       //     }
      //       Account Record Type - Prospect Locked
      //     else if(rt.SobjectType.equals('Account') && rt.Name.equals('Prospect Locked')){
                accountRecordTypeId = Lx_SetRecordIDs.AccountProspectLockedRecordTypeId;  // rt.id
       //    }
        //     Account Record Type - Customer
         //   else if(rt.SobjectType.equals('Account') && rt.Name.equals('Customer')){ 
                accountRecordTypeId_Customer = Lx_SetRecordIDs.AccountCustomerRecordTypeId;  // rt.id;
       //     }
       //     else if(rt.SobjectType.equals('Account') && rt.Name.equals('Internal')){
                accountRecordTypeId_Internal = Lx_SetRecordIDs.AccountInternalRecordTypeId;   
                accountRecordTypeId_PartnerLocked = Lx_SetRecordIDs.AccountPartnerLockedRecordTypeId;
                accountRecordTypeId_PartnerUnlocked = Lx_SetRecordIDs.AccountPartnerUnlockedRecordTypeId;
       //     }
            
     //  }   
        
        try{
            list<Opportunity> listOfOpportunity = database.query('select Id,Name,Account.RecordTypeId, Account.RecordType.Name, AccountId, Account.Name, Account.Company_Number__c , StageName from Opportunity where id in : opportunityIdSet');
            
            // find the opportunities whose Account Record Types 
            for(Opportunity opportunity :listOfOpportunity){ 
            
            /*[select Id 
                                                , Name 
                                                , Account.RecordTypeId
                                                , Account.RecordType.Name 
                                                , AccountId
                                                , Account.Name
                                                , Account.Company_Number__c 
                                                , StageName 
                                                from Opportunity 
                                                where id in : opportunityIdSet]){
              */                                              
                system.debug('opportunity: ' + opportunity);
                system.debug('Account.RecordRype.Name' + Account.RecordType.Name);
                //only create cases for those opporutnities that have an account record type = 'Prospect Unlocked'
                if (opportunity.Account.RecordType.Name == 'Prospect Unlocked'){    
                    newCase = createCase(opportunity,queueId,recordTypeId,contactId);
                    system.debug('new case: ' + newCase);
                    caseToBeInsert.add(newCase);
                }   
                
                //check to see what account information should be updated
                //any opportunity stagename = 'Closed Won' - update account type, account recordtype
                //any opporutnity stagename = 'Negotiation'/'Prospecting' - update account record type
                // if any opportunity.account.Record type = 'Internal' or 'Partner Locked' or 'Partner Unlocked' - do nothing.
                system.debug('opportunity.Account.RecordTypeId:' + opportunity.Account.RecordTypeId);
                system.debug('internal record type id: ' + opportunity.Account.RecordTypeId);
               if(opportunity.Account.RecordTypeId <> accountRecordTypeId_Internal&&opportunity.Account.RecordTypeId <> accountRecordTypeId_PartnerLocked&&opportunity.Account.RecordTypeId <> accountRecordTypeId_PartnerUnlocked){
                        if(accountRecordTypeId != null && !accountMap.containsKey(opportunity.AccountId)){
                        system.debug('Opportunity.StageName'+ Opportunity.StageName);
                        if(Opportunity.StageName == 'Closed Won'){
                            opportunity.Account.RecordTypeId  = accountRecordTypeId_Customer;           //sets acct record type = 'Prospect Locked'
                            opportunity.Account.Type = 'Customer';
                            system.debug('setting customer');
                        }else if(opportunity.Account.RecordTypeId <> accountRecordTypeId_Customer){
                          opportunity.Account.RecordTypeId  = accountRecordTypeId;          //sets acct record type = 'Prospect Locked'
                          system.debug('setting prospect locked');
                        }
                        accountMap.put(opportunity.AccountId, opportunity.Account);
                    }    
                }
            }
            if(caseToBeInsert.size() > 0){
                insert caseToBeInsert;
            }
            // update Accounts (update Record Type Prospect UnLocked -> Prospect Locked )
            update accountMap.values();
        }catch(Exception ex){
            System.debug('Excepiton :'+ex.getMessage());
        }
        
        
    }
   
    /* 
     This method find the Queue Id on the basis :
     Queue Name = HelpDesk.MDM Portal
     SObjectType = Case 
    */
    public static Id loadQueueId(){
        Id queueId;
     //   for(QueueSobject qu : [Select sobjectType, Queue.Name, QueueId, Id from QueueSobject  where Queue.Name = 'HelpDesk.MDM Portal' and SobjectType ='Case' limit 1]){
            queueId = Lx_SetRecordIDs.HelpDeskMDMPortalQId;//qu.QueueId;
    //    }
        return queueId;
    }
    
    /*
     This method find the Contact Id on the basis :
      Contact EMail = Login User's EmailId
    */
    public static Id loadContactId(){
        Id contactId;
        String emailId;
        for(User usr : [select Id ,ContactId, Email from User where id = : userInfo.getUserId() limit 1]){
            system.debug('usr: ' + usr);
            emailId = usr.Email;              
        }
        for(Contact con : [select Id from Contact where Email = : emailId limit 1]){
            contactId  = con.id;
        }
        system.debug('contactID: ' + contactID);
        return contactId;
    }
    
    /*
        This method create case reference where
        Type : Request
        Category : MDM Portal
        Level 1 : Prospect
        Subject : Submit account to MDM Portal
        CaseOwner : Queue:HelpDesk.MDM Portal 
        Recordtype : HelpDesk
        Contact Name : User that changed the opportunity stage to Prospecting
        Description  :  Account Name: <Account Name related to Opportunity>
                        Company Number: <Company Number of Account related to Opportunity>
                        Link: <url to Account related to Opportunity>
        
    */
    public static Case createCase(Opportunity opportunity,Id queueId,Id recordTypeId,Id contactId){
        Case newCase =  new Case(Type = 'Request', Level_1__c = 'Prospect',Category__c = 'MDM Portal', Subject ='Submit account to MDM Portal');
        if(queueId != null){
            newCase.ownerId = queueId;
        }
        if(recordTypeId != null){
            newCase.RecordTypeId = recordTypeId;
        }
        if(contactId != null){ 
            newCase.ContactId  = contactId;
        }
        string companyNumber; 
         
         if(opportunity.Account != null && opportunity.Account.get('Company_Number__c') != null ){
            companyNumber = string.valueof(opportunity.Account.get('Company_Number__c'));
         }else{
            companyNumber = '';
         }
        
        newCase.Description = 'Account Name : '+ opportunity.Account.Name +'\n'
                                  + 'Company Number : '+companyNumber +'\n'
                                  +'Account : '+ System.Label.OrganizationURL +'/'+ opportunity.AccountId;
     system.debug('return new case: ' + newCase);                             
     return newCase;
                
    }
    
    static testmethod void m1(){
        Account acc = createAccount();
        Opportunity opp = createOpportunity(acc.Id);
        CreateCaseOnOpportunity.isCaseCreationRequired('Closed Won','Prospecting');
        CreateCaseOnOpportunity.afterInsertUpdate(new Set<Id>{opp.Id});
        Id conId = CreateCaseOnOpportunity.loadContactId();
        Id qId = CreateCaseOnOpportunity.loadQueueId();
        Id recId = [Select Id from RecordType where sObjectType='Case' and name='Admin'].Id;
        CreateCaseOnOpportunity.createCases(new Set<Id>{opp.Id});
        CreateCaseOnOpportunity.createCase(opp,qId,recId,conId);
    }
      public static Opportunity createOpportunity(String accId){
      List<Contact> contacts = new List<Contact>(); 
      contacts.add(new Contact(LastName = 'Test',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_Contact__c=true,Status__c='Active'));
      contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_Contact__c=true,Status__c='Active'));
      insert contacts;
        
      Opportunity opp =  new Opportunity();
      opp.AccountId = accId;
      opp.Name = 'Opportunity4TestMethod';
      opp.CloseDate = Date.today().addDays(10);
      opp.StageName = 'Negotiation';
      opp.Type = 'Renewal';
      opp.QAStatus__c = 'New';
      opp.Ship_To__c  = contacts.get(0).Id;
      opp.Bill_To__c  = contacts.get(0).Id;
      opp.Technology__c = true;
      opp.LX_Sales_Type__c = 'Add On';
      insert opp;
      return opp;
    }
    public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.Physical_Country__c = 'Australia';
        acc.BillingCountry = acc.Physical_Country__c;
        acc.MDM_Sold_To_Number__c = '1234';
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId(); 
        insert acc;
        return acc;
    }
}