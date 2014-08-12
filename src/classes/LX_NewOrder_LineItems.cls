public class LX_NewOrder_LineItems{
    
    // Variable to store New order record
    public LX_New_Order_Request__c newOrder{get; set;}
    
    // Variable to store list of all SAP Contract Items related to the active SAP Contract on New Order Request
    public List<LX_New_Order_SAP_Contract_Item__c> LineItems{get;set;}
    public Boolean show{get;set;}
    public double newQuant{get;set;}
    public boolean isUpdated{get; set;}
    public LX_NewOrder_LineItems(ApexPages.StandardController controller) {
        newOrder = new LX_New_Order_Request__c();
        show=false;
        newOrder = [SELECT ID,LX_SAP_Contract__c,LX_Bill_To_Id__c, LX_Ship_To_Id__c,RecordType.Name FROM LX_New_Order_Request__c WHERE ID =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1 ];
        if(newOrder.RecordType.Name=='Read Only')
        show = true;
        query();  
        isUpdated = false;  
    }
    public Map<String, List<LX_New_Order_SAP_Contract_Item__c>> mpOrders;
    public void query(){
        LineItems = [  SELECT Id,LX_SAP_Contract_Item__r.LX_Grouping_Code__c,LX_SAP_Contract_Item__r.SAP_Contract__c,LX_SAP_Contract_Item__r.Part_Name__c,
                          LX_SAP_Contract_Item__r.Line_Number__c,LX_SAP_Contract_Item__r.Part_Number__c,LX_SAP_Contract_Item__r.Start_Date__c,
                          LX_SAP_Contract_Item__r.LX_Unit_of_Measure__c,LX_SAP_Contract_Item__r.Sold_Price__c,LX_SAP_Contract_Item__r.End_Date__c,
                          LX_Quantity__c,LX_SAP_Contract_Item__c,LX_New_Order_Request__c
                          FROM LX_New_Order_SAP_Contract_Item__c
                          WHERE LX_SAP_Contract_Item__r.SAP_Contract__c =:newOrder.LX_SAP_Contract__c AND LX_New_Order_Request__c =: ApexPages.currentPage().getParameters().get('Id')]; //:Limits.getLimitDMLRows()
        system.debug('##########'+LineItems.size()+''+newOrder.LX_SAP_Contract__c);
       
        
    }  
    
    public Pagereference saveQuant(){
        Map<String,LX_New_Order_SAP_Contract_Item__c> mpFinal= new Map<String,LX_New_Order_SAP_Contract_Item__c>();
        if(LineItems.size()>0){
            for(LX_New_Order_SAP_Contract_Item__c item: LineItems){
                   mpFinal.put(item.LX_SAP_Contract_Item__r.Line_number__c, item);
            } 
            for(LX_New_Order_SAP_Contract_Item__c item: LineItems){
                if(item.LX_SAP_Contract_Item__r.LX_Grouping_Code__c!= null){
                    item.LX_Quantity__c = mpFinal.get(item.LX_SAP_Contract_Item__r.LX_Grouping_Code__c).LX_Quantity__c;
                }
            }    
        }
        
        update lineItems;
        RecordType rec = [Select id from RecordType where Name='Read Only' and sobjectType='LX_New_Order_Request__c'];
        system.debug('###############################');
        newOrder.recordTypeId = rec.Id;
        update newOrder;
        show = true;
        isUpdated = true;
        return null;
    } 
       
}