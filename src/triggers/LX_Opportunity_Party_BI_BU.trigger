/*
Class Name : LX_Quick_Bid_AI_AU
Description : As per User Story US4167 .Trigger to Auto create/update Partner record in the Opportunity Party Object when a quick bid opportunity is created.
                Also sets the default values for Purchasing Method, Timing of Discount, claiming Party & Ship/Debit
Created By : Shubhashish Rai <shrai@deloitte.com>
Created Date : 28-July-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai   28-July-2014           1000               Initial Version to set the Default Values. 
Sanjay Chaudhary  29-July-2014                              Updated to calcualte Sold To , ZIDC & Sales Org on Create/Update. 
*************************************************************************/

trigger LX_Opportunity_Party_BI_BU on LX_Opportunity_Parties__c (before insert, before update) {

// Logic to set the SOLD To , ZIDC & Sales Organization based on the Opportunity Party 'Partner's' creation/update.    

    List<LX_Opportunity_Parties__c> oppPartyUpdateList = new List<LX_Opportunity_Parties__c>();
    List<LX_Opportunity_Parties__c> oppPartyList = new List<LX_Opportunity_Parties__c>();
    Map<String,String> oppPartyAccountMap = new Map<String,String>();
    Map<String, String> oppPartyAccountMdmIdMap = new Map<String, String>();
    Map<String,String> mdmIdSoldToIdMap = new Map<String,String>();
    Map<String,String> mdmSoldToIdMap = new Map<String,String>();
    Map<String,String> soldToSalesOrgMap = new Map<String,String>();

       for (LX_Opportunity_Parties__c oppParty: Trigger.new)
       {
           system.debug('**oppParty.LX_Opportunity_Record_Type_Id__c**'+oppParty.LX_Opportunity_Record_Type_Id__c+'**Label.LX_QuickBid_RecordTypeId**'+Label.LX_QuickBid_RecordTypeId);
           if (oppParty.LX_Opportunity_Record_Type_Id__c == Label.LX_QuickBid_RecordTypeId && oppParty.LX_Opportunity_Party_Type__c == 'Partner' && (oppParty.LX_MDM_Account_Number__c !=null || oppParty.LX_MDM_Id__c != null ) && (Trigger.isInsert || (Trigger.isUpdate && oppParty.LX_Account__c != Trigger.oldMap.get(oppParty.id).LX_Account__c)))
           {
               oppPartyAccountMap.put(oppParty.Id,oppParty.LX_MDM_Account_Number__c)  ; 
               oppPartyAccountMdmIdMap.put(oppParty.Id, oppParty.LX_MDM_Id__c);
               oppPartyUpdateList.add(oppParty); 
               system.debug('**oppPartyAccountMap**'+oppPartyAccountMap+'**oppPartyAccountMdmIdMap**'+oppPartyAccountMdmIdMap+'**oppPartyUpdateList**'+oppPartyUpdateList);   
           }
           if (oppParty.LX_Opportunity_Record_Type_Id__c == Label.LX_QuickBid_RecordTypeId && (oppParty.LX_Opportunity_Party_Type__c == 'Partner' && oppParty.LX_MDM_Account_Number__c == null && oppParty.LX_MDM_Id__c == null) && (Trigger.isUpdate && oppParty.LX_Account__c != Trigger.oldMap.get(oppParty.id).LX_Account__c) )
           {
               oppParty.LX_Sold_To__c=null;
               oppParty.LX_Account_Sales_Organization__c = null;
           }
       }
 
        if (oppPartyUpdateList.size()>0)
        {
        for (LX_SAP_Record__c sapRec:[Select Id,LX_MDM_Act__c,LX_MDM_ID__c, Name from LX_SAP_Record__c where LX_MDM_Act__c =: oppPartyAccountMap.values() and recordtype.name='Sold To' and LX_Status__c='Active'])    
            mdmIdSoldToIdMap.put(sapRec.LX_MDM_Act__c,sapRec.Id);        
            
        for (LX_SAP_Record__c sapRec:[Select Id,LX_MDM_Act__c,LX_MDM_ID__c, Name from LX_SAP_Record__c where LX_MDM_ID__c =: oppPartyAccountMdmIdMap.values() and recordtype.name='Sold To' and LX_Status__c='Active'])    
            mdmSoldToIdMap.put(sapRec.LX_MDM_ID__c,sapRec.Id); 
            
        for(LX_SAP_Record_Sales_Org__c slsOrg:[Select Id,Name,Sales_Org_Name__c,LX_Sold_To__c from LX_SAP_Record_Sales_Org__c where (LX_Sold_To__c in:mdmIdSoldToIdMap.values() or LX_Sold_To__c in:mdmSoldToIdMap.values()) and LX_Status__c='Active'])
            soldToSalesOrgMap.put(slsOrg.LX_Sold_To__c,slsOrg.Id);                       
        
        for (LX_Opportunity_Parties__c op:oppPartyUpdateList) {   
            if (mdmIdSoldToIdMap.get(oppPartyAccountMap.get(op.Id)) != null){
                op.LX_Sold_To__c = mdmIdSoldToIdMap.get(oppPartyAccountMap.get(op.Id)); 
                op.LX_Account_Sales_Organization__c = soldToSalesOrgMap.get(mdmIdSoldToIdMap.get(oppPartyAccountMap.get(op.Id)));
                }
            
            if (mdmIdSoldToIdMap.get(oppPartyAccountMap.get(op.Id)) == null && mdmSoldToIdMap.get(oppPartyAccountMdmIdMap.get(op.Id)) != null ) {   
                op.LX_Sold_To__c = mdmSoldToIdMap.get(oppPartyAccountMdmIdMap.get(op.Id));
                op.LX_Account_Sales_Organization__c = soldToSalesOrgMap.get(mdmIdSoldToIdMap.get(oppPartyAccountMap.get(op.Id)));
                }
            oppPartyList.add(op);
            }                         
       }                
   
}