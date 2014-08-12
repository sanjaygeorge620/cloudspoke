@isTest(seeAlldata=true)
private class Test_updateLexVertical
{
static testMethod void myUnitTest() 
{

 SIC_to_Lexmark_Verticals__c sic = new SIC_to_Lexmark_Verticals__c(Lexmark_Sub_Vertical__c = 'Test231',Lexmark_Vertical__c = 'Test234',SIC_8__c = 'Testing');
 SIC_to_Lexmark_Verticals__c sic2 = new SIC_to_Lexmark_Verticals__c(Lexmark_Sub_Vertical__c = 'Test2231',Lexmark_Vertical__c = 'Test2234',SIC_8__c = 'Testing1');
 insert sic;
 insert sic2;
   
  Lead newLead = Data_Lead.createLeads(sic.id);
     Test.Starttest();
              
         
         
         newLead.SIC_Code__c = 'Testing1';

         update newLead;     
              
     Test.StopTest();           
}
}