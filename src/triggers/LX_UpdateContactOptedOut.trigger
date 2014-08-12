/* Trigger Name   : LX_UpdateContactOptedOut
* Description   : Sync Contact records opt out with Account.e.g If account opt out from EmailOpt request then related contact
                   automatically opt out from Email Opt.
* Created By   : Arun thakur(arunsingh6@deloitt.com) 
* Created Date : 5/08/2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* 
*/
trigger LX_UpdateContactOptedOut on Account (after update)
{if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

    //Declare a set to store account ids
    Set<Id> LX_AccountIds=new Set<Id>();
    //Declare a set to store do not call ids
    Set<ID> LX_Do_Not_Call=new Set<ID>();
    //Declare a set to store email opt out ids
    Set<ID> LX_Email_Opt_Out=new Set<ID>();
    //Declare a set to store opt out early in pipeline ids
    Set<ID> LX_Opt_Out_Early_Pipeline=new Set<ID>();
    
    for(Account objAccount : Trigger.New)
    {
        Account LX_OldAccountRecord= trigger.oldMap.get(objAccount.Id);
        
        //only if field changed 
        if(
        (objAccount.LX_Do_Not_Call__c!=LX_OldAccountRecord.LX_Do_Not_Call__c)
        ||(objAccount.LX_Opt_Out_Early_Pipeline__c!=LX_OldAccountRecord.LX_Opt_Out_Early_Pipeline__c)
        ||(objAccount.LX_Email_Opt_Out__c!=LX_OldAccountRecord.LX_Email_Opt_Out__c))
        
        {
            //If account opt out from DO Not Call ,Update contact DO Not Call
            if(objAccount.LX_Do_Not_Call__c==true)
            {
                LX_AccountIds.Add(objAccount.Id);
                LX_Do_Not_Call.Add(objAccount.Id);
            }
            
            //if(objAccount.LX_Email_Opt_Out__c!=LX_OldAccountRecord.LX_Email_Opt_Out__c)
            
            //If account opt out from Email ,Update contact Email Opt Out
            if(objAccount.LX_Email_Opt_Out__c==true)
            {
                LX_AccountIds.Add(objAccount.Id);
                LX_Email_Opt_Out.Add(objAccount.Id);
                
            }
            
            //if(objAccount.LX_Opt_Out_Early_Pipeline__c!=LX_OldAccountRecord.LX_Opt_Out_Early_Pipeline__c)
                //If account opt out from Early Pipelin  ,Update contact Early Pipelin
            if(objAccount.LX_Opt_Out_Early_Pipeline__c==true)
            {
                LX_AccountIds.Add(objAccount.Id);
                LX_Opt_Out_Early_Pipeline.Add(objAccount.Id);
            }
        }
        
    }
    
    System.debug('===LX_Do_Not_Call'+LX_Do_Not_Call);
    System.debug('===LX_Email_Opt_Out'+LX_Email_Opt_Out);
    System.debug('===LX_Opt_Out_Early_Pipeline'+LX_Opt_Out_Early_Pipeline);
    
    if(!LX_AccountIds.IsEmpty())
    {
        List<Contact> LX_ListContact=new List<Contact>(); //List to store the contacts who need to be opt out
        for(Contact ObjContact:[select Opt_Out_Early_Pipeline__c,AccountId,DoNotCall,HasOptedOutOfEmail from contact where AccountId in :LX_AccountIds])
        {
            System.debug('===ObjContact'+ObjContact);
            if(LX_Do_Not_Call.Contains(ObjContact.AccountId))
            ObjContact.DoNotCall=true;
            
            if(LX_Email_Opt_Out.Contains(ObjContact.AccountId))
            ObjContact.HasOptedOutOfEmail=true;
            
            
            
            if(LX_Opt_Out_Early_Pipeline.Contains(ObjContact.AccountId))
            ObjContact.Opt_Out_Early_Pipeline__c=true;
            
            LX_ListContact.Add(ObjContact);
        }
        if(!LX_ListContact.IsEmpty())
        {
            System.debug('===LX_ListContact'+LX_ListContact);
            Update LX_ListContact;
        //Update Contact record and set 
        //  Do Not Call=false
        //  Email Opt Out=false
        //  Opt Out - Early Pipeline=false
        }
    
    }
    

}