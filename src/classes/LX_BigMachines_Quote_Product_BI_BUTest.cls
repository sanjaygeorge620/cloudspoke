@isTest(seeAllData=true)
public class LX_BigMachines_Quote_Product_BI_BUTest{

 static testMethod void InsertionTest() {
            
            Set<String> userProfile = new Set<String>();
            userProfile.add('Sales');
            userProfile.add('Sales Admin');
            userProfile.add('Sales Management');
            List<ID> ProfileIds = new List<ID>();
             
            for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                ProfileIds.add(profile.id);
            }
         
            List<User> newUserList = Data_User.createUser(3, ProfileIds);

            //Opportunity
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
            Test.starttest();
            insert oppRec;
            String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            
            List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(oppRec.id, pbe.id, categoryList );
            Test.stoptest();
   

   LX_Opportunity_Pricelist_Product__c OppPricePrdct = new LX_Opportunity_Pricelist_Product__c(LX_Product__c = products[0].id,LX_Sales_Price__c =5, LX_Bigmachines_Discount_Per_Unit__c = 1,LX_Part_Number__c =products[0].Part_Number__c);
   insert OppPricePrdct;
   
   BigMachines__Quote__c BMDealDskQuote = new BigMachines__Quote__c(BigMachines__Account__c = acc.id, BigMachines__Opportunity__c = oppRec.id);
   insert BMDealDskQuote;
  
   BigMachines__Quote_Product__c BMQuotePrdct = new BigMachines__Quote_Product__c(BigMachines__Quantity__c = 5,BigMachines__Quote__c=BMDealDskQuote.id, BigMachines__Product__c = products[0].id ,LX_Approved_Discount__c =2,BigMachines__Sales_Price__c = 10,Name = products[0].Part_Number__c);
   insert BMQuotePrdct;
   
   
   system.debug('Quick Bid--->'+OppPricePrdct.LX_Bigmachines_Discount_Per_Unit__c + '--->'+BMQuotePrdct.LX_Approved_Discount__c);
   system.debug('--->'+OppPricePrdct.LX_Sales_Price__c+ '--->'+BMQuotePrdct.BigMachines__Sales_Price__c);
   
   BMQuotePrdct.LX_Approved_Discount__c = 15;
   update BMQuotePrdct;
   
    
   system.debug('Quick Bid--->'+OppPricePrdct.LX_Bigmachines_Discount_Per_Unit__c + '--->'+BMQuotePrdct.LX_Approved_Discount__c);
   system.debug('--->'+OppPricePrdct.LX_Sales_Price__c+ '--->'+BMQuotePrdct.BigMachines__Sales_Price__c);
 }
}