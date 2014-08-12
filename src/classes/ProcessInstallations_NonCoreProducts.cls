public with sharing class ProcessInstallations_NonCoreProducts {
	public static Map<OpportunityLineItem, List<Product2>> ProcessInstallations_NonCoreProducts(OpportunityLineItem OppLineItemRec, Map<OpportunityLineItem, List<Product2>> nonCoreProductsMap, Product2 ProductRec ){
		
		//for each key in new products to add, check against existing products
		Map<OpportunityLineItem, List<Product2>> ProductsAdded = new Map<OpportunityLineItem, List<Product2>>();
		List<OpportunityLineItem> noncoreProductsKeySet = new List<OpportunityLineItem>(nonCoreProductsMap.keyset());						//get keyset of newProductsToAdd Map
		
		boolean ProductKeyfound;	
		if (nonCoreProductsMap.size() > 0){															//check to see if the ExistingProductsMap Contains anything
			ProductKeyfound = nonCoreProductsMap.containsKey(OppLineItemRec);									//does the existing products map have the keyset of the new products				
		}else{
			ProductKeyfound = false;
		}
		system.debug('ProductKeyfound: ' + ProductKeyfound);													//does the map have a keyset matching the NewProductsToAdd?
		List<Product2> tmpCoreProductList = new List<Product2>();					//create a tmpList to hold list returned from newProductsToadd
		
		if (ProductKeyfound){		
			tmpCoreProductList = nonCoreProductsMap.get(OppLineItemRec);								//get list from Existing productsList
		}	
			
		tmpCoreProductList.add(ProductRec);
		
		ProductsAdded.put(OppLineItemRec,tmpCoreProductList);	
		system.debug('productsAdded: ' + ProductsAdded);			

		return ProductsAdded;
		
	}
}