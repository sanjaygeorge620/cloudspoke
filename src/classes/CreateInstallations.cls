/**
 * Worker class to create installations for an Opportunity.
 *
 * Check each OpportunityLineItem, and for each:
 *  * Conditionally create an Agreement
 *  * Conditionally create one or more Servers
 *  * Conditionally create one or more Assets
 *  * Conditionally create one or more Asset Items
 *  * Conditionally create a License Key
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-11-16
 */
public class CreateInstallations {
    private static final String SERVERTYPE_LIVE = 'Live';
    private static final String SERVERTYPE_TEST = 'Test';
    private static final String SERVERTYPE_FAILOVER = 'Failover';
    List<Server__c> caseServers = new List<Server__c>();
    
    private static boolean firstInThread = true;
    private static boolean isHandleAssetFirst = true;
    public static void runInstallations () {
        if (firstInThread) {
            firstInThread = false;
            BatchCreateInstallations batchController = new BatchCreateInstallations();
            Database.executeBatch(batchController,1);       
        }
    }
    
    private Opportunity opportunity;
    
    public CreateInstallations(Id oppId) {
        opportunity = database.query('Select Id,AccountId,Ship_To__c,Opportunity_Number__c From Opportunity Where Id = :oppId');
    }

    /*
     * The main method for the Installation Creation process.  Drives the execution.
     *
     * See the document entitled "Installations Processor" for more information.
     */
    public void process() {
        List<OpportunityLineItem> lineItems = [
            Select
                Id,
                Opportunity.AccountId,
                Opportunity.Account.Name,
                OpportunityId,
                Quantity,
                PricebookEntry.Product2.Core_Product__c,
                PricebookEntry.Product2.Environment__c,
                PricebookEntry.Product2.Failover_Environments_Allowed__c,
                PricebookEntry.Product2.Failover_Environments_Needed__c,
                PricebookEntry.Product2.Failover_Licenses_Allowed__c,
                PricebookEntry.Product2.Exclude_from_Failover_Clone__c,
                PricebookEntry.Product2.Exclude_from_Test_Clone__c,
                PricebookEntry.Product2.Id,
                PricebookEntry.Product2.License_Required__c,
                PricebookEntry.Product2.Name,
                PricebookEntry.Product2.Parent_Product__r.Product_Model__r.Name,
                PricebookEntry.Product2.Parent_Product__r.Name,
                PricebookEntry.Product2.Product_Model__c,   
                PricebookEntry.Product2.Product_Model__r.Asset_Required__c,
                PricebookEntry.Product2.Product_Model__r.Family__c,
                PricebookEntry.Product2.Product_Model__r.Line__c,
                PricebookEntry.Product2.Product_Model__r.Model__c,              
                PricebookEntry.Product2.Product_Model__r.Name,
                PricebookEntry.Product2.Product_Model__r.Series__c,
                PricebookEntry.Product2.SMSA_Product__c,
                PricebookEntry.Product2.SMSA_Product__r.Product_Model__r.Name,
                PricebookEntry.Product2.Test_Environments_Allowed__c,
                PricebookEntry.Product2.Test_Environments_Needed__c,
                PricebookEntry.Product2.Test_Licenses_Allowed__c,
                PricebookEntry.Product2.Replicate_Full_Environment__c
            From
                OpportunityLineItem
            Where
                OpportunityId = :opportunity.Id];

        // No line items, nothing to do
        if (lineItems == null || lineItems.size() == 0) return;      
                
        replicateEnvironments(lineItems);
        handleCoreProducts(lineItems);
        handleInstallationProducts(lineItems);
    }
    
    public void replicateEnvironments(List<OpportunityLineItem> lineItems) {
        List<OpportunityLineItem> replicateItems = new List<OpportunityLineItem>();
        // Determine which line items need server replication
        for (OpportunityLineItem lineItem : lineItems) {
            if (lineItem.PricebookEntry.Product2.Replicate_Full_Environment__c) {
                replicateItems.add(lineItem);
            }
        }
        system.debug('replicateItems : ' + replicateItems);
        handleAssets(createOrFindServers(replicateItems, false));
    }
    
