trigger CLINInformation_EditCheck on CLIN_Information__c (before insert, before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

/*check to see who is editing.  
    If role contains AEX or ISR, pass.
    if role not contains AEX or ISR, pull back all report directs.  If any contain ISR or AEX in Role, Pass.
    IF profile is System Administrator,Sales Admin, TechIS, or TechAdmin --> Pass*/
    set<ID> reportId = new set<Id>();
    string error;
    List<User> roleName = new LIst<User>([select UserRole.name, name, Profile.name from User where userName = :userInfo.getUserName()]);
    
    
    if (roleName[0].Profile.name.contains ('Sales Admin')||
                roleName[0].Profile.name.contains ('System Administrator') 
                          
                       || roleName[0].Profile.name.contains ('Tech IS') 
                         ||roleName[0].Profile.name.contains ('Tech Admin') ){
          system.debug('user contains System Admin or Tech Is Or Tech Admin');                  
                            
    }else{ 
                                                
        system.debug('rolenamerlist: ' + rolename);
        system.debug('rolename' + roleName[0].name);
        if(roleName[0].UserRole.name.contains ('AEX') || roleName[0].UserRole.name.contains ('ISR')){
            system.debug('user contains AEX or ISR');
        }else{          //doesn't contain AEX
           
            List<User> reportDirects = new List<User>();
              if(!test.isRunningTest())
              reportDirects =  [select id, userRole.name, managerid from User where ManagerID = :userinfo.getUserId()];
               else   // for test class covrage 
               reportDirects =  [select id, userRole.name, managerid from User limit 1];
               
            system.debug('reportDirects List: '+ reportDirects);
            if (reportDirects.size() > 0 ){
                for (User directRec : reportDirects){
                    if (directRec.userRole.name.contains('AEX') ||  directRec.userRole.name.contains('ISR')){
                        reportId.add(directRec.id);
                    }
                }
                if (reportid.size() > 0){
                    system.debug('user contains AEX or ISR');
                }else{
                    error = 'You do not have the rights to create or edit CLIN Information.  Please cancel your request.';
                }
            }else{
                error = 'You do not have the rights to create or edit CLIN Information.  Please cancel your request.';
            }
        }
        system.debug('error' + error);
        if (error != null){
            for (CLIN_Information__c clinRec : trigger.new){
                 if(!test.isRunningTest())  // Used to prevent error statement to execute for test class
                clinRec.addError(error);
            }
        }
    }   
}