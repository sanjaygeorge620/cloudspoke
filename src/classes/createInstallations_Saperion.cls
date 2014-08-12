public class createInstallations_Saperion
{
public static void create(Map<OpportunityLineItem, List<Product2>> Sap_Map,Set<ID> ProductRec_ProductModelIds,Boolean isFuture)
{
set<ID> oppIDs = new Set<ID>();
set<ID> accIDs = new Set<ID>();
Map<ID,ID> oppIDs_CreateCase = new Map<ID,ID>();
Map<ID,Set<ID>> oppIDs_Prod = new Map<ID,Set<ID>>();
Map<ID,ID> oppIDs_AgrID = new Map<ID,ID>();
Map<ID,ID> oppIDs_AcctID = new Map<ID,ID>();
List<Case> castoIns = new List<Case>();
String ProductModelName = 'Basic Software Maintenance Agreement-SAPERION';
List<Agreement__c> ExistingAgreementList = new List<Agreement__c>();

for(OpportunityLineItem keyset : Sap_Map.keyset())
{
oppIDs.add(keyset.opportunityID);
accIDs.add(keyset.Opportunity.AccountId);
oppIDs_AcctID.put(keyset.opportunityID,keyset.Opportunity.AccountId);
}
if(!oppIDs.isEmpty())
{
 
   ExistingAgreementList = [select Name, account__c from Agreement__c where account__c =:accIDs and name like '%SAPERION%'];
   
    for(id keyset : oppIDs_AcctID.keyset())
   {
   boolean agreementfound = false;
   if(!ExistingAgreementList.isEmpty())
   {  
   for(Agreement__c Ag : ExistingAgreementList)
   {
   if(Ag.account__c == oppIDs_AcctID.get(keyset) && !agreementfound)
   {
   oppIDs_AgrID.put(keyset,Ag.id);
   agreementfound = True;
   castoIns.addall(createEnv_Servers(Ag,Sap_Map,ProductRec_ProductModelIds,isFuture));
   }
   }
   if(!agreementfound)
   {
      Agreement__c agreement = new Agreement__c();
                    agreement.Account__c = oppIDs_AcctID.get(keyset);
                    agreement.Opportunity__c = keyset;
                    agreement.Name = ProductModelName;
                    agreement.Status__c = 'Active';
                    system.debug('agreement.name: ' + agreement.name);
                    
            insert agreement;  
            oppIDs_AgrID.put(keyset,agreement.id);
            castoIns.addall(createEnv_Servers(agreement,Sap_Map,ProductRec_ProductModelIds,isFuture)); 
   }
   }
   else
   {
 Agreement__c agreement = new Agreement__c();
                    agreement.Account__c = oppIDs_AcctID.get(keyset);
                    agreement.Opportunity__c = keyset;
                    agreement.Name = ProductModelName;
                    agreement.Name = ProductModelName;
                    agreement.Status__c = 'Active';
                    system.debug('agreement.name: ' + agreement.name);
                    
            insert agreement;  
            oppIDs_AgrID.put(keyset,agreement.id);
             castoIns.addall((createEnv_Servers(agreement,Sap_Map,ProductRec_ProductModelIds,isFuture)));  
   }
   }  
   
 
if(!castoIns.isEmpty())
{
insert castoIns;
}
}
}




public static List<Case> createEnv_Servers(Agreement__c agr,Map<OpportunityLineItem,List<Product2>> Sap_Map,Set<ID> ProductRec_ProductModelIds,Boolean isFuture)
{
     List<Case> returnthis = new List<Case>();
     List<Server__c> returnList = new List<Server__c>();
     List<String> envTypeList = new List<String>();
     map<String,Environment__c> envmap = new map<String,Environment__c>();
     
     List<Environment__c> envList = [SELECT Account__c, Agreement_Name__c, Name, Environment_Type__c,Id 
                                     FROM Environment__c where Agreement_Name__c =: Agr.ID];
       if(!envList.isEmpty())
       {
       for(Environment__c en : envList)
       {       
       if(en.Environment_Type__c == 'Live')
       {
       envmap.put(en.Environment_Type__c,en);
       envTypeList.add(en.Environment_Type__c);
       }
       else
       {
       envTypeList.add('Live');             
       for(String st : envTypeList)
       {
       Environment__c enL = new Environment__c(Environment_Type__c = st,Agreement_Name__c = agr.ID,Account__c = agr.Account__c);
       envList.add(enL);
       }
       
       insert envList;
       for(Environment__c env : envList)
       {
       envmap.put(env.Environment_Type__c,env);
       }        
       }
       }
       }
       else
       {       
       envTypeList.add('Live');             
       for(String st : envTypeList)
       {
       Environment__c enL = new Environment__c(Environment_Type__c = st,Agreement_Name__c = agr.ID,Account__c = agr.Account__c);
       envList.add(enL);
       }
       
       insert envList;
       for(Environment__c en : envList)
       {
       envmap.put(en.Environment_Type__c,en);
       }       
       }       
   returnList = createServers(agr.Account__c,envmap); 
    
   Map<ID, Product_Model__c> ProductModelRecordsMap = new Map<ID,Product_Model__c> ();
   Product_Model__c productModelRec = new Product_Model__c();
   ProductModelRecordsMap = ProductModelMap(ProductRec_ProductModelIds); 
   Map<Asset, Asset_Item__c> Assets = new Map<Asset, Asset_Item__c>();   
   List<Case> CasesToInsert = new List<Case>();
   Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
   Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
   Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();
   
   for(OpportunityLineItem keyset : Sap_Map.Keyset())
   {
   For(Product2 productRec: Sap_Map.get(keyset))
   {
   system.debug('XXXXXXXXXXX' +productRec);
   system.debug('XXXXXXXXXXXXXXXXXX' +ProductModelRecordsMap.containskey(productRec.Product_Model__c));  
   system.debug('XXXXXXXXXXXXXXXXXX' +ProductModelRecordsMap.Keyset().Size());  
   
   productModelRec = ProductModelRecordsMap.get(productRec.Product_Model__c); 
   If(productModelRec.Asset_Required__c == true)
   {
   Assets = Saperion_CreateAssets.CreateAssets(Keyset,ProductRec,returnList, productModelRec.id, ProductModelRec.Name, 'Yes', isFuture);
   }
    if (ProductRec.License_Required__c == true)
    {
  returnthis =  Saperion_CreateAssets.ProcessInstallations_CreateLicense(Keyset,ProductRec, Assets, returnList, recordTypeID, CasesToInsert,isFuture);
    }
   
   }
   }   
   return returnthis;   
 
}


      public static Map<ID,Product_Model__c> ProductModelMap(Set<ID> ProductModelRecIds)
    {
        Map<ID, Product_Model__c> ProductModelMap_Return = new Map<ID,Product_Model__c>() ;
        List<Product_Model__c> productModelRecList = new List<Product_Model__c>([select Asset_Required__c
                                                                                                    , Name 
                                                                                                    , Id
                                                                                                    from Product_Model__c 
                                                                                                    where id in :ProductModelRecIDs]);
        system.debug('productModelRecList:' + productModelRecList);
        For (Product_Model__c ProductModelRec : productModelRecList){
            ProductModelMap_Return.put(productModelRec.id, ProductModelRec);
        }   
        return ProductModelMap_Return;                                                                                              
    }


public static List<Server__c> createServers(id acctid, map<String,Environment__c> envmap)
     {
     List<Server__c> returnList = new List<Server__c>();
     
     for(string s : envmap.keyset())
     {
     if(s == 'Live')
     {     
     returnList.addall(createServers(acctid,envmap.get(s),'Live',envmap.get(s).Agreement_Name__c,1));      
     }
     }
     if(!returnList.isEmpty())
     {
   //  insert returnList;
     }
     return returnList;
     }
     
     public static List<Server__c> createServers(id acctid,Environment__c Env,string subty,id AgrID,integer qty)
      {
      List<Server__c> existList = new List<Server__c>();
      existList = [Select ID,Account__c,Agreement__c,Environment__c,License_Status__c,Server_Type__c,Server_Sub_Type__c from Server__c where Account__c =: acctid and Agreement__c =: AgrID and Environment__c =: Env.ID and Server_Type__c =: Env.Environment_Type__c and Server_Sub_Type__c =: subty limit 1];
      List<Server__c> returnList = new List<Server__c>();
      if(!existList.isEmpty())
      {
      returnList.add(existList[0]);
      }
      else
      {
      for(Integer i =0;i< qty;i++)
      {
      Server__c sc = new Server__c();
      sc.Account__c = acctid;
      sc.Agreement__c = AgrID;
      sc.Environment__c = Env.ID;
      sc.License_Status__c = 'Not Licensed';
      sc.Server_Type__c = Env.Environment_Type__c;
      sc.Server_Sub_Type__c = subty;      
      returnList.add(sc);
      insert returnList;
      }
      }
      return returnList;
      }     

}