@isTest(seeAlldata=true)
public class Data_Account {

public static Account createAccount4()
{ 
List<Account> accList = [select Id,BillingState,name,Sector__c,type,Party_Role__c,Party_Type__c,Coverage_ID__c,MDM_Sold_To_Number__c,Reseller_ID__r.Name,Account.Owner.IsActive from Account where Id In (select AccountId from Contact where Portal_User_Type__c = '')
             and Account.Owner.IsActive = true and MDM_Sold_To_Number__c != ''  limit 1 ];  
  Account acc = new Account();
  for(Account a : accList){
      acc = a;
      break;
  }
  system.debug('xxxxxxxxxxxCHeck Account Herexxxxxxxxxxxxx' +acc);           
   

             
           


 return acc;  
            
}


public static Account createAccount3()
{ 
        //get User Data - Added by Rashi
        Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
        List<User> newUserList = Data_User.createUser(3, profileIds); 
        
       // Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2(); 
        Account A = new Account(name='Account4TestMethod2');       
 //       A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
      //  A.Coverage_ID__c = gc2.id;
        A.MDM_Sold_To_Number__c = '56A47657';
        A.Physical_Country__c = 'USA';
        A.BillingCity = 'NYC';
        A.LX_Country_Code__c = 'AI';
       //  A.BillingCountry= 'USA';
        A.BillingCountry  = 'USA';
        A.LX_Geo__c = 'EMEA';
        A.MPS_Qualification__c = 'MPS';
        A.LXK_Region__c = 'USA';
        A.TR_Status__c = 'On';
        A.ISS_Coverage_Method__c = 'Face to Face';
        A.ISS_Coverage_Model__c ='Enterprise';
        //VT 10/1 added to remove validation error
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Primary_Sector_Focus__c = 'Manufacturing';  //Added by arun thakur to avoid "LX_Lex_Vertical_Check "  trigger on contact validation 
        A.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;//Added by arun on 03-june-2013
      //  A.Hidden_Submitter_ManagerId__c = newUserList[0].id; // added by Rashi Joshi on 19-12-1013
        insert A;       
        return A;  
     }
     

     public static Account createAccount2(){ 
        Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2(); 
       
       /*Geography_Coverage__c gc2 = [SELECT Name, Coverage_Owner__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description__c, 
        Area__c, Category__c, LastModifiedById, LastModifiedDate, Notes__c, OwnerId, Id, Sub_Area__c, Location__c, Country__c,
         Sales_Organization__c, SystemModstamp FROM Geography_Coverage__c where area__c = 'NA' limit 1];
       */
        Account A = new Account(name='Account4TestMethod2');       
 //       A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc2.id;
        A.MDM_Sold_To_Number__c = '56A47657';
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.LX_Country_Code__c = 'US';
 A.Primary_Sector_Focus__c = 'Manufacturing';  //Added by arun thakur to avoid "LX_Lex_Vertical_Check "  trigger on contact validation 
A.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;       //Added by arun on 03-june-2013
       insert A;       
        return A;  
     }
                    
      public static Account createAccount10(){ 
        Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2(); 
       
      /* Geography_Coverage__c gc2 = [SELECT Name, Coverage_Owner__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description__c, 
        Area__c, Category__c, LastModifiedById, LastModifiedDate, Notes__c, OwnerId, Id, Sub_Area__c, Location__c, Country__c,
         Sales_Organization__c, SystemModstamp FROM Geography_Coverage__c where area__c = 'NA' limit 1];
       */
        Account A = new Account(name='Account4TestMethod2');       
 //       A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc2.id;
        A.MDM_Sold_To_Number__c = '56A47657';
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.Primary_Sector_Focus__c = 'Manufacturing';  //Added by arun thakur to avoid "LX_Lex_Vertical_Check "  trigger on contact validation 
        A.RecordTypeId=LX_SetRecordIDs.L5LocationCustomerAccountRecordId;       //Added by arun on 03-june-2013
        insert A;       
        return A;  
     }
     
     
     public static Account createAccount(){ 
     
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();      
        
       /* Geography_Coverage__c gc = [SELECT Name, Coverage_Owner__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description__c, 
        Area__c, Category__c, LastModifiedById, LastModifiedDate, Notes__c, OwnerId, Id, Sub_Area__c, Location__c, Country__c,
         Sales_Organization__c, SystemModstamp FROM Geography_Coverage__c where area__c = 'NA' limit 1];
       */    
        Account A = new Account(name='Account4TestMethod');       
 //     A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'Rajasthan';  
        A.Name = 'testAccount';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc.id;
        A.MDM_Sold_To_Number__c = '56A47657';
       A.Primary_Sector_Focus__c = 'Manufacturing';  //Added by arun thakur to avoid "LX_Lex_Vertical_Check "  trigger on contact validation ,
       A.Legacy_Company_Originator__c = 'Acuo';
       A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;//Added by arun on 03-june-2013
        insert A;  
             
        return A;  

//A.IsPartner=true;
     }
     
