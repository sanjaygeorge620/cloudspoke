@Istest
public with sharing class Data_Campaign {
    public static Campaign createCampaign(String campaignType, String ParentCampaignID){ 
        
        //RecordType CampaignRecordType = [select id from RecordType where name = :campaignType and SobjectType = 'Campaign' ];
        //4.17.2013 from 5 to 9
        //String CampaignRecordTypeId = '012i0000000LjzV';
        //String ParentCampaignRecordTypeId = '012i0000000LjzX';
        String CampaignRecordTypeId = '012i0000000LjzVAAS';
        String ParentCampaignRecordTypeId = '012i0000000LjzXAAS';
         Campaign C = new Campaign(Name=campaignType + 'Name'); 
               
        
        if (campaignType == 'Child Campaign'){
            c.ParentId = ParentCampaignID;
            c.RecordtypeID = CampaignRecordTypeId;
        }else{
            c.RecordtypeID = ParentCampaignRecordTypeId;
        }
        
        insert C;       
        return C;  
     }      
        
        
    static testMethod void testTestData() {
         Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
         Campaign cCam = Data_Campaign.createCampaign('Child Campaign', pCam.id);       
         System.assert(cCam.id != null);
      }   

}