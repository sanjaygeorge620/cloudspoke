/*************************************************************************************
Name : Test_LX_BillShipController
Created By : USI
Created Date : 6th Aug , 2013
Description : -Test class for coverage of class LX_BillShipController
*************************************************************************************/
@isTest(SeeallData = true)
Public Class Test_LX_BillShipController{
    @isTest
    static void testLX_BillShipController (){

        
        LX_BillShipController controller = new LX_BillShipController();
        controller.createCase();

        // Add parameters to page URL
        
        ApexPages.currentPage().getParameters().put('type', 'SELL');    
        
        
    }
}