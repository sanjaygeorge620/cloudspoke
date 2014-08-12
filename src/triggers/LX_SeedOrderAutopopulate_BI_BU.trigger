/*********************************************************************************************************************************************
    * Trigger Name   : LX_SeedOrderAutopopulate_BI_BU
    * Description    : Trigger is written for two events : Before Insert and Before Update.
    * Created By     : Nam Saxena, Veenu Trehan, Madhurupa Roy
    * Created Date   : 06-28-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Madhurupa Roy           06-28-2013               1000                  Initial Version   
    * Sumedha Kucherlapati    09-13-2013               1001                  Added logic in "LX_UpdateAccountID_on_SOR_BI_BU" trigger to 
    *                                                                         this trigger and commented code and made few changes to merge two triggers
    * Bhanu Prakash           09-07-2013               1002                  Added the funcationality for PSW Demo record Type
**********************************************************************************************************************************************/ 

trigger LX_SeedOrderAutopopulate_BI_BU on LX_Seed_Order_Request__c (before insert,before update,after insert, after update) {
    // Variable to store seed order Contact id 
    set<Id> conSeedID = new set<Id>();
    // Variable to store seed order Account id
    set<Id> accSeedID = new set<Id>();
    // Variable to store seed order Opportunity id 
    set<Id> oppSeedID = new set<Id>();
    Map<Id,Contact> conMap = new Map<Id,Contact>();
    Map<Id,Account> accMap = new Map<Id,Account>();
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
    // List to store the Opportunity to be updated (For PSW Demo)
    //List<Opportunity> oppToUpdate = new List<Opportunity>();
    MAP<ID,Opportunity> oppToUpdate = new Map<ID,opportunity>();
    // Variable to store the opportunities IDs
    set<Id> oppSeedIDs = new set<Id>();
    String EvaluationUnitPSWDemoRecordTypeId = LX_Seed_Order_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('EvaluationUnitPSWDemoRecordType')!=null?Lx_SetRecordIDs__c.getAll().get('EvaluationUnitPSWDemoRecordType').Value__c:'').getRecordTypeId();
    if(Trigger.isBefore &&(Trigger.isInsert ||Trigger.isUpdate)) {  
    for(LX_Seed_Order_Request__c seedRec :trigger.new) {
       if(seedRec.RecordTypeid!=EvaluationUnitPSWDemoRecordTypeId ){
       System.debug('Inside Loop');
           if(seedRec.LX_Account_Id__c != null){
               accSeedID.add(seedRec.LX_Account_Id__c);
            }
            if(seedRec.LX_Contact__c != null){
               conSeedID.add(seedRec.LX_Contact__c);
            }
            if(seedRec.LX_Opportunity__c != null){
               oppSeedID.add(seedRec.LX_Opportunity__c);
            }
        }
        else{
             if(Trigger.isInsert)
             seedRec.LX_Demo_Status__c = 'New';  
        }
    }    
    if(conSeedID!=null){
       conMap = new Map<Id,Contact>([SELECT Phone,AccountID from Contact where id in: conSeedID]);
    }
    if(accSeedID!=null){
        accMap = new Map<Id,Account>([SELECT BillingStreet,BillingState,BillingCity,BillingCountry,BillingPostalCode from Account where id in: accSeedID]);
    }
    if(oppSeedID!=null){
        oppMap = new Map<Id,Opportunity>([SELECT AccountId from Opportunity where id in :oppSeedID]);
    }
   
     for(LX_Seed_Order_Request__c seedRec1 : Trigger.new){  
          
            if(Trigger.isInsert && seedRec1.LX_Contact_Phone__c == null && conMap.containsKey(seedRec1.LX_Contact__c)){
              // Checking if the contact phone on Seed is NULL, if yes populating the corresponding contact's Phone number
               seedRec1.LX_Contact_Phone__c = conMap.get(seedRec1.LX_Contact__c).Phone;
            }
          
          // Checking if any of the address fields in seed order request is Null and if yes, populating the corresponding accounts address value in them
            if(Trigger.isInsert && accMap.containsKey(seedRec1.LX_Account_Id__c)){
             if(seedRec1.LX_Mailing_Street__c == null){
                seedRec1.LX_Mailing_Street__c = accMap.get(seedRec1.LX_Account_Id__c).BillingStreet;
             }
             if(seedRec1.LX_Mailing_City__c == null){
                seedRec1.LX_Mailing_City__c = accMap.get(seedRec1.LX_Account_Id__c).BillingCity;
             }
             if(seedRec1.LX_Mailing_State_province__c == null){
                seedRec1.LX_Mailing_State_province__c = accMap.get(seedRec1.LX_Account_Id__c).BillingState;
             }
             if(seedRec1.LX_Mailing_Zip_Postal_Code__c == null){
                seedRec1.LX_Mailing_Zip_Postal_Code__c = accMap.get(seedRec1.LX_Account_Id__c).BillingPostalCode;
             }
             if(seedRec1.LX_Mailing_Country__c == null){
                seedRec1.LX_Mailing_Country__c = accMap.get(seedRec1.LX_Account_Id__c).BillingCountry;
             }
            }
            // Populate the seed order Account with corresponding Oppportunity's Account
             if( seedRec1.LX_Opportunity__c != null && oppMap.containsKey(seedRec1.LX_Opportunity__c)){
                 seedRec1.LX_Account__c = oppMap.get(seedRec1.LX_Opportunity__c).AccountID;
               // Checking if the Account related to Seed order request's contact and opportunity are same or not. If not throwing error
                if(seedRec1.LX_Contact__c != null && conMap.containsKey(seedRec1.LX_Contact__c) && conMap.get(seedRec1.LX_Contact__c).AccountID != oppMap.get(seedRec1.LX_Opportunity__c).AccountID) {
                     seedRec1.addError('This contact does not belong to this Seed Order Account');                
                }
             }
         }
    }
    
     if(Trigger.isafter &&(Trigger.isInsert ||Trigger.isUpdate)) { 
        for(LX_Seed_Order_Request__c seedRec :trigger.new)
        {
            if(seedRec.LX_Opportunity__c != null)
            {
               oppSeedID.add(seedRec.LX_Opportunity__c);
            if(seedRec.RecordTypeid==EvaluationUnitPSWDemoRecordTypeId && seedRec.LX_Demo_Type__c=='Try and Buy')
                oppToUpdate.put(seedRec.LX_Opportunity__c,new Opportunity(id=seedRec.LX_Opportunity__c,LX_Demo__c=true)); 
            else if(seedRec.RecordTypeid==EvaluationUnitPSWDemoRecordTypeId && seedRec.LX_Demo_Type__c=='Standard Demo' )
                oppToUpdate.put(seedRec.LX_Opportunity__c,new Opportunity(id=seedRec.LX_Opportunity__c,LX_Demo__c=false)); 
            }
        }
        
        List<opportunity> oppEvaUnits = [Select LX_Cost_Center__c , (select LX_Cost_Center__c from Seed_Order_Requests__r where recordtypeid =:EvaluationUnitPSWDemoRecordTypeId order by LastModifiedDate  desc limit 1) from opportunity where id in : oppSeedID];
     
        for(opportunity oppRec : oppEvaUnits)
        {
            Opportunity opp;
            if(oppRec.Seed_Order_Requests__r.size()>0)
            {
                if(oppToUpdate.containskey(oppRec.id))
                {
                opp =oppToUpdate.get(oppRec.id);
                opp.LX_Cost_Center__c =oppRec.Seed_Order_Requests__r[0].LX_Cost_Center__c;
                }
                else 
                opp = new Opportunity(id=oppRec.id,LX_Cost_Center__c =oppRec.Seed_Order_Requests__r[0].LX_Cost_Center__c);
                oppToUpdate.put(oppRec.id,opp);
            }
                
        }
    }
 
   if(oppToUpdate.size()>0){
       try{     
           update oppToUpdate.values();  
       }catch(exception e){
           system.debug(e.getmessage());
           LX_CommonUtilities.createExceptionLog(e);
       }
   }
 
    
  
 
  }