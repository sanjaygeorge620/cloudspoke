/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public with sharing class SitesContactController Extends SitesController{

//-------------------------------------------------------------------------------
// Contact
//-------------------------------------------------------------------------------
    private string ControllerID; 
    private static string ControllerID; 
    public SitesContactController() {
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
      }
    
//-------------------------------------------------------------------------------
// Contact Details
//-------------------------------------------------------------------------------
    public contact c{
          get {
              if (c == null){
                 try{
                         c = [Select 
                                    id, 
                                    status__c, 
                                    firstname, 
                                    lastname, 
                                    email,
                                    title,
                                    name, 
                                    phone, 
                                    region__c,
                                    AccountID 
                               from Contact 
                               where id=:ControllerID and 
                                     AccountID=:SITE_ACCOUNT.id 
                               ];
                     } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
                }
              return c;
            }
          set;
          }
    
       
    //Update or Create Contact
    public pagereference updateContact(){
      try {
              //Account is tied to the Contact
              c.AccountID = SITE_ACCOUNT.ID;
              upsert c;
              
              system.debug('c.Status__c: '+c.Status__c);
              
              //Inactivate user if Contact Status is inactive
              if(c.status__c=='InActive'){
                  u.isactive=false;
              }
              
              if (!getisExistingUser() && !u.isactive){ //USER: did not exist and is not active
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Contact updated successfully! (001)'));
                  return null;
                  
              } else {
                      //verifying username
                      if (!isValidUserName()){
                          system.debug('1. user: '+u);
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Username must be unique and in the format of an email (user@company.com).'));
                      
                      } else if (getisExistingUser()){ //existing user
                          system.debug('2. user: '+u);
                          upsertPortalUser(u.communitynickname, u.isactive, c.id, c.email, c.firstName, c.lastName, u.username, c.Title, c.phone); //just update
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Submitted successfully! User will be updated momentarily. (002)'));
                          
                      } else{ //Create or update existing user
                          system.debug('3. user: '+u);
                          upsertPortalUser(u.communitynickname, u.isactive, c.id, c.email, c.firstName, c.lastName, u.username, c.Title, c.phone);
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Submitted successfully! An email has been sent with a temporary password. (003)'));
                      }
                      
                  //Refresh page
                  PageReference Pg;
                  Pg = page.Account;
                  Pg.getParameters().put('tab', 'contacts');
                  Pg.setRedirect(true);
                  return Pg;
              }    

            } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating contact.'));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesContactController.upsertContact','High','DML');
                  return null;
            } 
          }
//-------------------------------------------------------------------------------
// User Details
//-------------------------------------------------------------------------------
    public PageReference resetPassword(){
        boolean success = Site.forgotPassword(u.username); 
         if (success) {    
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Submitted successfully! An email has been sent with a temporary password.'));
         }
        return null;
    }
    
    //display user info on contact details page
    public boolean getShowUser() {
        return u.isactive;
    }
    
    public void enableUser() {
        //If you are enabling a user, then contact=Active
        c.status__c='Active';
        u.isactive=true;
        if (u.username==null || u.username.length()==0){
            u.username=c.email;
        }
        
        if (u.communitynickname==null || u.communitynickname.length()==0){
            string commname=c.firstname+'.'+c.LastName+'.'+string.valueOf(DateTime.Now().format('yyyymmmdd.hhmmss'));
            if (commname.length()>40){
                u.communitynickname = commname.substring(0, 39);
            } else {
                u.communitynickname=commname;}
        }
        
    }  
    
    public user u{
          get {
              if (u == null)
                getUserDetail();
              return u;
            }
          set;
          }
    
    //user details      
    public user getUserDetail(){
        if (ControllerID!=''){
            integer users =[select count() from user where contactid=:ControllerID ];
            if (users!=1){
               u = new user(); 
            } else{
                u = [Select 
                            u.id, 
                            u.username,
                            u.isactive, 
                            u.firstname, 
                            u.lastname, 
                            u.email,
                            u.title,
                            u.name, 
                            u.phone,
                            u.profileid,
                            u.alias,
                            u.communitynickname,
                            u.LastLoginDate  /* ,
                            u.IsPortalEnabled */
                       from user u
                       where u.contactid=:ControllerID 
                       ];
             }
         }          
      return u;
        } 
    
    //did user exist
    public boolean getisExistingUser(){
        integer users =[select count() from user where contactid=:ControllerID];
        if (users==1){
            return true;
        } else {
            return false;
        }
    }
    
    //verify I'm not creating a duplicate username      
    private boolean isValidUserName(){
        try{
              list<User> users = [select 
                                      username,
                                      contactid
                                  from User 
                                  where 
                                      username=:u.username 
                                   ];
             
             //iterating to get the id
             id foundContactID;
             for (user foundUser: users) {
                 foundContactID = foundUser.Contactid;
             }
            
            if (string.valueOf(u.username).trim() =='' || !string.valueOf(u.username).contains('@')){
                return false;
            } else if (users.size()==0 || (users.size()==1 && foundContactID==c.id)){ 
                 return true;
            } else {            
             return false;
            } 
        }catch(Exception ex){
            System.debug('Issue occurred dont allow creation');
            return false;
        }
       }   
    
    public static id getPortalProfileID() {
        //Execute query to get all profiles associated to Customer Portal
        profile p = [Select p.id From Profile p where  (p.Name = 'Perceptive Customer Portal User') limit 1];
        if (p.id==null){
            return null;
        } else{
            return p.id;
        }
    }


//-------------------------------------------------------------------------------
// Portal User Update/Creation
//-------------------------------------------------------------------------------
    
    @future static void upsertPortalUser(string communitynickname, boolean isActive, string Contactid, string email, string firstName, string lastName, string username, string Title, string Phone) {
        User u;
        boolean updateRecord;
        
        //only one contactid can be tied to one userrecord (when a user is disable the contactid is removed)
        list<user> Users = [select id from user where contactid=:ContactID and Contactid!=null];
        if (Users.size()==1){
            //Grab the one userid
            for (user oldUser : users) {
                u=oldUser;
            }
            updateRecord = true;
            
        } else{ //create new record
            u = new User();  
            updateRecord = false;
        }
                   
         
        u.isactive=isActive;
        u.username=username;
        u.firstname = firstname;
        u.lastname = lastname;
        u.email = email;
        u.title = Title;
        u.phone = phone;
        u.communitynickname=communitynickname;
        
        if (updateRecord){
            update u;
        } else { //creating user record
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = true;
            
            u.setOptions(dmo); //send email
            u.contactid = ContactID;
            u.alias = 'portal'; 
            u.emailencodingkey='UTF-8';
            u.languagelocalekey='en_US';
            u.localesidkey='en_US';
            u.profileid = getPortalProfileID();
            u.timezonesidkey='America/Chicago';
            insert u;
        }   
            
    }
    
}