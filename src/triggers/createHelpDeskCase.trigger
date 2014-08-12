trigger createHelpDeskCase on pse__Timecard_Header__c (after insert,after update)
{
 if(LX_CommonUtilities.ByPassBusinessRule())
 {
  return;  
 }
 
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('HelpDesk').getRecordTypeId();
        
List<Case> toIns = new List<Case>();

for(pse__Timecard_Header__c Tc : Trigger.new)
{
if((Trigger.isInsert && Tc.WBS_Error_Message__c == 'Multiple Matching WBS Elements Found') || (Trigger.isUpdate && Trigger.oldmap.get(Tc.id).pse__Status__c != Tc.pse__Status__c && Tc.pse__Status__c == 'Multiple Matching WBS Elements Found'))
{

string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Tc.ID;

   
                Case newCase = new Case();
                newCase.RecordtypeID = recordTypeId; 
                newCase.Status = 'New';
                newCase.Timecard__c = Tc.id;
                newCase.Impact__c = 'Enterprise';
                newCase.Urgency__c = 'High';
                newCase.Origin = 'Cases';
                newCase.Type = 'Request';                
                newCase.Category__c = 'Enterprise Application';
                newCase.Level_1__c = 'Salesforce.com';                
                newCase.Subject = 'Multiple Matching WBS Elements Found';               
                newCase.Description = 'Timecard:'+ '\n'+ 'Link: '+Url;  
                toIns.add(newCase);
}
}
if(!toIns.isEmpty())
{
insert toIns;
}
}