trigger populateFlexeraEntitlement on SAP_Sales_Order__c (after insert,after update,after undelete,after delete) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

     /*************************************
         *
         Description: Creating or updating the Flexera Entitlement record based upon the SAP Sales Order Number in SAP Sales Order
         *
         Date Created: 3/21/2012
         *
         Created By: Manoj Kolli
         *
     *****************************************/ 
    Set<Id> delsoIds = new Set<Id>();   
    Set<ID> ssoID = new Set<ID>();
    Set<ID> soID = new Set<ID>();
    Set<Flexera_Entitlement__c> FEid= new Set<Flexera_Entitlement__c>();
    Set<Flexera_Entitlement_Items__c> FEIid = new Set<Flexera_Entitlement_Items__c>();
    Set<String> sonum = new Set<String>();
    
    Set<String> sson = new Set<String>();
    List<Flexera_Entitlement__c> delflexEntitleList = new List<Flexera_Entitlement__c>();
    List<Flexera_Entitlement_Items__c> delflexEntitleitmList = new List<Flexera_Entitlement_items__c>();
    List<Flexera_Entitlement_Items__c> delflex = new List<Flexera_Entitlement_items__c>();
    List<Flexera_Entitlement__c> flexEntitleList = new List<Flexera_Entitlement__c>();
    Map<Id,Flexera_Entitlement__c> UpdatefeiMap = new Map<Id,Flexera_Entitlement__c>();
    Map<Id,SAP_Sales_Order__c> SoMp = new Map<Id,SAP_Sales_Order__c>();
    Set<String> AccIDst = new Set<String>();
    Map<String,Flexera_Account__c> Fa_mp = new Map<String,Flexera_Account__c>();
    List<Flexera_Entitlement_Items__c> feitoinsert = new List<Flexera_Entitlement_Items__c>();
    List<SAP_Sales_Order__c> ch_sso = new List<SAP_Sales_Order__c>();
    
    if(Trigger.isDelete)
    {
    for(SAP_Sales_Order__c sso : Trigger.Old)
    {
    soNum.add(sso.SAP_Sales_Order_Number__c);    
    }
    if(!sonum.isEmpty())
    {
    system.debug('xxxx' +Trigger.OLDmap.Keyset());
     delflex = [Select ID,Flexera_Entitlement_ID__c from Flexera_Entitlement_Items__c where Flexera_Entitlement_ID__r.Order_ID__c in:soNum];
     if(!delflex.isEmpty())
     {
     for(Flexera_Entitlement_Items__c FEI : delflex)
     {         
         IF(FEid.add(new Flexera_Entitlement__c(ID = FEI.Flexera_Entitlement_ID__c )))
         {
         delflexEntitleList.add(new Flexera_Entitlement__c(ID = FEI.Flexera_Entitlement_ID__c ));
         }
         
         IF(FEIid.add(FEI))
         {
         delflexEntitleitmList.add(FEI);
         }
     }
     }     
     } 
     if(!delflexEntitleitmList.isEmpty())
     {  
     Delete delflexEntitleitmList ;
     } 

 if(!delflexEntitleList.isEmpty())
     {     
     Delete delflexEntitleList;
     }        
    }
    
    else if(!Trigger.isDelete)
    {
    if(Trigger.IsUpdate)
    {
    soID.addall(Trigger.Newmap.Keyset());  
    }
    if(Trigger.isInsert || Trigger.isUndelete)
    {
    for(SAP_Sales_Order__c sso : Trigger.new)
    {
    system.debug('zzz0'+sso.Portal__c);
    if(sso.Portal__c == null)
    {
    soID.add(sso.ID);
    }
    } 
    }
    
    system.debug('zzz' +soID);
    
    
    if(Trigger.isInsert || Trigger.IsUpdate || Trigger.isUndelete)
    {
    if(!soID.isEmpty())
    {
   //  for(SAP_Sales_Order__c so : [Select ID,SAP_Contract__c,SAP_Contract__r.Account__r.Company_Number__c,SAP_Contract__r.Account__r.Name from SAP_Sales_Order__c where ID in:soID])
  for(SAP_Sales_Order__c so : (List<SAP_Sales_Order__c>)(database.query('Select ID,SAP_Contract__c,SAP_Contract__r.Account__r.Company_Number__c,SAP_Contract__r.Account__r.Name from SAP_Sales_Order__c where ID in:soID')))             
             {
             SoMp.put(so.ID,so);
             if(so.SAP_Contract__r != null && so.SAP_Contract__r.Account__r != null &&   so.SAP_Contract__r.Account__r.get('Company_Number__c')!=null)
                 AccIDst.add(so.SAP_Contract__r.Account__r.get('Company_Number__c')+'');
             }    
    }
    }
    
   system.debug('xxx1' +soMp);
        for(SAP_Sales_Order__c so : Trigger.New)
        {
            if(((Trigger.isInsert) && (so.SAP_Contract__c != null))||(Trigger.isUndelete)||((Trigger.isUpdate) && ((so.Close_Date__c != Trigger.oldMap.get(so.Id).Close_Date__c)
                ||(so.Account_ID__c != Trigger.oldMap.get(so.Id).Account_ID__c)||(so.Account_Name__c != Trigger.oldMap.get(so.Id).Account_Name__c))))
                {
                ssoID.add(so.ID);              
            }
        }
    
    
    for(Flexera_Account__c fa : [Select ID,Account_ID__c,Account_Name__c from Flexera_Account__c where Account_ID__c in: AccIDst])
    {
    fa_mp.put(fa.Account_ID__c,fa);
    }
    system.debug('XXXX' +ssoID);
    
    system.debug('XXX2' +fa_mp);
    
    Map<ID,List<Flexera_Entitlement_Items__c>> usethismap = CreateEntitlementItems.createItems(ssoID);
    
   if(!Trigger.isDelete)
   { 
     for(SAP_Sales_Order__c so : Trigger.New)
     {  
     if(usethismap.containskey(so.ID))
     {
     sson.add(so.SAP_Sales_Order_Number__c); 
     }
     }
     }  
     
     
    Map<Id,Flexera_Entitlement__c> feMap = new Map<Id,Flexera_Entitlement__c>([Select Id,Order_ID__c,Order_Date__c,Account_ID__c,
    SAP_Sales_Order_ID__c from Flexera_Entitlement__c where Order_ID__c IN :sson]);
    
    Map<Id,SAP_Sales_Order__c> soMap = new Map<Id,SAP_Sales_Order__c>([Select Id,SAP_Sales_Order_Number__c,Close_Date__c,Account_ID__c,
    Account_Name__c from SAP_Sales_Order__c where SAP_Sales_Order_Number__c IN :sson]);
    
    Map<String,Id> salesNumMap = new Map<String,Id>();
    for(SAP_Sales_Order__c son:soMap.values())
    {
        salesNumMap.put(son.SAP_Sales_Order_Number__c,son.Id);
    }
    Map<String,Id> orderIdMap = new Map<String,Id>();
    for(Flexera_Entitlement__c fe:feMap.values())
    {
        orderIdMap.put(fe.Order_ID__c,fe.Id);
    }
    
    for(SAP_Sales_Order__c s:soMap.values())
    {
    
        if(orderIdMap.containsKey(s.SAP_Sales_Order_Number__c))
        {
            UpdatefeiMap.put(orderIdMap.get(s.SAP_Sales_Order_Number__c),feMap.get(orderIdMap.get(s.SAP_Sales_Order_Number__c)));
            UpdatefeiMap.get(orderIdMap.get(s.SAP_Sales_Order_Number__c)).Order_Date__c = soMap.get(salesNumMap.get(s.SAP_Sales_Order_Number__c)).Close_Date__c;
            UpdatefeiMap.get(orderIdMap.get(s.SAP_Sales_Order_Number__c)).SAP_Sales_Order_ID__c = soMap.get(salesNumMap.get(s.SAP_Sales_Order_Number__c)).ID;
            if(fa_mp.containskey(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+''))
              {
            UpdatefeiMap.get(orderIdMap.get(s.SAP_Sales_Order_Number__c)).Flexera_Account_ID__c = fa_mp.get(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+'').ID ;
            UpdatefeiMap.get(orderIdMap.get(s.SAP_Sales_Order_Number__c)).Account_Name__c = fa_mp.get(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+'').Account_Name__c;
            UpdatefeiMap.get(orderIdMap.get(s.SAP_Sales_Order_Number__c)).Account_ID__c = fa_mp.get(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+'').Account_ID__c;            
              }
        }
        else
        {        
            Flexera_Entitlement__c flexEnt = new Flexera_Entitlement__c();
            flexEnt.Order_ID__c = soMap.get(salesNumMap.get(s.SAP_Sales_Order_Number__c)).SAP_Sales_Order_Number__c;
            flexEnt.Order_Date__c = soMap.get(salesNumMap.get(s.SAP_Sales_Order_Number__c)).Close_Date__c;
            flexEnt.Account_ID__c = soMap.get(salesNumMap.get(s.SAP_Sales_Order_Number__c)).Account_ID__c;            
            flexEnt.SAP_Sales_Order_ID__c = soMap.get(salesNumMap.get(s.SAP_Sales_Order_Number__c)).ID;
            if(fa_mp.containskey(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+''))
             {
            flexEnt.Flexera_Account_ID__c = fa_mp.get(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+'').ID;
            flexEnt.Account_Name__c = fa_mp.get(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+'').Account_Name__c;
            flexEnt.Account_ID__c = fa_mp.get(SoMp.get(s.ID).SAP_Contract__r.Account__r.get('Company_Number__c')+'').Account_ID__c;            
             }
            flexEntitleList.add(flexEnt);
        }            
    }
    
  
    if(flexEntitleList.size()>0)
    {
        insert flexEntitleList;
    }
    
    if(UpdatefeiMap.size()>0)
        {
            update UpdatefeiMap.values();
        } 
    
   system.debug('Flexera Entitlement List' +flexEntitleList);  
   
   for(Flexera_Entitlement__c fe : flexEntitleList) 
   {
   if(usethismap.containskey(fe.SAP_Sales_Order_ID__c))
   {
   for(Flexera_Entitlement_items__c fei : usethismap.get(fe.SAP_Sales_Order_ID__c))
   {
   fei.Flexera_Entitlement_ID__c = fe.ID;
      feitoinsert.add(fei);   
   }   

   }
   }
   
   system.debug('Flexera Entitlement items List' +feitoinsert);
   
   if(!feitoinsert.isempty()) 
   {
   insert feitoinsert;
   }
    
}

 
      
}