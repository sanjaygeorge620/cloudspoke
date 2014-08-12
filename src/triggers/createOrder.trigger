trigger createOrder on Opportunity (after insert, after update) 
{
For(Opportunity Opprec : trigger.new)
{
if(FirstRun_Check.FirstRun_OrderShellCreation)
{
Order__c OrderShellRec = createOpportunityOrderShell.createOpportunityOrderShell(oppRec.id );
FirstRun_Check.FirstRun_OrderShellCreation = False;
}
}
}