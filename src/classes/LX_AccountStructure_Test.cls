@isTest(seeAllData=true)
private class LX_AccountStructure_Test{

/*Description:This is the test method written to test LX_AccountStructure by passing test data for Account object.
*Param:None
*Returns:VOID
*/ 
    static testmethod void m1(){
        Account acc=Data_Account.createAccount3();
        Account acc1=Data_Account.createAccount3();
        acc1.Parent=acc;
        update acc1;
        Account acc2=Data_Account.createAccount3();
        acc2.Parent=acc1;
        update acc2;
        String currentId=acc.id;
      //  List<Account> accList=new List<Account>();
        //accList= [select name,id from account where id=:currentId  limit 1 ];
          Test.startTest();
           Test.setCurrentPage(page.AccountHierarchyPage);
           LX_AccountStructure l = new LX_AccountStructure();
           l.currentId= acc.id;
           l.setcurrentId(currentId);
           List<account> acList = l.TopAccount;
           List<Schema.FieldSetMember> getFields = l.getfields();
           LX_AccountStructure.ObjectStructureMap[] MapOS  = l.FormatObjectStructure(currentId);
           List<String> NodeElements = new  List<String> {'1','2','3'};
           Boolean islast = l.isLastNode(NodeElements);
           MapOS [0].getcurrentNode();
           
           //LX_AccountStructure.ObjectStructureMap o = new LX_AccountStructure.ObjectStructureMap('' , true, true, '', false, true, acc);
          Test.stopTest();
      //  LX_AccountStructure.formatObjectStructure(acc.id);
       // new ObStructureMap=new ObjectStructureMap();
    }
}