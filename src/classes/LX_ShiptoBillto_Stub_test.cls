@isTest(seeAllData=false)
class LX_ShiptoBillto_Stub_test{

     /* Class Name : LX_ShiptoBillto_Stub_test 
    * Description  : Test class for LX_ShiptoBillto_Stub
    * Created By   : Mayank
    * Created Date : 21-01-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Mayank          21-01-2014                                           Initial Version
    
    */
	
	public static testMethod void TestLXKBillToShipToDetailsFromSAPECCToSFDC_webservices_getBillToShipToDetailsWS_Port(){
		test.startTest();
		LX_ShiptoBillto_Stub.BillToShipToWSOutput bill2Output = new LX_ShiptoBillto_Stub.BillToShipToWSOutput();
		LX_ShiptoBillto_Stub.ShipToDetails ship2details = new LX_ShiptoBillto_Stub.ShipToDetails();
		LX_ShiptoBillto_Stub.BillToDetails bill2details = new LX_ShiptoBillto_Stub.BillToDetails();
		LX_ShiptoBillto_Stub.processBillToShipToDetails processbill = new LX_ShiptoBillto_Stub.processBillToShipToDetails();
		LX_ShiptoBillto_Stub.WSStatus wsStatus = new LX_ShiptoBillto_Stub.WSStatus();
		LX_ShiptoBillto_Stub.processBillToShipToDetailsResponse processResponse = new LX_ShiptoBillto_Stub.processBillToShipToDetailsResponse();
		LX_ShiptoBillto_Stub.BillToShipToWSOutput billWSOutput = new LX_ShiptoBillto_Stub.BillToShipToWSOutput();
		LX_ShiptoBillto_Stub.BillToShipToWSInput bill2shipOutput = new LX_ShiptoBillto_Stub.BillToShipToWSInput();
		LX_ShiptoBillto_Stub.LXKBillToShipToDetailsFromSAPECCToSFDC_webservices_getBillToShipToDetailsWS_Port bill2ship = new LX_ShiptoBillto_Stub.LXKBillToShipToDetailsFromSAPECCToSFDC_webservices_getBillToShipToDetailsWS_Port();
		test.stopTest();
	}
}