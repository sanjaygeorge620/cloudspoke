trigger OpportunityAssignmentToTerritory on Opportunity (after insert, after update) {

List<Opportunity> oldOpts = Trigger.old;
List<Opportunity> newOpts = Trigger.new;
   
//UpdateOptyTrtry.assignOpty(oldOpts, newOpts);
}