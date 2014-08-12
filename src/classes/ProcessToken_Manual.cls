global Class ProcessToken_Manual{

   WebService static String ProcessToken_Manual (string oppID, String TokenType) {
   
   set<ID> oppIDSet = new set<ID>();
   oppIDset.add(oppID);
   List<String> tokenTypeList = new List<String>();
   tokenTypeList.add(tokentype);
   String error;
   
    ProcessToken.ProcessToken(oppIDSet,tokenTypeList); 
    
    error = 'Tokens have been sent to be processed';
    return error;
    
   }
}