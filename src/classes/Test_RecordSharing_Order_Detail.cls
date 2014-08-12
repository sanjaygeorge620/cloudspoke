/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 08/6/2013
*
* Author : Maruthi Kolla.
* 
* Description : Test Class for 'RecordSharing_Order_Detail' Class.

*/

@istest
Public class Test_RecordSharing_Order_Detail 
{
    Static testmethod void ideasWithVotes(){
    Set<ID> ids1 = new Set<ID>();
    
    List<Order_Detail__c> orderDetails = new List<Order_Detail__c>();
    For(integer i=0; i<4 ; i++)
    orderdetails.add(new Order_Detail__c());
    insert orderDetails ;
    
    for(Order_Detail__c orderdetials1 : orderDetails)
    ids1.add(orderdetials1.id);
    
   
    
    RecordSharing_Order_Detail.manualShare_Order_Detail_Read(ids1);
    
    }
}