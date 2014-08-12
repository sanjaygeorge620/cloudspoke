/*
Class Name : LX_OpportunityHelper
Description : Helper class to consolidate all the methods used in the various opportunity related functionality
Created By : Kapil Sama Reddy (ksama@deloitte.com)
Created Date : 10-6-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Kapil Reddy      10-6-2013        1000                   Initial Version
Rashi Joshi      19-09-2013                              User Story #2848
Srinvias P       16-12-2013                              US 3320       
Veenu Trehan     12-18-2013                              Added method ThrowErrorForSoftwSolOpp
Rahul R          03-03-2014                              Added method to populate the current user value as a static method.   
Praveen S        06-25-2014                              Added Method to Update the Flags on Account based on the Line Item Part Types
*************************************************************************/

public class LX_OpportunityHelper  {
    
 Public static Boolean NotifyDownloads = false;
 Public static Boolean ProcessInstallations = false;
 Public static Boolean LX_Opportunity_BI_BU = false;
 Public static Boolean LX_Opportunity_AI_AU = false;
 Public static Boolean OpportunityLineItemGrouping = false;
 Public static Boolean OpportunityTrigger = false;
 Public static Boolean UpdateOpportunityLineItemDates = false;
 Public static Boolean CreateToken = false;
 Public static Boolean CreateSAPProject = false;
 Public Static Boolean IsFutureCalled = false;
 Public static Boolean IsFutureCalled1 = false;
 
 public static Boolean WBSPopulated     = false;
 public static map<id,User> currentUserMap = new map<id,User>();
    public static boolean alreadyUpdated = false;
    public static boolean UpdateOpportunity_AI_AU=false;
    // Declare all the constants that are used in Opportunity
    public final static string selectedRecord   = 'selectedRecord';
    public final static string type             = 'type';
    public final static string accountId        = 'accountId';
    public final static string oppId            = 'oppId';  
    public final static string RMAID            = 'RMAID';     
    public final static string projID           = 'projID'; 
    public final static string newOrderID       = 'newOrderID'; 
    
    // Below set of fields are refereed in Lx_Oppactive class
    
    Public final static String Sales_Type_c              = 'SMSA Renewal'; 
    Public final static String Purchasing_Method_c       = 'Direct';
    Public final static String Typeopp                   = 'Add On Solution';     
    Public final static String Change_Request_c          = 'No';     
    Public final static String ForecastCategoryNameopp   = 'Omitted'; 
    Public final static String StageName                 = 'Closed Won';           
    Public final static String StageNameopp              = 'Closed Won';
    Public final static String Contract_Indicator_copp   = 'NVE';
    Public final static String Opportunity_Division_c    = ' PSW';
    Public final static String Next_Steps                = 'Serial Number SMSA Renewal';
    Public final static String Quote_Status              = 'Finalized';
    Public final static String Legacy_Company_Originator = 'PACSGEAR';
    Public static Boolean OppcactiveT                    = True;

    
    public final static string LX_QUALIFYING    = 'Qualifying';
    public final static string LX_DEVELOPING    = 'Developing';
    public final static string LX_DEMONSTRATING = 'Demonstrating';
    public final static string LX_PROPOSING     = 'Proposing';
    public final static string LX_CLOSING       = 'Closing';
    public final static string LX_WON           = 'Closed Won';

    public final static string LX_NEW_LOGO      = 'New Logo';
    public final static string LX_PSE           = 'PSE';
    public final static string LX_Accounting    = 'Accounting';
    
    public static boolean isTestBypass    = false;

    //VT added 12/18
    public final static string PartType1='Prof Service - Time';
    public final static string PartType2='Prof Service - Fixed Fee';
    public final static string PartType3='Prof Service - Expense';
    /////////
    Public static boolean   BMIflag             =false;
    public final static string WBSType='Billing';
    public final static Map<Integer,String> oppStageEndDate         = new Map<Integer,String>{
                                                                        1 =>'LX_Hidden_Qualifying_End_Date__c',
                                                                        2 =>'LX_Hidden_Developing_End_Date__c',
                                                                        3 =>'LX_Hidden_Demonstrating_End_Date__c',
                                                                        4 =>'LX_Hidden_Proposing_End_Date__c',
                                                                        5 =>'LX_Hidden_Closing_End_Date__c'};
                                                                        
    private static Pricebook2 standardPricebookPrivate;                                                                        
    
    public static Pricebook2 standardPricebook {
                                                get{
                                                        if(!Test.isRunningTest()){
                                                            if(standardPricebookPrivate == null){
                                                                standardPricebookPrivate = [Select IsStandard, Id From Pricebook2 where isStandard=true limit 1];
                                                            }
                                                            return standardPricebookPrivate;       
                                                        }else{
                                                            return null;
                                                        }
                                                    }
                                              }
                                                

    //public static map<id,id> userDefaultTerritoryId         = new map<id,id>();
    public static map<String,Company_Code__c> mpCodeToCC    = new map<String,Company_Code__c>();

     /*
     * Description : populateCurrentUser
     * Param - : Populates the values for the current user from the ID passed
     * Returns : null
     */
    public static User populateCurrentUser (id CurrentUserID){
        //If the current User is present return the value from the map;
        if(currentUserMap.ContainsKey(CurrentUserID)){
            return currentUserMap.get(CurrentUserID);
        }else{
        //If the current User is not present the query the value, populate the value from the SOQL Query and then return the value from the map;    
            currentUserMap.put(CurrentUserID, [Select id,legacy_company__c,Profile.Name from User where id =:CurrentUserID]);
            return currentUserMap.get(CurrentUserID);   
        }       
        
    }

    
     /*
     * Description : validateTRAccounts
     * Param - : Validation rule moved to trigger becuase of the limits hit
     * Returns : null
     */
    public static void validateTRAccounts (list<Opportunity> newOpps,map<id,Account> accountMap){

        //iterate over the opportunity and check if the account is of TR type 
        for(Opportunity opp:newOpps){
            if(opp.AccountId != null){
                if((accountMap.containsKey(opp.AccountID))&&
                    (accountMap.get(opp.AccountID).TR_Status__c == 'On')&&
                    ((opp.LX_Pricing_Partner__c != null)||(opp.LX_Price_List_Offer__c != null))){
                        opp.adderror(Label.LX_TR_PrcingError);
                }
            }
        }
            
    }
    /*
     * Description : ThrowErrorForSoftwSolOpp
     * Param - : Validation rule moved to trigger becuase of the limits hit, throws error if  Change Request =yes and cr related opp is null
     * Returns : null
     */   
    
