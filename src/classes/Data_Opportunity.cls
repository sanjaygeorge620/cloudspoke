@isTest(seeAlldata=true)
public class Data_Opportunity {
    public static List<Opportunity> createOpportunity(List<String> Stage, Integer size){
     
         List<Opportunity> opportunities = new List<Opportunity>(); 
         set<Id> opportunityIds = new Set<Id>();  
          //get Campaign record  
        //Campaign campRec = [select id, name from Campaign limit 1];
        Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
        Campaign campRec = Data_Campaign.createCampaign('Child Campaign', pCam.id);    
        // changed on 4.16.2013 lines 10-14           
        //get recordtype       
        RecordType OppRecord = [select id, name from RecordType where sObjectType = 'Opportunity' and developerName= 'Expansion_Add_On' limit 1];              
        //string opprectype = '01270000000DraWAAS';
        string  opprectype = OppRecord.id;
        //get closedate so always in the future        
        Date test_CloseDate = system.today().addDays(3);
        
        //get User Data
        Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
     
        List<User> newUserList = Data_User.createUser(3, profileIds); 
        
        //get account
        
        String LocationID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        string accrecType = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Competitor').getRecordTypeId();//= '012i0000000LivxAAC';
        system.debug('Test from opportunity entering into account');
        Account accPrimayPartner = Data_Account.createAccount3();
        system.debug('Test -->  from account back to opportunity');
        accPrimayPartner.name='testAccount';      
        accPrimayPartner.RecordTypeID = LocationID; 
        update accPrimayPartner ;
        
        Account acc = Data_Account.createAccount3();      
        acc.Primary_Sector_Focus__c  = 'Manufacturing';
        acc.name='testAccount';  
        update acc;         
        //create primary competitor account
        //RecordType AccRecType = [select id, name from RecordType where sObjectType = 'Account' and name = 'Competitor'];  
        //4.17.2013  from 37 to 39
        //string accrecType = '01270000000M91wAAC';  
         
        
         Account accUpdate = Data_Account.createAccount();
         accUpdate.Type = 'Partner';
         accUpdate.RecordtypeID = AccRecType;
         accUpdate.name='testAccount';  
         accUpdate.ISS_Coverage_Model__c  = 'Channel';
         update accUpdate ;        
        
        //get contact
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
        
        //get product model and product information
        List<Product_Model__c> productModels = Data_ProductModels.createProductModels(1);
        List<Product2> products = data_Product.createProduct(productModels);
        //insert products;
        
        //get pricebook information for opportunity
        system.debug('testing');
        //list<Pricebook2> pb = [select id, name, isactive from Pricebook2 where isStandard = true limit 1]; 
        Pricebook2 pb = [select id, name, isactive from Pricebook2 where isStandard = true limit 1]; 
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pb.id, products[0].id); 
      system.debug('>>>>>>>'+products[0]);
                
