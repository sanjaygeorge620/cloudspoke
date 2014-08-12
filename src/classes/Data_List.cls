/**************************************************************
Class Name   : Data_Schedule
Created by   : Srikanth Seela
Created Date : June 22nd, 2011
Modified By : 
Modified Date : 
Purpose      : Class for creating a List
***************************************************************/
@isTest
public class Data_List{

public static List__c createList(){
    
    List__c lo = new List__c();
    
    lo.Category_Value__c='Test Category Value';
    lo.Name='Test Name';
    lo.Department__c='Sales';
    
    insert lo;
    return lo;
    }
static testMethod void testListData(){

       try
       {
           List__c lst = Data_List.createList();
       
       
       List<List__c> lsts = new List<List__c>();
       System.debug('List being tested: '+lst);
       lsts=[SELECT OwnerId from List__c where id= :lst.id];
       System.assertNotEquals(lsts[0].id,null);
       System.assertEquals(lst.id,lsts[0].id);
       System.assertNotEquals(lst.id,null); 
       }
       catch(exception e)
       {
           System.debug(e);
       }
      
    }     
}