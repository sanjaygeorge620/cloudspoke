/**
 **
 * @Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-06-2013
 *
 * Author : Veenu Trehan
 * 
 * Description : test class for LX_EvalProducts_Cntrl
 
 */
@isTest(seealldata=true)
Private class LX_Test_LX_EvalProducts_Cntrl {

Static testmethod void test(){
// inserting account,opportunity,contact records
        list<string> stage = new list<String>();
        stage.add('Developing');
        account testaccount = Data_account.createaccount2();
        list<contact> testcontact = Data_contact.createContacts(testaccount.Id,1);
        list<opportunity> testopportunity = Data_opportunity.createOpportunity3(stage,1,testaccount,testcontact);

LX_Seed_Order_Request__c Master = new LX_Seed_Order_Request__c();

Master.LX_Account__c = testaccount.id ;
Master.LX_Contact__c = testcontact[0].id ;
Master.LX_Opportunity__c = testopportunity[0].id ;

Insert Master ;



ApexPages.currentPage().getParameters().put(Label.LX_Eval_Unit,master.Id);
ApexPages.StandardController ApptController = new ApexPages.StandardController(Master);
LX_EvalProducts_Cntrl controller = new LX_EvalProducts_Cntrl(ApptController);
controller.addMore();
controller.addMore();
controller.count='1';
controller.delEvalProd();
controller.saveEvalProd();





}


}