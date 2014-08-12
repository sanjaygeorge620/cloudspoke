//===============================================================================================
// SKILLPORT SERVICES CLASS
// API Documentation: http://documentation.skillsoft.com/ikb/
// Created: January 2014
//===============================================================================================
public with sharing class SkillportServices {
    
//===============================================================================================
// SKILLPORT COMMANDS
//===============================================================================================
    //SinglePassUserCmd - CreateUser/LoginUser in One Command
        public static pagereference SinglePassUserCmd(string userId, string authid,string orgCode){
          try{
                user u = getCurrentUser(userid); 
               
                //verify settings needed
                
                string EnvironmentName = isSandbox?'.test':'.prod';
                if(
                    !Settings.containskey('skillport.endpoint'+EnvironmentName) || 
                    !Settings.containskey('skillport.sharedsecret'+EnvironmentName) ||
                    !Settings.containskey('skillport.adminusername'+EnvironmentName) 
                ){
                    //Throw Exception 
                    throw new spException('There seems to be an issue with the training system. Please try again. (SS52)');
                }    
                   
                string endpoint = 'https://' + Settings.get('skillport.endpoint'+EnvironmentName) + '.skillport.com/skillportfe/bcs/SinglePassUserCmd.cfm?';
                string SharedSecret = Settings.get('skillport.sharedsecret'+EnvironmentName);
                string AdminUserName = Settings.get('skillport.adminusername'+EnvironmentName);
                string now = string.valueof(system.currentTimeMillis());
                    
                
                PageReference Pg = new PageReference(endpoint);
                //**REQUIRED FIELDS
                              Pg.getParameters().put('loginUserName', (AdminUserName));
                              Pg.getParameters().put('secureid', (createToken(now, AdminUserName, SharedSecret)));
                              Pg.getParameters().put('token', (now));
                              Pg.getParameters().put('orgCode', (orgCode));
                              Pg.getParameters().put('userName', (stripDown(u.username)));
                //**OPTIONAL FIELDS          
                              Pg.getParameters().put('fname', (u.firstname));
                              Pg.getParameters().put('lname', (u.lastname));
                              Pg.getParameters().put('email', (u.email));
                               
                               //**http://documentation.skillsoft.com/ikb/index.htm?toc.htm?7952.htm
                                Pg.getParameters().put('free1', (u.User_Account_Name__c));
                              Pg.getParameters().put('free2', (u.User_Company_Number__c));
                              Pg.getParameters().put('authID', (authid));
                              Pg.getParameters().put('isActive', ('1'));            
                       Pg.setRedirect(true);
              
                return Pg;
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getmessage()));
                return null;
            }    
        }
        
      //CreateToken for secure authentication
        private static string createToken(string now, string username,string sharedsecret){
            //Build and Encrypt strings to use
                string ConcatenateValue = username.tolowercase() + '&' + now + '&' + sharedsecret;
                Blob baseSignature = Crypto.generateDigest('MD5', Blob.valueOf(ConcatenateValue));         
        
                //Convert to hexidecimal string
                string key= EncodingUtil.convertToHex(baseSignature);
                system.debug(key);
          //return encrypted key      
        return Key;
        }  
        
//===============================================================================================
// Helper Methods
//===============================================================================================    
    //Exception Class for throwing custom errors
        public class spException extends Exception {}
    
    //Grab Environment Variables from Custom Settings to dynamically change
        private static map<string,string> Settings{ 
            get{
                if(settings==null){
                    map<string,Environment_Variable__c> s = Environment_Variable__c.getAll();
                    //Need to iterate to make values lowercase
                    settings = new map<string,string>();
                    for(string x: s.keySet()){
                        settings.put(x.tolowercase(),s.get(x).Value__c);
                    }
                } 
                return settings;
             } 
             set;
        }
    
    //Check Custom Settings for match on orgid for checking if it is a sandbox
        private static boolean isSandbox{
            get{
                if(isSandbox==null){
                    isSandbox = true;
                    if(Settings.containskey('salesforce.orgid') && Settings.get('salesforce.com.orgid')==userinfo.getOrganizationId()){
                        isSandbox = false;
                    }    
                }
                system.debug('Environment = Sandbox?: '+ isSandbox);
                return isSandbox;
            }
            set;
        }
        
     
    //Grab current user information that is applicable      
        private static user getCurrentUser(string userId){
               return [select id, FirstName, LastName, Email, Username,User_Account_Name__c,User_Company_Number__c from user where id=:userid];
        }    
   
        
            
    //Force string to be in compliance with skillport rules
        private static string stripDown(string val){
            //strip string down to a-z + 0-9 + special allowed characters
             if (val=='' || val==null){
                 return val;
             }else{
                  return val.tolowercase().ReplaceAll('[^a-zA-Z0-9@$_.~\'-]', '');
             }     
        }
        
}