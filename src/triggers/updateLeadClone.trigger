trigger updateLeadClone on Lead (after insert,after update,before delete)
{

    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
    if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
    
    set<ID> lid = new Set<ID>();
    List<Lead_clone__c> ldcl = new List<Lead_clone__c>();
    List<Lead_clone__c> ldcl_new = new List<Lead_clone__c>();
    if(trigger.isUpdate || trigger.isInsert)
    {
        for(Lead l : trigger.new)
        {
            lid.add(l.ID);
        }
            
        map<ID,Lead_clone__c> mplc = new map<ID,Lead_CLone__c>();
            
        for(Lead_Clone__c lc : [Select ID,Parent_Lead__c from Lead_Clone__c where Parent_Lead__c in : lid])
        {
            mplc.put(lc.Parent_Lead__c,lc);
        }
        
        for(Lead ld : trigger.new)
        {
            //added code for portal change on 22/06/2013
            //Check if lead primary partner and Provide lead access is given then only create Lead clone record.
            //if(ld.Primary_Partner__c != null && ld.Provide_Partner_Portal_Access__c)
            if(ld.Primary_Partner__c != null)
            {
                if(mplc.containskey(ld.ID))
                {
                    Lead_Clone__c lc = mplc.get(ld.ID);
                    
                    lc.Primary_Partner__c = ld.Primary_Partner__c;  
                    lc.Campaign_Clone_name__c  = ld.Partner_Campaign_Clone__c;  
                    lc.Company__c = ld.company;
                    lc.First_Name__c = ld.FirstName;
                    lc.Last_name__c = ld.LastName;
                    lc.Title__c = ld.Title;
                    lc.Department__c = ld.Department__c;
                    lc.Industry__c = ld.Industry;
                    lc.Phone__c = ld.Phone;
                    lc.Email__c = Ld.Email;
                    lc.Website__c = Ld.Website;
                    lc.Sector__c = Ld.Sector__c;
                    lc.Lead_Type__c = Ld.Lead_Type__c;
                    lc.Host_Manufacturer__c = Ld.Manufacturer__c;
                    lc.Competitor__c = Ld.Competitor_solution__c;
                    lc.Budget__c = Ld.Budget__c;
                    lc.Need_Objectives__c = Ld.Need_Objectives__c;
                    lc.Host_Application__c = Ld.Host_Application__c;
                    lc.Current_Solution__c = Ld.Current_Solution__c;
                    lc.Timeline__c = Ld.Timeline__c;
                    lc.Preferred_Language__c = Ld.Preferred_Language__c;
                    lc.Opportunity_Lead_Notes__c = Ld.Tradeshow_Notes__c;
                    lc.Region__c = Ld.Region__c;
                    lc.Physical_Country__c = Ld.physical_country__c;
                    lc.Physical_Street_Address__c = Ld.physical_street_address__c;
                    lc.Physical_Street_Address_2__c = Ld.physical_street_address_2__c;
                    lc.Physical_City__c = Ld.physical_city__c;
                    lc.Physical_State__c = Ld.physical_state__c;
                    lc.Physical_Postal_Code__c = Ld.Physical_postal_code__c;
                    lc.International_State_Province__c = Ld.international_state_province__c;
                    
                    ldcl.add(lc);     
                }   
                else
                {
                    if(Ld.Primary_Partner__c != Null &&!Ld.Channel_Created__c)
                    {
                        Lead_Clone__c lc_new = new Lead_Clone__c();
                        
                        lc_new.Primary_Partner__c = ld.Primary_Partner__c;
                        lc_new.Campaign_Clone_name__c  = ld.Partner_Campaign_Clone__c;  
                        lc_new.Company__c = ld.company;
                        lc_new.First_Name__c = ld.FirstName;
                        lc_new.Last_name__c = ld.LastName;
                        lc_new.Title__c = ld.Title;
                        lc_new.Department__c = ld.Department__c;
                        lc_new.Industry__c = ld.Industry;
                        lc_new.Phone__c = ld.Phone;
                        lc_new.Email__c = Ld.Email;
                        lc_new.Website__c = Ld.Website;
                        lc_new.Sector__c = Ld.Sector__c;
                        lc_new.Lead_Type__c = Ld.Lead_Type__c;
                        lc_new.Host_Manufacturer__c = Ld.Manufacturer__c;
                        lc_new.Competitor__c = Ld.Competitor_solution__c;
                        lc_new.Budget__c = Ld.Budget__c;
                        lc_new.Need_Objectives__c = Ld.Need_Objectives__c;
                        lc_new.Host_Application__c = Ld.Host_Application__c;
                        lc_new.Current_Solution__c = Ld.Current_Solution__c;
                        lc_new.Timeline__c = Ld.Timeline__c;
                        lc_new.Preferred_Language__c = Ld.Preferred_Language__c;
                        lc_new.Opportunity_Lead_Notes__c = Ld.Tradeshow_Notes__c;
                        lc_new.Region__c = Ld.Region__c;
                        lc_new.Physical_Country__c = Ld.physical_country__c;
                        lc_new.Physical_Street_Address__c = Ld.physical_street_address__c;
                        lc_new.Physical_Street_Address_2__c = Ld.physical_street_address_2__c;
                        lc_new.Physical_City__c = Ld.physical_city__c;
                        lc_new.Physical_State__c = Ld.physical_state__c;
                        lc_new.Physical_Postal_Code__c = Ld.Physical_postal_code__c;
                        lc_new.International_State_Province__c = Ld.international_state_province__c;
                        lc_new.Created_Internally__c = true;
                        lc_new.OwnerID = ld.OwnerID; 
                        lc_new.Parent_Lead__c = ld.ID;
                        
                        ldcl_new.add(lc_new);
                    }
                }
            }
        }
        if(!ldcl_new.isEmpty())
        {
            insert ldcl_new; 
        }
        if(!ldcl.isEmpty())
        {    
            update ldcl;
        }
    }
    
    if(Trigger.ISDelete)
    {
      
        for(Lead ld : trigger.old)
        {
            lid.add(Ld.ID);
        }
        
        for(Lead_clone__c lc : [Select ID from Lead_CLone__c where Parent_Lead__c in : lid])
        {
            ldcl.add(lc);
        }
         
        try
        {
          delete ldcl;
        } 
        catch (DmlException e)
        {
            system.debug(e);
        } 
         
    }

}