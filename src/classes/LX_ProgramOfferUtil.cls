/* Class Name : LX_ProgramOfferUtil
 * Description : This class will be used as util class for Partner Program when ever they are inserting from triggers
 * Created By : Kapil
 * Created Date : 30-09-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer       Date           Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Kapil           30-09-2013     1000                 Initial Version 
 */


public Class LX_ProgramOfferUtil{

    public static List<LX_Program_Enrollment__c> lstUpdateRecords = new List<LX_Program_Enrollment__c>();
    /*Description: Delete Program offers and related Enrollment offers.
    *Param:set<id> programOffersSet
    *Returns:VOID
    */
    public void deleteProgramOffers(set<id> programOffersSet){        
        try{
        Delete [select id,LX_Program_Offer_Id_Hidden__c 
                       from LX_Program_Offer__c 
                       where id in :programOffersSet or LX_Program_Offer_Id_Hidden__c in : programOffersSet ];
        }catch(Exception ex){
        LX_CommonUtilities.createExceptionLog(ex);
        
        }
    }
    /*Description: Updates Program Enrolment Status to Inactive.
    *Param:Map<Id,String> mapPartnerPrograms : collection of Partner Program record id's and status
    *Returns:VOID
    */
    public void updateProgramEnrollmentStatus(Map<Id,String> mapPartnerPrograms, Map<Id,LX_Partner_Program__c> mapPartnerProgram)
    {
        //Get Program enrolment records based on Partner Programs
        List<LX_Program_Enrollment__c> lstProgramEnrollments = [select id,Name,LX_Enrollment_Effective_Date__c,LX_Enrollment_Signed_Date__c,LX_Enrollment_End_Date__c,LX_Enrollment_Proposed_Date__c,LX_Enrollment_Status__c,Approval_Status__c,Master_Program__c from LX_Program_Enrollment__c where Master_Program__c in: mapPartnerPrograms.keySet()];
        if(lstProgramEnrollments.size() <= 0) return;
        String strStatus = null;
        
        //Declare a list of String to store enrolments which are not populated with required fields while making status as active.
        //List<LX_Program_Enrollment__c> lstUpdateRecords = new List<LX_Program_Enrollment__c>();
        
         List<LX_Program_Enrollment__c> lstErroredRecords = new List<LX_Program_Enrollment__c>();
        for(LX_Program_Enrollment__c objProgramEnrollment : lstProgramEnrollments)
        {
            strStatus = mapPartnerPrograms != null ? mapPartnerPrograms.get(objProgramEnrollment.Master_Program__c) : null;
            system.debug('strStatus == '+strStatus);
            if(strStatus != null)
            {
                objProgramEnrollment.LX_Enrollment_Status__c = strStatus;
                //While making enrolment status to active update the records which have values in the LX_Enrollment_Effective_Date__c,LX_Enrollment_Signed_Date__c,LX_Enrollment_End_Date__c,LX_Enrollment_Proposed_Date__c fields
                if(strStatus == 'Active')
                {
                    if(objProgramEnrollment.LX_Enrollment_Effective_Date__c == null || objProgramEnrollment.LX_Enrollment_Signed_Date__c == null || objProgramEnrollment.LX_Enrollment_End_Date__c == null || objProgramEnrollment.LX_Enrollment_Proposed_Date__c == null || (objProgramEnrollment.Approval_Status__c != 'Approved' && objProgramEnrollment.recordTypeId == LX_SetRecordIDs.LockISSEnrollmentRecordType))
                    {
                        lstErroredRecords.add(objProgramEnrollment);
                        continue;
                        
                    }
                   
                }
               lstUpdateRecords.add(objProgramEnrollment);
            }
                
        }
        system.debug('lstUpdateRecords == '+lstUpdateRecords);
        Database.update(lstUpdateRecords,false);
        //UpdateStatus();
        
        /*//Iterate the errored records and show message to the end user
        for(LX_Program_Enrollment__c objErrorRecord : lstErroredRecords)
        {
            String strError = 'There are some validation exception for the following records ' + objErrorRecord.Name;
            system.debug('In Error == '+strError);
            mapPartnerProgram.get(objErrorRecord.Master_Program__c).Program_Status__c.addError(strError);
        }*/
    }
    /* @Future
    public static void UpdateStatus()
    {   
        system.debug('lstUpdateRecords == '+lstUpdateRecords);
        update lstUpdateRecords;
    } */
    /*Description: Updates Offer Enrollment Status to Inactive.
    *Param:Map<Id,String> mapProgramEnrollment : collection of Program enrollment record id's and status
    *Param:Map<Id,String> offerStatusMap : collection of Offer record id's and status
    *Returns:VOID
    */
    public void updateOfferEnrollmentStatus(Map<Id,String> mapProgramEnrollment,Map<Id,String> offerStatusMap)
    {
        system.debug('mapProgramEnrollment-->'+mapProgramEnrollment);
        //Get Program enrollment records based on Partner Programs
        List<LX_Offer_Enrollment__c> lstOfferEnrollments = null;
        if(mapProgramEnrollment != null){
            lstOfferEnrollments = [select id,LX_Offer_Enrollment_Status__c,Program_Enrollment__c from LX_Offer_Enrollment__c where Program_Enrollment__c in: mapProgramEnrollment.keySet()];
            }
        else if (offerStatusMap != null){
            lstOfferEnrollments = [select id,LX_Offer_Enrollment_Status__c,Program_Offer__r.LX_Offer__c from LX_Offer_Enrollment__c where Program_Offer__r.LX_Offer__c in: offerStatusMap.keySet()];           
            }
        String strStatus = null;
        for(LX_Offer_Enrollment__c objOfferEnrollment : lstOfferEnrollments)
        {
            strStatus = (mapProgramEnrollment != null ? mapProgramEnrollment.get(objOfferEnrollment.Program_Enrollment__c) : (offerStatusMap != null ? offerStatusMap.get(objOfferEnrollment.Program_Offer__r.LX_Offer__c) : null));//get the Offer status
            if(strStatus != null)
                objOfferEnrollment.LX_Offer_Enrollment_Status__c = strStatus;
        }
        
        //update Program Enrollments
        //update lstOfferEnrollments;
        Database.update(lstOfferEnrollments,false);

    } 

    
    
}