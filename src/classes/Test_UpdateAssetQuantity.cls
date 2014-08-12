/*********************************************************************************
Name : Test_UpdateAssetQuantity 
Created By : Bharti Mehta(Appirio Offshore)
Created Date : 24 Dec 2010
Usages : Testclass for Trigger UpdateAssetQuantity
*********************************************************************************/ 
@isTest
private class Test_UpdateAssetQuantity {
    
    static testmethod void unittest(){
   /*  3/1/11 - commented out test class, since we will be using a roll-up summary field instead of the UpdateAssetQuantity Trigger.
      //create account
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        
        //create assets
        List<Asset> assets = new List<Asset>();
        assets.add(new Asset(Name = 'TestAsset0',AccountId = acc.Id));
        assets.add(new Asset(Name = 'TestAsset1',AccountId = acc.Id));
        insert assets;
        
        //insert assetitems
        List<Asset_Item__c> assetItems = new List<Asset_Item__c>();
        assetItems.add(new Asset_Item__c(Name = 'TestAssetItem0', Asset__c = assets.get(0).Id , Quantity__c = 10 ));
        assetItems.add(new Asset_Item__c(Name = 'TestAssetItem1', Asset__c = assets.get(1).Id , Quantity__c = 20 ));
        insert assetItems;
        
        List<Asset> resultAssets = [SELECT Quantity__c FROM Asset WHERE Id =:assets.get(0).Id OR  Id =:assets.get(1).Id ];
        system.assertEquals(10,resultAssets.get(0).Quantity__c);
        system.assertEquals(20,resultAssets.get(1).Quantity__c);
        
        //change Asset and quantity field of asset item 
        //assetItems.get(0).Asset__c = assets.get(1).Id;
        assetItems.get(0).Quantity__c = 30;
        //assetItems.get(1).Asset__c = assets.get(0).Id;
        update assetItems;
        
        resultAssets = [SELECT Quantity__c FROM Asset WHERE Id =:assets.get(0).Id OR  Id =:assets.get(1).Id ];
        system.assertEquals(30,resultAssets.get(0).Quantity__c);
        system.assertEquals(20,resultAssets.get(1).Quantity__c);
        
        //delete asset items
        delete assetItems;
        
        resultAssets = [SELECT Quantity__c FROM Asset WHERE Id =:assets.get(0).Id OR  Id =:assets.get(1).Id ];
        system.assertEquals(0,resultAssets.get(0).Quantity__c);
        system.assertEquals(0,resultAssets.get(1).Quantity__c);
    */    
    }
    
}