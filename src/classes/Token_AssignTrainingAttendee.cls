global class Token_AssignTrainingAttendee {

    //Training_Attendee__c attendee; 
    
    
    WebService Static String AttendeeStatus(Integer TokenQty, string contactID, string attendeeID,
                                            string attendeeAccount, string attendeeName_regex, string attendeeRegistration) {
        String error;
        Set<ID> attendeeSet = new Set<ID>();
        //system.debug('attendeeName_regex' + attendeeName_regex);
        String attendeeName = attendeeName_regex.replace('_', '\'');
        //system.debug('attendeeName:' + attendeeName);
        List<Token__c> tokenUpdates = new List<Token__c>();   //listing of tokens for update
        List<Token__c> usedTokens = new List<Token__c>();     //listing of tokens already assigned to this attendee
                                                                                //      based on the registration
        List<Token__c> token = new List<Token__c>();          //listing of tokens that have not been assigned
        List<Token__c> takentokens = new List<Token__c>(); //holds the tokens that have been taken by another attendee
        Token__c tokenRec = new Token__c();                   //token record for processing
        //system.debug('attendee.id: ' + contactID);        
        List<Contact> attendeeContactList = [select accountid from Contact where id = :contactID];
        attendeeAccount = attendeeContactList[0].accountId;
        //system.debug('attendee.Account: ' + attendeeAccount);
        //system.debug('attendee.Name: ' + attendeeName);
        //system.debug('attendee.Registration: ' + attendeeRegistration);
        //get all training tokens related to the account
        List<Token__c> AllToken = new List<Token__c> ([select id, 
                                                                        Training_Attendee__c, 
                                                                        Training_Attendee__r.Registration__c, 
                                                                        Training_Attendee__r.name,
                                                                        name
            from Token__c where Account__c = :attendeeAccount and Token_Type__c = 'Training' order by name asc]);
        
        for (Token__c checkTokenRec: AllToken){
            //system.debug('checkTokenRec: '+ checkTokenRec);
            //system.debug('checkTokenRec.Training_attendee__r.name: ' + checkTokenRec.Training_attendee__r.name);
            //system.debug('attendeeName: ' + attendeeName);  
            //system.debug('attendeeRegistration: ' + attendeeRegistration);
            //system.debug('checkTokenRec.Training_Attendee__r.Registration__c: ' + checkTokenRec.Training_Attendee__r.Registration__c);
      if (checkTokenRec.Training_attendee__r.name == attendeeName  && attendeeRegistration == checkTokenRec.Training_Attendee__r.Registration__c ){       
                        //attendee already assigned a token for this registration
                usedTokens.add(checkTokenRec);
                //system.debug('adding to used tokens');
        }else{
            if (checkTokenRec.Training_attendee__r.name <> null){
                takentokens.add(checkTokenRec);
                //system.debug('adding to takentokens');
            }else{
                token.add(checkTokenRec);
                //system.debug('adding to tokensize');
            }   
        } 
      }
        //system.debug('usedToken.size: ' + usedTokens.size());   
        //system.debug('Alltoken.size: ' + AllToken.size());
        //system.debug('TokenQty: ' + TokenQty);
        //system.debug('token.size()' + token.size());
        integer availableTokens = Alltoken.size() - takenTokens.size();
        //system.debug('available tokens: ' + availableTokens);
    Integer tokenBalance = TokenQty - token.size();
        //system.debug('token balance: ' + tokenbalance);
        
        ///if return tokens 
        if(usedTokens.size()== 0){              //checking to see if any tokens have been assigned
            if (token.size() > 0) {
              //  if(usedTokens.size()== 0){              //checking to see if any tokens are available for this account
                    if(token.size() >= TokenQty){                            //if tokens available, check total available
                        for(integer i = 0;i<TokenQty;i++){
                            tokenRec = token[i];
                            tokenRec.Training_attendee__c = attendeeID;
                            tokenUpdates.add(tokenRec);   
                        }
                            //system.debug('tokeupdates.size(): ' + tokenUpdates.size());
                            update tokenUpdates;
                            error = 'Success: Tokens have been assigned.';
                    }else{                                                  //no tokens available
                        error = 'Insufficient Tokens: Account needs ' +  tokenBalance + ' Training Token(s) to continue. ';
                    }
                    
             //   }else{                                                      //tokens already assigned to this user
             //       error = 'Attention: Tokens have already been assigned to Attendee. No tokens were assigned at this time.';
             //   }
            }else {
                    error = 'Insufficient Tokens: Account needs ' +  tokenBalance + ' Training Token(s) to continue. ';
            }    
       }else{                                                      //tokens already assigned to this user
            error = 'Attention: Tokens have already been assigned to Attendee. No tokens were assigned at this time.';
       }
  
       return error;   
    }
    

}