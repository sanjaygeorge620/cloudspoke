public class ControllerClasses {
	
	public List<Training_Attendee__c> attendees = new List<Training_Attendee__c>();
	public Class__c currentClass;
    ApexPages.StandardController standardController;
	
	public String emails;
	
    public ControllerClasses(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.currentClass = (Class__c)pcfController.getRecord();
        
        attendees = 
        		[select contact__r.email
        			from Training_Attendee__c 
        			where Class__c =: currentClass.Id
        			];
    }
    
    public String getEmails(){
    	emails = '';
    	for(Training_Attendee__c t : attendees){
    		if(t.Contact__r.email != null){
    			
    			emails = emails + t.Contact__r.email + ', ';

    		}
    		
    	}
    	
    	if(attendees.size()>0 && emails.trim().endsWith(',')){
    		emails = emails.trim();
    		emails = emails.substring(0, emails.length()-1);
    	}
    	
    	return emails;
    }
}