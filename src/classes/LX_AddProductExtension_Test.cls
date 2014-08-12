@isTest(seeAllData = true)
public class LX_AddProductExtension_Test{
    static testmethod void m1(){
       Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
            ProfileIds.add(profile.id);
        }
     
        List<User> newUserList = Data_User.createUser(3, ProfileIds); 
       // User u = [Select id from User where Profile.name='System Administrator' and isActive=true and LX_Ability_to_Create_Accounts__c='Yes' limit 1];
            Account acc = new account(name='Test AccForOpp',
            License_Closed_Opp_Total__c=-100,
            //CurrencyIsoCode='USD-U.S. Dollar',
            LXK_Region__c='India',
            LX_Geo__c='APAC',
            Physical_Country__c='India',
            TR_Status__c = '',
            BillingCountry = 'India', BillingCity = 'Hyderabad', BillingState = 'Andhra Pradesh', DunsNumber = '12345', BillingPostalCode = '500081', BillingStreet='Madhapur', Website='www.deloitte.com', Phone='1234567890' );
            
            //acc.RecordTypeId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
            insert acc;
            id acct = acc.id;        
            Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');              
            Lead newLead = Data_Lead.createLeads(pCam.id); 

            List<Product_Model__c> productModels = Data_ProductModels.createProductModels(1);
            List<Product2> products = data_Product.createProduct(productModels);
            Pricebook2 pb = [select id, name, isactive from Pricebook2 where isStandard = true limit 1]; 
            PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pb.id, products[0].id); 
            RecordType OppRecType = [select id, name from RecordType where sObjectType = 'Opportunity' and name = 'Quick Bid'];              
            
            Opportunity oppRec = new Opportunity(AccountID =acc.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='Add On Solution',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology', Solution_Category__c='Back Office');
             
            oppRec.Name = 'Test Oppty';  
             
            //OppRec.Primary_Partner__c = accPrimayPartner.id; 
            oppRec.OwnerId = newUserlist[0].Id;
            oppRec.SE__c = newUserlist[1].Id;   
            oppRec.ISR__c = newUserlist[2].Id;        
            oppRec.AccountID = acct;        
            oppRec.Type = 'New Logo';        
            oppRec.Sector__c = 'State/Local';        
            oppRec.CampaignID = pCam.id;        
            oppRec.CloseDate = system.today().addDays(3);        
            oppRec.Amount = 000.00;        
            oppRec.StageName = 'Proposing';        
            OppRec.RecordTypeID = OppRecType.ID;       
            OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee'; 
                   
            //OppRec.Primary_Competitor__c = accPrimary.ID;  
            
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.      
            OppRec.Competitor_Installs__c = 'Testing';   
            //OppRec.Project_Contact__c = contacts[0].id;
            //OppRec.Top_3_Reason_for_Win__c = 'Testing';  
            OppRec.Owner_Manager__c = newUserList[1].id;
            Opprec.pricebook2Id = pb.id ;
            OppRec.Need_Established__c = true;
            OppRec.Recommenders_Met__c = true;
            OppRec.LX_ID_decision_makers_exec_sponsors__c = true;
            OppRec.Business_Case_Agreement__c = true;
            OppRec.All_Formal_Presentation_Demo_Complete__c = true;
            OppRec.Verbal_Received_Check__c = true;
            OppRec.Signed_Contract_Received__c = true;   
            oppRec.LX_Product_Type__c = 'Technology'; 
            oppRec.LX_Rollout_Start_Date__c = system.today();
            oppRec.LX_Rollout_End_Date__c = system.today() + 1;
            oppRec.LX_Ramp_Type__c = 'All At Once';
            oppRec.LX_Quick_Bid_Type__c = 'Standard';
            insert oppRec;
        
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
        List<Product2> product = Data_Product.createProduct(pmList);       
        
        list<LX_Opportunity_Pricelist_Product__c> lstOppPricelistProd = new List<LX_Opportunity_Pricelist_Product__c>();
        for(Integer i=0;i<3;i++){
            LX_Opportunity_Pricelist_Product__c oppPriceList = new LX_Opportunity_Pricelist_Product__c();
            oppPriceList.LX_Quantity__c = 1234 + i;
            oppPriceList.LX_Discount__c = 5678 + i;
            oppPriceList.LX_Opportunity__c = oppRec.id;
            oppPriceList.LX_Product__c = product[i].id;
            lstOppPricelistProd.add(oppPriceList);
        }
        insert lstOppPricelistProd;
                 
        PageReference pRef = Page.LX_AddProducts;
        pRef.getParameters().put('oppId',oppRec.Id);
        Test.setCurrentPageReference(pRef);

        Product2 prodInstance= new Product2();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(prodInstance);
        
        LX_AddProductsExtension pageInstance = new LX_AddProductsExtension(sc);
        
        System.debug('pageReference ' + pRef);  
        
        Test.startTest();
        pageInstance.quickBidType = 'Standard';
        pageInstance.getLineListFilter();
        
        pageInstance.quickBidType = 'Demo';
        pageInstance.getLineListFilter();        
        
        pageInstance.setLineFilter('Printers');
        pageInstance.setLineFilter('Options');
        pageInstance.setLineFilter('');
                
        pageInstance.getLineFilter();
        
        pageInstance.productChanged();
        pageInstance.NoProductsFound();
        pageInstance.ProductDetailsNotEntered();
        pageInstance.NoRecordsSelected();
        pageInstance.NoRecordsToBeDisplayed();
        pageInstance.RecordsNotInserted();
        pageInstance.cancelLogic();
        pageInstance.cancelLogicVF();
        
        pageInstance.lineFilter = null;
        pageInstance.lineChanged();
        
        pageInstance.lineFilter = 'Printers';
        pageInstance.lineChanged();
        
        pageInstance.lineFilter = 'Options';
        pageInstance.lineChanged();
        
        pageInstance.seriesFilter = 'Test';
        pageInstance.seriesChanged();
        
        pageInstance.seriesFilter = null;
        pageInstance.seriesChanged();
        
        pageInstance.familyFilter = 'Test';
        pageInstance.familyChanged();

        pageInstance.familyFilter = null;
        pageInstance.familyChanged();
    
        pageInstance.ProductNameFilter = 'Printer';
        pageInstance.PartNumberFilter = 'p';
        pageInstance.DescriptionFilter = 'Printer';
        pageInstance.lineFilter = 'Printers';
        
      /*  pageInstance.seriesFilter = 'test';
        pageInstance.isSeriesNotToBeDisplayed = false;
        pageInstance.familyFilter = 'test';
        pageInstance.isFamilyNotToBeDisplayed = false;
        pageInstance.isModelNotToBeDisplayed = false;
        pageInstance.modelFilter = '';*/
    
        pageInstance.getDynamicProductsFilter();
        
        pageInstance.getSavedDynamicProducts();
        
        Test.stopTest();
    }
}