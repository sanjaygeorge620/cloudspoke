public with sharing class ProcessInstallations_CreateCase {

    public static void ProcessInstallations_CreateCase(OpportunityLineItem lineItemRec, string errorMsg, List<Case> CasesToInsert, String ServerRecID){
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId();  
        
        //String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c; 
            String baseUrl =url.getSalesforceBaseUrl().toExternalform();     
           Case newCase = new Case();
           newCase.RecordTypeId = recordTypeId;
           //newCase.ContactId = '003e0000007HBI7';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'Enterprise';
           newCase.Urgency__c = 'Medium';
           newCase.Origin = 'Automation';
           newCase.Type = 'Request';
           newCase.Subject = 'BatchCreateInstallations';
           newCase.Description = 'Error Message: ' + errorMsg + '- within ProcessInstallations class.' + '\n'
                                + 'Link: ' + baseUrl + '/' + lineItemRec.id + '\n'
                                + 'Server Link: ' + baseUrl + '/' + ServerRecID;
                
           CasesToInsert.add(newCase);
    }

}