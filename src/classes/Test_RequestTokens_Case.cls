/**
    Test Class for RequestTokens_Case
*/    
@isTest
private class  Test_RequestTokens_Case {
    public static List<pse__Proj__c> Projects;
    public static List<Case> cases ;
    //Static User u1 = [Select id from User where isActive = true and profile.name = 'System Administrator' limit 1];
    static User u1 = [Select id from User where isActive = true and profile.name = 'System Administrator' limit 1];
    static testMethod void testExecute() {
        //add account record
         test.starttest();
        
        system.runAs(u1){
        //Projects = Data_Project.createProject(1);
        }
      Account acc = Data_Account.createAccount();
      
     
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3); 
      ID recordtypeID = schema.Sobjecttype.Case.getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getInstance('Case_PartnerChannel').Value__c).getRecordTypeId();        ///6/8/2011 - jd - had to add because running out soql queries.
      
     
      ID misc2 = recordTypeID;
      id misc3 = recordTypeID;   
      
       RecordType objRec = [Select id,name from recordtype where id =: recordtypeID];
        system.runAs(u1){  
       
      //cases = Data_Case.createCase(acc, contacts[0], recordtypeID, projects[0].id, misc2, misc3,1);
      cases = Data_Case.createCase(acc, contacts[0], objRec.Name,1);
      cases[0].Require_token__c = 'Yes';
      cases[0].Token_Quantity__c = 5;
      update cases[0]; 
      }           
      
      Perceptive_Config_Group__c configGroup = new  Perceptive_Config_Group__c();
      configGroup.Name = 'abc';
      configGroup.Key__c = 'abc123';
      configGroup.Description__c = 'abcdefg';
      insert configGroup;
      Perceptive_Config_Option__c configOption = new  Perceptive_Config_Option__c();
      configOption.Perceptive_Config_Group__c = configGroup.Id;
      configOption.Description__c = 'abcdefg';
      insert configOption;
      Perceptive_Config_Value__c configValue = new  Perceptive_Config_Value__c();
      configValue.Perceptive_Config_Option__c = configOption.Id;
      configValue.Name = cases[0].recordtype.name + ' Opportunity Name';
      configValue.Value__c = 'abcdefghi';
      upsert configValue;
        
        
        RequestTokens_Case requestT = new RequestTokens_Case(new ApexPages.Standardcontroller(cases[0]));
        requestT.requstedTokens = 5;
        try{
        PageReference pageRef = Page.Request_Tokens_Case;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', cases[0].id);
        //RequestTokens_Case requestTC = new RequestTokens_Case(new ApexPages.Standardcontroller(cases[0]));       
        requestT.requestTokens();
        }catch(exception e)
        {
        System.debug(e);
        }
        test.stoptest();
    }
}