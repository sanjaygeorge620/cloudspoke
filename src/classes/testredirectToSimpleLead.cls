@isTest(SeeAllData=true)
public class testredirectToSimpleLead{
    static pageReference redirectPage ;
    public static testmethod void testredirectToSimpleLead(){
    test.startTest();
        redirectToSimpleLead newRedirect = new redirectToSimpleLead();
        redirectPage = newRedirect.redirectToSimpleLead();
    test.stopTest();
    }
}