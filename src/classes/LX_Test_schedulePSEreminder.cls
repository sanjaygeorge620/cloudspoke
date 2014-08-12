/* Class Name : LX_Test_schedulePSEreminder
 * Description : This test class is written to test LX_schedulePSEreminder CLass.
 * Created By : Madhurupa Ghosh
 * Created Date : 11-02-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Madhurupa Ghosh       11-02-2013       1000                  Initial Version
 
 */
 @isTest
private class LX_Test_schedulePSEreminder{
    
    static testmethod void m1(){
        test.starttest();
        LX_schedulePSEreminder obj = new LX_schedulePSEreminder();
        String tym = '00 00 12 * * ?';
        System.schedule('Job1',tym,obj);
        test.stoptest();
    }

}