 public static void ThrowErrorForSoftwSolOpp(list<Opportunity> OppList){
       
         for(Opportunity OppRec:OppList){
        
              if(OppRec.LX_Change_Request__c=='Yes' && OppRec.LX_CR_Related_Opportunity__c == null ){
                System.debug('**Inside if');
                OppRec.LX_CR_Related_Opportunity__c.addError('Please add CR Related Opportunity');
                }
         }  
    }
          
       

    /*
     * 
     * Description : Methods to update the Stage Number
     * Param - : Trigger.New
     * Returns : null
    */
    public static void updateOpportunityStageNumber(list<Opportunity> oppList){
        //Based on the stages assign the numbers to the opportunity
        for(opportunity opp2:oppList){
            if(opp2.StageName == LX_QUALIFYING){
                opp2.LX_Stage_Number_New__c=1;
            }else if(opp2.StageName == LX_DEVELOPING){
                opp2.LX_Stage_Number_New__c=2;
            }else if(opp2.StageName == LX_DEMONSTRATING){
                opp2.LX_Stage_Number_New__c=3;
            }else if(opp2.StageName == LX_PROPOSING){
                opp2.LX_Stage_Number_New__c=4;
            }else if(opp2.StageName == LX_CLOSING){
                opp2.LX_Stage_Number_New__c=5;
            }else if(opp2.StageName == LX_WON){
                opp2.LX_Stage_Number_New__c=6;
            }
        }   
    }

    /*
     * 
     * Description : Check for Data Inegrity on the following counts
     *               Clears the Invoice logo if the owner of the Opp is changed.
     *               Defaults the amount to 50K
     *               Checks for the  Primary Campaign for a new Logo Oppo.
     *               Sets the primary pricebook as the standard pricebook.
     * Param - : Trigger.New
     * Param - : Trigger.isInsert Flag
     * Param - : Trigger.oldMap
     * Param - : Trigger.isUpdate
     * Param - : Current user details
     * Param - : bypass Logic
     * Returns : null
    */
    public static void updateOpportunityDefaults(boolean isInsert, list<Opportunity> oppList, boolean isUpdate, map<id,Opportunity> oldMap, User currentUser, boolean bypassValidation){

        //Iterate over the new list
        for(Opportunity newOpp:oppList){
        system.debug('>>>>>'+newOpp.LX_Sold_To_New__c);            
            //Clear the Invoice logo when the Owner Id is changed.  
            if((isUpdate)&&((newOpp.OwnerId)!= oldMap.get(newOpp.ID).ownerId)){
                newOpp.Invoice_Logo__c = null;
            } 
            
            //Update the amount to 50,000 if the opportunity is coming from an Lead and it is not already updated
            if((isInsert)&&(newOpp.LX_Converted_Lead_ID_Hidden__c!= null)&&(newOpp.Amount == null)){
                newOpp.Amount = 50000;
            }
            
            // Clear out Ship To and Bill To Information if the stage is else. 
            // if its is closed won then throw an error.
            if(isUpdate && (newOpp.LX_Sold_To_New__c != oldMap.get(newOpp.id).LX_Sold_To_New__c)){
                if(newOpp.stageName != LX_WON){
                    newOpp.LX_Ship_To_Address__c = '';
                    newOpp.LX_Ship_To_Address_2__c = '';
                    newOpp.LX_Ship_To_City__c = '';
                    newOpp.LX_Ship_To_Company__c = '';
                    newOpp.LX_Ship_To_Company_2__c = '';
                    newOpp.LX_Ship_To_Country__c = '';
                    newOpp.LX_Ship_To_ID__c = '';
                    newOpp.Ship_To_Name__c = '';
                    newOpp.LX_Ship_To_Postal__c = '';
                    newOpp.LX_Ship_To_State__c = '';
        
                    newOpp.LX_Bill_To_Address__c = '';
                    newOpp.LX_Bill_To_Address_2__c = '';
                    newOpp.LX_Bill_To_City__c = '';
                    newOpp.LX_Bill_To_Company__c = '';
                    newOpp.LX_Bill_To_Company_2__c = '';
                    newOpp.LX_Bill_To_Country__c = '';
                    newOpp.LX_Bill_To_ID__c = '';
                    newOpp.Bill_To_Name__c = '';
                    newOpp.LX_Bill_To_Postal__c = '';
                    newOpp.LX_Bill_To_State__c = '';
                    newOpp.LX_Bill_To_Email_Address__c = '';
                }else{
                    //Move to custom label.
                    newOpp.addError('You cannot change the \"Sold To\" once opportunity is in \"Closed Won\" stage.');    
                }
            }
            //VT 6/24:Added to deafult standard procebook
            if((isInsert)&&(LX_OpportunityHelper.standardPricebook != null) && (!Test.isRunningTest())){
                newOpp.pricebook2ID = LX_OpportunityHelper.standardPricebook.Id;
            }
            system.debug('@@@1    currentUser.Profile.Name'+currentUser.Profile.Name);
            // Add error to the opportunity where the campaign is missing           
            if(newOpp.type==LX_NEW_LOGO &&(newOpp.CampaignId ==null)&&(!currentUser.Profile.Name.contains(LX_PSE) && !currentUser.Profile.Name.contains(LX_Accounting))){
                system.debug('@@@2'); 
                if((bypassValidation != null)&&!(bypassValidation)){
                system.debug('@@@3');
                    newOpp.CampaignId.addError(label.LX_Required_a_primary_campaign_to_be_entered_if_the_Opportunity_Type_New_Logo);
                }
            }
        }
    }

