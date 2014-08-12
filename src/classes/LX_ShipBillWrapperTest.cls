@isTest(seeAllData = true)
Public class LX_ShipBillWrapperTest{

public static testmethod void test1(){

Boolean Isselected = false;

try{
Object compareTo;
//LX_ShiptoBillto_Stub.ShipToDetails ship;
//LX_ShiptoBillto_Stub.BillToDetails ship2;
//LX_shipbillWrapper lwrap=new LX_shipbillWrapper(true,ship);
//LX_shipbillWrapper lwrap1=new LX_shipbillWrapper(true,ship2);
LX_ShipBillWrapper lwrap2=new LX_ShipBillWrapper();
String LX_ASC = 'ASC';
String LX_DESC='DESC';
lwrap2.compareTo(compareTo);
}
catch(Exception e){}  


LX_ShiptoBillto_Stub shipto_innerclass = new LX_ShiptoBillto_Stub();
LX_ShiptoBillto_Stub.ShiptoDetails var = new LX_ShiptoBillto_Stub.ShiptoDetails();
LX_ShiptoBillto_Stub ship_det = new LX_ShiptoBillto_Stub();
LX_shipbillWrapper ship_bill_wrap = new LX_shipbillWrapper(Isselected,var);

LX_ShiptoBillto_Stub.BillToDetails Bill_to_Details= new LX_ShiptoBillto_Stub.BillToDetails();
LX_shipbillWrapper ship_bill_wrap1 = new LX_shipbillWrapper(Isselected,Bill_to_Details);

LX_shipbillWrapper ship_bill_wrap2 = new LX_shipbillWrapper();
LX_shipbillWrapper ship_bill_wrap3 = new LX_shipbillWrapper();


}
}