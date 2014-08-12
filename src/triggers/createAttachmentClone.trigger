trigger createAttachmentClone on Attachment (after insert,after update,before delete) 
{

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

if(trigger.isinsert)
{

set<ID> attID = new set<ID>();

set<ID> paID  = new set<ID>();

List<Attachment> lkattID = new List<Attachment>();

for(attachment a : trigger.new)
{
attID.add(a.ID);
}

List<Attachment> attmap = new List<Attachment>([Select ID,Body,BodyLength,Contenttype,Description,IsPrivate,Name,ParentID,ownerID,IsDeleted from Attachment where ID in : attID]);

map<ID,ID> mp = new map<ID,ID>();
for(attachment a : attmap)
{
//string s = 'a2o'; commented by arun thakur
string s = Schema.getGlobalDescribe().get('License_Key__c').getDescribe().getKeyPrefix();


string p = a.parentID;
string r = p.substring(0,3);
system.debug('attachment my parent id id' +r);

if(r.equals(s))
{
lkattID.add(a);
paID.add(a.ParentID);
system.debug('attachment my parent id id' +a.ParentID);
}
}

for(License_key_clone__c lkc :[Select ID,parent_license_key__r.ID from license_key_clone__c where Parent_License_Key__c in : paID])

{
mp.put(lkc.parent_license_key__r.ID,lkc.ID);
system.debug('attachment my parent id id' +lkc.parent_license_key__r.ID);
system.debug('attachment my parent id id' +lkc.ID);
}



List<Attachment> attclon = new List<Attachment>();

for(attachment at : lkattID)
{

//system.debug('Attachment Parent ID' +at.ParentID);

attachment b = at.clone(false);

b.parentid = mp.get(at.parentID); 
system.debug('attachment my parent id' +b.parentid);
attclon.add(b);

}
system.debug('REACHED INSERT ATTACHMENT --LINE59');
insert attclon;

}

//=============================================================UPDATE======================================================

if(trigger.isupdate)
{
set<ID> attID = new set<ID>();
set<ID> attparID = new set<ID>();
list<attachment> attlst = new list<attachment>();
map<ID,list<attachment>> attmap = new map<ID,list<attachment>>();
map<ID,ID> pa_att_map = new map<ID,ID>();

for(attachment a : trigger.new)
{

//string s = 'a2o'; commented by arun thakur
string s = Schema.getGlobalDescribe().get('License_Key__c').getDescribe().getKeyPrefix();


string p = a.parentID;
string r = p.substring(0,3);
system.debug('attachment my parent id id' +r);
list<attachment> attlist = new list<attachment>();

if(r.equals(s))
{
if(attparID.contains(a.ID))
{
attmap.get(a.ID).add(trigger.oldmap.get(a.id));
}
if(!attparID.contains(a.ID))
{
//attID.add(a.ID);
attlist.add(trigger.oldmap.get(a.id));
attmap.put(a.ParentID,attlist);
attparID.add(a.ParentID);
pa_att_map.put(a.ParentID,a.ID);
}
}
}

map<ID,ID> lk_lkc_map = new map<ID,ID>();
set<ID> lkcID = new set<ID>();

for(license_key_clone__c lkc : [Select ID,Parent_license_key__c from license_key_clone__c 
                                where parent_license_key__c in : attparID])
  
  {
  
  lk_lkc_map.put(lkc.ID,lkc.Parent_license_key__c);
  lkcID.add(lkc.ID);                                
  }
set<ID> todel = new set<ID>();
list<attachment> updlist = new list<attachment>();

list<attachment> attcllst = new list<attachment>();
map<ID,list<attachment>> attclmap = new map<ID,list<attachment>>();

for(list<attachment> latt : [Select ID,ParentID,name,Description,Bodylength from attachment where parentID in : lkcID] )
{

for(attachment eachatt : latt)
{
for(attachment trigatt : attmap.get(lk_lkc_map.get(eachatt.ParentID)))
{
if((trigatt.name == eachatt.name) && (trigatt.bodyLength == eachatt.BodyLength))
{
attachment newatt = trigger.newmap.get(trigatt.ID);

if(newatt.Description != null)
{
eachatt.Description = newatt.Description;
}

if(newatt.name != null )
{
eachatt.Name = newatt.Name;
}

updlist.add(eachatt);
}
}
}
}

update updlist;

}

//============================================Delete===============================================


if(trigger.isdelete)
{
set<ID> attID = new set<ID>();
set<ID> attparID = new set<ID>();
list<attachment> attlst = new list<attachment>();
map<ID,list<attachment>> attmap = new map<ID,list<attachment>>();
map<ID,ID> pa_att_map = new map<ID,ID>();

for(attachment a : trigger.old)
{

//string s = 'a2o'; commented by arun thakur
string s = Schema.getGlobalDescribe().get('License_Key__c').getDescribe().getKeyPrefix();


string p = a.parentID;
string r = p.substring(0,3);
system.debug('attachment my parent id id' +r);
list<attachment> attlist = new list<attachment>();

if(r.equals(s))
{
if(attparID.contains(a.ID))
{
attmap.get(a.ID).add(trigger.oldmap.get(a.id));
}
if(!attparID.contains(a.ID))
{
//attID.add(a.ID);
attlist.add(trigger.oldmap.get(a.id));
attmap.put(a.ParentID,attlist);
attparID.add(a.ParentID);
pa_att_map.put(a.ParentID,a.ID);
}
}
}

map<ID,ID> lk_lkc_map = new map<ID,ID>();
set<ID> lkcID = new set<ID>();

for(license_key_clone__c lkc : [Select ID,Parent_license_key__c from license_key_clone__c 
                                where parent_license_key__c in : attparID])
  
  {
  
  lk_lkc_map.put(lkc.ID,lkc.Parent_license_key__c);
  lkcID.add(lkc.ID);                                
  }
set<ID> todel = new set<ID>();
list<attachment> dellist = new list<attachment>();

list<attachment> attcllst = new list<attachment>();
map<ID,list<attachment>> attclmap = new map<ID,list<attachment>>();

for(list<attachment> latt : [Select ID,ParentID,name,Bodylength from attachment where parentID in : lkcID] )
{

for(attachment eachatt : latt)
{
for(attachment trigatt : attmap.get(lk_lkc_map.get(eachatt.ParentID)))
{
if((trigatt.name == eachatt.name) && (trigatt.bodyLength == eachatt.BodyLength))
{
dellist.add(eachatt);
}
}
}
}


try
  {
  delete dellist;
  }
 catch (DmlException e)
    {
   system.debug(e);
    } 
}

}