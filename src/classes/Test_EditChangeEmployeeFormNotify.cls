@isTest(seealldata=true)
Public class Test_EditChangeEmployeeFormNotify{
  public static testmethod void unittest1(){
       list<Employee_Change_Request__c> valList= new list<Employee_Change_Request__c>();
       Employee_Change_Request__c testEMP = new Employee_Change_Request__c (Business_Unit__c='Brainware',New_Manager__c=userinfo.getuserid());
       insert testEMP ;
       valList.add(testEMP );
       ApexPages.currentPage().getParameters().put('id',testEMP.id);
       ApexPages.currentPage().getParameters().put('salesforceuserId', userinfo.getuserid());
       ApexPages.StandardSetController cont = new ApexPages.StandardSetController (valList);
       Account acc = Data_account.createAccount3();
       list<contact> conList = Data_Contact.createContacts(acc.id,1);
       ApexPages.currentPage().getParameters().put('conId',conList[0].id);
       EditChangeEmployeeFormNotifyController edcont = new EditChangeEmployeeFormNotifyController (cont );
       edcont.Redirect();
       edcont.createEmployeeChangeNotificationRecord();
       edcont.submit();
       edcont.save();
       edcont.cancel();
  }
  }