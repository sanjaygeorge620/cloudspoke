trigger LX_Operations_BI_BU_AI_AD on LX_Operations__c (before update,before insert,  after insert, after delete) 
{
/*
 * Description  : Trigger set a scope as primary   
 * Created By   : Sanjay George
 * Created On   : 3/5/2014

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Sumedh Ambokar           18-March-14          
 * 
*/
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // Bypass code
    if(Trigger.isBefore){
        if(FirstRun_Check.FirstRun_LX_Operations_trigger == true)
        {
            List<LX_Operations__c> scopes = new List<LX_Operations__c>();
            if(trigger.isupdate||trigger.isinsert)
            {
                List<id> List_opportunity_id = new List<id>();
                string UpdateSuffix ='';
                
                    
                for(LX_Operations__c scp : trigger.new)
                {                
                    if(scp.is_primary__c == true)
                    {
                        if(scp.LX_Opportunity__c != Null)
                        {
                           List_opportunity_id.add(scp.LX_Opportunity__c); // Creating a list of Opportunity ids related to the scopes with is primary set as true.
                        }
                    }
                } 
                if(List_opportunity_id.size()>0){
                    if(Trigger.isUpdate){
                        set<id> set_id = Trigger.newmap.keyset();
                        UpdateSuffix= ' AND id NOT IN :set_id';
                    }
                      //  system.debug('myvariable -->'+myvariable );
                    scopes =( List<LX_Operations__c>)Database.query('SELECT id, is_primary__c FROM LX_Operations__c WHERE LX_Opportunity__c IN :List_opportunity_id AND Is_Primary__c = True' + UpdateSuffix); 
                    if(scopes.size()>0){
                    for(LX_Operations__c scp : scopes)
                    {
                        scp.Is_Primary__c = False; // setting is primary false for other scopes related to the opportunity.
                    }
                    FirstRun_Check.FirstRun_LX_Operations_trigger = false;      
                    update scopes;
                    }
                }
            }
        }
    }
    
    if(Trigger.isAfter){
        set<id> SetOpportunityid = new Set<id>();
        List<LX_Operations__c> TriggerList;
        if(Trigger.isInsert)
            TriggerList = Trigger.New;
        else
             TriggerList = Trigger.old;
        for(LX_Operations__c Opr: TriggerList ){
            SetOpportunityid.add(Opr.LX_Opportunity__c);
        }
        system.debug(SetOpportunityid.size());
        AggregateResult[] OppAggrList = [select count(id) exp0, LX_Opportunity__c from LX_Operations__c where LX_Opportunity__c =:SetOpportunityid  Group by LX_Opportunity__c];
        system.debug(OppAggrList.size());
        List<Opportunity> OppUpdateList = new List<Opportunity>();  
        Opportunity opp;
        SetOpportunityid = new Set<id>();
        if(Trigger.IsDelete){
  
            for(AggregateResult ar: OppAggrList ){
                if(ar.get('LX_Opportunity__c')!=null)
                    SetOpportunityid.add((id)ar.get('LX_Opportunity__c'));
                if(ar.get('LX_Opportunity__c')!=null&&ar.get('LX_Opportunity__c')!=''&&ar.get('exp0')!=null){
                    opp = new Opportunity ();
                    opp.LX_Counter_Scope__c= (integer) ar.get('exp0') ;
                    opp.id= (id)ar.get('LX_Opportunity__c');
                    OppUpdateList.add(opp);
                    
                }
            }
        }
        if(Trigger.isInsert){
        
            for(AggregateResult ar: OppAggrList ){
                if(ar.get('LX_Opportunity__c')!=null&&ar.get('LX_Opportunity__c')!=''&&ar.get('exp0')!=null){
                    opp = new Opportunity ();
                    opp.LX_Counter_Scope__c= (integer) ar.get('exp0') ;
                    opp.id= (id)ar.get('LX_Opportunity__c');
                    OppUpdateList.add(opp);
                }    
            }
        }
        for(LX_Operations__c Opr: TriggerList ){
            if(!SetOpportunityid.contains(Opr.LX_Opportunity__c)&&Trigger.isDelete){
                    opp = new Opportunity ();
                    opp.LX_Counter_Scope__c= 0 ;
                    opp.id= Opr.LX_Opportunity__c;
                    OppUpdateList.add(opp);
            }
        }
        if(OppUpdateList.size()>0){
           try{
                update OppUpdateList;
           }
            catch(Exception e){
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }

        
    
}