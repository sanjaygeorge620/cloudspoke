public class  UpdateProjectOnOpp 
{
    public UpdateProjectOnOpp()
    {
        List<Opportunity> OppIdList = new List<Opportunity>{};
        List<pse__Proj__c> projectIDList = new List<PSE__Proj__c>{};
        List<pse__Proj__c> preProjectIDLIst = new List<PSE__Proj__c>{};
        set<id> projectIds = new set<id>();
        set<id> opp_pr_Ids = new set<id>();        
        Map<id, List<pse__Proj__c>> ProjectMap = new Map<id, List<pse__Proj__c>>();
        Map<id, List<pse__Budget__c>> BudgetMap = new Map<id, List<pse__Budget__c>>();
                
        Schema.DescribeSObjectResult des = Schema.SObjectType.pse__Proj__c; 
        Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
        Id MRrtId = rtMap.get('Professional Services').getRecordTypeId();
        
        preProjectIDLIst = [select id, createdDate, pse__opportunity__c, pse__Opportunity__r.pse__Primary_Project__c from pse__Proj__c where pse__opportunity__c <> null
                            and RecordTypeid =: MRrtId and pse__Opportunity__r.pse__Primary_Project__c = null order by CreatedDate asc limit 10];
        if(!preProjectIDLIst.isEmpty())
        {                    
        for(pse__Proj__c  prj : preProjectIDLIst)
        {                    
        List<pse__Proj__c> temp = new List<pse__Proj__c>();
        if(!ProjectMap.containskey(prj.pse__opportunity__c))
        {        
        temp.add(prj);
        ProjectMap.put(prj.pse__opportunity__c,temp);  
        opportunity opp = new opportunity(id = prj.pse__opportunity__c,pse__Primary_Project__c = prj.id);
        OppIdList.add(opp);
        }
        else
        {
        temp = ProjectMap.get(prj.pse__opportunity__c);
        temp.add(prj);
        ProjectMap.put(prj.pse__opportunity__c,temp);  
        }         
        }        
        }
        
        List<pse__Budget__c> budjLst = [Select ID,pse__Opportunity__c,pse__Opportunity__r.pse__Primary_Project__c,pse__Project__c,pse__Project__r.Recordtypeid,pse__Project__r.createddate from pse__Budget__c where 
                                        pse__Opportunity__r.pse__Primary_Project__c = null and pse__Opportunity__c != null and pse__Project__r.RecordTypeid =: MRrtId  order by pse__Project__r.createddate asc limit 10];
        
        if(!budjLst.isEmpty())
        {
        for(pse__Budget__c budj : budjLst)
        {
        if(!ProjectMap.containsKey(budj.pse__Opportunity__c))
        {
        List<pse__Budget__c> tempbudj = new List<pse__Budget__c>();
        if(!BudgetMap.containskey(budj.pse__opportunity__c))
        {        
        tempbudj.add(budj);
        BudgetMap.put(budj.pse__opportunity__c,tempbudj);  
        opportunity opp = new opportunity(id = budj.pse__Opportunity__c,pse__Primary_Project__c = budj.pse__Project__c);
        OppIdList.add(opp);
        }
        else
        {
        tempbudj = BudgetMap.get(budj.pse__Opportunity__c);
        tempbudj.add(budj);
        BudgetMap.put(budj.pse__opportunity__c,tempbudj);   
        }         
        }
        }        
        }
        if(!oppIdList.isEmpty())
        {
        update oppIdList;
        }
        }
    
}