public class LX_CreateProjectfromPreSales {

    public String recordType {get; set;}
   // private final pse__Proj__c pro;
    public LX_CreateProjectfromPreSales(ApexPages.StandardController stdController) {
        
            }
    public pageReference continueToProject(){
    
        string projID = ApexPages.currentPage().getParameters().get('projID'); 
        //List<pse__Proj__c> projNameList = [select Name,pse__Project_Phase__c,pse__Opportunity__c,pse__Account__c from pse__Proj__c where id =: projID];
        
        pse__Proj__c projName = [select Name,pse__Is_Active__c,pse__Project_Status_Notes__c,pse__Project_Status__c,pse__Start_Date__c,pse__End_Date__c,pse__Region__c,pse__Region__r.name,pse__Practice__c,pse__Practice__r.name,pse__Group__c,pse__Group__r.name,pse__Project_Manager__c,Project_Manager_Name__c,pse__Project_Phase__c,pse__Opportunity__c,pse__Opportunity__r.name,pse__Account__c,pse__Account__r.name from pse__Proj__c where id =: projID LIMIT 1];
        
        PageReference pageRef;
        String db=Label.Project_RecordType_DatabaseServices;
        String msi=Label.Project_RecordType_MSImplementation_ID;
        String msu=Label.Project_RecordType_MSUpgrades_ID;
        String ps=Label.Project_RecordType_ProfessionalServices_ID;
        String imp=Label.Project_RecordType_Implementation_ID;
        String proj=Label.Project_ID;
        if(recordType.equals('Database Services')){
            pageRef = new PageReference(Label.PageRef);
            PageRef.getParameters().put(Label.retURL,Label.PageReferReturnURL);
            PageRef.getParameters().put('RecordType',db);
            PageRef.getParameters().put('ent',proj);
            PageRef.getParameters().put(Label.pse_Account,projName.pse__Account__c);
            PageRef.getParameters().put(Label.pse_Account_r,projName.pse__Account__r.name);
            PageRef.getParameters().put(Label.pse_Opportunity,projName.pse__Opportunity__c);
            PageRef.getParameters().put(Label.pse_Opportunity_r,projName.pse__Opportunity__r.name);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
            
        }
        if(recordType.equals('MS Implementation')){
            pageRef = new PageReference(Label.PageRef);
            PageRef.getParameters().put(Label.retURL,Label.PageReferReturnURL);
            PageRef.getParameters().put('RecordType',msi);
            PageRef.getParameters().put('ent',proj);
             PageRef.getParameters().put(Label.pse_Account,projName.pse__Account__c);
            PageRef.getParameters().put(Label.pse_Account_r,projName.pse__Account__r.name);
            PageRef.getParameters().put(Label.pse_Opportunity,projName.pse__Opportunity__c);
            PageRef.getParameters().put(Label.pse_Opportunity_r,projName.pse__Opportunity__r.name);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
        }
        if(recordType.equals('MS Upgrades')){
            pageRef = new PageReference(Label.PageRef);
            PageRef.getParameters().put(Label.retURL,Label.PageReferReturnURL);
            PageRef.getParameters().put('RecordType',msu);
            PageRef.getParameters().put('ent',proj);
             PageRef.getParameters().put(Label.pse_Account,projName.pse__Account__c);
            PageRef.getParameters().put(Label.pse_Account_r,projName.pse__Account__r.name);
            PageRef.getParameters().put(Label.pse_Opportunity,projName.pse__Opportunity__c);
            PageRef.getParameters().put(Label.pse_Opportunity_r,projName.pse__Opportunity__r.name);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
        }
        if(recordType.equals('Professional Services')){
            pageRef = new PageReference(Label.PageRef);
            PageRef.getParameters().put(Label.retURL,Label.PageReferReturnURL);
            PageRef.getParameters().put('RecordType',ps);
            PageRef.getParameters().put('ent',proj);
             PageRef.getParameters().put(Label.pse_Account,projName.pse__Account__c);
            PageRef.getParameters().put(Label.pse_Account_r,projName.pse__Account__r.name);
            PageRef.getParameters().put(Label.pse_Opportunity,projName.pse__Opportunity__c);
            PageRef.getParameters().put(Label.pse_Opportunity_r,projName.pse__Opportunity__r.name);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
            PageRef.getParameters().put(Label.pse_Project,projName.pse__Project_Phase__c);
        }
        if(recordType.equals('ISS Implementation')){
            pageRef = new PageReference(Label.PageRef);
            PageRef.getParameters().put(Label.retURL,Label.PageReferReturnURL);
            PageRef.getParameters().put('RecordType',imp);
            PageRef.getParameters().put('ent',proj);
             PageRef.getParameters().put(Label.pse_Account,projName.pse__Account__c);
            PageRef.getParameters().put(Label.pse_Account_r,projName.pse__Account__r.name);
            PageRef.getParameters().put(Label.pse_Opportunity,projName.pse__Opportunity__c);
            PageRef.getParameters().put(Label.pse_Opportunity_r,projName.pse__Opportunity__r.name);
            //commenting the below line as part of US2813 
            //PageRef.getParameters().put('00Ni0000001vABS',projName.pse__Project_Phase__c);
            //PageRef.getParameters().put('00Ni0000001vABS',projName.pse__Project_Phase__c);
            PageRef.getParameters().put(Label.projName_id,projName.id);
            PageRef.getParameters().put(Label.projName_Name,projName.Name);
            PageRef.getParameters().put(Label.pse_Project_Manager,projName.pse__Project_Manager__c);
            PageRef.getParameters().put(Label.Project_Manager_Name,projName.Project_Manager_Name__c);
            PageRef.getParameters().put(Label.pse_Region,projName.pse__Region__c);
            PageRef.getParameters().put(Label.pse_Region_r,projName.pse__Region__r.name);
            PageRef.getParameters().put(Label.pse_Practice,projName.pse__Practice__c);
            PageRef.getParameters().put(Label.pse_Practice_r,projName.pse__Practice__r.name);
            PageRef.getParameters().put(Label.pse_Group,projName.pse__Group__c);
            PageRef.getParameters().put(Label.pse_Group_r,projName.pse__Group__r.name);
            PageRef.getParameters().put(Label.pse_Project_Status,projName.pse__Project_Status__c);
            PageRef.getParameters().put(Label.pse_Project_Status_Notes,projName.pse__Project_Status_Notes__c);
            PageRef.getParameters().put(Label.pse_Is_Active_c,'1');
            //Adding the below logic as part of US2813
            PageRef.getParameters().put(Label.FinalPageRef,'0');
            
           
            
        }

            
        return pageRef;
        
    }
}