/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-30-2013
 *
 * Author : Akanksha Gupta
 * 
 * Description : This class is being used to check for missing timecards for each Assignment and then check the corresponding checkboxes.

**/ 

public class LX_MissingTimecardNotification{
	
	//This list is to get all the assignments that are active during the given week.
    List <pse__Assignment__c> assign=new List <pse__Assignment__c>();
    
	//These variables have been set to update the values Assignment values.
    Set <pse__Assignment__c> assigntoupdate=new Set <pse__Assignment__c>();
    List <pse__Assignment__c> assigntoupdatelist=new List <pse__Assignment__c>();
    
    
    String day=DateTime.now().format('EEEE'); 
    DateTime dt=Datetime.now();
    Integer mytime=dt.hour();
    
  /*
  *		Description : This method is used to determine the timecards that havent been submitted for a week.
  */
    public void checkConditions()
    {
   
        /*assign = [SELECT id,pse__Billable_Hours_Submitted__c,pse__Is_Billable__c,
                 pse__Assignment__c.pse__Schedule__r.pse__Week_Total_Hours__c,
                 pse__Assignment__c.pse__Project__r.pse__Billing_Type__c,
                 pse__Resource__r.pse__Is_Resource_Active__c,pse__Resource__r.pse__Exclude_From_Missing_Timecards__c,
                 pse__End_Date__c,pse__Start_Date__c  
                 from pse__Assignment__c 
                 WHERE pse__Project__c != '' AND (pse__Status__c = 'Scheduled' OR pse__Status__c = 'Closed') AND 
                 pse__Assignment__c.pse__Project__r.pse__Billing_Type__c != null AND
                 pse__Billable_Hours_Submitted__c = 0
                 AND pse__Resource__r.pse__Is_Resource_Active__c = true
                 AND pse__Resource__r.pse__Exclude_From_Missing_Timecards__c = false
                 AND pse__Start_Date__c < Today];
			*/
   		//Query to get all the scheduled Assignments that are either scheduled or closed, dont have any billed timecards entered 
   		//and have active resources associated to it.

   		//Query to get all the scheduled Assignments that are either scheduled or closed, dont have any billed timecards entered 
   		//and have active resources associated to it.
		list<pse__Assignment__c> assignments;
		
		
		
		if(day == 'Tuesday'){
			date tempDate = date.today().addDays(-4);
				assignments = [Select id, 
								(Select pse__End_Date__c, pse__Start_Date__c, pse__Total_Hours__c From pse__Timecards__r
								WHERE pse__End_Date__c >= TODAY 
								AND pse__Start_Date__c <= TODAY
								AND pse__Total_Hours__c != 0
								AND pse__Total_Hours__c != NULL
								AND pse__Status__c != 'Rejected'
								AND pse__Status__c != 'Saved'
								AND pse__Status__c != 'Un-Approved') 
								from pse__Assignment__c
								WHERE pse__Resource__r.pse__Is_Resource_Active__c = true
	     						AND pse__Resource__r.pse__Exclude_From_Missing_Timecards__c = false
	     						AND pse__Start_Date__c <= Today AND 
	     						pse__End_Date__c >= :tempDate];
		}else{
					assignments = [Select id, 
									(Select pse__End_Date__c, pse__Start_Date__c, pse__Total_Hours__c From pse__Timecards__r
									WHERE pse__End_Date__c >= TODAY 
									AND pse__Start_Date__c <= TODAY
									AND pse__Total_Hours__c != 0
									AND pse__Total_Hours__c != NULL
									AND pse__Status__c != 'Rejected'
									AND pse__Status__c != 'Saved'
									AND pse__Status__c != 'Un-Approved') 
									from pse__Assignment__c
									WHERE pse__Resource__r.pse__Is_Resource_Active__c = true
	         						AND pse__Resource__r.pse__Exclude_From_Missing_Timecards__c = false
	         						AND pse__Start_Date__c <= Today AND 
	         						pse__End_Date__c >= Today];
			
		} 

        for(pse__Assignment__c assignment:assignments) {
        	if(assignment.pse__Timecards__r.size() == 0){	
                if(day == 'Monday'){//If its a monday then ensure that Missing Time Email Check box should be checked and Monday checkbox should also be checked
                    if(mytime >12){//If its a monday and after 12 then ensure that Missing Time Email Check box should be checked and Monday 
						assigntoupdate.add(new pse__Assignment__c(id=assignment.id,
														 Send_Missing_Timecard_Email__c=true, 
														 Monday_Checkbox__c = true,
														 Send_Email_to_PM__c = true,
														 Friday_Checkbox__c = false ));                	

                    }else{
					assigntoupdate.add(new pse__Assignment__c(id=assignment.id,
														 Send_Missing_Timecard_Email__c=true, 
														 Monday_Checkbox__c = true,
														 Send_Email_to_PM__c = false,
														 Friday_Checkbox__c = false ));                	
                    }
                }else{//If its Friday, ensure that the Friday Checkbox is checked.
					assigntoupdate.add(new pse__Assignment__c(id=assignment.id,
													 Send_Missing_Timecard_Email__c=true, 
													 Monday_Checkbox__c = false,
													 Send_Email_to_PM__c = false,
													 Friday_Checkbox__c = true ));                	
                }
        	}
        }
    	
    	system.debug('>>>>>>>>>>>>>>>assigntoupdate>>>'+assigntoupdate);
       assigntoupdatelist.addAll(assigntoupdate);
        update assigntoupdatelist; 
   }
}