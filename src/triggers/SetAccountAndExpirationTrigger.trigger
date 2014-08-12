trigger SetAccountAndExpirationTrigger on pse__Skill_Certification_Rating__c (before insert, before update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    List<Id> contactIds = new List<Id>();
    Map<id,id> contactAccountMap = new Map<id,id>();
    Date expirationDate;
    for(pse__Skill_Certification_Rating__c certificationData : trigger.new)
    {
        contactIds.add(certificationData.pse__Resource__c);
    }
    if(trigger.isInsert || trigger.isUpdate)
    {
        if(contactIds != null && contactIds.size() > 0)
        {
            for(Contact con : [select id, AccountId from Contact where id in : contactIds])
            {
                contactAccountMap.put(con.id , con.AccountId);
            }
            for(Integer i =0;i<trigger.size;i++)
            {
                if(contactAccountMap.get(trigger.new[i].pse__Resource__c) != null)
                {
                    trigger.new[i].Account__c = contactAccountMap.get(trigger.new[i].pse__Resource__c);
                }
            }
        }
        
    }
    for(Integer i =0;i<trigger.size;i++)
    {
        Date evaluationDate = trigger.new[i].Valid_Date__c;
        if(evaluationDate.month() <= 3)
        {
            expirationDate =  date.newInstance(evaluationDate.year(), 6, 30);
            system.debug('---------------- test 1 --------------'+evaluationDate.month());
            system.debug('---------------- test 1 --------------'+expirationDate);
        }
        else
        {
            expirationDate =  date.newInstance((evaluationDate.year() + 1), 6, 30);
            system.debug('---------------- test 2 --------------'+evaluationDate.month());
            system.debug('---------------- test 2 --------------'+expirationDate);
        }
        if(expirationDate != null)
        {
            trigger.new[i].pse__Expiration_Date__c = expirationDate;
        }
    }

}