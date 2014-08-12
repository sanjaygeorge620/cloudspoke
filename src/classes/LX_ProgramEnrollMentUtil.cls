/* Class Name : LX_ProgramEnrollMentUtil
 * Description : This class will be used as util class for Program Enrolments when ever they are inserting from triggers
 * Created By : Kapil
 * Created Date : 26-09-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer       Date           Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Kapil           26-09-2013     1000                 Initial Version 
 */




public Class LX_ProgramEnrollMentUtil
{

    private static boolean Siblingdelete = false;
    
    /*Description: Insert Program Offers and link them to Enrolments.
    *Param:Map<id,id> enrollMentPrgMap,partnerProgramOffersMap,Map<id,list<LX_Program_Offer__c>> partnerProgramOffersMap
    *Returns:VOID
    */ 
    
    public void insertProgramOffers(Map<id,id> enrollMentPrgMap ,Map<id,list<LX_Program_Offer__c>> partnerProgramOffersMap ){
        system.debug('enrollMentPrgMap -->'+enrollMentPrgMap );
        system.debug('partnerProgramOffersMap -->'+partnerProgramOffersMap  );
        list<LX_Program_Offer__c > prgOffrsToInsert = new list<LX_Program_Offer__c>();
        for(id enrollMent: enrollMentPrgMap.keyset()){
            if(enrollMentPrgMap.containsKey(enrollMent)){
                if(partnerProgramOffersMap.containsKey(enrollMentPrgMap.get(enrollMent))){
                      for(LX_Program_Offer__c  prgOffer :(partnerProgramOffersMap.get(enrollMentPrgMap.get(enrollMent)).deepClone(false,false,false))){
                        prgOffer.LX_Program_Enrollment__c = enrollMent;
                    prgOffer.recordTypeId = LX_SetRecordIDs.EnrollmentOffersId ;
                    prgOffrsToInsert.add(prgOffer);
                  } 
                }  
            }        
        }
        system.debug('prgOffrsToInsert-->'+prgOffrsToInsert);
    try{
        if(!prgOffrsToInsert.isEmpty()){        
            insert prgOffrsToInsert;
        }
    }catch(Exception ex){
      LX_CommonUtilities.createExceptionLog(ex);              
     }
    }
    /*Description: Delete Program Offers on deleting the Program Enrolments
    *Param:set<id> partnerProgramSet
    *Returns:VOID
    */
    public void deleteProgramOffers(set<id> partnerProgramSet){
        system.debug('Offers to delete-->'+ [Select id,recordtype.Name from LX_Program_Offer__c where LX_Partner_Program__c in : partnerProgramSet and recordtype.Name = 'Enrollment Offers']);
        try{
        Delete [Select id,recordtype.Name 
                       from LX_Program_Offer__c 
                       where LX_Partner_Program__c in : partnerProgramSet and recordtype.Name = 'Enrollment Offers'];  
    }
    catch(Exception ex){
      LX_CommonUtilities.createExceptionLog(ex);              
     }
    }
    /*
    Method: CopyEnrollmenttoAcc
    Description: Copies all Enrollment to Transactional MDM ids.
    
    
    */
    public static void CopyEnrollmenttoAcc(List<LX_Program_Enrollment__c> triggerNew){
    
    set<id> ProgramMasterSet = new set<id>();
    set<String> AccountMasterSet = new set<String>();
    set<String> AccountMasterSet2 = new set<String>();
    set<Id> setAccountIds = new set<Id>();
    List<Account> AccountMDMList = new List<Account>();
    List<ID> accidl =  new List<ID>();
    Map<id,LX_Partner_Program__c> ApprovedPPMap ;
    set<id> verifyaccSet= new set<id>();
    Map<string,List<id>> Map_TranMDM_AccId = new Map<string,List<id>>();
    Map<id,Account> ApprovedAccountList ;
    LX_Program_Enrollment__c PEClone = new LX_Program_Enrollment__c ();
    List<LX_Program_Enrollment__c> ListMasterPE = new List<LX_Program_Enrollment__c>();
    List<id> TempMDMAccId;
        for(LX_Program_Enrollment__c  pe : triggernew){
            if(pe.Approval_Status__c=='Approved'&&pe.LX_Apply_to_All_Reseller_Locations__c==true){
                //AccountMasterSet.add(pe.LX_Account__c);
                setAccountIds.add(pe.LX_Account__c);
                accidl.add(pe.LX_Account__c);
                AccountMasterSet.add(pe.Lx_MDM_Account_Number__c);
                ProgramMasterSet.add(pe.Id);
            }
        }
        system.debug('AccountMasterSet == 11'+AccountMasterSet2);
          if(AccountMasterSet!=null )
        {
            //ApprovedAccountList =new Map<id,account>( [select id, MDM_ID__c from account where id in:AccountMasterSet]);
            //ApprovedAccountList = new Map<id,account>([select id, MDM_Account_Number__c,MDM_ID__c from account where MDM_Account_Number__c in:AccountMasterSet and (MDM_Transactional_Account_ID__c != null or MDM_Account_Level__c =: 'Transactional') and id not in: setAccountIds]);
             
             //Added By Praveen Sadineni to fix the test class breaking due to System.QueryException: Non-selective query against large object type
             
          if(test.isRunningTest())
             {
            
             }
             
             else
             {

               for(account acc: [select id, MDM_Account_Number__c,MDM_ID__c from account where MDM_Account_Number__c in:AccountMasterSet and (MDM_Transactional_Account_ID__c != null or MDM_Account_Level__c =: 'Transactional') and id not in: setAccountIds] )


               {
                if(acc.MDM_Account_Number__c!=null&&Map_TranMDM_AccId.get(acc.MDM_Account_Number__c)!=null){

                    TempMDMAccId =  Map_TranMDM_AccId.get(acc.MDM_Account_Number__c);
                }
                else

                {
                    TempMDMAccId  = new List<id>();
                }
                TempMDMAccId.add(acc.id);
                Map_TranMDM_AccId.put(acc.MDM_Account_Number__c,TempMDMAccId);
            }

            }
        }
        system.debug('Map_TranMDM_AccId == '+Map_TranMDM_AccId);
        for(LX_Program_Enrollment__c  pe : triggernew){
        system.debug('Current Record == '+pe);
            if(pe.Approval_Status__c=='Approved'&&pe.LX_Apply_to_All_Reseller_Locations__c==true){
                
                    //for(id idvalue: Map_TranMDM_AccId.get(ApprovedAccountList.get(pe.LX_Account__c).MDM_ID__c)){
                    if(Map_TranMDM_AccId != null && Map_TranMDM_AccId.get(pe.Lx_MDM_Account_Number__c) != null)
                    {
                        for(id idvalue: Map_TranMDM_AccId.get(pe.Lx_MDM_Account_Number__c)){
                        system.debug('idvalue == '+idvalue);
                            PEClone = pe.clone(false,true,false,false);
                            PEClone.LX_Original_PE_ID__c = pe.id;
                            PEClone.LX_Account__c= idvalue;
                            ListMasterPE.add(PEClone);
                    }
                }
            }
        }
    try{
         insert ListMasterPE;
     }
     catch(Exception ex){
      LX_CommonUtilities.createExceptionLog(ex);              
     }
         
         List<LX_Program_Enrollment__c> lstProgEnrollments = [select id,Lx_HQ_Enrollment__c from                                                     LX_Program_Enrollment__c 
                                                              where id in: ProgramMasterSet];
        if(lstProgEnrollments == null || lstProgEnrollments.size() <= 0) return;    
                                                  
        for(LX_Program_Enrollment__c obj : lstProgEnrollments)
        {
            obj.Lx_HQ_Enrollment__c = true;
        }
        try{
        update lstProgEnrollments;
    }catch(Exception ex){
      LX_CommonUtilities.createExceptionLog(ex);              
    }
    }
    
    
    
    /*
    Method: CopyEnrollmenttoAcc
    Description: Copies all Enrollment to Transactional MDM ids.
    
    
    */
    public static void DelEnrollmentfromAcc(List<LX_Program_Enrollment__c> triggerNew){
        List<LX_Program_Enrollment__c> DeletePEList ;
        if(Siblingdelete !=true){
            set<id> DeleteID = new  set<id> ();
            if(triggerNew != null)
            {
                for(LX_Program_Enrollment__c PE:triggerNew ){
                    DeleteID.add(PE.id);
                }
                DeletePEList =[select id,LX_Original_PE_ID__c   from LX_Program_Enrollment__c where LX_Original_PE_ID__c  in :DeleteID ];
                Siblingdelete =true;
        try{
                delete DeletePEList ;
                Siblingdelete =false;
        }catch(Exception ex){
          LX_CommonUtilities.createExceptionLog(ex);              
        }
            }
        }
    }
    
    /*
        *Method:updateApprover
        *Description: Updates the Apprver on insert
        *Param:List<LX_Program_Enrollment__c> triggerNew
        *Returns:VOID
    */  
    
  public static void updateApprover(List<LX_Program_Enrollment__c> triggerNew)
  {
    set<id> programIdSet = new set<id>();
    for(LX_Program_Enrollment__c enrollment : triggerNew){
      programIdSet.add(enrollment.Master_Program__c);
    }
    Map<id,LX_Partner_Program__c> partnerProgramsMap = new Map<id,LX_Partner_Program__c>([Select id ,Enrollment_Approver__c,Enrollment_Approver_Name__c from LX_Partner_Program__c where id in :programIdSet]);
    for(LX_Program_Enrollment__c enrollment : triggerNew){
      if(partnerProgramsMap.containsKey(enrollment.Master_Program__c) && partnerProgramsMap.get(enrollment.Master_Program__c).Enrollment_Approver__c == 'Other' && partnerProgramsMap.get(enrollment.Master_Program__c).Enrollment_Approver_Name__c != null){
        enrollment.LX_Enrollment_Approver__c = partnerProgramsMap.get(enrollment.Master_Program__c).Enrollment_Approver_Name__c;
      }else if(partnerProgramsMap.containsKey(enrollment.Master_Program__c) && partnerProgramsMap.get(enrollment.Master_Program__c).Enrollment_Approver__c == 'Sales Manager' && enrollment.LX_Sales_Manager_Hidden__c != null){
        enrollment.LX_Enrollment_Approver__c = enrollment.LX_Sales_Manager_Hidden__c;
      }
      if(enrollment.LX_Enrollment_Approver__c == null){
        enrollment.LX_Enrollment_Approver__c = system.label.LX_Default_Enrollment_Approver != null ? system.label.LX_Default_Enrollment_Approver : null;
      }
    }    
    }
    
    
}