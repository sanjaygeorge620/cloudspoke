@isTest
private class LX_Test_SAP_Record_Extension{
   
    static testMethod void testSAPExtn(){
        ApexPages.StandardController controller;
        LX_SAP_Record_Extension sapExtn = new LX_SAP_Record_Extension(controller);
        List<LX_SAP_Record_Extension.LX_Sales_Organization_Wrapper> orgList = new List<LX_SAP_Record_Extension.LX_Sales_Organization_Wrapper>();
        orgList = sapExtn.getSalesOrg();
        System.assertNotEquals(null, orgList);
        
        PageReference pr;
        pr = sapExtn.processSelected();
        System.assertEquals(null, pr);

    }
    /*static testMethod void testSAPExtn2(){
        ApexPages.StandardController controller;
        LX_SAP_Record_Extension sapExtn = new LX_SAP_Record_Extension(controller);
        PageReference pr;
        pr = sapExtn.processSelected();
        System.assertEquals(null, pr);
    }*/

}