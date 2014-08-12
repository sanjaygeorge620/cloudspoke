/*
Class Name : LX_CaseTriggger_util
Description : Utility Class for LX_Case_AI_AU_BI_BU Trigger.
Created By : Sanjay George
Created Date : 12-12-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Sanjay George    12-12-2013        1000                 Initial Version
*************************************************************************/
public class LX_CaseTriggger_util{

private final static string KeyUserQueue_AP = 'Key_user_AP';
private final static string KeyUserQueue_EMEA = 'Key_user_EMEA';
private final static string KeyUserQueue_LA = 'key_user_LA';
private final static string KeyUserQueue_NA = 'Key_User_NA';
private final static string Geo_AP = 'Asia Pacific';
private final static string Geo_EMEA = 'EMEA';
private final static string Geo_LA ='Latin America';
private final static string Geo_NA ='North America';
private final static map<integer,String> MapIntMonth = new map<integer,String>{1=>'January',2=>'February',
                                                                                3=>'March',4=> 'April',
                                                                                5=>'May',6=>'June',
                                                                                7=>'July', 8=>'August',
                                                                                9=>'September',10=>'October',
                                                                                11=>'November',12=>'December'};
public final static map<string,string> MapOpptoCasePaymentTerm =  new map<string,string>{'ZN30'=>'Net 30 Days','ZN45'=>'Net 45 Days',
                                                                                          'ZCWO'=>'Cash With Order'}   ;                                                                            
public static Boolean isFuture = false;


// private static List<Group> GroupList =[SELECT DeveloperName,Name,Type FROM Group where Type='Queue' and developerName like 'K%'];
    //private static map<string,string> MapGeoQueueId = new map<string,string>();
/*
Function: submitforApproval
Params: cid--> Case Record ID; approverid --> User who approves the record
return: Boolean. True is successful
*/
    public static boolean submitforApproval(id cid, id approverid){
        // Creating a approval process request
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically for Account Change Request ');
        req1.setObjectId(cid);
        //req1.setNextApproverIds(new Id[] {approverid});
        try{
            // Submit the request
            Approval.ProcessResult result = Approval.process(req1);
            return result.issuccess();
        }
        catch(Exception e){
           throw e;
            return false;
        }
        
        
    
    }

   
  /*
Function: GetKeyuserQueue
Params: Geo--> Geo of the User
return: id, returns the queue ID
*/  
/* Commented by Shubhashish Rai - Requirement changed to check based on Account's Physical Country
    public static id GetKeyuserQueue(string Geo){
        map<string,string> MapGeoQueueId = new map<string,string>();
        id idval;
        
        for(Group grp:GroupList  ){
            if(grp.DeveloperName==KeyUserQueue_AP){
                MapGeoQueueId.put(Geo_AP, grp.id);
            }
            else if(grp.DeveloperName==KeyUserQueue_EMEA){
                MapGeoQueueId.put(Geo_EMEA , grp.id);
            }
            else if(grp.DeveloperName==KeyUserQueue_LA){
                MapGeoQueueId.put(Geo_LA, grp.id);
            }
            else if(grp.DeveloperName==KeyUserQueue_NA){
                MapGeoQueueId.put(Geo_NA , grp.id);
            }
        }
        system.debug('Mapsss-->'+MapGeoQueueId);
        if(Geo=='Asia Pacific'&&MapGeoQueueId.containskey(Geo_AP)){
            idval=MapGeoQueueId.get(Geo);
        }
        else if(Geo=='EMEA'&&MapGeoQueueId.containskey(Geo_EMEA )){
            idval=MapGeoQueueId.get(Geo);
        }
        else if(Geo=='Latin America'&&MapGeoQueueId.containskey(Geo_LA)){
            idval=MapGeoQueueId.get(Geo);
        }
        else if(Geo=='North America'&&MapGeoQueueId.containskey(Geo_NA )){
            idval=MapGeoQueueId.get(Geo);
        }
        else
            return null;
        
        return idval;
    }
*/
public static id GetKeyuserQueue(string Country){
        System.debug('>>>>>>Country>>>>>>>'+Country);
        map<string,string> MapCountryQueueId = new map<string,string>();
        id idval;
        
        String QueueName = (LX_Country_Queue__c.getAll().get(Country)!=null?LX_Country_Queue__c.getAll().get(Country).LX_Queue_Name__c:'');
    
        System.debug('>>>>>>QueueName>>>>>>>'+QueueName);
       
        List<Group> GroupList =[SELECT id,DeveloperName,Name,Type FROM Group where Type='Queue' and developerName=:QueueName];    

        System.debug('>>>>>>GroupList>>>>>>>'+GroupList);
       
        if(GroupList.size()>0){
            idval = GroupList[0].id;
            return idval;
        }
        else
            return null;
    }
       
