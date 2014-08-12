public with sharing class ProcessInstallations_InactivateAssetItem {
    
    public static List<Asset_Item__c> ProcessInstallations_InactivateAssetItem(OpportunityLineItem OppLineItemRec 
                                                        , Product2 ProductRec
                                                        , List<Asset_Item__c> AssetItemsToUpdate //existing map of all assetsitems to update
                                                        , List<Server__c> ServersGiven
                                                        , Map<ID, List<Asset_Item__c>>  SwapAssetItemsMap
                                                        , ID ProductModelID
                                                        , String ProductModelName
                                                        , String CheckExistingAssets
                                                        , ID RecordtypeID
                                                        , List<Case> CasesToInsert
                                                        , Boolean createLater)
                                                        {
                                                            
                                                            
        system.debug('InactivateAssetItem-OppLineItemRec: ' + OppLineItemRec);
        system.debug('InactivateAssetItem-ProductRec: ' + ProductRec);
        system.debug('InactivateAssetItem-AssetItemsToUpdate: ' + AssetItemsToUpdate);
        system.debug('InactivateAssetItem-SwapAssetItemsMap: ' + SwapAssetItemsMap);
        system.debug('InactivateAssetItem-ProductModelID: ' + ProductModelID);
        system.debug('InactivateAssetItem-ProductModelName: ' + ProductModelName);
        system.debug('InactivateAssetItem-CheckExistingAssets: ' + CheckExistingAssets);
        system.debug('InactivateAssetItem-RecordtypeID: ' + RecordtypeID);
        system.debug('InactivateAssetItem-CasesToInsert: ' + CasesToInsert);
        
        
        List<Asset_Item__c> AssetItemsToReturn = new List<Asset_Item__c> ();
        
        List<Asset_Item__c> ProductAssetItemsToReturn = new List<Asset_Item__c> ();
        Map<Asset, Asset_Item__c> Assets = new Map<Asset, Asset_Item__c>();
        String errorMsg;
        
        boolean AssetKeyfound;  
        AssetItemsToReturn.addall(AssetItemsToUpdate);
        
        Integer SwapQuantityRemaining = (OppLineItemRec.Quantity).intValue();                               ///this is the quantity left after processing each asset quantity - initially starts as what customer is returning
        system.debug('serversGiven: ' + serversGiven);
        For(Server__c ServerRec : ServersGiven){
            
            list<Asset_Item__c> AssetItemsPerServer = new list<Asset_Item__c>();
            
            List<Server__c> Server = new List<Server__c>();
            List<ID> SwapAssetItemsMapKey = new List<ID>(SwapAssetItemsMap.keyset());
            system.debug('SwapAssetItemsMapKey - in InactivateAssetItem: ' + SwapAssetItemsMapKey);
            for(ID IDRec : SwapAssetItemsMapKey ){
                For(Asset_Item__c AssetItemRec: SwapAssetItemsMap.get(IDRec)){ 

                    if(AssetItemRec.Server__c == ServerRec.Id){
                        AssetItemsPerServer.add(AssetItemRec);
                    }
                }
            }   
            system.debug('AssetItemsPerServer: ' + AssetItemsPerServer);    
    //      If(AssetItemsPerServer.size()>0){
                SwapQuantityRemaining = (OppLineItemRec.Quantity).intValue();
                system.debug('start SwapQuantityRemaining: ' + SwapQuantityRemaining);
                List<Asset_Item__c> AssetItemsUpdated = new List<Asset_Item__c> ();
                system.debug('AssetItemsUpdated:' + AssetItemsUpdated);
                for (Asset_Item__c AssetItemRec: AssetItemsPerServer){
                    system.debug('assetItemRec: ' + AssetItemRec);
                    if(AssetItemRec.Product__c == ProductRec.Name_Abbrev__c){
                        if (SwapQuantityRemaining > 0){
                            //SwapQuantityRemaining will be negative if AssetitemRec.Quantity is larger, use negative value as value needed to create asset(value on productRec)
                            SwapQuantityRemaining = SwapQuantityRemaining - (AssetItemRec.Quantity__c).intValue();
                            system.debug('after subtraction = SwapQuantityRemaining: ' + SwapQuantityRemaining);
    
                            AssetItemRec.Status__c = 'Inactive';
                            AssetItemRec.Exclude__c = TRUE;
                                
                            AssetItemsUpdated.add(AssetItemRec);
                            if (SwapQuantityRemaining < 0){
                                ProductRec.SubProduct_Quantity__c = - (SwapQuantityRemaining);
                                
                            }                           
                        }
                    }   
                }
                system.debug('SwapQuantityRemaining - right before check: ' + SwapQuantityRemaining);
                If(SwapQuantityRemaining > 0){
                    //createCase
                    errorMsg = 'Too Many Items Returned';
                    ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(OppLineItemRec, errormsg, CasesToInsert, ServerRec.id);
                }else {
                    if (SwapQuantityRemaining < 0){
                        //create AssetItem by call Create_Asset
                        Server.add(ServerRec);
                        AssetItemsToReturn.addall(AssetItemsUpdated);
                        Assets = ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(OppLineItemRec, ProductRec, Server, ProductModelID, ProductModelName, 'Yes', createLater);
                        if (ProductRec.License_Required__c == true){
                            ProcessInstallations_CreateLicense.ProcessInstallations_CreateLicense(OppLineItemRec,ProductRec, Assets, Server, recordTypeID, CasesToInsert,createLater);
                        }
                    }else {
                        AssetItemsToReturn.addall(AssetItemsUpdated);       //pass back asset item that has been inactivated, but no new asset item or license key should be created.
                    }
                }
            }
    //  }
        
        
        system.debug('AssetItemsToReturn'+ AssetItemsToReturn);
        return AssetItemsToReturn;
        
                                                            
    }

}