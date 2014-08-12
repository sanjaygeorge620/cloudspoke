public class TCApprovalHelper {
    
    public static List<pse__Timecard_Header__c> pseTCList;
    
    public static void updateTCsWithApproved(List<pse__Timecard_Header__c> pseTClst){
        pseTCList = new List<pse__Timecard_Header__c>();
        for(pse__Timecard_Header__c pseTC : pseTClst){
            pseTC.pse__Status__c = 'Approved';
            pseTC.pse__Approved__c = true;
            pseTC.pse__Include_In_Financials__c = true;
            pseTCList.add(pseTC);
            if(pseTCList.size()==199){
                upsert pseTCList;
                pseTCList.clear();
            }
        }
        if(pseTCList.size()>0){
            upsert pseTCList;
        }
    }
    
    public static void updateTCsWithRejected(List<pse__Timecard_Header__c> pseTClst){
        pseTCList = new List<pse__Timecard_Header__c>();
        for(pse__Timecard_Header__c pseTC : pseTClst){
            pseTC.pse__Status__c = 'Rejected';
            pseTC.pse__Approved__c = false;
            pseTCList.add(pseTC);
            if(pseTCList.size()==199){
            	// NOTE: MOVED THE REJECTION EMAIL TO BE SENT VIA WORKFLOW WHEN TIMECARD STATUS SET TO 'REJECTED' -S.CLUNE 3/6/2010
            	//sendMailToOwner(pseTCList);
                upsert pseTCList;
                pseTCList.clear();
            }
        }
        if(pseTCList.size()>0){
            upsert pseTCList;
        }
    }
    
    public static void updateTCs(List<pse__Timecard_Header__c> TClst,String status){
        pseTCList = new List<pse__Timecard_Header__c>();
        if(status.equalsIgnoreCase('Approved')){
            updateTCsWithApproved(TClst);
        }else if(status.equalsIgnoreCase('Rejected')){
            updateTCsWithRejected(TClst);
        }
    }
    
    public static void sendMailToOwner(List<pse__Timecard_Header__c> TClst){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Set<String> templates = new Set<String>();
        Map<String,Id> emailTemplates = new Map<String,Id>();
        
        templates.add('PSE: Timecard Rejected');
        for(EmailTemplate eTemp:[select Id, DeveloperName from EmailTemplate 
            where name in :templates and isActive = true]){
               emailTemplates.put(eTemp.DeveloperName, eTemp.ID);
        }
        for(pse__Timecard_Header__c pseTC : TClst){
            Messaging.SingleEmailMessage mail = setSingleEmailMessageObj(pseTC,emailTemplates);
            mailList.add(mail);
        }
        
        Messaging.sendEmail(mailList);
    }   
    
    public static Messaging.SingleEmailMessage setSingleEmailMessageObj
    (pse__Timecard_Header__c pseTC,Map<String,Id> emailTemplates){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(emailTemplates.get('PSE_Timecard_Rejected'));
        mail.setToAddresses(new String[] {pseTC.owner.Email});
        mail.setWhatId(pseTC.id);
        mail.saveAsActivity=false;
        mail.setTargetObjectId(pseTC.ownerID);
        return mail;
    }

}