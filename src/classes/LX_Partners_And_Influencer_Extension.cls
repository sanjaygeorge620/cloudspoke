/* 
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 07/30/2013
 *
 * Author : Kapil Reddy Sama.
 * 
 * Description : Extension for Partners and Influencers new page.
 * No more used and can be deleted 
*/

public class LX_Partners_And_Influencer_Extension {
    public string recordTypeName {get;set;}
    public LX_Competitor_Influencer_and_Partner__c partnerAndInfluencer {get;set;}
    private string recordType;
    private ApexPages.StandardController Controller;
    public string masrterRecordType {get;set;}
    public LX_Partners_And_Influencer_Extension(ApexPages.StandardController controller) {
        masrterRecordType = Schema.SObjectType.LX_Competitor_Influencer_and_Partner__c.getRecordTypeInfosByName().get('Master').getRecordTypeId();
        Controller = controller;
        recordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        //partnerAndInfluencer = (LX_Competitor_Influencer_and_Partner__c ) controller.getRecord();
        string id = ApexPages.currentPage().getParameters().get('id');
        if(id != null && id != ''){
        
        partnerAndInfluencer  = [Select id,LX_Customer_Account__c,Competitive_Technology__c,LX_Influencer_Account__c,Competitive_Services__c,
                                        LX_Strength__c,LX_Software_Solutions__c,  LX_Primary__c,LX_Current_Install_Base__c,LX_Strengths__c,LX_Weaknesses__c,
                                        Comments__c ,Competitor_Renewal_Date__c,CurrencyIsoCode,RecordTypeId,RecordType.Name                                            
                                        from LX_Competitor_Influencer_and_Partner__c where id = :id ];
        }else{
            partnerAndInfluencer  = new LX_Competitor_Influencer_and_Partner__c( );
            partnerAndInfluencer.recordTypeId = recordType; 
        }
    }
    
    public pageReference save1(){
        partnerAndInfluencer.recordtypeId = recordType ;
        try{
            upsert partnerAndInfluencer ;        
            return new pageReference('/'+partnerAndInfluencer.id);}
            catch(Exception ex){
                system.debug('Save & New failed, likely due to validation rule errors or trigger fail due to bad data or null field, value or operator. Error: '+ex);
                 ApexPages.addmessages(ex);            
                 return null;
         }
    }
    
    //Override Save and New functionality
    public pageReference saveAndNew(){
        try{
            upsert partnerAndInfluencer;
            Schema.DescribeSObjectResult describeResult = Controller.getRecord().getSObjectType().getDescribe();
            pageReference pr;
            pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e');
            pr.setRedirect(true);
            return pr; 
            }catch(Exception ex){
             system.debug('Save & New failed, likely due to validation rule errors or trigger fail due to bad data or null field, value or operator. Error: '+ex);
             ApexPages.addmessages(ex);            
             return null;
             }
    }

}