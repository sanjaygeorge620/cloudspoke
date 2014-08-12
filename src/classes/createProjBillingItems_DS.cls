public class createProjBillingItems_DS
{
    public static Schema.DescribeSObjectResult des = Schema.SObjectType.pse__Proj__c; 
    public static Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
    public Static Id rtId = rtMap.get('Database Services').getRecordTypeId();
    public static Opportunity parentOpp = new Opportunity();
  
    Public Static Void Create(List<Opportunity> oplst, pse__Proj__c selProj)
    {
        System.debug('Opportunity List' +oplst.Size());
        System.debug('*****ParentOpp'+parentOpp);
        List<Project_Billing_Items__c> temp = new List<Project_Billing_Items__c>();
        List<Opportunitylineitem> opprlst = new List<Opportunitylineitem>();
        Map<ID,List<Opportunitylineitem>> opp_pli = new   Map<ID,List<Opportunitylineitem>>();
        List<Project_Billing_Items__c> pbi_List = [select Opportunity__c, Opportunity_Product__c from Project_Billing_Items__c where Project__c = :selProj.Id];

        opprlst = [SELECT Id, Part_Name__c, Part_Number__c  ,Product_Family__c, UnitPrice, Quantity, Originating_Company__c, OpportunityId FROM OpportunityLineItem
                   where OpportunityID in: oplst  and 
                   (Product_Family__c = 'Upgrade Service' OR
                   Product_Family__c = 'Upgrade Services')];
        for(Opportunitylineitem op : opprlst)
        {
            if(opp_pli.containskey(op.OpportunityID))
            {
                List<Opportunitylineitem> pjlst = new List<Opportunitylineitem>();
                pjlst = opp_pli.get(op.OpportunityID);
                pjlst.add(op);
                opp_pli.put(op.OpportunityID,pjlst);
            }
            else
            {
                List<Opportunitylineitem> pjlst = new List<Opportunitylineitem>();
                pjlst.add(op);
                opp_pli.put(op.OpportunityID,pjlst);
            }
        }
        System.debug('****opp_pli'+opp_pli);
        for(Opportunity op : oplst)
        {
            System.debug('Opportunity Loop**************************' +op);
            if(opp_pli.containskey(op.ID))
            {
                for(OpportunityLineItem opl : opp_pli.get(Op.ID))
                {
                    if(!isDuplicate(selProj,opl,pbi_List))
                    {
                        System.debug('OppLineItem Loop**************************' +opl);
                        integer i = Integer.valueOf(opl.Quantity);
                        System.debug('****quantity'+i);
                        system.debug('integer value' +i);
                        for(integer v = 0 ;v < i ; v++)
                        {
                            Project_Billing_Items__c pbi = new Project_Billing_Items__c();
                            pbi.Opportunity__c = op.ID;
                            pbi.originating_COmpany__c = opl.Originating_Company__c;
                            pbi.Project__c = selProj.ID;
                            pbi.Opportunity_Product__c = opl.Id;
                            pbi.Part_Number__c = opl.Part_Number__c;
                            pbi.Product_Name__c = opl.Part_Name__c;
                            pbi.Quantity__c = 1;
                            pbi.Sales_Price__c = opl.UnitPrice;
                            temp.add(pbi);
                            System.debug('Project Billing Item Loop**************************' +pbi);
                        }
                    }
                }
            }
        }
        System.debug('Temp lIST**************************' +TEMP);
        Insert temp;    
    }

    private static boolean isDuplicate(Pse__proj__c pj, OpportunityLineItem op1, List<Project_Billing_Items__c> pbiList){        
        if(op1.OpportunityId == parentOpp.Id){
            for(Project_Billing_Items__c pbi: pbiList){
                if(pbi.Opportunity_Product__c!= null && pbi.Opportunity_Product__c.equals(String.valueOf(op1.Id)))
                    return true;
                else if(pbi.Opportunity_Product__c == null || pbi.Opportunity_Product__c== '') // for old existing PBIs from Parent Oppty
                    return true;       
            }
        }
        else{ // for child Opptys
            for(Project_Billing_Items__c pbi: pbiList){
                if(pbi.Opportunity_Product__c!= null && pbi.Opportunity_Product__c.equals(String.valueOf(op1.Id)))
                    return true;      
            }
        }
        
        return false;
    }

}