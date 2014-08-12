/*****************************************************************************************************************
*Class Name : LX_Opportunity_SoldTo_Case
*Description : Calss to submit a case for the creation of the Sold to or Ship to or a Bill to on the opportunity
*Created By : Arun Singh (asingh6@deloitte.com)
*Created Date : 10-6-2013
*Modification Log:
*-----------------------------------------------------------------------------------------------------------------
*Developer                Date            Modification ID        Description
*-----------------------------------------------------------------------------------------------------------------
*Arun Singh              10-6-2013        1000                   Initial Version
*Sumedha Kucherlapati    12-20-2013       1001                   Added logic to create 
*                                                                case for sold tos with 
*                                                                Payment terms = "ZCWO"
*Sumedha Kucherlapati    01-20-2014       1002                   Added logic to include case creation logic
*                                                                based on primary partner account 
* Sanjay Chaudhary       04/15/2014                              Updated as per Case # 00776497 such that Contact is defaulted to Opportunity Owner's Contact 
*                                                                and case if related to Opportunity. 
******************************************************************************************************************/

public class LX_Opportunity_SoldTo_Case
 {
Public Static Boolean IsFutureCalled =false;
Public Static Boolean IsFutureCalled1 =false;

/*
 * 
 * Description : This method creates a case with all the required information required for the case.
 * Param - : list<Opportunity> list of opportnites for which the sold to request had to be created.
 * Returns : null
 */
 public void CreateOpportunitiesSoldToCaseNewRequest(List<Opportunity> Opportunities)
 {
 System.debug('=======================CreateOpportunitiesSoldToCaseNewRequest=================================================');
 
 
 List<case> Listcase=new List<case>();
 
 //Fetching the assignment rules on case
AssignmentRule AR = new AssignmentRule();
AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
//Creating the DMLOptions for "Assign using active assignment rules" checkbox
Database.DMLOptions dmlOpts = new Database.DMLOptions();
dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;

 for(Opportunity TempOpportunity:Opportunities)
 {
 
    Map <String,String> OppIdOwnerIdMap = new Map <String,String>();
    Map <String,String> OppOwnerIdContactIdMap = new Map <String,String>();
    OppIdOwnerIdMap.put(TempOpportunity.Id,TempOpportunity.OwnerId);
    for (Contact con:[Select id,pse__Salesforce_User__c from Contact where pse__Salesforce_User__c in: OppIdOwnerIdMap.values()])
        OppOwnerIdContactIdMap.put(con.pse__Salesforce_User__c,con.Id);

 System.debug('==CASE:'+TempOpportunity); 
    Case tempCase = new case();
    if (OppOwnerIdContactIdMap.get(OppIdOwnerIdMap.get(TempOpportunity.Id))!= null)
    tempCase.contactId = OppOwnerIdContactIdMap.get(OppIdOwnerIdMap.get(TempOpportunity.Id));
    tempCase.LX_Opportunity__c = TempOpportunity.Id;
    
    tempCase.recordtypeId = LX_SetRecordIDs.CaseBillToShipToSoldToRecordTypeId;
     if(TempOpportunity.Primary_Partner__c != NULL){
        tempCase.Internal_Case_Account__c = TempOpportunity.Primary_Partner__c ;
    }else{
        tempCase.Internal_Case_Account__c = TempOpportunity.AccountId;
    }
    tempCase.Origin = 'Cases';
    tempCase.Type = 'Request';
    tempCase.subject = 'Create Sold To request for Opportunity :'+TempOpportunity.Name;
    
    String Body='<h3>Create Sold To:</h3><table width=600 border=1><tr><th width=200>Opportunity</th><td><a href=/'+TempOpportunity.Id+' >';
    Body+=TempOpportunity.Name+'</a></td></tr>';
    Body+='<tr><th>Currency</th><td>'+TempOpportunity.CurrencyIsoCode+'</td></tr><tr><th>Sales Organization</th><td>'+TempOpportunity.Sales_Organization_value__c+'</td>';
    Body+='</tr><tr><th>Payment Terms</th><td></td></tr><tr><th>Requestor</th><td><a href=/'+UserInfo.GetUserId()+' >';
    Body+=UserInfo.getFirstName()+'  '+UserInfo.getLastName()+'</a></td></tr><tr><th>Salesperson Notes</th><td></td></tr></table>';
    tempCase.LX_Change_Request__c=Body;

//Setting the DMLOption on Case instance
    tempCase.setOptions(dmlOpts);
    Listcase.Add(tempCase);
 
 }
 
  insert Listcase ;
 
 }
 public void CreateOpportunitiesSoldToCaseExtendedRequest(List<Opportunity> Opportunities)
 {
 System.debug('=======================CreateOpportunitiesSoldToCaseExtendedRequest=================================================');
 
 List<case> Listcase=new List<case>();
 //Fetching the assignment rules on case
AssignmentRule AR = new AssignmentRule();
AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
//Creating the DMLOptions for "Assign using active assignment rules" checkbox
Database.DMLOptions dmlOpts = new Database.DMLOptions();
dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;



 for(Opportunity TempOpportunity:Opportunities)
 {
 System.debug('==TempOpportunity=TempOpportunity'+Opportunities);

    Map <String,String> OppIdOwnerIdMap = new Map <String,String>();
    Map <String,String> OppOwnerIdContactIdMap = new Map <String,String>();  
    OppIdOwnerIdMap.put(TempOpportunity.Id,TempOpportunity.OwnerId);
    for (Contact con:[Select id,pse__Salesforce_User__c from Contact where pse__Salesforce_User__c in: OppIdOwnerIdMap.values()])
        OppOwnerIdContactIdMap.put(con.pse__Salesforce_User__c,con.Id);
 
  
    Case tempCase = new case();
    if (OppOwnerIdContactIdMap.get(OppIdOwnerIdMap.get(TempOpportunity.Id))!= null)
    tempCase.contactId = OppOwnerIdContactIdMap.get(OppIdOwnerIdMap.get(TempOpportunity.Id));
    tempCase.LX_Opportunity__c = TempOpportunity.Id;
        
    tempCase.recordtypeId = LX_SetRecordIDs.CaseBillToShipToSoldToRecordTypeId;
     if(TempOpportunity.Primary_Partner__c != NULL){
        tempCase.Internal_Case_Account__c = TempOpportunity.Primary_Partner__c ;
    }else{
        tempCase.Internal_Case_Account__c = TempOpportunity.AccountId;
    }
    tempCase.Origin = 'Cases';
    tempCase.Type = 'Request';
    tempCase.subject = 'Extended Sold To request for Opportunity :'+TempOpportunity.Name;
    String Body='<h3>Extended Sold To:</h3><table width=600 border=1><tr><th width=200>Opportunity</th><td><a href=/'+TempOpportunity.Id+' >';
    Body+=TempOpportunity.Name+'</a></td></tr>';
    Body+='<tr><th>Currency</th><td>'+TempOpportunity.CurrencyIsoCode+'</td></tr><tr><th>Sales Organization</th><td>'+TempOpportunity.Sales_Organization_value__c+'</td>';
    Body+='</tr><tr><th>Payment Terms</th><td></td></tr><tr><th>Requestor</th><td><a href=/'+UserInfo.GetUserId()+' >';
    Body+=UserInfo.getFirstName()+' '+UserInfo.getLastName()+'</a></td></tr><tr><th>Salesperson Notes</th><td></td></tr></table>';
    tempCase.LX_Change_Request__c=Body;
    
    //Setting the DMLOption on Case instance
    tempCase.setOptions(dmlOpts);
    Listcase.Add(tempCase);
   
 
 }
 
insert Listcase ;

 
 }
 
   public void CreateOpportunitiesSoldToCaseRequesttoCEBU(List<Opportunity> Opportunities){
      string MDMportalQueue  =  label.LX_HelpDesk_MDM_Portal_Queue;
      List<Case>   csList = new List<Case>();
      set <id> OppidSet=new set<id>();
      map<id,string> OppSoldToMap=new map<id,string>();//map for storing opp id and LX_Sold_To_New__r.LX_SAP_Sold_To_ID__c 
      //////VT adding logic to populate on SAP Record Sales Org LX_SAP_Sold_To_ID__c, need to query opps to get the field from the lookup LX_Sold_To_New__r.LX_SAP_Sold_To_ID__c
      for(Opportunity TempOpportunity:Opportunities){
        OppidSet.add(TempOpportunity.id);
      }
      if(OppidSet.size()>0){
        list<Opportunity> OppList=[Select id,LX_Sold_To_New__c,LX_Sold_To_New__r.LX_SAP_Sold_To_ID__c
                                                        from Opportunity where id IN :OppidSet ];
         system.debug('##OppList'+OppList);    
                                                              
        if(OppList.size()>0){
        for(Opportunity TempOpportunity:OppList){
            system.debug('##OppList1'+TempOpportunity.LX_Sold_To_New__c); 
               system.debug('##OppList2'+TempOpportunity.LX_Sold_To_New__r.LX_SAP_Sold_To_ID__c);
            OppSoldToMap.put(TempOpportunity.id,TempOpportunity.LX_Sold_To_New__r.LX_SAP_Sold_To_ID__c );
            }
        }
      }
      

      ///////
      for(Opportunity TempOpportunity:Opportunities)
      {

        Map <String,String> OppIdOwnerIdMap = new Map <String,String>();
        Map <String,String> OppOwnerIdContactIdMap = new Map <String,String>();      
        OppIdOwnerIdMap.put(TempOpportunity.Id,TempOpportunity.OwnerId);
        for (Contact con:[Select id,pse__Salesforce_User__c from Contact where pse__Salesforce_User__c in: OppIdOwnerIdMap.values()])
            OppOwnerIdContactIdMap.put(con.pse__Salesforce_User__c,con.Id);
      
         System.debug('******TempOpportunity*****TempOpportunity'+Opportunities);
         Case csZCWO = new Case();
          if (OppOwnerIdContactIdMap.get(OppIdOwnerIdMap.get(TempOpportunity.Id))!= null)
          csZCWO.contactId = OppOwnerIdContactIdMap.get(OppIdOwnerIdMap.get(TempOpportunity.Id));
          csZCWO.LX_Opportunity__c = TempOpportunity.Id;
              
         csZCWO.recordtypeId = LX_SetRecordIDs.CaseBillToShipToSoldToRecordTypeId;
         csZCWO.Internal_Case_Account__c = TempOpportunity.AccountId;
         csZCWO.Origin = 'Cases';
         csZCWO.Type = 'Request';
         csZCWO.subject = 'Establish Payment terms on related Sold to for Opportunity :'+TempOpportunity.Name;
         String Body='<h3>Establish Payment terms on:</h3><table width=600 border=1><tr><th width=200>Sold to</th><td><a href=/'+TempOpportunity.LX_Sold_To_New__c+' >';
         Body+=TempOpportunity.LX_Sold_To_New__c+'</a></td></tr>';
         Body+='<tr><th>SAP Record</th><td>'+TempOpportunity.LX_Sold_To_SAP_Record__c+'</td></tr>';
         if(OppSoldToMap.containsKey(TempOpportunity.id)){
            Body+='<tr><th>Sold To ID </th><td>'+OppSoldToMap.get(TempOpportunity.id)+'</td></tr>';
         }
         Body+='<tr><th>Currency</th><td>'+TempOpportunity.CurrencyIsoCode+'</td></tr><tr><th>Sales Organization</th><td>'+TempOpportunity.Sales_Organization_value__c+'</td>';
         Body+='</tr><tr><th>Payment Terms</th><td>'+TempOpportunity.LX_Sold_To_Payment_Terms__c+'</td></tr><tr><th>Requestor</th><td><a href=/'+UserInfo.GetUserId()+' >';
         Body+=UserInfo.getFirstName()+' '+UserInfo.getLastName()+'</a></td></tr><tr><th>Salesperson Notes</th><td></td></tr></table>';
         csZCWO.LX_Change_Request__c=Body;
         //VT replacing with  a label csZCWO.OwnerID = '00Gi0000000ZEvp';
         csZCWO.OwnerID =MDMportalQueue  ;
         //csZCWO.OwnerID = '005i0000000ZKWM';
         csList.add(csZCWO);
      }
      try{
        insert csList;
      }catch(Exception ex){
        System.debug('********Cannot insert ZCWO case request'+ex.getMessage());
      }
  }
 
 }