/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 05-30-2013
 *
 * Author : Kapil Reddy Sama  
 * 
 * Description : Opportunity Record Type and Type selection based on Sales Type,Product Type anda First Time to Revenue fields.
 *
 *Invoice logo population 
 * // SC:08/01/2014: Added a check for Quick Bid Record Type at line # 583 as per US4170 since the checkboxes are not applicable to QB Oppty.
**/ 

trigger LX_Opportunity_BI_BU on Opportunity (before insert, before update) {

    //Rahul set of string to store the information related type of opportunity using which we would be creating a Sold ToLX_OppSoldToTypes
    static set<string> SoldToCaseOpportunityTypes = new set<string>(Label.LX_OppSoldToTypes.split(','));
    private static final string CountryUS                      ='US';
    private static final string LegacayComp                    ='Lexmark';
    private static final string FinalizedStatus                ='Finalized';
    string userid = userinfo.getUserId();//VT:6/27 Added to get logged in user
    private static User currentUser=LX_OpportunityHelper.populateCurrentUser(userinfo.getUserId());//VT6/27:queries the user fields
    private Integer tempNumber = 0 ;
    static map<string,Invoice_Logo__c> invoiceLogoMap = new map<string,Invoice_Logo__c>();
    //UserCase 3823
   // static map<id,Opportunity> mpIdProgram =  new map<id,Opportunity>();

    Boolean LX_OppSwitch = false;
    
    //Logic to prevent recurssion from workflows
    Boolean workflowUpdate = false;
    
    // US4092- Added by Venkat Arisa on 07/30/2014
     Set<Id> eOfferIds = new Set<Id>();
    for(Opportunity op: Trigger.new){
        if (op.LX_Pricebook_Offer__c != null){
            eOfferIds.add(op.LX_Pricebook_Offer__c);
        }    
    }
    Map<Id,LX_Offer_Enrollment__c> eOfferMap = new Map<Id,LX_Offer_Enrollment__c>([
        select Id, Name, LX_Offer_Name__c From LX_Offer_Enrollment__c where Id in :eOfferIds
    ]);
    for(Opportunity op: Trigger.new){
        if (op.LX_Pricebook_Offer__c != null){
                op.LX_Pricebook_Selected__c = eOfferMap.get(op.LX_Pricebook_Offer__c).LX_Offer_Name__c;
        }   
    }
    //Srini: Added below check as for before delete we can't use trigger.New variable.
    if(trigger.isBefore && !trigger.isDelete)
    {
        for(Opportunity opp:Trigger.new){
         //   mpIdProgram.put(opp.id, opp);
            if(opp.LX_Opportunity_BI_BU__c){
                LX_OpportunityHelper.NotifyDownloads        = true;
                LX_OpportunityHelper.CreateToken            = true;
                LX_OpportunityHelper.LX_Opportunity_AI_AU   = true;
                workflowUpdate =true;   
                opp.LX_Opportunity_BI_BU__c = false;
            }
        }
       // mpIdProgram = new map<id,Opportunity>([Select id, LX_Program_Enrollment__r.Master_Program__c from opportunity where id in :mpIdProgram.keySet()]);
    }
    

    if(workflowUpdate == true) return;  



    if(LX_CommonUtilities.ByPassBusinessRule()) return;     
        
        // Get current profile custom setting.
        LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
        // Get current Organization custom setting.
        LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
        // Get current User custom setting.
        LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
        
        // Allow the trigger to skip the User/Profile/Org based on the custom setting values
        if(LXUser != null)
        {
            LX_OppSwitch = LXUser.LX_Opt__c;
        }
        else if(LXProfile != null)
        {
            LX_OppSwitch = LXProfile.LX_Opt__c;
        }
        else if(LXOrg != null)
        {
            LX_OppSwitch = LXOrg.LX_Opt__c;
        }
    

    if(trigger.isUpdate) {
        
        handler_Opportunity.checkForCurrencyMatch(trigger.new, trigger.oldMap, trigger.isUpdate);

        handler_Opportunity.setFieldsOnInsertUpdate(trigger.new, trigger.oldMap, trigger.isUpdate);

        handler_Opportunity.assignOppTerritoryMember(trigger.new, trigger.oldMap, trigger.isUpdate);
    }

    if(trigger.isInsert) {
        
        handler_Opportunity.checkForCurrencyMatch(trigger.new, trigger.newMap, trigger.isUpdate);

        handler_Opportunity.setFieldsOnInsertUpdate(trigger.new, trigger.newMap, trigger.isUpdate);

        handler_Opportunity.assignOppTerritoryMember(trigger.new, trigger.newMap, trigger.isUpdate);
    }
    
    
        
    
    Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity; 
    //Map<Integer,String> oppStageEndDate = new Map<Integer,String>{1 =>'LX_Hidden_Qualifying_End_Date__c',2 =>'LX_Hidden_Developing_End_Date__c',3 =>'LX_Hidden_Demonstrating_End_Date__c',4 =>'LX_Hidden_Proposing_End_Date__c',5 =>'Hidden_Negotiation_End_Date__c',6 =>'LX_Hidden_Closing_End_Date__c',7=>'End_Date__c'}; 

    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();       
    Map<string, LX_Opp_RecordType__c> mcs = LX_Opp_RecordType__c.getAll();
    System.debug('>>>>>>>>>>>>mcssize>>>>>>>>>>>>>>>'+mcs.size());
    System.debug('>>>>>>>>>>>>mcs>>>>>>>>>>>>>>>'+mcs);
    
    set<id> userSet = new set<id>();
    set<id> salesOrgSet = new set<id>();
    map<id,User> userMap ;
    map<id,Sales_Organization__c> salesOrgMap = new map<id,Sales_Organization__c>();
    

    //VT 6/25:Added for populating fields
    list<id> programIds = new list<id>();
    list<id> campgainsIds = new list<id>();
    //VT 6/26:Added for the list of records which are new logo but don't have a campaign associated

    set<id> AccIdSet    = new set<id>();
    set<id> allAccIds   = new set<id>();
    list<Sales_Organization__c> SalesOrgList1=new list<Sales_Organization__c> ();
    map<string,id> SalesOrgMap1=new map<string,id>();
    map<id,account> AccMap=new map<id,account> ();
    map<string,Id> DefSalesOrg=new map<string,ID>();
    map<string,Id> DefSalesOrgCountry=new map<string,ID>();
    map<Id,ID> AccSalesOrgMAp=new map<Id,ID>();
    map<string,LX_Opportunity_Sales_Org__c> oppSalesOrg = LX_Opportunity_Sales_Org__c.getAll();
    List<account> AccList=new list<account>();
    // map used to store sales org and set of available currencies
    Map<String,set<String>> currencyValuesMap = new Map<String,set<String>>();
    

    // Added maps for defect #320
    map<id,user> portalUserContactIDMap     = new map<id,user>();
    map<string,user> portalUserEmailMap     = new map<string,user>();
    map<string,string> contactIdEmailMap    = new map<string,string>();
    map<id,Contact> contactIdMap    = new map<id,Contact>(); 
    list<id> portalContactIDs   = new list<id>();
    list<string> contactEmails  = new list<string>();
    // ZCWO case creation code for US3356
    // set to store the sold to IDs to query if payment terms = "ZCWO". If yes a case is created and assigned to "CEBU" queue
    set<ID> soldtoPayZCWO    = new set<ID>();
    List<Opportunity> oppSoldtoList = new List<Opportunity>();
    if(currentUser.Legacy_Company__c == null || (currentUser.Legacy_Company__c != null && currentUser.Legacy_Company__c.trim() == '')){
        currentUser.Legacy_Company__c = LegacayComp;        
    }
    
    if(trigger.isBefore){ 
        // udpate the stage number based on the stagename.
        LX_OpportunityHelper.updateOpportunityStageNumber(trigger.new);
        // Added by sumedha on 8/2/2013 : Popluates End date for respective Stages if they are skipped
        //update the end dates based on the stage values.
        LX_OpportunityHelper.updateOpportunityEndDate(trigger.isInsert, trigger.New,trigger.isUpdate, trigger.oldMap);
        // Populate the required fields and validate the data entered.
        LX_OpportunityHelper.updateOpportunityDefaults(trigger.isInsert, trigger.New,trigger.isUpdate, trigger.oldMap, currentUser,LX_OppSwitch);
       
    if(trigger.isUpdate)
    {   
        Set<Id> userIds = new Set<Id>();
        Map<String,List<Id>> mpGroupMembers = new Map<String, List<Id>>();
        List<GroupMember> lstGroupMembers = [Select id,UserOrgroupId, group.developerName from groupMember where Group.Name like 'CountryInScope%' ];  
        System.debug('>>>>>GM>>>>>>>>'+lstGroupMembers.size());
        for(GroupMember gm: lstGroupMembers ){
            UserIds.add(gm.UserOrGroupId);
            if(mpGroupMembers.get(gm.group.developerName) == null)
                mpGroupMembers.put(gm.group.developerName,new List<Id>{gm.UserOrGroupId});
            else
                mpGroupMembers.get(gm.group.developerName).add(gm.UserOrGroupId);
        }
        System.debug('>>>>>mpGM>>>>>>>>'+mpGroupMembers+'@@@@'+mpGroupMembers.size());  
        Map<Id,String> mpAccounts = new Map<Id,String>();   
        Map<Id,String> mpOwners = new Map<Id,String>();    
        Map<Id,List<Id>> mpCountries = new Map<Id,List<Id>>();
        Set<Id> OppIds = new Set<Id>();
        for(Opportunity opp: trigger.new){
            if(opp.Quote_Status__c == 'Approved' && trigger.oldmap.get(opp.Id).Quote_Status__c  != 'Approved' && opp.LX_Master_Opportunity__c){
                OppIds.add(opp.Id);
            }
        }
        if(OppIds.size()>0){
        List<Id> TempList;
            for(LX_Countries_In_Scope__c cis : [Select id, LX_Country__c,LX_Opportunity__c,LX_Opportunity__r.Account.name,LX_Opportunity__r.Owner.Name from LX_Countries_In_Scope__c  where LX_Opportunity__c in: oppIds]){
                if(mpCountries.get(cis.LX_Opportunity__c) != null){
                   TempList = new List<Id>();
                   TempList  = mpCountries.get(cis.LX_Opportunity__c);
                   if(mpGroupMembers.get((LX_Country_Queue__c.getAll().get(cis.LX_country__c)!=null?LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c:''))!=null && mpGroupMembers.get((LX_Country_Queue__c.getAll().get(cis.LX_country__c)!=null?LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c:'')).size()>0){
                       TempList.addall(mpGroupMembers.get((LX_Country_Queue__c.getAll().get(cis.LX_country__c)!=null?LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c:''))); 
                   }
                   if(TempList.size()>0){
                       mpCountries.put(cis.LX_Opportunity__c,TempList);
                   }
                }
                else{
                    System.debug('@@@@' + LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c);
                       if(mpGroupMembers.get((LX_Country_Queue__c.getAll().get(cis.LX_country__c)!=null?LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c:''))!=null && mpGroupMembers.get((LX_Country_Queue__c.getAll().get(cis.LX_country__c)!=null?LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c:'')).size()>0)
                       mpCountries.put(cis.LX_Opportunity__c, mpGroupMembers.get((LX_Country_Queue__c.getAll().get(cis.LX_country__c)!=null?LX_Country_Queue__c.getAll().get(cis.LX_country__c).LX_Group_Name__c:'')));
                }   
                mpAccounts.put(cis.LX_Opportunity__c,cis.LX_Opportunity__r.Account.name);
                mpOwners.put(cis.LX_Opportunity__c,cis.LX_Opportunity__r.Owner.Name);   
            }
            System.debug('@@@@mpCountries@@@@' + mpCountries + mpCountries.size());           
        }    
        
        System.debug('@@@@mpCountries@@@@' + mpCountries + mpCountries.size());      
        Map<Id,String> mpEmails = new Map<Id, String>();
        for(User u : [Select id,email from User where Id in: userIds]){
            mpEmails.put(u.Id, u.email);
        }
        System.debug('>>>>>mpEmails>>>>>>>>'+mpEmails.size());
        String QuoteNumberMail;
        String AccountNameMail;             
        if(mpCountries.size()>0){
              List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
              for(Id OppId : mpCountries.keyset()) {
                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  QuoteNumberMail = ' ';
                  AccountNameMail = ' ';
                  Set<String> setEmails = new Set<String>();
                  if(mpCountries.containsKey(oppId) && mpCountries.get(oppId).size()>0){
                      for(Id uId : mpCountries.get(oppId)){
                          setEmails.add(mpEmails.get(uId));
                      }  
                      List<String> lstEmails = new List<String>();
                      lstEmails.addAll(setEmails);
                      System.debug('>>>>>lstEmails>>>>>>>>'+lstEmails.size());              
                      mail.setToAddresses(lstEmails);
                      mail.setHtmlBody('Hi,<br/>You are receiving this email because you are in the Scope of a Master Participant opportunity where the belonging Master Quote has been approved.<br/>The Master Opportunity Name is ' + trigger.newMap.get(oppId).Opportunity_Number__c + '.<br/>Account Name: ' + mpAccounts.get(oppId)+'.<br/>The Master Quote was created by '+mpOwners.get(oppId)+'.<br/><br/>Please click the link below to review the master opportunity:<br/>'+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppId+'">'+trigger.newMap.get(oppId).Name+'</a><br/><br/>Thank You.<br/>Salesforce Team');                      
                      mail.setSaveAsActivity(false);
                      mails.add(mail);
                      if(trigger.newMap.containsKey(oppId)){
                          if(trigger.newMap.get(oppId).LX_Primary_Quote_Number__c != null){
                            QuoteNumberMail = trigger.newMap.get(oppId).LX_Primary_Quote_Number__c;
                          }
                      }
                      if(mpAccounts.containsKey(oppId)){
                        AccountNameMail = mpAccounts.get(oppId);
                      }
                      mail.setSubject('Master Quote ' + QuoteNumberMail + ' is approved for Account ' + AccountNameMail);
                      }
              }
              if(mails.size()>0){
                  try{
                      Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(mails);
                  }
                  catch(Exception e){
                       LX_CommonUtilities.createExceptionLog(e);
                  }       
              }
        }
        
        
            //Populate MPS Funnel check box 
             if(!LX_OpportunityHelper.WBSPopulated){  
                LX_OpportunityHelper.PopulateBillingWBSElement(Trigger.newMap);// added by sumedha - 2/14 for querying wbs element and populating 
                
            }
            LX_OpportunityHelper.ThrowErrorForSoftwSolOpp(trigger.new);
        }
    }
   
   
    
   for(opportunity opp2:trigger.new){
  

        if(opp2.AccountId != null){
            allAccIds.add(opp2.AccountId);
        }
  
        //updates for the portal user defect#320. Check the if the Quote_Status__c is 'Finalized' and it is not changed from the previous value
        if(((trigger.isInsert)&&(opp2.Quote_Status__c == FinalizedStatus))||((trigger.isUpdate)&&(opp2.Quote_Status__c == FinalizedStatus) && (opp2.Quote_Status__c != trigger.oldMap.get(opp2.id).Quote_Status__c))){
                //UserCase 3823
            if(opp2.Ship_To__c != null && (opp2.LX_Local_Program_ID__c!= Label.LX_NonStandardUser)){
                portalContactIDs.add(opp2.Ship_To__c );
            }
        }
    
   if((trigger.IsInsert && opp2.accountID!=null)
    ||((Trigger.IsUpdate) && (opp2.accountID!=null)&& (trigger.oldmap.get(opp2.id).accountId!=opp2.accountID))){ // Added by sumedha 11/25
            //Adding account ids to a set when AccountId is not null on Opportunity
            AccIdSet.add(opp2.accountID);
       }
       if(opp2.LX_Program_Enrollment__c != null){
            if((trigger.isInsert)||(trigger.isUpdate && opp2.LX_Program_Enrollment__c != trigger.oldMap.get(opp2.id).LX_Program_Enrollment__c)){
               programIds.add(opp2.LX_Program_Enrollment__c);
            }
       }
       
       if(opp2.CampaignId != null){
            if((trigger.isInsert)||(trigger.isUpdate && opp2.CampaignId != trigger.oldMap.get(opp2.id).CampaignId)){
                campgainsIds.add(opp2.CampaignId);
            }
       }
   }
    /******************* VT 1/14 commented and added logic for case creation to opp ai au trigger
   if(soldtoPayZCWO.size()>0){
    LX_Opportunity_SoldTo_Case helperCase = new LX_Opportunity_SoldTo_Case();
    helperCase.CreateOpportunitiesSoldToCaseRequesttoCEBU(oppSoldtoList);
  }*/

   //If the portalContactIDs is not null then generate the map for mapping the portal users.
   if(portalContactIDs.size() > 0){
        list<string> contactEmailIDs = new list<string>();
        for(Contact portalContact:[select id,email, Account.Type from Contact where id =:portalContactIDs]){
            if(portalContact.email != null){
                contactIdEmailMap.put(portalContact.id,portalContact.email);
                contactEmails.add(portalContact.email);
                contactIdMap.put(portalContact.Id, portalContact);
            }
        }
        
        
        for(User portalUser:[select id,contactID,contact.Email,username from user where ((contactID =:portalContactIDs) or (username =:contactEmails)) AND contactID != null] ){
            portalUserContactIDMap.put(portalUser.contactID,portalUser);
            portalUserEmailMap.put(portalUser.username,portalUser);
        }

   }

   
   //Querying account fields and adding them to a map
  system.debug('>>>>>>>>>>>>>AccMap>>>>>>>'+AccMap.values()); 
   if(allAccIds.size()>0){                               
   AccMap=new map<id,account>([SELECT id,Name,TR_Status__c,LX_Country_Code__c,LX_Sales_Team_Assigned__c,area_of_interest_s__c,Interested_Parties__c, Legacy_Company_Originator__c, RA__r.Email, footprint__c
                               FROM Account 
                               WHERE Id IN:allAccIds]);
  system.debug('>>>>>>>>>>>>>AccMap>>>>>>>'+AccMap.values());                             
     }  
   //Logic added for the workflows - LX_Opp Division _PSW_First_TIme_Rev & LX_Opp Division_PSW_Repeat_Customer 
   Set<String> oppStagesSet = new Set<String>();
   oppStagesSet.add('Qualifying');
   oppStagesSet.add('Developing');
   oppStagesSet.add('Demonstrating');
   oppStagesSet.add('Proposing');
   oppStagesSet.add('Closing');
   
 
    //Validate the TR validation
    if(!LX_OppSwitch && !AccMap.isEmpty()){
        LX_OpportunityHelper.validateTRAccounts(trigger.New,AccMap);
    }
  if(!AccMap.isEmpty()){          
    for(account testacc:AccMap.values()){
            if(AccIdSet.contains(testacc.id)){ 
          system.debug('>>>>>>>>>>>>>AccMap>>>>>>>'+AccMap.values());                             
            //iterating over the custom settings to get a match between country code and user's legacy company  
            for(LX_Opportunity_Sales_Org__c SalesRec :oppSalesOrg.values()){
                    if(currentUser.legacy_company__c==LegacayComp && testacc.LX_Country_Code__c==CountryUS){
                                System.debug('currentUser.legacy_company__c-->'+currentUser.legacy_company__c);
                                System.debug('SalesRec.LX_Legacy_Company__c-->'+SalesRec.LX_Legacy_Company__c);
                                System.debug('testacc.LX_Country_Code__c-->'+testacc.LX_Country_Code__c);
                                System.debug('SalesRec.LX_CountryCode__c -->'+SalesRec.LX_CountryCode__c );    
                            
                       if((testacc.LX_Country_Code__c != null) && (testacc.LX_Country_Code__c.trim() != '')&& (testacc.LX_Country_Code__c== SalesRec.LX_CountryCode__c )&& (currentUser.legacy_company__c==SalesRec.LX_Legacy_Company__c)){ 
                                      //Adding values to a map of <4 digit code string,account ID>
                                      DefSalesOrg.put(SalesRec.LX_DefaultSalesOrg__c,testacc.Id);
                                      
                                      //map off country and acc
                                      DefSalesOrgCountry.put(SalesRec.LX_CountryCode__c,testacc.Id);
                        }
                    }else{
                        if(testacc.LX_Country_Code__c== SalesRec.LX_CountryCode__c ){ 
                              DefSalesOrg.put(SalesRec.LX_DefaultSalesOrg__c,testacc.Id);
                              DefSalesOrgCountry.put(SalesRec.LX_CountryCode__c,testacc.Id);
                              break;
                        }
                    }   
                }
            }        
        }
}
if((DefSalesOrg != null && DefSalesOrg.size() > 0)|| (DefSalesOrgCountry != null && DefSalesOrgCountry.size() > 0)){
    //list of sales organisation records where sales org= default code frm the custom setting
    //US2872: Get sales org which has "Default" field checked.
    SalesOrgList1=[SELECT id,Sales_Organization__c ,Name,LX_Country_Code__c,LX_Default__c
              FROM Sales_Organization__c
              WHERE Sales_Organization__c=:DefSalesOrg.keyset() 
              AND LX_Country_Code__c=:DefSalesOrgCountry.keyset() 
              AND LX_Country_Code__c != null];
}               
              //AND LX_Country_Code__c!= :CountryUS  
              //AND LX_Default__c =: true];
    System.debug('SalesOrgList1-->'+SalesOrgList1);
    for(Sales_Organization__c TestSalesOrg: SalesOrgList1){
        if((TestSalesOrg.LX_Country_Code__c != 'US')&&(TestSalesOrg.LX_Default__c)){
            SalesOrgMap1.put(TestSalesOrg.Sales_Organization__c,TestSalesOrg.Id);
        }else if((TestSalesOrg.LX_Country_Code__c == 'US')){
            SalesOrgMap1.put(TestSalesOrg.Sales_Organization__c,TestSalesOrg.Id);
        }
    }         

    for(String TestDefSalesID:DefSalesOrg.keyset()){
        AccSalesOrgMAp.put(DefSalesOrg.get(TestDefSalesID),SalesOrgMap1.get(TestDefSalesID));//<acc,salesorgid>
        System.debug('SalesOrgMap1.get(TestDefSalesID)-->'+SalesOrgMap1.get(TestDefSalesID));
    }
   //****************************
    map<id,LX_Program_Enrollment__c> progMap = new map<id,LX_Program_Enrollment__c>();
    map<id,Campaign> campMap = new map<id,Campaign>();
    
   if(programIds.size()>0){
     progMap = new map<id,LX_Program_Enrollment__c>([select id,LX_Provides_Portal_Access__c from LX_Program_Enrollment__c where id =:programIds]);
   }
   //NJ 4/2 => Added 'Type' field to the query below
  if(campgainsIds.size()>0){
     campMap = new map<id,Campaign>([select id,Name, Type from Campaign where id =:campgainsIds]);
  }
  
   
    for(Opportunity opp1: trigger.new){
        //************************
              if(AccMap.size()>0 && AccMap.containsKey(opp1.accountId)){
                System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + opp1 + '~~~~~~~~~Outside Loop');
               //Logic added to replicate LX_Opp Division _PSW_First_TIme_Rev and LX_Opp Division_PSW_Repeat_Customer workflows and their field updates
                if(opp1.LX_Opportunity_Division__c == 'PSW' && oppStagesSet.contains(opp1.StageName) && (AccMap.get(opp1.accountId).footprint__c == 'None'))
                {
                    System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + opp1 + '~~~~~~~~~Loop 1');
                    opp1.LX_First_Time_to_Revenue__c = 'First Time to Revenue';
                }
                if(opp1.LX_Opportunity_Division__c == 'PSW' && oppStagesSet.contains(opp1.StageName) && (AccMap.get(opp1.accountId).footprint__c != 'None'))
                {
                    System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + opp1 + '~~~~~~~~~Loop 2');
                    opp1.LX_First_Time_to_Revenue__c = 'Repeat Customer';
                }
            }
        

        if(((trigger.IsInsert && opp1.accountID!=null)||
            ((Trigger.IsUpdate) && (opp1.accountID!=null)&& (trigger.oldmap.get(opp1.id).accountId!=opp1.accountID)))
           ){
           
           // Sumedha 11/25: Added code from "UpdateOppFields" trigger
           if(AccMap.size()>0 && AccMap.containsKey(opp1.accountId)){
           /*     if(opp1.Area_of_Interest_s__c == NULL ){  
                    opp1.Area_of_Interest_s__c = AccMap.get(opp1.accountId).area_of_Interest_s__c;
                }
           */
                if(opp1.Legacy_Company_Originator__c == NULL){
                    opp1.Legacy_Company_Originator__c = AccMap.get(opp1.accountId).Legacy_Company_Originator__c;
                }
                if(opp1.Interested_Party__c == NULL && AccMap.get(opp1.accountId).Interested_Parties__c != NULL)
                {
                opp1.Interested_Party__c = AccMap.get(opp1.accountId).Interested_Parties__c;
                }
                 
                // added for case 00030358 
                if(AccMap.get(opp1.accountId).RA__r.Email != NULL) {          
                    opp1.RA_Email__c = AccMap.get(opp1.accountId).RA__r.Email;
                }
            }
             
            if((opp1.Sales_Organization__c == null)){
                opp1.Sales_Organization__c=AccSalesOrgMAp.get(opp1.accountID);
                
                
                //Rahul Added logic for populating the sector. HPQC Defect 49
                if(trigger.isInsert && (opp1.LX_Converted_Lead_ID_Hidden__c != null) && (opp1.AccountID != null)){
                    opp1.Sector__c = AccMap.get(opp1.Accountid).LX_Sales_Team_Assigned__c; 
                    opp1.Amount = opp1.LX_Lead_Amount__c; 
                    if(opp1.LX_Is_Expedited_Opportunity__c=='Yes'){
                        opp1.closedate = System.today().adddays(5);
                    }
                }else if(trigger.isUpdate){
                    //Rahul moved from AI_AU                
                    opp1.Sector__c = AccMap.get(opp1.Accountid).LX_Sales_Team_Assigned__c;
                }
          }  

        }
        //******************************
        //VT 6/25:Added to update LX_Has_Portal_Access__c,LX_Primary_Campaign_Text__c
        if(opp1.LX_Program_Enrollment__c != null && progMap.containsKey(opp1.LX_Program_Enrollment__c)){
            opp1.LX_Has_Portal_Access__c= progMap.get(opp1.LX_Program_Enrollment__c).LX_Provides_Portal_Access__c ;
        }
        if(opp1.CampaignId != null && campMap.ContainsKey(opp1.CampaignId)){
            opp1.LX_Primary_Campaign_Text__c= campMap.get(opp1.CampaignId).Name;
            
            //NJ 4/2 => Added the following for Lead Source Mapping to LeadSource, LX_Lead_Source_Most_Recent__c
            //.. the first checking if Opportunity was created independent of the Lead Conversion Process to
            //.. ensure field is populated 100% of the time
            if(trigger.isInsert && opp1.LX_Converted_Lead_ID_Hidden__c == null) {
                opp1.LeadSource = campMap.get(opp1.CampaignId).Type;
            }
            opp1.LX_Lead_Source_Most_Recent__c = campMap.get(opp1.CampaignId).Type;
        }
        
        if(opp1.sales_organization__c != null){
            salesOrgSet.add(opp1.sales_organization__c);
        }
        
        if((Trigger.isInsert)||
            (trigger.isUpdate && opp1.ownerID != trigger.oldMap.get(opp1.id).ownerID)){
                userSet.add(opp1.ownerId);
        }
        
        system.debug('>>>>>>>>>>>>>>>>'+portalUserEmailMap);
        system.debug('>>>>>>>>>>>>>>>>'+contactIdEmailMap);
        system.debug('>>>>>>>>>>>>>>>>'+opp1.Ship_To__c);
        system.debug('>>>>>>>>>>>>>>>>'+contactIdEmailMap.get(opp1.Ship_To__c));
        
    //***************************** 

    //updates for the portal user defect#320. Check the if the Quote_Status__c is 'Finalized' and it is not changed from the previous value
        if(((trigger.isInsert)&&(opp1.Quote_Status__c == FinalizedStatus))||
            ((trigger.isUpdate)&&(opp1.Quote_Status__c == FinalizedStatus) && (opp1.Quote_Status__c != trigger.oldMap.get(opp1.id).Quote_Status__c))){
                //By Default make the Portal License Check as Yes if it is run.
                opp1.LX_Portal_License_Check_Ran__c = 'YES';
            if((contactIdMap.get(opp1.Ship_To__c) != null)&&((contactIdMap.get(opp1.Ship_To__c).Account.type == 'Partner'))){
                opp1.LX_Portal_License_Check__c = true;
            }   
                
            if(portalUserContactIDMap.ContainsKey(opp1.Ship_To__c)){
                //Check the portal license check if we find a user.
                opp1.LX_Portal_License_Check__c = true;
            }else if((contactIdEmailMap.get(opp1.Ship_To__c) != null)){
                if(!(portalUserEmailMap.ContainsKey(contactIdEmailMap.get(opp1.Ship_To__c)))){
                    //CHeck check box if the email is not present
                    opp1.LX_Portal_License_Check__c = true;
                }
            }
        }

        
    }
   // commented by sumedha 2/4 to include query in below for condition 
   // salesOrgMap = new map<id,Sales_Organization__c>([select id,sales_organization__c from Sales_Organization__c where id in :salesOrgSet]);
    //Rahul Currency Comment
   for(Sales_Organization__c org : [SELECT id,sales_organization__c,Name,LX_Country_Code__c,LX_Default__c,LX_Available_Currencies__c
                                      FROM Sales_Organization__c 
                                      WHERE ID IN :salesOrgSet]){
    /* for(Sales_Organization__c org : [SELECT id,sales_organization__c,Name,LX_Country_Code__c,LX_Default__c
                                      FROM Sales_Organization__c 
                                      WHERE ID IN :salesOrgSet]){*/
     salesOrgMap.put(org.id,org);

    //Rahul Currency Comment
     if(org.LX_Available_Currencies__c != null){
            String currencyValues = org.LX_Available_Currencies__c;
            System.debug('>>>>>>Curre Values>>>>'+currencyValues);
            set<String> currVal = new set<String>();
            currVal.addAll(currencyValues.split(';'));
            currencyValuesMap.put(org.id,currVal); // <salesorg,currencies>
      }                             
    }     
    
    if(userSet.size() > 0){
        userMap = new map<id,User>([Select id,Name,Email,ManagerId,EmployeeNumber,Legacy_Company__c from User where id in :userSet]);
    }else{
        userMap = new map<id,User>(); 
    }
    
    
    LX_OpportunityHelper.updateOpportunityOwnerFields(trigger.isInsert, trigger.new, trigger.isUpdate, trigger.oldMap, userMap);
    
    
    //If invoice logo is not populated then only query
    if(invoiceLogoMap.size() == 0){
        for(Invoice_Logo__c invLogo :[select id,Name from Invoice_Logo__c]){
            invoiceLogoMap.put(invLogo.Name,invLogo);   
        }
    }
   
        for(Opportunity opp: trigger.new){
        //Rahul Currency Comment
         if(opp.sales_organization__c != null && opp.CurrencyIsoCode!= null){
              System.debug('>>>>>>>Curre Validation>>>>>');
                if(!currencyValuesMap.isEmpty() && currencyValuesMap.containsKey(opp.sales_organization__c) 
                  && !currencyValuesMap.get(opp.sales_organization__c).contains(opp.CurrencyIsoCode))
                  {
                    opp.addError('The currency for your opportunity is not valid for this Sales organization.');
                  }
           }

// SC:08/01/2014: Added a check for Quick Bid Record Type as per US4170 since the checkboxes are not applicable to QB Oppty.        
            if(mcs != null && rtMapByName != null && opp.recordtypeId != Label.LX_QuickBid_RecordTypeId){    
                   //Flag to check if there is any valid combination
            Boolean foundValidCombination;
            foundValidCombination = false;
            //If MPS is select then update software_Solution and Technolgy should be selected
                    if(opp.MPS__c == true){
                        opp.Technology__c = true; 
                        opp.Software_Solutions__c = true;
                    }
            
            
            if(opp.LX_Converted_Lead_ID_Hidden__c != null && opp.LX_First_Time_to_Revenue__c == null && AccMap.get(opp.AccountId).footprint__c == 'None'){
                opp.LX_First_Time_to_Revenue__c = 'First time to Revenue';
            } 
            
            else if(opp.LX_Converted_Lead_ID_Hidden__c != null && AccMap.get(opp.AccountId).footprint__c != 'None'&&opp.LX_Opportunity_Division__c != 'PSW'){
                opp.LX_First_Time_to_Revenue__c = 'Repeat Customer';
            }           
            
            //Rahul make the First Time to Revenue in a string
            string accType = '';
            
            if(opp.LX_First_Time_to_Revenue__c == null || AccMap.get(opp.AccountId).footprint__c != 'None'){
                accType = 'Repeat Customer';
            }else{
                accType = opp.LX_First_Time_to_Revenue__c;
            }
            
            string product_type = '';
            {
                if(opp.MPS__c == true){                     
                    product_type +='MPS;';
                }
              if(opp.Software_Solutions__c == true){
                  product_type +='Software Solutions;';
              }
              if(opp.Technology__c == true){
              product_type +='Technology;';
              }            
               if(product_type.substringAfterLast(';')==''){
                    product_type = product_type.substringBeforeLast(';');
                }
                    
            }
            system.debug('>>>>>>>>>>AccType>>>>>>>>>>'+AccType);
            
            //Rahul Update the code to take values from custom setting.
            for(LX_Opp_RecordType__c OppRec :mcs.values()){

                if((OppRec.LX_Opportunity_Division__c == 'ISS' && opp.LX_Opportunity_Division__c == 'ISS' && OppRec.LX_Product_Type__c== product_type && opp.LX_Sales_Type__c == OppRec.LX_Sales_Type__c) || 
                ((OppRec.LX_Opportunity_Division__c == null || OppRec.LX_Opportunity_Division__c.trim() == '' )&& OppRec.LX_Product_Type__c== product_type && opp.LX_Sales_Type__c == OppRec.LX_Sales_Type__c && accType == OppRec.LX_First_Time_to_Revenue__c)||
                ((OppRec.LX_Opportunity_Division__c == 'PSW' && opp.LX_Opportunity_Division__c == 'PSW' )&& OppRec.LX_Product_Type__c== product_type && opp.LX_Sales_Type__c == OppRec.LX_Sales_Type__c && accType == OppRec.LX_First_Time_to_Revenue__c)){ 
                            opp.RecordTypeId=LX_CommonUtilities.GetRecordTypeId(OppRec.LX_Record_Type__c);
                            if(Trigger.IsUpdate && !opp.StageName.contains('Closed')){
                            opp.Type=OppRec.LX_Opportunity_Type__c;}
                            system.debug('>>>>>>>>>>OppRec.LX_Opportunity_Type__c>>>'+OppRec.LX_Opportunity_Type__c);
                            foundValidCombination = true;
                            break;
                    }
             }
               if(!foundValidCombination){
                    string errorMessage = '';
                    if(product_type.trim() != ''){
                        errorMessage = 'The following are valid values for sales type: '+LX_Product_Type_Sales_Type_Mapping__c.getAll().get(product_type).LX_Sales_Type__c+'.';
                        if(!Test.isrunningTest() ){
                            opp.addError('The Sales Type value you have selected is not valid for the Product Type selected. '+errorMessage);
                        }
                     }else{
                         if(!Test.isrunningTest() ){
                            opp.addError('Please check either "Technology" or "Software Solution" or "MPS" checkboxes.');
                         } 
                     }
                }else{
                    foundValidCombination = false;
                }            
            
            //Rahul added for config1BP ISS users // Sumedha - modified the logic based on change request 1/21
            /*if((opp.LX_Opportunity_Owner_Legacy_Company__c == LegacayComp)&&(!(opp.Technology__c))&&(opp.Software_Solutions__c)&&(!(opp.MPS__c)) && opp.LX_Sales_Type__c == 'Add On'){
                opp.Type = 'Add On';
            }else if((opp.LX_Opportunity_Owner_Legacy_Company__c == LegacayComp)&&((opp.Technology__c))&&(opp.Software_Solutions__c)&&(!(opp.MPS__c)) && opp.LX_Sales_Type__c == 'Add On'){
                opp.Type = 'Add On Joint';
            }else if((opp.LX_Opportunity_Owner_Legacy_Company__c == LegacayComp)&&((opp.Technology__c))&&(opp.Software_Solutions__c)&&(!(opp.MPS__c)) && opp.LX_Sales_Type__c == 'New Project'){
                opp.Type = 'New Logo';
            }else if((opp.LX_Opportunity_Owner_Legacy_Company__c == LegacayComp)&&((opp.Technology__c))&&(opp.Software_Solutions__c)&&(!(opp.MPS__c))){
                opp.Type = 'New Logo Joint';
            }*/
 
 
            system.debug('Sales Org-->'+opp.sales_organization_value__c);   
            //system.debug('>>>>>>>>>invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c)>>>>>>'+invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c));

            // Update the invoice logo if opportunity coming from Lead. 
            if((opp.Invoice_Logo__c == null) && (((trigger.isUpdate)&&(((opp.OwnerId)!= trigger.oldMap.get(opp.ID).ownerId)||(opp.sales_organization__c != trigger.oldMap.get(opp.id).sales_organization__c)))||(trigger.isInsert && opp.LX_Converted_Lead_ID_Hidden__c == null))){
                
                //system.debug('>>>>Inside the loop>>>'+opp.OwnerId);
                //system.debug('>>>>Inside the loop>>>'+userMap);
                //system.debug('>>>>Inside the loop>>>'+userMap.get(opp.OwnerId).Legacy_Company__C);
                if(invoiceLogoMap != null && userMap != null && invoiceLogoMap.size() > 0 && userMap.size()> 0 ){
                if((invoiceLogoMap.containsKey(userMap.get(opp.OwnerId).Legacy_Company__C))&&(userMap.get(opp.OwnerId).Legacy_Company__c != 'AccessVia')){
                        opp.Invoice_Logo__c = invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c).id;
                }else if(userMap.get(opp.OwnerId).Legacy_Company__C == 'PCSFT' || userMap.get(opp.OwnerId).Legacy_Company__C == 'Acuo'){
                    if(invoiceLogoMap.containsKey('Perceptive')){
                        opp.Invoice_Logo__c = invoiceLogoMap.get('Perceptive').id;
                    }
                }
                else if(userMap.get(opp.OwnerId).Legacy_Company__c == 'AccessVia' && (opp.sales_organization__c != null) && (salesOrgMap.get(opp.sales_organization__c).sales_organization__c == '5097' || salesOrgMap.get(opp.sales_organization__c).sales_organization__c == '5055' ) && invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c) != null ){
                    opp.Invoice_Logo__c = invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c).id;            
                }else if ((userMap.get(opp.OwnerId).Legacy_Company__c == 'AccessVia') && (opp.sales_organization__c != null)){
                    opp.Invoice_Logo__c = invoiceLogoMap.get('Perceptive').id;          
                }
                else if(userMap.get(opp.OwnerId).Legacy_Company__c == 'Saperion' && (opp.sales_organization__c != null) && (salesOrgMap.get(opp.sales_organization__c).sales_organization__c == '1058') && invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c) != null ){
                    opp.Invoice_Logo__c = invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c).id;            
                }else if ((userMap.get(opp.OwnerId).Legacy_Company__c == 'Saperion') && (opp.sales_organization__c != null)){
                    opp.Invoice_Logo__c = invoiceLogoMap.get('Perceptive').id;              
                }
                }
            }                   
        }//For loop END
    }//If END
}