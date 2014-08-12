global class Token_AssignContactFromCase {

    WebService Static String contactStatus(Integer TokenQty, string contactID, 
                                            string contactAccount, string contactName, string caseID, String TokenType) {
        String error;
        Set<ID> attendeeSet = new Set<ID>();
        List<Token__c> tokenUpdates = new List<Token__c>();   //listing of tokens for update
        List<Token__c> usedTokens = new List<Token__c>();     //listing of tokens already assigned to this attendee
                                                                                //      based on the registration
        List<Token__c> token = new List<Token__c>();          //listing of tokens that have not been assigned
        List<Token__c> takentokens = new List<Token__c>();
        Token__c tokenRec = new Token__c();                   //token record for processing
        system.debug('contact.id: ' + contactID);
        system.debug('contact.Account: ' + contactAccount);
        system.debug('contact.Name: ' + contactName);
        system.debug('Contact.Case: ' + caseID);
        //get all training tokens related to the account
        List<Token__c> AllToken = new List<Token__c> ([select id, 
                                                              Contact__c, 
                                                              Case__c, 
                                                              Contact__r.name,
                                                              name
                                                              from Token__c 
                                                              where Account__c = :contactAccount 
                                                              and Token_Type__c = :TokenType 
                                                              order by name asc]);
        If (AllToken.size()>0) {
           for (Token__c checkTokenRec: AllToken){
                system.debug('checkTokenRec: '+ checkTokenRec);
                String checkTokenRecCase = checktokenRec.Case__c;
                if (checkTokenRec.Case__c == Null){
                    system.debug('adding checktoken to availablelist');
                    token.add(checkTokenRec);
                }else {
                    system.debug('CheckTokenRecCase'+ checkTokenRecCase.substring(0,15));
                    system.debug('CaseID' + caseID);
                    system.debug('checkTokenRec.Contact__r.name' + checkTokenRec.Contact__r.name);
                    system.debug('contactName: ' + contactName);
                    if (checkTokenRec.Contact__r.name == contactName  && caseID == checkTokenRecCase.substring(0,15) ){       
                                //attendee already assigned a token for this registration
                        system.debug('adding checktoken to used List');
                        usedTokens.add(checkTokenRec);
                    }else {
                        if (checkTokenRec.Contact__r.name <> null) { 
                            takentokens.add(checkTokenRec);
                            system.debug('adding tokens to taken list');
                        } else{
                            system.debug('adding checktoken to availablelist');
                            token.add(checkTokenRec);
                        } 
                    }      
                }
            } 
        }
        system.debug('usedToken.size: ' + usedTokens.size());   
        system.debug('Alltoken.size: ' + AllToken.size());
        system.debug('TokenQty: ' + TokenQty);
        system.debug('token.size()' + token.size());
        integer availableTokens = Alltoken.size() - takenTokens.size();
        system.debug('available tokens: ' + availableTokens);
    Integer tokenBalance = TokenQty - token.size();
        system.debug('token balance: ' + tokenbalance);
        
        ///if return tokens 
        if(usedTokens.size()== 0){              //checking to see if any tokens have been assigned
            if (token.size() > 0) {
                    if(token.size() >= TokenQty){                            //if tokens available, check total available
                        for(integer i = 0;i<TokenQty;i++){
                            tokenRec = token[i];
                        tokenRec.Contact__c = contactID;
                        tokenrec.Case__c = caseID;
                        tokenUpdates.add(tokenRec);   
                        }
                            system.debug('tokeupdates.size(): ' + tokenUpdates.size());
                            update tokenUpdates;
                            error = 'Success: Tokens have been assigned.';
                    }else{                                                  //no tokens available
                        error = 'Insufficient Tokens: Account needs ' +  tokenBalance + ' Token(s) to continue. ';
                    }
                    
             }else {
                    error = 'Insufficient Tokens: Account needs ' +  tokenBalance + ' Token(s) to continue. ';
            }    
       }else{                                                      //tokens already assigned to this user
            error = 'Attention: Tokens have already been assigned to Case. No tokens were assigned at this time.';
       }
  
       return error;   
    }
    
    static testmethod void m1(){
            Account acc = Data_Account.createAccount3();
            List<Contact> lstCons = Data_Contact.createContacts(acc.Id,2);
            List<Case> lstcases = Data_case.createCase(acc,lstcons[0],'HelpDesk',2);
            Token_AssignContactFromCase.contactStatus(2, lstcons[0].Id, 
                                            acc.Id, 'test', lstcases[0].Id,'Training');
    }
    static testmethod void m2(){
            Account acc = Data_Account.createAccount3();
            List<Contact> lstCons = Data_Contact.createContacts(acc.Id,2);
            List<Case> lstcases = Data_case.createCase(acc,lstcons[0],'HelpDesk',2);
            
            token__c tk = new token__c();
            tk.Contact__c = lstCons[0].Id;
            tk.Case__c = lstcases[0].Id;
            tk.Token_Type__c= 'Product Support';
            tk.Account__c = acc.Id;
            insert tk;
            token__c tk1 = new token__c();
            tk1.Contact__c = lstCons[0].Id;
           
            tk1.Token_Type__c= 'Product Support';
            tk1.Account__c = acc.Id;
            insert tk1;
            
            token__c tk2 = new token__c();
            tk2.Token_Type__c= 'Product Support';
            tk2.Account__c = acc.Id;
            insert tk2;
            
            Token_AssignContactFromCase.contactStatus(2, lstcons[0].Id, 
                                            acc.Id, 'test', lstcases[0].Id,'Product Support');
    }
}