        //if any stages that are sent containg "Closed Won", need to create the opportunity with another stage, create the opp contact roles, then set the stage to Closed Won
        //create a new list which replaces the stage - then we can put it back
        List <String> newStageNames = new List<String>();
        system.debug('before stagenames');
         for(Integer s =0;s<size;s++){
            if (stage[s] == 'Closed Won') {
                NewStageNames.Add('Negotiation');
            }else {
                NewStageNames.Add(stage[s]);
            }
                        
        }
            system.debug('before insert opps loop:');
            contacts[0].accountID = acc.id;
            update contacts[0];
        
        
        //Test Block
        list<LX_Offer__c> listobjOffer =  new list<LX_Offer__c>();
        LX_Offer__c objOffer = null;
        for(Integer i =0;i<size;i++){
        objOffer = new LX_Offer__c(Name='testoffer'+1, LX_Offer_Status__c='Draft',Lx_Program__c='Direct',LX_Start_Date__c=Date.valueOf(System.now()),LX_End_Date__c=Date.valueOf(System.now()),
                                                salesRegion_quote__c='India',Lx_Quote_Currency__c='USD',LX_Quote_Category__c='Promotion');
        listobjOffer.add(objOffer);                                                
        }
        Insert listobjOffer;
        
        
        list<LX_Program_Offer__c> listobjProgramOffer =  new list<LX_Program_Offer__c>();
        LX_Program_Offer__c objProgramOffer = null;
        for(Integer i =0;i<size;i++){
        objProgramOffer = new LX_Program_Offer__c(LX_Offer__c = objOffer.id);
        listobjProgramOffer.add(objProgramOffer);
        }
        insert listobjProgramOffer;
        
        
        list<LX_Offer_Enrollment__c> listobjEnrolOffer =  new list<LX_Offer_Enrollment__c>();
        LX_Offer_Enrollment__c objEnrolOffer = null;
        for(Integer i =0;i<size;i++){
        objEnrolOffer = new LX_Offer_Enrollment__c(Account__c= acc.id,Offer__c=listobjOffer[i].id,LX_Product_Line_Items__c = 'Software Solutions');
        listobjEnrolOffer.add(objEnrolOffer);
        }
        insert listobjEnrolOffer;
        
        
         for(Integer i =0;i<size;i++){     
                   
            //add Opportunity Record        
            Opportunity oppRec = new Opportunity();        
            oppRec.Name = Stage[i];
            oppRec.LX_Pricebook_Offer__c = listobjEnrolOffer[i].id;
            OppRec.Primary_Partner__c = accPrimayPartner.id; 
            oppRec.OwnerId = newUserlist[0].Id;
           // oppRec.SE__c = newUserlist[1].Id;   
            oppRec.ISR__c = newUserlist[2].Id;        
            oppRec.AccountID = acc.id;        
            oppRec.Type = 'Add On Solution';        
            oppRec.Sector__c = 'State/Local';        
            oppRec.CampaignID = campRec.id;        
            oppRec.CloseDate = test_CloseDate;        
            oppRec.Amount = 000.00;        
            oppRec.StageName = newStageNames[i];  
            oppRec.Technology__c = true;
            oppRec.LX_Sales_Type__c = 'Add On';
            oppRec.LX_Ramp_Type__c = 'Back Loaded';
            oppRec.LX_Rollout_Start_Date__c = system.Today();
            oppRec.LX_Rollout_End_Date__c = System.Today() + 7;  
            oppRec.LX_First_Time_to_Revenue__c = 'Repeat Customer' ;
            OppRec.RecordTypeId = OppRecType;        
            OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';        
            //OppRec.Primary_Competitor__c = accPrimary.ID;  
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.      
            OppRec.Competitor_Installs__c = 'Testing';   
            OppRec.Project_Contact__c = contacts[0].id;
            //OppRec.Top_3_Reason_for_Win__c = 'Testing';  
            OppRec.Owner_Manager__c = newUserList[1].id;
            Opprec.pricebook2Id = pb.id ;
              OppRec.Need_Established__c = true;
            OppRec.Recommenders_Met__c = true;
            OppRec.LX_ID_decision_makers_exec_sponsors__c = true;
            OppRec.Business_Case_Agreement__c = true;
            OppRec.All_Formal_Presentation_Demo_Complete__c = true;
            OppRec.Verbal_Received_Check__c = true;
            OppRec.Signed_Contract_Received__c = true;
            OppRec.LX_Product_Type__c = 'Technology';
            OppRec.Technology__c = true;
            OppRec.LX_Sales_Type__c = 'Run Rate';
            OppRec.LX_First_Time_to_Revenue__c = 'Repeat Customer';
            OppRec.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
            OppRec.Contract_Number__c = 'test123';
            OppRec.LX_SAP_Upfront_Discount__c = 'test123';
            OppRec.LX_Vistex_Backend_Rebate__c = 'test123';
            OppRec.CurrencyIsoCode = 'USD';
            opportunities.add(oppRec);   
         }
         insert opportunities;
         
         for(Opportunity opp1 : opportunities){
             opportunityIds.add(opp1.Id); 
         }
         Opportunities = new List<Opportunity>(); 
         
         for (Opportunity opp1 : opportunities){            //from the list returned of inserted opportunities, created Opportunity Contact Roles
            List<OpportunityContactRole> contactRoles = Data_OpportunityContactRoles.createOpportunityContactRoles(opp1.id, contacts);
            
            List<Agreement__c> agreements = Data_Agreement.createAgreements(acc.id,opp1.id,productModels );
                
            String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
            List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp1.id, pbe.id, categoryList );
            system.debug('lineItem.PricebookEntry.Product2.Product_Model__r.Name' + opplineItem[0].PricebookEntry.Product2.Product_Model__r.Name);
         // CreateInstallations createIns = new CreateInstallations(opp1.id);
           
