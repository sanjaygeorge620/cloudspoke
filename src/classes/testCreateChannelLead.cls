@isTest(seealldata=true)
private class testCreateChannelLead
{
        public static Schema.DescribeSObjectResult des = Schema.SObjectType.Lead; 
        public static Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
        public static Id MRrtId = rtMap.get(Lx_SetRecordIDs__c.getInstance('Lead_UnlockedRecordType').Value__c).getRecordTypeId();   
        public static Schema.DescribeSObjectResult des1 = Schema.SObjectType.Account; 
        public static Map<String,Schema.RecordTypeInfo> rtMap1 = des1.getRecordTypeInfosByName();
        
static testMethod void testSingleInsert()
{
     Id MRrtacctId = rtMap1.get('Location Partner').getRecordTypeId();    
     Account pcct = Data_Account.createAccount3();
     pcct.recordtypeId= MRrtacctId;
     update pcct;
     Lead_CLone__c ld = new lead_clone__c();
     Lead_CLone__c ld2 = new lead_clone__c();
     ld.Lead_RecordType__c = MRrtId;
     System.debug(pcct.ID);
     ld.Primary_Partner__c = pcct.ID;
     ld.Reason_For_Conversion__c = 'Sales'; 
     ld.company__c = 'Tect Channel';
     ld.First_Name__c = 'Testing';
     ld.Last_name__c = 'Test Last name 1234556789987654321';
     ld.Title__c = 'Test Title';
     ld.Department__c = 'Advancement';
     ld.Industry__c = 'Agriculture';
     ld.Phone__c = '27973663';
     Ld.Email__c = 'Test@Channel.com';
     Ld.Website__c = 'Testchannel.com';
     Ld.Sector__c = 'Federal';
     Ld.Lead_Type__c = 'Partner';
     Ld.Host_Manufacturer__c = 'Datatel';
     Ld.Budget__c = 'Test Budget';
     Ld.Need_Objectives__c = 'Access Security';
     Ld.Host_Application__c = 'ActiveCampus';
     Ld.Current_Solution__c = 'Homegrown';
     Ld.Timeline__c = 'Test TIme';
     Ld.Preferred_Language__c = 'English';
     Ld.Opportunity_Lead_Notes__c = 'Test opportunity lead';
     Ld.Region__c = 'APAC';
     Ld.Physical_Country__c = 'Armenia';
     Ld.Physical_Street_Address__c = 'Sultan Bazr' ;
     Ld.Physical_Street_Address_2__c = 'chaderghat';
     Ld.physical_city__c = 'armistan';
     Insert ld;
     
     group grp = [SELECT ID FROM Group where name = 'Channel.New'];
     ld2.Opportunity_Name__c = 'Test';
     ld2.Opportunity_Owner__c = Userinfo.getuserId();
     ld2.Close_Date__c = system.today().addDays(3);
     ld2.Stage__c = 'Closed Won';
    // Test.StartTest(); 
    
    Insert ld2;
   // Test.StopTest();  

                            
    lead_clone__c ldc = [Select ID,Parent_Lead__c from lead_clone__c where ID =: ld.ID limit 1];
    
    //Lead l = [Select ID from Lead where LastName = 'Test Last name 1234556789987654321' limit 1];
   
    //VT:8/25 COmmented System.assertequals(l.ID,ldc.Parent_Lead__c); 
   } 
    //for channel Opp creation from Submit lead submit if account type is Partner-OEM
    
 
//Do not uncomment
    /*static testMethod void testBulkInsert()
{
    List<lead_clone__c> ldclst = new List<lead_clone__c>();
    
    for(integer i = 0; i<200;i++)
    {
    ldclst.add(new lead_clone__c(Lead_RecordType__c = MRrtId,
 Primary_Partner__c = pcct.ID,
 Reason_For_Conversion__c = 'Sales', 
 company__c = 'Tect Channel',
 First_Name__c = 'Testing',
 Last_name__c = 'Test Last name 1234556789987654321',
 Title__c = 'Test Title',
 Department__c = 'Advancement',
 Industry__c = 'Agriculture',
 Phone__c = '27973663',
 Email__c = 'Test@Channel.com',
 Website__c = 'Testchannel.com',
 Sector__c = 'Federal',
 Lead_Type__c = 'Partner',
 Host_Manufacturer__c = 'Datatel',
 Budget__c = 'Test Budget',
 Need_Objectives__c = 'Access Security',
 Host_Application__c = 'ActiveCampus',
 Current_Solution__c = 'Homegrown',
 Timeline__c = 'Test TIme',
 Preferred_Language__c = 'English',
 Opportunity_Lead_Notes__c = 'Test opportunity lead',
 Region__c = 'APAC',
 Physical_Country__c = 'Armenia',
 Physical_Street_Address__c = 'Sultan Bazr' ,
 Physical_Street_Address_2__c = 'chaderghat',
 physical_city__c = 'armistan'));    
    }
        insert ldclst;
    
    List<Lead> lst = [Select ID from Lead where LastName = 'Test Last name 1234556789987654321'];
    
    System.assertEquals(lst.size(),200);
    
    
} */


}