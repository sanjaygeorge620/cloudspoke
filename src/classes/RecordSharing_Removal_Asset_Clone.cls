public with sharing class RecordSharing_Removal_Asset_Clone
{

   Public static void manualShare_Asset_Clone_Removal(Set<ID> assetListIDs, set<ID> AcctListIDs)
   {
      List<Asset_Clone__Share> toDel = new List<Asset_Clone__Share >();
      List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :AcctListIDs and
                                                       profile.name like '%Channel Portal%']);

      List<Asset_Clone__Share> assetShareList = new List<Asset_Clone__Share>([select id, parentID, UserOrGroupID from Asset_Clone__Share where parentID in :assetListIDs]);
       Map<ID, Asset_Clone__Share> assetShareMap = new Map<ID, Asset_Clone__Share>();
      for(Asset_Clone__Share assetShareRec : assetShareList)
      {
          assetShareMap .put(assetShareRec.UserOrGroupID, assetShareRec);
      }
      
    integer l = 0;

        for (User UserRec : PrimaryPartnerUsers)
        {
            If(assetShareMap .containsKey(userRec.id))
            {
            Asset_Clone__Share assetShareRec= assetShareMap.get(userRec.id);
            toDel.add(assetShareRec);
            }
        }
        
        if(!toDel.isEmpty())
        {
        delete toDel;        
        }
   }
}