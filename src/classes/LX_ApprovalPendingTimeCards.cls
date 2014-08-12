/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-30-2013
 *
 * Author : Akanksha Gupta
 * 
 * Description : This class is being used to check for timecards that are pending approvals.

**/ 
public with sharing class LX_ApprovalPendingTimeCards {
	
	// list of timecards where the status is in 'Submitted' state.
	list<pse__Timecard_Header__c> pendingApprovals = new list<pse__Timecard_Header__c>();
	
	// Get the current dau so that we can decide when the job is being executed.
	String day=DateTime.now().format('EEEE'); 
    DateTime dt=Datetime.now();
    ID currentUserID = Userinfo.getUserId();
    
    list<pse__Permission_Control__c> updatePermissionControls = new list<pse__Permission_Control__c>();
	
  /*
	*		Description : This method is used to determine the timecards that are still in the submitted state and havent been approved yet.]
  	*/
	public void execute(){
		
		//get all the timecards that is in the submitted state.
		pendingApprovals  = [select id,LX_Tuesday_Checkbox__c,LX_Monday_Checkbox__c, 
							 pse__Resource__r.pse__Salesforce_User__c,pse__Resource__c 
							 from pse__Timecard_Header__c 
							 where pse__Status__c = 'Submitted'];
		system.debug('>>>>>>>>>>>>>pendingApprovals>>>>>>>>>'+pendingApprovals);
		system.debug('>>>>>>>>>>>>>day>>>>>>>>>'+day);
		
		//Loop through the timecard and based on the day the code is being executed, ensure you check the right checkbox							 
		for(pse__Timecard_Header__c timeCard :pendingApprovals){
			updatePermissionControls.add(new pse__Permission_Control__c(	pse__User__c = currentUserID,
																		pse__Resource__c =timeCard.pse__Resource__c,
																		pse__Timecard_Entry__c = true,
																		LX_ReminderCheck__c = true ));
			//If the code is being executed on a Monday update the LX_Monday_Checkbox__c field 			
			if(day =='Monday'){
				timeCard.LX_Monday_Checkbox__c = true;
			} else{//If the code is being executed on a Tuesday update the LX_Tuesday_Checkbox__c field
				timeCard.LX_Tuesday_Checkbox__c = true;	
			}
		}					 
		
		//If there are any pending approvals, update the records with the appropriate values.
		if(pendingApprovals.size() > 0){
			try{
				insert updatePermissionControls;
				update pendingApprovals;
				updatePermissionControls = [select id from pse__Permission_Control__c
													  where LX_ReminderCheck__c = true];
				
				delete updatePermissionControls;
				//database.update(pendingApprovals,false); 
			}catch (exception ex){
				LX_CommonUtilities.createExceptionLog(ex);
			}
		}
	}
}