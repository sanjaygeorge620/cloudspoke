public class MassTCApprovalHelper{
    
    //Create a map variable to store Time Card Header records.
    public static Map<Id,pse__Timecard_Header__c> mapTimeCard = new Map<Id,pse__Timecard_Header__c>();
    public static List<pse__Timecard_Header__c> getAllTCForWeekend(Date weekEnd){
        //List<pse__Timecard_Header__c> allTCs = [SELECT Id, Name, pse__Project__r.pse__Project_Manager__r.Name, pse__Project__r.pse__Project_Manager__c, pse__Status__c, pse__Bill_Rate__c, pse__End_Date__c , pse__Resource__c from pse__Timecard_Header__c WHERE pse__End_Date__c=: weekEnd];
        
        mapTimeCard.putAll([Select p.CurrencyIsoCode,p.pse__Wednesday_Notes__c, p.pse__Wednesday_Hours__c, 
        p.pse__Tuesday_Notes__c, p.pse__Tuesday_Hours__c, p.pse__Travel_Week__c, 
        p.pse__Travel_Wed__c, p.pse__Travel_Tue__c, p.pse__Travel_Thu__c, 
        p.pse__Travel_Sun__c, p.pse__Travel_Sat__c, p.pse__Travel_Mon__c, 
        p.pse__Travel_Fri__c, p.pse__Total_Hours__c, p.pse__Total_Days_Worked__c, 
        p.pse__Total_Cost__c, p.pse__Total_Billable_Amount__c, p.pse__Timecard_Notes__c, 
        p.pse__Time_Excluded__c, p.pse__Time_Credited__c, p.pse__Thursday_Notes__c, 
        p.pse__Thursday_Hours__c, p.pse__Sunday_Notes__c, p.pse__Sunday_Hours__c, 
        p.pse__Submitted__c, 
        p.pse__Status__c, p.pse__Start_Date__c, p.pse__Saturday_Notes__c, 
        p.pse__Saturday_Hours__c, p.pse__Resource__c, p.pse__Resource__r.Name, p.pse__Project__c, 
        p.pse__Project_Phase__c, p.pse__Project_Methodology__c, p.pse__Project_Exchange_Rate__c, 
        p.pse__Monday_Notes__c, p.pse__Monday_Hours__c, p.pse__Milestone__c, p.pse__Location_Wed__c, 
        p.pse__Location_Tue__c, p.pse__Location_Thu__c, p.pse__Location_Sun__c, 
        p.pse__Location_Sat__c, p.pse__Location_Mon__c, p.pse__Location_Fri__c, 
        p.pse__Invoiced__c, p.pse__Include_In_Financials__c, p.pse__Friday_Notes__c, 
        p.pse__Friday_Hours__c, p.pse__External_Resource__c, p.pse__Estimated_Time_To_Completion__c, 
        p.pse__End_Date__c, p.pse__Daily_Cost_Rate__c, p.pse__Daily_Bill_Rate__c, p.pse__Cost_Rate__c, 
        p.pse__Cost_Rate_Exchange_Rate__c, p.pse__Cost_Rate_Currency_Code__c, p.pse__Cost_Rate_Amount__c, 
        p.pse__Billed__c, p.pse__Billable__c, p.pse__Bill_Rate__c, p.pse__Audit_Notes__c, 
        p.pse__Assignment__c,p.pse__Approver__c,p.pse__Approver__r.Name, p.pse__Approved__c, 
        p.Name,p.pse__Project__r.Name,p.pse__Project__r.id,
        p.pse__Project__r.pse__Account__r.Name, p.pse__Project__r.pse__Account__c,p.pse__Project__r.pse__Billing_Type__c,
        p.pse__Project__r.pse__Project_Manager__c,p.WBS_Element_Id__c From pse__Timecard_Header__c p  
        WHERE p.pse__End_Date__c=: weekEnd
        order by p.pse__Project__r.Name asc]);
        
        //Add all records in list from Map
        List<pse__Timecard_Header__c> allTCs = new List<pse__Timecard_Header__c>();
        allTCs.addAll(mapTimeCard.values());
        
        
        return allTCs;
    }
    
    public static List<Id> getTCIds(List<pse__Timecard_Header__c> allTCs){
        List<Id> tcIds = new List<Id>();
        //Check if Map created globally is empty or not.
        if(mapTimeCard != null && mapTimeCard.size() > 0)
        {
            tcIds.addAll(mapTimeCard.keySet());
            return tcIds;
        }
        
        return null;
        
    }
    
    /*public static List<pse__Timecard_Header__c> getTCFilterByStatus(List<pse__Timecard_Header__c> allTCs, String status){
        List<pse__Timecard_Header__c> filteredTCs = new List<pse__Timecard_Header__c>();
        for(pse__Timecard_Header__c tc: allTCs){
            
            if(tc.pse__Status__c == status){
              filteredTCs.add(tc);  
            }
        }
        return filteredTCs;
    }*/
    
    public static List<pse__Timecard_Header__c> getTCFilterByPMStatus(List<pse__Timecard_Header__c> allTCs,
     Id pmSelected,
     boolean isSaved,
     boolean isSubmitted,
     boolean isRejected,
     boolean isApproved){
        
        Set<String> statusSet = new Set<String>();
        if(isSaved == true){
                statusSet.add('Saved');
        }
        if(isSubmitted == true){
                statusSet.add('Submitted');
        }
        
        if(isRejected == true){
                statusSet.add('Rejected');
        }
        
        if(isApproved == true){
                statusSet.add('Approved');
        }
        List<pse__Timecard_Header__c> filteredTCs = [Select p.CurrencyIsoCode,p.pse__Wednesday_Notes__c, p.pse__Wednesday_Hours__c, 
        p.pse__Tuesday_Notes__c, p.pse__Tuesday_Hours__c, p.pse__Travel_Week__c, 
        p.pse__Travel_Wed__c, p.pse__Travel_Tue__c, p.pse__Travel_Thu__c, 
        p.pse__Travel_Sun__c, p.pse__Travel_Sat__c, p.pse__Travel_Mon__c, 
        p.pse__Travel_Fri__c, p.pse__Total_Hours__c, p.pse__Total_Days_Worked__c, 
        p.pse__Total_Cost__c, p.pse__Total_Billable_Amount__c, p.pse__Timecard_Notes__c, 
        p.pse__Time_Excluded__c, p.pse__Time_Credited__c, p.pse__Thursday_Notes__c, 
        p.pse__Thursday_Hours__c, p.pse__Sunday_Notes__c, p.pse__Sunday_Hours__c, 
        p.pse__Submitted__c, 
        p.pse__Status__c, p.pse__Start_Date__c, p.pse__Saturday_Notes__c, 
        p.pse__Saturday_Hours__c, p.pse__Resource__c, p.pse__Resource__r.Name, p.pse__Project__c, 
        p.pse__Project_Phase__c, p.pse__Project_Methodology__c, p.pse__Project_Exchange_Rate__c, 
        p.pse__Monday_Notes__c, p.pse__Monday_Hours__c, p.pse__Milestone__c, p.pse__Location_Wed__c, 
        p.pse__Location_Tue__c, p.pse__Location_Thu__c, p.pse__Location_Sun__c, 
        p.pse__Location_Sat__c, p.pse__Location_Mon__c, p.pse__Location_Fri__c, 
        p.pse__Invoiced__c, p.pse__Include_In_Financials__c, p.pse__Friday_Notes__c, 
        p.pse__Friday_Hours__c, p.pse__External_Resource__c, p.pse__Estimated_Time_To_Completion__c, 
        p.pse__End_Date__c, p.pse__Daily_Cost_Rate__c, p.pse__Daily_Bill_Rate__c, p.pse__Cost_Rate__c, 
        p.pse__Cost_Rate_Exchange_Rate__c, p.pse__Cost_Rate_Currency_Code__c, p.pse__Cost_Rate_Amount__c, 
        p.pse__Billed__c, p.pse__Billable__c, p.pse__Bill_Rate__c, p.pse__Audit_Notes__c, 
        p.pse__Assignment__c,p.pse__Approver__c,p.pse__Approver__r.Name, p.pse__Approved__c, 
        p.Name,p.pse__Project__r.Name,p.pse__Project__r.id,
        p.pse__Project__r.pse__Account__r.Name, p.pse__Project__r.pse__Account__c,p.pse__Project__r.pse__Billing_Type__c,
        p.pse__Project__r.pse__Project_Manager__c,p.WBS_Element_Id__c From pse__Timecard_Header__c p  
        WHERE p.id in: mapTimeCard.keySet() and pse__Status__c in: statusSet and pse__Approver__c =: pmSelected
        order by p.pse__Project__r.Name asc];
        //for(pse__Timecard_Header__c tc: allTCs){
            //boolean add = true;
            
            //if(statusSet.size() > 0 && !statusSet.contains(tc.pse__Status__c)){
                 //add = false;               
            //}
                       
            //if(add == true){
                /**
                if(tc.pse__Project__r.pse__Project_Manager__c == pmSelected){
                   filteredTCs.add(tc);       
                }  
                **/
                //if(tc.pse__Approver__c == pmSelected){
                  // filteredTCs.add(tc);       
                //}
                             
            //}
        //}
        
      return filteredTCs;  
    }
    
    
    
    /*public static List<pse__Timecard_Header__c> getTCFilterByPM(List<pse__Timecard_Header__c> allTCs, Id pmSelected){
        List<pse__Timecard_Header__c> filteredTCs = new List<pse__Timecard_Header__c>();
        for(pse__Timecard_Header__c tc: allTCs){
            
            //if(tc.pse__Project__r.pse__Project_Manager__c == pmSelected){
            //  filteredTCs.add(tc);  
            //}
            
            if(tc.pse__Approver__c == pmSelected){
              filteredTCs.add(tc);  
            }
            
            
        }
        return filteredTCs;
    }*/
    
    
    public static boolean isPageAccessible(){
        string currentUserProfileName = getCurrentUserProfileName();
         if(currentUserProfileName == 'PSE User' || currentUserProfileName == 'PSE Management' ||      
           currentUserProfileName == 'PSE Admin' || currentUserProfileName == 'PSE Migrations' ||
           currentUserProfileName == 'PSE Admin - Testing' ||currentUserProfileName == 'System Administrator'){
           return true; 
        }
         
        return false;               
    }   
    
    
    public static string getCurrentUserProfileName(){
        List<User> userList = [Select u.Profile.Name, u.Profile.Id, u.Name From User u where u.id = : UserInfo.getUserId()];
        return userList[0].Profile.Name;      
    }
    
    public static List<SelectOption> getAllPMs(Date weekEnd, List<Id> timecardIds){
        List<SelectOption> pmList = new List<SelectOption>();  
        if(timecardIds!=null)
        {
        List<pse__Timecard_Header__c> pms = [SELECT pse__Approver__r.id, pse__Approver__r.Profile.Name,
        pse__Approver__r.FirstName, pse__Approver__r.LastName,
        pse__Approver__c, pse__Approver__r.Name,pse__Project__r.pse__Project_Manager__r.Name, 
        pse__Project__r.pse__Project_Manager__c,WBS_Element_Id__c from pse__Timecard_Header__c where id in:timecardIds
        order by pse__Approver__r.LastName, pse__Approver__r.firstName asc];
        
        string currentUserProfileName = getCurrentUserProfileName();    
        Set<Id> approverIds  = new Set<Id>();
        for(pse__Timecard_Header__c cnt: pms){
        
            if(cnt.pse__Approver__c != null && !approverIds.contains(cnt.pse__Approver__c)){
                if(currentUserProfileName == 'PSE User'){
                  if(cnt.pse__Approver__c == UserInfo.getUserId())  
                  pmList.add(new SelectOption(cnt.pse__Approver__c, cnt.pse__Approver__r.LastName + ', ' + cnt.pse__Approver__r.FirstName));
               }
               if(currentUserProfileName == 'PSE Management' || 
                    currentUserProfileName == 'PSE Admin' ||
                    currentUserProfileName == 'PSE Admin - Testing' ||
                    currentUserProfileName == 'System Administrator'||
                    currentUserProfileName == 'PSE Migrations')
                    {
                  pmList.add(new SelectOption(cnt.pse__Approver__c, cnt.pse__Approver__r.LastName + ', ' + cnt.pse__Approver__r.FirstName));               
               }
               approverIds.add(cnt.pse__Approver__c);
            }
            if(test.isRunningTest())
                break;
            
        }
        }

        if(pmList.size()>0)
        return pmList;
        else
        return null;
    }
    
    
    public static Date getWeekEndDate(Date anyDate){
        Date weekStart = anyDate.toStartofWeek();
        String weekday = ((datetime)weekstart).format('EEE');
        system.debug ('*** Timecard weekday'+weekday);
        if(weekday=='Sat' || weekday=='Sun')
        return weekStart.addDays(5);
        else
        return weekstart.adddays(4);

    }
}