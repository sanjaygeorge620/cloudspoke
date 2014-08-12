@isTest (seealldata=true)
public with sharing class LX_Opportunity_BD_Test{

    static testMethod void runNoDelete() {
        //Purge Existing Records
        deleteCustomSettings();
        
        boolean errorthrown = false;
        string errormsg = '';
        //try to delete an opportunity
        opportunity o = [select id from opportunity limit 1];
        try{
            delete o;
        }catch(exception e){
            errorthrown = true;
            errormsg = e.getmessage();
            System.debug(e.getmessage());
        }    
        system.assert(errorthrown==true, 'Assert (no delete) not working ' + errormsg);
    }
    
    static void deleteCustomSettings(){
        //Delete all access records
        list<LX_UserAccess__c> l = new list<LX_UserAccess__c>();
        for(LX_UserAccess__c x: [select id from LX_UserAccess__c]){ //select all
            l.add(x);
        }
        delete l; //prevent everyone from deleting opportunities
    
    }
    static testMethod void runDelete() {
        //Purge Existing Records
        deleteCustomSettings();
       
        //Add Delete access for self
        LX_UserAccess__c l = new LX_UserAccess__c(SetupOwnerId = userinfo.getuserid(), Opportunity_Deletion__c =true );
        insert l;
        
        boolean errorthrown = false;
        string errormsg = '';
        //try to delete an opportunity
        opportunity o = [select id from opportunity limit 1];
        try{
            delete o;
        }catch(exception e){
            errorthrown = true;
            errormsg = e.getmessage();
            System.debug(e.getmessage());            
        }    
        
    }


}