/*
    Created by Michael Fitzgerald
    Date: June 2014
    Description: Add custom buttons and functionality to the new lead creattion

*/
public with sharing class LeadRecordTypeSelection {

    public LeadRecordTypeSelection(ApexPages.StandardController controller) {

    }

        public class leadException extends Exception {}

    //========================================================
    // Recordtypes
    //========================================================
        public string selectedType{get;set;}
        public List<SelectOption> getleadTypes() {
             List<SelectOption> Options = new List<SelectOption>();
            for(Recordtype r: LeadRecordtypes){
                options.add(new SelectOption(r.id, r.Name));
            }
            return options;
        }
        
        
        public list<recordtype> LeadRecordtypes{
            get{
                if(LeadRecordtypes==null){
                    LeadRecordtypes = [SELECT Id, Description, DeveloperName, Name FROM RecordType WHERE SobjectType = 'lead' AND IsActive = true order by name];
                }
                return LeadRecordtypes;
            }
            set;
        }

            
    //========================================================
    // Action Buttons
    //========================================================
        //Cancel
        public pagereference Cancel(){
            string returl = ApexPages.currentPage().getParameters().get('retURL');
            
            PageReference Pg;
            
            //Redirect back to returl or tab.
            if(returl!=null && returl!=''){
                Pg = new PageReference(retURL);
            }else{    
                Pg = new PageReference('/' + Lead.sObjectType.getDescribe().getKeyPrefix());
            }    
            Pg.setRedirect(true);
            return Pg; 
        }
    
        //Continue Custom
        public pagereference btnContinueCustom(){
            try{

              PageReference Pg = new PageReference('/apex/datacom_lead');
              Pg.getParameters().put('retURL', ('/apex/LeadRecordTypeSelection'));
              Pg.getParameters().put('RecordType', selectedType);
              Pg.getParameters().put('ent', 'Lead');
              Pg.getParameters().put('nooverride', '1');
              Pg.setRedirect(true);
              return Pg; 
              
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getmessage()));
                return null;
            }
        }
        //Continue
        public pagereference btnContinue(){
            try{
              
              PageReference Pg = new PageReference('/' + Lead.sObjectType.getDescribe().getKeyPrefix() + '/e');
              Pg.getParameters().put('retURL', ('/apex/LeadRecordTypeSelection'));
              Pg.getParameters().put('RecordType', selectedType);
              Pg.getParameters().put('ent', 'Lead');
              Pg.getParameters().put('nooverride', '1');
              Pg.setRedirect(true);
              return Pg; 
              
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getmessage()));
                return null;
            }
        }
}