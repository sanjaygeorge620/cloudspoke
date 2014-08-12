public with sharing class ProcessInstallations_CreateLicense {
    
    static Integer Test_License_Total;
    static Integer Failover_License_Total;
    static Integer Live_License_Total;
    static boolean CreateAllTestLicense;
    static boolean CreateAllFailOverLicense;
    
    
    
    
    public static void ProcessInstallations_CreateLicense(OpportunityLineItem OppLineItemRec ,Product2 ProductRec, Map<Asset, Asset_Item__c> AssetMap, List<Server__c> Servers, ID RecordtypeID, List<Case> Cases ,Boolean createLater)
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
        
        for(Asset keyset : AssetsNeedingLicenseKeySet ){
 //           system.debug('keyset - AssetsNeedingLicenseKeySet: ' + keyset);
            If(keyset.Environment__c == 'Test' & Test_License_Total > 0){
                AssetsNeedingLicenseKeysMap.put(keySet,AssetMap.get(keyset));
                if (CreateAllTestLicense = false){
                    Test_License_Total = Test_License_Total - 1 ;
                }
                
            }else{
                if(keyset.Environment__c == 'Failover' & Failover_License_Total > 0){
                    AssetsNeedingLicenseKeysMap.put(keySet,AssetMap.get(keyset));
                    if (CreateAllFailOverLicense = false){
                        Failover_License_Total = Failover_License_Total - 1 ;
                    }
                }Else{
                    AssetsNeedingLicenseKeysMap.put(keySet,AssetMap.get(keyset));
                }
            }
        }
        LicenseKeysCreated = CreateLicenseKeys(AssetsNeedingLicenseKeysMap, ProductRec, OppLineItemRec, Servers,createLater);
        ProcessInstallations_CreateLicenseCase.ProcessInstallations_CreateLicenseCase(LicenseKeysCreated, AssetsNeedingLicenseKeysMap, OppLineItemRec, Servers, recordTypeID, Cases, false);  
    
    }   
    public static Map<Asset,License_Key__c> CreateLicenseKeys(Map<Asset,Asset_Item__c> AssetMap, Product2 ProductRec, OpportunityLineItem OppLineItemRec, List<Server__c> Servers,Boolean createLater)
    { 
        
        Map<Asset,License_Key__c> newLicenseKeys = new Map<Asset,License_Key__c>();
        List<License_Key__c> LicenseKeys = new List<License_Key__c>();
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
 //       system.debug('QuantityValue:' + QuantityValue);
        
        for (Asset AssetRec : AssetMap.Keyset()){

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
 //   public static list<Case> createCases(Map<Asset,License_Key__c> licenseKeys,Map<Asset, Asset_Item__c> AssetMap, OpportunityLineItem OppLineItemRec, List<Server__c> Servers, Id recordTypeId, List<Case> Cases){  
 //       
 //       Integer index = 0;
//        system.debug('license-External recordtype in create license case: ' + recordTypeId);
 //       String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c;        
 //       List<Case> cases = new List<Case>();
        
  //      List<Asset> LicenseKeySet = new List<Asset>(licenseKeys.keyset());
        
        
 /*       for(Asset keyset : LicenseKeySet ){
        
            License_Key__c licenseKey = LicenseKeys.get(keyset);
                Asset_Item__c assetItem = AssetMap.get(keyset);
                
                string serverRecType = '';          
                for (Server__c serverRec : Servers){                //environment is not set on asset at this point, need to get from server.
//                  system.debug('server rec - case: ' + serverRec);
                    if (serverRec.id == keyset.Server__c) { 
                        serverRecType = serverRec.Server_Type__c;
//                      system.debug('serverRecType: ' + serverRecType);
                    }
               }   
               
               string ReturnValue;
               if (OppLineItemRec.Return__c == true){
                    ReturnValue = 'Yes';
               }else{
                    ReturnValue = 'No';
               }

                Case newCase = new Case();
                newCase.RecordtypeID = recordTypeId;
                newCase.Internal_Case_Account__c = OppLineItemRec.Opportunity.AccountId;
                //newCase.ContactId = opportunity.Ship_To__c;
               // newCase.ContactId = '0037000000t4gzv';
               newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
                newCase.Status = 'New';
                newCase.Impact__c = 'Enterprise';
                newCase.Urgency__c = 'Medium';
                newCase.Origin = 'Automation';
                newCase.Type = 'Request';
                newCase.Return__c = OppLineItemRec.Return__c;
                newCase.Category__c = 'License Request';
                newCase.Level_1__c = 'License – Additional';
                newCase.Node_ID_File_Name__c = 'Not Available';
                newCase.Version__c = 'Not Available';
                newCase.Specific_Licenses_Requested__c = 'Not Available';
                newCase.Subject = 'Order Processed - ' + assetItem.Name;
                newcase.Environment__c = serverRecType;
                newcase.License_Key__c = licenseKey.id;
                newCase.Description = 'Model: ' + keyset.Name + '\n'
                                    + 'Product: ' + assetItem.Name + '\n'
                                    + 'Quantity: ' + assetItem.Quantity__c + '\n'
                                    + 'Opportunity Number: ' + OppLineItemRec.Opportunity.Opportunity_Number__c + '\n'
                                    + 'Link: ' + baseUrl + '/' + licenseKey.id  + '\n'
                                    + 'Return: ' + ReturnValue;
                cases.add(newCase);
                
            
        }
  *///      system.debug('==== cases == ' + cases);
//        insert cases;
//       return cases;
 //   }
}