/* Trigger Name : LX_Program_Enrollment_AI_AU_BI_BU_BD_AD
 * Description : Create the Program Offers on inserting the Program Enrollmentts and delete the Program offers on deleting the Enrollments.
 * Created By : Kapil
 * Created Date : 26-09-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer       Date           Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Kapil           26-09-2013     1000                 Initial Version 
 * Kapil           10-8-2013      1001                 Added Profile By Pass
 * Rajesh K        25-7-2014      US3900               Deactivate Enrollment status changing that makes Offer Enrollment status inactive when the program enrollment is made inactive
 */

trigger LX_Program_Enrollment_AI_AU_BI_BU_BD_AD on LX_Program_Enrollment__c (after insert,after update, after delete,before insert,before update) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    
    /*if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
        LX_ProgramEnrollMentUtil enrollMentUtil = new LX_ProgramEnrollMentUtil ();
        enrollMentUtil.updateEnrollmentApprover(trigger.new); 
    }*/
    
    // Kapil (12/18/2013): Commented as part of Offer Enrollment schema change. 
   /* if(trigger.isInsert && trigger.isAfter){
        Map<id,id> enrollMentPrgMap = new Map<id,id>();
        Map<id,list<LX_Program_Offer__c>> partnerProgramOffersMap = new Map<id,list<LX_Program_Offer__c>>();
        
        for(LX_Program_Enrollment__c  prgEnroll : trigger.new){
            enrollMentPrgMap.put(prgEnroll.id,prgEnroll.Master_Program__c); 
        }
        System.debug('enrollMentPrgMap.values()-->'+enrollMentPrgMap.values());
        for(LX_Program_Offer__c prgOffers: [Select  LX_Country__c,LX_Deal_Desk_Quote_Description__c,LX_Deal_Desk_Quote_ID__c,LX_Deal_Desk_Quote_Name__c ,
                                                    LX_Deal_Desk_Quote_Status__c ,LX_Description__c   ,LX_End_Date__c ,LX_Geo__c,LX_Offer__c,
                                                    LX_Offer_ID__c,LX_Offer_Status__c,LX_Partner_Program__c,LX_Program_Enrollment__c,
                                                    LX_Region_del__c,LX_Start_Date__c,recordtype.Name 
                                                    from LX_Program_Offer__c where LX_Partner_Program__c in :enrollMentPrgMap.values() and recordtype.Name = 'Program Offers']){
                                                    
            list<LX_Program_Offer__c> prgOffersList = partnerProgramOffersMap.get(prgOffers.LX_Partner_Program__c);
            if(prgOffersList == null){
              prgOffersList  = new list< LX_Program_Offer__c>(); 
            }        
            prgOffers.LX_Program_Offer_Id_Hidden__c = prgOffers.id;
            prgOffersList.add(prgOffers);
                              
            system.debug('-->'+prgOffersList);           
            partnerProgramOffersMap.put(prgOffers.LX_Partner_Program__c ,prgOffersList);
        }
        
        LX_ProgramEnrollMentUtil enrollMentUtil = new LX_ProgramEnrollMentUtil ();
        enrollMentUtil.insertProgramOffers(enrollMentPrgMap ,partnerProgramOffersMap);        
       
    }     
     */
    
    if(trigger.isafter && trigger.isUpdate){
         List<LX_Program_Enrollment__c> lstCurrentRecords = new List<LX_Program_Enrollment__c>();
         list<LX_Program_Enrollment__c> enrollmentOffersToUpdate = new list<LX_Program_Enrollment__c>(); 
         for(LX_Program_Enrollment__c  prgEnroll : trigger.new)
         {
            if((prgEnroll.Approval_Status__c  != trigger.oldMap.get(prgEnroll.id).Approval_Status__c  && prgEnroll.Approval_Status__c == 'Approved' ) && 
                (prgEnroll.LX_Enrollment_Status__c != trigger.oldMap.get(prgEnroll.id).LX_Enrollment_Status__c &&  prgEnroll.LX_Enrollment_Status__c == 'Active')){
                enrollmentOffersToUpdate.add(prgEnroll);
            }
            if(prgEnroll.Approval_Status__c != trigger.oldMap.get(prgEnroll.id).Approval_Status__c || 
                prgEnroll.LX_Apply_to_All_Reseller_Locations__c != trigger.oldMap.get(prgEnroll.id).LX_Apply_to_All_Reseller_Locations__c)
                lstCurrentRecords.add(prgEnroll);
         }
         //LX_ProgramEnrollMentUtil.updateEnrollMentOffers(enrollmentOffersToUpdate);
         LX_ProgramEnrollMentUtil.CopyEnrollmenttoAcc(lstCurrentRecords); 
    }
    
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert))
    {
    List<LX_Program_Enrollment__c> LPLst = new List<LX_Program_Enrollment__c>();
    for(LX_Program_Enrollment__c LPE : Trigger.new)
    {
    if(trigger.isUpdate)
    {
    if(LPE.LX_Enrollment_Status__c != Trigger.oldMap.get(LPE.id).LX_Enrollment_Status__c && LPE.LX_Enrollment_Status__c == 'Active')
    {    
    LPLst.add(LPE);
    }
    }
    else if(trigger.isInsert)
    {
    if(LPE.LX_Enrollment_Status__c == 'Active')
    {
    LPLst.add(LPE);    
    }
    }    
    }
    if(!LPLst.isEmpty())
    {
    update_Account_Enrolment.updateAccountfromEnrolment(LPLst);    
    }
    }
    
    
            
      
    
    if(trigger.isDelete && trigger.isAfter)
    {
        LX_ProgramEnrollMentUtil.DelEnrollmentfromAcc(trigger.new);
      /*  LX_ProgramEnrollMentUtil enrollMentUtil = new LX_ProgramEnrollMentUtil ();
        enrollMentUtil.deleteProgramOffers(trigger.oldMap.keySet());  */
    }
    
    List<LX_Program_Enrollment__c> DeletePEList  = new list<LX_Program_Enrollment__c>();
    if(trigger.isafter && trigger.isUpdate){         
         for(LX_Program_Enrollment__c  prgEnroll : trigger.new){
             if(prgEnroll.LX_Apply_to_All_Reseller_Locations__c == false && trigger.oldMap.get(prgEnroll.id).LX_Apply_to_All_Reseller_Locations__c == true){
                 DeletePEList.add(prgEnroll);
             }
         }
         if(!DeletePEList.isEmpty()){         
             LX_ProgramEnrollMentUtil.DelEnrollmentfromAcc(DeletePEList);
         }
    }
   
    //Update offer enrollment status to Inactive.
    if(trigger.isBefore && ! trigger.isDelete)
    {   
        Map<Id,String> mapProgEnroll = new Map<Id,String>();
        for(LX_Program_Enrollment__c  objProgEnroll : trigger.new)
        {
           // if(objProgEnroll.LX_Enrollment_Status__c == 'Inactive' || objProgEnroll.LX_Enrollment_Status__c == 'Active') //Commented for US3900
            if(objProgEnroll.LX_Enrollment_Status__c == 'Active')
            {
                mapProgEnroll.put(objProgEnroll.id,objProgEnroll.LX_Enrollment_Status__c);
            }
        }
        
        //check if map is not null then call method to update status of offer enrollment records assocoiated to this.
        LX_ProgramOfferUtil objProgramUtil = new LX_ProgramOfferUtil();
        objProgramUtil.updateOfferEnrollmentStatus(mapProgEnroll,null);
        
    }
    
    if( trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
       // for(LX_Program_enrollment__c enrollment : trigger.new){
            LX_ProgramEnrollMentUtil.updateApprover(trigger.new);
        //}   
    }
    
}