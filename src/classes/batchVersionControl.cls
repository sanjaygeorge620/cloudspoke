Global class batchVersionControl implements Database.Batchable<sObject>
{
Global final String Query;
Global final boolean isClass;    
Global final boolean isVFPage;
Global final boolean isTrigger;
Global final boolean isComponent;

Global Map<String,Set<ID>> extCompMap = new Map<String,Set<ID>>();
Global Map<String,Set<ID>> extCheckedOutMap = new Map<String,Set<ID>>();
Global Set<ID> checkedoutset = new Set<ID>();
Global Set<ID> extset = new Set<ID>();
Global List<Version_Control__c> extVC = new List<Version_Control__c>();
Global Map<ID,Sub_Version__c> subvMap = new Map<ID,Sub_Version__c>();
Global Map<ID,Version_Control__c> vcMap = new Map<ID,Version_Control__c>();
Global Set<ID> extCompset = new Set<ID>();

   Global batchVersionControl(String S,String T)
  {
  if(T == 'Apex Class')
  {
  Query = S;
  isClass = True;
  isVFPage = False;
  isTrigger = False;
  isComponent = False;    
  system.debug('$$$$$$$$' +Query);
  extVC = [Select Component_ID__c,Component_Name__c,Component_Type__c,Status__c,inRepository__c,(Select ID,ID__c,Api_Version__c,SystemModstamp__c,BodyCrc__c,LengthWithoutComments__c,Version__c from SubVersions__r order by Version__c desc limit 1) from Version_Control__c where Component_Type__c = 'Apex Class'];
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  extCompset.add(vc.Component_ID__c);
  vcMap.put(vc.Component_ID__c,vc);
  }
  Map<ID,APexClass> acMap =  new Map<ID,APexClass>([Select ID,name from ApexClass where ID in: extCompset]);
  List<Version_Control__c> clsLst = new List<Version_Control__c>();
  for(id i : vcMap.keyset())
  {
  if(acMap.containskey(i))
  {
  }
  else
  {
  Version_Control__c acl = vcMap.get(i);
  if(!acl.Component_Name__c.contains('--Deleted--'))
  {
  acl.isDeleted__c = True;
  acl.Component_Name__c = acl.Component_Name__c + '--Deleted--'+System.now().format('yyyy_MM_dd_hh_mm_ss');
  clsLst.add(acl);
  }
  }  
  }
  if(!clsLst.isEmpty())
  {
  update clsLst;
  }
  }
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  List<Sub_Version__c> sver = new List<Sub_Version__c>();
  sver = vc.SubVersions__r;
  if(!sver.isEmpty())
  {
  subvMap.put(vc.id,sver[0]);
  }
  }
  }
  
  {  if(!extVC.isEmpty())

  for(Version_Control__c VC : extVC)
  {
  if(VC.Status__c == 'Locked')
  {
  if(extCheckedOutMap.containskey(VC.Component_Type__c))
  {
  extCheckedOutMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCheckedOutMap.put(VC.Component_Type__c,temp);
  }
  }
  if(VC.inRepository__c)
  {
  if(extCompMap.containskey(VC.Component_Type__c))
  {
  extCompMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCompMap.put(VC.Component_Type__c,temp);
  }
  }
  }
  extset = extCompMap.get('Apex Class'); 
  checkedoutset = extCheckedOutMap.get('Apex Class');
  }
  }
  if(T == 'Apex Trigger')
  {
  Query = S;
  isClass = False;
  isVFPage = False;
  isTrigger = True;
  isComponent = False;    
  
  system.debug('$$$$$$$$' +Query);
  extVC = [Select Component_ID__c,Component_Name__c,Component_Type__c,Status__c,inRepository__c,(Select ID,ID__c,Api_Version__c,BodyCrc__c,SystemModstamp__c,LengthWithoutComments__c,Version__c from SubVersions__r order by Version__c desc limit 1) from Version_Control__c where Component_Type__c = 'Apex Trigger'];
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  extCompset.add(vc.Component_ID__c);
  vcMap.put(vc.Component_ID__c,vc);
  }
  Map<ID,ApexTrigger> acMap =  new Map<ID,ApexTrigger>([Select ID,name from ApexTrigger where ID in: extCompset]);
  List<Version_Control__c> clsLst = new List<Version_Control__c>();
  for(id i : vcMap.keyset())
  {
  if(acMap.containskey(i))
  {
  }
  else
  {
  Version_Control__c acl = vcMap.get(i);
  if(!acl.Component_Name__c.contains('--Deleted--'))
  {
  acl.isDeleted__c = True;
  acl.Component_Name__c = acl.Component_Name__c + '--Deleted--'+System.now().format('yyyy_MM_dd_hh_mm_ss');
  clsLst.add(acl);
  }
  }  
  }
  if(!clsLst.isEmpty())
  {
  update clsLst;
  }
  }
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  List<Sub_Version__c> sver = new List<Sub_Version__c>();
  sver = vc.SubVersions__r;
  if(!sver.isEmpty())
  {
  subvMap.put(vc.id,sver[0]);
  }
  }
  }
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c VC : extVC)
  {
  if(VC.Status__c == 'Locked')
  {
  if(extCheckedOutMap.containskey(VC.Component_Type__c))
  {
  extCheckedOutMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCheckedOutMap.put(VC.Component_Type__c,temp);
  }
  }
  if(VC.inRepository__c)
  {
  if(extCompMap.containskey(VC.Component_Type__c))
  {
  extCompMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCompMap.put(VC.Component_Type__c,temp);
  }
  }
  }
  extset = extCompMap.get('Apex Trigger'); 
  checkedoutset = extCheckedOutMap.get('Apex Trigger');
  }  
  }
  
  if(T == 'Visualforce Page')
  {
  Query = S;
  isClass = False;
  isVFPage = True;
  isTrigger = False;
  isComponent = False;  
  system.debug('$$$$$$$$' +Query);
  extVC = [Select Component_ID__c,Component_Name__c,Component_Type__c,Status__c,inRepository__c,(Select ID,ID__c,Api_Version__c,BodyCrc__c,SystemModstamp__c,LengthWithoutComments__c,Version__c from SubVersions__r order by Version__c desc limit 1) from Version_Control__c where Component_Type__c = 'Visualforce Page'];
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  extCompset.add(vc.Component_ID__c);
  vcMap.put(vc.Component_ID__c,vc);
  }
  Map<ID,ApexPage> acMap =  new Map<ID,ApexPage>([Select ID,name from ApexPage where ID in: extCompset]);
  List<Version_Control__c> clsLst = new List<Version_Control__c>();
  for(id i : vcMap.keyset())
  {
  if(acMap.containskey(i))
  {
  }
  else
  {
  Version_Control__c acl = vcMap.get(i);
  if(!acl.Component_Name__c.contains('--Deleted--'))
  {
  acl.isDeleted__c = True;  
  acl.Component_Name__c = acl.Component_Name__c + '--Deleted--'+System.now().format('yyyy_MM_dd_hh_mm_ss');
  clsLst.add(acl);
  }
  }  
  }
  if(!clsLst.isEmpty())
  {
  update clsLst;
  }
  }
  
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  List<Sub_Version__c> sver = new List<Sub_Version__c>();
  sver = vc.SubVersions__r;
  if(!sver.isEmpty())
  {
  subvMap.put(vc.id,sver[0]);
  }
  }
  }
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c VC : extVC)
  {
  if(VC.Status__c == 'Locked')
  {
  if(extCheckedOutMap.containskey(VC.Component_Type__c))
  {
  extCheckedOutMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCheckedOutMap.put(VC.Component_Type__c,temp);
  }
  }
  if(VC.inRepository__c)
  {
  if(extCompMap.containskey(VC.Component_Type__c))
  {
  extCompMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCompMap.put(VC.Component_Type__c,temp);
  }
  }
  }
  extset = extCompMap.get('Visualforce Page'); 
  checkedoutset = extCheckedOutMap.get('Visualforce Page');
  }
  }
  
    if(T == 'Apex Component')
  {  
  Query = S;
  isClass = False;
  isVFPage = False;
  isTrigger = False;
  isComponent = True;  
  
  system.debug('$$$$$$$$' +Query);
  extVC = [Select Component_ID__c,Component_Name__c,Component_Type__c,Status__c,inRepository__c,(Select ID,ID__c,Api_Version__c,BodyCrc__c,SystemModstamp__c,LengthWithoutComments__c,Version__c from SubVersions__r order by Version__c desc limit 1) from Version_Control__c where Component_Type__c = 'Apex Component'];
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  extCompset.add(vc.Component_ID__c);
  vcMap.put(vc.Component_ID__c,vc);
  }
  Map<ID,ApexComponent> acMap =  new Map<ID,ApexComponent>([Select ID,name from ApexComponent where ID in: extCompset]);
  List<Version_Control__c> clsLst = new List<Version_Control__c>();
  for(id i : vcMap.keyset())
  {
  if(acMap.containskey(i))
  {
  }
  else
  {
  Version_Control__c acl = vcMap.get(i);
  if(!acl.Component_Name__c.contains('--Deleted--'))
  {
  acl.isDeleted__c = True;  
  acl.Component_Name__c = acl.Component_Name__c + '--Deleted--'+System.now().format('yyyy_MM_dd_hh_mm_ss');
  clsLst.add(acl);
  }
  }  
  }
  if(!clsLst.isEmpty())
  {
  update clsLst;
  }
  }
  
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c vc : extVC)
  {
  List<Sub_Version__c> sver = new List<Sub_Version__c>();
  sver = vc.SubVersions__r;
  if(!sver.isEmpty())
  {
  subvMap.put(vc.id,sver[0]);
  }
  }
  }
  
  if(!extVC.isEmpty())
  {
  for(Version_Control__c VC : extVC)
  {
  if(VC.Status__c == 'Locked')
  {
  if(extCheckedOutMap.containskey(VC.Component_Type__c))
  {
  extCheckedOutMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCheckedOutMap.put(VC.Component_Type__c,temp);
  }
  }
  if(VC.inRepository__c)
  {
  if(extCompMap.containskey(VC.Component_Type__c))
  {
  extCompMap.get(VC.Component_Type__c).add(VC.Component_ID__c);
  }
  else
  {
  set<ID> temp = new set<ID>();
  temp.add(VC.Component_ID__c);
  extCompMap.put(VC.Component_Type__c,temp);
  }
  }
  }
  extset = extCompMap.get('Apex Component'); 
  checkedoutset = extCheckedOutMap.get('Apex Component');
  }
  }
  }


    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    return Database.getQueryLocator(Query);        
    }
    
    global void execute(Database.BatchableContext BC,  List<sObject> recordList)
    {
    if(isClass)
    {
    List<Version_Control__c> VCLST = new List<Version_Control__c>();
    List<Sub_Version__c> SVLST = new List<Sub_Version__c>();
    List<Attachment> ATTLST = new List<Attachment>();
    Map<ID,ApexClass> clsMap = new Map<ID,ApexClass>();
    Map<ID,ApexClass> All_clsMap = new Map<ID,ApexClass>();    
    Map<ID,ApexClass> Batch_clsMap = new Map<ID,ApexClass>();    
    List<ApexClass> allclasslst = new list<ApexClass>();
    
    
    for(sObject aCL : recordList)
    {
    ApexClass aCLs = (ApexClass)aCL;    
    Batch_clsMap.put(aCLs.id,aCLs);    
    }
    
    String Query1 = 'SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp FROM ApexClass where NamespacePrefix = \'\'';
    allclasslst = Database.query(query1);
    
    if(recordList.getSObjectType() == ApexClass.sObjectType)
    {    
    for(apexClass aCLs : allclasslst)
    {      
    All_clsMap.put(aCLs.id,aCLs);
    }

    for(sObject aCL : recordList)
    {
    ApexClass aCLs = (ApexClass)aCL;    
    if(!extset.contains(aCLs.id))
    {
    clsMap.put(aCLs.id,aCLs);
    }
    }
     for(sObject aCL : recordList)
    {
    ApexClass aCLs = (ApexClass)aCL;
    if(!extset.contains(aCLs.id))
    {
    Version_Control__c vc = new Version_Control__c(Component_ID__c = aCLs.id,Component_Name__c = aCLs.Name + '_Class',Component_Type__c = 'Apex Class',Status__c = 'Unlocked');
    VCLST.add(vc);
    }
    }
       if(!VCLST.isEMpty())
    {
    insert VCLST;
    
    for(Version_Control__c vct : VCLST)
    {
    ApexClass acls = clsMap.get(vct.Component_ID__c);
    //ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp
    Sub_Version__c sv = new Sub_Version__c();
    sv.Parent_Version__c = vct.id;
    sv.Api_Version__c = acls.ApiVersion;
    sv.BodyCrc__c = acls.BodyCrc.format();
    sv.CreatedById__c = acls.CreatedById;
    sv.CreatedDate__c = acls.CreatedDate;
    sv.Id__c = acls.Id;
    sv.IsValid__c = acls.IsValid;
    sv.LastModifiedById__c = acls.LastModifiedById;            
    sv.LastModifiedDate__c = acls.LastModifiedDate;            
    sv.LengthWithoutComments__c = acls.LengthWithoutComments;            
    sv.Name__c = acls.Name;            
    sv.NamespacePrefix__c = acls.NamespacePrefix;                            
    sv.Status__c = acls.Status;
    sv.SystemModstamp__c = acls.SystemModstamp; 
    sv.Version__c = 1;       
    SVLST.add(sv);
    }
    if(!SVLST.isEmpty())
    {
    insert SVLST;
    
    for(Sub_Version__c svt : SVLST)
    {
    ApexClass acls = clsMap.get(svt.Id__c);
    
    String bodyStr=acls.Body;
    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    
    ATTLST.Add(att);
    }
    if(!ATTLST.isEMpty())
    {
    insert ATTLST;
    
    for(Version_Control__c vct : VCLST)
    {
    vct.inRepository__c = True;
    }
    Update VCLST;
    }    
    }
    }
     
    //-------------------------------------Begin Checked Out Class Version Control------------------------------------
    
    List<Sub_Version__c> SVLST_Locked = new List<Sub_Version__c>();
    List<Attachment> ATTLST_Locked = new List<Attachment>();
    
    
    for(ID coi : subvMap.keyset())
    {
    Sub_Version__c sv_Latest = subvMap.get(coi);
    ApexClass cl = All_clsMap.get(sv_Latest.id__c);
    if(Batch_clsMap.containskey(sv_Latest.id__c))
    {
    if(cl.BodyCrc.format() != sv_Latest.BodyCrc__c && cl.LengthWithoutComments != sv_Latest.LengthWithoutComments__c)
    {   
    Sub_Version__c sv = new Sub_Version__c();
    sv.Parent_Version__c = coi;
    sv.Api_Version__c = cl.ApiVersion;
    sv.BodyCrc__c = cl.BodyCrc.format();
    sv.CreatedById__c = cl.CreatedById;
    sv.CreatedDate__c = cl.CreatedDate;
    sv.Id__c = cl.Id;
    sv.IsValid__c = cl.IsValid;
    sv.LastModifiedById__c = cl.LastModifiedById;            
    sv.LastModifiedDate__c = cl.LastModifiedDate;            
    sv.LengthWithoutComments__c = cl.LengthWithoutComments;            
    sv.Name__c = cl.Name;            
    sv.NamespacePrefix__c = cl.NamespacePrefix;                            
    sv.Status__c = cl.Status;
    sv.SystemModstamp__c = cl.SystemModstamp; 
    sv.Version__c = sv_Latest.Version__c + 1;       
    SVLST_Locked.add(sv);
    }
    }
    }
    if(!SVLST_Locked.isEmpty())
    {
    insert SVLST_Locked;
    for(Sub_Version__c svt : SVLST_Locked)
    {
    ApexClass acls = All_clsMap.get(svt.Id__c);    
    String bodyStr=acls.Body;    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    ATTLST_Locked.Add(att);
    }
    if(!ATTLST_Locked.isEMpty())
    {
    insert ATTLST_Locked;
    }
    }
    }
    }                                     //END APEXCLASS Logic
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(isTrigger)                         //BEGIN APEXTRIGGER LOGIC
    {
    List<Version_Control__c> VCLST = new List<Version_Control__c>();
    List<Sub_Version__c> SVLST = new List<Sub_Version__c>();
    List<Attachment> ATTLST = new List<Attachment>();
    Map<ID,ApexTrigger> trgMap = new Map<ID,ApexTrigger>();
    Map<ID,ApexTrigger> All_trgMap = new Map<ID,ApexTrigger>();    
    Map<ID,ApexTrigger> Batch_trgMap = new Map<ID,ApexTrigger>();    
    List<ApexTrigger> allTriglst = new list<ApexTrigger>();
    
    
    for(sObject aCL : recordList)
    {
    ApexTrigger aCLs = (ApexTrigger)aCL;    
    Batch_trgMap.put(aCLs.id,aCLs);    
    }
    
    String Query1 = 'SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp,TableEnumOrId,UsageAfterDelete,UsageAfterInsert,UsageAfterUndelete,UsageAfterUpdate,UsageBeforeDelete,UsageBeforeInsert,UsageBeforeUpdate,UsageIsBulk FROM ApexTrigger where NamespacePrefix = \'\'';
    allTriglst = Database.query(query1);
    
    if(recordList.getSObjectType() == ApexTrigger.sObjectType)
    {    
    for(ApexTrigger aCLs : allTriglst)
    {      
    All_trgMap.put(aCLs.id,aCLs);
    }

    for(sObject aCL : recordList)
    {
    ApexTrigger aCLs = (ApexTrigger)aCL;    
    if(!extset.contains(aCLs.id))
    {
    trgMap.put(aCLs.id,aCLs);
    }
    }
     for(sObject aCL : recordList)
    {
    ApexTrigger aCLs = (ApexTrigger)aCL;
    if(!extset.contains(aCLs.id))
    {
    Version_Control__c vc = new Version_Control__c(Component_ID__c = aCLs.id,Component_Name__c = aCLs.Name + '_Trigger',Component_Type__c = 'Apex Trigger',Status__c = 'Unlocked');
    VCLST.add(vc);
    }
    }
       if(!VCLST.isEMpty())
    {
    insert VCLST;
    
    for(Version_Control__c vct : VCLST)
    {
    ApexTrigger acls = trgMap.get(vct.Component_ID__c);
    //ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp,TableEnumOrId,
    //UsageAfterDelete,UsageAfterInsert,UsageAfterUndelete,UsageAfterUpdate,UsageBeforeDelete,UsageBeforeInsert,UsageBeforeUpdate,UsageIsBulk
    Sub_Version__c sv = new Sub_Version__c();
    sv.Parent_Version__c = vct.id;
    sv.Api_Version__c = acls.ApiVersion;
    sv.BodyCrc__c = acls.BodyCrc.format();
    sv.CreatedById__c = acls.CreatedById;
    sv.CreatedDate__c = acls.CreatedDate;
    sv.Id__c = acls.Id;
    sv.IsValid__c = acls.IsValid;
    sv.LastModifiedById__c = acls.LastModifiedById;            
    sv.LastModifiedDate__c = acls.LastModifiedDate;            
    sv.LengthWithoutComments__c = acls.LengthWithoutComments;            
    sv.Name__c = acls.Name;            
    sv.NamespacePrefix__c = acls.NamespacePrefix;                            
    sv.Status__c = acls.Status;
    sv.SystemModstamp__c = acls.SystemModstamp; 
    sv.Version__c = 1;
    sv.TableEnumOrId__c = acls.TableEnumOrId;       
    sv.UsageAfterDelete__c = acls.UsageAfterDelete;
    sv.UsageAfterInsert__c = acls.UsageAfterInsert;
    sv.UsageAfterUndelete__c = acls.UsageAfterUndelete;
    sv.UsageAfterUpdate__c = acls.UsageAfterUpdate;
    sv.UsageBeforeDelete__c = acls.UsageBeforeDelete;
    sv.UsageBeforeInsert__c = acls.UsageBeforeInsert;
    sv.UsageBeforeUpdate__c = acls.UsageBeforeUpdate;                            
    sv.UsageIsBulk__c = acls.UsageIsBulk;                                
    SVLST.add(sv);
    }
    if(!SVLST.isEmpty())
    {
    insert SVLST;
    
    for(Sub_Version__c svt : SVLST)
    {
    ApexTrigger acls = trgMap.get(svt.Id__c);
    
    String bodyStr=acls.Body;
    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    
    ATTLST.Add(att);
    }
    if(!ATTLST.isEMpty())
    {
    insert ATTLST;
    
    for(Version_Control__c vct : VCLST)
    {
    vct.inRepository__c = True;
    }
    Update VCLST;
    }    
    }
    }
     
    //-------------------------------------Begin Checked Out Class Version Control------------------------------------
    
    List<Sub_Version__c> SVLST_Locked = new List<Sub_Version__c>();
    List<Attachment> ATTLST_Locked = new List<Attachment>();
    
    
    for(ID coi : subvMap.keyset())
    {
    Sub_Version__c sv_Latest = subvMap.get(coi);
    ApexTrigger cl = All_trgMap.get(sv_Latest.id__c);
    if(Batch_trgMap.containskey(sv_Latest.id__c))
    {
    if(cl.BodyCrc.format() != sv_Latest.BodyCrc__c && cl.LengthWithoutComments != sv_Latest.LengthWithoutComments__c)
    {   
    Sub_Version__c sv = new Sub_Version__c();
    sv.Parent_Version__c = coi;
    sv.Api_Version__c = cl.ApiVersion;
    sv.BodyCrc__c = cl.BodyCrc.format();
    sv.CreatedById__c = cl.CreatedById;
    sv.CreatedDate__c = cl.CreatedDate;
    sv.Id__c = cl.Id;
    sv.IsValid__c = cl.IsValid;
    sv.LastModifiedById__c = cl.LastModifiedById;            
    sv.LastModifiedDate__c = cl.LastModifiedDate;            
    sv.LengthWithoutComments__c = cl.LengthWithoutComments;            
    sv.Name__c = cl.Name;            
    sv.NamespacePrefix__c = cl.NamespacePrefix;                            
    sv.Status__c = cl.Status;
    sv.SystemModstamp__c = cl.SystemModstamp; 
    sv.Version__c = sv_Latest.Version__c + 1;   
    sv.TableEnumOrId__c = cl.TableEnumOrId;       
    sv.UsageAfterDelete__c = cl.UsageAfterDelete;
    sv.UsageAfterInsert__c = cl.UsageAfterInsert;
    sv.UsageAfterUndelete__c = cl.UsageAfterUndelete;
    sv.UsageAfterUpdate__c = cl.UsageAfterUpdate;
    sv.UsageBeforeDelete__c = cl.UsageBeforeDelete;
    sv.UsageBeforeInsert__c = cl.UsageBeforeInsert;
    sv.UsageBeforeUpdate__c = cl.UsageBeforeUpdate;                            
    sv.UsageIsBulk__c = cl.UsageIsBulk;    
    SVLST_Locked.add(sv);
    }
    }
    }
    if(!SVLST_Locked.isEmpty())
    {
    insert SVLST_Locked;
    for(Sub_Version__c svt : SVLST_Locked)
    {
    ApexTrigger acls = All_trgMap.get(svt.Id__c);    
    String bodyStr=acls.Body;    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    ATTLST_Locked.Add(att);
    }
    if(!ATTLST_Locked.isEMpty())
    {
    insert ATTLST_Locked;
    }
    }
    }
    }                               //END APEX TRIGGER CODE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    // BEGIN APEX PAGE LOGIC    
    if(isVFPage)
    {
    List<Version_Control__c> VCLST = new List<Version_Control__c>();
    List<Sub_Version__c> SVLST = new List<Sub_Version__c>();
    List<Attachment> ATTLST = new List<Attachment>();
    Map<ID,ApexPage> vfMap = new Map<ID,ApexPage>();
    Map<ID,ApexPage> All_vfMap = new Map<ID,ApexPage>();    
    Map<ID,ApexPage> Batch_vfMap = new Map<ID,ApexPage>();    
    List<ApexPage> allVFlst = new list<ApexPage>();
    
    
    for(sObject aCL : recordList)
    {
    ApexPage aCLs = (ApexPage)aCL;    
    Batch_vfMap.put(aCLs.id,aCLs);    
    }
    
    String Query1 = 'SELECT ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,IsAvailableInTouch,IsConfirmationTokenRequired,LastModifiedById,LastModifiedDate,Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp FROM ApexPage where NamespacePrefix = \'\'';
    allVFlst = Database.query(query1);
    
    if(recordList.getSObjectType() == ApexPage.sObjectType)
    {    
    for(ApexPage aCLs : allvflst)
    {      
    All_vfMap.put(aCLs.id,aCLs);
    }

    for(sObject aCL : recordList)
    {
    ApexPage aCLs = (ApexPage)aCL;    
    if(!extset.contains(aCLs.id))
    {
    vfMap.put(aCLs.id,aCLs);
    }
    }
     for(sObject aCL : recordList)
    {
    ApexPage aCLs = (ApexPage)aCL;
    if(!extset.contains(aCLs.id))
    {
    Version_Control__c vc = new Version_Control__c(Component_ID__c = aCLs.id,Component_Name__c = aCLs.Name + '_Page',Component_Type__c = 'Visualforce Page',Status__c = 'Unlocked');
    VCLST.add(vc);
    }
    }
       if(!VCLST.isEMpty())
    {
    insert VCLST;
    
    for(Version_Control__c vct : VCLST)
    {
    ApexPage acls = vfMap.get(vct.Component_ID__c);
    //ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,IsAvailableInTouch,IsConfirmationTokenRequired,LastModifiedById,LastModifiedDate,
    //Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp

    Sub_Version__c sv = new Sub_Version__c();
    sv.Parent_Version__c = vct.id;
    sv.Api_Version__c = acls.ApiVersion;
    sv.ControllerKey__c = acls.ControllerKey;
    sv.ControllerType__c = acls.ControllerType;    
    sv.CreatedById__c = acls.CreatedById;
    sv.CreatedDate__c = acls.CreatedDate;
    sv.Id__c = acls.Id;
    sv.Description__c = acls.Description;
    sv.LastModifiedById__c = acls.LastModifiedById;            
    sv.LastModifiedDate__c = acls.LastModifiedDate;            
    sv.IsAvailableInTouch__c = acls.IsAvailableInTouch;            
    sv.Name__c = acls.Name;            
    sv.NamespacePrefix__c = acls.NamespacePrefix;                            
    sv.IsConfirmationTokenRequired__c = acls.IsConfirmationTokenRequired;
    sv.SystemModstamp__c = acls.SystemModstamp; 
    sv.Version__c = 1;
    sv.MasterLabel__c = acls.MasterLabel;       
    SVLST.add(sv);
    }
    if(!SVLST.isEmpty())
    {
    insert SVLST;
    
    for(Sub_Version__c svt : SVLST)
    {
    ApexPage acls = vfMap.get(svt.Id__c);
    
    String bodyStr=acls.Markup;
    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    
    ATTLST.Add(att);
    }
    if(!ATTLST.isEMpty())
    {
    insert ATTLST;
    
    for(Version_Control__c vct : VCLST)
    {
    vct.inRepository__c = True;
    }
    Update VCLST;
    }    
    }
    }
     
    //-------------------------------------Begin Checked Out Class Version Control------------------------------------
    
    List<Sub_Version__c> SVLST_Locked = new List<Sub_Version__c>();
    List<Attachment> ATTLST_Locked = new List<Attachment>();
    
    
    for(ID coi : subvMap.keyset())
    {
    Sub_Version__c sv_Latest = subvMap.get(coi);
    ApexPage cl = All_VFMap.get(sv_Latest.id__c);
    if(Batch_VFMap.containskey(sv_Latest.id__c))
    {
    if(cl.SystemModstamp != sv_Latest.SystemModstamp__c)
    {
    Sub_Version__c sv = new Sub_Version__c();   
    sv.Api_Version__c = cl.ApiVersion;
    sv.ControllerKey__c = cl.ControllerKey;
    sv.ControllerType__c = cl.ControllerType;    
    sv.CreatedById__c = cl.CreatedById;
    sv.CreatedDate__c = cl.CreatedDate;
    sv.Id__c = cl.Id;
    sv.Description__c = cl.Description;
    sv.LastModifiedById__c = cl.LastModifiedById;            
    sv.LastModifiedDate__c = cl.LastModifiedDate;            
    sv.IsAvailableInTouch__c = cl.IsAvailableInTouch;            
    sv.Name__c = cl.Name;            
    sv.NamespacePrefix__c = cl.NamespacePrefix;                            
    sv.IsConfirmationTokenRequired__c = cl.IsConfirmationTokenRequired;
    sv.SystemModstamp__c = cl.SystemModstamp; 
    sv.MasterLabel__c = cl.MasterLabel; 
    sv.Parent_Version__c = coi;
    sv.Version__c = sv_Latest.Version__c + 1; 
    SVLST_Locked.add(sv);
    }
    }
    }
    if(!SVLST_Locked.isEmpty())
    {
    insert SVLST_Locked;
    for(Sub_Version__c svt : SVLST_Locked)
    {
    ApexPage acls = All_vfMap.get(svt.Id__c);    
    String bodyStr=acls.Markup;    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    ATTLST_Locked.Add(att);
    }
    if(!ATTLST_Locked.isEMpty())
    {
    insert ATTLST_Locked;
    }
    }
    }
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    // BEGIN APEX COMPONENT LOGIC    
    if(isComponent)
    {
    List<Version_Control__c> VCLST = new List<Version_Control__c>();
    List<Sub_Version__c> SVLST = new List<Sub_Version__c>();
    List<Attachment> ATTLST = new List<Attachment>();
    Map<ID,ApexComponent> vfMap = new Map<ID,ApexComponent>();
    Map<ID,ApexComponent> All_vfMap = new Map<ID,ApexComponent>();    
    Map<ID,ApexComponent> Batch_vfMap = new Map<ID,ApexComponent>();    
    List<ApexComponent> allVFlst = new list<ApexComponent>();
    
    
    for(sObject aCL : recordList)
    {
    ApexComponent aCLs = (ApexComponent)aCL;    
    Batch_vfMap.put(aCLs.id,aCLs);    
    }
    
    String Query1 = 'SELECT ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,LastModifiedById,LastModifiedDate,Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp FROM ApexComponent where NamespacePrefix = \'\'';
    allVFlst = Database.query(query1);
    
    if(recordList.getSObjectType() == ApexComponent.sObjectType)
    {    
    for(ApexComponent aCLs : allvflst)
    {      
    All_vfMap.put(aCLs.id,aCLs);
    }

    for(sObject aCL : recordList)
    {
    ApexComponent aCLs = (ApexComponent)aCL;    
    if(!extset.contains(aCLs.id))
    {
    vfMap.put(aCLs.id,aCLs);
    }
    }
     for(sObject aCL : recordList)
    {
    ApexComponent aCLs = (ApexComponent)aCL;
    if(!extset.contains(aCLs.id))
    {
    Version_Control__c vc = new Version_Control__c(Component_ID__c = aCLs.id,Component_Name__c = aCLs.Name + '_Component',Component_Type__c = 'Apex Component',Status__c = 'Unlocked');
    VCLST.add(vc);
    }
    }
       if(!VCLST.isEMpty())
    {
    insert VCLST;
    
    for(Version_Control__c vct : VCLST)
    {
    ApexComponent acls = vfMap.get(vct.Component_ID__c);
    //ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,IsAvailableInTouch,IsConfirmationTokenRequired,LastModifiedById,LastModifiedDate,
    //Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp

    Sub_Version__c sv = new Sub_Version__c();
    sv.Parent_Version__c = vct.id;
    sv.Api_Version__c = acls.ApiVersion;
    sv.ControllerKey__c = acls.ControllerKey;
    sv.ControllerType__c = acls.ControllerType;    
    sv.CreatedById__c = acls.CreatedById;
    sv.CreatedDate__c = acls.CreatedDate;
    sv.Id__c = acls.Id;
    sv.Description__c = acls.Description;
    sv.LastModifiedById__c = acls.LastModifiedById;            
    sv.LastModifiedDate__c = acls.LastModifiedDate;            
//  sv.IsAvailableInTouch__c = acls.IsAvailableInTouch;            
    sv.Name__c = acls.Name;            
    sv.NamespacePrefix__c = acls.NamespacePrefix;                            
//  sv.IsConfirmationTokenRequired__c = acls.IsConfirmationTokenRequired;
    sv.SystemModstamp__c = acls.SystemModstamp; 
    sv.Version__c = 1;
    sv.MasterLabel__c = acls.MasterLabel;       
    SVLST.add(sv);
    }
    if(!SVLST.isEmpty())
    {
    insert SVLST;
    
    for(Sub_Version__c svt : SVLST)
    {
    ApexComponent acls = vfMap.get(svt.Id__c);
    
    String bodyStr=acls.Markup;
    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    
    ATTLST.Add(att);
    }
    if(!ATTLST.isEMpty())
    {
    insert ATTLST;
    
    for(Version_Control__c vct : VCLST)
    {
    vct.inRepository__c = True;
    }
    Update VCLST;
    }    
    }
    }
     
    //-------------------------------------Begin Checked Out Class Version Control------------------------------------
    
    List<Sub_Version__c> SVLST_Locked = new List<Sub_Version__c>();
    List<Attachment> ATTLST_Locked = new List<Attachment>();
    
    
    for(ID coi : subvMap.keyset())
    {
    Sub_Version__c sv_Latest = subvMap.get(coi);
    ApexComponent cl = All_VFMap.get(sv_Latest.id__c);
    if(Batch_VFMap.containskey(sv_Latest.id__c))
    {
    if(cl.SystemModstamp != sv_Latest.SystemModstamp__c)
    {
    Sub_Version__c sv = new Sub_Version__c();   
    sv.Api_Version__c = cl.ApiVersion;
    sv.ControllerKey__c = cl.ControllerKey;
    sv.ControllerType__c = cl.ControllerType;    
    sv.CreatedById__c = cl.CreatedById;
    sv.CreatedDate__c = cl.CreatedDate;
    sv.Id__c = cl.Id;
    sv.Description__c = cl.Description;
    sv.LastModifiedById__c = cl.LastModifiedById;            
    sv.LastModifiedDate__c = cl.LastModifiedDate;            
//  sv.IsAvailableInTouch__c = cl.IsAvailableInTouch;            
    sv.Name__c = cl.Name;            
    sv.NamespacePrefix__c = cl.NamespacePrefix;                            
//  sv.IsConfirmationTokenRequired__c = cl.IsConfirmationTokenRequired;
    sv.SystemModstamp__c = cl.SystemModstamp; 
    sv.MasterLabel__c = cl.MasterLabel; 
    sv.Parent_Version__c = coi;
    sv.Version__c = sv_Latest.Version__c + 1; 
    SVLST_Locked.add(sv);
    }
    }
    }
    if(!SVLST_Locked.isEmpty())
    {
    insert SVLST_Locked;
    for(Sub_Version__c svt : SVLST_Locked)
    {
    ApexComponent acls = All_vfMap.get(svt.Id__c);    
    String bodyStr=acls.Markup;    
    Attachment att=new Attachment();
    att.Body=Blob.valueOf(bodyStr);
    att.Name= svt.Name__c + '_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
    att.parentId=svt.id;
    ATTLST_Locked.Add(att);
    }
    if(!ATTLST_Locked.isEMpty())
    {
    insert ATTLST_Locked;
    }
    }
    }
    }    
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }
}