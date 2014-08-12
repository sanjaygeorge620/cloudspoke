trigger LX_MasterQuoteLine_Item_AI_AU on LX_Master_Quote_Line_Item__c (after insert, after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; //added ByPass

    //Time condition to make sure that emails are not sent if the Opportunity has been last modified within the last 30 minutes
    Set<Id> oppsIdSet = new Set<Id>();//set to store Opportunity Ids for new Master Quote Line Item being added/updated
    List<Opportunity> opportunityRecList = new List<Opportunity>(); //list to store Opportunity Records corresponding to ids in oppsIdSet
    List<Opportunity> updateOpp = new List<Opportunity>();  //list to store Opportunity Records to update Notify Owner field    
    //Time condition to make sure that emails are not sent if the Opportunity has been last modified within the last 30 minutes
    //for loop to iterate over Trigger.new and add corresponding Opportunity Ids in set oppsIdSet
    integer ctr;
    ctr=0;
    if(LX_OpportunityLineItemHelper.isMQLIUpdated == false)
    return;
    for (LX_Master_Quote_Line_Item__c  mqrec : Trigger.new)
    {   
          /*  Long createdTime = mqrec.CreatedDate.getTime();
            Long lastModifiedTime = mqrec.LastModifiedDate.getTime();
            if(lastModifiedTime - createdTime > (30*60000)){ *///30 Minutes converted to milliseconds
              //  System.debug('Im in the first for loop' + '~~~~~~~~~~~~~~~~~~~~~~~~');
                oppsIdSet.add(mqrec.LX_Opportunity__c);
           // }
    }
    //query to fetch opportunity records for Ids in Set oppsIdSet
  /*  opportunityRecList = [Select id,LX_Notify_Owner__c,LastModifiedDate 
                            FROM opportunity 
                            WHERE id IN : oppsIdSet];
     
    //for loop to iterate over opportunity record List and set LX_Notify_Owner__c to true
    for (Opportunity  oppRec : opportunityRecList)
    {
            oppRec.LX_Notify_Owner__c = true;
            updateOpp.add(oppRec);
            ctr++;
          //  System.debug('Im in the second for loop' + '-------------------->');
    }
    if(!(updateOpp.isEmpty()))
    {//updating opportunities for which new Master Quote Line Item being added/updated
        try{
        LX_OpportunityLineItemHelper.isMQLIUpdated = false;
        update updateOpp;
        System.debug('Im in the try block' + '((((((((((((((((((()))))))))))))))))))');
        System.debug(ctr + '--------------------->');
        System.debug('UpdateOpp size' + updateOpp.size() + '------------------------------>');
        System.debug('oppsIdSet size' + oppsIdSet.size() + '------------------------------>');
        }catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }

    }*/
}