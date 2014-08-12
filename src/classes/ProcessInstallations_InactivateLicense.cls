public with sharing class ProcessInstallations_InactivateLicense {

	public static List<License_Key__c> ProcessInstallations_InactivateLicense(List<Asset_Item__c> AssetItemsToUpdate 
																				, Map<ID, List<License_Key__c>> SwapLicenseKeyMap	
																				, List<License_Key__c>SwapLicenseKeyList
																				, OpportunityLineItem OppLineItemRec
																				, List<Server__c> Servers
																				, Id recordTypeId
																				, List<Case> Cases ){
		
		system.debug('InactivateLicense-AssetItemsToUpdate'+ AssetItemsToUpdate);
		system.debug('InactivateLicense-AssetItemsToUpdate - count'+ AssetItemsToUpdate.size());
		system.debug('InactivateLicense-SwapLicenseKeyMap'+ SwapLicenseKeyMap);
		system.debug('InactivateLicense-SwapLicenseKeyList'+ SwapLicenseKeyList);
		
	//	Map<Asset,License_Key__c> licenseKeys = new Map<Asset, License_Key__c>();	// will hold all license keys defined by their asset
		Map<Asset, Asset_Item__c> AssetMap = New Map<Asset, Asset_Item__c>();		//will hold all asset items defined by their asset
		Asset AssetRec = new Asset();			//this will be template for assetRecord
		
		List<License_Key__c> LicenseKeyToReturn = new List<License_Key__c>();
		set<ID> AssetItemRecSet = new set<ID>();

		for (Asset_Item__c AssetItemRec : AssetItemsToUpdate){	
			system.debug('AssetItemRec' + AssetItemRec);
			//create map to be used for licenseCases 
				boolean AssetKeyfoundInAssetMap;
				AssetRec = new Asset(id = AssetItemRec.Asset__c,Server__c = AssetItemRec.Server__c );	
				AssetMap.put(AssetRec,AssetItemRec);
			
			///Asset map created, continue to add as process through assetitemsRecs
					
			
			List<License_Key__c> LicenseKeyList = new List<License_Key__c>(SwapLicenseKeyMap.get(AssetItemRec.Asset__c));
			system.debug('LicenseKeyList:' + LicenseKeyList);
		 	If(LicenseKeyList.size() > 0 ){     
		 		                                                           	
				For(License_Key__c LicenseKeyRec : LicenseKeyList){
					system.debug('LicenseKeyRec:' + LicenseKeyRec);
					if(LicenseKeyRec.Asset_Item__c == AssetItemRec.Id){
						LicenseKeyRec.Status__c = 'Inactive';
						LicenseKeyRec.Exclude__c  = TRUE;
						Map<Asset,License_Key__c> licenseKeys = new Map<Asset, License_Key__c>();	// will hold all license keys defined by their asset 
						LicenseKeyToReturn.add(LicenseKeyRec);
						
						//create map for license keys to be usd in CreateLIcenseCase
							licenseKeys.put(AssetRec,LicenseKeyRec);
							ProcessInstallations_CreateLicenseCase.ProcessInstallations_CreateLicenseCase(licenseKeys, AssetMap, OppLineItemRec, Servers, recordTypeID, Cases, true);
						//end create map for license keys
						
						
					}
				}
			
			}
		}	
																
		return LicenseKeyToReturn;
	}
	
	
}