trigger Hoursupdate on User ( before update){

    if(!FirstRun_Check.FirstRun_TimezoneContactTrigger && !FirstRun_Check.FirstRun_TimezoneUserTrigger)
        {
            List<Contact> conToUpdate = new List<Contact>();
    for(User U : Trigger.new)
            {
            if((U.From__c != Trigger.OldMap.get(U.id).From__c || U.To__c != Trigger.OldMap.get(U.id).To__c || U.TimeZoneSidKey != Trigger.OldMap.get(U.id).TimeZoneSidKey) && ((U.usertype=='PowerCustomerSuccess')) && U.isActive)
                {
                    Contact Con = New Contact(ID = U.ContactID);
                if(TimeZone_Listing__c.getall().containskey(U.TimeZoneSidKey))
                    {
                        Con.Time_Zone__c = TimeZone_Listing__c.getall().get(U.TimeZoneSidKey).TimeZone__c;
                    }
                    Con.Business_Hours_To__c = U.To__c;
                    Con.Business_Hours_From__c= U.From__c;
                    conToUpdate.add(Con);
                }
            }
            
            if(!conToUpdate.isEmpty())
                {
                    FirstRun_Check.FirstRun_TimezoneUserTrigger = True;
                    Update conToUpdate;
                }
        }
}