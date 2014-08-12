@isTest(seealldata=true)
public class Test_createProjBillingItems_DS{

public static testmethod  void TestUnit1(){
  //try{

    createProjBillingItems_DS createProj = new createProjBillingItems_DS();
    List<pse__Proj__c> test_proj= Data_Project.createProject(1);
    String [] stageList = new List<String>();
    stageList.add('Negotiation');
    //Account acc = Data_Account.createAccount4();
    //List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
    
    List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);

    List<Product2> product = Data_Product.createProduct(pmList); 
Test.StartTest();
 Account acc1 = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc1; 
        List<Contact> contacts = Data_Contact.createContacts(acc1.Id,1);
        List<Opportunity> test_opportunities = new  List<Opportunity>();
        Opportunity opportunities = new Opportunity(AccountId = acc1.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
        //insert opportunities ;
        test_opportunities.add(opportunities);
        insert test_opportunities;
        
    //List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList,1,acc,contacts); 

    String [] CategoryList = new List<String>();
    CategoryList.add('Training');
    CategoryList.add('Test');
    CategoryList.add('Sample');
    Pricebook2 pb = [select id, name, isactive from Pricebook2 where isStandard = true limit 1]; 
    PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pb.id, product[0].id); 
    
    /*List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_opportunities[0].id, pbe.id, categoryList );
    for(OpportunityLineItem o : oppLineItem){
    o.Product_Family__c = 'Upgrade Service';
    }
    update oppLineItem;
    */
    OpportunityLineItem oppLineItems = new OpportunityLineItem();
    oppLineItems.OpportunityID       = test_opportunities[0].id;
    oppLineItems.pricebookentryid    = pbe.Id ;
    oppLineItems.quantity            = 1;
    oppLineItems.unitprice           = 1;
    oppLineItems.Category__c             = CategoryList[0];
    oppLineItems.Token_Type__c        = CategoryList[0];
    oppLineItems.Product_Family__c = 'Upgrade Services';
    insert oppLineItems;
        
    //system.debug('This is an opplineitem'+oppLineItem);
    List<Project_Billing_Items__c> projBillingItemList = new List<Project_Billing_Items__c>();
    Project_Billing_Items__c projitem = new Project_Billing_Items__c (Opportunity__c = test_opportunities[0].id, Project__c= test_proj[0].id);
    projBillingItemList.add(projitem);
    insert projBillingItemList ;
    
    system.debug('#$# OpList :+test_opportunities ');
    system.debug('#$# Proj :+test_proj[0]');
     
    createProjBillingItems_DS.create(test_opportunities, test_proj[0]);
   
    Test.StopTest();
  //}
  //catch(exception e){
  //}
}

}