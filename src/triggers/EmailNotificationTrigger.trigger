trigger EmailNotificationTrigger on pse__Proj__c (before insert, before update) {
    Set<Id> regionIdSet = new Set<Id>();
    for(pse__Proj__c pp: Trigger.new) {
        //pse__Proj__c oldPP = Trigger.oldMap.get(pp.Id);
        if((pp.Solution_Acceptance_Date__c != null) && (Trigger.isInsert || (Trigger.isUpdate && pp.Solution_Acceptance_Date__c != Trigger.oldMap.get(pp.Id).Solution_Acceptance_Date__c))) {
            regionIdSet.add(pp.pse__Region__c);
        }
    }
    
    if(!regionIdSet.isEmpty()) {
        try {
            Map<Id, pse__Region__c> regionMap = new Map<Id, pse__Region__c>([Select Id, Name from pse__Region__c where Id IN: regionIdSet AND 
                                                                             Name LIKE '%VNA%']);
            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :'PSE_Sign_Off_Tracking'];
            List<Messaging.SingleEmailMessage> mailMessageList = new List<Messaging.SingleEmailMessage>();
            for(pse__Proj__c pp: Trigger.new) {
                //pse__Proj__c oldPP = Trigger.oldMap.get(pp.Id);
                //if(pp.Solution_Acceptance_Date__c != oldPP.Solution_Acceptance_Date__c) {
                if((pp.Solution_Acceptance_Date__c != null) && (Trigger.isInsert || (Trigger.isUpdate && pp.Solution_Acceptance_Date__c != Trigger.oldMap.get(pp.Id).Solution_Acceptance_Date__c))) {
                    String[] toAddresses = new String[] {'finops@perceptivesoftware.com'};
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toAddresses);
                    mail.setTemplateId(et.Id);
                    mail.setWhatId(pp.Id);
                    mail.setTargetObjectId(pp.pse__Project_Manager__c);
                    mail.setUseSignature(false);
                    mailMessageList.add(mail);
                    // system.debug('---------------Line 30-----------'+regionMap);
                }
            }
            
            if(mailMessageList.size() > 0) {
                Messaging.sendEmail(mailMessageList);
            }
        } catch(Exception e) {
            System.debug('Warning: No Regions Exists.');
        }
    }
}