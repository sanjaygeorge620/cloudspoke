trigger LX_UpdateOrderTrg on Case (after insert, after update) {
    Set<Id> orderIds = new Set<Id>();
    for(Case c : trigger.new){
        if(c.LX_New_Order_Request__c != null){
            orderIds.add(c.LX_New_Order_Request__c);
        }        
    }
    
    if(orderIds.size()>0){
        Map<Id, List<Case>> mpOrders = new Map<Id, List<Case>>();
        Map<Id, List<Case>> mpClosedOrders = new Map<Id, List<Case>>();
       
        for(Case c :[Select id,Status,LX_New_Order_Request__c from Case where LX_New_Order_Request__c in: orderIds]){
           
            if(mpOrders.get(c.LX_New_Order_Request__c) == null)
                mpOrders.put(c.LX_New_Order_Request__c, new List<Case>{c});
            else
                mpOrders.get(c.LX_New_Order_Request__c).add(c);
                
            if(c.status == 'Closed'){
                if(mpClosedOrders.get(c.LX_New_Order_Request__c) == null)
                    mpClosedOrders.put(c.LX_New_Order_Request__c, new List<Case>{c});
                else
                    mpClosedOrders.get(c.LX_New_Order_Request__c).add(c);
            }
           
        }
        if(mpOrders.size()>0){
            List<LX_New_Order_Request__c> lstToUpdate = new List<LX_New_Order_Request__c>();
            for(id OrderId : mpOrders.keyset()){
                if(mpClosedOrders.get(OrderId) != null && mpOrders.get(OrderId) != null){
                    LX_New_Order_Request__c oReq = new LX_New_Order_Request__c(Id = orderId);
                    if(mpOrders.get(OrderId).size() != mpClosedOrders.get(OrderId).size())
                        oReq.LX_Case_Status__c = 'Open';
                    else
                        oReq.LX_Case_Status__c = 'Closed';
                    lstToUpdate.add(oReq);
                }
                else{
                    if(mpOrders.get(OrderId) != null && mpClosedOrders.get(OrderId)== null){
                        LX_New_Order_Request__c oReq = new LX_New_Order_Request__c(Id = orderId);
                        oReq.LX_Case_Status__c = 'Open';
                        lstToUpdate.add(oReq);
                    }
                }
            }
            
            if(lstToUpdate.size()>0)
            update lstToUpdate;
        }
    }
    
    
}