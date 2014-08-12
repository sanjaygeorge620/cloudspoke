global class createAcuoInstallations
{ 
public static List<String> envTypeList = new List<String>();
    public void Cancel() 
    {
        editmode = False;
    }


    public PageReference back() 
    {
        string str = '/'+ EnvironmentID;
        PageReference pr = new PageReference(str);
         
        pr.setRedirect(True);
        return pr;
    }


    public void Edit() 
    {
    lstInner.clear();
    
    if(!mapping.isEmpty())
    {
       count = 1;
       for(Server_Asset_Association__c sa : mapping)
       {
       innerClass icl = new innerclass(count);       
       icl.servast = sa;
       mapInner.put(count,icl);
       count++;
       }
       lstInner.addall(mapInner.values());
    }
    if(servList!= null && servList.size() > 0 && assetitmList != null && assetitmList.size() > 0)
    {
    editmode = True;
    }
    }


    public List<Asset> assetList {get;set;}
    public List<Asset_Item__c> assetitmList {get;set;}
    public List<Server__c> servList {get;set;}
    public List<Server_Asset_Association__c> mapping {get;set;}    
    public List<Server_Asset_Association__c> toDel {get;set;}
    public List<Server_Asset_Association__c> mappinglist = new List<Server_Asset_Association__c>(); 
    public list<SelectOption> options {get;set;}
    public string EnvironmentID {get;set;}
    public string AgreementID {get;set;}
    public string EnvironmentType {get;set;}
    public boolean editMode {get;set;}
    public integer selectedRowIndex
    {get;set;}
    public List<innerClass> lstInner 
    {   get;set;    }
    public Map<integer,innerClass> mapInner
    {   get;set;    }
    public Integer count = 1;
    //{get;set;}
    
   
    
    public class innerClass
    {  
        public String recCount
        {get;set;}     
       
        public Server_Asset_Association__c servast 
        {get;set;}
        
        /*Inner Class Constructor*/
        public innerClass(Integer intCount)
        {
        recCount = String.valueOf(intCount);   
        servast = new Server_Asset_Association__c();            
        } 
    }
    
    public createAcuoInstallations() 
    {
    EnvironmentID = Apexpages.currentPage().getParameters().get('Eid');     
    EnvironmentType = Apexpages.currentPage().getParameters().get('Type');  
    AgreementID = Apexpages.currentPage().getParameters().get('Aid');
    lstInner = new List<innerClass>();
    mapInner = new Map<integer,innerClass>();
    addMore();
    selectedRowIndex = 0;
    todel = new List<Server_Asset_Association__c>();
    mapping = new List<Server_Asset_Association__c>();
    assetList = new List<Asset>();
     servList = new List<Server__c>();
    loadAssets();
    }
    
       public PageReference Save()
    {
        PageReference pr = new PageReference('/apex/Acuo_assetmap');
        pr.getparameters().put('Eid',EnvironmentID);
        pr.getparameters().put('Type',EnvironmentType);
        pr.getparameters().put('Aid',AgreementID);
        for(Integer j = 0;j<lstInner.size();j++)
        {
            mappinglist.add(lstInner[j].servast);
        } 
        upsert mappinglist;
        if(!toDel.isEmpty())
        {
        delete toDel;
        toDel.clear();
        }
        pr.setRedirect(True);
        return pr;
    }


    public void Add() 
    {
    count = count+1;
    addMore();        
    }
    
    public void Del() 
    {
        system.debug('selected row index---->'+selectedRowIndex);
        system.debug('Count---->'+Count);
        if(mapInner.containskey(selectedRowIndex))
        {
        if(mapInner.get(selectedRowIndex).servast.id != null)
        {
        toDel.add(mapInner.get(selectedRowIndex).servast);
        }
        mapInner.remove(selectedRowIndex);
        lstinner.clear();
        lstinner.addall(mapInner.values());
        // count = count - 1;
        }
    }
    
    public void addMore()
    {
        //call to the iner class constructor
        innerClass objInnerClass = new innerClass(count);        
        //add the record to the inner class list
        mapInner.put(count,objInnerClass);    
        lstinner.clear();
        lstinner.addall(mapInner.values());
        system.debug('lstInner---->'+lstInner);            
    }/* end addMore*/
    
  
    public List<SelectOption> getserverOptions()
    { 
    list<SelectOption> options = new list<SelectOption>();
    options.add(new SelectOption('','Select Server')); 
    if(!servList.isEmpty())
     {     
     for(Server__c ser : servList)
     {
     string str = '';
     if(ser.Server_Name__c != null)
     {
     str = ser.Server_Name__c + '--';
     }
     if(ser.Server_Sub_Type__c != null)
     {
     str = str + ser.Server_Sub_Type__c + '--';
     }
     if(ser.Server_Type__c != null)
     {
     str = str + ser.Server_Type__c;        
     }
    options.add(new SelectOption(ser.id,str)); 
     }    
     }     
    return options;
    }
    
        public List<SelectOption> getastitmOptions()
    { 
    list<SelectOption> options = new list<SelectOption>();
    options.add(new SelectOption('','Select Asset Item')); 
    if(assetitmList != null && !assetitmList.isEmpty())
     {     
     for(Asset_Item__c ser : assetitmList)
     {
     string str = '';
     if(ser.name != null)
     {
     str = ser.name+ '--';
     }
     if(ser.Asset__r.Acuo_Environment__c!= null)
     {
     str = str + ser.Asset__r.Acuo_Environment__c + '--';
     }
     if(ser.Quantity__c!= null)
     {
     str = str + ser.Quantity__c + '--';        
     }     
      if(ser.Part_Number__c!= null)
     {
     str = str + ser.Part_Number__c;        
     }
    options.add(new SelectOption(ser.id,str)); 
     }    
     }     
    return options;
    }

     public void loadAssets()
     {
     set<ID> servIDset = new Set<ID>();
     set<ID> AssetSet = new Set<ID>();

     if(EnvironmentType == 'Live')
     {
     servList = [Select ID,name,Server_Name__c ,Environment__c,Server_Sub_Type__c,Server_Type__c from Server__c where Environment__c =: EnvironmentID and Server_Type__c = 'Live'];
     assetList = [Select ID,name from Asset where Agreement__c =: AgreementID and Acuo_Environment__c = 'Live'];
     }
     else if(EnvironmentType == 'Failover')
     {
     servList = [Select ID,name,Server_Name__c ,Environment__c,Server_Sub_Type__c,Server_Type__c from Server__c where Environment__c =: EnvironmentID and Server_Type__c = 'Failover'];
     assetList = [Select ID,name from Asset where Agreement__c =: AgreementID and Acuo_Environment__c = 'Failover'];
     }
     
     if(!assetList.isEmpty())
     {
     for(Asset ast : assetList)
     {
     AssetSet.add(ast.ID); 
     }
     assetitmList = [SELECT Asset__c,Asset__r.AccountID,Asset__r.Account.name,Asset__r.Acuo_Environment__c, Name, End_Date__c, Environment__c, Exclude__c, Opportunity__c, Part_Number__c,  Product__c, Quantity__c, Id, SAP_Contract_Item__c,
     Server__c, Start_Date__c, Status__c FROM Asset_Item__c where asset__c in: assetList];
     }
     
     if(!servList.isEmpty())
     {     
     for(Server__c ser : servList)
     {
     servIDset.add(ser.ID);     
     }
     mapping = [Select ID,Account_Name__c,Asset_Item__c,Asset_Item__r.name,Server__c,Server__r.server_name__c from Server_Asset_Association__c where Server__c in: servIDset];
     if(!mapping.isEmpty())
     {
     editmode = false;
     }
     else
     {
     editmode = True;     
     }
     }
     
     }
     
    



//VF Page Controller





  webService static void create(ID dsc,ID oppID) 
  {
  
  List<Server__c> servList = new List<Server__c>();
  List<Asset> astList = new List<Asset>();
  List<Asset> newAstList = new List<Asset>();
  List<Asset_Item__c> astitmList = new List<Asset_Item__c>();
  map<string,Asset> astMap = new map<string,Asset>();
  set<ID> dscset = new Set<ID>();  
  Set<ID> ProductRec_ProductModelIds = new Set<ID>();
  Map<ID, Product_Model__c> ProductModelRecordsMap = new Map<ID,Product_Model__c> ();
  dscset.add(oppID);
  boolean proceed;
  String ProductModelName = 'Basic Software Maintenance Agreement-VNA';
  Agreement__c agreement = new Agreement__c();
  List<Agreement__c> ExistingAgreementList = new List<Agreement__c>();
  Product_Model__c productModelRec = new Product_Model__c();
  List<Data_Center_Requirements_Sizing__c> dscList = new List<Data_Center_Requirements_Sizing__c>();  
  List<Agreement__c> AgrList = new List<Agreement__c>();
  List<OpportunityLineItem> opl = new List<OpportunityLineItem>();
  List<Environment__c> EnvList = new List<Environment__c>();
  Map<OpportunityLineItem, List<Product2>> oppItmLst = new Map<OpportunityLineItem, List<Product2>>();
  dscList = [SELECT Account__c, Contract__c, CreatedById, CreatedDate, CurrencyIsoCode, Name, 
  IsDeleted, Failover_Application_Server__c, Failover_Central_Services__c, Failover_Migration__c, Failover_Routers__c, Failover_Test__c, 
  Failover_XDS__c, Installation_Details__c,Only_Create_Servers__c, Installed__c, LastActivityDate, LastModifiedById, LastModifiedDate, Live_Application_Server__c, 
  Live_Central_Services__c, Live_Migration__c, Live_Routers__c, Live_Test__c, Live_XDS__c, Opportunity__c,Opportunity__r.ID, OwnerId, Id, Status__c, 
  SystemModstamp FROM Data_Center_Requirements_Sizing__c where ID =: dsc];   
  
  for(Data_Center_Requirements_Sizing__c ds : dscList)
  {     
  oppItmLst = ProcessInstallations_GetProducts.ProcessInstallations_getProducts(ds.Opportunity__c);
  for(OpportunityLineItem otm : oppItmLst.Keyset())
  {
  if(otm.PricebookEntry.Product2.Use_Sizing_Tool__c)
  {
  for(Product2 p2 : oppItmLst.get(otm))
  {  
  ProductRec_ProductModelIds.add(p2.Product_Model__c);
  }
  }  
  }
  ProductModelRecordsMap = ProductModelMap(ProductRec_ProductModelIds);
  agreement = AgreementRecord(ds,ProductModelName);
  servList = createEnvironments(ds,agreement);
  if(!ds.Only_Create_Servers__c)
  {
  astList = [Select ID,Name,Server__c,AccountID,Agreement__c,Product_Model__c,Acuo_Environment__c from Asset where Agreement__c =: agreement.ID];
  if(!astList.isEmpty())
  {
  for(Asset ast : astList)
  {
  string key  = ast.Product_Model__c + ast.Acuo_Environment__c;
  astMap.put(key,ast);
  }
  }
  for(ID pmid : ProductModelRecordsMap.keyset())
  {
  if(ProductModelRecordsMap.get(pmid).Asset_Required__c == true)
  {
  for(string str : envTypeList)
  {
  string key = pmid+str;
  if(!astMap.containskey(key))
  {
  Asset assset = new Asset(Name = ProductModelRecordsMap.get(pmid).name                                        
                                        , AccountId = ds.Account__c
                                        , Agreement__c = agreement.Id
                                        , Product_Model__c = pmid
                                        , Acuo_Environment__c = str);
  newAstList.add(assset);
  }
  }
  }
  }
  if(!newAstList.isEmpty())
  {
  insert newAstList;
  for(asset ast : newAstList)
  {
  string key = ast.Product_Model__c + ast.Acuo_Environment__c;
  astMap.put(key,ast);
  }
  }
  
  for(OpportunityLineItem otm : oppItmLst.Keyset())
  {
  if(otm.PricebookEntry.Product2.Use_Sizing_Tool__c)
  {
  for(Product2 p2 : oppItmLst.get(otm))
  {
  if(ProductModelRecordsMap.containskey(p2.Product_Model__c))
  {
  productModelRec = ProductModelRecordsMap.get(p2.Product_Model__c);  
  If(productModelRec.Asset_Required__c == true)
    {
    for(string str : envTypeList)
    {
    string key = productModelRec.ID + str;
    if(astMap.containskey(key))
    {    
    Asset_Item__c assetItemRec = new Asset_Item__c(Name = p2.Name
                                        , Quantity__c = otm.Quantity
                                        , Status__c = 'Active'
                                        , Product__c = p2.Name_Abbrev__c            //used this field because couldn't populate ID in my temp table
                                        , Opportunity__c = otm.OpportunityId
                                        , Price_Type__c = otm.Price_Type__c
                                        , Asset__c = astMap.get(key).id);
            AstitmList.add(assetItemRec);                         
            
    }
    
    else
    {
    system.debug('----------------------Asset Missing for Product Model ID' +productModelRec.ID + '----Environment' +str);
    }
    }
    }
    }
  }
  }  
  }
  insert AstitmList;  
  }
  ds.Installed__c = True; 
  }
  update dscList;
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
    
    //CREATE Agreement
    
     public static Agreement__c AgreementRecord(Data_Center_Requirements_Sizing__c dsc, String ProductModelName)
     {
        Agreement__c ReturnAgreement = new Agreement__c();          
        List<Agreement__c> ExistingAgreementList = new List<Agreement__c>();
        ExistingAgreementList = [select Name, account__c from Agreement__c where account__c =: dsc.Account__c];
               
        If(!ExistingAgreementList.isEmpty())
        {
        for(Agreement__c agr1 : ExistingAgreementList)
        {
        system.debug('xxxx' +agr1);        
        if(agr1.name.contains('VNA'))
        {
        ReturnAgreement = agr1;
        system.debug('Acuo Agreement Exists');
        break;
        }
        }
        }

        if(ExistingAgreementList.isEmpty() || ReturnAgreement.id == null)
        {                              
            Agreement__c agreement = new Agreement__c();
                    agreement.Account__c = dsc.Account__c;
                    agreement.Opportunity__c = dsc.Opportunity__r.ID;
                    agreement.Name = ProductModelName;
                    agreement.Status__c = 'Active';
                    system.debug('agreement.name: ' + agreement.name);
                    
            insert agreement;
            ReturnAgreement = agreement;
        }  
        return ReturnAgreement;     
    }
    
    //Create Servers From Sizing Record
    
     public static List<Server__c> createEnvironments(Data_Center_Requirements_Sizing__c dsc,Agreement__c Agr)
     {
     List<Server__c> returnList = new List<Server__c>();
     map<String,Environment__c> envmap = new map<String,Environment__c>();
     List<Environment__c> envList = [SELECT Account__c, Agreement_Name__c, Name, Environment_Type__c,Id 
                                     FROM Environment__c where Agreement_Name__c =: Agr.ID];
       if(!envList.isEmpty())
       {
       for(Environment__c en : envList)
       {
       envmap.put(en.Environment_Type__c,en);
       if(en.Environment_Type__c == 'Live' || en.Environment_Type__c == 'Failover')
       {
       envTypeList.add(en.Environment_Type__c);
       }
       }
       }
       else
       {
       envTypeList.add('Live');
       envTypeList.add('Failover');
  
       Environment__c enL = new Environment__c(Environment_Type__c = 'Live',Agreement_Name__c = agr.ID,Account__c = dsc.Account__c);
       Environment__c enF = new Environment__c(Environment_Type__c = 'Failover',Agreement_Name__c = agr.ID,Account__c = dsc.Account__c);       
       envList.add(enL);
       envList.add(enF);
       insert envList;
       for(Environment__c en : envList)
       {
       envmap.put(en.Environment_Type__c,en);
       }       
       }
       
     returnList = createServers(dsc,envmap);
       
     return returnList;
     }
     
     public static List<Server__c> createServers(Data_Center_Requirements_Sizing__c dsc,map<String,Environment__c> envmap)
     {
     List<Server__c> returnList = new List<Server__c>();
     
     for(string s : envmap.keyset())
     {
     if(s == 'Live')
     {
     if(dsc.Live_Application_Server__c != 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Application',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Live_Application_Server__c)));
     }
     if(dsc.Live_Central_Services__c != 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Central Services',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Live_Central_Services__c)));
     }
     if(dsc.Live_Migration__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Migration',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Live_Migration__c)));
     }
     if(dsc.Live_Routers__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Routers',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Live_Routers__c)));
     }
     if(dsc.Live_Test__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Test',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Live_Test__c)));
     }
     if(dsc.Live_XDS__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'XDS',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Live_XDS__c)));
     }
     }
     if(s == 'Failover')
     {
     if(dsc.Failover_Application_Server__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Application',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Failover_Application_Server__c)));
     }
     if(dsc.Failover_Central_Services__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Central Services',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Failover_Central_Services__c)));
     }
     if(dsc.Failover_Migration__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Migration',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Failover_Migration__c)));
     }
     if(dsc.Failover_Routers__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Routers',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Failover_Routers__c)));
     }
     if(dsc.Failover_Test__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'Test',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Failover_Test__c)));
     }
     if(dsc.Failover_XDS__c!= 0)
     {
     returnList.addall(createServers(dsc,envmap.get(s),'XDS',envmap.get(s).Agreement_Name__c,integer.valueOf(dsc.Failover_XDS__c)));
     }
     }
     }
     if(!returnList.isEmpty())
     {
     insert returnList;
     }
     return returnList;
     }
     
      public static List<Server__c> createServers(Data_Center_Requirements_Sizing__c dsc,Environment__c Env,string subty,id AgrID,integer qty)
      {
      List<Server__c> returnList = new List<Server__c>();
      for(Integer i =0;i< qty;i++)
      {
      Server__c sc = new Server__c();
      sc.Account__c = dsc.Account__c;
      sc.Agreement__c = AgrID;
      sc.Environment__c = Env.ID;
      sc.License_Status__c = 'Not Licensed';
      sc.Server_Type__c = Env.Environment_Type__c;
      sc.Server_Sub_Type__c = subty;      
      returnList.add(sc);
      }
      return returnList;
      }     
}