public class LX_Enrol_Multiple_Partners{

    public string ProgramId {get;set;}
    public String soldTo{get;set;}
    private final LX_Program_Enrollment__c prgEnrolment;
    public list<PartnerAccountWrapper> partnerAccountsList{get;set;}
//  public list<DataTableWrapper> DataTableWrapperList{get;set;}
    private LX_Partner_Program__c ObjPartner = new LX_Partner_Program__c();
    public integer matchingAccountsSize {get;set;}// to display the count of eligible accounts
    public LX_Enrol_Multiple_Partners(ApexPages.StandardController controller) {  
        matchingAccountsSize = 0;
        ProgramId = Apexpages.currentPage().getParameters().get('programId');
        if(ProgramId != null && ProgramId != ''){
            partnerAccountsList = fetchpartnerAccountsList ();
            prgEnrolment = (LX_Program_Enrollment__c ) controller.getRecord();        
            if(ProgramId != '' && ProgramId != null){
                prgEnrolment.Master_Program__c = ProgramId;
            }
            prgEnrolment.recordtypeId = LX_SetRecordIDs.ISSPartnerEnrollment;
        }
    }        
    
   //Fetch Enrolled accounts 
    public set<id> fetchEnrolledAccts(){
        set<id> enrolledAccts = new set<id>();
            for(LX_Program_Enrollment__c prg: [Select id,LX_Account__c from LX_Program_Enrollment__c where  Master_Program__c = :ProgramId]){
                enrolledAccts.add(prg.LX_Account__c);
            }
            return enrolledAccts;
    }
    
   //Fetch the eligible accounts 
    public list<PartnerAccountWrapper> fetchpartnerAccountsList (){
    

    
        list<PartnerAccountWrapper> partnerAccs = new list<PartnerAccountWrapper>();
        list<Account> ptnrAccs = new list<Account>();
        string soql = '';       
        set<id> enrolledAccts = fetchEnrolledAccts();
        ObjPartner = [select id,LX_Party_Type__c,ISS_Capability_Segment__c,LX_ISS_Coverage_Method__c,
                                       LX_GEO__c,LX_Region__c,LX_T_County__c,LX_Country__c,
                                       LX_T_Minimum_MPS_Capability_Score__c,ISS_Coverage_Model__c,
                                       LX_T_Minimum_Solution_Capability_Score__c,LX_Partner_ISS_Capability_Segment__c,
                                       LX_Primary_ISS_Internal_Segment__c,LX_Minimum_Total_Capability_Score__c
                             FROM LX_Partner_Program__c 
                             WHERE id=:ProgramId];
                                                   
        soql += ' recordtypeId = \''+LX_SetRecordIDs.L5LocationPartnerAccountRecordId +'\' '; 
        
        if(ObjPartner.LX_ISS_Coverage_Method__c != null && ObjPartner.LX_ISS_Coverage_Method__c != ''){
            soql += 'and ISS_Coverage_Method__c = \'' + ObjPartner.LX_ISS_Coverage_Method__c +'\'';
        }
        
         if(ObjPartner.ISS_Coverage_Model__c != null && ObjPartner.ISS_Coverage_Model__c != ''){
            soql += 'and ISS_Coverage_Model__c = \'' + ObjPartner.ISS_Coverage_Model__c +'\'';
        }
        
        if(ObjPartner.LX_T_Minimum_MPS_Capability_Score__c != null && ObjPartner.LX_T_Minimum_MPS_Capability_Score__c != 0){
            soql += 'and Partner_MPS_Capability_Score__c >= ' + ObjPartner.LX_T_Minimum_MPS_Capability_Score__c + ' ';
        }
        
        if(ObjPartner.LX_T_Minimum_Solution_Capability_Score__c != 0 && ObjPartner.LX_T_Minimum_Solution_Capability_Score__c != null){
            soql += 'and  Partner_ISS_Solutions_Capability_Score__c >= ' + ObjPartner.LX_T_Minimum_MPS_Capability_Score__c + ' ';
        }
        
        if(ObjPartner.LX_GEO__c != null && ObjPartner.LX_GEO__c != ''){
            soql += 'and LX_Geo__c=\''+String.escapeSingleQuotes(ObjPartner.LX_GEO__c)+'\'';
        }
        
        if(ObjPartner.LX_Region__c != null && ObjPartner.LX_Region__c != ''){
            soql+='and LXK_Region__c=\''+String.escapeSingleQuotes(ObjPartner.LX_Region__c)+'\'';
        }
        //kapil(2/18/2014):Sprint 13 chnages to add Capability Segemtn,Internal Segment and Total Capability score to the filter criteria.
        if(ObjPartner.LX_Partner_ISS_Capability_Segment__c !=null && ObjPartner.LX_Partner_ISS_Capability_Segment__c  != ''){
            soql+='and Partner_ISS_Capability_Segment__c =\''+String.escapeSingleQuotes(ObjPartner.LX_Partner_ISS_Capability_Segment__c)+'\'';
        }
        
        if(ObjPartner.LX_Primary_ISS_Internal_Segment__c !=null && ObjPartner.LX_Primary_ISS_Internal_Segment__c != ''){
            soql+='and Primary_ISS_Internal_Segment__c =\''+String.escapeSingleQuotes(ObjPartner.LX_Primary_ISS_Internal_Segment__c)+'\'';
        }
        
        if(ObjPartner.LX_Minimum_Total_Capability_Score__c !=null ){
            soql+='and LX_Total_Capability_Score__c >='+ObjPartner.LX_Minimum_Total_Capability_Score__c;
        }
        
      /* if(ObjPartner.LX_T_County__c != null && ObjPartner.LX_T_County__c != ''){
            soql += 'and BillingCountry=\''+String.escapeSingleQuotes(ObjPartner.LX_T_County__c)+'\'';
        }*/
        
     /*   if(ObjPartner.LX_Party_Type__c !=null && ObjPartner.LX_Party_Type__c != ''){
            soql+='and Party_Type__c =\''+String.escapeSingleQuotes(ObjPartner.LX_Party_Type__c)+'\'';
        }*/

        
        system.debug(enrolledAccts);
        if(enrolledAccts != null && !enrolledAccts.isEmpty()){
            soql += 'and id not in :enrolledAccts';
        }
        System.debug('soql-->'+Soql);
        
        if(soql.startsWith('and')){
            soql = soql.replaceFirst('and',' ');
        }
        soql = 'SELECT id,SLASerialNumber__c,Coverage_Status__c,Owner.Name,Company_Number__c,MDM_Account_Number__c,Party_Role__c,Name,Partner_ISS_Capability_Segment__c,Primary_ISS_Internal_Segment__c,LX_Total_Capability_Score__c,Party_Type__c,ISS_Coverage_Method__c,BillingCountry,LXK_Region__c,LX_Geo__c,ISS_Coverage_Model__c,Partner_MPS_Capability_Score__c ,Partner_ISS_Solutions_Capability_Score__c FROM Account WHERE  '+ soql + ' Order by Name ';
        System.debug('soql-->'+Soql);        
 
// SC:06/05/2014 : Updated to calculate Account Sold To as per US3662     
   List<Account> accList = new List <Account>();
   Set <String> accSet = new Set <String> ();
   Integer Counter1 = 0; 
      
    for(Account ObjAccount: database.query(soql)){   

        boolean IsMatch=false;
        if(ObjAccount.Party_Type__c != null && ObjPartner.LX_Party_Type__c != null)
            {
            if(ObjPartner.LX_Party_Type__c.contains(ObjAccount.Party_Type__c))
            IsMatch = true;
//            matchingAccountsSize ++;
            }
        else{
            IsMatch=true;  
//            matchingAccountsSize ++;
            }
        

        if (IsMatch){
        matchingAccountsSize ++;
        if (Counter1<500){
        Counter1 ++;
        accList.add(ObjAccount);
        accSet.add(ObjAccount.MDM_Account_Number__c); 
        }   
    }
    }
              
        Integer counter = 0;
        Transient String SoldTo = '';   
        
        Map <String, String> sapRecMap = new Map <String, String> ();
        
        if (accSet.size()>0){
        for (LX_SAP_Record__c sapRec: [Select Id,LX_MDM_Act__c,LX_Sold_To_ID__c from LX_SAP_Record__c where LX_MDM_Act__c in:accSet and LX_MDM_Act__c <> null  ])
            sapRecMap.put(sapRec.LX_MDM_Act__c, sapRec.LX_Sold_To_ID__c);
         }
                        
        for(Account ObjAccount: accList){ 
            SoldTo = sapRecMap.get(ObjAccount.MDM_Account_Number__c) ;          
            counter = counter + 1;
            PartnerAccountWrapper wrp = new PartnerAccountWrapper(ObjAccount, counter,SoldTo);    
            partnerAccs.add(wrp);                                                               
        }  
        system.debug('partnerAccs -->'+partnerAccs );      
        return partnerAccs ;
    }
    
