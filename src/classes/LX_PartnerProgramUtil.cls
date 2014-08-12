/* Class Name : LX_PartnerProgramUtil
 * Description : This class will be used as util class for Partner Program when ever they are inserting from triggers
 * Created By : Kapil
 * Created Date : 26-09-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer       Date           Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Kapil           26-09-2013     1000                 Initial Version 
 */


public Class LX_PartnerProgramUtil{
    
    /*Description: Delete Program Offers on deleting the Program Enrolments
    *Param:set<id> partnerProgramSet
    *Returns:VOID
    */
    
    // Kapil (12/18/2013): Commented as part of Offer Enrollment schema change. 
   /* public void deleteProgramOffers(set<id> partnerProgramSet){ 
    try{       
        Delete [Select id,recordtype.Name 
                       from LX_Program_Offer__c 
                       where LX_Partner_Program__c in : partnerProgramSet  ];  
    }catch(Exception ex){
    LX_CommonUtilities.createExceptionLog(ex);       
    }
    }*/
    
    /*Description: Insert Program Offers for Active Partner Programs.
    *Param:set<id> partnerProgramSet
    *Returns:VOID
    */
    // Kapil (12/18/2013): Commented as part of Offer Enrollment schema change. 
    /*
    public void insertProgramOffers( Map<id,Lx_partner_program__c> partnerProgramMap){
         Map<LX_Partner_Program__c,list<LX_Program_Offer__c>> partnerProgramOffersMap = new Map<LX_Partner_Program__c,list<LX_Program_Offer__c>>();
         Map<LX_Partner_Program__c ,List<LX_program_enrollment__c>> partnerProgramEnrollmentMap = new Map<LX_Partner_Program__c ,list<LX_program_enrollment__c>>();
          
         
         Map< id,LX_Program_Enrollment__c> enrollmentMap = new Map<id,LX_Program_Enrollment__c>([Select id,Master_Program__c from Lx_Program_enrollment__c  where Master_Program__c in :partnerProgramMap.keySet()]); 
         system.debug('enrollmentMap -->'+enrollmentMap);  
         
        for(LX_Program_Enrollment__c enrollment: enrollmentMap.values()){              
            List<LX_program_enrollment__c> enrollmentList = partnerProgramEnrollmentMap.get(partnerProgramMap.get(enrollment.Master_Program__c));
            if(enrollmentList == null){
              enrollmentList  = new List<LX_program_enrollment__c>(); 
            }
            enrollmentList.add(enrollment); 
            partnerProgramEnrollmentMap .put(partnerProgramMap.get(enrollment.Master_Program__c) ,enrollmentList);
        } 
        
        Map<id,LX_Program_Offer__c> programOffersMap =  new Map<id,LX_Program_Offer__c>([Select  LX_Country__c,LX_Deal_Desk_Quote_Description__c,LX_Deal_Desk_Quote_ID__c,LX_Deal_Desk_Quote_Name__c , LX_Deal_Desk_Quote_Status__c ,LX_Description__c   ,LX_End_Date__c ,LX_Geo__c,LX_Offer__c,
                                                                                                 LX_Offer_ID__c,LX_Offer_Status__c,LX_Partner_Program__c,LX_Program_Enrollment__c,
                                                                                                 LX_Region_del__c,LX_Start_Date__c 
                                                                                                 from LX_Program_Offer__c where LX_Partner_Program__c in :partnerProgramMap.keySet() and recordtype.name = 'Program Offers']);
        system.debug('programOffersMap  -->'+programOffersMap.values() );  
        for(LX_Program_Offer__c prgOffers: programOffersMap.values()){                                                    
            list<LX_Program_Offer__c> prgOffersList = partnerProgramOffersMap.get(partnerProgramMap.get(prgOffers.LX_Partner_Program__c));
            if(prgOffersList == null){
              prgOffersList  = new list< LX_Program_Offer__c>(); 
            }        
            prgOffers.LX_Program_Offer_Id_Hidden__c = prgOffers.id;
            prgOffersList.add(prgOffers);
            partnerProgramOffersMap.put(partnerProgramMap.get(prgOffers.LX_Partner_Program__c) ,prgOffersList);
        }
        
        Map<id,LX_Program_Offer__c> enrollmentOffersMap = new Map<id,LX_Program_Offer__c>([Select  LX_Partner_Program__c, id ,LX_Program_Offer_Id_Hidden__c,LX_Program_Enrollment__c,recordtype.name
                                                                                                    from LX_Program_Offer__c        
                                                                                                    where LX_Program_Enrollment__c in :enrollmentMap.keySet()and recordtype.name = 'Enrollment Offers']);
        system.debug('enrollmentOffersMap-->'+enrollmentOffersMap);
        Map<id,set<id>> prgOfferToIgnoreMap = new Map<id,set<id>>();
        set<id> ignoreSet = new set<id>();
        for(LX_Program_Offer__c prgOffer : enrollmentOffersMap.values()){                
            set<id> Offerset = prgOfferToIgnoreMap.get(prgOffer.LX_Partner_Program__c);         
            if(Offerset  == null){
              Offerset = new set< id>(); 
            }
            Offerset.add(prgOffer.LX_Program_Offer_Id_Hidden__c);  
            ignoreSet.add(prgOffer.LX_Program_Offer_Id_Hidden__c);
            prgOfferToIgnoreMap.put(prgOffer.LX_Partner_Program__c,Offerset );           
        } 
        
        Map<id,List<Lx_Program_offer__c>> finalMap = new Map<id,List<Lx_Program_offer__c>>();
        for(list<LX_program_offer__c> prgOffersList:partnerProgramOffersMap.values()){
            for(LX_program_offer__c prgrOffer : prgOffersList){            
                if(!ignoreSet.contains(prgrOffer.id)){
                    list<LX_Program_offer__c> OfferList = finalMap.get(prgrOffer.LX_partner_program__c);
                    if(OfferList  == null){
                      OfferList = new list<LX_program_offer__c>(); 
                    }
                    prgrOffer.LX_Program_Offer_Id_Hidden__c = prgrOffer.id;
                    OfferList.add(prgrOffer);                              
                    system.debug('-->'+OfferList);                         
                    finalMap.put(prgrOffer.LX_Partner_Program__c,OfferList);                
                }                
            }
        }         
        
        List<LX_program_offer__c> POList = new List<LX_program_offer__c>();
        for(LX_Program_Enrollment__c enrollment: enrollmentMap.values()){
            if(finalMap.get(enrollment.Master_Program__c) != null){  
                for(LX_program_offer__c p :finalMap.get(enrollment.Master_Program__c).deepclone(false,false,false)){
                        p.recordtypeId =  LX_SetRecordIDs.EnrollmentOffersId ;                        
                        p.LX_program_enrollment__c = enrollment.id;                       
                        if(p.id==null)
                            POList.add(p);
                    }                                           
                }  
        }
        try{
        insert POList;   
        }catch(Exception ex){
         LX_CommonUtilities.createExceptionLog(ex);          
        }       
    }*/ 
        
    /*Description: Update Enrollment Approver with the Owner's Manager
    *Param:Map<id,LX_partner_program__c> partnerProgramMap 
    *Returns:VOID
    */
     
    public void updateApprover(Map<id,LX_Partner_Program__c> partnerProgramMap){
        
        Map<LX_Partner_Program__c ,List<LX_program_enrollment__c>> partnerProgramEnrollmentMap = new Map<LX_Partner_Program__c ,list<LX_program_enrollment__c>>();
        Map<id,LX_Program_Enrollment__c> enrollmentMap = new Map<id,LX_Program_Enrollment__c>([Select id ,Master_Program__c,LX_Account__r.Owner.ManagerId
                                                                                                      from LX_Program_Enrollment__c 
                                                                                                      where Master_Program__c in :partnerProgramMap.keySet()]);
        system.debug('enrollmentMap>>>>>>>>'+enrollmentMap);
        for(LX_Program_Enrollment__c enrollment : enrollmentMap.values()){
            List<LX_program_enrollment__c> enrollmentList = partnerProgramEnrollmentMap.get(partnerProgramMap.get(enrollment.Master_Program__c));
            if(enrollmentList == null){
              enrollmentList = new List<LX_program_enrollment__c>(); 
            }
            enrollmentList.add(enrollment); 
            partnerProgramEnrollmentMap.put(partnerProgramMap.get(enrollment.Master_Program__c) ,enrollmentList);  
        }   
        system.debug('partnerProgramEnrollmentMap>>>>>>>>'+partnerProgramEnrollmentMap);        
        
        for(LX_Partner_Program__c ptnr : partnerProgramMap.values()){
          if(ptnr.Enrollment_Approver__c == 'Other' &&  partnerProgramEnrollmentMap.containsKey(ptnr)){
              for(LX_program_enrollment__c enrollment :partnerProgramEnrollmentMap.get(ptnr)){
                if(ptnr.Enrollment_Approver_Name__c != null){
                    enrollment.LX_Enrollment_Approver__c = ptnr.Enrollment_Approver_Name__c;
                }
                else {
                    enrollment.LX_Enrollment_Approver__c = system.label.LX_Default_Enrollment_Approver != null ? system.label.LX_Default_Enrollment_Approver : null;
                }
              }
          }else if(ptnr.Enrollment_Approver__c == 'Sales Manager' && partnerProgramEnrollmentMap.containsKey(ptnr) ){
              for(LX_program_enrollment__c enrollment :partnerProgramEnrollmentMap.get(ptnr)){
                  if(enrollment.LX_Account__r.Owner.ManagerID != null){
                      enrollment.LX_Enrollment_Approver__c = enrollment.LX_Account__r.Owner.ManagerID;                    
                  }
                  else {
                    enrollment.LX_Enrollment_Approver__c = system.label.LX_Default_Enrollment_Approver != null ? system.label.LX_Default_Enrollment_Approver : null;
                }
              }        
          }       
        }
        try{
        if(enrollmentMap != null && !enrollmentMap.isEmpty()){
            update enrollmentMap.values();
        }
        }catch(Exception ex){
        	LX_CommonUtilities.createExceptionLog(ex);
        }
    }
}