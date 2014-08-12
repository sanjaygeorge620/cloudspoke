public with sharing class CreatePartnerUserRegistration2 {
     /**************************************
     Description: Creating User Registration record for partner portal
     *
     Date Created: 3/9/2012
     *
     By: Manoj Kolli
     *****************************************/ 
    
    public static void CreatePartnerUserRegistration(Set<ID> CreateUserFromContactIDList){             //contactId
        System.debug('****************In the class CreatePartnerUserRegistration**********');
        
        List<User_Registration__c> userRegList = new List<User_Registration__c>();
      
        List<Contact> ContactList = new List<Contact>([select    id 
                                                                    , accountid 
                                                                  // , account.IsPartner 
                                                                    , email 
                                                                    , LastName
                                                                    , FirstName
                                                                    from contact where id in :CreateUserFromContactIDList]);
        set<Id> accIdsInContact = new set<Id>();
        set<String> emailContact = new set<String>();
        Map<Id,Contact> ConListforAccounts;
        Map<Id,Id> sisterContactasMaster = new Map<Id,Id>();
        Map<Id,Id> AccountIdtosiscontact = new Map<Id,Id>();
        Map<Id,Id> sisterContactChannel = new Map<Id,Id>();
        
        
        if(ContactList.size()>0){
            for(Contact con:ContactList){
                if(con.accountid != Null){
                    accIdsInContact.add(con.accountId);
                }
                if(con.Email != Null){
                    emailContact.add(con.email);
                }
            }
        }
        if(accIdsInContact.size()>0){
           ConListforAccounts = new Map<Id,Contact>([select Id,accountid,email from 
                                                     contact where Id not in :CreateUserFromContactIDList and accountid in :accIdsInContact and email in :emailContact]);
         }                                         
        
        if(ConListforAccounts.size()>0){
        
            set<Id> sisterContactIds = new set<Id>();
            for(Contact c5:ConListforAccounts.values()){
               System.debug('***************contact id*********'+c5.Id);
               sisterContactIds.add(c5.Id);           
            }
       
           Map<Id,User_Registration__c> userRegwithSistercontact = new Map<Id,User_Registration__c>([Select Id,Master_Contact__c,Master_Contact__r.AccountId, User_Contact__c,
                                                                   User_Contact__r.Email,Application__c from User_Registration__c where User_Contact__c in :sisterContactIds and Application__c != 'Channel Partner']);
                                                                   
           Map<Id,User_Registration__c> URcontainsChannel = new Map<Id,User_Registration__c>([Select Id,Master_Contact__c,Master_Contact__r.AccountId, User_Contact__c,
                                                                   User_Contact__r.Email,Application__c from User_Registration__c where User_Contact__c in :sisterContactIds and Application__c = 'Channel Partner']);
           
           system.debug('***************user reg with sister contact*******'+userRegwithSistercontact.size());
           //Map<Id,Id> sisterContactasMaster = new Map<Id,Id>();
           //Map<Id,Id> AccountIdtosiscontact = new Map<Id,Id>();
           if(userRegwithSistercontact.size()>0){
                for(User_Registration__c ur1:userRegwithSistercontact.values()){
                    sisterContactasMaster.put(ConListforAccounts.get(ur1.Master_Contact__c).accountId,ur1.Master_Contact__c);
                    AccountIdtosiscontact.put(ConListforAccounts.get(ur1.Master_Contact__c).accountId,ur1.Master_Contact__r.AccountId);
                    //tmpemail.put(cont)
                }
            }
           
           if(URcontainsChannel.size()>0){
                for(User_Registration__c ur2:URcontainsChannel.values()){
                    sisterContactChannel.put(ConListforAccounts.get(ur2.Master_Contact__c).accountId,ur2.Master_Contact__c);
                }
            } 
            
        }
       
       User_Registration__c newUserReg;
       List<Contact> conreg = new List<Contact>();
        
       for(Contact c: ContactList){
           if(sisterContactasMaster.containsKey(c.AccountId)){
               newUserReg = new User_Registration__c (
                        Application__c = 'Channel Partner',        
                        Profile__c = 'User',
                        Master_Contact__c = sisterContactasMaster.get(c.accountId),
                        User_Account__c = AccountIdtosiscontact.get(c.accountId),
                        User_Contact__c = c.Id,
                        Auto_Created__c = True,
                        Workflow_Status__c = 'Submitted'
                        );
                        system.debug('***************in if loop contact w/user reg'+newUserReg);
               userRegList.add(newUserReg);          
           }
           /*else if(sisterContactasMaster.containsKey(c.accountId)){
                   newUserReg = new User_Registration__c (
                        Application__c = 'Channel Partner',        
                        Profile__c = 'User',
                        Master_Contact__c = sisterContactasMaster.get(c.accountId),
                        User_Account__c = AccountIdtosiscontact.get(c.accountId),
                        User_Contact__c = c.Id,
                        Auto_Created__c = True,
                        Workflow_Status__c = 'Submitted'
                        );
                        system.debug('***************in elseif contact w/o user reg'+newUserReg);
               userRegList.add(newUserReg);
               }*/
           else if(!sisterContactChannel.containsKey(c.accountId)){
               conreg.add(c);
              }
            }
           
           if(conreg.size()>0){ 
               for(Contact c1:conreg){
                   
                   newUserReg = new User_Registration__c (
                            Application__c = 'Channel Partner',        
                            Profile__c = 'User',
                            Master_Contact__c = c1.Id,
                            User_Account__c = c1.AccountId,
                            User_Contact__c = c1.Id,
                            Auto_Created__c = True,
                            Workflow_Status__c = 'Submitted'
                            );
                            system.debug('***************in else contact user reg'+newUserReg);
                   userRegList.add(newUserReg);
               }    
          } 
         insert userRegList; 
         system.debug('***********userRegList'+userRegList);
    
       }  
}