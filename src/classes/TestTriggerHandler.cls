public class TestTriggerHandler {

 public static void updateCheckbox(List<Survey_MKT_Customer_Loyalty__c> newList, Map<Id, Survey_MKT_Customer_Loyalty__c> oldMap, Boolean isInsert){
 	
 	Set<Id> contId = new Set<Id>();
 	for(Survey_MKT_Customer_Loyalty__c cls : newlist){
 		if(isInsert || cls.Requests_Follow_Up__c != oldMap.get(cls.Id).Requests_Follow_Up__c){
 			
 			System.debug('The checkbox is checked :: '+cls.Requests_Follow_Up__c);
			contId.add(cls.Contact_Name__c);
 			
 		}
 	}
 	
 	if(!contId.isEmpty()){
 		 Map<Id, Contact> cont = new  Map<Id, Contact>([Select Id, Test_Customer__c from Contact where 
                                                              Id IN: contId]);
	for(Survey_MKT_Customer_Loyalty__c cls : newlist){
 		if(isInsert || cls.Requests_Follow_Up__c != oldMap.get(cls.Id).Requests_Follow_Up__c){
 			cont.get(cls.Contact_Name__c).Test_Customer__c = cls.Requests_Follow_Up__c;
 			System.debug('The checkbox is checked :: '+cls.Requests_Follow_Up__c);
	}                                                              
 	}
 	update cont.values();
 	//System.debug('The checkbox is checked :: '+cls.Requests_Follow_Up__c);
 	}
 }
}