    /*
     * 
     * Description : Update the various fields that stores the information about the opportunity owner.
     * Param - : Trigger.New
     * Param - : Trigger.isInsert Flag
     * Param - : Trigger.oldMap
     * Param - : Trigger.isUpdate
     * Param - : ownerMap
     * Returns : null
    */
    public static void updateOpportunityOwnerFields(boolean isInsert, list<Opportunity> oppList, boolean isUpdate, map<id,Opportunity> oldOpp,map<id,User> OppOwnerMap){
        
        for(Opportunity opp : oppList)
        {
            if(opp.OwnerId != null && OppOwnerMap.containskey(opp.OwnerID))
            {
                opp.Owner_Email__c      = OppOwnerMap.get(opp.OwnerID).email;
                //set Owner Manager field
                opp.Owner_Manager__c    = OppOwnerMap.get(opp.OwnerId).ManagerId;
                //added for US1145 by Manoj Kolli on 3/19/2012
                opp.Employee_Number__c  = OppOwnerMap.get(opp.OwnerId).EmployeeNumber;
                //added for US1145 by Manoj Kolli on 3/19/2012
                opp.Legacy_User_Sales_Company__c = OppOwnerMap.get(opp.OwnerId).Legacy_Company__c;
                
                //update the Division
                
                if(OppOwnerMap.get(opp.OwnerId) != null && ((OppOwnerMap.get(opp.OwnerId).Legacy_Company__c == 'Lexmark') ||(OppOwnerMap.get(opp.OwnerId).Legacy_Company__c == '')||(OppOwnerMap.get(opp.OwnerId).Legacy_Company__c == null))){
                    opp.LX_Opportunity_Division__c = 'ISS';
                }else{
                    opp.LX_Opportunity_Division__c = 'PSW';
                }
            }
        }
    
        //update the opportunity Begin Date, End Date & Contract End Date

        Date oppContractEndDate;
        Date mydate = Date.today();
        Map<ID, Opportunity> OpportunityRecMap = new Map<ID, Opportunity>();   
          
        String[] oppTypeSet = new String[]{'New Solution','New Logo'};
        MAP<ID,integer> mapOppProductsType = new MAp<ID,integer>();
        
        if(isUpdate)
                mapOppProductsType = getOpportunityProducts(oppList);
        
        for (Opportunity oppRec : oppList){
            if(oppRec.LX_Opportunity_Division__c == 'PSW'){             
            if ((isInsert)||(isUpdate 
                    &&  (oldOpp.get(oppRec.id).QAStatus__c != 'Complete' 
                    || oldOpp.get(oppRec.id).Contract_End_Date__c != OppRec.Contract_End_Date__c )
                    && FirstRun_Check.FirstRun_UpdateOpportunityLineItems)
                 )
                 {
                  opportunityRecMap.put(opprec.id, oppRec);
                  oppContractEndDate = oppRec.Contract_End_Date__c;
                  FirstRun_Check.FirstRun_UpdateOpportunityLineItems = False;
                }
            }
            
        }
        if (opportunityRecMap.size() > 0){
          
            //update only opportunities that are set to QA_status = 'Complete' and recordtype contains 'New Logo'
            for(Opportunity oppRec : opportunityRecMap.Values())
            {
                Date oneYearDate = mydate.addYears(1);
                oppContractEndDate = oneYearDate.addDays(-1);
                Date currentOppContractEndDate = oppRec.Contract_End_Date__c;
                
                 
                if(mapOppProductsType.get(oppRec.id) == 0)
                    oppRec.Contract_End_Date__c = oppContractEndDate;
                
                if(oppRec.QALevel2Approved__c == True){
                    boolean endDateSet = false;
                    oppRec.Begin_Date__c = mydate;
                    for( string oppType : oppTypeSet){
                        if (oppRec.Type == oppType){
                        //set contract end date = today+1year - 1 day;
                            OpportunityRecMap.get(oppRec.id).Contract_End_Date__c = oppContractEndDate;
                            OppRec.End_Date__c = oppContractEndDate;
                            endDateSet = true;
                         }
                    }
                    if(endDateSet == false)
                    { 
                        if (currentOppContractEndDate > oppContractEndDate)
                        {
                            oppRec.End_Date__c = currentOppContractEndDate;
                        }
                        Else 
                        {
                            if ((currentOppContractEndDate <= oppContractEndDate) || (currentOppContractEndDate == null))
                            {
                                 oppRec.End_Date__c = oppContractEndDate;
                            }
                        }   
                    }                
                }

            }   
              
        }           
    }



    /*
     * 
     * Description : Update the Stage End Dates when they are skipped.
     * Param - : Trigger.New
     * Param - : Trigger.isInsert Flag
     * Param - : Trigger.oldMap
     * Param - : Trigger.isUpdate
     * Returns : null
    */
    public static void updateOpportunityEndDate(boolean isInsert, list<Opportunity> oppList, boolean isUpdate, map<id,Opportunity> oldOpp){
        
        for(Opportunity currentOpp:oppList){
            
            
            if(isUpdate){
                //moved LX_Opportunity Ai AU
                if((currentOpp.Quote_Status__c!= null)&&(currentOpp.Quote_Status__c.equalsIgnoreCase(System.Label.LX_Opp_Quote_Status))&&(currentOpp.Quote_Status__c != oldOpp.get(currentOpp.id).Quote_Status__c)){
                    currentOpp.LX_Opportunity_Finalized__c = true;
                }       
            }
            
            
            Integer oldStageNumber = 1;
            // Based on the conditions first check if the Opportunity stage has changed or not.
            if((isUpdate && currentOpp.LX_Stage_Number_New__c > oldOpp.get(currentOpp.id).LX_Stage_Number_New__c ) 
            || (isInsert && currentOpp.LX_Stage_Number_New__c > 1)){
                
                system.debug('>>>>>>>>>>inside If');
                //If the operation is an update operate then take the old stage number
                if(isUpdate){
                    oldStageNumber = Integer.valueOf(oldOpp.get(currentOpp.id).LX_Stage_Number_New__c );
                }else if(isInsert){
                    //Else if it the current stage then assume the old stage as 1
                    oldStageNumber = 1;
                }
                
                // Iterate over the stage maps and generate end date all the stages between the new dates as follows
                // If the corresponding end date is null.
                // If the corresponding end date is in the past.
                for(Integer index = oldStageNumber; index< currentOpp.LX_Stage_Number_New__c;index++){
                    system.debug('>>>>>>>'+oppStageEndDate.get(index));
                    if(oppStageEndDate.containsKey(index) && 
                    (Date.Valueof(currentOpp.get(oppStageEndDate.get(index))) == NULL || Date.Valueof(currentOpp.get(oppStageEndDate.get(index))) < System.Date.today())){
                        if(index != 1 && index != currentOpp.LX_Stage_Number_New__c)
                        currentOpp.put(oppStageEndDate.get(index),System.Date.today());
                        else if(index==1){
                            if(oppStageEndDate.get(index).contains('Qual'))
                            currentOpp.put(oppStageEndDate.get(index),System.Today());
                        }
                        else{
                            
                            if(oppStageEndDate.get(index).contains('Develop'))
                            currentOpp.put(oppStageEndDate.get(index),currentOpp.Date_Developing_Conv__c);
                            if(oppStageEndDate.get(index).contains('Demonstrat'))
                            currentOpp.put(oppStageEndDate.get(index),currentOpp.Date_Demonstrating_Conv__c);
                            if(oppStageEndDate.get(index).contains('Proposing'))
                            currentOpp.put(oppStageEndDate.get(index),currentOpp.Date_Proposal_Conv__c);
                            if(oppStageEndDate.get(index).contains('Closing'))
                            currentOpp.put(oppStageEndDate.get(index),currentOpp.Date_Closing_Conv__c);
                        }
                    }
                }
            }
            //Based on the conditions blank out the values if we move back.
            if((isUpdate && (currentOpp.LX_Stage_Number_New__c < oldOpp.get(currentOpp.id).LX_Stage_Number_New__c) && oldOpp.get(currentOpp.id).LX_Stage_Number_New__c + 1 != currentOpp.LX_Stage_Number_New__c )){
                
                //If the operation is an update operate then take the old stage number
                if(isUpdate){
                    oldStageNumber = Integer.valueOf(oldOpp.get(currentOpp.id).LX_Stage_Number_New__c );
                }
                
                // Iterate over the stage maps and generate end date all the stages between the new dates as follows
                // If the corresponding end date is null.
                // If the corresponding end date is in the past.
                for(Integer index = Integer.valueOf(currentOpp.LX_Stage_Number_New__c); index< oldStageNumber;index++){
                    if(oppStageEndDate.containsKey(index)){
                        currentOpp.put(oppStageEndDate.get(index),null);
                    }
                }
            }
            
            
            
        }
    }