    /*
     * Ensure there is an Active Agreement__c for each of the Products with Core_Product
     * set to true.  For the Account in question, there should be one Agreement per 
     * Product Model (differentiated by the Name field).
     */
    public void handleCoreProducts(List<OpportunityLineItem> lineItems) {
        List<OpportunityLineItem> lineItemsToProcess = new List<OpportunityLineItem>();
        
        //prepare a list of line items where Core_Product__c = true
        for (OpportunityLineItem lineItem : lineItems) {
            if (lineItem.PricebookEntry.Product2.Core_Product__c) {
                lineItemsToProcess.add(lineItem);
            }
        }
        system.debug('replicateItems : ' + lineItemsToProcess);
        handleAssets(createOrFindServers(lineItemsToProcess, true));
    }
    
    
    /* Get a list of Agreements from passed in LineItems 
     * 1) if found active agreement then do nothing, 
     * 2) if found inactive agreement, then activates it, 
     * 3) if didn't find agreement then creates agreement
     */
    public List<Agreement__c> getAgreements(List<OpportunityLineItem> lineItems) {
        List<Agreement__c> agreements = new List<Agreement__c>();
        List<Agreement__c> agreementsToInsert = new List<Agreement__c>();
        List<Agreement__c> agreementsToUpdate = new List<Agreement__c>();
        
        if(lineItems.size() <= 0)
           return agreements;
        
        String queryAppend = '';
        for (OpportunityLineItem lineItem : lineItems) {                           
            queryAppend += ' ( ';
            queryAppend += ' Name = \''+ getAgreementName(lineItem.PricebookEntry.Product2).replace('\'', '\\\'') +'\'';
            queryAppend += ' and ';
            queryAppend += ' Account__c = \''+lineItem.Opportunity.AccountId+'\'';
            queryAppend += ' ) or';            
        }        
        queryAppend = queryAppend.substring(0, queryAppend.lastIndexOf('or'));
        String soql = 'SELECT Id,Account__c,Name,Status__c FROM Agreement__c WHERE ' + queryAppend;
        
        Map<String, Agreement__c> agreementNameKeyMap = new  Map<String, Agreement__c>();
        agreements = Database.query(soql);
        for(Agreement__c agreement : agreements){
            String key = agreement.Name + ':'+ agreement.Account__c;
            agreementNameKeyMap.put(key, agreement);
            if (agreement.Status__c != 'Active') {
                agreement.Status__c = 'Active';
                agreementsToUpdate.add(agreement);
            }
        }
        
        for (OpportunityLineItem lineItem : lineItems) {  
            String key = getAgreementName(lineItem.PricebookEntry.Product2) + ':'+ lineItem.Opportunity.AccountId;
            if(!agreementNameKeyMap.containsKey(key)){
                Agreement__c agreement = new Agreement__c();
                agreement.Account__c = lineItem.Opportunity.AccountId;
                agreement.Opportunity__c = lineITem.OpportunityId;
                agreement.Name = getAgreementName(lineItem.PricebookEntry.Product2);
                agreement.Status__c = 'Active';
                agreementsToInsert.add(agreement);
                agreementNameKeyMap.put(key, agreement);
            }
        }
        
        system.debug('==== agreementsToUpdate == ' + agreementsToUpdate);
        system.debug('==== agreementsToInsert == ' + agreementsToInsert);
        
        if(agreementsToUpdate.size() > 0){
            update agreementsToUpdate;
        }
        
        if(agreementsToInsert.size() > 0){
            insert agreementsToInsert;
            agreements.addAll(agreementsToInsert);
        }
        
        return agreements;
    }
    
    
    /*
     * Create Installations for all Support products.
     * A product is a Support product if:
        If Line = Solutions Software, Series = Application Maint. & Dev, Family = Support
        If Line = Services, Series = Managed Software Services, Family = Hosted
        If Line = Services, Series = Managed Software Services, Family = Remote Administration
        If Line = Services, Series = Managed Software Services, Family = Subscription
     */
    public void handleInstallationProducts(List<OpportunityLineItem> lineItems) {
        List<OpportunityLineItem> installationsItems = new List<OpportunityLineItem>();
        for (OpportunityLineItem lineItem : lineItems) {
            if (lineItem.PricebookEntry.Product2.Product_Model__r.Asset_Required__c && 
                    !lineItem.PricebookEntry.Product2.Core_Product__c) {
                installationsItems.add(lineItem);           
            }
        }
        handleAssets(createOrFindServers(installationsItems, true));
    }
    
