public with sharing class handler_SerialNumber {
	
	public static void setPartNameByPartNumber(List<Serial_Number__c> serialNumbers, Map<Id, Serial_Number__c> oldMap, Boolean isUpdate) {
		
		 set<String> partNumbers = new set<String>();

		 for(Serial_Number__c sn : serialNumbers) {

		 	if(isUpdate) {

		 		if(sn.Part_Number__c != oldMap.get(sn.Id).Part_Number__c) {

		 			partNumbers.add(sn.Part_Number__c);
		 		}
		 	}
		 	else {

	 			partNumbers.add(sn.Part_Number__c);
		 	}
		 }

		 if(partNumbers.size() > 0) {

		 	map<String, Id> partNumberToProductIdMap = new map<String, Id>();

		 	for(Product2 p : [SELECT Id, Part_Number__c
		 					  FROM Product2
		 					  WHERE Part_Number__c IN :partNumbers]) {

		 		partNumberToProductIdMap.put(p.Part_Number__c, p.Id);
		 	}

		 	for(Serial_Number__c sn : serialNumbers) {

	 			if(partNumberToProductIdMap.get(sn.Part_Number__c) != null) {

	 				sn.Part_Name__c = partNumberToProductIdMap.get(sn.Part_Number__c);
	 			}
		 	}
		 }
		 
	}
 
}