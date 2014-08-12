@isTest
private class Test_SendEmailToPMWhenAssignedToProject {

    @isTest
    static void TestSendEmailToPMWhenAssignedToProject() { 
        List<ID> newProjectList = new List<ID>();
        List<pse__Proj__c> Projects = Data_Project.createProject(1);
        Set<ID> setAccts = new Set<ID>();
        for(pse__Proj__c objPse : Projects)
        {
            setAccts.add(objPse.pse__Account__c);
        }
        List<Account> objAcc = [select id from account where id in: setAccts];
        List<Contact> lstContacts = Data_Contact.CreateContacts(objAcc[0].Id,1);
        //Contact ContactRec = [select id, email from Contact where status__c = 'Active' and email != null and accountID = :projects[0].Account_Name__c limit 1];
        //system.debug('test class - contactRec:' + ContactRec);
        for (pse__Proj__c ProjectRec : Projects){
            projectRec.pse__Project_Manager__c = lstContacts[0].id;
            newProjectList.add(ProjectRec.id);
        }   
       

              
        Test.startTest();
        update Projects;
            SendEmailToPMWhenAssignedToProject.SendEmail(newProjectList);
        Test.stopTest();

        //system.assertEquals(projects[0].pse__Project_Manager__c , 
            // [select pse__Project_Manager__c from pse__Proj__c where ID = :projects[0].id limit 1].pse__Project_Manager__c);
        
//test email message
       /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

         
         EmailTemplate template = ([select Id from EmailTemplate where Name = 'PSE: Notify PM of new Project' limit 1]);
         mail.setTargetObjectId(projects[0].pse__project_Manager__c);
         mail.setTemplateId(template.Id);
         system.debug('projects[0].pse__project_Manager__c: ' +projects[0].pse__project_Manager__c);
         system.debug('projects[0].pse__Account__r.owner.Email: ' +projects[0].pse__Account__r.owner.Email);
         system.debug('projects[0].pse__Account__r.ISR__r.Email: ' +projects[0].pse__Account__r.ISR__r.Email);
         system.debug('projects[0].pse__Account__r.ISR__c: ' +projects[0].pse__Account__r.ISR__c);
         mail.setWhatId(projects[0].ID);
         mail.saveAsActivity = false;
         String[] ccAddresses = new String[] {projects[0].pse__Account__r.owner.Email, projects[0].pse__Account__r.ISR__r.Email};
         if (ccAddresses != null){
         mail.setCcAddresses(ccAddresses);     
         }*/                          
         //mail.setSenderDisplayName('Professional Services');                 // Specify the name used as the display name.  
  //       List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                                
         //Send email results    
   //     system.debug ('statuscode : ' + results.get(0).getErrors()[0].getMessage());
//        System.debug('Email result ' + results[0].IsSuccess());
         
        
   //      System.AssertEquals(true, results[0].IsSuccess());
  //    
    }
}