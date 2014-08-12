@isTest
private class CustomerLoyaltyAccountFields_Schdl_Test {

    static testMethod void testScheduleJob() {
        test.StartTest();
        CustomerLoyaltyAccountFields_Schdl  m = new CustomerLoyaltyAccountFields_Schdl ();
        String sch = '0 0 22 1,15 * ?';
        system.schedule('Customer Loyalty Rollup Fields Batch Job', sch, m);
        test.StopTest();
    }
}