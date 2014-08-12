@isTest
Public class TestSute{

    static TestMethod void MyTestPersonalization()
    {
        popupwindow popupwOne = new popupwindow();
        
        Personalization__c prsn = new Personalization__c();
        prsn.User__c = UserInfo.getUserId();
        prsn.Product_Family_Name__c = 'AccessVia;BPM';
        insert prsn;
        
        popupwindow popupw = new popupwindow();
       
        popupw.getMyCheckboxes();
        popupw.closePopup();
        popupw.showPopup();
        popupwindow.ProductFamilywrapper  pfw = new popupwindow.ProductFamilywrapper();
        pfw.isChecked = True ;
        pfw.PfamilyName = prsn.Product_Family_Name__c ;
        popupw.PFlst.add(pfw);
        popupw.submit();
    }

}