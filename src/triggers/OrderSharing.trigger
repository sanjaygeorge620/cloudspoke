trigger OrderSharing on Order__c (after insert, after update) {
     if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    //for each lead that comes in, if has a primary partner, put into list of ids that will be sent to the recordsharing class
    
    Set<ID> OrderIdSet = new Set<ID>();
    Set<ID> AcctIdSet = new Set<ID>();
    
     //get listing of opportunities
     for (Order__c  orderRec : Trigger.new){
        
        system.debug('orderRec.Primary_Partner__c' + orderRec.Reseller_ID__c);
        If(orderRec.Reseller_ID__c <> null && trigger.isInsert ||
               trigger.isUpdate&& orderRec.Reseller_ID__c <> null  && trigger.oldMap.get(orderRec.id).Reseller_ID__c != orderRec.Reseller_ID__c
               ){
            system.debug('met Criteria');
            OrderIdSet.add(orderRec.id);
            system.debug('OrderIdSet:' + OrderIdSet);  
            If(trigger.isUpdate){
                AcctIdSet.add(trigger.oldMap.get(orderRec.id).Reseller_ID__c);
                system.debug('acctIDSet:' + AcctIdSet);
            }
        }
     }
     system.debug('orderIDset:' + orderIdSet);
     if(OrderIdSet.size()>0){
       
        List<Order_Detail__c> orderDetailList = new List<Order_Detail__c>([select id, Reseller_ID__c from Order_Detail__c where order__c = :orderIdSet]);
        Set<ID> OrderDetailIdSet = new Set<ID>();
        if(orderDetailList.size() >0 ){
             for(Order_Detail__c orderDetailRec : OrderDetailList){
                 OrderDetailIDSet.add(orderDetailRec.id);
             }
        }     
        
        if(acctIDSet.size()>0){
            recordSharing_Removal_Order.manualShare_Order_Removal(OrderIdSet, AcctIDSet);
            if(orderDetailIDSet.size()>0){
                recordSharing_Removal_Order_Detail.manualShare_Order_Detail_Removal(orderDetailIDSet, AcctIDSet);
            }
        }   
        recordSharing_Order.manualShare_Order_Read(OrderIdSet);
         if(orderDetailIDSet.size()>0){
             recordSharing_Order_Detail.manualShare_Order_Detail_Read(orderDetailIDSet);
         }
     }
}