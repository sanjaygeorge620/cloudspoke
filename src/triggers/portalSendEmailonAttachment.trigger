trigger portalSendEmailonAttachment on Attachment (after insert) 
{ 
   if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
   List<Id> ParentIds=new List<Id>();
   List<Id> ownerIds=new List<Id>();
   List<Attachment> attList = new List<Attachment>();
   for (Attachment att : trigger.new)
   {
   string id = att.ParentID;   
   if(id.substring(0,3) == '500')
   {
   attList.add(trigger.newmap.get(att.ID));
   ParentIds.add(att.ParentID);
   ownerIds.add(att.OwnerID);
   }
   }
   if(!attlist.IsEmpty())
   {
   map<ID,User> usrMap = new map<ID,User>();
   map<ID,Case> casesmap = new Map<ID,Case>(); 
   List<Case> updatecase = new List<Case>();
   casesmap.putall([Select ID,HasAttachment__c,Recordtype.Name from case where ID in :ParentIds]);
   usrMap.putall([Select ID,profile.Usertype from User where id IN :ownerIDs]);

   for(attachment attach : attList)
   {
   system.debug('Testing' +usrMap.get(attach.OwnerID).Profile.Usertype);
   if((usrMap.get(attach.OwnerID).Profile.Usertype == 'PowerCustomerSuccess') && (!casesmap.get(attach.parentID).HasAttachment__c)&&(casesmap.get(attach.parentID).Recordtype.Name == 'Product Support'))
   {   
   system.debug('%%%^^^^***');
   case cs = new case(ID = attach.ParentID);
   cs.PortalSendEmail__c = true;
   updatecase.add(cs);    
   }
   if((casesmap.get(attach.parentID).HasAttachment__c)&&(casesmap.get(attach.parentID).Recordtype.Name == 'Product Support'))
   {
   case css = new case(ID = attach.ParentID);
   css.HasAttachment__c = false;
   updatecase.add(css);
   }
   }
   if(!updatecase.isEmpty())
   {
   update updatecase;   
   }
}
}