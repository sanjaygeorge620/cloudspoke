public class MobileAgreement_Buttons {
    
     /**************************************
     Description: Logic to handle both Accept and Decline button functionality on Mobile Agreement record
     *
     Date Created: 11/16/2011
     By: Manoj Kolli
     *
     Date Modified: 12/16/2011
     Revision by: Manoj Kolli
     *
     *****************************************/ 
          
    Id mId;
    Mobile_Agreement__c ma;
    Case c;
    Contact con;
    //string conName,uName;
    Profile p1 = [Select Id,Name from Profile where Name = 'Tech IS'];
    Profile p2 = [Select Id,Name from Profile where Name = 'System Administrator'];
    String p1Id = p1.Id;
    String p2Id = p2.Id;
    public MobileAgreement_Buttons(ApexPages.StandardController controller) {
        //mId = ApexPages.currentPage().getParameters().get('Id');
        //ma = [Select Id,Status__c,Case_Number__c from Mobile_Agreement__c where Id = :mId];
        /*c = [Select Id,ContactId, Status from Case where Id = :ma.Case_Number__c];
        if(c.ContactId != null){
            con = [Select Id,Name,LastName,FirstName from contact where Id = :c.ContactId];
            conName = con.LastName+' '+con.FirstName;
        }
        uName = UserInfo.getLastName()+' '+UserInfo.getFirstName();*/
    }
    
    Public PageReference Accept(){
        mId = ApexPages.currentPage().getParameters().get('Id');
        ma = [Select Id,Status__c,Case_Number__c from Mobile_Agreement__c where Id = :mId];
        c = [Select Id,ContactId, Status from Case where Id = :ma.Case_Number__c];
        System.debug('c.ContactId-->'+c.ContactId);
        if(c.ContactId != null){
            con = [Select Id,Name,Email,LastName,FirstName from contact where Id =: c.ContactId];            
            //conName = con.LastName+' '+con.FirstName;
        }
        
        User u = [Select Id,Email,Name from User where Id = :UserInfo.getUserId()];
        //uName = UserInfo.getLastName()+' '+UserInfo.getFirstName();
        PageReference pg;
        
                
        if((u.Email == con.Email && ma.Status__c == Null) || UserInfo.getProfileId() == p1Id || UserInfo.getProfileId() == p2Id){
             ma.Status__c = 'Accept';
             c.Status = 'Open-Working';
             Update ma;
             Update c;
             //pg = new PageReference('/'+mId);
             ApexPages.Message Msg= new ApexPages.Message(ApexPages.severity.INFO, 'Thank you. The mobile request has been submitted.');  
             ApexPages.addMessage(Msg);
             pg = new PageReference('/apex/AcceptButton');                
          }
        else{
            ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'You do not have access to update the status on this agreement');  
            ApexPages.addMessage(errMsg);
            pg = new PageReference('/apex/AcceptButton');
          }
        return pg;
    }
    
    Public PageReference Decline(){
        mId = ApexPages.currentPage().getParameters().get('Id');
        ma = [Select Id,Status__c,Case_Number__c from Mobile_Agreement__c where Id = :mId];
        c = [Select Id,ContactId, Status from Case where Id = :ma.Case_Number__c];
        if(c.ContactId != null){
            con = [Select Id,Name,Email,LastName,FirstName from contact where Id = :c.ContactId];
        }
        User u = [Select Id,Email,Name from User where Id = :UserInfo.getUserId()];
        PageReference pg1;
        if((u.Email == con.Email && ma.Status__c == Null) || UserInfo.getProfileId() == p1Id || UserInfo.getProfileId() == p2Id){
             ma.Status__c = 'Decline';
             c.Status = 'Closed';
             Update ma;
             Update c;
             ApexPages.Message Msg= new ApexPages.Message(ApexPages.severity.INFO, 'The agreement has been declined. The mobile request has been Closed.');  
             ApexPages.addMessage(Msg);
             pg1 = new PageReference('/apex/DeclineButton');
           }
        else{ 
             ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'You do not have access to update the status on this agreement');  
             ApexPages.addMessage(errMsg);
             pg1 = new PageReference('/apex/DeclineButton');
           }
        return pg1;
    }
    
    //Test Method
    
      public static testmethod void testMobileAgreement_Buttons(){
        
         Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
         Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
         Id MRrtId = rtMap.get('Mobile Request').getRecordTypeId();
         Contact con;
         //con =[Select Id,Name from Contact where Name  = 'Jennifer Dauernheim' limit 1];
         Account acc = data_Account.createAccount3();
         list<contact> cons = Data_Contact.createContacts(acc.id,1);
         con = cons[0]; 
         Case c = new Case(RecordTypeId = MRrtId,Status = 'New',Type = 'Request',ContactId = con.Id);
         insert c;
         c.Status = 'Open-Needs Customer Attention';
         update c;
         //VT 10/1 Added list ma and added the if(ma.size()>0)
         List<Mobile_Agreement__c> ma = new List<Mobile_Agreement__c>();
         MobileAgreement_Buttons mab;
         ma=[Select Id,Status__c,Case_Number__c from Mobile_Agreement__c where Case_Number__c = :c.Id limit 1];
         PageReference pg1 = Page.AcceptButton;
         if(ma.size()>0){
             pg1.getParameters().put('id',ma[0].Id);
             ApexPages.StandardController sc = new ApexPages.standardController(ma[0]);
             mab = new MobileAgreement_Buttons(sc);
             Test.setCurrentPage(pg1);
             mab.Accept();
             test.starttest();
             mab.Decline();
             test.stoptest();
             /*
             //4.18.2014
             //Profile p1 = [Select Id,Name from Profile where Name = 'Sales Admin' limit 1];
             Profile p1 = [Select Id,Name from Profile where Name = 'System Administrator' limit 1];
              User adminUser = new User(alias = 'standt', email='cstandarduser@testorg1.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p1.Id, 
                timezonesidkey='America/Los_Angeles', username='standarduser123332121212@testorg1.com',
                LX_Region__c='NE');
                Insert adminUser;
             
             System.RunAs(adminUser){
                 mab.Accept();
                 mab.Decline();
             }
         }*/
         
         }     
}
}