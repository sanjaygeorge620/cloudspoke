/*
Class Name : LX_OppPricePrdct_Approval_BD
Description : As per US4116 to not allow users delete a Quick Bid Opportunity Pricelist Product directely even if they have delete access at the Profile leve.  
Created By : Ravi Teja Kamma (rkamma@deloitte.com)
Created Date : 04-Aug-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Ravi Teja Kamma    04-Aug-2014                            Created 
*************************************************************************/
trigger LX_OppPricePrdct_Approval_BD on LX_Opportunity_Pricelist_Product__c (before delete) {

if(LX_CommonUtilities.ByPassBusinessRule()) return;    //Shubhashish Rai - Added Bypass  

set<id> oppPricePrdctIDS = new set<id>();
for(LX_Opportunity_Pricelist_Product__c oppPricePrdct: trigger.old){
system.debug('------>@@@@' + oppPricePrdct.id);
    if(oppPricePrdct.LX_Opportunity__r.RecordtypeId == Label.LX_QuickBid_RecordTypeId){
    oppPricePrdctIDS.add(oppPricePrdct.id);}
}

if(oppPricePrdctIDS.size() >0){
list<LX_Opportunity_Pricelist_Product__c> listoppPricePrdct = new list<LX_Opportunity_Pricelist_Product__c>();

listoppPricePrdct = [select id,LX_Opportunity__r.LX_In_Approval_Process_Quick_Bid__c,LX_Opportunity__r.RecordTypeId from
                     LX_Opportunity_Pricelist_Product__c where id in : oppPricePrdctIDS];
                     
for(LX_Opportunity_Pricelist_Product__c oppPricePrdct: listoppPricePrdct)
{
 if(oppPricePrdct.LX_Opportunity__r.RecordtypeId == Label.LX_QuickBid_RecordTypeId && oppPricePrdct.LX_Opportunity__r.LX_In_Approval_Process_Quick_Bid__c){
 oppPricePrdct.adderror('User is not allowed to Edit/Delete the Products Directely for a Quick Bid. Please use the link Select Quick Bid Products');
 }
}
}

}