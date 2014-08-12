public with sharing class ProcessInstallations_GetSwapAssets {

	static Boolean ServerForAsset;
	
	public static Map<ID, List<Asset_Item__c>> ProcessInstallations_GetSwapAssets(Map<ID, Product2> ProductRecMap
																				, Map<OpportunityLineItem, List<Server__c>> AllServersGivenMap
																				, Map<Product2, OpportunityLineItem> ProductRecLineItem
																				, Map<ID, Product_Model__c> ProductModelRecordsMap){
																					
system.debug('ProductRecMap:' + ProductRecMap);
system.debug('AllServersGivenMap:' + AllServersGivenMap);
system.debug('ProductRecLineItem:' + ProductRecLineItem);
system.debug('ProductModelRecordsMap:' + ProductModelRecordsMap);
																					
		Map<ID, List<Asset_Item__c>> AssetsMapToReturn = new Map<ID, List<Asset_Item__c>>();
		
		List<Asset_Item__c> AssetItems = new List<Asset_Item__c>( [select id
																		, Name
																		, Quantity__c
																		, Status__c
																		, Product__c
																		, Opportunity__c
																		, Server__c
																		, Asset__c
																		from Asset_Item__c
																		where product__c in :ProductRecMap.keyset()
																		and Status__c = 'Active']);
																		
																				
		
		system.debug('AssetItems: ' + AssetItems);
				//for each key in new products to add, check against existing products
		for (Asset_Item__c AssetItemRec : AssetItems){
			Product2 AssetItemProductRec = ProductRecMap.get(AssetItemRec.Product__c);				//get the whole product record based on the id
			OpportunityLineItem OppLineItem = ProductRecLineItem.get(AssetItemProductRec);			//get the oppline item related to the product Record
			
			List<Server__c> ServersGiven = new List<Server__c>();  
			ServersGiven = AllServersGivenMap.get(OppLineItem);										//get all servers related to OpportunityLineItem - this will include test & failover if needed
			
			ServerForAsset = false;	
			system.debug('ServersGiven: ' + ServersGiven);
			System.debug('AssetItemRec.Server__c: ' + AssetItemRec.Server__c);
			for (Server__c ServerRec : ServersGiven){												//check to see if there is a server matching the asset.  Only process assets on servers that are given
				if (ServerForAsset == false){
					if(AssetItemRec.Server__c == ServerRec.id){
						ServerForAsset = true;
					}
				}
			}
			

			system.debug('ServerForAsset:' + ServerForAsset);
			if(ServerForAsset == true){
				boolean AssetKeyfound;	
				if (AssetsMapToReturn.size() > 0){															//check to see if the Existing AssetMap Contains anything
					AssetKeyfound = AssetsMapToReturn.containsKey(AssetItemRec.Product__c);				//does the existing assetMap map have the keyset of the new asset Item				
				}else{
					AssetKeyfound = false;
				}
				system.debug('AssetKeyfound: ' + AssetKeyfound);									//does the map have a keyset matching the AssetsMapToReturn?
				List<Asset_Item__c> tmpAssetItemList = new List<Asset_Item__c>();					//create a tmpList to hold list returned from AssetItems
				list<Asset_Item__c> tmpAssetItemsToAdd = new List<Asset_Item__c>();					//this will be the list that gets the assets that will be added to the map
				
				if (AssetKeyfound){		
					tmpAssetItemList = AssetsMapToReturn.get(AssetItemRec.Product__c);								//get list from Existing productsList
				}	
					
				tmpAssetItemList.add(AssetItemRec);
				
				AssetsMapToReturn.put(AssetItemRec.Product__c,tmpAssetItemList);	
				system.debug('AssetsMapToReturn: ' + AssetsMapToReturn);	
			}			
	
			
		}		
		return AssetsMapToReturn;
				
				
		
	}
}