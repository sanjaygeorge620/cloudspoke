public class CreateCRRecordFromProject {
    
    public pse__Proj__c project{get;set;}
    public Opportunity opportunity{get;set;}
    public pse__Budget__c budget{get;set;}
    public Boolean isRegionRequired{get;set;}
    public Boolean isPracticeRequired{get;set;}
    public Boolean isGroupRequired{get;set;}
    
    public CreateCRRecordFromProject(ApexPages.StandardController  stdController){
        String recordId = stdController.getId();
        String budgetName = '- CR Budget';
        if(recordId != null){
            for(pse__Proj__c proj : [select Id,Name
                                            , pse__Region__c
                                            ,pse__Practice__c
                                            ,pse__Group__c
                                            ,pse__Account__c
                                            ,pse__Account__r.OwnerId
                                            ,pse__Account__r.LX_Software_AEX__c
                                            ,pse__Account__r.ISR__c
                                            , OwnerId 
                                            ,pse__Opportunity__c
                                            ,pse__Opportunity__r.Name
                                            ,pse__Opportunity__r.AccountId
                                            ,pse__Opportunity__r.pse__Region__c
                                            ,pse__Opportunity__r.pse__Practice__c
                                            ,pse__Opportunity__r.pse__Group__c 
                                         from pse__Proj__c  
                                         where id = : recordId ]){
                project = proj;             
                
            }
            if(project != null){
                opportunity = new Opportunity(Name = '- CR',
                                              pse__Is_Services_Opportunity__c = true,
                                              pse__Is_Change_Request__c = true,
                                              pse__Primary_Project__c = project.id,
                                              CloseDate = Date.Today());
                if(project.pse__Opportunity__c != null){
                    opportunity.Name = project.pse__Opportunity__r.Name+'- CR';
                    opportunity.pse__Parent_Opportunity__c = project.pse__Opportunity__c;
                    opportunity.accountId = project.pse__Opportunity__r.accountId;
                    opportunity.pse__Region__c = project.pse__Opportunity__r.pse__Region__c;
                    opportunity.pse__Practice__c = project.pse__Opportunity__r.pse__Practice__c;
                    opportunity.pse__Group__c = project.pse__Opportunity__r.pse__Group__c;
                    budgetName = project.pse__Opportunity__r.Name + budgetName;
                }else{
                    opportunity.pse__Region__c = project.pse__Region__c;
                    opportunity.pse__Practice__c = project.pse__Practice__c;
                    opportunity.pse__Group__c = project.pse__Group__c;
                }
            }else{
                opportunity = new Opportunity();
                
            }          
            opportunity.Software_Solutions__c = true;
            opportunity.LX_Sales_Type__c      = 'Add On';
            //parentOppy.LX_CR_Related_Opportunity__c = oppyid;
            //parentOppy.LX_Change_Request__c = 'Yes';
            opportunity.LX_CR_Related_Opportunity__c =  project.pse__Opportunity__c;
            opportunity.LX_Change_Request__c = 'Yes';           
            budget = new pse__Budget__c(Name = budgetName, pse__Project__c = project.id,pse__Account__c = project.pse__Opportunity__r.accountId,pse__Effective_Date__c = Date.Today(),pse__Status__c = 'Draft');
          
        }
    }
    
    public PageReference cancel(){
        return new PageReference('/'+project.id);
    }
    public PageReference Create()
    {
        PageReference pageRef;
        try{
            Id recordTypeId;
            Id campaignId;
            if(budget.pse__Amount__c > opportunity.Amount){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Budget Amount must be less than to Opportunity Amount'));
                return null;
            }
            if( Opportunity.Name.length() > 28){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Length of Opportunity Name is must be less than 28 Characters.'));
                return null;
            }
            for(RecordType rt : [select Id,Name from RecordType where DeveloperName ='Expansion_Add_On' and SobjectType='Opportunity' limit 1]){
                recordTypeId = rt.id; 
            }
            for(Campaign ca :[Select Id From Campaign  where Name ='R - Employee - Professional Services' limit 1]){
                campaignId = ca.id;
            }
            opportunity.StageName = 'Closing';
           
          // SK commented on 10/4/2013 as type is defaulted based on Opportunity record type selection page.. opportunity.Type = 'Expansion Add On';
           
           opportunity.Software_Solutions__c = true ;
            //VT 7/11changed the nextstep field from standard to custom field
            opportunity.Next_Steps__c= 'ISR to send Change Request to customer.';
            opportunity.pse__Is_Services_Opportunity__c = true;
            if(recordTypeId != null){
                opportunity.RecordTypeId = recordTypeId;
            }
            opportunity.LeadSource = 'Professional Services';
            if(campaignId != null){
                opportunity.CampaignId = campaignId;
            }
            if(project.pse__Account__c != null){
                opportunity.OwnerId = project.pse__Account__r.LX_Software_AEX__c;
                opportunity.ISR__c = project.pse__Account__r.ISR__c;
                //opportunity.pse__Parent_Opportunity__r.pse__Is_Change_Request__c = true;
            }else{
                opportunity.OwnerId = project.OwnerId;
            }
     //Insert Opportunity 
                
            insert opportunity;      
                 
                 System.debug('opp created');  
                 System.debug('opp created Parent Oppy'+opportunity.pse__Parent_Opportunity__c);
                 System.debug('opp created'+opportunity.id); 
            
            budget.pse__opportunity__c = opportunity.id;
            
            if (opportunity.id != null)
            {
                string oppyid;
                string oppyid2;
                oppyid = opportunity.id;
                oppyid2 = opportunity.pse__Parent_Opportunity__c;
                List<Opportunity> opplst = [select id, name, pse__Is_Change_Request__c From Opportunity where id =: oppyid2 Limit 1];
                if(!opplst.isEmpty())
                {
                Opportunity parentOppy = opplst[0];
                //parentOppy.LX_CR_Related_Opportunity__c = oppyid;
                //parentOppy.LX_Change_Request__c = 'Yes';
                update parentOppy;                
                }
            
            }  
            
     //send notification regarding new opportunity
            List<String> SendTo = new List<String>();
           SendTo.add(opportunity.OwnerId);
           SendTo.add(opportunity.ISR__c);
            system.debug('sendTo : ' + sendTo);
            List<ID> contactIdList= GetContactFromUserList.getContactFromUserList(sendTo);  
            system.debug('contactIDList: ' + contactIdList); 
            if (contactIdList.size()>0){
                NotifyNewOpportunity_Project.NotifyNewOpportunity_Project(contactIDList, opportunity.id);
            }
    //insert budget //   
            insert budget;
            pageRef = new PageReference('/'+opportunity.id);        
        
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        return pageRef;
    }
    public List<SelectOption> getBudgetTypes(){
        List<SelectOption> budgetTypes = new List<SelectOption>();
        budgetTypes.add(new SelectOption('Customer Purchase Order Change Request','Customer Purchase Order Change Request'));
        budgetTypes.add(new SelectOption('Internal Budget Change Request','Internal Budget Change Request'));
        budgetTypes.add(new SelectOption('Customer Purchase Order','Customer Purchase Order'));        
        budgetTypes.add(new SelectOption('Internal Budget','Internal Budget'));
        return budgetTypes;
    }

}