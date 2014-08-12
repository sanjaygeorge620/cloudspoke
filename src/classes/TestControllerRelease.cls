/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestControllerRelease {

    static testMethod void testClone() {

        Brand__c brand = new Brand__c();
        brand.name = 'ImageNow';
        insert brand;
        
        ProductRelease__c newRelease = new ProductRelease__c();
        newRelease.Brand__c = brand.id;
        newRelease.Major__c =1;
        newRelease.Minor__c =1;
        newRelease.Increment__c ='1';
        newRelease.new_Major__c =1;
        newRelease.new_Minor__c =1;
        newRelease.new_Increment__c ='100';
        insert newRelease;

        Product2 pDevelopment = new Product2();
        pDevelopment.Product_Category__c = 'Client';
        pDevelopment.Name = 'test';
        insert pDevelopment;
        
        Product_Configuration__c pConf = new Product_Configuration__c();
        pConf.ProductRelease__c = newRelease.id;
        pConf.Product__c = pDevelopment.id;
        
        insert pConf;

        Database_Master__c db = new Database_Master__c();
        db.Database__c = 'NewDB';
        db.Database_version__c = 'NewDBVersion';
        insert db;
        
        Platform_Master__c pm = new Platform_Master__c();
        pm.platform__c = 'Test';
        pm.Platform_Version__c = 'test';
        
        insert pm;
        
         Product_Platform__c newPlatform = new Product_Platform__c();             
                newPlatform.brand__c = 'ImageNow';
                newPlatform.product__c = 'Test';
                newPlatform.Platform__c = 'Test';
                newPlatform.platform_version__c = 'Test';
                newPlatform.Platform_Master__c = pm.id;
                newPlatform.Product_Master__c = pConf.id;
        
        insert newPlatform;
        
        Product_Database__c pd = new Product_Database__c();
        pd.Brand__c = 'ImageNow';
        pd.Database__c = 'NewDB';
        pd.Database_Version__c = 'NewDBVersion';
        pd.Database_Master__c = db.id;
        pd.ProductConfig__c = pConf.id;
        pd.Product__c = 'Test';
        insert pd;
        
        Component_Master__c cm = new Component_Master__c();
        cm.Component_Description__c = 'xxx';
        cm.Component_Name__c = 'test';
        cm.Component_Status__c = 'Active';
        
        insert cm;
        
         Product_Component__c newComponent = new Product_Component__c();
                newComponent.brand__c = 'ImageNow';
                newComponent.product__c = 'Test';                
                newComponent.ProductConfig__c = pConf.id;
                newComponent.Component__c = cm.id;
                newComponent.Product_SKU__c = 'Test';
                
                insert newComponent;
                
        License_Option_Master__c lm = new License_Option_Master__c();
        lm.Description__c = 'tst';
        lm.License_Option_ID__c = 'jdksl';
        
        insert lm;
        
        Product_License_Option__c newLicenseOption = new Product_License_Option__c();
                
                newLicenseOption.brand__c = 'ImageNow';
                newLicenseOption.product__c = 'Test';
                newLicenseOption.License_Option__c = lm.id;
                newLicenseOption.ProductConfig__c = pConf.id;
        
                insert newLicenseOption;
                
                
                
        
        
        
 

        Test.setCurrentPageReference(new PageReference('Page.ReleaseClone'));
        
       //ApexPages.currentPage().getParameters().put('Id','a1VQ0000000CagW');
       
        
        
     //   ProductRelease__c release = [select id, New_Major__c, New_Minor__c, , increment__c, major__c, minor__c, Brand__c, Release__c, status__c 
          ProductRelease__c release = [select id, New_Major__c, New_Minor__c, major__c, minor__c, Brand__c, Release__c, status__c, New_Increment__c 
          from ProductRelease__c where id=:newRelease.id limit 1];
          
           ApexPages.currentPage().getParameters().put('Id',release.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Release); 
        ControllerRelease extensionController = new ControllerRelease(sc);  
        PageReference pageRef = extensionController.cloneRelease();        
        
        pageRef = extensionController.back();
    }
}