@isTest(SeeAllData=true)
public class LX_Test_LX_ChildOpportunity1{

/* Class Name : LX_ChildOpportunity1 
    * Description  : Test class to cover the code coverage for LX_ChildOpportunity1.
    * Created By   : Rashi
    * Created Date : 18-12-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Rashi                  18-12-2013                                   Initial Version
    
    */    
    
    /* Description : Static Test Method to create default data and call methods in the LX_ChildOpportunity1 class
       to cover the functionality of creating child opportunity .
    *  Param - None
    *  Returns :  None
  */ 
 static Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
 static testMethod void createChildOpp(){
       
        //Insert Product Model
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);

        //Insert Product
        List<Product2> product = Data_Product.createProduct(pmList);  
        //Insert PricebookEntry
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.Id, product[0].id);
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
         //Insert Opportunity    
       
         Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
         insert acc; 

         Opportunity oppt = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today(),LX_Master_Opportunity__c = TRUE); 
         insert Oppt; 

        
        List<Opportunity> opp = new List<Opportunity>();
        opp.add(oppt);
               
        String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
         //Insert Opportunity Line Item 
     
       List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp[0].id, pbe.id, categoryList );    
  
       //Insert Countries in Scope
       LX_Countries_In_Scope__c country1 = new LX_Countries_In_Scope__c(LX_Country__c = 'US',CurrencyIsoCode ='USD',LX_Exchange_Rate__c ='10',LX_Opportunity__c = opp[0].Id);
       LX_Countries_In_Scope__c country2 = new LX_Countries_In_Scope__c(LX_Country__c = 'IN',CurrencyIsoCode ='USD',LX_Exchange_Rate__c ='12',LX_Opportunity__c = opp[0].Id);
       List<LX_Countries_In_Scope__c> countriesList = new List<LX_Countries_In_Scope__c>();
       countriesList.add(country1);
       countriesList.add(country2);
       insert countriesList;
       
       list<LX_Countries_In_Scope__c> CS1=new list<LX_Countries_In_Scope__c>();
       CS1= countriesList;
       
            
        
       PageReference pageRef = new PageReference('/apex/LX_CreateChildOpportunity1?oppId='+opp[0].id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('oppId',opp[0].Id);
       //create controller instance
       ApexPages.StandardController ApptController = new ApexPages.StandardController(opp[0]);
       
       
       LX_ChildOpportunity1 controller = new LX_ChildOpportunity1(ApptController);
       controller.ChildWrap = new List<LX_ChildOpportunity1.displayChildWrapper>();
       controller.childwrap.add(new LX_ChildOpportunity1.displayChildWrapper(country1));
       controller.childwrap.add(new LX_ChildOpportunity1.displayChildWrapper(country2));
       controller.childwrap[0].check = true;
       
       controller.getSelected();
      controller.getChildOppCountries();
      
      controller.getMasterOppSelCountries();
    
       
      
    }
    
    static testMethod void createChildOpp1(){
       
        //Insert Product Model
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);

        //Insert Product
        List<Product2> product = Data_Product.createProduct(pmList);  
        //Insert PricebookEntry
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.Id, product[0].id);
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
         //Insert Opportunity    
          Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
         insert acc;
         
         Opportunity oppt = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today(),LX_Master_Opportunity__c = TRUE);
        insert Oppt;
        
        List<Opportunity> opp = new List<Opportunity>{oppt};
        String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
         //Insert Opportunity Line Item 
       List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp[0].id, pbe.id, categoryList );    
       //Insert Countries in Scope
       LX_Countries_In_Scope__c country1 = new LX_Countries_In_Scope__c(LX_Country__c = 'India',CurrencyIsoCode ='INR',LX_Exchange_Rate__c ='10',LX_Opportunity__c = opp[0].Id);
       LX_Countries_In_Scope__c country2 = new LX_Countries_In_Scope__c(LX_Country__c = 'Afganistan',CurrencyIsoCode ='OMR',LX_Exchange_Rate__c ='10',LX_Opportunity__c = opp[0].Id);
       List<LX_Countries_In_Scope__c> countriesList = new List<LX_Countries_In_Scope__c>();
       countriesList.add(country1);
       countriesList.add(country2);
       
       insert countriesList;     
       
       test.startTest();
       PageReference pageRef = new PageReference('/apex/LX_CreateChildOpportunity1?oppId='+opp[0].id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('oppId',opp[0].Id);
       //create controller instance
       ApexPages.StandardController ApptController = new ApexPages.StandardController(opp[0]);
       
       LX_ChildOpportunity1 controller = new LX_ChildOpportunity1(ApptController);
                    
       controller.ChildWrap = new List<LX_ChildOpportunity1.displayChildWrapper>();
       controller.childwrap.add(new LX_ChildOpportunity1.displayChildWrapper(country1));
       controller.childwrap.add(new LX_ChildOpportunity1.displayChildWrapper(country2));
       controller.childwrap[0].check = true;
       controller.getSelected();
       controller.getChildOppCountries();
       controller.getMasterOppSelCountries();
       controller.ChildWrap = new List<LX_ChildOpportunity1.displayChildWrapper>();
       controller.childwrap.add(new LX_ChildOpportunity1.displayChildWrapper(country1));
       controller.childwrap.add(new LX_ChildOpportunity1.displayChildWrapper(country2));
       controller.childwrap[0].check = true;
       try    
       {
       LX_ChildOpportunity1 cont= new LX_ChildOpportunity1(oppt.id);
       }
       catch(Exception e)
       {
       }
       test.stopTest();
     // controller.createChildOpp(opp[0].Id);
     //  controller.setChildOppCountries(countriesList);
       
     // 
      // controller.cancelLogic();
         
      
    }
    
 }