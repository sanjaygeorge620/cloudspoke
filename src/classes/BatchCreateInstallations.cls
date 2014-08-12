/*********************************************************************************
Name : BatchCreateInstallations 
Created By : Bharti Mehta(Appirio Offshore)
Created Date : 29 Dec 2010
Usages : This Batch Apex class iterates over Opportunities with a batch size of 1 and call CreateInstalltions process.   
*********************************************************************************/

global class BatchCreateInstallations implements Database.Batchable<sObject>, Database.Stateful{
    global final String Query;

    global BatchCreateInstallations(String q){
        Query = q; 
    }
    
    global BatchCreateInstallations(){
        Query = 'SELECT Id, QAStatus__c, SAP_Sent__c, Contract_Number__c, SAP_Status__c FROM Opportunity WHERE InstallationStatus__c = \'In Queue\'';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> opportunities){
        // We are guaranteed to have only one opportunity, since the batch size is 1
        Opportunity opp = opportunities.get(0);
        Boolean sendEmail = false;
        String expValue;
        
        // Confirm that we are still In Queue
        if ([select InstallationStatus__c from opportunity where id = :opp.Id].InstallationStatus__c != 'In Queue') {
            // some other thread is already processing this record
            return;
        }

        try {
            opp.InstallationStatus__c = 'Processing';
            update opp;
            system.debug('inBatchCreateInstallation - oppStatus - processing?' + opp);
            new CreateInstallations(opp.Id).process();

            opp.InstallationStatus__c = 'Completed';
            update opp;
            system.debug('inBatchCreateInstallation - oppStatus - Completed?' + opp);
            sendEmail = true;
            expvalue = 'Its All good.';
            
        }
        catch (Exception e) {
            system.debug('exception:' + e);
            // XXX what if this update fails -- we can't return the status to In Queue, and this will be missed. 
            // In this case, we will email an exception.
            sendEmail = true;
            expValue = e.getMessage();
            
       //   opp.InstallationStatus__c = 'In Queue';
       //   system.debug('inBatchCreateInstallation - oppStatus - In Queue?' + opp);
       //   update opp;
        }
        system.debug('expValue: ' + expValue);
        if (sendEmail){
            //ApexPages.addMessages(expValue);  
            system.debug('expValue: ' + expValue);

            Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Id recordTypeId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId();  
            
            String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c; 
                     
            Case newCase = new Case();
            newCase.RecordTypeId = recordTypeId;
            newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId; 
            newCase.Status = 'New';
            newCase.Impact__c = 'Enterprise';
            newCase.Urgency__c = 'Medium';
            newCase.Origin = 'Automation';
            newCase.Type = 'Request';
            newCase.Subject = 'BatchCreateInstallations';
            newCase.Description = 'Exception: ' + expValue + '\n'
                                + 'Opportunity ID: ' + opp.id + '\n'
                                + 'Contract Number: ' + opp.contract_Number__c + '\n'
                                + 'SAP Status: ' + opp.SAP_Status__c + '\n'
                                + 'QA Status: ' + opp.QAStatus__c + '\n'
                                + 'SAP Sent Flag: ' + opp.SAP_Sent__c + '\n'
                                + 'Link: ' + baseUrl + '/' + opp.id;
                
            insert newCase;

        }
    }

    global void finish(Database.BatchableContext BC){
    }
}