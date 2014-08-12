/**
 **
 * @Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-06-2013
 *
 * Author : Veenu Trehan
 * 
 * Description : test class for LX_OpportunityRecordTypeSelectionContrlr
 
 */
@isTest(seeAllData=True)
Private class LX_Test_LX_OpportunityRecordTypecntrl2 {
 Static User Testuser;
 Static Profile p;
 Static Account AccForOpp;
 Static Account AccForOpp1;
 Static LX_Territory__c NewTerr;
 Static LX_Territory_Member__c NewTerrMember;
 Static LX_Territory_Member__c NewTerrMember2;
 
 Static list<LX_Opp_RecordType__c > CustomSet=new list<LX_Opp_RecordType__c >();
 Static  Opportunity TestOpp;
    static void testData(){
 /*      
LX_Opp_RecordType__c Rec1 = new LX_Opp_RecordType__c(  Name='Both-Add On-False',
                                                        LX_First_Time_to_Revenue__c= 'Repeat Customer',
                                                        LX_Product_Type__c= 'Both',
                                                        LX_Sales_Type__c= 'Add On',
                                                        LX_Opportunity_Type__c= 'Expansion-Add On',
                                                        LX_Record_Type__c = 'Expansion Add On – Joint');
CustomSet.add(Rec1);
LX_Opp_RecordType__c Rec2 = new LX_Opp_RecordType__c(  Name='Both-New Proj-False',
                                                        LX_First_Time_to_Revenue__c= 'Repeat Customer',
                                                        LX_Product_Type__c= 'Both',
                                                        LX_Sales_Type__c= 'New Project',
                                                        LX_Opportunity_Type__c= 'Expansion New Solution',
                                                        LX_Record_Type__c = 'New Sales Project – Join');    
                                                    
CustomSet.add(Rec2);
LX_Opp_RecordType__c Rec3 = new LX_Opp_RecordType__c(  Name='Both-New Proj-True',
                                                        LX_First_Time_to_Revenue__c= 'First Time to Revenue',
                                                        LX_Product_Type__c= 'Both',
                                                        LX_Sales_Type__c= 'New Project',
                                                        LX_Opportunity_Type__c= 'New Solution',
                                                        LX_Record_Type__c = 'New Sales Project – Joint');
CustomSet.add(Rec3);
LX_Opp_RecordType__c Rec4 = new LX_Opp_RecordType__c(  Name='Software-Add On-False',
                                                        LX_First_Time_to_Revenue__c= 'Repeat Customer',
                                                        LX_Product_Type__c= 'Software',
                                                        LX_Sales_Type__c= 'Add On',
                                                        LX_Opportunity_Type__c= 'Expansion-Add On',
                                                        LX_Record_Type__c = 'Expansion-Add On');                
CustomSet.add(Rec4);
LX_Opp_RecordType__c Rec5 = new LX_Opp_RecordType__c(  Name='Software-New Proj-False',
                                                        LX_First_Time_to_Revenue__c= 'Repeat Customer',
                                                        LX_Product_Type__c= 'Software',
                                                        LX_Sales_Type__c= 'New Project',
                                                        LX_Opportunity_Type__c= 'Expansion New Solution',
                                                        LX_Record_Type__c = 'New Sales Project');
CustomSet.add(Rec5);
LX_Opp_RecordType__c Rec6 = new LX_Opp_RecordType__c(  Name='Software-New Proj-True',
                                                        LX_First_Time_to_Revenue__c= 'First Time to Revenue',
                                                        LX_Product_Type__c= 'Software',
                                                        LX_Sales_Type__c= 'New Project',
                                                        LX_Opportunity_Type__c= 'New Logo',
                                                        LX_Record_Type__c = 'New Sales Project');       
CustomSet.add(Rec6);
LX_Opp_RecordType__c Rec7 = new LX_Opp_RecordType__c(  Name='Tech-New Proj-False',
                                                        LX_First_Time_to_Revenue__c= 'Repeat Customer',
                                                        LX_Product_Type__c= 'Technology',
                                                        LX_Sales_Type__c= 'New Project',
                                                        LX_Opportunity_Type__c= 'New Solution',
                                                        LX_Record_Type__c = 'New Sales Project – HW');
CustomSet.add(Rec7);
LX_Opp_RecordType__c Rec8 = new LX_Opp_RecordType__c(  Name='Tech-New Proj-true',
                                                        LX_First_Time_to_Revenue__c= 'First Time to Revenue',
                                                        LX_Product_Type__c= 'Technology',
                                                        LX_Sales_Type__c= 'New Project',
                                                        LX_Opportunity_Type__c= 'New Solution',
                                                        LX_Record_Type__c = 'New Sales Project – HW');      
CustomSet.add(Rec8);                                                        
LX_Opp_RecordType__c Rec9 = new LX_Opp_RecordType__c(  Name='Tech-Run RAte-False',
                                                        LX_First_Time_to_Revenue__c= 'Repeat Customer',
                                                        LX_Product_Type__c= 'Technology',
                                                        LX_Sales_Type__c= 'Run Rate',
                                                        LX_Opportunity_Type__c= 'Run Rate',
                                                        LX_Record_Type__c = 'Run Rate');        
CustomSet.add(Rec9);                                                        
                                                        
   */                                                 

                      
        Testuser = new User(alias = 'hasrole', email='userwithrole@lexmark.com',LX_Region__c='NE',
                                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                            localesidkey='en_US', profileid = P.id,Legacy_Company__c='Lexmark',
                                            timezonesidkey='America/Los_Angeles', username='Test9898@test.com');
          //for Footprint=N/A                                  
        AccForOpp=new account(name='Test AccForOpp',
                                       License_Closed_Opp_Total__c=-100,
                                       //CurrencyIsoCode='USD-U.S. Dollar',
                                        LXK_Region__c='India',
                                       LX_Geo__c='APAC',
                                       Physical_Country__c='India',
                                       BillingCountry='India',
                                       RecordTypeID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId());
        //for other values of footprint
       AccForOpp1=new account(name='Test AccForOpp1',
                                       License_Closed_Opp_Total__c=100000000,
                                       //CurrencyIsoCode='USD-U.S. Dollar',
                                       LXK_Region__c='India',
                                       LX_Geo__c='APAC',
                                       Physical_Country__c='India',
                                       BillingCountry='India',
                                       RecordTypeID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId()                                        );
                                       
        //AccForOpp = Data_account.CreateAccount3();                             
        //AccForOpp1 = Data_account.CreateAccount3();
        NewTerr=new LX_Territory__c(Name='TestTerr',
                                                    LX_Territory_Id__c='TestTerr'  );
                                                    //CurrencyIsoCode='USD-U.S. Dollar'
                                                  

        NewTerrMember=new LX_Territory_Member__c(LX_DefaultFlag__c=true,
                                                                        Name='Terr',LX_User__c=Testuser.id);
                                                                        //CurrencyIsoCode='USD-U.S. Dollar'
        NewTerrMember2=new LX_Territory_Member__c(LX_DefaultFlag__c=false,
                                                    Name='Terr',LX_User__c=Testuser.id);
        TestOpp=new Opportunity(Name='Test Opp',CloseDate=system.today(),
                                          StageName='Developing',sector__c='Banking',
                                          ForecastCategoryName='Closed',
                                          Budget__c='aaa',
                                          Authority__c='aaa',
                                          Objectives__c='aaa',
                                          Timeline__c='aaa',
                                          Next_Steps__c='aaa',
                                          Area_of_Interest_s__c='aaa',
                                          Qualification_Level__c='Level1',
                                          Technology__c = True,
                                          LX_Sales_Type__c='New Project', 
                                          Reason_for_Conversion__c='Enterprise Government'
                                          );                                                                        
        
           
        insert Testuser ;
        insert AccForOpp;
        insert AccForOpp1;
        insert NewTerr;
        insert NewTerrMember;
        insert NewTerrMember2;
        //insert CustomSet;
                                                                        
    }
    //for continue logic when footprint is NA
static testMethod void LX_TestOpportunityRecordTypeCntr(){
     p= [select id  from profile 
         limit 1];
        testData();
        //*********terr member update for trigger
        NewTerrMember2.LX_DefaultFlag__c=true;
        update NewTerrMember2;
        //*********************
        TestOpp.Accountid=AccForOpp.id;
      insert TestOpp;                                        
   ApexPages.StandardController sc = new ApexPages.standardController(TestOpp);
    
       PageReference pageRef = Page.LX_OpportunityRecordTypeSelection;
      
       
               Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('accid',AccForOpp.id);
      
    // create an instance of the controller
    LX_OpportunityRecordTypeSelectionContrlr OppCntrlr=new LX_OpportunityRecordTypeSelectionContrlr(sc);
     //OppCntrlr.NewOpp.LX_Product_Type__c='Both';
       //OppCntrlr.NewOpp.LX_Sales_Type__c='Add On';
       //OppCntrlr.NewOpp.LX_First_Time_to_Revenue__c ='Repeat Customer';
         //OppCntrlr.continueLogic();
     //to update terr
     OppCntrlr.NewOpp.LX_Product_Type__c='Software and Technology';
       OppCntrlr.NewOpp.LX_Sales_Type__c='New Project';
       OppCntrlr.NewOpp.LX_First_Time_to_Revenue__c ='Repeat Customer';
       OppCntrlr.continueLogic(); 
    }
    //for continue logic when footprint not NA
    static testMethod void LX_TestOpportunityRecordTypeCntr1(){
    
    Account acc = Data_account.createAccount2();
    acc.LX_Country_Code__c='US';
    update acc;
     p= [select id  from profile 
         limit 1];
         
       user u = [Select id from User where profile.Name = 'System Administrator' and isActive = true limit 1];
        system.runAs(u){
        
        u.legacy_Company__c='Lexmark';
        update u;
        testData();
        TestOpp.Accountid=AccForOpp1.id;
      insert TestOpp;                                        
   ApexPages.StandardController sc = new ApexPages.standardController(TestOpp);
    
       PageReference pageRef = Page.LX_OpportunityRecordTypeSelection;
        Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('accid',AccForOpp1.id);
      
    // create an instance of the controller
    LX_OpportunityRecordTypeSelectionContrlr OppCntrlr=new LX_OpportunityRecordTypeSelectionContrlr(sc);
         OppCntrlr.continueLogic();
         
         oppCntrlr.change_sales();
         oppCntrlr.sales_list();
         try{
         oppCntrlr.GetRecordTypeId('Customer');}
         catch(Exception e){}
         
        }
    }
    //for cancel logic
    static testMethod void LX_TestOpportunityRecordTypeCntr2(){
     p= [select id  from profile 
         limit 1];
        testData();
        TestOpp.Accountid=AccForOpp1.id;
      insert TestOpp;                                        
   ApexPages.StandardController sc = new ApexPages.standardController(TestOpp);
    
       PageReference pageRef = Page.LX_OpportunityRecordTypeSelection;
        Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('accid',AccForOpp1.id);
      
    // create an instance of the controller
    LX_OpportunityRecordTypeSelectionContrlr OppCntrlr=new LX_OpportunityRecordTypeSelectionContrlr(sc);
         OppCntrlr.cancelLogic();
        
    }
    //for accid null
    static testMethod void LX_TestOpportunityRecordTypeCntr3(){
     p= [select id  from profile 
         limit 1];
        testData();
        TestOpp.Accountid=AccForOpp1.id;
      insert TestOpp;  
      
    
                                        
   ApexPages.StandardController sc = new ApexPages.standardController(TestOpp);
    
       PageReference pageRef = Page.LX_OpportunityRecordTypeSelection;
        Test.setCurrentPage(pageRef);
       
    LX_OpportunityRecordTypeSelectionContrlr OppCntrlr=new LX_OpportunityRecordTypeSelectionContrlr(sc);
         OppCntrlr.continueLogic();
         
        
    }







}