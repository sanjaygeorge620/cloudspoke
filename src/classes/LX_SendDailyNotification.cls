/* Class Name   : LX_SendDailyNotification  
    * Description   : This is a class which will be scheduled to send the emails if STAR requests are in corresponding queues for more than 2 days. 
    * Created By   : Maruthi Kolla
    * Created Date : 01-08-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla        01-08-2014               1000                Initial Version    
    */
    
public class LX_SendDailyNotification {
//Variable declarations
public List <STAR__c> star_Requests = new List <STAR__c>();
Set<ID> idSet = new Set<ID>();
public List <STAR__c> star_Requests_Toupdate = new List <STAR__c>();

//Map of STAR qeuues
MAP<ID,Group> star_queues = new Map<ID,Group>([SELECT DeveloperName,Id,Type FROM Group WHERE Type = 'Queue' AND DeveloperName LIKE '%LX_STAR%']);

/*  Description : This is for setting the flag values to true for STAR requests. This flag will fire the corresponding WF rules and sends the emial to respective queue.
    *  Param - no params
    *  Returns :  VOID
    */
public void sendEmail()
{
//Collecting the STAR requests that are in STAR queues.
star_Requests = [Select LX_Send_Email__c,CreatedDate from STAR__c where ownerid in :star_queues.keyset()];

//Logic to set the flag if STAR requests that are in STAR queues for more than 2 days 
        for (STAR__c req:star_Requests)
        {  
        Boolean Flag_temp= False;
        DateTime dT = req.CreatedDate;
        Integer no_of_days = Integer.valueof(Label.LX_STAR_emailescalation_days);
        String weekday = dT.format('EEE');
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
            if((weekday =='Thu' || weekday =='Fri' || weekday =='Sat') && (date.today()>= myDate.addDays(no_of_days+2))) 
            Flag_temp = True;
            else if((weekday =='Sun') && (date.today()>= myDate.addDays(no_of_days+1))) 
            Flag_temp = True;
            else if(date.today()>= myDate.addDays(no_of_days))
            Flag_temp = True;
           if(Flag_temp)
            {
                req.LX_Send_Email__c=true;
                idSet.add(req.id);
                star_Requests_Toupdate.add(req);                
            } 
        }
        
    update star_Requests_Toupdate; // updating the flag to true to fire the corresponding WF rules(for sending the emails to queues) for STAR requests
    setFlags(idSet);
  }      
        /*  Description : This is for setting the flag values to flase.
    *  Param - no params
    *  Returns :  VOID
    */
    
    Public static void setFlags(Set<ID> idSet1)
    {
        List<STAR__c> Star_req = [Select LX_Send_Email__c from  STAR__c where id in :idSet1];
        List<STAR__c> Stars_Toupdate = new List<STAR__c>();
        
    //Logic for setting the flag values to false for the STAR requests after sending the email
     for (STAR__c Starcreated:Star_req)
        {
        Starcreated.LX_Send_Email__c = false;
        Stars_Toupdate.add(Starcreated);
        
        }
        update Stars_Toupdate; // updating the flag for STAR requests to false .
    }
 
}