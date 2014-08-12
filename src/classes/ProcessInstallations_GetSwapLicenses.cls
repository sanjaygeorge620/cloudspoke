public with sharing class ProcessInstallations_GetSwapLicenses {
    
    public static Map<ID, List<License_Key__c>> ProcessInstallations_GetSwapLicenses(List<ID> AssetRecList){
        Map<ID, List<License_Key__c>> LicensesMapToReturn = new Map<ID, List<License_Key__c>>();
        List<License_Key__c> LicenseKeys = new List<License_Key__c>( [select id
                                                                        , Name
                                                                        , Quantity__c
                                                                        , Asset__c
                                                                        , Asset_Item__c
                                                                        , server__c
                                                                        from License_Key__c
                                                                        where Asset__c in :AssetRecList
                                                                        and Status__c = 'Active']);
                                                                        
                                                                                
        
        
        
                //for each key in new products to add, check against existing products
        for (License_Key__c LicenseKeyRec : LicenseKeys){
            boolean LicenseKeyfound;    
            if (LicensesMapToReturn.size() > 0){                                                            //check to see if the Existing AssetMap Contains anything
                LicenseKeyfound = LicensesMapToReturn.containsKey(LicenseKeyRec.Asset__c);             //does the existing assetMap map have the keyset of the new asset Item              
            }else{
                LicenseKeyfound = false;
            }
            system.debug('LicenseKeyfound: ' + LicenseKeyfound);                                                    //does the map have a keyset matching the NewProductsToAdd?
            List<License_Key__c> tmpLicenseKeyList = new List<License_Key__c>();                    //create a tmpList to hold list returned from newProductsToadd
            
            if (LicenseKeyfound){       
                tmpLicenseKeyList = LicensesMapToReturn.get(LicenseKeyRec.Asset__c);                               //get list from Existing productsList
            }   
                
            tmpLicenseKeyList.add(LicenseKeyRec);
            
            LicensesMapToReturn.put(LicenseKeyRec.Asset__c,tmpLicenseKeyList); 
            system.debug('LicensesMapToReturn: ' + LicensesMapToReturn);            
    
            
        }       
        return LicensesMapToReturn;
                
                
        
    }
}