/******************************************************************
Trigger Name   : PSE_TimecardDetermineApprover
Created by     : Appirio
Created Date   : October 28, 2009
Purpose        : Set Timecard Approver to Project's PM.
********************************************************************/
trigger PSE_TimecardDetermineApprover on pse__Timecard_Header__c (after insert, after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    // Trigger Switch
    Boolean LX_Switch = false; 
    static integer index = 0;    
    // Get current profile custom setting.
    LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
    // Get current Organization custom setting.
    LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
    // Get current User custom setting.
    LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
    
    // Allow the trigger to skip the User/Profile/Org based on the custom setting values
    if(LXUser != null)
        LX_Switch = LXUser.Bypass__c;
    else if(LXProfile != null)
        LX_Switch = LXProfile.Bypass__c;
    else if(LXOrg != null)
        LX_Switch = LXOrg.Bypass__c;
    if(LX_Switch)
        return;    


    Set<String>  setTimeCardID = new Set<String>();
    
    Map<ID, pse__Timecard_Header__c > mapOld = Trigger.OldMap;
    system.debug('>>>>>>>>>>>>>>>>>mapOld:>>>'+mapOld);
    system.debug('>>>>>>>>>>>>>>>>>trigger.isInsert>>>'+trigger.isInsert);    
    system.debug('>>>>>>>>>>>>>>>>>trigger.isupdate>>>'+trigger.isupdate);    
    system.debug('>>>>>>>>>>>>>>>>>trigger.isAfter>>>'+trigger.isAfter);    
    system.debug('>>>>>>>>>>>>>>>>>ID>>>'+trigger.New[0].id);    
    system.debug('>>>>>>>>>>>>>>>>>trigger.isAfter>>>'+trigger.isAfter);    
    

    
    
    //Create a set of time cards if status = "Submitted"
    //And old status not equal to New status
    
       if(FirstRun_Check.FirstRun_TCApprover)
{    
    
    For(pse__Timecard_Header__c  timecard : Trigger.New)
    {  
      
        if(timecard.pse__Status__c == 'Submitted')
        {
           if(Trigger.IsUpdate)
           {
             if(timecard.pse__Status__c != mapOld.get(timecard.Id).pse__Status__c)
             {
                 setTimeCardID.Add(timecard.ID);
           }               
           }
       
        }
           if(Trigger.IsInsert)
           {
               setTimeCardID.Add(timecard.ID);
           }           
   }
      
       
   system.debug('XXCCC' +setTimeCardID);
    List< pse__Timecard_Header__c > timeCards = new List< pse__Timecard_Header__c >();
    Boolean flagUpdate = false;
    
    //Only proceed if the set contains some values.
    
    if(setTimeCardID.size()>0)
    {
        
        //Query on timecard object for all timecards whose id was stored in the set.
        
        timeCards = [SELECT id ,pse__Project__c,pse__Project__r.pse__Project_Manager__c , pse__Resource__c,pse__Project_Methodology__c,
                    pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c,pse__Resource__r.Delegate_PSE_Approver__c,
                    pse__Resource__r.pse__Salesforce_User__r.Managerid ,pse__Project__r.pse__Project_Phase__c,pse__Project_Phase__c,
                    pse__Approver__c  from pse__Timecard_Header__c
                    where id in : setTimeCardID];
                    
        for(pse__Timecard_Header__c timecard :timeCards)
        {
            if(timecard.pse__Project__c != null)
            {
                //If timecard's Project.Project_Manager == null 
                //then approver should be Resource.Delegate PSE Approver
                //Else approver should be Resource .SFDC User.Manager
                //Else approver should be Project.Project_Manager.SFDC user
                
                if(Trigger.IsInsert){
                system.debug('*************************************************************************************** project phase is :: '+timecard.pse__Project__r.pse__Project_Phase__c);
                timecard.pse__Project_Phase__c = timecard.pse__Project__r.pse__Project_Phase__c;
                system.debug('*************************************************************************************** project phase in tc'+timecard.pse__Project_Phase__c);
                }
                 
                system.debug('Approver Check start' +timecard.pse__Approver__c);
                system.debug('XApprover Check startX' +timecard.pse__Project__r.pse__Project_Manager__c);
                if(timecard.pse__Project__r.pse__Project_Manager__c == null)
                {
                    if(timecard.pse__Resource__c != null)
                    {
                            if(timecard.pse__Approver__c!= timecard.pse__Resource__r.Delegate_PSE_Approver__c && timecard.pse__Resource__r.Delegate_PSE_Approver__c!=Null)
                            {
                               system.debug('Approver Check Resource' +timecard.pse__Resource__r.Delegate_PSE_Approver__c);
                               
                               timecard.pse__Approver__c = timecard.pse__Resource__r.Delegate_PSE_Approver__c;
                               flagUpdate = true;
                               system.debug('Approver Check Resource' +timecard.pse__Approver__c);
                            }
                            else
                            {
                               if(timecard.pse__Resource__r.Delegate_PSE_Approver__c==Null && timecard.pse__Approver__c != timecard.pse__Resource__r.pse__Salesforce_User__r.Managerid)
                               {
                                   timecard.pse__Approver__c = timecard.pse__Resource__r.pse__Salesforce_User__r.Managerid;
                                   flagUpdate = true;
                               }
                            }
                        
                    }
                }
                else
                {
                    system.debug('If the Project Manager is not null, Check if the Resource is the Project Manager');

                    // If the resource is the PM, set the Approver to HR.
                    
                    if(timecard.pse__Resource__r.pse__Salesforce_User__c == timecard.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c)
                    {
                    
                    // If the project methodology is INVST 
                    if(timecard.pse__Project_Methodology__c.contains('INVST'))
                    {
                        // If the project methodology contains INVST, the timecard of Project Manager is submitted to the HR Manager
                        system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Resource is the Project Manager>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                        // Check if there is any delegated approver for the user.
                        if(timecard.pse__Resource__r.Delegate_PSE_Approver__c==Null){
                            // If there is no delegate approver to the resource,set the approver to the manager
                            timecard.pse__Approver__c = timecard.pse__Resource__r.pse__Salesforce_User__r.Managerid;
                            flagUpdate = true;
                            system.debug('Approver is '+timecard.pse__Resource__r.pse__Salesforce_User__r.Managerid);
                            system.debug('Approver is '+timecard.pse__Approver__c);
                        
                        }
                        else{                                
                            timecard.pse__Approver__c = timecard.pse__Resource__r.Delegate_PSE_Approver__c;
                            flagUpdate = true;
                        }
                    }else{
                        // If the project methodology does not contain INVST, the timecard is auto approved using a workflow and the approver field is set to Project Manager
                        timecard.pse__Approver__c = timecard.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c;                
                        flagUpdate = true;
                    }
                    }
                    
                    else{     
                    system.debug('>>>>>>>>timecard.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c>>>>>>>>>>'+timecard.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c) ;      
                     if(timecard.pse__Approver__c != timecard.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c)
                     {
                       timecard.pse__Approver__c = timecard.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c;                
                       flagUpdate = true;
                     }
                   }
                }               
            }
            system.debug('Approver Check' +timecard.pse__Approver__c);
        } 
        if(flagUpdate)
        {    
            //updating the flag for recursion check
            FirstRun_Check.FirstRun_TCApprover = False;
            update timecards;
            FirstRun_Check.FirstRun_TCApprover = true;
        }
        system.debug('XXX' +timecards);
     }
     //Rahul commented the code as this is not helping with recursion 
     /*
     if(Trigger.isUpdate)
     {
         FirstRun_Check.FirstRun_TCApprover = False;
      }*/
      
     }
     
}