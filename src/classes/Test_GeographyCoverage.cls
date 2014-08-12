@isTest
private class Test_GeographyCoverage {

    static testMethod void TestGeographyCoverage () {

     
        
        /* Instantiate an instance of this class so we can call it's setup method. */
        Test_GeographyCoverage testclass = new Test_GeographyCoverage();
               
        /* create a case with the relevant child objects */
        Geography_Coverage__c gc = testclass.setupTestCoverage();
                
        /* Setup the controller with and test context per the helper method. */
       GeographyCoverage controller = testclass.setupController(gc);
       
       integer Categorynum =[select count() 
                            from Perceptive_Config_Value__c 
                            where name = 'Category']; 
       system.assertequals(controller.getCategories().size(),Categorynum+1); /*adding 1 because I add a --none-- value to the SelectOption*/
       
       controller.setCategory(gc.Category__c);
       
        Sales_Organization__c sales_org = new Sales_Organization__c();
        sales_org.Name = 'testaa';
        sales_org.Status__c = 'Active';
        sales_org.LX_Country_Code__c = 'In';
        sales_org.Sales_Organization__c = '47';
        sales_org.LX_Default__c = true;
        insert sales_org;
       
       Geography_Coverage__c geo_cov = new Geography_Coverage__c();
       geo_cov.Country__c = 'United States';
       geo_cov.Category__c = 'International';
       geo_cov.Sales_Organization__c = sales_org.id;
       insert geo_cov;
        
       Perceptive_Config_Group__c per_config_grp = new Perceptive_Config_Group__c();
       per_config_grp.Name = 'test';
       per_config_grp.Key__c = 'testa';
       per_config_grp.Description__c = 'testb';
       insert per_config_grp;
   
       Perceptive_Config_Option__c per_config_opt = new Perceptive_Config_Option__c();
       per_config_opt.Name = 'testc';
       per_config_opt.Description__c = 'testd';
       per_config_opt.Perceptive_Config_Group__c = per_config_grp.id;
       insert per_config_opt;
             
       Perceptive_Config_Value__c per_config_val_test = new Perceptive_Config_Value__c();
       per_config_val_test.Name = geo_cov.Category__c + ' Category';
       per_config_val_test.Perceptive_Config_Option__c = per_config_opt.id;
       insert per_config_val_test;
        
       
       String CategoryChoice = gc.Category__c + ' Category';
       integer Areasnum =[select count() 
                            from Perceptive_Config_Value__c 
                            where Name = :CategoryChoice];
       system.assertequals(controller.getAreas().size(),Areasnum+1); /*adding 1 because I add a --none-- value to the SelectOption*/
         
       controller.setArea(gc.Area__c);
         
       String areaChoice = gc.Area__c + ' Area';
       integer SubAreasnum =[select count() 
                            from Perceptive_Config_Value__c 
                            where Name = :areaChoice];
        system.debug('getSubAreas Results: ' + controller.getSubAreas());
       system.assertequals(controller.getSubAreas().size(),SubAreasnum+1); /*adding 1 because I add a --none-- value to the SelectOption*/
       
       controller.setSubArea(gc.Sub_Area__c);
       
       String subareaChoice = gc.Sub_Area__c + ' Sub Area';
       system.debug('subAreaChoices: ' + subareaChoice);
       integer locationnum =[select count() 
                            from Perceptive_Config_Value__c 
                            where Name = :subareaChoice];
        system.debug('getLocations Results: ' + controller.getLocations());
       system.assertequals(controller.getLocations().size(), locationnum+1); /*adding 1 because I add a --none-- value to the SelectOption*/
       
       controller.setLocation(gc.Location__c);  
       
       
       String locationChoice = gc.Location__c + ' Location';
       system.debug('locationChoices: ' + locationChoice );
       system.debug('countryChoises select:' + [select count() from Perceptive_Config_Value__c where Name = :locationChoice ]);

       integer countrynum =[select count() 
                            from Perceptive_Config_Value__c 
                            where Name = :locationChoice ];
        system.debug('getCountriesResults: ' + controller.getCountries());
        system.debug('countrynum:' + countrynum);
       system.assertequals(controller.getCountries().size(), countrynum +1); /*adding 1 because I add a --none-- value to the SelectOption*/
       
       controller.setLocation(gc.Location__c);  
         
       controller.save();
       controller.getArea();
       controller.getCategory();
       controller.getSubArea();
       controller.getLocation();
       controller.getCountry();
       controller.setCountry(gc.Country__c);
       controller.getSalesOrg();
       controller.setSalesOrg(gc.Sales_Organization__c );
       
       
                              

    }

    private Geography_Coverage__c setupTestCoverage() {
           
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();
        system.debug('testCoverage ID' + gc.id);
        return gc;
    }
    
    private GeographyCoverage setupController(Geography_Coverage__c CoverageRec) {
    
       GeographyCoverage controller = new GeographyCoverage(new ApexPages.StandardController(CoverageRec));
       PageReference p = Page.GeographyCoverage;
        
       p.getParameters().put('id',CoverageRec.id);
       Test.setCurrentPage(p);
        
       return controller;
    }
}