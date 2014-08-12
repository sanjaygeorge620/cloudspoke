/*
Project Request : PRJ001799
Created by: Jennifer Dauernheim
this class will get all the existing price book records so that they can be returned back to the pricebook batched processor class.
Within the pricebook batch processor class, the results passed back will be compared so that we don't create new records for existing.
*/

public with sharing class getExistingPriceBookRecs {
	
	public static Map<String, Published_Price_Book__c> getExistingPriceBookRecs(Set<String> partNumberSet, Set<String> SalesOrgSet, Set<String> CurrencySet, Set<String> PriceBookNameSet, Set<String> PricebookTypeSet){
		
		map<String, Published_Price_Book__c> existingPriceBookRecs = new Map<String, Published_Price_Book__c>();						//prj001716 - return map
		
		list<Published_Price_Book__c> existingRecsList = new List<Published_Price_Book__c>();
		existingRecsList = [Select Part_Number__c
							, id
							, Sales_Organization__c
							, CurrencyIsoCode
							, Tier_Minimum__c
							, Name
							, Price_Book_Type__c
							, List_Price__c
							, account__c
							, Price_Book_Maker_ID__c
                    		, Child_Number__c
                    		, End_Date__c         
                    		, Exclude_from_Quote_Process__c     
                    		, Fair_Market_Value__c
                    		, Family__c
                    		, Header_Number__c
                    		, IsParent__c
                    		, Line__c
                    		, Model__c
                    		, Model_Brand__c
                    		, Parent_Product__c
		                    , Price_Type__c
                    		, Pricing_ID__c                        
                    		, Product__c
                   			, Product_Brand__c
                    		, Product_Name__c
                    		, Product_Family__c
		                    , Series__c
                    		, Start_Date__c
                    		, Status__c
		                    , Tier_Pricing__c
                    		, Uplift_Part_Number__c
                    		, Uplift_Product__c
                    		, Token_Type__c
                    		
							from Published_Price_Book__c
							where Part_Number__c in :partNumberSet
							and Sales_Organization__c in :SalesOrgSet
        					and CurrencyIsoCode in :CurrencySet
        					and Name in :PriceBookNameSet
        					and Price_Book_Type__c in :PricebookTypeSet];
		
		system.debug('existingRecListTotal: ' + existingRecsList.size());
		if (existingRecsList.size() > 0){
			for(Published_Price_Book__c priceBookRec : existingRecsList){
				//put the  information from the record into the map so that the unique can be used to compare later
				String priceBookRecUniqueKey;
				priceBookRecUniqueKey = pricebookRec.Part_Number__c;
				priceBookRecUniqueKey = priceBookRecUniqueKey + ' - ' + pricebookRec.Sales_Organization__c;
				priceBookRecUniqueKey = priceBookRecUniqueKey + ' - '  + pricebookRec.CurrencyIsoCode;
				priceBookRecUniqueKey = priceBookRecUniqueKey + ' - '  + string.valueof(pricebookRec.tier_Minimum__c);
				priceBookRecUniqueKey = priceBookRecUniqueKey + ' - '  + pricebookRec.Name;
				priceBookRecUniqueKey = priceBookRecUniqueKey + ' - '  + pricebookRec.Price_Book_Type__c;
				if(priceBookRec.Account__c == null){
					priceBookRecUniqueKey = priceBookRecUniqueKey + ' - no account';
				}else{
					priceBookRecUniqueKey = priceBookRecUniqueKey + ' - '  + pricebookRec.Account__c;
				}
				
				
				
				existingPriceBookRecs.put(priceBookRecUniqueKey, priceBookRec);
			}			
		}
		system.debug('existingPriceBookRecs:' + existingPriceBookRecs);
		return existingPriceBookRecs;
	}

}