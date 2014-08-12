public class LX_CreateProjectFromOpp {

    private final pse__Proj__c proj;
    private final static decimal Internal_costs=0.0;
    private final static decimal Other_Costs=0.0;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public LX_CreateProjectFromOpp (ApexPages.StandardController stdController) {
        string oppId = ApexPages.currentPage().getParameters().get('oppId');
        string accId = ApexPages.currentPage().getParameters().get('accID');
          
        this.proj= (pse__Proj__c)stdController.getRecord();
        
        if(oppId != null){
            proj.pse__Opportunity__c = oppId;
        }
        
        if(accId != Null){
            proj.pse__Account__c = accId;
        }
            proj.pse__Project_Phase__c = 'Ready for Assignment';
            proj.pse__Billing_Type__c = 'Pre-Sales';
            proj.pse__Start_Date__c     = Date.today();
            proj.pse__Internal_Costs__c = Internal_costs;
            proj.pse__Other_Costs__c    = Other_Costs;
            proj.ownerID=UserInfo.getUserId();          
            proj.recordTypeID = Label.Project_RecordType_PreSales_ID;
            

        
    }

}