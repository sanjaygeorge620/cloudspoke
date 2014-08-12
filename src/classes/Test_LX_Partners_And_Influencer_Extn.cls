@isTest(seeAllData=true)
private class Test_LX_Partners_And_Influencer_Extn{
    public static Account acc1;
    public static Account acc2;
    public static LX_Competitor_Influencer_and_Partner__c partnerInfluencer;
    static testMethod void myUnitTest() {
       
        Test.startTest();        
        acc1 = data_Account.createAccount3(); 
        system.assertNotEquals(acc1, Null);
        acc2 = data_Account.createAccount3(); 
        system.assertNotEquals(acc2, Null);
        
        Account ai=new account(name='son',LX_Country_Code__c='', BillingCountry = 'USA', Physical_Country__c = 'USA');
               insert ai;
        
        LX_Competitor_Influencer_and_Partner__c o= new LX_Competitor_Influencer_and_Partner__c();
        
        o.Competitive_Technology__c='Color';
        //o.LX_Influencer_Account__c='';
        o.Competitive_Services__c='MPS/LFM';
        o.LX_Strength__c='Strong';
        o.LX_Software_Solutions__c='Content Solution';
        o.LX_Strengths__c='aaa';
        o.LX_Weaknesses__c='bbb';
        o.Comments__c ='hi';
        o.LX_Customer_Account__c=ai.id;
        o.LX_Influencer_Account__c=ai.id;
        
        insert o;
   
        
        partnerInfluencer = new LX_Competitor_Influencer_and_Partner__c (LX_Influencer_Account__c = acc1.id,LX_Customer_Account__c = acc2.id);
        Test.setCurrentPage(Page.LX_Partners_And_Influencers_New);
              ApexPages.currentPage().getParameters().put('id',o.id);
         
        LX_Partners_And_Influencer_Extension controller = new LX_Partners_And_Influencer_Extension  (new ApexPages.StandardController(partnerInfluencer));    
        controller.save1();
        controller.saveAndNew();
        
        Test.setCurrentPage(Page.LX_Partners_And_Influencers_New);
            ApexPages.currentPage().getParameters().put('id','');
            LX_Partners_And_Influencer_Extension controller1 = new LX_Partners_And_Influencer_Extension  (new ApexPages.StandardController(partnerInfluencer));    
            controller1.save1();
            controller1.saveAndNew();
        test.stopTest();
       }
        /*
        static testMethod void myUnitTest1() 
        {
            Test.startTest();
            Test.setCurrentPage(Page.LX_Partners_And_Influencers_New);
            ApexPages.currentPage().getParameters().put('id','');
            LX_Partners_And_Influencer_Extension controller1 = new LX_Partners_And_Influencer_Extension  (new ApexPages.StandardController(partnerInfluencer));    
            controller1.save1();
            controller1.saveAndNew();
            test.stopTest();
        }
        */    
    }