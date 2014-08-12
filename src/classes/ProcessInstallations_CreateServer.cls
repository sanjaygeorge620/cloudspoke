public with sharing class ProcessInstallations_CreateServer {
    public static List<Server__c> ProcessInstallations_CreateServer(OpportunityLineItem LineItemRec, Product2 ProductRec, String ProductModelName){
        //  create agreement for server to go under
        system.debug('ProductRec: ' + productRec);
/*      Agreement__c agreement = new Agreement__c();
                agreement.Account__c = LineItemRec.Opportunity.AccountId;
                agreement.Opportunity__c = LineItemRec.OpportunityId;
                if(ProductRec.SMSA_Product__c != null){
                    agreement.Name = [select Product_Model__r.Name from Product2 where id = :ProductRec.SMSA_Product__c].Product_Model__r.Name;
                }else{
                    agreement.Name = ProductModelName;
                }   
                agreement.Status__c = 'Active';
                system.debug('agreement.name: ' + agreement.name);
                
        insert agreement;
 */
        Agreement__c Agreement = AgreementRecord(LineItemRec, ProductRec, ProductModelName);       
        List<Server__c> Servers = new List<Server__c>();
        List<Server__c> liveServer = new List<Server__c>();
        //use agreement ID on server record 
        //creat server for live
        if(ProductRec.Environment__c == 'Live'){
            
            liveServer = (createServerRecord(LineItemRec, agreement.id, 'Live', 1, agreement.id,'No'));
            insert liveServer;
            
            //all needed serves on product
            
    
            integer numberofservers;
            String [] serverTypeList = new List<String>();
                serverTypeList.add('Test');
                serverTypeList.add('Failover');
            for (Integer sl = 0; sl < serverTypeList.size(); sl++){    
                string serverType = serverTypeList[sl];
                numberofservers = 0;
                if (servertype == 'Test'){
                    numberofServers = (ifnull(productRec.Test_Environments_Needed__c)).intValue();
                }else{
                    numberofServers = (ifnull(productRec.Failover_Environments_Needed__c)).intValue();
                } 
    
                if(numberOfServers > 0) {
                    List<Server__c> addServers = new List<Server__c>(createServerRecord(LineItemRec, agreement.id, serverType, numberofServers, liveServer[0].id, 'Yes'));
                
                    for (Server__c serverRec : addServers){
                        servers.add(serverRec);
                    }       
                }
            }    
        }else {
            ///****how to get liveServer ID
            List<Server__c> addServers = new List<Server__c>(createServerRecord(LineItemRec, agreement.id, ProductRec.Environment__c, 1,agreement.id,  'No' ));
                
            for (Server__c serverRec : addServers){
                servers.add(serverRec);
            } 
        }    
        system.debug('createServers - return servers: ' + servers);
        insert servers;
        
        //system.debug('liveServer.size(): ' + liveServer.size());
        if (liveServer.size() > 0 ){
            for(Server__c LiveServerRec : liveServer){
                servers.add(LiveServerRec);
            }   
        }
        system.debug('createServers - return servers after insert: ' + servers);
        return servers;
    }
    
    public static list<Server__c> createServerRecord(OpportunityLineItem LineItemRec
                                                        , ID agreementID
                                                        , String serverType
                                                        , Integer numberofservers
                                                        , ID LiveServerID
                                                        , string addLiveServer){
        List<Server__c> Servers = new List<Server__c>();                                                            
        system.debug('==numberOfServers:' + numberOfServers);
        String ServerName = lineItemRec.Opportunity.Account.Name;
              if(ServerName.length() > 79)
           {                                              
        ServerName = ServerName.substring(0,79);     
           }
        for (Integer i = 0; i < numberOfServers; i++) 
        {
            Server__c server = new Server__c();
            server.Name = ServerName;
            server.Server_Type__c = serverType;
            if (serverType != 'Live' && addLiveServer == 'Yes'){
                server.Live_Server__c = LiveServerID;
            }
            server.Agreement__c = agreementId;
            server.Account__c = lineItemRec.Opportunity.AccountId;
            system.debug('server in createServers: ' + server);
            Servers.add(server);
        }                                               
        return Servers;
    }
    
    public static decimal ifnull(decimal num) 
{
if (num == null) 
{
    num = 0;
}
return num;
}
    
    public static Agreement__c AgreementRecord(OpportunityLineItem LineItemRec, Product2 ProductRec, String ProductModelName)
    {
                                                            
//based on Product model name = check to see if an agreement of that name is already there for this account.  If so,
//use that agreement & just create servers.  otherwise, insert.
        Agreement__c ReturnAgreement;
        String ProductModelNameToUse;
        if(ProductRec.SMSA_Product__c != null)
        {
            ProductModelNameToUse = [select Product_Model__r.Name from Product2 where id = :ProductRec.SMSA_Product__c].Product_Model__r.Name;
        }
        else
        {
            ProductModelNameToUse = ProductModelName;
        }   
        
        List<Agreement__c> ExistingAgreementList = new List<Agreement__c>([select Name, account__c 
                                            from Agreement__c 
                                            where account__c = :LineItemRec.Opportunity.AccountId 
                                            and Name = :ProductModelNameToUse limit 1]);
        
        If(ExistingAgreementList.size() > 0){
            return ReturnAgreement = ExistingAgreementList[0];
        }else{                              
            Agreement__c agreement = new Agreement__c();
                    agreement.Account__c = LineItemRec.Opportunity.AccountId;
                    agreement.Opportunity__c = LineItemRec.OpportunityId;
                    agreement.Name = ProductModelNameToUse;
                    agreement.Status__c = 'Active';
                    system.debug('agreement.name: ' + agreement.name);
                    
            insert agreement;
            return ReturnAgreement = agreement;
        }       
    }
}