    /*
     * 
     * Description : This method to update the opportunity to indicate that the opportunity is an Acuo opportunity.
     * Param - : ID of the opportunity
     * Returns : null
    */
    @future                          
  public static void updateAcuoOpp(set<id> acuoIDs){
    LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
    list<Opportunity> acuoOpp = new list<Opportunity>();
    
    for(ID ids :acuoIDs){       
        acuoOpp.add(new opportunity(ID = ids,Contains_Acuo_Prod__c = True));
    }
    
    if(acuoOpp.size() > 0){
        try{
            update acuoOpp;
        }catch (exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }
    }
    
    //Opportunity updateParentOpp = new Opportunity(id=parentOppId,LX_Has_Participant_Opportunities__c=true,LX_Master_Opportunity__c=true);
    //update updateParentOpp ;
  }


    /*
     * 
     * Description : This method to update the opportunity to indicate if child is present
     * Param - : ID of the opportunity
     * Returns : null
    */
    @future                          
  public static void updateOppChildFlag(string parentOppId){
    Opportunity updateParentOpp = new Opportunity(id=parentOppId,LX_Has_Participant_Opportunities__c=true,LX_Master_Opportunity__c=true);
    update updateParentOpp ;
  }

    

    /*
     * 
     * Description : This method updates the opportunity with Quote information from LX_BI_BUQuote trigger
     * Param - : Set of opportunity ids whose values need to be updated.
     * Returns : null
    */
    @future                          
    public static void updateOppFromQuote(Map<ID,Boolean> oppFinal, Map<ID,Integer> oppNumber)
    {
        
        //List of Opportunity that needs to be updated.
        list<Opportunity> oppListtoBeUpdated = new list<opportunity>();
        set<id> oppotunityIds = new set<id>();
        system.debug('-------------' +oppNumber.keyset());
        if(oppFinal != null)
        {
            oppotunityIds.addall(oppFinal.keySet());
        }
        
        if(oppNumber!= null){
            oppotunityIds.addall(oppNumber.keySet());
        }
        
        //loop for the opp id
        for(Id curOppID :oppotunityIds)
        {
            system.debug('opp no of quotes '+curOppID);
            Opportunity opp = new Opportunity (id = curOppID);
            // Check if the opportunity is updating the Number?
            if(oppNumber.containsKey(curOppID))
            {
                opp.LX_No_of_BM_Quotes__c  = oppNumber.get(curOppID);
                system.debug('opp no of quotes '+opp.LX_No_of_BM_Quotes__c);
                system.debug('oppNumber curOppID '+oppNumber.get(curOppID));
            }

            if(oppFinal.containsKey(curOppID)){
                opp.LX_Ready_for_Finalization__c = oppFinal.get(curOppID);
            }
            
            oppListtoBeUpdated.add(opp);
        }
        
        if(oppListtoBeUpdated.size() > 0){
            try{
            update oppListtoBeUpdated;
            }catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
            }
        }
    }
    

    /*
     * 
     * Description : This method updates the invoice logo and sales organization based on the values on the Accounts.
                    Added logic to update the endDate of the opportunity line items.
     * Param - : Set of opportunity ids whose values need to be updated.
                 Set of opportunity ids whose Line Items needs to be updated.
     * Returns : null
    */
    @future                         
    public static void updateInvoiceLogo(set<id> oppIds, set<id> oppEndDateIDs){

                // Set the isFutureCalled as true
                LX_Opportunity_SoldTo_Case.IsFutureCalled  = true;
                
                //update part for Invoice Logo
                if((oppIds != null)&&(oppIds.size() > 0)){
                // Map to get the Invoice values in a map
                map<string,Invoice_Logo__c> invoiceLogoMap = new map<string,Invoice_Logo__c>();
                set<id> userSet = new set<Id>();
                
                //Query over all the Invoices. The data shouldnt be an issue as we have less than 100 Invoice Logo Records.
                for(Invoice_Logo__c invLogo :[select id,Name from Invoice_Logo__c]){
                    invoiceLogoMap.put(invLogo.Name,invLogo);   
                }
                
                //Get all the oportunity records that need the Invoice Logo and Territory Id to be populated.
                list<Opportunity> OpptoBeUpdated = [select ownerId, id,Invoice_Logo__c,sales_organization__c,sales_organization__r.sales_organization__c,
                                                    LX_Territory_Member__c,LX_Sold_To_New__r.Id               
                                                    from Opportunity 
                                                    where id =:oppIds ];
                
                //add the opportunity owner to the user set.
                for(Opportunity opp:OpptoBeUpdated){
                    userSet.add(opp.ownerId);
                }
                
                //populate the the default territory member for each user.
                /*
                for(LX_Territory_Member__c territoryMember :[select id, Name, LX_Territory_Id__c,LX_User__c 
                                                           FROM  LX_Territory_Member__c
                                                           WHERE LX_User__c = :userSet
                                                           AND LX_DefaultFlag__c = true]){
                          userDefaultTerritoryId.put(territoryMember.LX_User__c,territoryMember.id); 
                           
                }*/
                
                map<id,User>userMap = new map<id,User>([Select id,Legacy_Company__C  from User where id in :userSet]);
                
                for(Opportunity opp:OpptoBeUpdated){

                //Update the invoice logos based on the rules we have set.
                if((invoiceLogoMap.containsKey(userMap.get(opp.ownerid).Legacy_Company__C))&&(userMap.get(opp.ownerid).Legacy_Company__c != 'AccessVia')){
                            opp.Invoice_Logo__c = invoiceLogoMap.get(userMap.get(opp.ownerid).Legacy_Company__c).id;
                    }else if(userMap.get(opp.ownerid).Legacy_Company__C == 'PCSFT' || userMap.get(opp.ownerid).Legacy_Company__C == 'Acuo'){
                        if(invoiceLogoMap.containsKey('Perceptive')){
                            opp.Invoice_Logo__c = invoiceLogoMap.get('Perceptive').id;
                        }
                    }
                    else if(userMap.get(opp.OwnerId).Legacy_Company__c == 'AccessVia' && (opp.sales_organization__c != null) && (opp.sales_organization__r.sales_organization__c == '5097' || opp.sales_organization__r.sales_organization__c  == '5055' ) && invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c) != null ){
                        opp.Invoice_Logo__c = invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c).id;            
                    }else if ((userMap.get(opp.OwnerId).Legacy_Company__c == 'AccessVia') && (opp.sales_organization__c != null)){
                        opp.Invoice_Logo__c = invoiceLogoMap.get('Perceptive').id;          
                    }
                    else if(userMap.get(opp.OwnerId).Legacy_Company__c == 'Saperion' && (opp.sales_organization__c != null) && (opp.sales_organization__r.sales_organization__c == '1058') && invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c) != null ){
                        opp.Invoice_Logo__c = invoiceLogoMap.get(userMap.get(opp.OwnerId).Legacy_Company__c).id;            
                    }else if(userMap.get(opp.OwnerId).Legacy_Company__c == 'Saperion' && (opp.sales_organization__c != null)){
                        opp.Invoice_Logo__c = invoiceLogoMap.get('Perceptive').id;
                    }
                
                    //opp.LX_Territory_Member__c = userDefaultTerritoryId.get(opp.ownerid);
                }
                system.debug('>>>>>OpptoBeUpdated>>>>>>'+OpptoBeUpdated);
                if(!test.isRunningTest()){
                    //LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
                    System.debug('>>>>>>>Future After>>>>>>>>>>>>'+LX_Opportunity_SoldTo_Case.IsFutureCalled);
                    LX_Opportunity_SoldTo_Case.IsFutureCalled = true;  
                    update OpptoBeUpdated;
                }
                }

                // Set the isFutureCalled back to false
                LX_Opportunity_SoldTo_Case.IsFutureCalled  = false;
            }
       
 /*
     * 
     * Description : Methods to 
     * Param - : 
     * Returns : null
    */
    public static String sales_type(string ProductType){
       Map<string,LX_Product_Type_Sales_Type_Mapping__c> allProductSalesMapping = LX_Product_Type_Sales_Type_Mapping__c.getall(); 
       
       system.debug('>>>>>>>>>>>>>>>>'+allProductSalesMapping);
       
       string SalesType;
       
       if(allProductSalesMapping.get(ProductType) != null){
           SalesType = allProductSalesMapping.get(ProductType).LX_Sales_Type__c;
            system.debug('salesType >>>>>>>>>>>>>>>>'+SalesType);
       }else{
           SalesType = '';
       }

       return SalesType ;
       
    }            
    
    /*
     * 
     * Description : updates check box to false / true based on parent and child opps
     * Param - : list of opportunities
     * Returns : null
    */
    public static void updateMPSFunnel(list<Opportunity> lstOpportunities){
         System.debug('$$$lstOpportunities'+lstOpportunities);
        //Variable to hold parent opportunities
        set<Id> setParentOppIds = new set<Id>();
        for(Opportunity objOpp : lstOpportunities)
        {
            if(objOpp.Master_Opportunity__c != null)
                setParentOppIds.add(objOpp.Master_Opportunity__c);
        }
        
        //Get parent opportunities which are having MPS checkbox as false
        //List to store updated parent opportunties
        List<Opportunity> lstParentOpp = new List<Opportunity>();
        if(setParentOppIds.size() > 0 )
        {
        
            for(Opportunity  objParentOPP : [select id,LX_MPS_Inc_Funnel__c from Opportunity where id in: setParentOppIds])
            {
                System.debug('objParentOPP '+objParentOPP );
                objParentOPP.LX_MPS_Inc_Funnel__c = false;
                lstParentOpp.add(objParentOPP);
                
            }
        }
        //Check if parent opp size is greater than zero
        if(lstParentOpp.size() > 0)
            {
            System.debug('lstParentOpp'+lstParentOpp);
            update lstParentOpp;
           }
    }            
    
    /*
     * 
     * Description : updates check box to false / true based on parent and child opps
     * Param - : list of opportunities
     * Returns : null
    */
    public static void updateMPSFunnelOnDelete(list<Opportunity> lstOpportunities){
    
        //Variable to hold parent opportunities
        set<Id> setParentOppIds = new set<Id>();
        for(Opportunity objOpp : lstOpportunities)
        {
            if(objOpp.Master_Opportunity__c != null)
                setParentOppIds.add(objOpp.Master_Opportunity__c);
        }
        system.debug('setParentOppIds == '+setParentOppIds);
        //Get parent opportunities which are having MPS check box as false
        //List to store updated parent opportunities
        List<Opportunity> lstParentOpp = new List<Opportunity>();
        Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>();
        Set<id> setOppToUpdate = new Set<ID>();
        for(Opportunity  objParentOPP : [select id,LX_MPS_Inc_Funnel__c,Master_Opportunity__c from Opportunity where Master_Opportunity__c in: setParentOppIds])
        {
            
            
            if(mapOpp.containsKey(objParentOPP.Master_Opportunity__c))
            {
               setOppToUpdate.remove(objParentOPP.Master_Opportunity__c);
            }
            else
            {
                mapOpp.put(objParentOPP.Master_Opportunity__c,objParentOPP);
                setOppToUpdate.add(objParentOPP.Master_Opportunity__c);
            }
            system.debug('setOppToUpdate =='+setOppToUpdate);
        }
        
        if(setOppToUpdate.size() > 0)
        {
                for(Opportunity  objParentOPP : [select id,LX_MPS_Inc_Funnel__c from Opportunity where id in: setOppToUpdate])
                {
                
                    objParentOPP.LX_MPS_Inc_Funnel__c = true;
                    lstParentOpp.add(objParentOPP);
                
                }
        
        }
        
        //Check if parent opp size is greater than zero
        if(lstParentOpp.size() > 0)
            update lstParentOpp;
       
    }    /*
     * VT 12/11
     * Description : To update the bmi fields on child opp when they get changed on the parent opp
     * Param - : Trigger.Isupdate
     * Param - : Trigger.oldMap
     * Param - : Trigger.isUpdate
     * Param - : Current user details
     * Param - : bypass Logic
     * Returns : null
    */
    public static void BmiUpdate( Map<Id, Opportunity> oppMasterMap1,Map<Id, Opportunity> OldMapOpp){
    Map<Id, Opportunity> oppMasterMap=new  Map<Id, Opportunity>();
    List<Opportunity> opportunityRecList = new List<Opportunity>();          
    oppMasterMap=oppMasterMap1;
    system.debug('##before size'+oppMasterMap.size());
    if(oppMasterMap.size()>0 && BMIflag==false){
        system.debug(oppMasterMap+'###');
    opportunityRecList=[select id,LX_Master_Agreement_Type__c,LX_Master_Quote_Reference__c,LX_Master_Quote_Name__c,LX_Master_Control_Number__c,Master_Opportunity__c,LX_Master_Quote_End_Date__c,LX_Master_Quote_Start_Date__c
                                       from opportunity where Master_Opportunity__c IN :oppMasterMap.keyset()];
    system.debug('###opportunityRecList'+opportunityRecList);                                      
         if(opportunityRecList.size()>0) {      
                  for (Opportunity  oppRec : opportunityRecList){
                                if(oppMasterMap.containsKey(oppRec.Master_Opportunity__c)){
                                    oppRec.LX_Master_Agreement_Type__c = oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Agreement_Type__c;
                                    oppRec.LX_Master_Quote_Reference__c = oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Primary_Quote_Number__c;
                                    oppRec.LX_Master_Quote_Name__c = oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Quote_Name__c;
                                    oppRec.LX_Master_Control_Number__c = oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Quote_Control_Number__c;
                                    if((OldMapOpp.containsKey(oppRec.Master_Opportunity__c) && OldMapOpp.get(oppRec.Master_Opportunity__c).Quote_Status__c!='Approved' && oppMasterMap.get(oppRec.Master_Opportunity__c).Quote_Status__c=='Approved' )||
                                        (OldMapOpp.containsKey(oppRec.Master_Opportunity__c) && oppMasterMap.get(oppRec.Master_Opportunity__c).Quote_Status__c=='Approved' && 
                                        (OldMapOpp.get(oppRec.Master_Opportunity__c).LX_Quote_Start_Date__c!=oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Quote_Start_Date__c ||OldMapOpp.get(oppRec.Master_Opportunity__c).LX_Quote_End_Date__c!=oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Quote_End_Date__c))){
                                        oppRec.LX_Master_Quote_Start_Date__c= oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Quote_Start_Date__c;
                                        oppRec.LX_Master_Quote_End_Date__c= oppMasterMap.get(oppRec.Master_Opportunity__c).LX_Quote_End_Date__c;
                                        }
                                }
                }
               
                    system.debug('####helper');
                     //BMIflag=true;
                    update opportunityRecList;
                     //BMIflag=false;
                
         }
    }
    }
    
     // Code for creating SAP project request: START
    /*
     * Description : Create Sap Project Request record based on Opportunity field values
     * Param - : Opportunity Records which are updating / inserting
     * Returns : null
    */
   public static void CreateSAPProjectRequest(List<Opportunity> lstOpportunities,Map<Id,Opportunity> mapOldOpps){
    
      //Set<String> setOppStages = new Set<String>{'Proposing','Closing','Closed Won','Closed Lost','Closed Dead','Closed Withdraw','Closed Migrated'};
      Set<String> setPartTypes = new Set<String>{'Prof Service - Time','Prof Service - Fixed Fee','PROF SERVICE - EXPENSES','PROF SERVICE - FIXED FEE','PROF SERVICE - TIME'};
      List<SAP_Project_Request__c> lstSapProjectRequest = new List<SAP_Project_Request__c>();
      Set<ID> oppor_id = new Set<ID>();
      Set<ID> user_id = new Set<ID>();
      Map<ID,ID> map_Opp_User = new Map<ID,ID>();
      Map<ID,Boolean> part_types = new Map<ID,Boolean>();
      List<Opportunity> opptobeupdated = new List<Opportunity>();
      
   //  Pull in the Company Code of the opportunity owner.

      set<String> setCompanyCodes = new set<String>();
      for(Opportunity oppt : lstOpportunities)
      {
        if(!(mpCodeToCC.containsKey(oppt.Owner_Company_Code__c))){
            setCompanyCodes.add(oppt.Owner_Company_Code__c); //Creating a set of Company code values
        }
      }
      
      //Check if the setCompanyCodes is greater than zero
      if(setCompanyCodes.size() > 0){
          for(Company_Code__c ccode : [SELECT id,name,Company_Code_Value__c FROM Company_Code__c where Company_Code_Value__c IN :setCompanyCodes]){
             mpCodeToCC.put(ccode.Company_Code_Value__c, ccode); //Creating a map Company code value to Company code records
          }
      }
      
  //  end.
      for(Opportunity opp : lstOpportunities)
      { 
         
            boolean Flag = True;
            
         if(mapOldOpps!=null){
           Opportunity oldOpp = mapOldOpps.get(opp.Id);
           system.debug('********1'+ oldOpp.LX_LineItems_PartType__c);
             if((oldopp.LX_Stage_Number_New__c < 4) || (oldOpp.LX_Change_Request__c != opp.LX_Change_Request__c)  || oldOpp.LX_SAP_Project_Request__c != opp.LX_SAP_Project_Request__c || oldOpp.LX_LineItems_PartType__c>0 )
             Flag = True;
             else
             Flag = False;
             system.debug('*******************************2' +flag);
        }
           
           
         if(opp.MPS__c != true)
           {
             if((opp.LX_Stage_Number_New__c >3) && (opp.LX_Change_Request__c != 'Yes') && ((!opp.LX_SAP_Project_Request__c)) && Opp.LX_LineItems_PartType__c>0 && Flag==True && opp.LX_Sold_To_New__c!=null)
             {
             Opportunity temp_opp = new Opportunity(id= opp.id,LX_SAP_Project_Request__c=true);
             System.debug('*********************3');
                SAP_Project_Request__c objSapProject = new SAP_Project_Request__c();
               // objSapProject.Account_Name__c = opp.Accountid;
                objSapProject.Opportunity__c = opp.id;
                objSapProject.Request_Type__c='B-Type (PS)';
              objSapProject.Sold_To_s__c = opp.LX_Sold_To_New__c;
                //objSapProject.Company_Code__c = users.get(map_Opp_User.get(opp.id)).Company_Number__c;
                //Sunil
                if(mpCodeToCC.get(opp.Owner_Company_Code__c) != null)
                {
                  objSapProject.Company_Code__c = mpCodeToCC.get(opp.Owner_Company_Code__c).id;
                }  
                //Sunil
                lstSapProjectRequest.add(objSapProject);
                opptobeupdated.add(temp_opp);
             }
             }
     /**    else
          
         if((opp.LX_Stage_Number_New__c >3) && (opp.LX_Change_Request__c == 'No') && ((!opp.LX_SAP_Project_Request__c)) && Flag==True && opp.LX_Sold_To_New__c!=null)
             {
             Opportunity temp_opp = new Opportunity(id= opp.id,LX_SAP_Project_Request__c=true);
             System.debug('*********************3');
                SAP_Project_Request__c objSapProject = new SAP_Project_Request__c();
                //objSapProject.Account_Name__c = opp.Accountid;
                objSapProject.Opportunity__c = opp.id;
                objSapProject.Request_Type__c='MPS';
               objSapProject.Sold_To_s__c = opp.LX_Sold_To_New__c;
                //objSapProject.Company_Code__c = users.get(map_Opp_User.get(opp.id)).Company_Number__c;
                //Sunil
                if(mpCodeToCC.get(opp.Owner_Company_Code__c) != null)
                {
                  objSapProject.Company_Code__c = mpCodeToCC.get(opp.Owner_Company_Code__c).id;
                }  
                //Sunil
                lstSapProjectRequest.add(objSapProject);
                opptobeupdated.add(temp_opp);
                
           }**/
           //Commented MPS
             
         }
       
      
    
      //insert sap project records here
      if(lstSapProjectRequest.size()>0)
      insert lstSapProjectRequest;  
     
     if(opptobeupdated.size()>0)
     update opptobeupdated;
    }
 
 
    public static void updateOppLineItemsDates(set<id> oppEndDateIDs){
                        if((oppEndDateIDs != null) && (oppEndDateIDs.size() >  0)){
                   
                   Date mydate = Date.today();
                   
                   List<OpportunityLineItem> OppLineItemList = new List<OpportunityLineItem>([select id
                                                                                , start_Date__c
                                                                                , end_date__c
                                                                                , opportunityId
                                                                                , opportunity.Begin_Date__c
                                                                                , opportunity.End_Date__c
                                                                                , opportunity.Contract_End_Date__c
                                                                                , opportunity.QALevel2Approved__c
                                                                                from OpportunityLineItem
                                                                                where Product_Family__c = :System.Label.LX_Opp_Prod 
                                                                                and opportunityID in :oppEndDateIDs]);
                  
                    if(OppLineItemList.size()>0)
                    {
                      System.debug('>>>>>>Inside Opp Line Item List >>>>>');
                        //loop through OppLineItemList to set the start and end dates based on the information on the opportunity
                        for(OpportunityLineItem oppLineItemrec : OppLineItemList){
                            //oppLineItemRec.Contract_End_Date__c       = oppLineItemrec.opportunity.Contract_End_Date__c;
                            oppLineItemRec.Start_Date__c    = oppLineItemrec.opportunity.Begin_Date__c;
                            oppLineItemRec.end_date__c  = oppLineItemrec.opportunity.end_date__c;
                            System.debug('>>>>>>oppLineItemRec.Start_Date__c>>>>>>>>'+oppLineItemRec.Start_Date__c);
                            System.debug('>>>>>>oppLineItemRec.end_date__c >>>>>>>>'+oppLineItemRec.end_date__c);
                            //if (oppLineItemrec.opportunity.QALevel2Approved__c == True){
                            //}
                        } 
                        try{
                            update OppLineItemList;
                            System.debug('>>>>Updated>>>>');
                        }catch (exception ex){
                            LX_CommonUtilities.createExceptionLog(ex);
                        }
                    }                                                                               
 
                }
    }   
    
  
 // Code for creating SAP project request: END  
  // Code for creating SAP project request: END  
   /*
   *method called from Opp Bi BU to update wbs billing element
   */  
  public static void PopulateBillingWBSElement(Map<Id,Opportunity> oppMap){
    System.debug('>>>>>>>>>>>>>oppMap'+oppMap);
    Boolean needtoRunQuery = FALSE ;
      for(Opportunity opp : oppMap.values()){
          if(opp.QAStatus__c != null && opp.QAStatus__c != '' && opp.QAStatus__c.toLowerCase() == 'complete'){//&& opp.LX_Finalize__c == true){ 
             needtoRunQuery = TRUE;
             System.debug('>>>>>>>>>>>>opp'+opp);
             break;
          }
      }
      if(needtoRunQuery){
      System.debug('>>>>>>Print trigger.newMap'+oppMap);
          List<opportunity> OpptoUpdateList = new List<Opportunity>();
          Map<ID,ID> mpWBS = new Map<ID,ID>();
          for(WBS_Element_Project__c proj : [SELECT id,Name,Opportunity__c,WBS_Element__c,WBS_Element__r.WBS_Type__c
                                              FROM WBS_Element_Project__c 
                                              WHERE WBS_Element__r.WBS_Type__c=:WBSType 
                                              AND Opportunity__c IN :oppMap.keyset()
                                              AND WBS_Element__r.Active__c = true]){
             mpWBS.put(proj.Opportunity__c,proj.WBS_Element__c);
             system.debug('###### map is ' + mpWBS);
             system.debug('@@@@ oppMap' + oppMap);
          }
          for(Opportunity opp:oppMap.values()){
             system.debug('opp ==='+opp);
             if(mpWBS.containskey(opp.id)&& opp.QAStatus__c != null && opp.QAStatus__c != '' && opp.QAStatus__c.toLowerCase() == 'complete' && opp.Billing_WBS_Element__c == null){//&& opp.LX_Finalize__c == true){ 
               opp.Billing_WBS_Element__c=mpWBS.get(opp.ID);
               WBSPopulated = true;
               system.debug('@@@@@@@ ' +  opp.Billing_WBS_Element__c);
            }
          }
      }    
     } 
    
    @future
      public static void updateAccountFLags(Set<ID> oppSet)
    {
        system.debug('------------In updateAccountFLags Future------------------');
        List<OpportunityLineItem> otmList = new List<OpportunityLineItem>();
        Map<ID,List<OpportunityLineItem>> otmmap = new Map<ID,List<OpportunityLineItem>>();
        Map<ID,Account> acmap = new Map<ID,Account>();
        otmList = [Select ID,Product_Family__c,OpportunityID,Opportunity.AccountID from OpportunityLineItem where OpportunityID in: oppSet];
        
        if(!otmList.isEmpty())
        {
        for(OpportunityLineItem ol : otmList)
        {
            Account Ac = new Account();
            boolean isUpdate = False;
            if(acmap.containsKey(ol.Opportunity.AccountID))
            {                
            Ac = acmap.get(ol.Opportunity.AccountID);
            }
            else
            {
                Ac.Id = ol.Opportunity.AccountID;
            }           
            
            
            if(ol.Product_Family__c == 'SaaS Subscription as a service')
            {
                Ac.Subscription__c = True;
                Ac.Platform_Services__c = True;  
                isUpdate = True;
            }            
            
            if(ol.Product_Family__c == 'Subscription')
            {
                Ac.Subscription__c = True;  
                isUpdate = True;
            }
            
            if(ol.Product_Family__c == 'Hosted Service')
            {                
                Ac.Platform_Services__c = True;
                isUpdate = True;                
            }
            
            if(ol.Product_Family__c == 'Remote Admin Service')
            {
                Ac.Remote_Administration__c = True; 
                isUpdate = True;
            }
            
            if(isUpdate)
            {
            acmap.put(ol.Opportunity.AccountID,Ac);            
            }
        }            
        }
        
        List<Account> updList = acmap.values();
        if(!updList.isEmpty())
        {
            system.debug('$$$$$$$' +updList);
        try
        {
        Update updList;
        }
        catch(Exception ex)
        {
        LX_CommonUtilities.createExceptionLog(ex);
        }
        }
    }


    public static void updateOpportunityPriceBook(list<Opportunity> oppListFromTrigger)
    {
    //  List < Opportunity > oppList = [SELECT Id, LX_Pricebook_Offer__c, LX_Pricebook_Selected__c FROM Opportunity WHERE Id IN: Trigger.newMap.keySet()];
        List < Opportunity > oppList = oppListFromTrigger;
            List < Opportunity > oppToUpdate = new List<Opportunity>{};

            for (Opportunity opp: oppList)
            {
                if (opp.LX_Pricebook_Offer__c != null || opp.LX_Pricebook_Offer__c != '')
                {
                    String offerEnrollmentId = opp.LX_Pricebook_Offer__c;
                    System.debug('****************offerEnrollmentId*************' + offerEnrollmentId);
                    LX_Offer_Enrollment__c offerEnrollment = [SELECT Id, Name, Offer__c FROM LX_Offer_Enrollment__c where id = : offerEnrollmentId LIMIT 1];
                    if (offerEnrollment != null) 
                    {
                        string offerId = offerEnrollment.Offer__c;
                        System.debug('****************offerId*************' + offerId);
                        LX_Offer__c offer = [SELECT Id, Name FROM LX_Offer__c where id = : offerId];
                        opp.LX_Pricebook_Selected__c = offer.Name;
                        System.debug('****************oldOpp.LX_Pricebook_Selected__c*************' + opp.LX_Pricebook_Selected__c);                    
                         oppToUpdate.add(opp);
                    }
                }
            }
                     if (oppToUpdate.size() > 0) {  
                        try {
                        //  upsert oppToUpdate;
                             Database.update(oppToUpdate);
                        } catch (exception ex) {
                            LX_CommonUtilities.createExceptionLog(ex); //Exception log ,Kapil Reddy Sama 6/6/13      
                        }
                    }
            
    }
    
     /*
     * Description : Function to return the Map of opporutnity ids and an integer which indicates the corresponding products types. 
     * Param - : Trigger.New
     * Returns : Map<ID,integer>
    */
    public static Map<ID,integer> getOpportunityProducts(list<Opportunity> oppList){
        List<ID> oppIDs = new List<ID>();
        MAP<ID,integer> mapOppProducts = new MAp<ID,integer>();
        for(Opportunity oppRec: oppList)
            oppIDs.add(oppRec.id);
        for(opportunitylineItem lineitems : [Select id, PricebookEntry.product2.Originating_Company__c,OpportunityID from opportunitylineItem where OpportunityID in :oppIDs])
        {
            if(mapOppProducts.containskey(lineitems.OpportunityID))
            {
                if(mapOppProducts.get(lineitems.OpportunityID) == 0 && lineitems.PricebookEntry.product2.Originating_Company__c !='PACSGEAR')
                    mapOppProducts.put(lineitems.OpportunityID,1);
                if(mapOppProducts.get(lineitems.OpportunityID) == 2 && lineitems.PricebookEntry.product2.Originating_Company__c =='PACSGEAR')
                    mapOppProducts.put(lineitems.OpportunityID,1);
            }
            else
            {
                if(lineitems.PricebookEntry.product2.Originating_Company__c == 'PACSGEAR')
                    mapOppProducts.put(lineitems.OpportunityID,0);
                else
                    mapOppProducts.put(lineitems.OpportunityID,2);
            }
        }
        return mapOppProducts;
        // returns 0 for PACSGEAR products
        // returns 1 for mixed PACGEAR products
        // returns 2 for non- PACSGEAR products.
    }
    
}