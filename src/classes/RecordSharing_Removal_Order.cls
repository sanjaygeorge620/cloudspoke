public with sharing class RecordSharing_Removal_Order 
{
   Public static void manualShare_Order_Removal(Set<ID> orderListIDs, set<ID> AcctListIDs)
   {
   List<Order__Share> toDel = new List<Order__Share>();
   List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :AcctListIDs]);
   List<Order__Share> orderShareList = new List<Order__Share>([select id, parentID, UserOrGroupID from Order__Share where parentID in :orderListIDs]);
   Map<ID, Order__Share> OrderShareMap = new Map<ID, Order__Share>();
      for(Order__Share orderShareRec : orderShareList)
      {
          OrderShareMap.put(orderShareRec .UserOrGroupID, orderShareRec);
      }
      
    integer l = 0;

        for (User UserRec : PrimaryPartnerUsers)
        {
            If(orderShareMap.containsKey(userRec.id))
            {
             Order__Share orderShareRec = orderShareMap.get(userRec.id);
             toDel.add(orderShareRec);   
            }
         }
         if(!toDel.isEmpty())
         {
         delete toDel;         
         }
   }
    
    

}