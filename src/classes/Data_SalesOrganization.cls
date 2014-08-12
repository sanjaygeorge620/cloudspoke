public class Data_SalesOrganization {
     public static Sales_Organization__c createSalesOrganization(){       
        Sales_Organization__c SalesOrg = new Sales_Organization__c(name='United States Test');       
        SalesOrg.include_In_VSOE__c =  true;
        salesOrg.Sales_Organization__c = '002';
        salesOrg.LX_Country_Code__c = 'IN';
        salesOrg.Status__c = 'Active';
        salesOrg.LX_Sales_Geo__c = 'AP';
        salesOrg.LX_Default__c = true;
        insert salesOrg;

        return SalesOrg;  
     }
     

      static testMethod void testTestData() {
         Sales_Organization__c SalesOrg = Data_SalesOrganization.createSalesOrganization();       
         System.assert(SalesOrg.id != null);
      }   
}