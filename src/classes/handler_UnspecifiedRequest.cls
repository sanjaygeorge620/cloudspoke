public with sharing class handler_UnspecifiedRequest {
 	
 	public static void setRouteToUser(List<refedge__Unspecified_Request__c> unspecifiedRequests) {

		set<Id> userIds = new set<Id>();

		for(refedge__Unspecified_Request__c ur : unspecifiedRequests) {

			userIds.add(ur.refedge__Requester__c);
		}

		Map<Id, User> userMap = new Map<Id, User>();

		for(User u : [SELECT Id, LX_Country__c, LX_Geo__c, Email
					  FROM User
					  WHERE Id IN :userIds]) {

			userMap.put(u.Id, u);
		}

		Map<String, Id> customSettingMap = new Map<String, Id>();

		for(Unspecified_Request_Routing__c urr : [SELECT Geo__c, Country__c, Email_Not_Lexmark__c, SetupOwnerId
												  FROM Unspecified_Request_Routing__c]) {

			if(urr.Email_Not_Lexmark__c) {

				customSettingMap.put('Email', urr.SetupOwnerId);
			}
			else if(urr.Geo__c == 'North America') {

				customSettingMap.put('North America', urr.SetupOwnerId);
			}
			else if(urr.Geo__c == 'Latin America') {

				customSettingMap.put('Latin America', urr.SetupOwnerId);
			}
			else if(urr.Geo__c == 'EMEA') {
				
				customSettingMap.put('EMEA', urr.SetupOwnerId);
			}
			else if(urr.Country__c == 'Australia') {
				
				customSettingMap.put('Australia', urr.SetupOwnerId);
			}
			else if(urr.Geo__c == 'Asia Pacific') {
				
				customSettingMap.put('Asia Pacific', urr.SetupOwnerId);
			}
			
		}

		for(refedge__Unspecified_Request__c ur : unspecifiedRequests) {

			//set route to division field
			if(!userMap.get(ur.refedge__Requester__c).Email.contains('@lexmark.com')) {

				ur.Route_To_Division__c = 'PSW';
			}
			else {
				
				ur.Route_To_Division__c = 'ISS';
			}


			if(!userMap.get(ur.refedge__Requester__c).Email.contains('@lexmark.com')) {

				ur.Route_To__c = customSettingMap.get('Email');
			}
			if(userMap.get(ur.refedge__Requester__c).LX_Geo__c == 'North America') {

				ur.Route_To__c = customSettingMap.get('North America');
			}
			else if(userMap.get(ur.refedge__Requester__c).LX_Geo__c == 'Latin America') {

				ur.Route_To__c = customSettingMap.get('Latin America');
			}
			else if(userMap.get(ur.refedge__Requester__c).LX_Geo__c == 'EMEA') {

				ur.Route_To__c = customSettingMap.get('EMEA');
			}
			else if(userMap.get(ur.refedge__Requester__c).LX_Country__c == 'Australia') {

				ur.Route_To__c = customSettingMap.get('Australia');
			}
			else if(userMap.get(ur.refedge__Requester__c).LX_Geo__c == 'Asia Pacific') {

				ur.Route_To__c = customSettingMap.get('Asia Pacific');
			}
			
			
		}
 	}
}