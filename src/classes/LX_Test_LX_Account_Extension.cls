/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 08/13/2013
*
* Author : Maruthi Kolla.
* 
* Description : Test Class for 'LX_Account_Extension'

*/

@isTest(seealldata = true)
public class LX_Test_LX_Account_Extension
{
        Static testmethod void test_Account_Extension(){
       Account acc = Data_account.createAccount3(); 
       ApexPages.StandardController controller = new ApexPages.StandardController(acc);
       List<Account> accList = new List<Account>();
       List<Contact> cntList = new List<Contact>();
       
       LX_Account_Extension lx_acc_ext = new LX_Account_Extension(controller);
       accList  = lx_acc_ext.getChidAccountList();
       cntList = lx_acc_ext.getContactList();
       
       
       //LX_Account_New_BillTo_Extension lx_acc_billto_ext = new LX_Account_New_BillTo_Extension(controller);
       //lx_acc_billto_ext.getSoldToOrg();
       //Pagereference pg_ref = lx_acc_billto_ext.saveRecord();
       
       }
}