public with sharing class RequestTokens {
  //test
  public String requstedTokens {get;set;}
  public String oppName {get;set;}
  public Opportunity opportunity{get;set;}
  public String SpecialNotes {get;set;}
  public String accName {get;set;}
  public String conName {get;set;}
  public Training_Attendee__c objTA {get;set;}
  private Account account;
String firstTimeThrough = 'Yes';
  List<ID> contactIDList = new List<ID>();  
  //ApexPages.StandardController standardController;
  
  public RequestTokens(ApexPages.StandardController taController){ 
    //standardController = taController;
    Id currentId = ((Training_Attendee__c)taController.getRecord()).id;
    oppName = 'TRNG –';
    try{
        for(Training_Attendee__c ta : [select id,Contact__r.Account.LX_Software_AEX__c,Contact__r.Account.OwnerId 
                                        , Contact__r.Account.ISR__c
                                        ,Contact__r.Account.ISR__r.Email // added by sumedha 11/1/2013 to send email to isr users
                                        , Contact__r.Account.LX_Software_AEX__r.Email // added by sumedha 11/1/2013 to send email to aex users
                                        , Contact__r.AccountId
                                        ,Contact__r.Account.Name
                                        ,Contact__r.Account.LX_Sales_Team_Assigned__c
                                        ,Contact__r.Name  
                                        from Training_Attendee__c where id = :currentId limit 1 ]){
            objTA = ta;
            accName = objTA.Contact__r.Account.Name != null ? objTA.Contact__r.Account.Name : '' ; 
            conName = objTA.Contact__r.Name != null ? objTA.Contact__r.Name : '' ;
            
        }
        opportunity = new Opportunity();
        SpecialNotes = '' ;
    }catch(Exception ex){
        System.debug ('Exception occured :--> ' + ex);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
    }
  }
  
  public PageReference requestTokens(){     
    RecordType recType;
    pageReference pageRef ;
    //VT:changed record type from 'Additional Services' to 'Expansion-Add On'
    for(RecordType  rt : [Select Id from RecordType where name='Expansion-Add On' limit 1]){
        recType = rt;
    }
    Opportunity opp = new Opportunity();
    OpportunityLineItem oppLI;
    opp.name= oppName;
    opp.CloseDate = System.today()+7; 
    opp.Amount = 0.00;
    opp.AccountId = objTA.Contact__r.AccountId; 
    opp.Sector__c = objTA.Contact__r.Account.LX_Sales_Team_Assigned__c;
    opp.OwnerId =  (objTA.Contact__r.Account.LX_Software_AEX__c != NULL ?objTA.Contact__r.Account.LX_Software_AEX__c:objTA.Contact__r.Account.OwnerId);
    //VT changed type based on the new logic
    //opp.Type = 'Add On Solution';
    opp.RecordTypeId = recType.Id;
    opp.ISR__c = ObjTA.Contact__r.Account.ISR__c;
    opp.StageName = 'Closing';//VT changed stage name from negotiation to closing due to change in the stage map
    opp.ForecastCategoryName = 'Commit';
    opp.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';
    opp.Next_Steps__c = 'Purchase Training Seat(s): Quantity = ' + requstedTokens + ' per ' + conName;
    opp.Special_Notes__c = SpecialNotes;
     opp.Software_Solutions__c = True ;
    opp.LX_AEX_User_Email__c = ObjTA.Contact__r.Account.LX_Software_AEX__r.Email;  // added by sumedha 11/01/2013
    opp.ISR_Email__c = ObjTA.Contact__r.Account.ISR__r.Email;  // added by sumedha 11/01/2013
    //VT commented opp.LX_Product_Type__c = 'Software';x    

    opp.LX_Sales_Type__c = 'Add On';
    System.debug ('opportunity :--> ' + opportunity.id);
    opp.pse__Parent_Opportunity__c = opportunity.pse__Parent_Opportunity__c;
    opp.currencyISOCode = opportunity.currencyISOCode;
    
    
    //send notification regarding new opportunity
    List<String> SendTo = new List<String>();
    SendTo.add(opp.OwnerID);
    SendTo.add(opp.ISR__c);
    SendTo.add(ObjTA.Contact__r.Account.LX_Software_AEX__c); // added by sumedha 11/04/2013
    system.debug('sendTo : ' + sendTo);
    List<ID> contactIdList= GetContactFromUserList.getContactFromUserList(sendTo);  
    system.debug('contactIDList: ' + contactIdList);
    
    //updating the training attendee status
       id AttendeeID = ApexPages.currentPage().getParameters().get('id');
       training_attendee__c Attendee = new training_Attendee__c(id=AttendeeID);
       Attendee.Status__c = 'Requested Opportunity' ;
    
    try{
      insert opp;
      
      //update attendee status after oppty is created
      update attendee;
      
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
    return new PageReference ('/' + objTA.Id );
  }
}