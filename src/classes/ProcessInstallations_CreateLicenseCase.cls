public with sharing class ProcessInstallations_CreateLicenseCase 
{
    public static list<Case> ProcessInstallations_CreateLicenseCase(Map<Asset,License_Key__c> licenseKeys,Map<Asset, Asset_Item__c> AssetMap, OpportunityLineItem OppLineItemRec, List<Server__c> Servers, Id recordTypeId, List<Case> Cases, Boolean ReturnValue)
    {  
        
        Integer index = 0;
//        system.debug('license-External recordtype in create license case: ' + recordTypeId);
        String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c;        
 //       List<Case> cases = new List<Case>();
        
        List<Asset> LicenseKeySet = new List<Asset>(licenseKeys.keyset());
        
        
        for(Asset keyset : LicenseKeySet ){
        
            License_Key__c licenseKey = LicenseKeys.get(keyset);
                Asset_Item__c assetItem = AssetMap.get(keyset);
                
                string serverRecType = '';          
                for (Server__c serverRec : Servers){                //environment is not set on asset at this point, need to get from server.
//                  system.debug('server rec - case: ' + serverRec);
                    if (serverRec.id == keyset.Server__c) { 
                        serverRecType = serverRec.Server_Type__c;
//                      system.debug('serverRecType: ' + serverRecType);
                    }
               }   
               
               String ReturnValue_Text;
               if (ReturnValue == true){
                    ReturnValue_Text = 'Yes';
               }else{
                    ReturnValue_Text = 'No';
               }

                Case newCase = new Case();
                newCase.RecordtypeID = recordTypeId;
                newCase.Internal_Case_Account__c = OppLineItemRec.Opportunity.AccountId;
             
                //newCase.ContactId = opportunity.Ship_To__c;
                newCase.Originating_Company__c = OppLineItemRec.Originating_Company__c;
                newCase.Opportunity_Type__c = OppLineItemRec.Opportunity.Type; //Added by Manoj for US1172 on 3/30/12
                /* 3 below added for US1528  8.1.2012 Appirio */
                newCase.Admin_Contact_Name__c = OppLineItemRec.Opportunity.Admin_Contact__r.Name;
                newCase.Admin_Contact_Email__c = OppLineItemRec.Opportunity.Admin_Contact__r.Email; 
                newCase.Admin_Contact_Phone__c = OppLineItemRec.Opportunity.Admin_Contact__r.Phone;
                //newCase.ContactId = '0037000000t4gzv';
                newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
                newCase.Status = 'New';
                newCase.Impact__c = 'Enterprise';
                newCase.Urgency__c = 'Medium';
                newCase.Origin = 'Automation';
                newCase.Type = 'Request';
                newCase.Return__c = ReturnValue;
                newCase.Category__c = 'License Request';
                newCase.Level_1__c = 'License – Additional';
                newCase.Node_ID_File_Name__c = 'Not Available';
                newCase.Version__c = 'Not Available';
                newCase.Specific_Licenses_Requested__c = 'Not Available';
                newCase.Subject = 'Order Processed - ' + assetItem.Name;
                newcase.Environment__c = serverRecType;
                newcase.License_Key__c = licenseKey.id;
                newCase.Description = 'Model: ' + keyset.Name + '\n'
                                    + 'Product: ' + assetItem.Name + '\n'
                                    + 'Quantity: ' + assetItem.Quantity__c + '\n'
                                    + 'Opportunity Number: ' + (OppLineItemRec.Opportunity != null ? OppLineItemRec.Opportunity.get('Opportunity_Number__c') : '' )+ '\n'
                                    + 'Link: ' + baseUrl + '/' + licenseKey.id  + '\n'
                                    + 'Return: ' + ReturnValue_Text;    
                                    
                          
                                    
                              
                cases.add(newCase);
                
            
        }
        system.debug('==== cases == ' + cases);
//        insert cases;
         return cases;
    }
    public static void ProcessInstallations_CreateAcuoLicenseCase(map<ID,List<OpportunityLineItem>> Acuocasemap)
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('HelpDesk').getRecordTypeId();
        
    List<Case> AcuoCases = New List<Case>();
    for(ID oppid : Acuocasemap.Keyset())
   {
   string Url = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppid;
   opportunitylineitem otm = Acuocasemap.get(oppid)[0];
                Case newCase = new Case();
                newCase.RecordtypeID = recordTypeId;
                newCase.Internal_Case_Account__c = otm.Opportunity.AccountId;        
                //newCase.ContactId = '0037000000t4gzv';
                newCase.Status = 'New';
                newCase.Impact__c = 'Enterprise';
                newCase.Urgency__c = 'High';
                newCase.Origin = 'Cases';
                newCase.Type = 'Request';                
                newCase.Category__c = 'Enterprise Application';
                newCase.Level_1__c = 'Salesforce.com';                
                newCase.Subject = 'Create Install Base';               
                newCase.Description = 'Opportunity Number:' + otm.Opportunity.get('Opportunity_Number__c')  + '\n'+ 'Link: '+Url;  
                AcuoCases.add(newCase);                                                     
                                  
   
   }
   insert AcuoCases;
    }
}