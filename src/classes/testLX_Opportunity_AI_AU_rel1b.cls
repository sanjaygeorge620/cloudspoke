@isTest(SeeAllData=true)
public class testLX_Opportunity_AI_AU_rel1b {
    public static PricebookEntry pbe;
    public static List<Opportunity> opportunities;
    public static List<OpportunityLineItem> oppLineItem ;

    public static testMethod void testCase1() {
            List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
            List<Product2> productList = Data_Product.createProduct(pmList); 
            Pricebook2 pricebook2List = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
      
            if(pricebook2List.Id!=null&& productList!=null){
            try {
             pbe = createPriceBookEntry(pricebook2List.id, productList[0].id);   
             }
            catch (Exception ex ) {ex.getMessage(); }    
            String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            Account acc = createAccount();
    
           opportunities = new List<Opportunity>();
           //Test.startTest();
           opportunities = Data_Opportunity.createOpportunity(stageList, 1);
                   
            
            for(Opportunity tempOpp : opportunities)
            {
            tempOpp.Contract_Number__c = 'SAP001';
            tempOpp.LX_SAP_Upfront_Discount__c  = 'temp001';
            tempOpp.LX_Vistex_Backend_Rebate__c = 'temp002';
            }
          
             update opportunities;
         
            opportunities = [select Id,Name,LX_SAP_Upfront_Discount__c,Contract_Number__c,LX_Vistex_Backend_Rebate__c  from Opportunity where Contract_Number__c = 'SAP001' LIMIT 1];
           
          for(Opportunity tempOpp : opportunities)
            {
            System.assert(tempOpp.Id != null);
            tempOpp.Contract_Number__c = 'some001';
            tempOpp.LX_SAP_Upfront_Discount__c = 'some001';
            tempOpp.LX_Vistex_Backend_Rebate__c = 'some001';
            }
          
          String [] CategoryList = new List<String>();
                    CategoryList.add('Training');
                    CategoryList.add('Training');
                    CategoryList.add('Training');
          
          test.startTest() ;          
          oppLineItem = createOppLineItem(opportunities[0].id, pbe.id, categoryList );       
                    
          System.assert(oppLineItem.size() >0);
          update opportunities;
          update oppLineItem;
          Test.stopTest();                
           
                         
                   
          } }
          
          
              //methods used to create test data for account and Opportunity and OpportunityProduct
              public static Account createAccount(){
                Account acc = new Account();
                acc.Name = 'testAccount';
                acc.MDM_Sold_To_Number__c = '1234'; 
                acc.BillingCountry = 'USA';
                acc.Physical_Country__c = acc.BillingCountry;
                insert acc;
                return acc;
                } 
         
         
         public static List<OpportunityLineItem> createOppLineItem(id oppid, id PriceBookEntryId, list<String> Category){ 
         List<OpportunityLineItem> LineItems = new List<OpportunityLineItem>();   
         list<string> contractval = new list<string>();
         contractval.add('SAP Software Contract');
         contractval.add('SAP Upfront Discount');
         contractval.add('Vistex Backend Rebate');
         Integer j=0;
         for(Integer i =0;i<category.size();i++){        
            OpportunityLineItem oppLineItems = new OpportunityLineItem();
            oppLineItems.opportunityId       = oppid;
            oppLineItems.pricebookentryid    = PriceBookEntryId;
            oppLineItems.quantity            = 1;
            oppLineItems.unitprice           = 1;
         
            
            oppLineItems.Category__c             = Category[i];
            oppLineItems.Token_Type__c        = Category[i];
            if(j<=3){
           oppLineItems.LX_Contract_Type__c = contractval[j];
           j++;
           }
           else
           {
            oppLineItems.LX_Contract_Type__c = 'SAP Upfront Discount';
            }
            LineItems.add(oppLineItems);  
         }
        system.debug('lineItems entered:' + lineItems);
        insert LineItems;       
        return LineItems;  
     }
     
    public static PricebookEntry createPriceBookEntry(id pricebook2id, id product2Id){     
          //Create a pricebook entry. 
            PricebookEntry pbe2 = new PricebookEntry();
            pbe2.Pricebook2Id = pricebook2id;
            pbe2.Product2Id   = product2Id;
            pbe2.IsActive     = true;
            pbe2.UnitPrice    = 1;
           // pbe2.useStandardPrice = true ;
try {
        insert pbe2; 
        }
         catch (Exception ex ) {ex.getMessage(); }        
        return pbe2;  
  }
  }