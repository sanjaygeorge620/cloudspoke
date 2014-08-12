/* Class Name : LX_Test_AccountCompetitor
 * Description : This is a test class for Triggers CreateOpportunityCompetitor and DeleteOppportunityCompetitor
 * Created By : Abhishek Jain(Deloitte)
 * Created Date : 6-3-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Abhishek Jain        6-3-2013                        Initial Version
 * Sumedha Kucherlapati 6-22-2013 
 * Kapil Reddy Sama     8-14-2013                       Migrated to QA
 */

@isTest(seeAlldata =true)
public class LX_Test_AccountCompetitor{ 

/*Description:This is the test method written to test triggers CreateOpportunityCompetitor and DeleteOppportunityCompetitor
*Param:None
*Returns:VOID
*/ 
  
    public Static  TestMethod void DeleteAccountCompetitor(){
        Opportunity test_opportunities;        
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        User u = [Select id from User where Profile.name='System Administrator' and isActive=true and LX_Ability_to_Create_Accounts__c='Yes' limit 1];
        System.runAs(u){ 
            for(Opportunity TempOpp:Data_Opportunity.createOpportunity(stageList, 3)){
                if(TempOpp.Primary_Partner__c!=null)
                    test_opportunities=TempOpp;
            }           
        }
               
        //OptyCompetitor.Name = TestCompetitor; 
        Account ObjAccount=new account(Id=test_opportunities.AccountID);
        ObjAccount.RecordTypeId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        update ObjAccount;
            
        Account accLoactionCustomer= Data_Account.createAccount3();
        accLoactionCustomer.RecordTypeId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
        Update accLoactionCustomer;

        Test.startTest();
        
        test_opportunities.AccountID=accLoactionCustomer.Id;
        test_opportunities.Primary_Partner__c=ObjAccount.Id;
        update  test_opportunities;
        
        // ObjAccount.RecordTypeId=Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
        //update ObjAccount;
        
        Account acc = Data_Account.createAccount3();
        acc.RecordTypeId =  Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        update acc;
    
        LX_Opportunity_Competitor__c OptyCompetitor = new LX_Opportunity_Competitor__c();
        OptyCompetitor.LX_Competitor_Account__c = acc.id;
        OptyCompetitor.LX_Opportunity__c = test_opportunities.id;
        OptyCompetitor.LX_Type__c = 'Competitor';
        insert OptyCompetitor;

            
        Account accInfluencer = Data_Account.createAccount3();
        accInfluencer.RecordTypeId =  Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
        accInfluencer.Party_Role__c='Influencer';
        update accInfluencer;
                  
        List<Opportunity_Influencer__c> LX_List_Opportunity_Influencer=new List<Opportunity_Influencer__c>();
        Opportunity_Influencer__c Lx_ObjInfluencer=new Opportunity_Influencer__c();
        Lx_ObjInfluencer.LX_Influencer_Account__c= accInfluencer.id;
        Lx_ObjInfluencer.RecordTypeId=LX_SetRecordIDs.InfluencerPartnerId;
        Lx_ObjInfluencer.LX_Opportunity__c = test_opportunities.id;
        Lx_ObjInfluencer.LX_Type__c = 'Influencer';
        LX_List_Opportunity_Influencer.Add(Lx_ObjInfluencer);
        insert Lx_ObjInfluencer;
        //Lx_ObjInfluencer.LX_Influencer_Account__c= acc.id;
        //update Lx_ObjInfluencer;      
        
        accInfluencer.Party_Role__c='Distributor';
        update accInfluencer;
        
        Opportunity_Influencer__c Lx_ObjInfluencerPartner=new Opportunity_Influencer__c();
        Lx_ObjInfluencerPartner.LX_Influencer_Account__c= accInfluencer.id;
        Lx_ObjInfluencerPartner.RecordTypeId=LX_SetRecordIDs.InfluencerPartnerId;
        Lx_ObjInfluencerPartner.LX_Opportunity__c = test_opportunities.id;
        Lx_ObjInfluencerPartner.LX_Type__c = 'Distributor';
        insert Lx_ObjInfluencerPartner;
        LX_List_Opportunity_Influencer.Add(Lx_ObjInfluencerPartner);
        
        //Lx_ObjInfluencerPartner.LX_Influencer_Account__c= acc.id;
        //insert LX_List_Opportunity_Influencer;        
        //update LX_List_Opportunity_Influencer;
          delete OptyCompetitor;
        Test.stopTest();
    }      
}