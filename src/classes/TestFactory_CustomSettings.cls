@isTest
public class TestFactory_CustomSettings {
	
	public static List<Lx_SetRecordIDs__c> testCSVCustomSettingRecordIds {get;set;}
	
	//Creates test custom settings to satisfy the "LX_SetRecordIDs.cls" class
    public static void createRecordTypeSettings() {
        
        testCSVCustomSettingRecordIds = Test.loadData(Lx_SetRecordIDs__c.sObjectType, 'TestDataCustomSettingRecordTypes');
    }
}