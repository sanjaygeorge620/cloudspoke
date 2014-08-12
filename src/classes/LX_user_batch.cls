/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 07/26/2013
*
* Author : Maruthi Kolla.
* 
* Description : Batch class for populating 'Sales Territory Type'  field on users.
*
* Maruthi Kolla: 05/23/2014: Updated to calculate 'MPS' and 'Number of lexmark verticals' on user record. 
* Sanjay Chaudhary: 06/09/2014: Updated as per US3787 to update Partner STT Calculation to be based 'Partner ISS Capability Segment' on instead of 'ISS Internal Segment' 
*/

global class LX_user_batch implements Database.batchable<sObject>
{
    Public Set<String> PartyGroup;
    Public Set<String> IntSegment ;
    Public Set<String> MPS_Qualification;
    Public Set<String> ISS_Local_Priority;
    Public Set<String> TR_Status;
    Public Set<String> ISS_Coverage;
    //String id1='005i0000000ZKWl';
    List<Account> acct2;
    Public Set<String> Lexmark_Verticals;
    Public Boolean Flag;
    Public List<Database.saveresult> updateResults;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String Query ='SELECT id,username,LX_Ability_to_Create_Accounts__c FROM User where usertype=\'Standard\' and isactive=true';
        if(test.isRunningTest())
            Query += ' and id = '+'\''+UserInfo.getUserId()+'\'';            
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> User1)
    {
    List<User> users = new List<User>();
    List<User> users2 = new List<User>();
    Set<ID> ids = new Set<ID>();
        For(integer i=0; i<User1.size();i++)
        {   
            acct2 = new List<Account>();
            PartyGroup = new Set<String>();
            IntSegment = new Set<String>();
            MPS_Qualification = new Set<String>();
            ISS_Local_Priority = new Set<String>();
            TR_Status = new Set<String>();
            ISS_Coverage = new Set<String>();
            Lexmark_Verticals = new Set<String>();
            
        List<Account> acct1 =[Select id,LX_Sales_Team_Assigned__c,Type,TR_Status__c,ISS_Coverage_Model__c,Partner_ISS_Capability_Segment__c,MPS_Qualification__c,Local_Priority__c from account where Ownerid = :User1[i].id and (Recordtype.Developername ='Lx_Location_Customer' or Recordtype.Developername ='Lx_Location_Partner')and Coverage_Status__c ='Active' and (type!='Customer' OR ISS_Coverage_Model__c!='OLA')];
             For (Account acc : acct1)
            {
                if(acc.Type == 'Customer' && acc.TR_Status__c=='On')
                {
                    if(acc.ISS_Coverage_Model__c != null && acc.ISS_Coverage_Model__c != '--None--')
                    ISS_Coverage.add(acc.ISS_Coverage_Model__c);
                    System.debug(acc.MPS_Qualification__c);
                    if(acc.MPS_Qualification__c == null || acc.MPS_Qualification__c == 'Non MPS' || acc.MPS_Qualification__c == '--None--' || acc.MPS_Qualification__c == 'NA' || acc.MPS_Qualification__c == 'Na' || acc.MPS_Qualification__c == 'Off'|| acc.MPS_Qualification__c == 'OFF' || acc.MPS_Qualification__c == 'off')
                    {
                    MPS_Qualification.add('Non MPS');
                    System.debug('Inside');
                    }
                    else if(acc.MPS_Qualification__c == 'MPS' || acc.MPS_Qualification__c == 'On' || acc.MPS_Qualification__c == 'ON' || acc.MPS_Qualification__c == 'on')
                    MPS_Qualification.add('MPS');
                    if(acc.Local_Priority__c != null && acc.Local_Priority__c !='--None--')
                    ISS_Local_Priority.add(acc.Local_Priority__c);
                    if(acc.LX_Sales_Team_Assigned__c!='Partner' && acc.LX_Sales_Team_Assigned__c!='' && acc.LX_Sales_Team_Assigned__c!=null && acc.LX_Sales_Team_Assigned__c!='--None--')
                    Lexmark_Verticals.add(acc.LX_Sales_Team_Assigned__c);
                    acct2.add(acc);
                    PartyGroup.add(acc.Type);
                }
                if (acc.Type == 'Partner')
                {
                    if(acc.Partner_ISS_Capability_Segment__c != null && acc.Partner_ISS_Capability_Segment__c !='--None--')
                    IntSegment.add(acc.Partner_ISS_Capability_Segment__c);
                    PartyGroup.add(acc.Type);
                    acct2.add(acc);
                }

            }
            
            if(acct2.size() > 0)
            LX_user_territory_update.update_Terr(User1[i],PartyGroup,IntSegment,MPS_Qualification,ISS_Local_Priority,TR_Status,ISS_Coverage,Lexmark_Verticals); // Calling the method to calculate the fields on User record
            else 
            ids.add(User1[i].id);            
        }
        
        // Logic to update the users not holding any accounts.
        if(ids.size()>0)
        {
            users =[select LX_Sales_Territory_Type__c,LX_MPS__c,LX_Number_of_Lexmak_Verticals__c from user where usertype='Standard' and id in :ids and ((LX_Sales_Territory_Type__c != null and LX_Sales_Territory_Type__c != '') or LX_MPS__c !=false or LX_Number_of_Lexmak_Verticals__c != '0')];
            for (User us1 : Users)
            {
                Flag = false;
                if(us1.LX_Sales_Territory_Type__c != null && us1.LX_Sales_Territory_Type__c != '')
                {
                    us1.LX_Sales_Territory_Type__c ='';
                    Flag = true;
                }
                
                if(us1.LX_MPS__c !=false )
                {
                    us1.LX_MPS__c = false;
                    Flag = true;
                }
                if(us1.LX_Number_of_Lexmak_Verticals__c != null && us1.LX_Number_of_Lexmak_Verticals__c != '0')
                {
                    us1.LX_Number_of_Lexmak_Verticals__c = '0';
                    Flag = true;
                }
                if(flag==true)
                    users2.add(us1);
            }
             
            if(users2.size()>0)
            {
                updateResults = Database.update(users2,false);
                for(Integer i=0;i<updateResults.size();i++)
                {
                    if (!updateResults.get(i).isSuccess())
                        LX_CommonUtilities.createExceptionLog(updateResults.get(i).getErrors().get(0).getmessage()); // Creating the exception log record with the error message.
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }  
}