/**
 **
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-06-2013
 *
 * Author : Kapil Reddy Sama  
 * 
 * Description : test class for LX_Opportunity_BI_BU trigger
 
 */
@isTest(seealldata= true)
public class LX_Test_LX_Opportunity_BI_BU { 
    
    static testMethod void LX_Test_LX_Opportunity_BI_BU_1(){
        test.startTest(); 
        LX_Data_Opportunity.testData();
        test.stopTest();
    }
    
}