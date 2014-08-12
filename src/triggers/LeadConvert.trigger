/*********************************************************************************
Name : LeadConvert 
Created By : Appirio Offshore [Akhilesh Soni] 
Created Date : 13 Jan 2011
Usages : Trigger fires on lead conversion and sets the territory from user's territory
Modified : [USI] US2488 : To set the opportunity record type based on the questions on lead.
Modified: [Sanjay George: US3955]: Added case Creation Logic for Converted Account from Locked and Unlocked Record Type
*********************************************************************************/
trigger LeadConvert on Lead (after update){

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update

  List<Id> newOppsId = new List<Id>();
  List<ID> newOppsId_c = new List<ID>();
  List<LX_Opportunity_Competitor__c> opptyCompList = new List<LX_Opportunity_Competitor__c>();
  Map<Id,String> partnerTypeAccountMap = new Map<Id,String>();
  Map<Id,String> accMapDescr = new Map<Id,String>();
  Map<Id,String> accMapSic = new Map<Id,String>();
  Map<Id,String> accMapType = new Map<Id,String>();
  Map<Id,Id> leadIDMap = new Map<Id,Id>();
  Map<Id,Decimal> accMapAccntRev = new Map<Id,Decimal>();
  Map<Id,Integer> accMapEmpLocal = new Map<Id,Integer>();
  Map<String,LX_Opp_RecordType__c> oppRecordType = LX_Opp_RecordType__c.getAll();
  Boolean partType = false;
  set<Case> LeadConversionCaseset= new set<case>();
  for(Lead l : Trigger.New) {  
      // [USI: US3955]
    if(Trigger.oldMap.get(l.Id).isConverted == false && l.isConverted == true){
      if(l.ConvertedAccountId!=null&&LX_Lead_util.CreatedAccountIDSet.contains(l.ConvertedAccountId)&&FirstRun_Check.FirstRun_LeadConvert&&(l.Recordtypeid==LX_SetRecordIDs.LeadLockedRecordTypeId ||l.Recordtypeid==LX_SetRecordIDs.LeadUnlockedRecordTypeId )){
          //Case cs=;
          FirstRun_Check.FirstRun_LeadConvert=false;
          LeadConversionCaseset.add(LX_Lead_util.PopulateLockedUnlockedCase(l));
      }
      
      // --->>US3955 Ends here<<---
      
      
      if (l.ConvertedOpportunityId != null)
      {
        newOppsId.add(l.ConvertedOpportunityId);
        // below code is for upcoming change in US 2500
        LX_Opportunity_Competitor__c opptyComp = new LX_Opportunity_Competitor__c();
        opptyComp.LX_Opportunity__c = l.ConvertedOpportunityId;
        opptyComp.LX_Competitor_Account__c = l.Competitor_Solution__c;
        opptyComp.AccIdOppId__c = ''+opptyComp.LX_Opportunity__c+''+opptyComp.LX_Competitor_Account__c;
        if(opptyComp.LX_Competitor_Account__c!=null){
        opptyCompList.add(opptyComp);
        }
        System.debug('competitor added >>>>>>>>>');
      }
                            
 // US2488 End   USI
      if(l.ConvertedContactId != NULL)
      {
          newOppsId_c.add(l.ID); 
      }
      if(l.LX_Party_Group__c == 'Partner' && l.ConvertedAccountId != NULL){
               partnerTypeAccountMap.put(l.ConvertedAccountId, l.LX_Party_Group__c); 
               accMapDescr.put(l.ConvertedAccountId, l.Company_Description__c); // [Nick Johnson 18-Mar-14] : Replaced Calypso_Description__c mapping with Company_Description__c
               accMapSic.put(l.ConvertedAccountId, l.SIC_Code__c);
               accMapAccntRev.put(l.ConvertedAccountId, l.AnnualRevenue);
               accMapEmpLocal.put(l.ConvertedAccountId, l.NumberOfEmployees);
               leadIDMap.put(l.ConvertedAccountId, l.Id);
               partType = true ;
      }
      if(l.ConvertedAccountId != NULL && (l.LX_Party_Group__c == 'Customer' || l.LX_Party_Group__c == NULL)){ 
            partnerTypeAccountMap.put(l.ConvertedAccountId, l.LX_Party_Group__c);
            accMapDescr.put(l.ConvertedAccountId, l.Company_Description__c); // [Nick Johnson 18-Mar-14] : Replaced Calypso_Description__c mapping with Company_Description__c
            accMapSic.put(l.ConvertedAccountId, l.SIC_Code__c);
            accMapAccntRev.put(l.ConvertedAccountId, l.AnnualRevenue);
            accMapEmpLocal.put(l.ConvertedAccountId, l.NumberOfEmployees);
            leadIDMap.put(l.ConvertedAccountId, l.Id);
      }
    }
    
    System.debug('$$$$$ '+accMapType +'@@@@@ '+accMapSic);
  }
  If(opptyCompList != null && opptyCompList.size() > 0){   
        System.debug('competitor list size >>>>>>>>>'+opptyCompList.size());
        System.debug('competitor list >>>>>>>>>'+opptyCompList);
        upsert opptyCompList AccIdOppId__c;
  }

 if(!newOppsId_c.isEmpty())
  {
  UpdateUserPanelSurvey.updateSurvey(newOppsId_c);
  }
  if(!(partnerTypeAccountMap.isEmpty())){
  List<Account> accList = [select Id, createdDate, lastModifiedDate, RecordTypeId, LX_Lead_Convert_Check__c, LX_Converted_Lead_ID_Hidden__c, Type, Party_Type__c, Sic, Annual_Revenue_In_Country_Override__c, Employees_Override__c, ISS_Coverage_Model__c, ISS_Coverage_Method__c, Coverage_Status__c, MPS_Qualification__c, Local_Priority__c, TR_Status__c From Account where Id In : partnerTypeAccountMap.keySet()]; 
  System.debug('inside 3 partType is >>>>>>>>>'+partType);
  Id mdmPartnerRecTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('MDM Partner').getRecordTypeId();
  Id mdmCustomerRecTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
  Id locCustomerRecTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
  if(partType){
  String partnerRecTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
  for(Account acc: accList){
    System.debug('Inside for loop...>>>>>>>>>>>>>>>>');
    System.debug('acc.createdDate...>>>>>>>>>>>>>>>>'+acc.createdDate);
    System.debug('acc.lastModifiedDate...>>>>>>>>>>>>>>>>'+acc.lastModifiedDate);
    //acc.RecordTypeId = recType.Id;\
     long dt1 = acc.CreatedDate.getTime();
    long dt2 = acc.LastModifiedDate.getTime();
     double dDifferneceInSeconds = dt2 - dt1;   //differnece will get in milliseconds, to compare with seonds divide by 1000
     system.debug('dDifferneceInSeconds == '+dDifferneceInSeconds);
     
    if(acc.LX_Converted_Lead_ID_Hidden__c == leadIDMap.get(acc.Id) && ((dDifferneceInSeconds/1000) < 10)){
    System.debug('inside 5 >>>>>>>>>');
    acc.RecordTypeId = partnerRecTypeId;
    
    if(acc.Type == null || acc.Type == '' || acc.Party_Type__c <> 'Business Customer'){
        acc.Type = partnerTypeAccountMap.get(acc.Id);}
    //if(acc.Lead_Conversion_ID__c  != null){
        //acc.Lead_Conversion_ID__c  = null;}
    
    if(acc.Description == null || acc.Description == ''){
        acc.Description = accMapDescr.get(acc.Id);}
    if(acc.Sic == null || acc.Sic == ''){
        acc.Sic = accMapSic.get(acc.Id);}
    if(acc.Annual_Revenue_In_Country_Override__c == null){
        acc.Annual_Revenue_In_Country_Override__c = accMapAccntRev.get(acc.Id);}
    if(acc.Employees_Override__c == null){
        acc.Employees_Override__c = accMapEmpLocal.get(acc.Id);}
    if(acc.ISS_Coverage_Model__c == null || acc.ISS_Coverage_Model__c == ''){
        acc.ISS_Coverage_Model__c = 'Channel';}
    if(acc.ISS_Coverage_Method__c == null || acc.ISS_Coverage_Method__c == ''){
        acc.ISS_Coverage_Method__c = 'Uncovered';}
    if(acc.Coverage_Status__c == null || acc.Coverage_Status__c == ''){
        acc.Coverage_Status__c = 'Inactive';}
    if(acc.MPS_Qualification__c == null || acc.MPS_Qualification__c == ''){
        acc.MPS_Qualification__c = 'NA';}
    if(acc.Local_Priority__c == null || acc.Local_Priority__c == ''){
        acc.Local_Priority__c = 'H';}
    if(acc.TR_Status__c == null || acc.TR_Status__c == ''){
        acc.TR_Status__c = 'N/A';}
        
    }
    acc.LX_Lead_Convert_Check__c = true;
    System.debug('acc.RecordTypeId...>>>>>>>>>>>>>>>>'+acc.RecordTypeId);
    System.debug('partnerRecTypeId...>>>>>>>>>>>>>>>>'+partnerRecTypeId);
  }
   system.debug('accList 1 == '+accList);
  if(accList.size() > 0){
    update accList;
  }
  }else{
  Id mdmCustomerRecTypeId1 = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
  String customerRecType = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
  for(Account acc: accList){
    System.debug('Inside for loop...>>>>>>>>>>>>>>>>>>>>>');
    System.debug('Inside for loop... lead id hidden >>>>>>>>>>>>>>>>>>>>>'+acc.LX_Converted_Lead_ID_Hidden__c);
    System.debug('Inside for loop... lead id hidden >>>>>>>>>>>>>>>>>>>>>'+leadIDMap.get(acc.Id));
    long dt1 = acc.CreatedDate.getTime();
    long dt2 = acc.LastModifiedDate.getTime();
     double dDifferneceInSeconds = dt2 - dt1;   //differnece will get in milliseconds, to compare with seonds divide by 1000
     system.debug('dDifferneceInSeconds == '+dDifferneceInSeconds);
    if(acc.LX_Converted_Lead_ID_Hidden__c == leadIDMap.get(acc.Id) && ((dDifferneceInSeconds/1000) < 10)){
    acc.RecordTypeId = customerRecType;
    if(acc.Type == null || acc.Type == ''){
        acc.Type = partnerTypeAccountMap.get(acc.Id);}
   // if(acc.Lead_Conversion_ID__c  != null){
        //acc.Lead_Conversion_ID__c  = null;}
    
    if(acc.Description == null || acc.Description == ''){
        acc.Description = accMapDescr.get(acc.Id);}
    if(acc.Sic == null || acc.Sic == ''){
        acc.Sic = accMapSic.get(acc.Id);}
    if(acc.Annual_Revenue_In_Country_Override__c == null){
        acc.Annual_Revenue_In_Country_Override__c = accMapAccntRev.get(acc.Id);}
    if(acc.Employees_Override__c == null){
        acc.Employees_Override__c = accMapEmpLocal.get(acc.Id);}
         
    }
    acc.LX_Lead_Convert_Check__c = true;
  }
  system.debug('accList 2== '+accList);
  
          
      
  if(accList.size() > 0){
    update accList;
  }
  }
  }
  if(LeadConversionCaseset.size()>0){
      List<case> LeadConversionCaseList = new List<Case>();
      LeadConversionCaseList .addall(LeadConversionCaseset);
      insert LeadConversionCaseList ;
      
      }
  system.debug('Lead Convert trigger end >>>>>>>>>>>>>>');
}