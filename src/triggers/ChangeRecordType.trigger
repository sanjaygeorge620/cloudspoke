/**************************************************************
Trigger Name   : ChangeRecordType
Created by   : Srikanth Seela
Created Date : June 23rd, 2011
Modified By : Sneha
Modified Date : 26/Sep/2013
Purpose      : 
               When a Lead Record of type 'Unlocked' is created or updated with Partner Type equal to 
                1.Partner-Channel Level 1
                2.Partner-Channel Level 2
                3.Partner-Channel Level 3
                4.Partner-OEM 
               AND Primary Partner changed
               Find all lead records,
               where the Company equals the Company and Primary Partner = null and Record Type = Unlocked.
               For each such Lead record apply the following: 
               1.Change record type to Locked
               2.Update Associated Partner with value from Channel Partner. 
               3.Update Contract Begin Date with today's date. 
               Modified to add code to automate the submission of Lead record for approval on save.
***************************************************************/
trigger ChangeRecordType on Lead (after insert,after update) {
    
//static boolean firstRun = true;
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code

    //Fetch the record type id's for Lead record type "Locked" and "Unlocked"
    
    //list<RecordType> lockedRecordType =  [SELECT Id FROM RecordType where Name = 'Locked' and SobjectType='Lead'];
    //System.debug('Locked Record Type Details: '+lockedRecordType);
    //String lockedRecordTypeId = lockedRecordType[0].Id;
    String lockedRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get('Locked').getRecordTypeId(); 
    //list<RecordType> unlockedRecordType =  [SELECT Id FROM RecordType where Name = 'Unlocked' and SobjectType='Lead'];
    //System.debug('Unlocked Record Type Details: '+unlockedRecordType);
    //String unlockedRecordTypeId = unlockedRecordType[0].Id;
    String unlockedRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get('Unlocked').getRecordTypeId(); 
    // Declare the list
    List<Lead> leadsToLock = new List<Lead>();
    List<String> companyList = new List<String>();
    //Create a list of Companies
    for(Lead lo:Trigger.New){
        companyList.add(lo.Company);
    }
   //company =:lo.Company and 
   if(Trigger.isUpdate){
        
        leadsToLock = [Select Name,company, recordtypeid, rrpu__Alert_Message__c from lead 
                                       where 
                                       partner_type__c=null
                                       and 
                                       IsConverted=False
                                       and
                                       RecordTypeId !=:lockedRecordTypeId
                                       and Company IN :CompanyList];
   
   
    For(Lead lo:Trigger.New){  
         
          Lead l=System.Trigger.oldMap.get(lo.Id);
          
         if(lo.Partner_Approved__c=='Approved'&&(lo.Partner_Type__c=='Partner-Channel Level 1'||lo.Partner_Type__c=='Partner-Channel Level 2'||lo.Partner_Type__c=='Partner-Channel Level 3'||lo.Partner_Type__c=='Partner-OEM')&&(lo.Primary_Partner__c!=l.Primary_Partner__c||lo.Primary_Partner__c!=null))
         {
             //System.debug('The partner type is '+ lo.Partner_Type__c+' and the Primary Partner info has changed from '+l.Primary_Partner__c+' to '+lo.Primary_Partner__c);
             //System.debug('Searching for Leads with Company equal to '+lo.Company);
             
             //Fetch lead records to lock
             //Moved outside the for loop
            /* List<Lead> leadsToLock = [Select Name,company,recordtypeid,rrpu__Alert_Message__c from lead 
                                       where 
                                       company =:lo.Company
                                       and 
                                       partner_type__c=null
                                       and 
                                       IsConverted=False
                                       and
                                       RecordTypeId !=:lockedRecordTypeId]; */
             if(leadsToLock!=null){
             
                 //System.debug('Leads to Lock: '+leadsToLock);
                 
                     //For each record
                    /* for(integer i=0;i<leadsToLock.size();i++){
                         // 1.Change record type to Locked
                         leadsToLock[i].RecordTypeId=lockedRecordTypeId;
                         // 2.Update Associated Partner with value from Channel Partner. 
                         leadsToLock[i].Partner__c=lo.Primary_Partner__c;
                         // 3.Update Contract Begin Date with today's date. 
                         leadsToLock[i].Locked_Date__c=system.today(); 
                         //Set Pop-up message
                         LeadsToLock[i].rrpu__Alert_Message__c='Partner Restricted Lead'; 
                     }*/  
                     
                     //Changed loop
                     for(Lead le : leadsToLock){
                     
                     //Check if the company is same
                        if(lo.Company.equals(le.company))
                        {                               
                             // 1.Change record type to Locked
                             le.RecordTypeId=lockedRecordTypeId;
                             // 2.Update Associated Partner with value from Channel Partner. 
                             le.Partner__c=lo.Primary_Partner__c;
                             // 3.Update Contract Begin Date with today's date. 
                             le.Locked_Date__c=system.today(); 
                             //Set Pop-up message
                             le.rrpu__Alert_Message__c='Partner Restricted Lead'; 
                        }
                     } 
                     System.debug('@@@@@ Update LeadsToLock '+leadsToLock); 
                     update leadsToLock;   
             }                          
                                
            
         }
         
    } 
   }
   else{
   
    leadsToLock = [Select Name,company, recordtypeid, rrpu__Alert_Message__c from lead 
                                       where 
                                       partner_type__c=null
                                       and 
                                       IsConverted=False
                                       and
                                       RecordTypeId !=:lockedRecordTypeId
                                       and Company IN :CompanyList];
     
   
    For(Lead lo:Trigger.New){
          
         if(lo.Partner_Approved__c=='Approved'&&(lo.Partner_Type__c=='Partner-Channel Level 1'||lo.Partner_Type__c=='Partner-Channel Level 2'||lo.Partner_Type__c=='Partner-Channel Level 3'||lo.Partner_Type__c=='Partner-OEM')&&lo.Primary_Partner__c!=null)
         {
             //System.debug('The partner type is '+ lo.Partner_Type__c+' and the Primary Partner info has changed from null to '+lo.Primary_Partner__c);
             //System.debug('Searching for Leads with Company equal to '+lo.Company);
             
             //Moved outside the for loop
             /*List<Lead> leadsToLock = [Select Name,company,recordtypeid,rrpu__Alert_Message__c from lead 
                                       where 
                                       company =:lo.Company
                                       and 
                                       partner_type__c=null
                                       and 
                                       IsConverted=False
                                       and
                                       RecordTypeId !=:lockedRecordTypeId];*/
             if(leadsToLock!=null) {    
                                  
                  //System.debug('Leads to Lock: '+leadsToLock);
                     
                         //For each record
                         /*for(integer i=0;i<leadsToLock.size();i++){
                             // 1.Change record type to Locked
                             leadsToLock[i].RecordTypeId=lockedRecordTypeId;
                             // 2.Update Associated Partner with value from Channel Partner. 
                             leadsToLock[i].Partner__c=lo.Primary_Partner__c;
                             // 3.Update Contract Begin Date with today's date. 
                             leadsToLock[i].Locked_Date__c=system.today();
                             //Set Pop-up message
                             LeadsToLock[i].rrpu__Alert_Message__c='Partner Restricted Lead';    
                         }*/ 
                         
                         //Changed loop
                          for(Lead l : leadsToLock){
                          if(lo.Company.equals(l.Company))
                           {
                                 // 1.Change record type to Locked
                                 l.RecordTypeId=lockedRecordTypeId;
                                 // 2.Update Associated Partner with value from Channel Partner. 
                                 l.Partner__c=lo.Primary_Partner__c;
                                 // 3.Update Contract Begin Date with today's date. 
                                 l.Locked_Date__c=system.today();
                                 //Set Pop-up message
                                 l.rrpu__Alert_Message__c='Partner Restricted Lead';  
                            }
                         }  
                          System.debug('@@@@@ Insert LeadsToLock '+leadsToLock); 
                         update leadsToLock;                            
            }
         }
         
    } 
   }
   
   
   

 
}