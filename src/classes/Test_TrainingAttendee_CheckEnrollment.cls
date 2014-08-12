@isTest
private class Test_TrainingAttendee_CheckEnrollment {

    static testMethod void myUnitTest() {

      Account   acc = Data_Account.createAccount();
         List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
        Course__c  currentCourse = Data_TrainingCourse.createTrainingCourse(3); 
        Class__c newClass = Data_Class.createClass(); 
        newClass.Course__c = currentCourse.id;
        update newClass;
        ELearning_Registration__c newRegistration = Data_ELearningRegistration.createElearning(newclass.id,acc.id ); 
        
       Training_Attendee__c  newAttendee = Data_TrainingAttendee.createTrainingAttendee(newClass.id,newRegistration.id ); 
       
        
     List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
       List<Product2> product  = Data_Product.createProduct(pmList);  
                test.startTest();       
    
      Pricebook2  pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
       PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
     
              
        //create opportunity in system
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity2(stageList, 1,acc,contacts,pmlist,product,pricebook2,pbe);
        //update test opportunity so that QA Status = 'Complete'
        

        String [] CategoryList = new List<String>();
        CategoryList.add('Training');
        CategoryList.add('Training');
    //  CategoryList.add('Training');
             
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList ); 
        for (OpportunityLineItem oppLineRec : oppLineItem){
            oppLineRec.Token_Type__c = 'Training';
        }
        update oppLineItem;
              
        System.debug('oppLineItem : ' + oppLineItem );
        System.assert(oppLineItem[0].id != null);
                                                 
       /* system.assertEquals(2,
            [select id from OpportunityLineItem where opportunityid = :oppLineItem[0].opportunityId
                                                    and category__c = 'Training' 
                                                    and Processed__c <> True].size()); */
                                                                                                     
                                                    
        for (Opportunity oppRec : Test_Opportunities)
        {
            oppRec.QAStatus__c = 'Complete';   
        }
       
            ProcessToken_Manual.ProcessToken_Manual(Test_Opportunities[0].id, 'Training');
        
        test.stopTest();  

        
        List<Token__c> trainingtokenOppList = new List<Token__c> ([select id,
                                                                    Training_Attendee__r.id
                                                                    from Token__c
                                                                    where opportunity__c in :Test_Opportunities]);

                                                                    
        for(Token__c tokenRec : TrainingTokenOppList){
            tokenRec.training_Attendee__c = newAttendee.id;
        }
        update TrainingTokenOppList;
        system.debug('TrainingTokenOppList'+ TrainingTokenOppList);
        
         List<Token__c> trainingtokenList = new List<Token__c> ([select id,
                                                                Training_Attendee__r.id
                                                                from Token__c
                                                                where Training_attendee__r.id = :newAttendee.id]);
        system.debug('trainingtokenlist:' + trainingtokenList);
        
        List<Training_Attendee__c> TrainingAttendeeRec = new List<Training_Attendee__c> ([select tokens__c   
                                                                                                from Training_Attendee__c
                                                                                                where id = :newAttendee.id]) ;       
                                                                                                
          
         system.debug('trainingattendeerec' + TrainingAttendeeRec);                 
                                                                    
        system.assertEquals(2,
            [select id from Token__c where Training_Attendee__r.id = :newAttendee.id].size());
        
        system.assertEquals(2,
            [select id, Training_Attendee__r.id from Token__c where Opportunity__c = :oppLineItem[0].opportunityId].size());
        
        newAttendee.Status__c = 'Enrolled';  
        
       // List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);  
        newAttendee.Contact__c = contacts[0].id;
        system.debug('coursetokens:' + [select tokens__c from Course__c where id = :currentCourse.id].tokens__c);
        system.assertEquals(3,
            [select tokens__c from Course__c where id = :currentCourse.id].tokens__c);
        
  
        try { 
        update newAttendee;

        }catch(system.dmlException e){    
        system.debug('e.getDMLMessage(0):' + e.getDMLMessage(0));
          System.assertEquals('Please assign tokens before enrolling this attendee.',e.getDMLMessage(0));
          
          
      }
        
    
        
    }
 
}