public with sharing class RecordSharing_Removal_Order_Detail{


   Public static void manualShare_Order_Detail_Removal(Set<ID> orderListIDs, set<ID> AcctListIDs)
   {
   List<Order_Detail__Share> toDel = new List<Order_Detail__Share>(); 
   List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :AcctListIDs]);
   List<Order_Detail__Share> orderShareList = new List<Order_Detail__Share>([select id, parentID, UserOrGroupID from Order_Detail__Share where parentID in :orderListIDs]);
       Map<ID, Order_Detail__Share> orderShareMap = new Map<ID, Order_Detail__Share>();
      for(Order_Detail__Share orderShareRec : orderShareList)
      {
          orderShareMap .put(orderShareRec.UserOrGroupID, orderShareRec);
      }
      
    integer l = 0;

        for (User UserRec : PrimaryPartnerUsers)
        {
            If(orderShareMap .containsKey(userRec.id))
            {
             Order_Detail__Share orderShareRec= orderShareMap.get(userRec.id);
             toDel.add(orderShareRec);  
            }
        }
        if(!toDel.isEmpty())
        {
        delete toDel;
        }
        
   }
    
    

}