trigger Account_AutoPopulate_Bill_To on Opportunity (before insert, before update) {

       //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 


 if(Trigger.new[0].Bill_To__c ==null)
{
    if(Trigger.new[0].AccountId!= null || Trigger.new[0].Primary_Partner__c != null)
    {
        if(Trigger.new[0].Primary_Partner__c != null)
        {
            list<Contact> cc = new list<Contact>([select id from Contact where AccountId = :Trigger.new[0].Primary_Partner__c and Default_Bill_To__c = true]);          
            if(!cc.isEmpty())
            {
               Trigger.new[0].Bill_To__c = cc[0].Id;
            }

        }
        else
        {
            list<Contact> cc = new list<Contact>([select id from Contact where AccountId = :Trigger.new[0].AccountId and Default_Bill_To__c = true]);
            if(!cc.isEmpty())
            {
                Trigger.new[0].Bill_To__c = cc[0].Id;
            }           
        }
    }
}
//if(Trigger.isInsert)
//{
system.debug(trigger.new);
    if(Trigger.new[0].AccountId!= null || Trigger.new[0].Primary_Partner__c != null)
    {
        if(Trigger.new[0].Primary_Partner__c != null)
        {
            list<Account> aa = new list<Account>([select id,Type from Account where Id = :Trigger.new[0].Primary_Partner__c]);
            system.debug('Account list:' + aa);
                if(!aa.isEmpty())
                {
                   Trigger.new[0].AccountTypeUpdate__c = aa[0].Type;
                } 
                system.debug('trigger:' + trigger.new);          
        }
        else
        {
            list<Account> aa = new list<Account>([select id,Type from Account where Id = :Trigger.new[0].AccountId]);
            if(!aa.isEmpty())
            {
               Trigger.new[0].AccountTypeUpdate__c = aa[0].Type;
            }           
        }       

    }
}
//}