//Written By Perceptive IS 07/16

trigger updateLexVertical on Lead (before insert,before update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
Map<String,SIC_to_Lexmark_Verticals__c> sicMap = new Map<String,SIC_to_Lexmark_Verticals__c>();
Set<String> sicSet = new Set<String>();
List<Lead> leadLst = new List<Lead>();

if(Trigger.isInsert)
{
for(Lead L : Trigger.New)
{
/*Deloitte USI: Expedite Lead Functionality added below
Record type: Simple Customer and Simple Partner
*/
    LX_Lead_util.PopulateOnwerFields(L);
    if(L.SIC_Code__c != '')
    {
        sicSet.add(L.SIC_Code__c);
        leadLst.add(L);
    }    
}
}
if(Trigger.isUpdate)
{
for(Lead L : Trigger.new)
{
    /*Deloitte USI: Expedite Lead Functionality added below
Record type: Simple Customer and Simple Partner
*/
    LX_Lead_util.PopulateOnwerFields(L);
if(Trigger.oldmap.get(L.id).SIC_Code__c != L.SIC_Code__c && L.SIC_Code__c != '' )
{
sicSet.add(L.SIC_Code__c);
leadLst.add(L);
}
}
}
if(!sicSet.isEmpty() && !leadLst.isEmpty())
{
List<SIC_to_Lexmark_Verticals__c> sicLst = New List<SIC_to_Lexmark_Verticals__c>();

sicLst = [Select ID,Lexmark_Sub_Vertical__c,Lexmark_Vertical__c,SIC_8__c from SIC_to_Lexmark_Verticals__c where SIC_8__c in: sicSet];

if(!sicLst.isEmpty())
{
for(SIC_to_Lexmark_Verticals__c sc : sicLst)
{
if(sc.SIC_8__c != '')
{
sicMap.put(sc.SIC_8__c,sc);
}
}
}

for(Lead L : leadLst)
{
if(L.SIC_Code__c != '' && sicMap.containskey(L.SIC_Code__c))
{
 system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' +sicMap.get(L.SIC_Code__c).Lexmark_Vertical__c);
 system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' +sicMap.get(L.SIC_Code__c).Lexmark_Sub_Vertical__c);
 
L.Sector__c = sicMap.get(L.SIC_Code__c).Lexmark_Vertical__c;
L.Vertical_Subtype__c = sicMap.get(L.SIC_Code__c).Lexmark_Sub_Vertical__c;
}
}
}
}