public class ControllerCase {
    private Case currentCase;
    ApexPages.StandardController standardController;
    public List<Case> relatedCases;
    public boolean showRows;
    
    public ControllerCase(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.currentCase = (Case)pcfController.getRecord();
 	    relatedCases = [select id, createdDate, subject, status, ownerid, owner.name, casenumber from case where parentid =: currentCase.id and (ContactId != null and Internal_Only_Case__c = false) ];
 	
    }
    
    
    //Related Cases to show in Customer Portal.  Hide ones with no contact and with Internal Only Case checked.
    public List<Case> getRelatedCases(){
    	//List<Case> relatedCases = new List<Case>();
    	
    	//relatedCases = [select id, createdDate, subject, status, ownerid, owner.name, casenumber from case where parentid =: currentCase.id and (ContactId != null and Internal_Only_Case__c = false) ];
    	return relatedCases;
    }

	public boolean getShowRows(){
		return (relatedCases!=null && relatedCases.size()>0);	
	}
	
}