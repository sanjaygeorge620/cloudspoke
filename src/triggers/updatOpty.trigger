trigger updatOpty on Opportunity (after update) {

List<Opportunity> oldOpts = Trigger.old;
List<Opportunity> newOpts = Trigger.new;
   
//OpportunityAssignment.assignOpty(oldOpts, newOpts);
	

}