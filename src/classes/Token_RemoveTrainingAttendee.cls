global class Token_RemoveTrainingAttendee {
    
    WebService Static String RemoveAttendee(string attendeeID) {
        String error;
        //get all training tokens related to the training attendee
        List<Token__c> tokenUpdates = new List<Token__c>();   //listing of tokens for update
        List<Token__c> replaceTokens = new List<Token__c> ([select id, 
                                                                        Training_Attendee__c, 
                                                                        Training_Attendee__r.name
            															from Token__c 
            															where Training_Attendee__c = :attendeeID and Token_Type__c = 'Training' 
            															order by name asc]);
        If(replaceTokens.size()>0){
	        for (Token__c checkTokenRec: replaceTokens){
	            system.debug('checkTokenRec: '+ checkTokenRec);
	            checkTokenRec.Training_attendee__c = null;
	            tokenUpdates.add(checkTokenRec);  
	         }
	        Update tokenUpdates;
	        error = 'Success: Tokens have been unassigned.';
       }else{                                                      //tokens already assigned to this user
            error = 'Attention: No Tokens are currently associated to this Training Attendee. No tokens were unassigned at this time.  ';
       }
  
       return error;   
    }
}