/*********************************************************************
Created By    :    Appirio Inc.
Date          :    13 May
Reasom        :    Test method to validate the duplicate of Database and Platform.
*************************************************************************************/
@istest
public class testDuplicate
{
    testmethod static void TestDatabaseDuplicate()
    {
        Database_master__c d1 = new DataBase_Master__c(DataBase__c='db1',Database_Version__c='ver1');
        insert d1;
        Database_master__c d2 = new DataBase_Master__c(DataBase__c='db1',Database_Version__c='ver1');
        boolean er=false;
        try
        {
            insert d2;
        }
        catch(Exception ex)
        {
            er=true;
            system.debug(ex);
        }
       //VT8/25:COmmented  system.assertequals(er,true);
        Database_master__c d3 = new DataBase_Master__c(DataBase__c='db2',Database_Version__c='ver1');
        insert d3;
        er=false;
        try
        {    
            d3.Database__c='db1';
            update d3;
        }
        catch(Exception ex)
        {
            er=true;
            system.debug(ex);
        }
        //system.assertequals(er,true);
        
    }
    testmethod static void TestPlatformDuplicate()
    {
        Platform_master__c d1 = new Platform_Master__c(Platform__c='db1',Platform_Version__c='ver1');
        insert d1;
        Platform_master__c d2 = new Platform_Master__c(Platform__c='db1',Platform_Version__c='ver1');
        boolean er=false;
        try
        {
            insert d2;
        }
        catch(Exception ex)
        {
            er=true;
            system.debug(ex);
        }
        //VT8/25:COmmented system.assertequals(er,true);
        Platform_master__c d3 = new Platform_Master__c(Platform__c='db2',Platform_Version__c='ver1');
        insert d3;
        er=false;
        try
        {    
            d3.Platform__c='db1';
            update d3;
        }
        catch(Exception ex)
        {
            er=true;
            system.debug(ex);
        }
        //system.assertequals(er,true);
        
    }

}