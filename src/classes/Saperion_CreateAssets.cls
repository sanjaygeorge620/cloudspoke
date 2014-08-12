public with sharing class Saperion_CreateAssets
{
    
    static Integer Test_Asset_Total;
    static Integer Failover_Asset_Total;
    static Integer Live_Asset_Total;
    Static Boolean existingAsset = false;
    Static Boolean checkTestAssetAllowed = true;
    static Boolean checkFailoverAssetAllowed = true;
    static boolean checkNeeded = true;          //is there a check needed to see if there are available servers per the product rec
    
    public static Map<Asset, Asset_Item__c> CreateAssets(OpportunityLineItem OppLineItemRec 
    ,Product2 ProductRec, List<Server__c> Servers, ID ProductModelID, String ProductModelName
    , String CheckExistingAssets, Boolean createLater)
    {
        List<Perceptive_Config_Value__c> pcv = new List<Perceptive_Config_Value__c>();
    map<String,Perceptive_Config_Value__c> key_desc = new map<String,Perceptive_Config_Value__c>();    
    pcv = [Select ID,Name,Custom_Attribute_1__c,Custom_Attribute_2__c,Description__c,Perceptive_Config_Option__c,sort__c,value__c
           from Perceptive_Config_Value__c where Perceptive_Config_Option__r.Name = 'Unit of Measure'];    
        if(!pcv.isEmpty())
        {
        for(Perceptive_Config_Value__c pc : pcv)
        {
            if(pc.name != null || pc.name != '')
            {
        key_desc.put(pc.Name,pc);
            }
        }   
        }
        
        //check to see if have any assets already for that server - won't create asset, just create asset item then
        Map<Server__c, Integer> ServersNeedingAssets = new Map<Server__c, Integer>();
        List<Server__c> ServersNeedingAssetsList = new List<Server__c>();           //list of servers needing assets.
        List<Asset>AssetsToAddItems = new List<Asset>();                            //list of assets that need Items.
        Map<Asset, Asset_Item__c>AssetsCreated = new Map<Asset, Asset_Item__c>();
        List<Asset>ExistingAssets = new List<Asset>();
        
        Integer Live_Existing_Asset_Total = 0;
        Integer Test_Existing_Asset_Total = 0;
        Integer Failover_Existing_Asset_Total = 0;
        Live_Asset_Total = 1;
        system.debug('productRec - within CreateAsset: ' + ProductRec);
        system.debug('productRec.Test_Environments_Allowed__c - within CreateAsset: ' + productRec.Test_Environments_Allowed__c);
        //Test_Asset_Total = (productRec.Test_Environments_Allowed__c) != null ? (productRec.Test_Environments_Allowed__c).intValue() : 0 ;
        if (productRec.Test_Environments_Allowed__c != null)
        {
            Test_Asset_Total = (productRec.Test_Environments_Allowed__c).intValue();
            checkTestAssetAllowed = true;
        }
        else
        {  
            Test_Asset_Total = 0;
            checkTestAssetAllowed = false;
        }
        System.debug('Test_Asset_Total - before processing:' + Test_Asset_Total);
        system.debug('checkTestAssetAllowed - before processing:' + checkTestAssetAllowed);
    //  Failover_Asset_Total = (productRec.Failover_Environments_Allowed__c) != null ? (productRec.Failover_Environments_Allowed__c).intValue() : 0;
        if (productRec.Failover_Environments_Allowed__c != null){
            Failover_Asset_Total =(productRec.Failover_Environments_Allowed__c).intValue();
            checkFailoverAssetAllowed = true;
        }else{  
            checkFailoverAssetAllowed = false;
            Failover_Asset_Total = 0;
        }
        System.debug('Failover_Asset_Total - before processing:' + Failover_Asset_Total);
        system.debug('checkFailoverAssetAllowed - before processing:' + checkTestAssetAllowed);
        Integer AvailableAssets;
        Integer AssetsNeeded;
        Integer NumberAssetsToCreate;
        Integer AssetsAllowed;

        Asset AssetRecHold;
        //per server, look to see if asset related to the asset name has already been created, if not create
        system.debug('Servers = in Create Asset: ' + Servers);
        if(CheckExistingAssets == 'Yes'){
            ExistingAssets = [select id, name, Environment__c, Server__c, Server__r.ID from Asset where Server__c in :Servers];
            system.debug('ExistingAssets:' + ExistingAssets);
        }
        ServersNeedingAssetsList.addall(Servers);
     
        //loop through ServersNeedingAssets.  need to check if anymore are allowed
        system.debug('ServersNeedingAssetsList:' + ServersNeedingAssetsList);
        
        list<Asset> assad = new list<Asset>();
        
        assad = createNewAssets(ServersNeedingAssetsList, ProductModelID, ProductModelName, createLater);
        
        for(Asset ast : assad)
        {
        
        AssetsToAddItems.add(ast);
        
        }       
        
 
        //create assetItems
        List<Asset_Item__c> AssetItems = new List<Asset_Item__c>();
        system.debug('AssetsToAddItems:' + AssetsToAddItems);
        Integer QuantityValue = (OppLineitemRec.Quantity).intValue();
        Integer FinalQuantityValue;
        if (productRec.Product_Bundled__c == true){                 //if product was part of a bundle, take value off sub Product
            if(productRec.SubProduct_Quantity__c != null){          //if sub product value = null, then use the opp line item value
                QuantityValue = (productRec.SubProduct_Quantity__c).intValue();
            }
        }else{
            If(OppLineItemRec.Return__c == true){
                QuantityValue = (productRec.SubProduct_Quantity__c).intValue();
            }
        }
        
        system.debug('QuantityValue:' + QuantityValue);
        system.debug('ProductRec.ID:'+ ProductRec.id);
        system.debug('ProductRec:'+ ProductRec);
        for (Asset AssetRec : AssetsToAddItems)
        {
            system.debug('AssetRec right before quantity checks: ' + AssetRec);
            //if product rec test environments allowed or failover environments allowed < opplineitem or submitemquantity, use the lower #
            string serverRecType = '';          
            for (Server__c serverRec : Servers)
            {                //environment is not set on asset at this point, need to get from server.
                system.debug('server rec - case: ' + serverRec);
                if (serverRec.id == AssetRec.Server__c) 
                { 
                    serverRecType = serverRec.Server_Type__c;
                    system.debug('serverRecType: ' + serverRecType);
                }
            }   
  
      
                    FinalQuantityValue = QuantityValue;
           
            system.debug('finalQuantityValue:' + finalQuantityValue);
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:' + ProductRec.part_number__c);
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:' + OppLineitemRec.price_type__c);
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:' + AssetRec);
            
                string pt_desc = '';
                if(Upgrade_Table__c.getall().containskey(ProductRec.part_number__c+'-'+OppLineitemRec.price_type__c))
                {            
             pt_desc = key_desc.get(Upgrade_Table__c.getall().get(ProductRec.part_number__c+'-'+OppLineitemRec.price_type__c).New_Unit_of_Measure__c).Description__c;    
                }
                else
                {
                if(key_desc.Containskey(OppLineitemRec.price_type__c))
                {
              pt_desc =  key_desc.get(OppLineitemRec.price_type__c).Description__c;
              }
                }
            Asset_Item__c assetItemRec = new Asset_Item__c(Name = ProductRec.Name
                                        , Quantity__c = FinalQuantityValue
                                        , Status__c = 'Active'
                                        , Product__c = ProductRec.Name_Abbrev__c            //used this field because couldn't populate ID in my temp table
                                        , Opportunity__c = OppLineitemRec.OpportunityId
                                        , Price_Type__c =  OppLineitemRec.Price_Type__c 
                                        , Price_Type_Description__c = pt_desc                  
                                        , Server__c = AssetRec.Server__c
                                        , Asset__c = AssetRec.id);
          if(createLater)                          //Create Asset Item Clone Later
          {
          assetItemRec.Process_Later__c = True;
          }                                         
                                        
            AssetItems.add(assetItemRec);                           
            AssetsCreated.put(AssetRec, assetItemRec);  
            
        }
        
        insert AssetItems;  
            
        return AssetsCreated;                           
        //return AssetsToAddItems;
                                        
                                                                
    }
    
    public static List<Asset> CreateNewAssets(List<Server__c> ServerRec, ID ProductModelId,String ProductModelName
    , Boolean createLater)
    { 
        list<Asset> astlst = new list<Asset>();
        
        for(Server__c ServerRec1 : ServerRec )
        {
            Asset assset = new Asset(Name = ProductModelName
                                        , Server__c = serverRec1.Id 
                                        , AccountId = serverRec1.Account__c
                                        , Agreement__c = serverRec1.Agreement__c
                                        , Product_Model__c = ProductModelID);
          if(createLater)                          //Create Asset Clone Later
          {
          assset.Process_Later__c = True;
          }                              
                                        
           astlst.add(assset);
                                        
        }        
                    
        insert astlst;
        
       // system.debug('assset - in CreateNewAssets:' + assset);
        return astlst;
    }
    
    public static List<Case> isUpgradereq(List<Server__c> srvlst,product2 prod,OpportunityLineItem otm,map<String,Perceptive_Config_Value__c> key_desc,boolean createLater)
    {        
        map<ID,List<OpportunityLineItem>> sizingcaseList = new map<ID,List<OpportunityLineItem>>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();    
        String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c;  
        
        
    List<Asset_Item__c> newAssets = new List<Asset_Item__c>();     
    List<Asset_Item__c> toExclude = new List<Asset_Item__c>();
    List<Asset_Item__c> toUpdate = new List<Asset_Item__c>();
    List<License_Key__c> toExcludelKey = new List<License_Key__c>();     
    List<License_Key__c> toUpdatelKey = new List<License_Key__c>();     
    List<License_Key__c> toInslKey = new List<License_Key__c>();         
    List<Case> castoIns = new List<Case>();  
    Map<String,string> astname = new Map<String,string>();
    Map<ID,Asset_Item__c> astmap = new Map<ID,Asset_Item__c>();    
        string p_desc = '';
        string uom = '';
        
    boolean retval = True;  
               
    map<ID,List<License_Key__c>> lkmap = new map<ID,List<License_Key__c>>();    
    toExclude = [SELECT Asset__c,Asset__r.name,Asset__r.Server__c,End_Date__c,Environment__c,Exclude__c,Id,LX_DataLoadId__c,LX_SFDC_ID__c,
                 LX_Siebel_ID__c,Name,Opportunity__c,Part_Number__c,Price_Type_Description__c,Price_Type__c,
                 Process_later__c,Product__c,Quantity__c,SAP_Contract_Item__c,Server__c,Start_Date__c,Status__c,Upgrade_From__c
                 FROM Asset_Item__c where Asset__r.Server__c in: srvLst and Part_Number__c =: prod.Part_Number__c];    
        
    toExcludelKey = [Select ID,asset_item__c from License_Key__c where asset_item__c =: toExclude];        
    
        if(!toExcludelKey.isEmpty())
        {
        for(license_key__c lk : toExcludelKey)
        {
        if(lkmap.containskey(lk.asset_item__c))
        {
        lkmap.get(lk.asset_item__c).add(lk);
        }
        else
        {
        List<License_Key__c> temp = new List<License_Key__c>();
            temp.add(lk);
            lkmap.put(lk.asset_item__c,temp);
        }
        }
        }
        
    if(Upgrade_Table__c.getall().keyset().size() > 0)
    {
    if(Upgrade_Table__c.getall().containskey(prod.part_number__c+'-'+otm.price_type__c))
    {
    if(Upgrade_Table__c.getall().get(prod.part_number__c+'-'+otm.price_type__c).New_Unit_of_Measure__c != '')
    {
    for(Asset_Item__c atm : toExclude)
    {
    if(atm.Part_Number__c == prod.part_number__c)
    {     
     
        p_desc = key_desc.get(Upgrade_Table__c.getall().get(prod.part_number__c+'-'+otm.price_type__c).New_Unit_of_Measure__c).Description__c;
        uom = Upgrade_Table__c.getall().get(prod.part_number__c+'-'+otm.price_type__c).New_Unit_of_Measure__c;
        asset_item__c nwast = new Asset_Item__c(Asset__c = atm.Asset__c,End_Date__c = atm.End_date__c,Exclude__c = createLater,
                                          LX_DataLoadId__c = atm.LX_DataLoadId__c,                                          LX_Siebel_ID__c = atm.LX_Siebel_ID__c,Name = atm.name,Opportunity__c = atm.Opportunity__c,
                                          Price_Type_Description__c = p_desc,Price_Type__c = uom,Process_later__c = createLater,Product__c = atm.product__c,
                                          Quantity__c = atm.quantity__c,SAP_Contract_Item__c = atm.SAP_Contract_Item__c,Server__c = atm.server__c,Start_Date__c = atm.start_date__c,
                                          Status__c = atm.status__c,Upgrade_From__c = atm.id);
        
    atm.status__c = 'Inactive';
    atm.exclude__c = True; 
    astmap.put(atm.id,atm);
    newAssets.add(nwast);
    toUpdate.add(atm);    
    astname.put(atm.Part_Number__c,atm.Asset__r.name);
    }   
    }
        if(!newAssets.isEmpty())
        {
        Update toUpdate;
        insert newAssets;
         
        for(Asset_Item__c aim : newAssets)
        {
        if(Upgrade_Table__c.getall().get(prod.part_number__c+'-'+otm.price_type__c).New_License__c == '' ||
           Upgrade_Table__c.getall().get(prod.part_number__c+'-'+otm.price_type__c).New_License__c == 'No')
        {   
        if(lkmap.containskey(aim.Upgrade_From__c))
        {
        for(License_Key__c lk : lkmap.get(aim.upgrade_From__c))
        {
        lk.asset_item__c = aim.id;    
        toUpdatelKey.add(lk);
        }
        }   
        }  
         else if(Upgrade_Table__c.getall().get(prod.part_number__c+'-'+otm.price_type__c).New_License__c == 'Yes')
         {
          Integer QuantityValue = (otm.Quantity).intValue();
          Integer FinalQuantityValue;
           
          FinalQuantityValue = QuantityValue;
                
  
             
            License_Key__c LicenseKeyRec = new License_Key__c(Name = Prod.Name
                                        , Quantity__c = FinalQuantityValue
                                        , Asset__c = aim.Asset__c
                                        , Asset_Item__c = aim.id
                                        );
            if(createLater)
            {
            LicenseKeyRec.Process_later__c = True;
            }     

            if(astmap.containskey(aim.Upgrade_From__c)) 
            {
            LicenseKeyRec.server__c = astmap.get(aim.Upgrade_From__c).Asset__r.server__c;
            }       
                                        
            toInslKey.add(LicenseKeyRec);
         
         }
        }
        
        if(!toUpdatelkey.isEmpty())    
        {
        update toUpdatelkey;    
        }
        if(!toInslKey.isEmpty())
        {
        insert toInslkey;
        for(Asset_Item__c aim : newAssets)
        {
         for(License_Key__c lky : toInslkey)
         {
             if(lky.Asset_Item__c == aim.id )
             {
         Case newCase = new Case();
                newCase.RecordtypeID = recordTypeId;
                newCase.Internal_Case_Account__c = otm.Opportunity.AccountId;             
                newCase.Originating_Company__c = otm.Originating_Company__c;
                newCase.Opportunity_Type__c = otm.Opportunity.Type;
                newCase.Admin_Contact_Name__c = otm.Opportunity.Admin_Contact__r.Name;
                newCase.Admin_Contact_Email__c = otm.Opportunity.Admin_Contact__r.Email; 
                newCase.Admin_Contact_Phone__c = otm.Opportunity.Admin_Contact__r.Phone;
                newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
                newCase.Status = 'New';
                newCase.Impact__c = 'Enterprise';
                newCase.Urgency__c = 'Medium';
                newCase.Origin = 'Automation';
                newCase.Type = 'Request';
                newCase.Return__c = False;
                newCase.Category__c = 'License Request';
                newCase.Level_1__c = 'License – Additional';
                newCase.Node_ID_File_Name__c = 'Not Available';
                newCase.Version__c = 'Not Available';
                newCase.Specific_Licenses_Requested__c = 'Not Available';
                newCase.Subject = 'Order Processed - ' + aim.Name;
                newcase.Environment__c = aim.Environment__c;
                newcase.License_Key__c = lky.id;
        if(astname.containskey(aim.part_number__c))
        {
                newCase.Description = 'Model: ' + astname.get(aim.part_number__c) + '\n';
        }
                newCase.Description = newCase.Description+'';
                newCase.Description = newCase.Description + 'Product: ' + aim.Name + '\n'
                                    + 'Quantity: ' + aim.Quantity__c + '\n'
                                    + 'Opportunity Number: ' + Otm.Opportunity.get('Opportunity_Number__c') + '\n'
                                    + 'Link: ' + baseUrl + '/' + lky.id  + '\n'
                                    + 'Return: No';
                castoIns.add(newCase);         
         }  
         }
        }
           /* if(!castoIns.isEmpty())
            {
            insert castoIns;
            }  */
            
        }  
        }    
    }   
    }
    }   
 
 return castoIns;
    }
    
    static Integer Test_License_Total;
    static Integer Failover_License_Total;
    static Integer Live_License_Total;
    static boolean CreateAllTestLicense;
    static boolean CreateAllFailOverLicense;
    
        public static List<Case> ProcessInstallations_CreateLicense(OpportunityLineItem OppLineItemRec ,Product2 ProductRec, Map<Asset, Asset_Item__c> AssetMap, List<Server__c> Servers, ID RecordtypeID, List<Case> Cases ,Boolean createLater)
    {
        
//      system.debug('license-External recordtype in create license: ' + recordTypeId);
        Map<Asset,License_Key__c> LicenseKeysCreated = new Map<Asset,License_Key__c>();
        
        Test_License_Total = (productRec.Test_Licenses_Allowed__c) != null ? (productRec.Test_Licenses_Allowed__c).intValue() : 0 ;
        if(Test_License_Total > 0){
            CreateAllTestLicense = true;
        }
        Failover_License_Total = (productRec.Failover_Licenses_Allowed__c) != null ? (productRec.Failover_Licenses_Allowed__c).intValue() : 0;
        if(Failover_License_Total > 0){
            CreateAllFailOverLicense = true;
        }
        Integer AvailableLicenses;
        Integer LicensesNeeded;
        Integer NumberLicensesToCreate;
        List<Asset> AssetsNeedingLicenseKeySet = new List<Asset>(AssetMap.keyset());
        Map<Asset, Asset_Item__c> AssetsNeedingLicenseKeysMap = new Map<Asset, Asset_Item__c>();
        
        for(Asset keyset : AssetsNeedingLicenseKeySet )
        {
 //           system.debug('keyset - AssetsNeedingLicenseKeySet: ' + keyset);
            If(keyset.Environment__c == 'Test' & Test_License_Total > 0)
            {
                AssetsNeedingLicenseKeysMap.put(keySet,AssetMap.get(keyset));
                if (CreateAllTestLicense = false)
                {
                    Test_License_Total = Test_License_Total - 1 ;
                }
                
            }
            else
            {
                if(keyset.Environment__c == 'Failover' & Failover_License_Total > 0)
                {
                    AssetsNeedingLicenseKeysMap.put(keySet,AssetMap.get(keyset));
                    if (CreateAllFailOverLicense = false)
                    {
                        Failover_License_Total = Failover_License_Total - 1 ;
                    }
                }
                Else
                {
                    AssetsNeedingLicenseKeysMap.put(keySet,AssetMap.get(keyset));
                }
            }
        }
        LicenseKeysCreated = CreateLicenseKeys(AssetsNeedingLicenseKeysMap, ProductRec, OppLineItemRec, Servers,createLater);
        List<Case> ipInsert = ProcessInstallations_CreateLicenseCase.ProcessInstallations_CreateLicenseCase(LicenseKeysCreated, AssetsNeedingLicenseKeysMap, OppLineItemRec, Servers, recordTypeID, Cases, false);  
        
       
        system.debug('XXXXXXXXXX----------------' +ipInsert);
        
        return ipInsert;
    
    }   
    public static Map<Asset,License_Key__c> CreateLicenseKeys(Map<Asset,Asset_Item__c> AssetMap, Product2 ProductRec, OpportunityLineItem OppLineItemRec, List<Server__c> Servers,Boolean createLater)
    { 
        
        Map<Asset,License_Key__c> newLicenseKeys = new Map<Asset,License_Key__c>();
        List<License_Key__c> LicenseKeys = new List<License_Key__c>();
        Integer QuantityValue = (OppLineitemRec.Quantity).intValue();
        Integer FinalQuantityValue;
        if (productRec.Product_Bundled__c == true){                 //if product was part of a bundle, take value off sub Product
            if(productRec.SubProduct_Quantity__c != null)
            {          //if sub product value = null, then use the opp line item value
                QuantityValue = (productRec.SubProduct_Quantity__c).intValue();
            }
        }
        else
        {
            If(OppLineItemRec.Return__c == true)
            {
                QuantityValue = (productRec.SubProduct_Quantity__c).intValue();
            }
        }
 //       system.debug('QuantityValue:' + QuantityValue);
        
        for (Asset AssetRec : AssetMap.Keyset())
        {

            //if product rec test environments allowed or failover environments allowed < opplineitem or submitemquantity, use the lower #
            string serverRecType = '';  
            system.debug('Servers List - license Creation: ' + Servers);        
            for (Server__c serverRec : Servers){                //environment is not set on asset at this point, need to get from server.
//                system.debug('server rec - case: ' + serverRec);
                if (serverRec.id == AssetRec.Server__c) { 
                    serverRecType = serverRec.Server_Type__c;
 //                   system.debug('serverRecType: ' + serverRecType);
                }
            }   
 //           System.debug('ServerRecType - License Case Creation'+ serverRecType);
//            System.debug('ProductRec - License Case Creation'+ productRec);
            if (serverRecType  == 'Test'){          //don't have environment on Asset, but it is put on the assetItem
                if (productRec.Test_Licenses_Allowed__c != null){
//                    system.debug('productRec.Test_Licenses_Allowed__c).intValue():' + (productRec.Test_Licenses_Allowed__c).intValue());
//                    system.debug('Test QuantityValue: ' + QuantityValue);
                    if((productRec.Test_Licenses_Allowed__c).intValue() < QuantityValue){
//                        system.debug('in Test, productValue < Quantity Value');
                        FinalQuantityValue = (productRec.Test_Licenses_Allowed__c).intValue();
                    }else{
                        FinalQuantityValue = QuantityValue;
                    }
                        
                }else{
                        FinalQuantityValue = QuantityValue;
                }
            }else{
                if (serverRecType == 'Failover'){
                    if (productRec.Failover_Licenses_Allowed__c != null){
 //                       system.debug('productRec.Failover_Licenses_Allowed__c).intValue():' + (productRec.Failover_Licenses_Allowed__c).intValue());
 //                       system.debug('Failover QuantityValue: ' + QuantityValue);
                        if((productRec.Failover_Licenses_Allowed__c).intValue() < QuantityValue){
 //                           system.debug('in Failover, productValue < Quantity Value');
                            FinalQuantityValue = (productRec.Failover_Licenses_Allowed__c).intValue();
                        }else{
                            FinalQuantityValue = QuantityValue;
                        }   
                    }else{
                        FinalQuantityValue = QuantityValue;
                    }   
                }else{
                    FinalQuantityValue = QuantityValue;
                }       
            }   
 //           system.debug('finalQuantityValue:' + finalQuantityValue);
            
            
            
            License_Key__c LicenseKeyRec = new License_Key__c(Name = ProductRec.Name
                                        , Quantity__c = FinalQuantityValue
                                        , Asset__c = AssetRec.id
                                        , Asset_Item__c = AssetMap.get(assetRec).id
                                        , server__c = AssetRec.Server__c);
            if(createLater)
            {
            LicenseKeyRec.Process_later__c = True;
            }                                        
                                        
            LicenseKeys.add(LicenseKeyRec); 

            newLicenseKeys.put(assetRec, licenseKeyRec);                        
                            
        }
        insert LicenseKeys;
        
        return newLicenseKeys;
    }
    
    
    
}