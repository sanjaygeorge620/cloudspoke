@isTest
private class LX_ChildAccount_ExtensionTest{

    static testMethod void test1() {
    
    ApexPages.StandardController controller;
    LX_ChildAccount_Extension obj1=new LX_ChildAccount_Extension(controller);
    obj1.getChidAccountList();
    }
    }