trigger UpdateVerticalsUsingSIC on Lead (before insert, before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code

// Automatically assign the approver based on Physical Country - US2774

   String UsaApprover1 = Label.ApproverForUSA;
   String GermanyApprover1 = Label.ApproverForGermany;
   String UsaApprover2 = Label.ApproverForUSA2;
   String GermanyApprover2 = Label.ApproverForGermany2;
   
   List<User> ApproverList = [Select Id, Name, LastName, FirstName from User where (Name =:UsaApprover1 OR Name =:GermanyApprover1 OR Name =:UsaApprover2 OR Name =:GermanyApprover2) AND isActive = true];
  
   for(Lead l : Trigger.New){
   
       for(User approver : ApproverList){
           if(l.Region__c == 'North America'){
               if(approver.Name == UsaApprover1)
                   l.ApproverBasedOnLocation__c = approver.Id;
               
               if(approver.Name == UsaApprover2)
                   l.ApproverBasedOnLocation2__c = approver.Id;
           }
           else
           if(l.Region__c == 'EMEA'){
               if(approver.Name == GermanyApprover1)
                   l.ApproverBasedOnLocation__c = approver.Id;
               
               if(approver.Name == GermanyApprover2)
                   l.ApproverBasedOnLocation2__c = approver.Id;
           }
           System.debug('***** System.debug l.ApproverBasedOnLocation__c ' +l.ApproverBasedOnLocation__c +' Name : '+approver);
           System.debug('&&&& Users ' + ApproverList);
       }
   
   }
}