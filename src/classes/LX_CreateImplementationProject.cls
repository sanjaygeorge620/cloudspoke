public class LX_CreateImplementationProject {

    private final pse__Proj__c pro;
    private final static decimal Internal_costs=0.0;
    private final static decimal Other_Costs=0.0;
    
    public LX_CreateImplementationProject(ApexPages.StandardController stdController) {
    
        string oppId = ApexPages.currentPage().getParameters().get('oppId');
        string accId = ApexPages.currentPage().getParameters().get('accID');     
        string projID = ApexPages.currentPage().getParameters().get('projID'); 
        List<pse__Proj__c> projNameList = [select Name,pse__Project_Phase__c,pse__Opportunity__c,pse__Account__c from pse__Proj__c where id =: projID];
        this.pro= (pse__Proj__c)stdController.getRecord();
        
      /*  if(oppId != null){
            pro.pse__Opportunity__c = oppId;
        }
        
        if(accId != Null){
            pro.pse__Account__c = accId;
        }*/
            pro.Pre_Sales_Project_Name__c = projNameList[0].id;
            
            pro.pse__Project_Phase__c=projNameList[0].pse__Project_Phase__c;
            pro.pse__Opportunity__c=projNameList[0].pse__Opportunity__c;
            pro.pse__Account__c=projNameList[0].pse__Account__c;
            pro.pse__Start_Date__c     = Date.today();
            pro.pse__Internal_Costs__c = Internal_costs;
            pro.pse__Other_Costs__c    = Other_Costs;
            pro.ownerID=UserInfo.getUserId();
            pro.recordTypeID = Label.Project_RecordType_Implementation_ID;

           

    }


 
}