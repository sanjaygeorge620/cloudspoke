/* Trigger Name : setVsoe
* Description : Used to create and update MQLI records corresponding to the opportunity line items records created/updated
* Created By :  Veenu Trehan
* Created Date : 05-30-2013
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer         Date         Modification ID     Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*  Veenu Trehan   05-30-2013               Initial Version
* Veenu Trehan    12-20-2013               added logic for mqli creation
*/
trigger setVsoe on OpportunityLineItem (after Insert,after Update)
{

 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    // Trigger Switch
    Boolean LX_Switch = false; 
    static integer index = 0;    
    // Get current profile custom setting.
    LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
    // Get current Organization custom setting.
    LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
    // Get current User custom setting.
    LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
    
    // Allow the trigger to skip the User/Profile/Org based on the custom setting values
    if(LXUser != null)
        LX_Switch = LXUser.Bypass__c;
    else if(LXProfile != null)
        LX_Switch = LXProfile.Bypass__c;
    else if(LXOrg != null)
        LX_Switch = LXOrg.Bypass__c;
    if(LX_Switch)
        return;    

Map<id,OpportunityLineItem> OppLineMap=new Map<id,OpportunityLineItem>();
set<string> OppLinAndOppIdSet=new set<string>();
List<Opportunity> oppUpd = new list<Opportunity>();
set<id> OppSet= new set<id>();
    for(OpportunityLineItem opl : Trigger.New)
     {
         if((opl.Product_Family__c == 'Professional Services') && ( opl.Fair_Market_Value__c > opl.TotalPrice))
         {
         oppUpd.add(new opportunity(id = opl.OpportunityID,VSOE_Eligible__c = True));
         }
     }
     if(!oppUpd.isEmpty())
     {
       try{
         Update OppUpd;
        }catch(Exception ex){
            System.debug('>>>>>>>>>>>>>Could not update Opportunity>>>>>>>>>>>>>'+ex.getMessage());
            LX_CommonUtilities.createExceptionLog(ex);              
        }
     }
////////////////////////////////////

If(trigger.isUpdate||trigger.isInsert){
    if(LX_OpportunityLineItemHelper.isUpdated==true || LX_OpportunityLineItemHelper.trgCount<2 ){
        system.debug('call future method'+LX_OpportunityLineItemHelper.isUpdated);
        LX_OpportunityLineItemHelper.isUpdated=false;
        LX_OpportunityLineItemHelper.trgCount++;
        LX_OpportunityLineItemHelper.PopulateLX_Contract_Type(Trigger.NewMap.keyset());
        //LX_OpportunityLineItemHelper.isUpdated=true;
    }
    //LX_OpportunityLineItemHelper.PopulateLX_Contract_Type(Trigger.NewMap.keyset());
    //for loop to make a list of opp line items and a set of corresponding opportunities
    for(OpportunityLineItem opl : Trigger.New){
        if(trigger.isInsert){
            OppLineMap.put(opl.id,opl);
            OppSet.add(opl.OpportunityId);
        }
        ///////////
        //to check if any of the fields have changed for the update condition
        if(trigger.isUpdate && (opl.Part_Number__c!=trigger.oldmap.get(opl.id).Part_Number__c||opl.UnitPrice!=trigger.oldmap.get(opl.id).UnitPrice||opl.Parent_ID__c!=trigger.oldmap.get(opl.id).Parent_ID__c
        ||opl.Description!=trigger.oldmap.get(opl.id).Description||opl.Quantity!=trigger.oldmap.get(opl.id).Quantity||opl.PricebookEntry.Product2.id!=trigger.oldmap.get(opl.id).PricebookEntry.Product2.id
        ||opl.LX_Extra_Parts_Info__c !=trigger.oldmap.get(opl.id).LX_Extra_Parts_Info__c )){
            OppLineMap.put(opl.id,opl);//line item id, record
            
            OppSet.add(opl.OpportunityId);
            }
        }
       
         If(OppSet.size()>0 && !OppLineMap.isEmpty()){
            /*string QuoteStatus='Approved';
            //query the parent opportunites to pass them to the mqli update method
            map<id,Opportunity> ParentOpps=new map<id,Opportunity>([select id, name,Sales_Organization__r.LX_Country_Code__c,Quote_Status__c
                                            from Opportunity
                                            Where id IN:OppSet AND Quote_Status__c= :QuoteStatus]);
            //query the child opportunities to pass them to the mqli update method                                      
            map<id,Opportunity> ChildOpps=new map<id,Opportunity>([Select id, name,LX_Country_Code__c,CurrencyIsoCode,Master_Opportunity__c
                                                                from Opportunity
                                                                Where Master_Opportunity__c IN :OppSet ]);
            //query the line items as we need the pricebook.product2 field to pass to the mqli update method                                                            
            map<id,OpportunityLineItem> LineMap=new map<id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.Quote_Status__c,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c 
                                                                                    from OpportunityLineItem
                                                                                    where ID IN :OppLineMap.keyset() AND Opportunity.Quote_Status__c= :QuoteStatus]); 
                                                        
             //system.debug('#####first value-->'+ParentOpps.values[0].Sales_Organization__r.LX_Country_Code__c);                                                                   
             system.debug('##ParentOpps---->'+ParentOpps);
             system.debug('##ChildOpps---->'+ChildOpps);
             system.debug('##OppLineMap---->'+OppLineMap);
             //calling the mqli update method to create/update the mqli records*/                                                         
             //LX_OpportunityLineItemHelper.mqliUpdate1(ParentOpps, ChildOpps, LineMap);
            /*Commented by Shubhashish to check batch class logic LX_OpportunityLineItemHelper.mqliUpdateMultiFuture(Oppset) ;   */                                                                                  
         }                                                                                   
        
}
////////////////////////////////////

}