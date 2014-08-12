/* Trigger Name : LX_Partner_Program_BD_AU_AI_BI_BU_AD 
 * Description : Delete the related Program Offers.
 * Created By : Kapil
 * Created Date : 26-09-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer       Date           Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Kapil           26-09-2013     1000                 Initial Version 
 * Kapil           10-8-2013      1001                 Added Profile By Pass
 */

trigger LX_Partner_Program_BD_AU_AI_BI_BU_AD on LX_Partner_Program__c (after delete,after update, after insert,before update,before insert) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
     // Kapil (12/18/2013): Commented as part of Offer Enrollment design change. 
    /*if(trigger.isDelete && trigger.isAfter){   
        LX_PartnerProgramUtil programUtil = new LX_PartnerProgramUtil();
        programUtil.deleteProgramOffers(Trigger.oldMap.keySet());     
    } */
    // Kapil (12/18/2013): Commented as part of Offer Enrollment design change. 
   /* if(trigger.isUpdate && trigger.isAfter){ 
        Map<id,LX_Partner_Program__c> partnerProgramMap = new Map<id,LX_Partner_Program__c>();  
        LX_PartnerProgramUtil programUtil = new LX_PartnerProgramUtil();
        for(LX_Partner_Program__c  program : trigger.new){
            if(program.Program_Status__c == 'Active' && program.Program_Status__c  != trigger.oldMap.get(program.id).Program_Status__c ){            
                partnerProgramMap.put(program.id,program);
            }
        }    
        programUtil.insertProgramOffers(partnerProgramMap );        
    }      */ 
    // Update the Enollment Approver Name based on the Enrollment Approver on Partner Program  
     if(trigger.isUpdate && trigger.isAfter ){        
        Map<id,LX_Partner_Program__c> partnerProgramMap = new Map<id,LX_Partner_Program__c>();
        LX_PartnerProgramUtil programUtil = new LX_PartnerProgramUtil();
        for(LX_Partner_Program__c  program : trigger.new){
            if(program.Enrollment_Approver__c != trigger.oldMap.get(program.id). Enrollment_Approver__c || program.Enrollment_Approver_Name__c  !=  trigger.oldMap.get(program.id). Enrollment_Approver_Name__c){
                partnerProgramMap.Put(program.id,program);              
            }
        }        
        programUtil.updateApprover(partnerProgramMap);  
    }
    
    //Update offer enrollment status to Inactive.
    if(trigger.isAfter && ! trigger.isDelete)
    {   
        Map<Id,String> mapProgEnroll = new Map<Id,String>();
        for(LX_Partner_Program__c  objProgEnroll : trigger.new)
        {
            if(objProgEnroll.Program_Status__c == 'Inactive' || objProgEnroll.Program_Status__c == 'Active')
            {
                mapProgEnroll.put(objProgEnroll.id,objProgEnroll.Program_Status__c);
            }
        }
        
        //check if map is not null then call method to update status of offer enrollment records assocoiated to this.
        LX_ProgramOfferUtil objProgramUtil = new LX_ProgramOfferUtil();
        objProgramUtil.updateProgramEnrollmentStatus(mapProgEnroll,trigger.newMap);
        
    }
}