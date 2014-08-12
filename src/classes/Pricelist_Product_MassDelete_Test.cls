@isTest(seealldata = true)
private class Pricelist_Product_MassDelete_Test {

public static Opportunity opp;

        static testMethod void testSitesCaseController() 
        {
        
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'vesss', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id,EmployeeNumber='000000', 
         timezonesidkey='America/Los_Angeles', username='sta'+math.random()+'nsdard12usagcer@testorg1.com',Lx_Region__c = 'NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
                
                String [] stageList = new List<String>();
                stageList.add('Negotiation');
                Account acc = Data_Account.createAccount3();      
                List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
                List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
                List<Product2> product = Data_Product.createProduct(pmList);  
                Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
                PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
             
                List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity2(stageList,1,Acc,contacts,pmlist,
                product,pricebook2,pbe);                    
                opp = new opportunity();
                opp = test_opportunities[0];
                List<LX_Opportunity_Pricelist_Product__c> saveProdList = new List<LX_Opportunity_Pricelist_Product__c>();
                LX_Opportunity_Pricelist_Product__c offProd = new LX_Opportunity_Pricelist_Product__c();
                offProd.LX_Opportunity__c = opp.id;
                offProd.CurrencyIsoCode = 'USD';
                offProd.LX_Part_Number__c = product[0].Part_Number__c;
                offProd.Parent_ID__c = '45';
                offProd.LX_Product__c = product[0].id;
                offProd.LX_Sales_Price__c = 500;
                offProd.Quantity__c = 10;
                saveProdList.add(offProd);      
                
                insert   saveProdList;             
                
         
        system.runas(adminUser)
        { 
        test.starttest();
        system.debug('--------------------' +opp.id);
        ApexPages.currentPage().getParameters().put('OppId',opp.id);
        ApexPages.StandardController stdLead = new ApexPages.StandardController(saveProdList[0]);
       PriceListDelete deletecontroller = new PriceListDelete(stdLead);       
       deletecontroller.sQuery = 'Select Parent_ID__c,CurrencyIsoCode,LX_Opportunity__c,LX_Part_Number__c,Quantity__c,Part_Type__c,LX_Product__c,LX_Product__r.name,Product_Line__c,LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c = \''+opp.id+'\'';        
       deletecontroller.Opp_id = opp.id;
       deletecontroller.Selected_Config = '45';
       deletecontroller.selectedItem = saveProdList[0].ID;
       deletecontroller.doSelectItemR();
       deletecontroller.preSelect();
       deletecontroller.selectedItem = saveProdList[0].ID;
       deletecontroller.doDeselectItemR();
       deletecontroller.initialize();
       deletecontroller.selectedItem = saveProdList[0].ID;
       string value = '\''+saveProdList[0].ID+'\'';
       deletecontroller.Selected_Config = '';
       deletecontroller.sQuery = 'Select Parent_ID__c,CurrencyIsoCode,LX_Opportunity__c,LX_Part_Number__c,Quantity__c,Part_Type__c,LX_Product__c,LX_Product__r.name,Product_Line__c,LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c = \''+opp.id+'\'';        
       deletecontroller.delsel();
        
                try
                {
                   deletecontroller.Initialize();
                }
                catch(Exception e)
                {
                System.Debug(e);
                }
        test.stoptest();
             
          }   
          
        }
}