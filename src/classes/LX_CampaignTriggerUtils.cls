/* Class Name   : LX_CampoaignTriggerUtils 
* Description   : This is a utility class to update the Rating and Country_Account_Rating__c columns on account object.
* Created By   : Srinivas
* Created Date : 11-06-2013 
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Srinivas           13-08-2013                                  Initial Version
*/

Public Class LX_CampaignTriggerUtils{

    /* Description : It accepts collection of campaign records and updates notification dates based on Actual start date.
    *  Param - lstCampaignRecords : Collection of Campaign records 
    *  Returns :  void.
    */
    public static void updateNotificationDates(list<Campaign> lstCampaignRecords){
    
        //iterate campaing records and caliculate notification dates.
       // Campaign objCampaign;
        for(Campaign objCampaign : lstCampaignRecords)
        {
            if(objCampaign.Actual_Start_Date__c == null) return;
            if(objCampaign.Lx_Campaign_Opt_Out__c == 'Notification Only')
            {
                //Notification date should be 48 hours before actual start date.
                objCampaign.Lx_Notification_Date__c = objCampaign.Actual_Start_Date__c.addDays(-2);
                //Dead line for request for long opt out type is 5 business days before actual start date.
                objCampaign.Lx_Deadline_for_Requests__c = null;
                //Dead line for approval for long opt out type is 2 business days before actual start date.
                objCampaign.Lx_Deadline_for_Approvals__c = null;
                
            }
            else if(objCampaign.Lx_Campaign_Opt_Out__c == 'Long Opt-Out')
            {
                //Notification date should be 10 business days before actual start date.
                objCampaign.Lx_Notification_Date__c = calicluateBusinessDays(objCampaign.Actual_Start_Date__c,10);
                //Dead line for request for long opt out type is 5 business days before actual start date.
                objCampaign.Lx_Deadline_for_Requests__c = calicluateBusinessDays(objCampaign.Actual_Start_Date__c,5);
                //Dead line for approval for long opt out type is 2 business days before actual start date.
                objCampaign.Lx_Deadline_for_Approvals__c = calicluateBusinessDays(objCampaign.Actual_Start_Date__c,2);
            }
            else if(objCampaign.Lx_Campaign_Opt_Out__c == 'Short Opt-Out')
            {
                //Notification date should be 10 business days before actual start date.
                objCampaign.Lx_Notification_Date__c = calicluateBusinessDays(objCampaign.Actual_Start_Date__c,5);
                //Dead line for request for long opt out type is 5 business days before actual start date.
                objCampaign.Lx_Deadline_for_Requests__c = calicluateBusinessDays(objCampaign.Actual_Start_Date__c,3);
                //Dead line for approval for long opt out type is 2 business days before actual start date.
                objCampaign.Lx_Deadline_for_Approvals__c = calicluateBusinessDays(objCampaign.Actual_Start_Date__c,1);
            }
            else if(objCampaign.Lx_Campaign_Opt_Out__c == 'Ongoing Opt-Out' || objCampaign.Lx_Campaign_Opt_Out__c == '')
            {
                //Notification date should be 10 business days before actual start date.
                objCampaign.Lx_Notification_Date__c = null;
                //Dead line for request for long opt out type is 5 business days before actual start date.
                objCampaign.Lx_Deadline_for_Requests__c = null;
                //Dead line for approval for long opt out type is 2 business days before actual start date.
                objCampaign.Lx_Deadline_for_Approvals__c = null;
            }
            
        }
    
    
    }
    
     /* Description : Caliclulates business days by skipping weekends based on actual start date.
    *  Param - dateActual:Actual Date
    *  NoOfBusniessdays - iBusinessDays integer
    *  Returns :  Date.
    */
    
    public static Date calicluateBusinessDays(date dateActual,integer iBusinessDays){
        Datetime dtFormattedDate = getNotifyDate(dateActual,iBusinessDays);
        //return date
        return dtFormattedDate.dateGMT();
        //return date.newinstance(dtFormattedDate.year(), dtFormattedDate.month(), dtFormattedDate.day());
        
    
    } 
    
    /* Description : returns notification date by skipping weekends based on actual start date.
    *  Param - dateActual:Actual start Date
    *  Param - iMaxDays: no of business days
    *  Returns :  DateTime.
    */
    private static DateTime getNotifyDate(Datetime dtActualStartDate,Integer iMaxDays)
    {
        system.debug('dtActualStartDate == '+dtActualStartDate);
        system.debug('iMaxDays == '+iMaxDays);
        Integer iCount = 0;
        DateTime dtReturnDate = dtActualStartDate;
        Decimal dWeekendDays = (iMaxDays / 7);
        dWeekendDays = dWeekendDays.setScale(0, RoundingMode.UP);
        Integer iBusinessDays = iMaxDays + Integer.valueOf(dWeekendDays);
        system.debug('iBusinessDays == '+iBusinessDays);
        Integer ivar = 0;
        while(iCount < 20)
        {
            dtReturnDate = dtActualStartDate.adddays(-iCount);
            system.debug('dtReturnDate == '+dtReturnDate);
            system.debug('dtReturnDate.format == '+dtReturnDate.format('E'));
            
            String strDay = dtReturnDate.format('E');
            system.debug(' strDay ' + strDay);
            if(strDay == 'Sat' || strDay == 'Sun')
            {
                iCount++;
                continue;               
            }
            iCount++;
            ivar++;
            system.debug('iCount== '+iCount);
            system.debug('ivar == '+ivar);
            if(ivar > iMaxDays)
                break;
           
        }
        system.debug('After Formatting dtReturnDate== '+dtReturnDate);
        return dtReturnDate;
        
    }

}