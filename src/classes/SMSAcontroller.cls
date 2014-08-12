public class SMSAcontroller{
   public LX_Serial_Number_Sales_Order__c lxObj ; 
   public SMSAcontroller(ApexPages.StandardController controller) 
   {
        lxObj = [SELECT Id,Name,LX_Customer_Account__c,LX_Customer_Account__r.LX_Sales_Team_Assigned__c,LX_Customer_Account__r.OwnerId FROM LX_Serial_Number_Sales_Order__c where id = :ApexPages.CurrentPage().getparameters().get('id') ]; 
                     
   }
   public PageReference createOpp(){
   

       Opportunity Opp = new Opportunity( RecordTypeId = [SELECT Id 
                                             FROM RecordType 
                                             WHERE SobjectType = 'Opportunity' 
                                                 AND DeveloperName = 'Expansion_Add_On'
                                             Limit 1].Id,
                                             Name = lxObj.Name,   
                                             AccountId = lxObj.LX_Customer_Account__c ,                                                                                 
                                             CloseDate = System.Today(), 
                                             OwnerId = lxObj.LX_Customer_Account__r.OwnerId,
                                             Software_Solutions__c = True,
                                             LX_Sales_Type__c = 'SMSA Renewal', 
                                             LX_Purchasing_Method__c = 'Direct',
                                             Type = 'Add On Solution',
                                             LX_Change_Request__c = 'No',
                                             Sector__c = lxObj.LX_Customer_Account__r.LX_Sales_Team_Assigned__c, 
                                            Amount = 0,
                                            StageName = 'Closed Won', 
                                            ForecastCategoryName = 'Omitted', 
                                            Contract_Indicator__c = ' NVE',
                                            LX_Opportunity_Division__c = ' PSW', 
                                            Next_Steps__c = 'Serial Number SMSA Renewal',  
                                            Quote_Status__c = 'Finalized',
                                            Legacy_Company_Originator__c = 'PACSGEAR', 
                                            QALevel2Approved__c = True,  
                                            LX_Ready_for_Finalization__c = True,
                                            LX_CheckOpp_craeted__c = True,
                                            Contract_End_Date__c = System.Today() + 364,
                                            Begin_Date__c = System.Today(),
                                            End_Date__c = System.Today() + 364                                             
                                             );
                                             
     try{
           insert Opp;       
           
       }
       catch(Exception ex){
   
       }
       
                
   return new PageReference ('/' + Opp.Id);
   }                                   
                           
       
}