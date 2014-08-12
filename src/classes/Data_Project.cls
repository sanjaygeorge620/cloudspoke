@isTest
public class Data_Project{

    static ID userId ;
    static  Date todayDate ;
    

 public static List<pse__Proj__c> createProject(Integer size)
 {

    

     system.debug('inside createproj >>>>>>');
     //Insert region 
     pse__Region__c pse_region = Data_PSE_Region.createRegion(); 
     system.assert(pse_region.Id != null);
        
     //Insert Practice
     pse__Practice__c pse_practice = Data_PSE_Practice.createPractice();
     system.assert(pse_practice.Id != null);
       
     //Insert Group
     pse__Grp__c pse_group = Data_PSE_Group.createGroup();  
     system.assert(pse_group.Id!=null);
     
     List<pse__Proj__c> Projects= new List<pse__Proj__c>();    
     Set<Id> projectIds = new Set<Id>();    
     pse__Proj__c Project;  
     
     String [] stageList = new List<String>();
     stageList.add('Negotiation');


     system.debug('inside createproj before calling createacc >>>>>>');
     Account acc = Data_Account.createAccount3();
     system.debug('acc id >>>>>>'+acc.id); 
          
    integer i1 = 0;
    //Account acc = [Select ID from Account where MDM_Sold_To_Number__c != null limit 1]; 
    /*Contact  con = new Contact(
                           LastName='Test Contact '+i1,
                           firstName='TestFirst',
                           AccountId = acc.ID,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email='test'+i1+'@gmail.com',
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           License_Contact__c=true,
                           //pse__Salesforce_User__c = userList[u].id,
                          // Accounting_Contact__c = true,
                           areas_of_need__c = 'Content',
                           phone='1234'+i1,
                           Lx_Lexmark_Vertical__c = 'Manufacturing',
                           pse__Is_Resource__c  = true,
                           pse__Is_Resource_Active__c  = true);*/
    
    List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
    //List<Contact> contacts = new list<Contact>();
    //contacts.add(con);
    //insert contacts;
    //system.debug('con === '+con);
   // List<Contact> contacts = Data_Contact.queryContacts(acc.ID);   
    //List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
    //contacts[0].pse__Is_Resource__c  = true;
    //contacts[0].pse__Is_Resource_Active__c  = true;
   // contacts[0].License_Contact__c  = true;
   // update contacts[0];
    List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
    List<Product2> product = Data_Product.createProduct(pmList); 
    
   List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList,1,acc,contacts); 

    //Account accRec = [select owner.id from Account where Id = :test_opportunities[0].Ship_To__r.accountID];
     //accRec.ISR__c = accRec.Owner.id;
     //update accRec;
     
     for(Integer i =0;i<size;i++){  
        userId = UserInfo.getUserId();
        todayDate = Date.today(); 
            project = new pse__Proj__c (
            Name=test_opportunities[0].Ship_To__r.accountID,
            pse__Account__c = test_opportunities[0].Ship_To__r.accountID,
            pse__Is_Active__c = true,
            pse__Project_Status__c = 'Green',
            pse__Start_Date__c = todayDate.addMonths(-1),
            pse__End_Date__c = todayDate.addMonths(4),
            OwnerId = userId,
            CurrencyIsoCode ='USD',
            pse__Opportunity__c = test_opportunities[0].id,
            //accounting_contact__c = test_opportunities[0].Ship_To__c,
            pse__Allow_Timecards_Without_Assignment__c = false, 
            pse__Region__c = pse_region.Id,     
            pse__Practice__c = pse_practice.Id,
            pse__Group__c = pse_group.Id,
            pse__Project_Manager__c = contacts[0].id,
            pse__Project_Phase__c = 'Closed Inactive',
            Product_Line_s__c ='ISS'
            );
        
        Projects.add(project);   
        system.debug('projectRec:' + project);
     }
     //TEst.startTest();
     insert projects;
     system.debug('projects: ' + projects);
      //TEst.stopTest();
     return Projects;
     
  }    
  
  public static List<pse__Proj__c> createProjects(Integer size,Account ac,List<Contact> contacts,pse__Region__c pse_region,pse__Practice__c pse_practice)
 {
 
 
 
  //Insert region 
          
     //Insert Group
     pse__Grp__c pse_group = Data_PSE_Group.createGroup();  
     system.assert(pse_group.Id!=null);
     
     List<pse__Proj__c> Projects= new List<pse__Proj__c>();    
     Set<Id> projectIds = new Set<Id>();    
     pse__Proj__c Project;  
     
     String [] stageList = new List<String>();
     stageList.add('Negotiation');

     List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList, 1,ac,contacts);  


    Account accRec = [select owner.id from Account where Id = :test_opportunities[0].Ship_To__r.accountID];
     accRec.ISR__c = accRec.Owner.id;
     update accRec;
     
     for(Integer i =0;i<size;i++){  
        userId = UserInfo.getUserId();
        todayDate = Date.today(); 
        project = new pse__Proj__c (
            Name=test_opportunities[0].Ship_To__r.accountID,
            pse__Account__c = test_opportunities[0].Ship_To__r.accountID,
            pse__Is_Billable__c = true,
            pse__Is_Active__c = true,
            pse__Project_Status__c = 'Green',
            pse__Start_Date__c = todayDate.addMonths(-1),
            pse__End_Date__c = todayDate.addMonths(4),
            OwnerId = userId,
            CurrencyIsoCode ='USD',
            pse__Opportunity__c = test_opportunities[0].id,
            //accounting_contact__c = test_opportunities[0].Ship_To__c,
            pse__Allow_Timecards_Without_Assignment__c = false, 
            pse__Region__c = pse_region.Id,     
            pse__Practice__c = pse_practice.Id,
            pse__Group__c = pse_group.Id,
            pse__Billing_Type__c = 'Fixed Price',
            pse__Project_Manager__c = contacts[0].id,
            pse__Bookings__c = 10000,
            LX_Bill_To_ID__c = '1234',LX_Ship_To_ID__c  = '1234');
        
        Projects.add(project);   
        system.debug('projectRec:' + project);
     }
     insert projects;
     system.debug('projects: ' + projects);

     return Projects;
 
 
 
 }   
 
 static testMethod void testTestData1() 
 
 {
 
 List<pse__Proj__c> Projects = Data_Project.createProject(1);       
     // System.assertEquals(Projects.size(),1); 
 }
 
 
  static testMethod void testTestData2() {
 
       Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);
      
      Test.StartTest();
      
        pse__Region__c pse_region = Data_PSE_Region.createRegion(); 
     system.assert(pse_region.Id != null);
        
     //Insert Practice
     pse__Practice__c pse_practice = Data_PSE_Practice.createPractice();
     system.assert(pse_practice.Id != null);
     
        List<pse__Proj__c> Projects2 = Data_Project.createProjects(1,Acc,contacts,pse_region,pse_practice);       
      System.assertEquals(Projects2.size(),1); 
      
            Test.StopTest();      
      
  }  
       
}