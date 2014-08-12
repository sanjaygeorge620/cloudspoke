public with sharing class RequestTokens_Case {

  
  public Integer requstedTokens {get;set;}
  public String oppName {get;set;}
  public String accName {get;set;}
  public String conName {get;set;}
  public Case objCA {get;set;}
  private Account account;
  String firstTimeThrough = 'Yes';
  List<ID> contactIDList = new List<ID>();  
  Perceptive_Config_Value__c configValue;
  //ApexPages.StandardController standardController;
  
  public RequestTokens_Case(ApexPages.StandardController CaController){ 
    //standardController = taController;
    Id currentId = ((Case)caController.getRecord()).id;         //gets current page id
    
    try{
        for(Case ca : [select id, AccountId,Account.Sector__c, Account.ISR__c, Contact.Name, RecordType.Name, Account.Name, Account.OwnerId from Case where id = :currentId limit 1 ]){
            objCA = ca;
            accName = objCA.Account.Name != null ? objCA.Account.Name : '' ; 
            conName = objCA.Contact.Name != null ? objCA.Contact.Name : '' ;
system.debug('objCA:' + objCA);
        
            configValue = [select id, value__c from Perceptive_Config_Value__c where Name = :objCa.recordtype.name + ' Opportunity Name'];
system.debug('configValue:' + configValue);
            oppName =  'Tokens - ' + configValue.Value__c;
            }
    }
    catch(Exception ex){
        System.debug ('Exception occured :--> ' + ex);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
    }
  }
  
  public PageReference requestTokens(){     
    RecordType recType;
    pageReference pageRef ;
   // for(RecordType  rt : [Select Id from RecordType where name='Additional Services' limit 1]){
   //     recType = rt;
   // }
    Opportunity opp = new Opportunity();
    OpportunityLineItem oppLI;
    opp.name= oppName;
    opp.CloseDate = date.today(); 
    opp.Amount = 0.00;
    opp.AccountId = objCA.AccountId; 
    opp.Sector__c = objCA.Account.Sector__c;
    opp.OwnerId =  objCA.Account.OwnerId;
    opp.Type =  configValue.Value__c;
    opp.ISR__c = objCA.Account.ISR__C;
    //opp.RecordTypeId = '01270000000LyH6';
    // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.OpportunityAdditionalServicesRecordTypeId'.
   opp.RecordTypeId = schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Expansion-Add On').getRecordTypeId();
    opp.StageName = 'Closing';//Changed by VT due to change in Stage map(was negotiation earlier)
    opp.ForecastCategoryName = 'Commit';
    opp.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';
    opp.Next_Steps__c = 'Purchase ' + configValue.Value__c + ' Token(s): Quantity = ' + requstedTokens + ' per ' + conName;
       
    //send notification regarding new opportunity
    List<String> SendTo = new List<String>();
    SendTo.add(opp.OwnerId);
    SendTo.add(opp.ISR__c);
    system.debug('sendTo : ' + sendTo);
    List<ID> contactIdList= GetContactFromUserList.getContactFromUserList(sendTo);  
    system.debug('contactIDList: ' + contactIdList); 
    try{
        insert opp;
       
        if (contactIdList.size()>0){
            NotifyNewOpportunity.NotifyNewOpportunity(contactIDList, opp.id);
        }
        pageRef = new PageReference ('/' + opp.Id );                  
    }catch(Exception ex){
        System.debug ('Exception occured :--> ' + ex);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
    }
          
    return pageRef;
  }
  
  public PageReference cancel(){
    return new PageReference ('/' + objCA.Id );
  }
}