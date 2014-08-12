/*
Class Name : LX_NewOrderHelper
Description : Test Class for LX_NewOrderHelper.
Created By : Deepti Tadala tdeepti@deloitte.com)
Created Date : 06-02-2014
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Deepti Tadala    06-02-2014       1000                 Initial Version
*************************************************************************/

@istest(seealldata = true)

private class testLX_NewOrderHelper {
public static testmethod void accnbext () {

Account acc = Data_Account.createAccount3();
List<Contact> contacts = Data_Contact.createContacts(acc.id,1); 

LX_SAP_Record__c saprec=new LX_SAP_Record__c();
RecordType rec = [Select id from Recordtype where developername='LX_Sold_To' and SobjecttYpe='LX_SAP_Record__c'];
//saprec.Name = 'test';
insert saprec;

LX_New_Order_Request__c nor = new LX_New_Order_Request__c();
Map<id,LX_New_Order_Request__c> normap = new Map<id,LX_New_Order_Request__c>();
RecordType rec1 = [Select id from Recordtype where name='Read Only' and SobjecttYpe='LX_New_Order_Request__c'];
nor.RecordtypeId = rec1.id;
nor.LX_License_End_User__c = saprec.id;
nor.License_Contact__c = contacts[0] .id;
nor.LX_End_Date__c = system.today().adddays(2);
nor.LX_Start_Date__c = system.today();
nor.LX_Ship_To_ID__c = 'test';
nor.LX_Bill_To_ID__c = 'testa';
insert nor;
normap.put(nor.id,nor);

SAP_Contract__c sapc = new SAP_Contract__c();
sapc.Account__c= acc.id;
insert sapc;

SAP_Contract_Item__c sconi = new SAP_Contract_Item__c();
List<SAP_Contract_Item__c> sconilst = new List<SAP_Contract_Item__c>();
sconi.SAP_Contract__c = sapc.id;
sconilst.add(sconi);
insert sconilst;
Set<Id> sconiset = new Set<Id>();
sconiset.add(sconi.id);


LX_NewOrderHelper.createJunctionObject(normap,sconiset);
try{

LX_NewOrderHelper.createNewOrderCase(normap,sconiset);
}

catch(Exception e){}

  




    }
    
 }