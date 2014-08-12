@isTest(seeAllData = True)
public class LX_Test_SitesAccountController{
    public static List<Asset> testAssetList;
    public static List<Asset> retAssetValueList;
    public static List<license_key__c> retLicenseValueList;
    public static List<SitesAccountController.AssetWrapper> retAssetWrap;
    public static List<SitesAccountController.LicenseWrapper> retLicWrap;
    public static List<Server__c> retServer;
    public static List<Contact> retContact;
    public static List<user> retUser;
    public static List<Order__c> retOrder;
    public static List<Perceptive_Site_Content__c> retPSC;
    
    public static testmethod void testFunc(){

    try{
        testAssetList = new List<Asset>();
        testAssetList = [Select id from Asset limit 1];
        ApexPages.currentPage().getParameters().put('id',testAssetList[0].id);
        SitesAccountController testInstance = new SitesAccountController();
        //SitesController testSites = new SitesController();
        retAssetValueList = new List<Asset>();
            retAssetValueList = testInstance.getLiveProducts();
            retAssetValueList = testInstance.getFailoverProducts();
            retAssetValueList = testInstance.getTestProducts();
            retAssetValueList = testInstance.getProducts('Test');
        
        retLicenseValueList = new List<license_key__c>();
            retLicenseValueList = testInstance.getLicenses('Test');
           // retLicenseValueList = testInstance.getLicenses();
        /*
            retLicenseValueList = testInstance.getLiveLicenses();
            retLicenseValueList = testInstance.getFailoverLicenses();    
            retLicenseValueList = testInstance.getTestLicenses();
        */
            
        retAssetWrap = new List<SitesAccountController.AssetWrapper>();
            retAssetWrap = testInstance.getAllProducts();
            retAssetWrap = testInstance.getProducts();
        retLicWrap = new List<SitesAccountController.LicenseWrapper>();
            retLicWrap = testInstance.getLiveLicenses();
            retLicWrap = testInstance.getFailoverLicenses();
            retLicWrap = testInstance.getTestLicenses();
            retLicWrap = testInstance.getNewLicenses('Test');
            
        PageReference p = testInstance.submitLicenseRequest();
            p = testInstance.createContact();
        
        retServer = new List<Server__c>();
            retServer = testInstance.getLiveServers();
            retServer = testInstance.getFailoverServers();
            retServer = testInstance.getTestServers();
        
        retContact = new List<Contact>(); 
            retContact = testInstance.getActiveContacts();
            retContact = testInstance.getInactiveContacts();
            
       retUser = new List<user>();
           retUser = testInstance.getPortalContacts();
       
       retOrder = new List<Order__c>();
           retOrder = testInstance.getOrders();
       
       retPSC = new List<Perceptive_Site_Content__c>();
           retPSC = testInstance.getWidgetEventResources();         
        
    Asset asse = new Asset();
    asse.name = 'testa';
    asse.CurrencyIsoCode = 'USD';
  
    insert asse;
    
    Asset_Item__c ass_item = new Asset_Item__c();
    ass_item.Name = 'testa';
    ass_item.Asset__c = asse.id;
    insert ass_item;
    License_Key__c lisence_key = new License_Key__c();
    lisence_key.Name = 'test';
    lisence_key.Asset_Item__c = ass_item.id;
    insert lisence_key;
    
SitesAccountController sites_ctrl = new SitesAccountController ();
SitesAccountController.LicenseWrapper var = new SitesAccountController.LicenseWrapper('test',lisence_key);
    }
    catch(Exception e){
        System.debug(e);
    }


    }
    


}