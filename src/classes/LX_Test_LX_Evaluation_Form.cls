@isTest(SeeAllData=true)
public class LX_Test_LX_Evaluation_Form{

 /* Class Name : LX_Test_LX_Evaluation_Form
    * Description  : Test class to cover the code coverage for LX_Evaluation_Form.
    * Created By   : Rashi
    * Created Date : 13-01-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Rashi                  13-01-2014                                   Initial Version
    
    */
    
    
    /* Description : Static Test Method to create default data and call methods in the LX_Evaluation_Form class
       to cover the fucntionality of creating Evaluation form.
    *  Param - None
    *  Returns :  None
  */ 
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
        LX_Evaluation_Unit_Disposition_Forms__c evalDisp = new LX_Evaluation_Unit_Disposition_Forms__c();
        evalDisp.LX_Evaluation_Unit__c = master.Id;
        evalDisp.LX_Purchaser_s_Name__c = testcontact[0].id;
        Insert evalDisp;
        List<Product_Model__c> productModelList = new List<Product_Model__c>();
        Product_Model__c   productModel = new Product_Model__c(Name = 'Test Model',Line__c = 'Printers',Series__c = 'Application Maint. & Dev',Family__c = 'Support');
        insert productModel;
        
        productModelList.add(productModel);
        List<Product2> productList = Data_Product.createProduct(productModelList);
        LX_Evaluation_Product__c evalProduct = new LX_Evaluation_Product__c();
        evalProduct.LX_Product__c = productList[0].Id;
        evalProduct.LX_Quantity__c = 2;
        evalProduct.LX_Seed_Order_Request__c = master.Id ;
        evalProduct.LX_Evaluation_Unit_Disposition_Form__c = evalDisp.Id;
        Insert evalProduct;
        
        LX_Evaluation_Unit_Details__c evalUnit  = new LX_Evaluation_Unit_Details__c();
        evalUnit.Name = 'test';
        evalUnit.LX_Evaluation_Product__c = evalProduct.Id;
        evalUnit.CurrencyIsoCode = 'USD';
        evalUnit.LX_Evaluation_Unit_Disposition_Form__c = evalDisp.Id;
        evalUnit.LX_Status__c = 'Open';
        Insert evalUnit;
       // LX_Evaluation_Unit_Disposition_Forms__c evDisRec=new LX_Evaluation_Unit_Disposition_Forms__c(LX_Evaluation_Unit__c=evalUnit.id);
        //insert evDisRec;
        Recordtype rectypeId = [Select id,name from Recordtype where name='Sell'];
        ApexPages.currentPage().getParameters().put(Label.LX_EvaluationUnit,master.Id);
        ApexPages.currentPage().getParameters().put(Label.LX_RecordType,rectypeId.Id);
        
        ApexPages.StandardController ApptController = new ApexPages.StandardController(evalDisp );
        PageReference pageRef = new PageReference('/apex/LX_Evaluation_Form');
        Test.setCurrentPage(pageRef);
        LX_Evaluation_Form controller = new LX_Evaluation_Form(ApptController);
        LX_Evaluation_Form.lineItems lineItems1 = new LX_Evaluation_Form.lineItems(true,evalUnit,evalDisp .id);
        controller.saveForm();
        
                
}
        
}