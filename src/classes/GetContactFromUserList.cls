public with sharing class GetContactFromUserList {
  public static List<ID> getContactFromUserList(List<String> SendTo){
            String firstTimeThrough = 'Yes';
            List<ID> contactIDList = new List<ID>();  
  
            List<User> SendtoUsers = ([select Email, name, id from User where id in :SendTo]);   // Strings to hold the email addresses to which you are sending the email.  
            List<String> SendToUsersEmailList = new List<String>();
            Set<String> SendToUsersEmailSet = new Set<String>();
            for (User UserRec : SendtoUsers){
                 if (!(SendToUsersEmailSet.contains(UserRec.Email))){
                    SendToUsersEmailSet.add(UserRec.Email);
                 }   
            }
            if (SendToUsersEmailSet.size() > 0) {
                SendToUsersEmailList.addall(SendToUsersEmailSet);
            }
            system.Debug('SendToUsersEmailList: '+ SendToUsersEmailList);
            List<Contact> SendToContacts = ([select Email, name, id from Contact where email in :SendtoUsersEmailList]);
            list<Contact> SendToContactsList = new List<Contact>();
            
            system.debug('sendtocontacts: ' + sendToContacts);
        
            for (contact contactRec : SendToContacts){
                String matchFound = 'No';
                for(integer i=0;i<SendToContactsList.size();i++){
                    system.debug('contactRec.email: ' + contactRec.email);
                    if (firstTimeThrough == 'No'){
                        system.debug('SendToContactsList[i].email: ' + SendToContactsList[i].email);
                        if(contactRec.email == SendToContactsList[i].email){
                            matchFound = 'Yes';
                        }       
                    }    
                }
                system.debug('matchFound: ' + matchFound);
                if (matchFound == 'No'){
                    SendToContactsList.add(contactRec);
                }
                firstTimeThrough = 'No';
             }
            for (Contact contactRec : SendToContactsList){           
                    contactIDList.add(contactRec.id);
                
            }
            
            system.debug('contactIDList: ' + contactIDList);
 
            return contactIDList;
    }
}