        @future
        public static void updateOwnership(List<Id> caseIDs) { 
            LX_CaseTriggger_util.isFuture = true;
        System.debug('>>>>>>>>updateOwnership>>>>>>>>>');
        Database.DMLOptions dmo = new Database.DMLOptions(); 
        dmo.EmailHeader.triggerUserEmail = true; 

        List<Case> casesToUpdate = [select ownerid,LX_Account_Country__c from case where id in :caseIDs]; 
        List<Case> updateCaseList = new List<Case>();
        System.debug('>>>>>>>>>casesToUpdate>>>>>'+casesToUpdate);
        for(Case c : casesToUpdate) { 
            c.OwnerId = LX_CaseTriggger_util.GetKeyuserQueue(c.LX_Account_Country__c);
            System.debug('>>>>>>>>>c.OwnerId>>>>>'+c.OwnerId);
            c.setOptions(dmo);
            updateCaseList.add(c);
        } 

        //Database.update(casesToUpdate, dmo); // Actual DML operation is performed instead of implicit update
        if(updateCaseList.size()>0){
            System.debug('>>>>>>>>>updateCaseList>>>>>'+updateCaseList);
            update updateCaseList;    
         }
         
        }
         public static void  LX_CaseFieldPopulation(List<case> Triggernew, List<case> TriggerOld){
            set<id> Accountset = new set<id>  ();
            set<id> OpportunitySet = new set<id> ();
            string paymentterm1 ;
            String caseSalesOrganization;
            for(cASE cs: TriggerNew){
                if(cs.AccountID!=null)
                    Accountset.add(cs.AccountID);
                if(cs.LX_Opportunity__c!=null)
                    OpportunitySet.add(cs.LX_Opportunity__c);
            }
            Map<id,Opportunity> MapIdOpp = new Map<id,Opportunity>([Select Sales_Organization__c,LX_supplies_revenue__c,Payment_Terms__c,Payment_Terms__r.SAP_Code__c,LX_options_revenue__c,LX_printers_revenue__c,LX_TCV__c,LX_Term__c,Amount,MPS_Deal_Type__c,id,CloseDate from Opportunity where id in:OpportunitySet ]);
            Map<id,Account> MapIdAcc = new Map<id,Account>([Select id,name,Physical_Country__c,Party_Role__c,Party_Type__c,Phone,LX_Owner_Email__c,LX_Country_Code__c from Account where id in :Accountset]);
            for(Case cs: Triggernew){
            if(cs.Recordtypeid==LX_SetRecordIDs.CaseLeadConversionRecordTypeId){
                paymentterm1 ='';
                caseSalesOrganization = '';
                    //cs.LX_Account_Address__c = 
                    if(cs.LX_Valid_Duplicate_Flag__c == true){
                        cs.LX_Re_send_To_MDM__c=true;
                    }
                    if(MapIdAcc.containskey(cs.AccountID)&&MapIdAcc.get(cs.AccountID).LX_Country_Code__c !=null){
                        cs.LX_Sold_To_Transportation_Zone__c = MapIdAcc.get(cs.AccountID).LX_Country_Code__c;
                    }
                    cs.SuppliedCompany= MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).Name:null;
                    cs.LX_Country__c = MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).Physical_Country__c:null;
                    cs.SuppliedEmail= MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).LX_Owner_Email__c : null;
                    cs.SuppliedPhone =MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).Phone:null;
                    cs.LX_D_U_N_S_Number__c = MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).LX_Owner_Email__c:null;
                   // cs.LX_Type_of_Business__c= 
                    
                    cs.LX_Party_Role__c=MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).Party_Role__c:null;
                    cs.LX_Party_type__c=MapIdAcc.get(cs.AccountID)!=null?MapIdAcc.get(cs.AccountID).Party_Type__c:null;
                    if(cs.LX_Payment_Terms__c!=null&&cs.LX_Payment_Terms__c=='Cash With Order'){
                        cs.LX_Credit_Check_Required__c ='Vistex';
                    }
                    else if(cs.LX_Payment_Terms__c!=null){
                        cs.LX_Credit_Check_Required__c ='Non-Vistex';
                    }
                    //cs.LX_Payment_Terms_Lead__c
                    if(cs.LX_Opportunity__c!=null){
                         paymentterm1 = MapIdOpp.get(cs.LX_Opportunity__c)!=null?MapIdOpp.get(cs.LX_Opportunity__c).Payment_Terms__r.SAP_Code__c:null;
                        system.debug('paymentterm1 -->'+paymentterm1 );
                        if((paymentterm1 !=null||paymentterm1 !='')){
                            if(cs.LX_Payment_Terms__c==null)
                            cs.LX_Payment_Terms__c= MapOpptoCasePaymentTerm.get(paymentterm1);
                            /*else{
                                if(cs.LX_Payment_Terms__c!=MapOpptoCasePaymentTerm.get(paymentterm1)&&cs.origin=='Opportunity'){
                                    system.debug('LX_Payment_Terms__c--->'+cs.LX_Payment_Terms__c+'****'+MapOpptoCasePaymentTerm.get(paymentterm1));
                                    cs.LX_Payment_Terms__c.adderror('Payment term cannot be modified.');
                                }
                            }*/
                        }
                        
                        caseSalesOrganization = MapIdOpp.get(cs.LX_Opportunity__c)!=null?MapIdOpp.get(cs.LX_Opportunity__c).Sales_Organization__c:null;
                        system.debug('paymentterm1 -->'+paymentterm1 );
                        if((caseSalesOrganization !=null||caseSalesOrganization !='')){
                            if(cs.LX_Sales_Organization_Country__c==null)
                            cs.LX_Sales_Organization_Country__c= caseSalesOrganization;
                            else{
                                if(cs.LX_Sales_Organization_Country__c!=caseSalesOrganization && cs.origin=='Opportunity'){
                                    system.debug('LX_Sales_Organization_Country__c---->'+cs.LX_Sales_Organization_Country__c+'****'+caseSalesOrganization);
                                    cs.LX_Sales_Organization_Country__c.adderror('Sales Organization cannot be modified.');
                                }
                            }
                        }
                    
                    
                    cs.LX_Total_Opportunity_Cost__c = MapIdOpp.get(cs.LX_Opportunity__c).Amount;
                    cs.LX_Highest_Month_Revenue__c = MapIdOpp.get(cs.LX_Opportunity__c).CloseDate!=null?GetMonthfromInteger(MapIdOpp.get(cs.LX_Opportunity__c).CloseDate.month()):'';
                    cs.LX_MPS_deal_Type__c = MapIdOpp.get(cs.LX_Opportunity__c).MPS_Deal_Type__c;
                   // cs.LX_Opportunity_Existing_Devices_Leased__c = 
                    cs.LX_Opportunity_TCV__C = MapIdOpp.get(cs.LX_Opportunity__c).LX_TCV__c;
                    cs.LX_Term__C = MapIdOpp.get(cs.LX_Opportunity__c).LX_Term__c;
                    cs.LX_Printer__C = MapIdOpp.get(cs.LX_Opportunity__c).LX_printers_revenue__c;
                    cs.LX_Options__c = MapIdOpp.get(cs.LX_Opportunity__c).LX_options_revenue__c;
                    cs.LX_Supplies__c = MapIdOpp.get(cs.LX_Opportunity__c).LX_supplies_revenue__c;
                    
                    }
                    
                    // Logic for Requested Date
                    if(Trigger.isInsert){
                        if(cs.origin=='Lead')
                            if(cs.LX_Sold_To_Number_Request_Status__c=='Submitted to MDM')
                                cs.LX_Requested_By_date__c = System.Today().addDays(3);
                            else
                                cs.LX_Requested_By_date__c = System.Today().addDays(5);
                        else if (cs.origin=='Account')
                            cs.LX_Requested_By_date__c = System.today().addDays(5);
                        else if(cs.origin=='Opportunity'&& cs.LX_Opportunity__c!=null){
                            if(MapIdOpp.get(cs.LX_Opportunity__c).closedate!=null && System.today().daysBetween(MapIdOpp.get(cs.LX_Opportunity__c).closedate)<5)
                                cs.LX_Requested_By_date__c =MapIdOpp.get(cs.LX_Opportunity__c).closedate;
                            else
                                cs.LX_Requested_By_date__c = System.today().addDays(5);
                        }
                    }
                    
                    
                }

            
            }
        // 
        //cs.Suppliedphone = null;
        }  
        
        /*
        Function to return the String value for a given month in Integer
        
        */
        
        public static string GetMonthfromInteger(integer mon){
            if(mon<=12&&mon>0)
                return MapIntMonth.get(mon);
            else Return null;
        }
        
}