     public static Account createPartnerAccount(){ 
     
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();      
        
       /* Geography_Coverage__c gc = [SELECT Name, Coverage_Owner__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, Description__c, 
        Area__c, Category__c, LastModifiedById, LastModifiedDate, Notes__c, OwnerId, Id, Sub_Area__c, Location__c, Country__c,
         Sales_Organization__c, SystemModstamp FROM Geography_Coverage__c where area__c = 'NA' limit 1];
       */    
        Account A = new Account(name='Account4TestMethod');       
 //     A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'Rajasthan';  
        A.Name = 'testAccount';
        A.Sector__c = 'State/Local';
        A.Type = 'Partner';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc.id;
        A.MDM_Sold_To_Number__c = '56A47657';
       A.Primary_Sector_Focus__c = 'Manufacturing';  //Added by arun thakur to avoid "LX_Lex_Vertical_Check "  trigger on contact validation ,
       A.Legacy_Company_Originator__c = 'Acuo';
       A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;//Added by arun on 03-june-2013
        a.LX_Geo__c = 'North America';
        a.LXK_Region__c = 'USA';
        a.partner_mps_capability_score__c = 1;
        a.partner_iss_solutions_capability_score__c = 1;
        a.MDM_Account_Number__c = '1234';       //Added by Abhishek 21-Jan-2014
        insert A;  
             
        return A;  

//A.IsPartner=true;
     }
     
     public static Account createAccount_Batch()
     { 
        Account A = new Account(name='Account4TestMethod2');       
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.MDM_Sold_To_Number__c = '56A47657';
        A.Physical_Country__c = 'USA';
        A.BillingCity = 'NYC';
        A.LX_Country_Code__c = 'AI';
        A.BillingCountry  = 'USA';
        A.LX_Geo__c = 'EMEA';
        A.MPS_Qualification__c = 'MPS';
        A.LXK_Region__c = 'USA';
        A.TR_Status__c = 'On';
        A.ISS_Coverage_Method__c = 'Face to Face';
        A.ISS_Coverage_Model__c ='Enterprise';
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Primary_Sector_Focus__c = 'Manufacturing';  
        A.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
        a.Coverage_Status__c = 'Active'; 
        insert A;       
        return A;  
     }
// added by abhishek 13-Jan-2014
    public static Account createMDMAccount(){ 
     
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();      
        
      
        Account A = new Account(name='Account4TestMethod');       
 //     A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'Rajasthan';  
        A.Name = 'testAccount';
        A.Sector__c = 'State/Local';
        A.Type = 'Partner';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc.id;
        A.MDM_Sold_To_Number__c = '56A47657';
       A.Primary_Sector_Focus__c = 'Manufacturing';  
       A.Legacy_Company_Originator__c = 'Acuo';
       A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.MDM_Account_Number__c = '1234';
        a.MDM_Account_Level__c = 'Transactional';
        A.RecordTypeId=LX_SetRecordIDs.L4MDMPartnerAccountRecordId;
        insert A;  
             
        return A;  

     }

      static testMethod void testTestData() {
         Account acc = Data_Account.createAccount();   
         Account acc2 = Data_Account.createAccount2();     
         Account acc3 = Data_Account.createAccount3();   
         Account acc4 = Data_Account.createAccount4();   
         System.assert(acc.id != null);
         System.assert(acc2.id != null);
         System.assert(acc3.id != null);
         //System.assert(acc4.id != null);
         
      }   
}