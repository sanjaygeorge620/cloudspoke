/***************************************************************************
Trigger Name   : PSE_AutoCreateMilestonesMiscAdjustments
Created by     : Appirio
Created Date   : November 11, 2009
Purpose        : Project Trigger that auto creates Milestones and 
                 Misc Adjustments when Billing Type = Fixed Price
Mod Date       : February 9, 2010
Mod Description: Misc. Adjustments will use new "Pre-Billed" field for first 
                 invoice, so only a 'final invoice' Misc. Adjustment needs to be
                 created from now on.  Also, added a lookup for Labor Category Id
*****************************************************************************/

trigger PSE_AutoCreateMilestonesMiscAdjustments on pse__Proj__c (before insert, after insert, before update) {
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

    for (pse__Proj__c  projinsert : Trigger.New) {
    if (Trigger.isInsert && Trigger.isBefore && (projinsert.pse__Billing_Type__c=='Fixed Price' || projinsert.pse__Billing_Type__c=='T&M/Fixed') )
        projinsert.pse__Is_Active__c = true;    
    }
    
    // Create a list for new milestones and new misc. adjustments
    List< pse__Milestone__c > new_milestones = new List< pse__Milestone__c >();
    List< pse__Miscellaneous_Adjustment__c > new_mas = new List< pse__Miscellaneous_Adjustment__c >();
    
    
    for(pse__Proj__c  proj : Trigger.New){ 
        
        // If Project Billing Type is 'Fixed Price' and it was not previously set, insert Milestones and Misc. Adjustments, check
        if((Trigger.isInsert && Trigger.isAfter && (proj.pse__Billing_Type__c=='Fixed Price' || proj.pse__Billing_Type__c=='T&M/Fixed') ) || (Trigger.isUpdate && (proj.pse__Billing_Type__c=='Fixed Price' || proj.pse__Billing_Type__c=='T&M/Fixed') && proj.pse__Is_Active__c && System.Trigger.oldMap.get(proj.Id).pse__Billing_Type__c==null && System.Trigger.oldMap.get(proj.Id).pse__Is_Active__c)){
        system.debug ('Inside After Insert'+proj.Id);
//        proj.pse__Is_Active__c = true;
        integer i=[select count() from pse__Milestone__c where  pse__Project__c=:proj.Id];
        
            if(i !=1) 
            {
                // JL 2013-07-18: Insert new 1 Milestone Record if the project Billing Type is
                // Fixed Price or T&M Fixed
                pse__Milestone__c pm =    new pse__Milestone__c ( Name = 'Marker for setup',
                                    pse__Project__c = proj.Id,
                                    //pse__Description__c = '',
                                    pse__Milestone_Amount__c = 0,
                                    pse__Milestone_Cost__c = 0,
                                    pse__Status__c = 'Open',
                                    pse__Target_Date__c = proj.pse__Start_Date__c + 15,
                                    CurrencyIsoCode = proj.CurrencyIsoCode);           
                new_milestones.add(pm);
            }

            // JL 2013-07-18: Create a single miscellaneous adjustment if the project Billing Type is Fixed Price
            if(proj.pse__Billing_Type__c=='Fixed Price' && proj.pse__Is_Active__c)
            {
                Labor_Category__C Labor_Cat = [Select Id From Labor_Category__c where Name = 'Fixed Price'];
                integer j=[select count() from pse__Miscellaneous_Adjustment__c where pse__Project__c =:proj.Id];
                if(j!=1)
                {
                    pse__Miscellaneous_Adjustment__c pma=new pse__Miscellaneous_Adjustment__c ( 
                        Name = 'Marker for Setup',
                        pse__Project__c = proj.Id,
                        pse__Description__c = '',
                        pse__Amount__c = 0,
                        pse__Status__c = 'Draft',
                        pse__Effective_Date__c = proj.pse__Start_Date__c + 15,
                        Target_Date__c = proj.pse__Start_Date__c + 15,
                        pse__Transaction_Category__c = 'Ready-to-Bill Revenue',
                        Labor_Category__c = Labor_Cat.Id,
                        CurrencyIsoCode = proj.CurrencyIsoCode);
                    new_mas.add(pma);
                }
            }
        }
    }
    System.debug('New Milestones ###'+new_milestones.size());
    System.debug('New Mas ###'+new_mas.size());
    if(!new_mas.isEmpty()) insert new_mas;
    if(!new_milestones.isEmpty()) insert new_milestones;   
}