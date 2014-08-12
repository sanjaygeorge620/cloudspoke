@isTest(seeAllData = true)
Public class LX_CustonSoldtoLookupController2Test{

public static testmethod void test1(){

try{
ApexPages.currentPage().getParameters().put('type','BILL');
LX_CustonSoldtoLookupController2 obj1=new LX_CustonSoldtoLookupController2();
obj1.sortExpression='';
obj1.getsortDirection();
obj1.setSortDirection('ASC');
obj1.getresultList();
obj1.searchBoolean=true;
obj1.viewSoldToData();
obj1.go();
LX_SAP_Record_Sales_Org__c soldToObject;
LX_CustonSoldtoLookupController2.customSoldToWrapper wrp=new LX_CustonSoldtoLookupController2.customSoldToWrapper(soldToObject);
}
catch(Exception e){}


}

public static testmethod void test3(){

try{
ApexPages.currentPage().getParameters().put('type','SELL');
LX_CustonSoldtoLookupController2 obj1=new LX_CustonSoldtoLookupController2();
obj1.sortExpression='';
obj1.getsortDirection();
obj1.setSortDirection('ASC');
obj1.getresultList();
obj1.searchBoolean=true;
obj1.viewSoldToData();
obj1.go();
LX_SAP_Record_Sales_Org__c soldToObject;
LX_CustonSoldtoLookupController2.customSoldToWrapper wrp=new LX_CustonSoldtoLookupController2.customSoldToWrapper(soldToObject);
}
catch(Exception e){}


}


public static testmethod void test2(){

try{

ApexPages.currentPage().getParameters().put('type','SOLD');
LX_CustonSoldtoLookupController2 obj1=new LX_CustonSoldtoLookupController2();
obj1.getsortDirection();
obj1.setSortDirection('ASC');
obj1.getresultList();
obj1.searchBoolean=true;
obj1.viewSoldToData();
obj1.go();
LX_SAP_Record_Sales_Org__c soldToObject;
LX_CustonSoldtoLookupController2.customSoldToWrapper wrp1=new LX_CustonSoldtoLookupController2.customSoldToWrapper(soldToObject);
ApexPages.currentPage().getParameters().put('type','BILL');
LX_CustonSoldtoLookupController2 obj2=new LX_CustonSoldtoLookupController2();
obj2.getsortDirection();
obj2.setSortDirection('ASC');
obj2.getresultList();
obj2.searchBoolean=true;
obj2.viewSoldToData();
obj2.go();
LX_CustonSoldtoLookupController2.customSoldToWrapper wrp2=new LX_CustonSoldtoLookupController2.customSoldToWrapper(soldToObject);
ApexPages.currentPage().getParameters().put('type','SELL');
LX_CustonSoldtoLookupController2 obj3=new LX_CustonSoldtoLookupController2();

obj3.getsortDirection();
obj3.setSortDirection('ASC');
obj3.getresultList();
obj3.searchBoolean=true;
obj3.viewSoldToData();
obj3.go();
LX_CustonSoldtoLookupController2.customSoldToWrapper wrp3=new LX_CustonSoldtoLookupController2.customSoldToWrapper(soldToObject);
}
catch(Exception e){}


}

}