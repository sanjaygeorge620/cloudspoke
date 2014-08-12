trigger LX_Opportunity_AU on Opportunity (After Update) {

        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 


if(LX_SAP_Record_Utility.IsUpdated == false){//Avoid recursion using a static variable
List<Opportunity> listOpp = new List<Opportunity>([Select Id, name, AccountId, Primary_Partner__c from opportunity where Id IN :Trigger.newMap.keySet()and  Primary_Partner__c != null and StageName='Closed Won' ]);

List<LX_Competitor_Influencer_and_Partner__c> listCIP = new List<LX_Competitor_Influencer_and_Partner__c>();
LX_Competitor_Influencer_and_Partner__c oCIP;
for (Opportunity record: listOpp)
{
     oCIP = new LX_Competitor_Influencer_and_Partner__c(LX_Influencer_Account__c= record.Primary_Partner__c ,
     LX_Customer_Account__c= record.AccountId  , LX_Type__c='Partner', RecordTypeID=LX_SetRecordIDs.CompetitorPartnerInfluencerPartnerId);
     listCIP.add(oCIP);
}
  System.debug('ListCip: ' + listCIP);
   try{
  insert listCIP;
  }catch(exception ex){
  system.debug('>>>>>>>>>>>>exception>>>>');
  LX_CommonUtilities.createExceptionLog(ex);//Exception log ,Veenu Trehan 6/11/13       
    }
  LX_SAP_Record_Utility.IsUpdated = true;
}
}