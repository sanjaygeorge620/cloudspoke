public with sharing class ProcessInstallations_getServers {
	public static Map<OpportunityLineItem, List<Server__c>> processInstallations_getServers(List<OpportunityLineItem> OppLineItems){
		
		Boolean duplicateFound = false;
		Map<OpportunityLineItem, List<Server__c>> CompleteServerMap = new Map<OpportunityLineItem, List<Server__c>>();
		List<Server__c> CompleteServerList = new List<Server__c>();
		
		set<ID>serverIDs = new set<ID>();
		Set<ID>LiveServerIds = new Set<ID>();
		
		//populate set of all Ids to query for Server Rec
		for (OpportunityLineItem OppLineItemRec : OppLineItems){
			if(OppLineItemRec.Server__c != null){			
				serverIDs.add(OppLineItemRec.Server__c);
			}	
		}
		system.debug('serverIDs: ' + serverIds);
		//pull back a list of all servers based on server id
		List<Server__c> serverRecList = new List<Server__c>( [select Name
																, id
																, Server_Type__c
																, Live_Server__c
																, Agreement__c
																, Account__c
																from Server__c
																where Id in :serverIDs]);
		system.debug('serverRecList: ' + serverRecList);														
		CompleteServerList.addall(ServerRecList);
		For(Server__c serverRec : serverRecList){
			if (serverRec.Server_Type__c == 'Live'){
				LiveServerIds.add(serverRec.id);
			}
		}	
			
		//pull back a list of all servers based on their liveServerID
		if(LiveServerIds.size()>0){													
			List<Server__c> LiveServerRecList = new List<Server__c> ( [select Name
																	, id
																	, Server_Type__c
																	, Live_Server__c
																	, Agreement__c
																	, Account__c
																	from Server__c
																	where Live_Server__c in :serverIDs]);
			system.debug('LiveServerRecList: ' + LiveServerRecList);														
			//add servers to the list - no duplicates
		
			For(Server__c LiveServerRec : LiveServerRecList){
				system.debug('LiveServerRec:' + LiveServerRec);
				duplicateFound = false;
				for (Server__c CompleteServerRec : CompleteServerList){	
					system.debug('CompleteServerRec:' + CompleteServerRec);
					if(duplicateFound == false){
						If(CompleteServerRec.id == LiveServerRec.id && CompleteServerRec.Server_Type__c == LiveServerRec.Server_Type__c){
							duplicateFound = true;
						}	
					}
				}
				system.debug('duplicateFound:' + duplicateFound);
				if(duplicateFound == false){
					CompleteServerList.add(LiveServerRec);
					system.debug('CompleteServerList.add(LiveServerRec)' + CompleteServerList);
				}
					
			}

			
		}
		
		//populate map from existing server list information.
		
		system.debug('OppLineItems:' + OppLineItems);
		for(OpportunityLineItem OppLineItemRec : OppLineItems){
			system.debug('OppLineItemRec' + OppLineItemRec);
			List<Server__c> tmpServerList = new List<Server__c>();
			if (OppLineItemRec.Server__c != null){
				system.debug('tmpServerLIst prior to iteration over Servers'+tmpServerList);
				for (Server__c ServerRec : CompleteServerList){
					system.debug('ServerRec:' + ServerRec);
					system.debug('OppLineItemRec.Server__c: ' + OppLineItemRec.Server__c);
					system.debug('ServerRec.id: ' + ServerRec.id);
					system.debug('ServerRec.Live_Server__c: ' + ServerRec.Live_Server__c);
					if (OppLineItemRec.Server__c == ServerRec.id){
						tmpServerList.add(ServerRec);
					}else{
						if (OppLineItemRec.Server__c == ServerRec.Live_Server__c){
							tmpServerList.add(ServerRec);
						}
					}
					system.debug('tmpServerLIst after iteration over each Server'+tmpServerList);
				}
			}else{
				system.debug('tmpServerList - no server on opp line Item:' + tmpServerList);
				CompleteServerMap.put(OppLineItemRec, tmpServerList);
			}	
			system.debug('tmpServerList:' + tmpServerList);
		//	if (tmpServerList.size() > 0){
				CompleteServerMap.put(OppLineItemRec, tmpServerList);
		//	}	
			system.debug('CompleteServerMap:'+ CompleteServerMap);
		}
		
		
		system.debug('CompleteServerList:' + CompleteServerList);
		system.debug('CompleteServerMap:' + CompleteServerMap);

		return CompleteServerMap;
	}
}