    public pageReference enrolMultiplePartners(){
        list<LX_Program_Enrollment__c> programEmrolmentsToInsert = new list<LX_Program_Enrollment__c>();
        system.debug('partnerAccountsList>>>>>>>>>>'+partnerAccountsList);
        if(partnerAccountsList != null && !partnerAccountsList.isEmpty()){
            for(PartnerAccountWrapper wrp : partnerAccountsList){
                if(wrp.chk){
                    LX_Program_Enrollment__c prgEnrolmentClone = prgEnrolment.clone(false,false,false);
                    prgEnrolmentClone.LX_Account__c = wrp.acc.id;  
                    programEmrolmentsToInsert.add(prgEnrolmentClone);                               
                }
            }
        }
        try{
            if(!programEmrolmentsToInsert.isEmpty()){
                insert programEmrolmentsToInsert;
                return new pageReference('/'+ProgramId );
            }
            else {
                Apexpages.Message msg = new Apexpages.message(ApexPages.Severity.ERROR,'Please select atleast one Account.');            
                ApexPages.addMessage(msg);
            }
        }catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
            Apexpages.Message msg = new Apexpages.message(ApexPages.Severity.ERROR,''+ex);            
            ApexPages.addMessage(msg);
        }
        return null;    
        
    }
    
    public class PartnerAccountWrapper{
        public Account acc{set;get;}
        public boolean chk{set;get;} 
// SC:06/05/2014 : Updated the include Counter & SoldTo as per US3662        
        public Integer counter { get; set; } 
        public String SoldTo { get; set; }   
        public PartnerAccountWrapper (Account acc, Integer counter, String SoldTo){
            this.acc = acc;
            this.counter = counter; 
            this.SoldTo = SoldTo;           
        }
    }
    

    
    public pageReference cancel(){
        return new pageReference('/'+ProgramId );
    }

}