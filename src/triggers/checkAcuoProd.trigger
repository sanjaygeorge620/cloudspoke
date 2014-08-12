trigger checkAcuoProd on OpportunityLineItem (after insert,after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code

if(FirstRun_Check.FirstRun_checkAcuoProd)
{
set<ID> prodset = new set<ID>();
set<ID> pbeset = new set<ID>();
set<id> OppSet = new set<id>();
List<OpportunityLineItem> pbelst = new List<OpportunityLineItem>();
List<Opportunity> oplst = new List<Opportunity>();
Set<Opportunity> opset = new Set<Opportunity>();
for(OpportunityLineItem OLI : Trigger.new)
    {
        prodset.add(OLI.id);
    }
 pbelst = [Select ID,OpportunityID,Opportunity.Contains_Acuo_Prod__c,PricebookEntry.Product2.Use_Sizing_Tool__c from opportunitylineitem where id in:prodset];
 
 for(OpportunityLineItem OLI : pbelst)
 { 
  if(OLI.PricebookEntry.Product2.Use_Sizing_Tool__c && !OLI.Opportunity.Contains_Acuo_Prod__c)
  {
  	OppSet.add(OLI.OpportunityID);
  	//opset.add(new opportunity(ID = OLI.OpportunityID,Contains_Acuo_Prod__c = True));
  }
 }   
	if(OppSet.size() > 0){
		LX_OpportunityHelper.updateAcuoOpp(OppSet);
	}
	
}
}