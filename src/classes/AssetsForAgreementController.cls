/*********************************************************************************
Name :AssetsForAgreementController 
Created By : Reena Acharya(Appirio Offshore)
Created Date : 10 Jan , 2013
Description : Show Asset Items on the Agreement layout , related to server.
              Controller of AssetsForAgreement page.
*********************************************************************************/
public class AssetsForAgreementController {
    Agreement__c agree; 
    public List<Asset_Item__c > assetItems {get;set;}
    public AssetsForAgreementController(ApexPages.StandardController controller) {
        agree = (Agreement__c)controller.getRecord();
        loadAssets();
    }
    
    public void loadAssets(){
       assetItems = new List<Asset_Item__c>([Select id,Name ,Environment__c,Quantity__c,Start_Date__c,End_Date__c,Status__c,Exclude__c from Asset_Item__c where Asset__r.Server__r.Server_Type__c = 'Live' and Asset__r.Server__r.Agreement__c =: agree.ID]);
    }
}