public class GenerateCard{

    public GenerateCard(ApexPages.StandardSetController controller) {
        if(!Test.isRunningTest()){
        controller.addFields(editableFields);
        } 
        setCon = controller;
    }

    ApexPages.StandardSetController setCon;

    // Initialize setCon and return a list of records
    public List<Requirements__c> getOpportunities() {
        List<Requirements__c> ListReq = new List<Requirements__c>();
        return (List<Requirements__c>) setCon.getSelected();
          
    }
    
    public string domainName {
        public get{
            if(domainName ==null){
             List<Site> siteObj = [select id,subdomain from site where name='QRScan'];
             if(!siteObj.isEmpty()){
                 domainName = siteObj[0].subdomain; 
                 return 'https://'+domainName+'.secure.force.com';
              }
              else
              return null;
            }
            else
             return null;            
        }
        private set{
        }
    }
    
    public List<String> editableFields {
        public get {
        if (editableFields == null) {
        editableFields = new List<String>();
        editableFields.add('name');
        editableFields.add('Story_Points_Dummy__c');
        editableFields.add('User_Type__c');
        editableFields.add('User_Story__c');
        editableFields.add('So_that__c');
        editableFields.add('User__r.Name');
        editableFields.add('Supporting_BA__r.name');
        editableFields.add('Developer_Name__c');
        editableFields.add('Functional_Area__c');
        //editableFields.add('Sub_Process__c ');
        
        
        }
        return editableFields ;
        }
        private set;
        }
}