/******************************************************************************
Trigger Name   : PSE_BillingEventItemSetLaborCategAccNo
Created by     : Appirio
Created Date   : December 15, 2009
Purpose        : Copy the Labor Category Account Number from the 
                 Timecard Split or Misc. Adjustment Record.
Mod Date       : Febuary 10, 2009
Mod Description: Added Extract_Label__c, Extract_Opportunity_Sector__c, 
                 Extract_Company_Number__c, Extract_Billing_End_Date__c this
                 is to facilitate the Cast Iron/Softrax invoice extract process.
Next Mod Date :  March 31,2010
Mod Description : Added Extract PO Number with project PO Number
********************************************************************************/
trigger PSE_BillingEventItemSetLaborCategAccNo on pse__Billing_Event_Item__c (after insert) {

 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code

    Set<String> setMiscAdjustmentIds = new Set<String>();
    Set<String> setTimecardSplitIds = new Set<String>();

    Map<ID, pse__Miscellaneous_Adjustment__c> mapMiscAdjustments;
    Map<ID, pse__Timecard__c> mapTimecardSplits; 
    for (pse__Billing_Event_Item__c BEI : Trigger.new) {    
        // build list of Timecards and Misc. Adjustments
        if (BEI.pse__Category__c == 'Timecard') {
            setTimecardSplitIds.add(BEI.pse__Object_Id__c);
        } else if (BEI.pse__Category__c == 'Miscellaneous Adjustment') {
            setMiscAdjustmentIds.add(BEI.pse__Object_Id__c);
        }
    }
    
    // build list of Misc. Adjusts if there are any in the BE
    if (setMiscAdjustmentIds.size() > 0) {
        mapMiscAdjustments = new Map<ID, pse__Miscellaneous_Adjustment__c>([SELECT
                Labor_Category_Account_Number__c 
                FROM pse__Miscellaneous_Adjustment__c
                WHERE Id IN :setMiscAdjustmentIds]);
    }
    
    // build list of Timecards if there are any in the BE
    if (setTimecardSplitIds.size() > 0) {
        mapTimecardSplits = new Map<ID, pse__Timecard__c>([
                SELECT Labor_Category_Account_Number__c, pse__Timecard_Header__r.pse__Resource__r.Name,
                pse__Billing_Event_Item__r.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c,
                pse__Billing_Event_Item__r.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c
                FROM pse__Timecard__c WHERE Id IN :setTimecardSplitIds]);
    }
        

    // Set the "Extract" fields that are common to every BEI (regardless if it's a Timecard or Misc. Adjust).  Note, we 
    // need to do a query to get the relationship fields.
    Set<ID> BEI_Id = new Set<ID>(); 
    for (pse__Billing_Event_Item__c BEI : Trigger.new) {
        // build list of BEI's
        BEI_Id.add(BEI.id);
        system.debug('***DEBUG*** BEI Before Insert Trigger  Step 1:'+ BEI.id);
    }
    
    // query BEI's
    Boolean flagUpdate = false;
    List< pse__Billing_Event_Item__c > Update_BEIs = new List< pse__Billing_Event_Item__c >();
    update_BEIs = database.query('SELECT Name, pse__Project__r.Name, pse__Project__r.pse__Project_Manager__r.Name,pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c,pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c,pse__Project__r.pse__Opportunity__r.Sector__c, pse__Project__r.pse__Account__r.Company_Number__c,pse__Project__r.PO_Number__c,pse__Category__c, pse__Object_Id__c FROM pse__Billing_Event_Item__c WHERE Id IN :BEI_Id');
        // Rahul Comment 7/24. Switching to dynamic SOQL to leverage the switching of Company_Number__c field.  
        
                /*[SELECT Name, pse__Project__r.Name, pse__Project__r.pse__Project_Manager__r.Name, 
                pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c,
                pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c,
                pse__Project__r.pse__Opportunity__r.Sector__c, pse__Project__r.pse__Account__r.Company_Number__c,
                pse__Project__r.PO_Number__c,pse__Category__c, pse__Object_Id__c
                FROM pse__Billing_Event_Item__c WHERE Id IN :BEI_Id];
                */
   
     for(pse__Billing_Event_Item__c BEI:update_BEIs){
        
        // Set Extract fields that are specific to Timecard and Misc.Adjustments. BEI's
        if (BEI.pse__Category__c == 'Miscellaneous Adjustment' && mapMiscAdjustments.containsKey(BEI.pse__Object_Id__c)) {
            BEI.Labor_Category_Account_Number__c = mapMiscAdjustments.get(BEI.pse__Object_Id__c).Labor_Category_Account_Number__c;
            
            // Build the label for the Misc. Adjust by concatinatingn the last 5 chars of the BEI name
            BEI.Extract_Label__c = 'Miscellaneous Adjustment - ' + BEI.Name.substring(BEI.Name.Length()-5); 
            
        } else if (BEI.pse__Category__c == 'Timecard' && mapTimecardSplits.containsKey(BEI.pse__Object_Id__c)) {
            BEI.Labor_Category_Account_Number__c = mapTimecardSplits.get(BEI.pse__Object_Id__c).Labor_Category_Account_Number__c;

            // Build the label for the Timecard as "Name - start date - end date"
        //*    date End_Date = mapTimecardSplits.get(BEI.pse__Object_Id__c).pse__Billing_Event_Item__r.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c;
        //*    date Start_Date = mapTimecardSplits.get(BEI.pse__Object_Id__c).pse__Billing_Event_Item__r.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c;
            string Start_Date =''; 
            string End_Date = '';
            if(BEI.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c!=null){
                Start_Date = BEI.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c.format();
            }
            if(BEI.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c!=null){
                End_Date = BEI.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c.format();
            }
            BEI.Extract_Label__c = mapTimecardSplits.get(BEI.pse__Object_Id__c).pse__Timecard_Header__r.pse__Resource__r.Name + ' - ' + Start_Date + ' to ' + End_Date;

        }

     // Update the BEI Extract fields
        BEI.Extract_Project_Name__c = BEI.pse__Project__r.Name + '-' + BEI.pse__Project__r.pse__Project_Manager__r.Name;
        BEI.Extract_Opportunity_Sector__c = BEI.pse__Project__r.pse__Opportunity__r.Sector__c;
        if((BEI.pse__Project__r.pse__Account__r != null)&&(BEI.pse__Project__r.pse__Account__r.get('Company_Number__c') != null)){
            BEI.Extract_Company_Number__c = string.valueOF(BEI.pse__Project__r.pse__Account__r.get('Company_Number__c'));
        }
        BEI.Extract_Billing_End_Date__c = BEI.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c;
        BEI.Extract_Billing_Start_Date__c = BEI.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c;
        // update Extract field PO Number by Project PO Number (Added on 31st Mar 2010)
        BEI.Extract_PO_Number__c = BEI.pse__Project__r.PO_Number__c;
        flagUpdate = true;
    }
    System.debug('Flag Update '+flagUpdate+'update BEI '+Update_BEIs);
    if(flagUpdate)
      update Update_BEIs;
   
}