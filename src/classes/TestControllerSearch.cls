@IsTest
private class TestControllerSearch {

@isTest
private static void TestSearch(){
    //Account insert
    Account act = new Account();
    act.Name ='TestACT';
    act.Type = 'Analyst';
    act.Region__c = 'APAC';
    act.BillingCountry = 'USA';
    act.Physical_Country__c = 'USA';
    insert act;
    
    Server__c server = new Server__c();
    server.Server_Name__c ='ServerTest';
    server.Account__c = act.id;
    insert server;
    
    string serverID =server.id;
    ControllerSearch controller = new ControllerSearch();
    PageReference pg = Page.ServerCustomSearch;
    ApexPages.currentpage().getParameters().put('id',serverID);
    ApexPages.currentpage().getParameters().put('Brand','ImageNow');
    ApexPages.currentpage().getParameters().put('Release','6.5.1');
    ApexPages.currentpage().getParameters().put('Product','ImageNow Server');
    controller.doSearch();
    controller.productColName('Config');
    controller.releaseColName('Config');
    controller.GetWhereClause('Config');
    server.Search_Brand__c = '';
    controller.GetWhereClause('Config');    
    controller.GetWhereClause('');
    controller.getPrdConfigToShow();
    controller.getPrdplatformToShow();
    controller.getPrdDataBaseToShow();  
    controller.Cancel();
    controller.dataExists();
    controller.updateServerForConfig();
    
    controller.Save();
    controller.BackToPage();
    controller.updateServerForPlatForm();
    controller.updateServerForDataBase();
    controller.GetRecordsToShow();
    
    controller.server.Search_Brand__c = 'ImageNow';
    controller.server.Search_Release__c = '5.4.0';
    controller.getBrandsList();
    controller.getReleaseList();
    controller.getProductNameList();
    
    controller.server = null;
    controller.getBrandsList();
    controller.getReleaseList();
    controller.getProductNameList();
    
}
}