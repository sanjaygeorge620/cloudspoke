trigger caseChannelClosed on Case (after insert, after update) {
    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
    
    List<Case>ChannelClosedCasesList = new List<Case>();
    for (Case caseRec : Trigger.new){         //get all contacts that need to process
            
            //****FirstRun_Check.FirstRun_Check.ChannelCase_Closed - this ensure the process only runs once even if case is updated during run
            //***only run this trigger on case that have a record type = Partner-Channel
            //***cases should be closed, but only recently closed(avoids trigger being run when cases is edited after being closed)
            
            //UAT use RecordTypeId 012Q00000008lYA 
            //PROD use RecordTypeId 01270000000MAaaAAG
             if ((trigger.isinsert 
                    && caseRec.isClosed == true 
                    && FirstRun_Check.FirstRun_ChannelCase_Closed
               //Modified by Abhishek Jain on 4/30/2013, replaced Hardcoded Id with 'Lx_SetRecordIDs.CasePartnerChannelRecordTypeId'
                    && caseRec.RecordTypeID == LX_SetRecordIDs.CasePartnerChannelRecordTypeId)|| 
                (trigger.isupdate && trigger.oldMap.get(caseRec.id).IsClosed != caseRec.isClosed
                              && caseRec.isClosed == true
                              && FirstRun_Check.FirstRun_ChannelCase_Closed
               //Modified by Abhishek Jain on 4/30/2013, replaced Hardcoded Id with 'Lx_SetRecordIDs.CasePartnerChannelRecordTypeId'                              
                              && caseRec.RecordTypeID == LX_SetRecordIDs.CasePartnerChannelRecordTypeId)){     
                                ChannelClosedCasesList.add(CaseRec);
                              }         
    }   
    if (ChannelClosedCasesList.size()>0){
        for (Case CaseRec : ChannelClosedCasesList){
            Contact contactRec = [select name, id from Contact where id = :caseRec.ContactId];
            caseChannelClosed.caseChannelClosed(caseRec, ContactRec);
        }
        
    }
}