    public void handleAssets(Map<OpportunityLineItem,List<Server__c>> mapServers) {
        system.debug('HandleAssets - mapServers: ' + mapServers);
        if (mapServers.size() == 0) {
            // nothing to do here
            return;
        }
        system.debug('do I continue with HandleAssets?');
        //prepare set of productId to query product subitems        
        Set<Id> productIds = new Set<Id>();        
         for(OpportunityLineItem lineItem : mapServers.keySet()){
            if(lineItem.PricebookEntry.Product2.Product_Model__r.Asset_Required__c){
                productIds.add(lineItem.PricebookEntry.Product2Id);
            }
        }
        
        Map<Id, List<Product_Sub_Item__c>> mapProductSubItem = loadProductSubItems(productIds);
        Set<String> assetNames = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        
        //process all lineItems and ProductSubItems to prepare set of exist assetName 
        for(OpportunityLineItem lineItem : mapServers.keySet()){
            accountIds.add(lineItem.Opportunity.AccountId);
            system.debug('mapProductSubItem.containsKey(lineItem.PricebookEntry.Product2Id): ' + mapProductSubItem.containsKey(lineItem.PricebookEntry.Product2Id));
            if(mapProductSubItem.containsKey(lineItem.PricebookEntry.Product2Id)){
                for(Product_Sub_Item__c productSubItem : mapProductSubItem.get(lineItem.PricebookEntry.Product2Id)){
                    assetNames.add(getAssetName(productSubItem.Product__r));
                }
            } else {
                assetNames.add(getAssetName(lineItem.PricebookEntry.Product2));                            
            }
        }        
        
        //Prepare a map of serverAssets with serverId
        //serverAssets is again a map of asset with assetName as keyset
        system.debug('assetnames: ' + assetnames);
        system.debug('accountIds: ' + accountIds);
        Map<String, Map<String,Asset>> mapExistingServerAssets = loadServerAssets(assetNames,accountIds);
                       
        List<Asset> newAssets = new List<Asset>();
        List<Asset> assets = new List<Asset>();
        List<Asset_Item__c> assetItems = new List<Asset_Item__c>();
        List<License_Key__c> licenseKeys = new List<License_Key__c>();
        for(OpportunityLineItem lineItem : mapServers.keySet()){
            system.debug('lineitem(inside HandleAssets): ' + lineItem);
            system.debug('lineItem.PricebookEntry.Product2.Product_Model__r.Asset_Required__c: '+ lineItem.PricebookEntry.Product2.Product_Model__r.Asset_Required__c);
            if(lineItem.PricebookEntry.Product2.Product_Model__r.Asset_Required__c){ 
                Map<String,Integer> allowedEnvs = newEnvironmentsAllowed(lineItem,mapServers.get(lineItem),mapExistingServerAssets);                
                for(Server__c server : mapServers.get(lineItem)){
                    caseServers.add(server);
                    system.debug('server record:' + server);
                    system.debug('allowedEnvs-after server record: ' + allowedEnvs);
                    if(!mapExistingServerAssets.containsKey(server.Id) && allowedEnvs.get(server.Server_Type__c) > 0){
                        mapExistingServerAssets.put(server.Id,new Map<String,Asset>());
                        allowedEnvs.put(server.Server_Type__c,allowedEnvs.get(server.Server_Type__c) - 1);
                    }
                    system.debug('mapExistingServerAssets.containsKey(server.Id): ' + mapExistingServerAssets.containsKey(server.Id));
                    system.debug('mapExistingServerAssets: '+ mapExistingServerAssets);   
                    system.debug('server.id: ' + server.id);              
                    if(mapExistingServerAssets.containsKey(server.Id)){
                        //calculate quantity of the server
                        Decimal quantity = lineItem.Quantity;
                        if (server.Server_Type__c == SERVERTYPE_FAILOVER) {
                            quantity = minValue(lineItem.Quantity, lineItem.PricebookEntry.Product2.Failover_Licenses_Allowed__c);
                        }
                        else if (server.Server_Type__c == SERVERTYPE_TEST) {
                            quantity = minValue(lineItem.Quantity, lineItem.PricebookEntry.Product2.Test_Licenses_Allowed__c);                                  
                        }       

                        Map<String,Asset> mapExistingAssets;
                        mapExistingAssets = mapExistingServerAssets.get(server.Id);
                        
                        system.debug('mapExistingServerAssets-inside:' + mapExistingServerAssets);
                        system.debug('mapExistingAssets-inside:' + mapExistingAssets);

                        // Create asset and asset item for the Product
                        String assetName = getAssetName(lineItem.PricebookEntry.Product2);  
                        system.debug('assetName): ' + assetName+'---'+mapExistingAssets.containsKey(assetName));
                            if(!mapExistingAssets.containsKey(assetName)){
                                Asset assset = new Asset(Name = assetName, Server__c = server.Id , AccountId = server.Account__c, Agreement__c = server.Agreement__c, Product_Model__c = lineItem.PricebookEntry.Product2.Parent_Product__r.Product_Model__c != null ? lineItem.PricebookEntry.Product2.Parent_Product__r.Product_Model__c : lineItem.PricebookEntry.Product2.Product_Model__c);
                                system.debug('Assset record: ' + Assset);
                                newAssets.add(assset);
                                system.debug('newAssetmap:' + newAssets);
                                mapExistingAssets.put(assetName,assset);
                                //PR-0421 - this code was used after this condition but it creates more than one assert Item for Asset so i have moved it in loop.
                                assets.add(assset);
                                assetItems.add(new Asset_Item__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity,Status__c = 'Active',Product__c = lineItem.PricebookEntry.Product2.Id, Opportunity__c = lineItem.OpportunityId));
                                system.debug('assetItems'+ assetItems);
                                if (lineItem.PricebookEntry.Product2.License_Required__c) {
                                    licenseKeys.add(new License_Key__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity));                                                  
                                }   
                            }else if(!lineItem.PricebookEntry.Product2.Core_Product__c){
                                 assets.add(mapExistingAssets.get(assetName));
                                 assetItems.add(new Asset_Item__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity,Status__c = 'Active', Product__c = lineItem.PricebookEntry.Product2.Id, Opportunity__c = lineItem.OpportunityId));
                                 system.debug('assetItems'+ assetItems);
                                 if(lineItem.PricebookEntry.Product2.License_Required__c) {
                                    licenseKeys.add(new License_Key__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity));                                                  
                                 }
                                 if(allowedEnvs.containsKey(server.Server_Type__c)&& allowedEnvs.get(server.Server_Type__c) > 0){
                                    allowedEnvs.put(server.Server_Type__c, allowedEnvs.get(server.Server_Type__c) - 1 );
                                 }      
                            
                          } 
                          // If there are Product Sub Items, create asset items for this as well
                          system.debug('mapProductSubItem :' + mapProductSubItem);
                          system.debug('lineItem.PricebookEntry.Product2Id: ' + lineItem.PricebookEntry.Product2Id);
                          if(mapProductSubItem.containsKey(lineItem.PricebookEntry.Product2Id)){
                             for(Product_Sub_Item__c productSubItem : mapProductSubItem.get(lineItem.PricebookEntry.Product2Id)){
                                system.debug('productsubitem:' + productSubItem);
                                assetName = getAssetName(productSubItem.Product__r);
                                system.debug('assetName - productsubItem' + assetName); 
                                system.debug('mapExistingAssets.containsKey(assetName)- productsubItem' + mapExistingAssets.containsKey(assetName));
                                if(!mapExistingAssets.containsKey(assetName)){
                                    Asset assset = new Asset(Name = assetName, Server__c = server.Id , AccountId = server.Account__c,Agreement__c = server.Agreement__c, Product_Model__c = lineItem.PricebookEntry.Product2.Parent_Product__r.Product_Model__c != null ? lineItem.PricebookEntry.Product2.Parent_Product__r.Product_Model__c : lineItem.PricebookEntry.Product2.Product_Model__c);
                                    system.debug('Assset record: ' + Assset);
                                    newAssets.add(assset);
                                    system.debug('newAssetmap:' + newAssets);
                                    mapExistingAssets.put(assetName,assset);
                                    //PR-0421 - this code was used after this condition but it creates more than one assert Item for Asset so i have moved it in loop.
                                    assets.add(assset);
                                    assetItems.add(new Asset_Item__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity,Status__c = 'Active',Product__c = lineItem.PricebookEntry.Product2.Id, Opportunity__c = lineItem.OpportunityId));
                                    system.debug('assetItems'+ assetItems);
                                    if (lineItem.PricebookEntry.Product2.License_Required__c) {
                                        licenseKeys.add(new License_Key__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity));                                                  
                                    }   
                                }else if(!lineItem.PricebookEntry.Product2.Core_Product__c){ // add this part for resolving the issue in PR-08421
                                    assets.add(mapExistingAssets.get(assetName));
                                    assetItems.add(new Asset_Item__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity,Status__c = 'Active',Product__c = lineItem.PricebookEntry.Product2.Id, Opportunity__c = lineItem.OpportunityId));
                                    system.debug('assetItems'+ assetItems);
                                    if(lineItem.PricebookEntry.Product2.License_Required__c) {
                                        licenseKeys.add(new License_Key__c(Name = lineItem.PricebookEntry.Product2.Name, Quantity__c = quantity));                                                  
                                    }
                                    if(allowedEnvs.containsKey(server.Server_Type__c)&& allowedEnvs.get(server.Server_Type__c) > 0){
                                        allowedEnvs.put(server.Server_Type__c, allowedEnvs.get(server.Server_Type__c) - 1 );
                                    }       
                                }
                            }
                        }
                    }                   
                }
            }
        }
        
        //insert new assets
        system.debug('newassets.size()' + newAssets.size());
        if(newAssets.size() > 0){
            insert newAssets;
        }
        
        //fill AssetIds in AssetItems and licenseKeys
        system.debug('assetitems.size()' + assetItems.size());
        system.debug('License Keys size(): ' + licenseKeys.size());
        system.debug('License Keys: ' + licenseKeys);
        for(Integer index=0; index < assetItems.size(); index++){
            assetItems.get(index).Asset__c = assets.get(index).Id;
            licenseKeys.get(index).Asset__c = assets.get(index).Id;
        }
        
        //insert asset items        
        if(assetItems.size() > 0){
            insert assetItems;
        }
        
        //fill AssetItem Id in licenseKeys
        
        for(Integer index=0; index < licenseKeys.size(); index++){
            licenseKeys.get(index).Asset_Item__c = assetItems.get(index).Id;
        }
        
        //insert license keys
        if(licenseKeys.size() > 0){
            insert licenseKeys;
            // need to change to @future, this fires off triggers which put us over the SOQL query limit
            createCases(licenseKeys,assetItems,assets);
        }
        system.debug('==== newAssets == ' + newAssets);
        system.debug('==== assetItems == ' + assetItems);
        system.debug('==== licenseKeys == ' + licenseKeys);
        
    }
    
   
   private void createCases(List<License_Key__c> licenseKeys,List<Asset_Item__c> assetItems,List<Asset> assets){
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get(Lx_SetRecordIDs__c.getAll().get('CaseLicenseExternalRecordType').Value__c).getRecordTypeId();
        Integer index = 0;
        
        String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c;        
        List<Case> cases = new List<Case>();
        for(License_Key__c licenseKey : licenseKeys){
            Asset_Item__c assetItem = assetItems.get(index);
            Asset assset = assets.get(index);
            system.debug('***case assset item: ' + assset);
            system.debug('***license key record: ' + licenseKey);
            system.debug('assetItem record : ' + assetItem);
            system.debug('*** case servers: '+ caseServers);
            string serverRecType = '';
            for (Server__c serverRec : caseServers){
                system.debug('server rec - case: ' + serverRec);
                if (serverRec.id == assset.Server__c) { 
                    serverRecType = serverRec.Server_Type__c;
                    system.debug('serverRecType: ' + serverRecType);
                }
            }            
            Case newCase = new Case();
            newCase.RecordTypeId = recordTypeId;
            newCase.Internal_Case_Account__c = opportunity.AccountId;
            //newCase.ContactId = opportunity.Ship_To__c;
            newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
            newCase.Status = 'New';
            newCase.Impact__c = 'Enterprise';
            newCase.Urgency__c = 'Medium';
            newCase.Origin = 'Automation';
            newCase.Type = 'Request';
            newCase.Category__c = 'License Request';
            newCase.Level_1__c = 'License – Additional';
            newCase.Node_ID_File_Name__c = 'Not Available';
            newCase.Version__c = 'Not Available';
            newCase.Specific_Licenses_Requested__c = 'Not Available';
            newCase.Subject = 'Order Processed - ' + assetItem.Name;
            newcase.Environment__c = serverRecType;
            newCase.Description = 'Model: ' + assset.Name + '\n'
                                + 'Product: ' + assetItem.Name + '\n'
                                + 'Quantity: ' + assetItem.Quantity__c + '\n'
                                + 'Opportunity Number: ' + opportunity.get('Opportunity_Number__c') + '\n'
                                + 'Link: ' + baseUrl + '/' + licenseKey.id ;
            cases.add(newCase);
            index++;
        }
        
        system.debug('==== cases == ' + cases);
        insert cases;
    }
    
   /*@future(callout=true)  
   public static void callCreateInstallations(Set<Id> opportunityIds){
    for(Id oppId : opportunityIds){
        new CreateInstallations(oppId).process();
    }
   }*/
    
    //Returns a map for new environments allowed with servertype as key set
    private Map<String,Integer> newEnvironmentsAllowed(OpportunityLineItem lineItem,List<Server__c> servers,Map<String, Map<String,Asset>> mapExistingServerAssets){ 
        // see how many of each type there are -- if we have null, in the Allowed field, then we use all
        Integer testServers = 0;
        Integer failoverServers = 0;
        for (Server__c server : servers) {
            if (server.Server_Type__c == SERVERTYPE_TEST) {
                testServers++;
            }
            else if (server.Server_Type__c == SERVERTYPE_FAILOVER) {
                failoverServers++;
            }
        }
        //system.debug('Servers asset: ' + mapExistingServerAssets);
        system.debug('Servers hhhh: ' + Servers);
        //system.debug('testServers: ' + testServers);
        Map<String,Integer> allowedEnvs = new Map<String,Integer>();
        allowedEnvs.put(SERVERTYPE_TEST,getAllowedEnvironments(lineItem.PricebookEntry.Product2,SERVERTYPE_TEST,testServers));
        allowedEnvs.put(SERVERTYPE_FAILOVER,getAllowedEnvironments(lineItem.PricebookEntry.Product2,SERVERTYPE_FAILOVER,failoverServers));
        allowedEnvs.put(SERVERTYPE_LIVE,1);
        
        /*for(Server__c server : servers){
           //check for existing asset for server
            if(mapExistingServerAssets.containsKey(server.Id) && lineItem.PricebookEntry.Product2.Core_Product__c == false){
                allowedEnvs.put(server.Server_Type__c,allowedEnvs.get(server.Server_Type__c)-1); 
            }
        }*/
        system.debug('allowedEnvs:' + allowedEnvs);
        return allowedEnvs;
    }
        
    /*
     * Either find existing servers for which Assets will be created, or create new
     * servers.
     *
     * includeLiveServers determines whether or not we want the 'Live' server to be
     *   returned.  We do not want it to be returned when replicating, for instance.
     */
    public Map<OpportunityLineItem,List<Server__c>> createOrFindServers(List<OpportunityLineItem> lineItems, Boolean includeLiveServers) {        
        Map<OpportunityLineItem,List<Server__c>> mapServers = new Map<OpportunityLineItem,List<Server__c>>();
        List<Server__c> serversToInsert = new List<Server__c>();
        Map<String, Agreement__c> agreementNameKeyMap = loadAgreements(lineItems);   
        system.debug('agreementNamekeyMap:' + agreementNameKeyMap);
        // Find servers having agreements, names and accounts set accordingly
        Map<String, List<Server__c>> existingServerMap = loadServers(getWhereclauseForServer(lineItems,agreementNameKeyMap, includeLiveServers));
        system.debug('existingServerMap: ' + existingServerMap);
        system.debug('==lineItems: ' + lineItems);
        for (OpportunityLineItem lineItem : lineItems) {
            system.debug('==lineItem.PricebookEntry.Product2) + \':\'+lineItem.Opportunity.AccountId:' + lineItem.PricebookEntry.Product2 + ':'+lineItem.Opportunity.AccountId);
            String agreementKey = getAgreementName(lineItem.PricebookEntry.Product2) + ':'+lineItem.Opportunity.AccountId;
            system.debug('==agreementkey' + agreementKey);
            if(agreementNameKeyMap.containsKey(agreementKey)){
                List<Server__c> servers = new List<Server__c>();
                List<Server__c> newServers = new List<Server__c>();
                String key = lineItem.Opportunity.Account.Name +':'+agreementNameKeyMap.get(agreementKey).id + ':';
                system.debug('==key==: ' + key);
                Integer neededServers;
                 
                if(lineItem.PricebookEntry.Product2.Environment__c == SERVERTYPE_LIVE && includeLiveServers){
                    neededServers = 1;
                    if(existingServerMap.containsKey(key + SERVERTYPE_LIVE)){
                       servers.addAll(existingServerMap.get(key + SERVERTYPE_LIVE));
                    }else if(lineItem.PricebookEntry.Product2.Product_Model__r.Asset_Required__c && 
                    !lineItem.PricebookEntry.Product2.Core_Product__c){ //added to resolved the issue in PR-08421 and create new Live server if there is no core product with the opportunity 
                         List<Server__c> lst = createServers(lineItem.Opportunity.Account.Name,SERVERTYPE_LIVE,agreementNameKeyMap.get(agreementKey),neededServers);
                         existingServerMap.put(key + SERVERTYPE_LIVE,lst);
                         newServers.addAll(lst);
                    } 
                    if(lineItem.PricebookEntry.Product2.Core_Product__c == true){ //added to resolved the issue in PR-08421 and create a new Live server everytime when core product is encountered.
                         List<Server__c> lst = createServers(lineItem.Opportunity.Account.Name,SERVERTYPE_LIVE,agreementNameKeyMap.get(agreementKey),neededServers);
                         existingServerMap.put(key + SERVERTYPE_LIVE,lst);
                         newServers.addAll(lst);
                    }                       
                }
                system.debug('==lineitem - get needed servers' + lineItem );
                system.debug('==lineitem - get needed servers - pricebookentryProduct2' + lineItem.PricebookEntry.Product2 );  
                neededServers = getNeededServers(lineItem.PricebookEntry.Product2,SERVERTYPE_TEST);
                system.debug('retun neededServers:' + neededServers);
                system.debug('lineItem.PricebookEntry.Product2.Environment__c:' + lineItem.PricebookEntry.Product2.Environment__c);
                if (lineItem.PricebookEntry.Product2.Environment__c == SERVERTYPE_TEST) {
                    neededServers++;
                }
                system.debug('existingServerMap.containsKey(key + SERVERTYPE_TEST): ' + existingServerMap.containsKey(key + SERVERTYPE_TEST));
                if(existingServerMap.containsKey(key + SERVERTYPE_TEST) && neededServers > 0 ){
                    List<Server__c> existingServers = existingServerMap.get(key + SERVERTYPE_TEST);
                    system.debug('existingservers: ' + existingServers);
                    servers.addAll(existingServers);
                    if(lineItem.PricebookEntry.Product2.Core_Product__c == false)
                        neededServers -= existingServers.size();
                }
               
                newServers.addAll(createServers(lineItem.Opportunity.Account.Name,SERVERTYPE_TEST,agreementNameKeyMap.get(agreementKey),neededServers));
                
                neededServers = getNeededServers(lineItem.PricebookEntry.Product2,SERVERTYPE_FAILOVER);
                if (lineItem.PricebookEntry.Product2.Environment__c == SERVERTYPE_FAILOVER) {
                    neededServers++;
                }
                if(existingServerMap.containsKey(key + SERVERTYPE_FAILOVER) && neededServers > 0 ){
                    List<Server__c> existingServers = existingServerMap.get(key + SERVERTYPE_FAILOVER);
                    servers.addAll(existingServers);
                    if(lineItem.PricebookEntry.Product2.Core_Product__c == false)
                        neededServers -= existingServers.size();
                }
                system.debug('newServers:' + newServers);
                newServers.addAll(createServers(lineItem.Opportunity.Account.Name,SERVERTYPE_FAILOVER,agreementNameKeyMap.get(agreementKey),neededServers));

                serversToInsert.addAll(newServers);
                system.debug('newServers:' + newServers+'servers :'+servers);
                servers.addAll(newServers);
                
                mapServers.put(lineItem,servers);
            }
        }
        system.debug('==== serversToInsert == ' + serversToInsert);
        
        //insert new servers
        if (serversToInsert.size() > 0) {
            insert serversToInsert;
        }
        return mapServers;
    }
    
    //Processes each lineItems , related agreement and a boolean value includeLiveServers to build whereclause for server query
    private String getWhereclauseForServer(List<OpportunityLineItem> lineItems,Map<String, Agreement__c> agreementNameKeyMap, Boolean includeLiveServers){
        String whereclause = '';        
        for (OpportunityLineItem lineItem : lineItems) {
            String agreementKey = getAgreementName(lineItem.PricebookEntry.Product2) + ':'+lineItem.Opportunity.AccountId;
            String csvAvailableServerTypes = getCSVAvailableServerTypes(lineItem.PricebookEntry.Product2,includeLiveServers);
            if(agreementNameKeyMap.containsKey(agreementKey) && csvAvailableServerTypes != ''){                        
                whereclause += ' ( ';
                whereclause += ' Name = \''+lineItem.Opportunity.Account.Name.replace('\'', '\\\'')+'\'';
                whereclause += ' and ';
                whereclause += ' Server_Type__c in ('+ csvAvailableServerTypes +') ';
                whereclause += ' and ';
                whereclause += ' Agreement__c = \''+agreementNameKeyMap.get(agreementKey).id+'\'';
                whereclause += ' ) or';
            }
        }
        whereclause = whereclause != '' ? whereclause.substring(0, whereclause.lastIndexOf('or')) : whereclause;
        system.debug('where clause - load servers: ' + whereclause);
        return whereclause;     
    }
    
    private String getCSVAvailableServerTypes(Product2 product,Boolean includeLiveServers){
        String csvServerTypes ='';        
        csvServerTypes += '\'' + SERVERTYPE_TEST + '\',';
        csvServerTypes += '\'' + SERVERTYPE_FAILOVER + '\',';
        if(includeLiveServers)
            csvServerTypes += '\'' + SERVERTYPE_LIVE + '\',';
        csvServerTypes = csvServerTypes != '' ? csvServerTypes.substring(0, csvServerTypes.lastIndexOf(',')) : csvServerTypes;
        return csvServerTypes;
    }
    
    private String getAgreementName(Product2 product){
        return product.SMSA_Product__c != null ? product.SMSA_Product__r.Product_Model__r.Name
                                                 : product.Product_Model__r.Name;
    }
    
    private String getAssetName(Product2 product){
        system.debug('product - inside getAssetName: ' + product);
        system.debug('product.Parent_Product__r.Product_Model__r.Name :'+ product.Parent_Product__r.Product_Model__r.Name != null ? product.Parent_Product__r.Product_Model__r.Name : product.Product_Model__r.Name);
        return product.Parent_Product__r.Product_Model__r.Name != null ? product.Parent_Product__r.Product_Model__r.Name
                                                                       : product.Product_Model__r.Name;
    }
    
    
  // Create servers for an agreement.
   private List<Server__c> createServers(String serverName, String serverType, Agreement__c agreement, Decimal numberOfServers) {
        List<Server__c> servers = new List<Server__c>();
        system.debug('==numberOfServers:' + numberOfServers);
        for (Integer i = 0; i < numberOfServers; i++) {
            Server__c server = new Server__c();
            server.Name = serverName;
            server.Server_Type__c = serverType;
            server.Agreement__c = agreement.Id;
            server.Account__c = agreement.Account__c;
            system.debug('server in createServers: ' + server);
            servers.add(server);
        }        
        system.debug('createServers - return servers: ' + servers);
        return servers;
    }        
    
    // Returns agreement map
    private Map<String, Agreement__c> loadAgreements(List<OpportunityLineItem> lineItems){  
        Map<String, Agreement__c> agreementNameKeyMap = new  Map<String, Agreement__c>();
        for(Agreement__c agreement : getAgreements(lineItems)){
            String key = agreement.Name + ':'+ agreement.Account__c;
            agreementNameKeyMap.put(key, agreement);
        }
        return agreementNameKeyMap;
    }
    
    //load server adding whereclause in query
    private Map<String, List<Server__c>> loadServers(String whereclause){
        Map<String, List<Server__c>> existingServerMap = new Map<String, List<Server__c>>();
        String dynamicQuery = 'select Agreement__c,Id,Name,Server_Type__c,Account__c From Server__c ';
        String Key;
        if(whereclause != null && whereclause.length() > 0){
            dynamicQuery += ' Where '+ whereclause;
            
            System.debug('3 XXX limit: '+Limits.getQueries()+'--query String--'+dynamicQuery);
            for (Server__c server : Database.query(dynamicQuery)) {
                key = server.Name + ':' + server.Agreement__c + ':'+server.Server_Type__c;
                if(!existingServerMap.containsKey(key))
                    existingServerMap.put(key,new List<Server__c>()); 
                existingServerMap.get(key).add(server);       
            }
            
        }
        return existingServerMap; 
    }
    
    //load assets where name exists assetNames 
    //and Server__r.Account__c in serverAccountIds
    private Map<String, Map<String,Asset>> loadServerAssets(Set<String> assetNames,Set<Id> serverAccountIds){        
        Map<String, Map<String,Asset>> existingServerAssetMap = new Map<String, Map<String,Asset>>();
        system.debug('assetNames - inloadServerAssets: ' + assetNames);
        system.debug('serverAccountIDs - inloadServerAssets: ' + serverAccountIDs);
        for(Asset assset : [SELECT Id,Name,Server__c, Environment__c FROM Asset WHERE Name IN :assetNames AND Server__r.Account__c IN : serverAccountIds ]){
            system.debug('assset- inloadServerAssets: ' + assset);
            system.debug('existingServerAssetMap - inloadServerAssets: ' + existingServerAssetMap);
            system.debug('existingServerAssetMap.containsKey(assset.Server__c) - inloadServerAssets: ' + existingServerAssetMap.containsKey(assset.Server__c));
            if(!existingServerAssetMap.containsKey(assset.Server__c))
               existingServerAssetMap.put(assset.Server__c,new Map<String,Asset>());            
            existingServerAssetMap.get(assset.Server__c).put(assset.Name,assset);
        }        
        return existingServerAssetMap; 
    }
    
    //load product sub items for products
    private Map<Id, List<Product_Sub_Item__c>> loadProductSubItems(Set<Id> productIds){        
        Map<Id, List<Product_Sub_Item__c>> mapProductSubItem = new Map<Id, List<Product_Sub_Item__c>>(); 
               
        for(Product_Sub_Item__c productSubItem : [
                SELECT 
                    Parent_Product__c,
                    Product__c,
                    Product__r.License_Required__c,
                    Product__r.Name,
                    Product__r.Parent_Product__r.Name,
                    Product__r.Parent_Product__r.Product_Model__c,
                    Product__r.Parent_Product__r.Product_Model__r.Name,
                    Product__r.Product_Model__c,
                    Product__r.Product_Model__r.Name,
                    Quantity__c
                FROM 
                    Product_Sub_Item__c 
                WHERE 
                    Active__c = true AND Parent_Product__c IN :productIds]){
            if(!mapProductSubItem.containsKey(productSubItem.Parent_Product__c))
                mapProductSubItem.put(productSubItem.Parent_Product__c,new List<Product_Sub_Item__c>());
            mapProductSubItem.get(productSubItem.Parent_Product__c).add(productSubItem);
        }        
        return mapProductSubItem; 
    }
        
    //Returns number of server needed for a line item 
    //the count depends on product and servertype    
    private Integer getNeededServers(Product2 product,String serverType){  
        system.debug('==getneededServers-ServerType:' + serverType);
        system.debug('==getneededServers-product.Test_Environments_Needed__c:' + product.Test_Environments_Needed__c);   
        system.debug('==getneededServers-product.Failover_Environments_Needed__c:' + product.Failover_Environments_Needed__c);    
        if(serverType == SERVERTYPE_TEST && product.Test_Environments_Needed__c != null) {
            system.debug('product.Test_Environments_Needed__c.intValue(): ' + product.Test_Environments_Needed__c.intValue());
            return product.Test_Environments_Needed__c.intValue();
        }
        if(serverType == SERVERTYPE_FAILOVER && product.Failover_Environments_Needed__c != null) {
            return product.Failover_Environments_Needed__c.intValue();  
        }
        return 0;
    }
    
    
    //Returns number of environments allowed for a line item 
    //the count depends on product and servertype    
    private Integer getAllowedEnvironments(Product2 product,String serverType,Integer cap){  
        system.debug('serverType: ' + serverType);
        system.debug('product.Exclude_from_Test_Clone__c: ' + product.Exclude_from_Test_Clone__c);      
        if(serverType == SERVERTYPE_TEST && !product.Exclude_from_Test_Clone__c) {
            system.debug('product.Test_Environments_Allowed__c: '+ product.Test_Environments_Allowed__c);
            if (product.Test_Environments_Allowed__c != null) {
                system.debug('product.Test_Environments_Allowed__c.intValue(): ' + product.Test_Environments_Allowed__c.intValue());
                return product.Test_Environments_Allowed__c.intValue();
            }
            else {
                return cap;
            }
        }
        if(serverType == SERVERTYPE_FAILOVER && !product.Exclude_from_Failover_Clone__c) {
            if (product.Failover_Environments_Allowed__c != null) {
                return product.Failover_Environments_Allowed__c.intValue();
            }
            else {
                return cap;
            }  
        }
        
        return 0;
    }
    
    //Returns min of val1 and val2.It also handles null values
    private Decimal minValue(Decimal val1,Decimal val2){
        if(val1 == null)
          return val2;
        if(val2 == null)
          return val1;
        return math.min(val1,val2);
    }
}