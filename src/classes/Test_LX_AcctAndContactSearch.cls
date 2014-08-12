/* 
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 07/23/2013
 *
 * Author : Kapil Reddy Sama.
 * 
 * Description : test class for LX_AcctAndContactSearch.
*/
@isTest(seeAllData=true)
private class Test_LX_AcctAndContactSearch {
    
    public static Account acc;
    static testMethod void myUnitTest1() {
        Test.startTest();        
        acc = data_Account.createAccount3(); 
        system.assertNotEquals(acc, Null);
        Test.setCurrentPage(Page.LX_Global_Search);   
        ApexPages.currentPage().getParameters().put('searchText','test');          
        LX_AcctAndContactSearch controller = new LX_AcctAndContactSearch();
        controller.sortExpression ='Name';
        controller.setSortDirection('ASC');
        controller.searchText = 'test';
        controller.search();
        controller.accForFilters.Name = 'test';
        controller.accForFilters.ownerid = userinfo.getUserid();
        controller.accForFilters.BillingCountry = 'US';
        controller.accForFilters.TR_Status__c = 'test'; 
        controller.accForFilters.Coverage_Status__c  = 'test';
        controller.accForFilters.ISS_Coverage_Model__c   = 'test';  
        controller.accForFilters.ISS_Coverage_Method__c   = 'test'; 
        controller.accForFilters.Local_Priority__c = 'US';
        controller.accForFilters.MPS_Qualification__c  = 'test';    
        controller.accForFilters.Party_Type__c    = 'test'; 
        controller.accForFilters.Country_Account_Rating__c  = 'test';   
        controller.accForFilters.LX_Sales_Team_Assigned__c   = 'test';
        controller.accForFilters.Primary_ISS_Internal_Segment__c     = 'test';  
        controller.accForFilters.MPS_Capable_Partner__c  = 'test';  
        controller.accForFilters.NameLocal = 'test';  
        controller.accOwner = 'Kapil';
        controller.showAccPagination();
        controller.applyAccFilters();
        controller.getpartyTypes();
        controller.getTrStatus();
        controller.getCoverageStatus();
        controller.getVerticals();
        controller.getPrimaryISSInternalSegments();
        controller.getCoverageMethods();
        controller.getCoverageModels();
        controller.getMPSQualifications();
        controller.getLocalPriorities();
        controller.showAccFilters();
        controller.showMoreFilters();
        controller.showMoreAccts();
        controller.getMPSCapablePartners();
        controller.getSortDirection();        
        controller.next();
        controller.previous();
        controller.searchText = 't';
        controller.search();
        controller.searchText = '5432167890';
        controller.search();
        
    }    
}