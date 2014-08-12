trigger LX_InsertAccountCompetitor on LX_Opportunity_Competitor__c (before insert,before update) 
{
/*
 * ©Lexmark Front Office 2013, all rights reserved
 * Created Date : 24/May/2013
 * Author : Arun thakur(arunsingh6@deloitte.com)
 * Description : Established relationship between Opportunity Competitor and “Competitor Influencer and Partner” .
 */

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
 System.debug('===================================LX_InsertAccountCompetitor===============================');
    //List of Opportunity Influencer record Account 
    Set<Id> LX_AccountIds=new Set<Id>();
    
    //Create A key to search in LX_Account_Competitor__c records 
    Map<String,LX_Opportunity_Competitor__c> AccountKeyAndInfluencer=new Map<String,LX_Opportunity_Competitor__c> ();
    for(LX_Opportunity_Competitor__c ObjInfluencer :trigger.New)
    {
        
        ObjInfluencer.LX_Customer_Account__c=ObjInfluencer.Opportunity_Account_Id__c;
        if(ObjInfluencer.LX_Winner__c==true)
        {
            AccountKeyAndInfluencer.Put(ObjInfluencer.LX_Customer_Account__c+'#'+ObjInfluencer.LX_Competitor_Account__c,ObjInfluencer);
            LX_AccountIds.Add(ObjInfluencer.LX_Customer_Account__c);
        }
    }
    
    List<LX_Opportunity_Competitor__c> OpportunityInfluencer=new  List<LX_Opportunity_Competitor__c>();
    //get all LX_Account_Competitor__c records  where accounts is Opportunity Influencer accounts
    for(LX_Account_Competitor__c  ObjCompetitorInfluencerPartner:[select Id,LX_End_Customer_Account__c ,LX_Competitor_Account__c 
    from LX_Account_Competitor__c where LX_End_Customer_Account__c in :LX_AccountIds])
    {
        String Key=ObjCompetitorInfluencerPartner.LX_End_Customer_Account__c+'#'+ObjCompetitorInfluencerPartner.LX_Competitor_Account__c;
        //If Ket exist Remove from insert list and update an LX_Opportunity_Competitor__c record with related  LX_Account_Competitor__c record
        if(AccountKeyAndInfluencer.containsKey(Key))
        {
        
            LX_Opportunity_Competitor__c ObjOpportunityInfluencer=AccountKeyAndInfluencer.get(key);
            ObjOpportunityInfluencer.LX_Competitor_Relationship__c=ObjCompetitorInfluencerPartner.Id;
            OpportunityInfluencer.Add(ObjOpportunityInfluencer);
            AccountKeyAndInfluencer.remove(Key);
        }
    }
    
    //Insert LX_Account_Competitor__c records 
    List<LX_Account_Competitor__c> ListAccountCompetitorInfluencerPartner=new List<LX_Account_Competitor__c>();
    for(LX_Opportunity_Competitor__c ObjOpportunityInfluencer :AccountKeyAndInfluencer.values())
    {
    
        if(ObjOpportunityInfluencer.LX_Winner__c==true)
        {
            LX_Account_Competitor__c NewAccountCompetitorInfluencerPartner=new LX_Account_Competitor__c();
            NewAccountCompetitorInfluencerPartner.LX_End_Customer_Account__c=ObjOpportunityInfluencer.LX_Customer_Account__c;
            NewAccountCompetitorInfluencerPartner.LX_Competitor_Account__c =ObjOpportunityInfluencer.LX_Competitor_Account__c;
            NewAccountCompetitorInfluencerPartner.LX_Primary__c=ObjOpportunityInfluencer.LX_Primary__c;
            NewAccountCompetitorInfluencerPartner.LX_Current_Install_Base__c=ObjOpportunityInfluencer.LX_Current_Install_Base__c;
            NewAccountCompetitorInfluencerPartner.LX_Weaknesses__c=ObjOpportunityInfluencer.LX_Weaknesses__c;
            NewAccountCompetitorInfluencerPartner.LX_Strengths__c=ObjOpportunityInfluencer.LX_Strengths__c;
        
            ListAccountCompetitorInfluencerPartner.Add(NewAccountCompetitorInfluencerPartner);
        }
        
    }
    //Kapil 11/5/13:Added try catch block 
    try{
    insert ListAccountCompetitorInfluencerPartner;
    }catch(Exception ex){
    LX_CommonUtilities.createExceptionLog(ex);
    }
    
    System.debug('===============ListAccountCompetitorInfluencerPartner='+ListAccountCompetitorInfluencerPartner);
    
    for(LX_Account_Competitor__c ObjCompetitorInfluencerPartner:ListAccountCompetitorInfluencerPartner)
    {
    
        String Key=ObjCompetitorInfluencerPartner.LX_End_Customer_Account__c +'#'+ObjCompetitorInfluencerPartner.LX_Competitor_Account__c ;
        //If Ket exist Remove from insert list and update an LX_Opportunity_Competitor__c record with related  LX_Account_Competitor__c record
        if(AccountKeyAndInfluencer.containsKey(Key))
        {
            
                LX_Opportunity_Competitor__c ObjOpportunityInfluencer=AccountKeyAndInfluencer.get(key);
                ObjOpportunityInfluencer.LX_Competitor_Relationship__c=ObjCompetitorInfluencerPartner.Id;
                //OpportunityInfluencer.Add(ObjOpportunityInfluencer); 
                //AccountKeyAndInfluencer.remove(Key); 
            
        }
    
    }
    

 
}