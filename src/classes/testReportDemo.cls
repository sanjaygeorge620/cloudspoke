@isTest(SeeAllData=true)
public class testReportDemo{
    static List<Opportunity> returnOpptyList ;
    public static testmethod void testReportDemo(){
        test.startTest();
            returnOpptyList = new List<Opportunity>();
            ReportDemo testReportDemo = new ReportDemo();
            returnOpptyList = testReportDemo.soqlquery();
        test.stopTest();
    }
}