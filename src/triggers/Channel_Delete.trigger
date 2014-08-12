trigger Channel_Delete on Case (after update) 
{

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
    
list<Case> toDelete = new List<Case>();
list<Case> toprocess = new List<Case>();

toprocess = [SELECT Ready_To_Delete__c,owner.name FROM Case where ID in: Trigger.Newmap.Keyset()];

for(Case c : toprocess)
{
system.debug('Ready to Delete ' +c.Ready_To_Delete__c);
system.debug('Ready to Delete old ' +Trigger.oldmap.get(c.id).Ready_To_Delete__c);
system.debug('Owner name' +c.Owner.Name);
if(c.Ready_To_Delete__c == true && Trigger.oldmap.get(c.id).Ready_To_Delete__c != true && c.Owner.Name == 'Channel.Delete')
{
toDelete.add(c);
}
}
system.debug('ToDelete' +toDelete);
Try
{
Delete toDelete;
}
catch (DMLException e) 
{                          
  ErrorLogUtility.createErrorRecord(e.getMessage(),'Error while Deleting Channel.Delete Cases','High','DML');
}

}