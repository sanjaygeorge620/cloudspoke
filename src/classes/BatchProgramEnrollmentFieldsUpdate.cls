/*********************************************************************************
Name : BatchPrgEnrollFieldsUpdate 
Created By : Appirio Offshore(Hemlata)
Created Date : Jan 2013
Usages : This Batch Apex class iterates over Accounts and up[date Account fields.  

this is from test1a
qualifying, developing, demonstrating, proposing, closing, 
open stages
closed won
won stage
closed dead, closed withdraw, closed lost
are the remaining stages 
*********************************************************************************/
global class BatchProgramEnrollmentFieldsUpdate implements Database.Batchable<sObject> 
{
    global final String Query;    
    global final Set<String> OPEN_OPP_STAGE = new Set<String> {'Qualifying', 'Developing', 'Demonstrating', 'Proposing', 'Closing'};
    global final Set<String> LOST_OPP_STAGE = new Set<String> {'Closed Lost', 'Closed Dead', 'Closed Withdraw'};

    global BatchProgramEnrollmentFieldsUpdate(String q)
    {
        Query = q; 
    }
    
    global BatchProgramEnrollmentFieldsUpdate()
    {
        Query = 'Select a.Current_Year_Revenue_Goal__c, a.YTD_Revenue_Generated__c, a.Value_Open_Opportunities__c, a.Value_Closed_Won_Opportunities__c, a.Opportunity_Win_Rate__c, a.Number_Open_Opportunities__c, a.Number_Lost_Opportunities__c, a.Number_Closed_Won_Opportunities__c, a.Last_Year_Revenue_Generated__c, a.Goal_Attainment__c From LX_Program_Enrollment__c a';
        system.debug('Query' + Query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(Test.isRunningTest()) 
        {
            return database.getQueryLocator('Select a.Current_Year_Revenue_Goal__c, a.YTD_Revenue_Generated__c, a.Value_Open_Opportunities__c, a.Value_Closed_Won_Opportunities__c, a.Opportunity_Win_Rate__c, a.Number_Open_Opportunities__c, a.Number_Lost_Opportunities__c, a.Number_Closed_Won_Opportunities__c, a.Last_Year_Revenue_Generated__c,a.Id, a.Goal_Attainment__c, a.LX_Party_Group__c,a.LX_Party_Type__c,a.LX_Party_Role__c From LX_Program_Enrollment__c a Limit 1');  
        }        
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC,  List<sObject> recordList)
    {
        Map<Id, LX_Program_Enrollment__c> lxpMap = new Map<Id,LX_Program_Enrollment__c>();
        List<LX_Program_Enrollment__c> lxpList;
        Map<Id,Set<Opportunity>> lxpToOpportunitiesMap = new Map<Id,Set<Opportunity>>();
        Map<Id,Opportunity> lxpToCurrentFiscalOppMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> lxpToLastFiscalOppMap = new Map<Id,Opportunity>();
        Map<Id,Set<Opportunity>> lxpToClosedLostOpportunitiesMap = new Map<Id,Set<Opportunity>>();
        
        for(sObject record :recordList) 
        {
            LX_Program_Enrollment__c acc = (LX_Program_Enrollment__c)record;
            lxpMap.put(acc.Id,acc);            
        } 
            for (Opportunity oppObj : [Select o.Id, o.StageName,  o.Primary_Partner__r.Type, o.Primary_Partner__c, o.CloseDate, o.LX_Program_Enrollment__r.LX_Party_Group__c,o.LX_Program_Enrollment__r.LX_Party_Role__c,o.LX_Program_Enrollment__r.LX_Party_Type__c,
        o.LX_Program_Enrollment__c,o.TotalOpportunityQuantity,o.Amount  From Opportunity o where o.LX_Program_Enrollment__c in :lxpMap.keySet()]) 
        {
                if (lxpToOpportunitiesMap.containsKey(oppObj.LX_Program_Enrollment__c)) 
                {
                    Set<Opportunity> oppSet = lxpToOpportunitiesMap.get(oppObj.LX_Program_Enrollment__c);
                    oppSet.add(oppObj);
                    lxpToOpportunitiesMap.put(oppObj.LX_Program_Enrollment__c,oppSet);
                } else 
                {
                    lxpToOpportunitiesMap.put(oppObj.LX_Program_Enrollment__c,new Set<Opportunity>{oppObj});
                }
            } 

                 
        
        lxpToCurrentFiscalOppMap = new Map<Id, Opportunity>([Select o.Id,o.StageName,  o.Primary_Partner__r.Type, o.Primary_Partner__c, o.CloseDate, o.LX_Program_Enrollment__r.LX_Party_Group__c,o.LX_Program_Enrollment__r.LX_Party_Role__c,o.LX_Program_Enrollment__r.LX_Party_Type__c,
            o.LX_Program_Enrollment__c,o.TotalOpportunityQuantity,o.Amount  From Opportunity o where o.CloseDate = THIS_FISCAL_YEAR and o.LX_Program_Enrollment__c in: lxpMap.keySet()]);
        lxpToLastFiscalOppMap = new Map<Id, Opportunity>([Select o.Id,o.StageName,  o.Primary_Partner__r.Type, o.Primary_Partner__c, o.CloseDate, o.LX_Program_Enrollment__r.LX_Party_Group__c,o.LX_Program_Enrollment__r.LX_Party_Role__c,o.LX_Program_Enrollment__r.LX_Party_Type__c,
            o.LX_Program_Enrollment__c,o.TotalOpportunityQuantity,o.Amount  From Opportunity o where o.CloseDate = LAST_FISCAL_YEAR and o.LX_Program_Enrollment__c in: lxpMap.keySet()]);
            
        list<LX_Program_Enrollment__c> LxpLisBeUpdated = new List<LX_Program_Enrollment__c>();
        for (Id accId: lxpToOpportunitiesMap.keySet()) 
        {
            Set<Opportunity> opportunityList = lxpToOpportunitiesMap.get(accId);
            Decimal GoalAttainment = 0.00;
            Decimal No_Open_Opportunities = 0;
            Decimal No_ClosedWon_Opportunities = 0;
            Decimal No_Lost_Opportunities = 0;
            Decimal Value_Open_Opportunities = 0.00;
            Decimal Value_ClosedWon_Opportunities = 0.00;
            Decimal YTD_Revenue_Generated = 0.00;
            Decimal LastYear_Revenue_Generated = 0.00;
            for (Opportunity oppObj : opportunityList) 
            {
                system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                if (oppObj.StageName == 'Closed Won' && lxpToCurrentFiscalOppMap.containsKey(oppObj.Id) && oppObj.Amount != null) 
                {
                    system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                    GoalAttainment = GoalAttainment + oppObj.Amount;
                }  
                if (OPEN_OPP_STAGE.contains(oppObj.StageName) ) 
                {
                    system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                    No_Open_Opportunities = No_Open_Opportunities + 1;
                    if (oppObj.Amount != null) 
                    {    
                        system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                        Value_Open_Opportunities = Value_Open_Opportunities + oppObj.Amount;
                    }   
                } 
                if (oppObj.StageName == 'Closed Won') 
                {
                    system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                    No_ClosedWon_Opportunities = No_ClosedWon_Opportunities + 1;
                    if (oppObj.Amount != null) 
                    {    
                        system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                        Value_ClosedWon_Opportunities = Value_ClosedWon_Opportunities + oppObj.Amount;
                    }   
                }
                if (LOST_OPP_STAGE.contains(oppObj.StageName)) 
                {
                    system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                    No_Lost_Opportunities = No_Lost_Opportunities + 1;
                } 
                        
                if (oppObj.StageName == 'Closed Won' && lxpToLastFiscalOppMap.containsKey(oppObj.Id) && oppObj.Amount != null) 
                {
                    system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                    LastYear_Revenue_Generated = LastYear_Revenue_Generated + oppObj.Amount;
                }   
                //Added for US4400
                if (oppObj.StageName == 'Closed Won' && lxpToCurrentFiscalOppMap.containsKey(oppObj.Id) && oppObj.Amount != null )
                {   
                    YTD_Revenue_Generated = YTD_Revenue_Generated + oppObj.Amount;
                }               
            } // for
            
            if (lxpMap.get(accId).Current_Year_Revenue_Goal__c != null && lxpMap.get(accId).Current_Year_Revenue_Goal__c != 0) 
            {
                system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                lxpMap.get(accId).Goal_Attainment__c = (GoalAttainment/lxpMap.get(accId).Current_Year_Revenue_Goal__c)*100;
            }
            LxpMap.get(accId).Number_Open_Opportunities__c = No_Open_Opportunities;
            LxpMap.get(accId).Number_Closed_Won_Opportunities__c = No_ClosedWon_Opportunities;
            LxpMap.get(accId).Number_Lost_Opportunities__c = No_Lost_Opportunities;
            if ((No_ClosedWon_Opportunities + No_Lost_Opportunities) != 0) 
            {
                system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
                LxpMap.get(accId).Opportunity_Win_Rate__c = No_ClosedWon_Opportunities/(No_ClosedWon_Opportunities + No_Lost_Opportunities);
            }   
            LxpMap.get(accId).Value_Open_Opportunities__c = Value_Open_Opportunities;
            LxpMap.get(accId).Value_Closed_Won_Opportunities__c = Value_ClosedWon_Opportunities;
            LxpMap.get(accId).YTD_Revenue_Generated__c = YTD_Revenue_Generated;
            LxpMap.get(accId).Last_Year_Revenue_Generated__c = LastYear_Revenue_Generated;
            LxpLisBeUpdated.add(LxpMap.get(accId));
                
        } // for
        if (LxpLisBeUpdated != null && LxpLisBeUpdated.size() > 0) 
        {
            update LxpLisBeUpdated;
        }        
    }
    global void finish(Database.BatchableContext BC){
    
    }    
    
    @isTest(SeeAllData=true)
    public static void batchTest()
    {
        RecordType rec = [Select id from RecordType where name='Local PSW Program' and sobjectType='LX_Partner_Program__c'];
        //Account acc = Data_account.createAccount3();
        RecordType perec = [Select id from RecordType where name='PSW Program Enrollment' and sobjectType='LX_Program_Enrollment__c'];
        LX_Partner_Program__c pgm = new LX_Partner_Program__c();
        pgm.Name='test pgm';
        pgm.recordtypeId = rec.Id;
        pgm.Program_Level__c='Global Program Category (L2)';
        //pgm.LX_Account__c= acc.Id;
        insert pgm;
        
        LX_Program_Enrollment__c pe = new LX_Program_Enrollment__c();
        pe.Master_Program__c = pgm.Id;
        pe.recordtypeid = perec.id ;
        insert pe;
        //System.debug('>>>>>>>>>>>>>');
    

       BatchProgramEnrollmentFieldsUpdate batch = new BatchProgramEnrollmentFieldsUpdate();                
       Test.startTest();
       Database.executeBatch(batch,1);
       Test.stopTest();
   }

}