         //     createIns.process();
         }
         for(Opportunity opp1 : [select ID
                                 , StageName
                                 , OwnerID
                                 , Ship_To__c
                                 , Bill_To__c
                                 , Name
                                 , LX_Bill_To_Email_Address__c 
                                  , Primary_Partner__c
                                  ,LX_Pricebook_Offer__c
                                 , ISR__c
                                 ,CurrencyIsoCode
                                 , CampaignID
                                 , Contract_Number__c
                                 , priceBook2id
                                 , contract_End_Date__c
                                 , CloseDate
                                 , accountid
                                 , Project_Contact__c
                                 , Ship_To__r.accountid
                                 , Ship_To__r.account.name
                                 from Opportunity where id in : opportunityIds]){ 
             if(opp1.Name == 'Closed Won'){
                opp1.stageName = 'Closed Won';
                opp1.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
             }
             Opportunities.add(opp1);   
         }
         system.debug('end data_opportunity');
         return Opportunities;
    }
    
    public static List<Opportunity> createOpportunity2(List<String> Stage, Integer size,Account acc,List<Contact> contacts,
    List<Product_Model__c> productModels,List<Product2> products,Pricebook2 pb,PricebookEntry pbe)
    {
         //Rahul Add Start
        Account OppAccount,ParentAccount;
        Opportunity soldToOpp;
        Sales_Organization__c salesOrg;
        LX_SAP_Record__c soldToSAP;
        LX_SAP_Record_Sales_Org__c oppSoldTo;

        
        OppAccount  = LX_TestData.createAccountForOpportunity(); 
        salesOrg    = LX_TestData.createSalesOrgForOpportunity();
        soldToSAP   = LX_TestData.createSAPsoldTo();
        oppSoldTo   = LX_TestData.createOppSoldTo();
        LX_Territory__c terr = new LX_Territory__c(Name = 'test', LX_Territory_Id__c='12345');
        insert terr;
        
        //Rahul Add end
        
         Id contId ;
         for(contact con : contacts){
             contId = con.Id;
             break;
         }
         List<Opportunity> opportunities = new List<Opportunity>(); 
         set<Id> opportunityIds = new Set<Id>();  
          //get Campaign record  
        //Campaign campRec = [select id, name from Campaign limit 1];
        Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
        Campaign campRec = Data_Campaign.createCampaign('Child Campaign', pCam.id);    
                   
        //get recordtype       
        //RecordType OppRecType = [select id, name from RecordType where sObjectType = 'Opportunity' and name = 'Expansion-Add On'];              
        //4.18.2013 from 60 to 62
        //string opprectype = '01270000000DraWAAS';
        string opprectype = '012i0000000LoBuAAK';
        //get closedate so always in the future        
        Date test_CloseDate = system.today().addDays(3);
        
        //get User Data
        Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
     
        List<User> newUserList = Data_User.createUser(3, profileIds); 
        
        //get account
       // Account acc = Data_Account.createAccount();
        
        //create primary competitor account
        //RecordType AccRecType = [select id, name from RecordType where sObjectType = 'Account' and name = 'Competitor'];  
       // 4.18.2013 from 85 to 87
       // string accrecType = '01270000000M91wAAC'     ;  
        string accrecType = [Select id from RecordType where name='Location Partner' and sobjectType='Account'].id;   
        Account accPrimary = Data_Account.createAccount();
        accPrimary.Type = 'Partner';
        accPrimary.RecordtypeID = AccRecType;
        accPrimary.ISS_Coverage_Model__c= 'Channel';
        update accPrimary;        
        
        //get contact
        //List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
        
        //get product model and product information
        //List<Product_Model__c> productModels = Data_ProductModels.createProductModels(1);
        //List<Product2> products = data_Product.createProduct(productModels);
        
        //get pricebook information for opportunity
        //Pricebook2 pb = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        //PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pb.id, products[0].id); 
        
        
                
        //if any stages that are sent containg "Closed Won", need to create the opportunity with another stage, create the opp contact roles, then set the stage to Closed Won
        //create a new list which replaces the stage - then we can put it back
        List <String> newStageNames = new List<String>();
         for(Integer s =0;s<size;s++){
            if (stage[s] == 'Closed Won') {
                NewStageNames.Add('Closing');
            }else {
                NewStageNames.Add(stage[s]);
            }
                        
        }
        
        LX_Territory_Member__c terrMem = new LX_Territory_Member__c(Name='Test Mem',LX_Territory_Id__c =terr.id,LX_User__c=newUserlist[0].Id);
        insert terrMem;

        

         for(Integer i =0;i<size;i++){     
                   
            //add Opportunity Record        
            Opportunity oppRec = new Opportunity();        
            oppRec.Name = Stage[i];   
            oppRec.OwnerId = newUserlist[0].Id;
           //oppRec.SE__c = newUserlist[1].Id;   
            oppRec.ISR__c = newUserlist[2].Id;        
            oppRec.AccountID = acc.id;        
            oppRec.Type = 'Add On Solution';        
            oppRec.Sector__c = 'State/Local';        
            oppRec.CampaignID = campRec.id;        
            oppRec.CloseDate = test_CloseDate;        
            oppRec.Amount = 000.00;    
            oppRec.LX_Ramp_Type__c = 'Back Loaded';
            oppRec.LX_Rollout_Start_Date__c = system.Today();
            oppRec.LX_Rollout_End_Date__c = System.Today() + 7;      
            oppRec.StageName = newStageNames[i];        
            OppRec.RecordTypeId = OppRecType;        
            OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';        
            //OppRec.Primary_Competitor__c = accPrimary.ID; 
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.      
            OppRec.Competitor_Installs__c = 'Testing';   
            OppRec.Ship_To__c = contId;
            OppRec.Bill_To__c = contId; 
            OppRec.Project_Contact__c = contId;
            oppRec.Sales_Organization__c = salesOrg.id;
                
                //Rahul Add Start
                OppRec.Lx_Sold_To_New__c       = oppSoldTo.id;
                OppRec.SAP_Status__c = 'SUBMITTED';
                OppRec.AccountID = acc.id;
                OppRec.Quote_Status__c = 'Approved'; 
                //OppRec.Ship_To__c = con.id;
                OppRec.LX_Bill_To_ID__c      = '111111';
                OppRec.LX_Ship_To_ID__c      = '111111';
                OppRec.LX_Territory_Member__c = terrMem.id;
                OppRec.LX_Product_Type__c = 'Software';
                OppRec.Technology__c = True;
            OppRec.LX_Sales_Type__c = 'New Project';
            OppRec.LX_First_Time_to_Revenue__c = 'First Time to Revenue';
           oppRec.CurrencyIsoCode = salesOrg.LX_Available_Currencies__c;
                //Rahul Add End,
           // OppRec.CurrencyIsoCode = 'USD';
                
          //  OppRec.Top_3_Reason_for_Win__c = 'Testing';  
            OppRec.Owner_Manager__c = newUserList[1].id;
            Opprec.pricebook2Id = pb.id;
                OppRec.Contract_Number__c = 'test123';
            OppRec.LX_SAP_Upfront_Discount__c = 'test123';
            OppRec.LX_Vistex_Backend_Rebate__c = 'test123';
           // OppRec.Invoice_Logo__c = ilogo.ID;
           
           
           Opprec.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com'; //so that VR on LX_Bill_To_Address__c when StageName = 'Closed Won' is validated
           
            system.debug('oppty account id !!!!!!!!'+ oppRec.AccountID);
           // system.debug('contact account id !!!!!!!!'+ contacts[0].AccountID);
           // system.debug('contact email !!!!!!!!'+ contacts[0].Email);
           // system.debug('contact License_Contact__c !!!!!!!!'+ contacts[0].License_Contact__c);
            system.debug('oppty OppRec.Ship_To__c !!!!!!!!'+ OppRec.Ship_To__c);  
           
            opportunities.add(oppRec);   
         }
         insert opportunities;
         
         for(Opportunity opp1 : opportunities)
         {
             opportunityIds.add(opp1.Id); 
             System.debug('%%%%%%%' +opp1.Invoice_logo__r.name);
         }
         Opportunities = new List<Opportunity>(); 
         
         for (Opportunity opp1 : opportunities){            //from the list returned of inserted opportunities, created Opportunity Contact Roles
            List<OpportunityContactRole> contactRoles = Data_OpportunityContactRoles.createOpportunityContactRoles(opp1.id, contacts);
            
            List<Agreement__c> agreements = Data_Agreement.createAgreements(acc.id,opp1.id,productModels );
                
            String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
            List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp1.id, pbe.id, categoryList );
         //  system.debug('lineItem.PricebookEntry.Product2.Product_Model__r.Name' + opplineItem[0].PricebookEntry.Product2.Product_Model__r.Name);
         // CreateInstallations createIns = new CreateInstallations(opp1.id);
           
         //     createIns.process();
         }
         for(Opportunity opp1 : [select ID
                                 , StageName
                                 , OwnerID
                                 , Ship_To__c
                                 , Bill_To__c
                                 , Name                                 
                                 , ISR__c
                                 , CampaignID
                                 , Contract_Number__c
                                 , priceBook2id
                                 , contract_End_Date__c
                                 , CloseDate
                                 , accountid
                                 , Ship_To__r.accountid
                                 , Ship_To__r.account.name
                                 from Opportunity where id in : opportunityIds]){ 
             if(opp1.Name == 'Closed Won'){
                opp1.stageName = 'Closed Won';
                opp1.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
             }
             Opportunities.add(opp1);   
         }
         
         return Opportunities;
   
    }
    
    
    public static List<Opportunity> createOpportunity3(List<String> Stage, Integer size,Account acc,List<Contact> contacts)
    {
    

         List<Opportunity> opportunities = new List<Opportunity>(); 
         set<Id> opportunityIds = new Set<Id>();  
          //get Campaign record  
        //Campaign campRec = [select id, name from Campaign limit 1];
        Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
        Campaign campRec = Data_Campaign.createCampaign('Child Campaign', pCam.id);    
                   
        //get recordtype       
        RecordType OppRecType = [select id, name from RecordType where sObjectType = 'Opportunity' and name = 'Expansion-Add On'];              
        string opprectype1 = OppRecType.ID;
        //get closedate so always in the future        
        Date test_CloseDate = system.today().addDays(3);
        
        //get User Data
        Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
     
        List<User> newUserList = Data_User.createUser(3, profileIds); 
        
        //get account
       // Account acc = Data_Account.createAccount();
        
        //create primary competitor account
        //RecordType AccRecType = [select id, name from RecordType where sObjectType = 'Account' and name = 'Competitor'];  
        //4.18.2013 from 335 to 337
        //string accrecType = '01270000000M91wAAC'     ;   
        string accrecType = [Select id from RecordType where name='Location Partner' and sobjecttype='Account'].Id; 
        Account accPrimary = Data_Account.createAccount2();
        accPrimary.Type = 'Partner';
        accPrimary.RecordtypeID = AccRecType;
        accPrimary.ISS_Coverage_Model__c  = 'Channel';
        accPrimary.LX_Geo__c = 'EMEA';
        update accPrimary;        
        
        
        //if any stages that are sent containg "Closed Won", need to create the opportunity with another stage, create the opp contact roles, then set the stage to Closed Won
        //create a new list which replaces the stage - then we can put it back
        List <String> newStageNames = new List<String>();
         for(Integer s =0;s<size;s++){
            if (stage[s] == 'Closed Won') {
                NewStageNames.Add('Negotiation');
            }else {
                NewStageNames.Add(stage[s]);
            }
                        
        }
        
         for(Integer i =0;i<size;i++){     
                   
            //add Opportunity Record        
            Opportunity oppRec = new Opportunity();        
            oppRec.Name = Stage[i];   
            oppRec.OwnerId = newUserlist[0].Id;
           // oppRec.SE__c = newUserlist[1].Id;   
            oppRec.ISR__c = newUserlist[2].Id;        
            oppRec.AccountID = acc.id;        
            oppRec.Type = 'Add On Solution';        
            oppRec.Sector__c = 'State/Local';        
            oppRec.CampaignID = campRec.id;        
            oppRec.CloseDate = test_CloseDate;        
            oppRec.Amount = 000.00;
            oppRec.LX_Ramp_Type__c = 'Back Loaded';
            oppRec.LX_Rollout_Start_Date__c = system.Today();
            oppRec.LX_Rollout_End_Date__c = System.Today() + 7;          
            oppRec.StageName = newStageNames[i]; 
            if(oppRec.StageName == 'Closed Won') { oppRec.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';}     
            OppRec.RecordTypeId = opprectype1;        
            OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';        
            //OppRec.Primary_Competitor__c = accPrimary.ID;    
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.    
            OppRec.Competitor_Installs__c = 'Testing';  
            
            
            /*Fields for Notify Trigger */
            OppRec.BPQ_License__c = 1000;
            
            /*Fields ship to and bill to are moved to SAPRecords object.*/
            OppRec.Ship_To__c = contacts[0].id;
            OppRec.Bill_To__c = contacts[0].id; 
            OppRec.Project_Contact__c = contacts[0].id;
           // OppRec.Top_3_Reason_for_Win__c = 'Testing';  
            OppRec.Owner_Manager__c = newUserList[1].id;
            OppRec.Need_Established__c = true;
            OppRec.Recommenders_Met__c = true;
            OppRec.LX_ID_decision_makers_exec_sponsors__c = true;
            OppRec.Business_Case_Agreement__c = true;
            OppRec.All_Formal_Presentation_Demo_Complete__c = true;
            OppRec.Verbal_Received_Check__c = true;
            OppRec.Signed_Contract_Received__c = true;
            OppRec.LX_Product_Type__c = 'Software Solutions';
            OppRec.LX_Sales_Type__c = 'New Project';
            OppRec.LX_First_Time_to_Revenue__c = 'First Time to Revenue';
                OppRec.Contract_Number__c = 'test123';
            OppRec.LX_SAP_Upfront_Discount__c = 'test123';
            OppRec.LX_Vistex_Backend_Rebate__c = 'test123';
            OppRec.Technology__c = True;
          //  Opprec.pricebook2Id = pb.id;
            opportunities.add(oppRec); 
             
            system.debug('oppty account id >>>>>>'+ oppRec.AccountID);
            system.debug('contact account id >>>>>>'+ contacts[0].AccountID);
            system.debug('contact email >>>>>>'+ contacts[0].Email);
            system.debug('contact License_Contact__c >>>>>>'+ contacts[0].License_Contact__c);
            system.debug('oppty OppRec.Ship_To__c >>>>>>'+ OppRec.Ship_To__c);         }
            insert opportunities;
         
         for(Opportunity opp1 : opportunities){
             opportunityIds.add(opp1.Id); 
         }
         Opportunities = new List<Opportunity>(); 
         
         for (Opportunity opp1 : opportunities){            //from the list returned of inserted opportunities, created Opportunity Contact Roles
            List<OpportunityContactRole> contactRoles = Data_OpportunityContactRoles.createOpportunityContactRoles(opp1.id, contacts);
            
       //     List<Agreement__c> agreements = Data_Agreement.createAgreements(acc.id,opp1.id,productModels );
                
            String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
            
         }
         for(Opportunity opp1 : [select ID
                                 , StageName
                                 , OwnerID
                                 , Ship_To__c
                                 , Bill_To__c
                                 , Name
                                 , ISR__c
                                 , CampaignID
                                 , Contract_Number__c
                                 , priceBook2id
                                 , contract_End_Date__c
                                 , CloseDate
                                 , accountid
                                 , Ship_To__r.accountid
                                 , Ship_To__r.account.name
                                 from Opportunity where id in : opportunityIds]){ 
             
             Opportunities.add(opp1);   
         }
         
         return Opportunities;
   
    }
    
    public static List<Opportunity> createOpportunityNewSales(List<String> Stage, Integer size){
     
         List<Opportunity> opportunities = new List<Opportunity>(); 
         set<Id> opportunityIds = new Set<Id>();  
          //get Campaign record  
        //Campaign campRec = [select id, name from Campaign limit 1];
        Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
        Campaign campRec = Data_Campaign.createCampaign('Child Campaign', pCam.id);    
        // changed on 4.16.2013 lines 10-14           
        //get recordtype       
        RecordType OppRecord = [select id, name from RecordType where sObjectType = 'Opportunity' and developerName= 'New_Sales_Project' limit 1];              
        //string opprectype = '01270000000DraWAAS';
        string  opprectype = OppRecord.id;
        //get closedate so always in the future        
        Date test_CloseDate = system.today().addDays(3);
        
        //get User Data
        Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
     
        List<User> newUserList = Data_User.createUser(3, profileIds); 
        
        //get account
        
        String LocationID = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        string accrecType = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Competitor').getRecordTypeId();//= '012i0000000LivxAAC';
        Account accPrimayPartner = Data_Account.createAccount3();
        accPrimayPartner.name='testAccount';      
        accPrimayPartner.RecordTypeID = LocationID; 
        accPrimayPartner.TR_Status__c='Off';
        update accPrimayPartner ;
        
        Account acc = Data_Account.createAccount3();      
        acc.Primary_Sector_Focus__c  = 'Manufacturing';
        acc.name='testAccount';  
        update acc;         
        //create primary competitor account
        //RecordType AccRecType = [select id, name from RecordType where sObjectType = 'Account' and name = 'Competitor'];  
        //4.17.2013  from 37 to 39
        //string accrecType = '01270000000M91wAAC';  
         
        
         Account accUpdate = Data_Account.createAccount();
         accUpdate.Type = 'Partner';
         accUpdate.RecordtypeID = AccRecType;
         accUpdate.name='testAccount';
         accUpdate.ISS_Coverage_Model__c  = 'Channel';  
         update accUpdate ;        
        
        //get contact
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
        
        //get product model and product information
        List<Product_Model__c> productModels = Data_ProductModels.createProductModels(1);
        List<Product2> products = data_Product.createProduct(productModels);
      
        //get pricebook information for opportunity
        system.debug('testing');

        Pricebook2 pb = [select id, name, isactive from Pricebook2 where isStandard = true limit 1]; 
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pb.id, products[0].id); 

                
        //if any stages that are sent containg "Closed Won", need to create the opportunity with another stage, create the opp contact roles, then set the stage to Closed Won
        //create a new list which replaces the stage - then we can put it back
        List <String> newStageNames = new List<String>();
        system.debug('before stagenames');
         for(Integer s =0;s<size;s++){
            if (stage[s] == 'Closed Won') {
                NewStageNames.Add('Negotiation');
            }else {
                NewStageNames.Add(stage[s]);
            }
                        
        }
            system.debug('before insert opps loop:');
            contacts[0].accountID = acc.id;
            update contacts[0];
            
         for(Integer i =0;i<size;i++){     
                   
            //add Opportunity Record        
            Opportunity oppRec = new Opportunity();        
            oppRec.Name = Stage[i];   
            OppRec.Primary_Partner__c = accPrimayPartner.id; 
            oppRec.OwnerId = newUserlist[0].Id;
            //oppRec.SE__c = newUserlist[1].Id;   
            oppRec.ISR__c = newUserlist[2].Id;        
            oppRec.AccountID = acc.id;        
            oppRec.Type = 'Add On Solution';   
            oppRec.LX_Ramp_Type__c = 'Back Loaded';
            oppRec.LX_Rollout_Start_Date__c = system.Today();
            oppRec.LX_Rollout_End_Date__c = System.Today() + 7;      
            oppRec.Sector__c = 'State/Local';        
            oppRec.CampaignID = campRec.id;        
            oppRec.CloseDate = test_CloseDate;  
            oppRec.Technology__c = True;
            oppRec.LX_Sales_Type__c = 'New Project' ;     
            oppRec.Amount = 000.00;        
            oppRec.StageName = newStageNames[i]; 
                    if(oppRec.StageName == 'Closed Won') { oppRec.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';} //for bypassing the VR on LX_Bill_To_Formula__c
            OppRec.RecordTypeId = OppRecType;        
            OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';        
            //OppRec.Primary_Competitor__c = accPrimary.ID;  
            //Modified by Kapil Reddy Sama on 5/2/2013 to remove the Primary Competitor field from Opportunity.      
            OppRec.Competitor_Installs__c = 'Testing';   
            OppRec.Project_Contact__c = contacts[0].id;
            //OppRec.Top_3_Reason_for_Win__c = 'Testing';  
            OppRec.Owner_Manager__c = newUserList[1].id;
            Opprec.pricebook2Id = pb.id ;
              OppRec.Need_Established__c = true;
            OppRec.Recommenders_Met__c = true;
            OppRec.LX_ID_decision_makers_exec_sponsors__c = true;
            OppRec.Business_Case_Agreement__c = true;
            OppRec.All_Formal_Presentation_Demo_Complete__c = true;
            OppRec.Verbal_Received_Check__c = true;
            OppRec.Signed_Contract_Received__c = true;
            OppRec.LX_Product_Type__c = 'Software';
            OppRec.LX_Sales_Type__c = 'New Project';
            OppRec.LX_First_Time_to_Revenue__c = 'First Time to Revenue';
                OppRec.Contract_Number__c = 'test123';
            OppRec.LX_SAP_Upfront_Discount__c = 'test123';
            OppRec.LX_Vistex_Backend_Rebate__c = 'test123';
            opportunities.add(oppRec);   
         }
         insert opportunities;
         
         for(Opportunity opp1 : opportunities){
             opportunityIds.add(opp1.Id); 
         }
         Opportunities = new List<Opportunity>(); 
         
         for (Opportunity opp1 : opportunities){            //from the list returned of inserted opportunities, created Opportunity Contact Roles
            List<OpportunityContactRole> contactRoles = Data_OpportunityContactRoles.createOpportunityContactRoles(opp1.id, contacts);
            
            List<Agreement__c> agreements = Data_Agreement.createAgreements(acc.id,opp1.id,productModels );
                
            String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
            List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp1.id, pbe.id, categoryList );
            system.debug('lineItem.PricebookEntry.Product2.Product_Model__r.Name' + opplineItem[0].PricebookEntry.Product2.Product_Model__r.Name);
         // CreateInstallations createIns = new CreateInstallations(opp1.id);
           
         //     createIns.process();
         }
         for(Opportunity opp1 : [select ID
                                 , StageName
                                 , OwnerID
                                 , Ship_To__c
                                 , Bill_To__c
                                 , Name
                                 , LX_Bill_To_Formula__c 
                                  , Primary_Partner__c
                                 , ISR__c
                                 , CampaignID
                                 , Contract_Number__c
                                 , priceBook2id
                                 , contract_End_Date__c
                                 , CloseDate
                                 , accountid
                                 , Ship_To__r.accountid
                                 , Ship_To__r.account.name
                                 from Opportunity where id in : opportunityIds]){ 
             if(opp1.Name == 'Closed Won'){
                opp1.stageName = 'Closed Won';
             }
             opp1.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
             Opportunities.add(opp1);   
         }
         system.debug('end data_opportunity');
         return Opportunities;
    }
    
    
    static testMethod void TestTestData(){
    
            
            String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
              List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 3);       
              
                 Account acct = Data_Account.createAccount4(); // Changing from createAccount4 to createAccount
                 List<Contact> contacts = Data_Contact.CreateContacts(acct.Id,2);
                             Contact cont = contacts[0];
                             
                            
                 List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
                         
                                                          
                 List<Product2> product = Data_Product.createProduct(pmList); 
                            
                 Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
                 PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
                  Test.StartTest();
                 List<Opportunity> test_opportunities2 = Data_Opportunity.createOpportunity2(stageList,3,acct,contacts,
                 pmList,product,pricebook2,pbe); 
                 

              
                             Test.StopTest();              
               
    }
    
    static testMethod void TestTestData2()
     {
     
     String [] stageList = new List<String>();
            stageList.add('Negotiation');


            stageList.add('Negotiation');
            stageList.add('Negotiation');
            
            Account acct = Data_Account.createAccount();  
                 List<Contact> contacts = Data_Contact.createContacts(acct.Id,1);
                             Contact cont = contacts[0];
           
                             Test.StartTest();
                           List<Opportunity> test_opportunities3 = Data_Opportunity.createOpportunity3(stageList,3,acct,contacts);  

                             Test.StopTest();              
    }
    
    static testMethod void testUpdateOppConversion1()
    {     
     String [] stageList = new List<String>();
            stageList.add('Demonstrating');            
           
     Test.StartTest();
     List<Opportunity> test_opportunities3 = Data_Opportunity.createOpportunity(stageList, 1);
     Test.StopTest();              
    }
    
    static testMethod void testUpdateOppConversion2()
    {     
     String [] stageList = new List<String>();            
            stageList.add('Proposing');
           
     Test.StartTest();
     List<Opportunity> test_opportunities3 = Data_Opportunity.createOpportunity(stageList, 1);
     Test.StopTest();              
    }
    
     
    
    
}