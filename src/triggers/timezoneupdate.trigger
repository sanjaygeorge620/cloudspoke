trigger timezoneupdate on Contact ( before update){
        if(!FirstRun_Check.FirstRun_TimezoneUserTrigger && !FirstRun_Check.FirstRun_TimezoneContactTrigger)
        {
            Map<String,TimeZone_Listing__c> tzmap = TimeZone_Listing__c.getall();
            Map<String,String> tzlookup = new Map<String,String>();
        for(string tz : tzmap.keyset())
            {
               tzlookup.put(tzmap.get(tz).TimeZone__c,tz);   
            }
        for(string tz : tzlookup.keyset())
            {    
               system.debug('--------------------------------------' +tz);    
               system.debug('--------------------------------------' +tzlookup.get(tz)); 
            }
            Map<Id,Contact> conMap = new Map<Id,Contact>();
        for (contact contIterate : trigger.new)
            {
                if(contIterate.Business_Hours_To__c != Trigger.OldMap.get(contIterate.id).Business_Hours_To__c || contIterate.Business_Hours_From__c <> Trigger.OldMap.get(contIterate.id).Business_Hours_From__c || contIterate.Time_Zone__c <> Trigger.OldMap.get(contIterate.id).Time_Zone__c )
                    {
                        conMap.put(contIterate.Id,contIterate); 
                    }
            }
            List<User> usrToUpdate = new List<User>();
                if(conMap.size() >0)
                    {
            List<User> usrLst = [select id,Name,TimeZoneSidKey,From__c,To__c,Contactid from User where ContactId IN:conMap.keyset() AND isActive = True];
                       
                if(usrLst.size() >0)
                        {
                            for(User usrIterate : usrLst)
                                {
                                    Contact conRec = conMap.get(usrIterate.ContactId);
                                    if(tzlookup.containskey(conRec.Time_Zone__c)){
                                    usrIterate.TimeZoneSidKey =tzlookup.get(conRec.Time_Zone__c);}
                                    usrIterate.To__c = conRec.Business_Hours_To__c;
                                    usrIterate.From__c= conRec.Business_Hours_From__c;
                                    usrToUpdate.add(usrIterate);
                                }
                            if(usrToUpdate.size() >0)
                                {
                                    FirstRun_Check.FirstRun_TimezoneContactTrigger = True;            
                                    update usrToUpdate;
                                }
                        }
                    }
           } 
        }