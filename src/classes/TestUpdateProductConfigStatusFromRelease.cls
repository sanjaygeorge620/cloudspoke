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
private class TestUpdateProductConfigStatusFromRelease {
    static testMethod void myUnitTest() {
    //insert brand record
        Brand__c B = new Brand__c(Name='TestBrand',
                    description__c = 'TestBrand');
        insert B;
        
     //insert release record    
        ProductRelease__c r = new ProductRelease__c(Brand__c = b.id,
                major__c= 10.0,
                minor__c = 10.0,
                increment__c = '10.0',
                status__c = 'Beta');
        insert r;
        
    //go get brand record
          ProductRelease__c releaseRec = [select id, status__c from ProductRelease__c where id = :r.id limit 1];
     //insert product record      
        Product2 pd = new Product2(name= 'testImageNow Product',
                product_category__c = 'Agent',
                status__c = 'In Development',
                description = 'Testing ImageNowProduct');
                
        insert pd;
        
    //go get product record just inserted   
        Product2 prodRec = [select id, name from Product2 where id = :pd.id limit 1];
        
    
     //insert product configuration record      
        Product_Configuration__c newConfig = new Product_Configuration__c();
                newConfig.product__c = prodRec.id;
                newConfig.productrelease__c = releaseRec.id;
                newConfig.status__c = 'In Development';             
        insert newConfig;
            
        //get newConfiguration record
        Product_Configuration__c ProdConfig = [select id, status__c from Product_Configuration__c where id = :newConfig.id limit 1];
        
        //get release record, then update
        ProductRelease__c UpdateRelease = [select id, status__c from ProductRelease__c where id = :releaseRec.id limit 1];
        updateRelease.status__c = 'General Availability';
        
        Update UpdateRelease;
        set<Id> UpdateReleaseID = new set<Id>();
        updateReleaseID.add(updateRelease.id);
        
        test.startTest();
        UpdateProductConfig.UpdateProductConfig(updateReleaseId);
        test.stopTest();
            
        system.assertEquals('General Availability',
            [select status__c from Product_Configuration__c where id = :ProdConfig.id].status__c);

                
    }    
}