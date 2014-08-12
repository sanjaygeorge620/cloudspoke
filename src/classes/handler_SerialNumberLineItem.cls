public with sharing class handler_SerialNumberLineItem {
	
	public static void setPartNameByPartNumber(List<Serial_Number_Line_Item__c> serialNumberLineItems, Map<Id, Serial_Number_Line_Item__c> oldMap, Boolean isUpdate) {
		
		 set<String> partNumbers = new set<String>();

		 for(Serial_Number_Line_Item__c snli : serialNumberLineItems) {

		 	if(isUpdate) {

		 		if(snli.Part_Number__c != oldMap.get(snli.Id).Part_Number__c) {

		 			partNumbers.add(snli.Part_Number__c);
		 		}
		 	}
		 	else {

	 			partNumbers.add(snli.Part_Number__c);
		 	}
		 }

		 if(partNumbers.size() > 0) {

		 	map<String, Id> partNumberToProductIdMap = new map<String, Id>();

		 	for(Product2 p : [SELECT Id, Part_Number__c
		 					  FROM Product2
		 					  WHERE Part_Number__c IN :partNumbers]) {

		 		partNumberToProductIdMap.put(p.Part_Number__c, p.Id);
		 	}

		 	for(Serial_Number_Line_Item__c snli : serialNumberLineItems) {

	 			if(partNumberToProductIdMap.get(snli.Part_Number__c) != null) {

	 				snli.Part_Name__c = partNumberToProductIdMap.get(snli.Part_Number__c);
	 			}
		 	}
		 }
		 
	}
}