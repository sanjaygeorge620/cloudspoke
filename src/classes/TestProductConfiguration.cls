/*********************************************************************
//Name      : TestProductConfiguration
//Author    : Aslam Bari
//Date      : 15 May, 2009
//Purpose   : Gives test coverage for ControllerProductConfiguration
*********************************************************************/
@isTest
public class TestProductConfiguration {    
    public static void testController(){
        Brand__c brand = new Brand__c();
        brand.name = 'ImageNow';
        insert brand;
        
        ProductRelease__c release = new ProductRelease__c();
        release.Brand__c = brand.id;
        release.Major__c =1;
        release.Minor__c =1;
        release.Increment__c ='1';
        insert release;
        
        Product2 pDevelopment = new Product2();
        pDevelopment.Product_Category__c = 'Client';
        pDevelopment.Name = 'test';
        insert pDevelopment;
        
        Product_Configuration__c pConf = new Product_Configuration__c();
        pConf.ProductRelease__c = release.id;
        pConf.Product__c = pDevelopment.id;
        
        insert pConf;
        
        Database_Master__c db = new Database_Master__c();
        db.Database__c = 'test';
        insert db;
        
        Product_Database__c pDatabase = new Product_Database__c();
        //pDatabase.release__c = '1.1.1';
        pDatabase.product__c = 'test';
        pDatabase.Brand__c = 'ImageNow';
        pDatabase.ProductConfig__c = pConf.id;
        pDatabase.Database_Master__c = db.id;
        insert pDatabase;
        
        Platform_Master__c pMaster1 = new Platform_Master__c();
        pMaster1.Platform__c = 'test';
        Platform_Master__c pMaster2 = new Platform_Master__c();
        pMaster2.Platform__c = 'test2';
        
        List<Platform_Master__c> lstPMaster = new List<Platform_Master__c>();
        lstPMaster.add(pMaster1);
        lstPMaster.add(pMaster2);
        insert lstPMaster;
        
        ApexPages.StandardController pcController = new ApexPages.StandardController(pConf);
        ControllerProductConfiguration controller = new ControllerProductConfiguration(pcController);
        controller.getCurrentComponents();
        controller.getCurrentPlatforms();
        controller.getCurrentDatabases();
        controller.getCurrentLicenseOptions();
        controller.viewConfiguration();
        controller.viewComponents();
        
        //Test Product Components Part
        controller.actionAddComponents();
        controller.getAllComponents();
        System.assert(controller.saveComponent() != null);
        controller.actionDeleteComponents();
        controller.getAllComponents();
        System.assert(controller.saveComponent() != null);
        
        //Test Product Licenses Part
        controller.actionAddLicenseOptions();
        //controller.getAllLicenseOptions();
        //controller.getAllLicenseOptionsWithAction('add');
        
        System.assert(controller.saveLicenseOption() != null);
        
        controller.actionDeleteLicenseOptions();
        controller.getAllLicenseOptions();
        //controller.getAllLicenseOptionsWithAction('delete');
        System.assert(controller.saveLicenseOption() != null);
        
        //Test Product Platforms Part
        controller.actionAddPlatforms();
        controller.getAllPlatforms();
        System.assert(controller.savePlatform() != null);
        controller.actionDeletePlatforms();
        controller.getAllPlatforms();
        System.assert(controller.savePlatform() != null);
        
        //Test Product Databases Part
        controller.actionAddDatabases();
        controller.getAllDatabases();
        System.assert(controller.saveDatabase() != null);
        controller.actionDeleteDatabases();
        controller.getAllDatabases();
        System.assert(controller.saveDatabase() != null);
        
        ApexPages.currentPage().getParameters().put('CHBX000000000000000','CHBX000000000000000');
        controller.getCheckBoxIds();
        controller.getButtonsRender();
        //controller.sortStandard(lstPMaster,'Platform__c');
        //controller.debug('test');
        //controller.debug('test');
        //ApexPages.currentpage().getParameters().put('id',serverID);
    }
    
}