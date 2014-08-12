@isTest(seeAlldata=true)
public class Data_GeographyCoverage {
     public static Geography_Coverage__c createGeographyCoverage(){  
        /*List<ID> ProfileIds = new List<ID>();
       for(Profile p : [select Id from Profile where Name ='System Administrator' limit 1]){
        ProfileIds.add(p.ID);
       }
      List<User> userList = Data_User.createUser(1, profileIds);       
      User u1 = userList[0];
      
      system.runAs(u1)
      { */
      Sales_Organization__c SalesOrgRec = null;
      Geography_Coverage__c gc = null;
        SalesOrgRec = Data_SalesOrganization.createSalesOrganization();
            
        gc = new Geography_Coverage__c(Category__c='NA');       
        gc.Area__c = 'NA';
        gc.Sub_Area__c = 'NA';
        gc.Location__c = 'United States';
        gc.Country__c = 'United States';

        gc.Sales_Organization__c = SalesOrgRec.id;
        insert gc;
        System.Debug(gc);       
        return gc;  /*
        
        Geography_Coverage__c gc = [SELECT Name, Coverage_Owner__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description__c, 
        Area__c, Category__c, LastModifiedById, LastModifiedDate, Notes__c, OwnerId, Id, Sub_Area__c, Location__c, Country__c,
         Sales_Organization__c, SystemModstamp FROM Geography_Coverage__c where area__c = 'NA' limit 1];
        */
        return gc;
        //}
        //return null;
     }
     
     public static Geography_Coverage__c createGeographyCoverage2(){   
        Sales_Organization__c SalesOrgRec1 = Data_SalesOrganization.createSalesOrganization();
            
        Geography_Coverage__c gc = new Geography_Coverage__c(Category__c='NA');       
        gc.Area__c = 'NA';
        gc.Sub_Area__c = 'NA';
        gc.Location__c = 'United States';
        gc.Country__c = 'Canada';

        gc.Sales_Organization__c = SalesOrgRec1.id;
        insert gc;
        System.Debug(gc);       
        return gc;  
     }
     

      static testMethod void testTestData() {
         Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();       
         System.assert(gc .id != null);
          Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2();       
      }   
}