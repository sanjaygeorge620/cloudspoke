trigger CreateChannelLead on Lead_Clone__c (before insert)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
List<Lead> ldls = new list<lead>();
List<Opportunity> opplist = new List<Opportunity>();
//Lead ld = new Lead();
List<Lead_clone__c> lcls = new list<lead_Clone__c>();
group grp = [SELECT ID FROM Group where name = 'Channel.New'];    
    

for(Lead_Clone__c lc : Trigger.new)
{   
if(lc.Created_Internally__c != true)
{    
    if(lc.Opportunity_Name__c == Null)
    {
        Lead ld = new Lead();
        ld.ownerID = grp.ID;
        ld.Channel_Created__c = true;
        ld.recordtypeid = lc.Lead_RecordType__c;
        ld.Reason_For_Conversion__c = 'Sales';
        System.debug(lc.Primary_Partner__c);
        ld.Primary_Partner__c = lc.Primary_Partner__c;
        ld.company = lc.Company__c;
        ld.FirstName = lc.First_Name__c;
        ld.LastName = lc.Last_name__c;
        ld.Title = lc.Title__c;
        ld.Department__c = lc.Department__c;
            ld.Industry = lc.Industry__c;
            ld.Phone = lc.Phone__c;
            Ld.Email = lc.Email__c;
            Ld.Website = lc.Website__c;
            Ld.Sector__c = lc.Sector__c;
            Ld.Lead_Type__c = lc.Lead_Type__c;
            Ld.Manufacturer__c = lc.Host_Manufacturer__c;
            Ld.Competitor_solution__c = lc.Competitor__c;
            //Ld.Budget__c = lc.Budget__c;
            Ld.Need_Objectives__c = lc.Need_Objectives__c;
            Ld.Host_Application__c = lc.Host_Application__c;
            Ld.Current_Solution__c = lc.Current_Solution__c;
            //Ld.Timeline__c = lc.Timeline__c;
            Ld.Preferred_Language__c = lc.Preferred_Language__c;
            Ld.Tradeshow_Notes__c = lc.Opportunity_Lead_Notes__c;
            Ld.Region__c = lc.Region__c;
            Ld.physical_country__c = lc.Physical_Country__c;
            Ld.physical_street_address__c = lc.Physical_Street_Address__c;
            Ld.physical_street_address_2__c = lc.Physical_Street_Address_2__c;
            Ld.physical_city__c = lc.Physical_City__c;
            Ld.physical_state__c = lc.Physical_State__c;
            Ld.Physical_postal_code__c = lc.Physical_Postal_Code__c;
            Ld.international_state_province__c = lc.International_State_Province__c;
            // Ld.Lead_Clone__c = Lc.ID;
            ldls.add(ld);            
       }
       else{
            Opportunity o = new Opportunity();
            o.Name = lc.Opportunity_Name__c;
            o.CloseDate = lc.Close_Date__c;
            o.StageName = lc.Stage__c;
            /* Case 00034866
               Updated by - Rahul Chitkara
               Appriio Offshore Jaipur  
            */
            o.Partner_s_Customer_Account_Number__c = lc.Partner_s_Customer_Account_Number__c;          
            /*
            End Case 00034866
            */
            //o.Budget__c = lc.Budget__c;
            //o.Authority__c = lc.Authority__c;
            o.Objectives__c = lc.Need_Objectives__c;
            //o.Timeline__c = lc.Timeline__c;
            o.Hot_Buttons__c = lc.Hot_Buttons__c;
            o.Next_Steps__c= lc.Next_Step__c;
            o.Order_Method_Confirmation__c = lc.Order_Method_Confirmation__c;
            o.Decision_Criteria__c = lc.Decision_Criteria__c;
            o.Description = lc.Description__c;
            o.Sector__c = lc.Sector__c;
            o.Host_Manufacturer__c = lc.Host_Manufacturer__c;
            o.Host_Application__c = lc.Host_Application__c;
            o.Secondary_Host_Application__c = lc.Secondary_Host_Application__c;
            o.Secondary_Host_Manufacturer__c = lc.Secondary_Host_Manufacturer__c; 
            o.Department__c = lc.Department__c;
            o.Server_Operating_System__c = lc.Server_Operating_System__c;
            o.Type = 'Data_Opportunity';
            o.Partner_Referral_Fee_Applicable__c = 'Partner-OEM';
            o.AccountId = lc.Account_ID__c;
            system.debug('**********Opportunity Owner in trigger'+lc.Opportunity_Owner__c);
            o.OwnerId = lc.Opportunity_Owner__c;
            o.Primary_Partner__c = lc.Primary_Partner__c; 
            //o.Primary_Partner__c = lc.Primary_Partner__c;
            o.Partner_OEM_Opp_Status__c = 'Created';
            opplist.add(o);
       }     
    
            
}
}
    if(ldls.size()>0){
    system.debug('List To Update === '+ldls);
    insert ldls;
       
     map<ID,Lead> ml = new map<ID,Lead>();
    
    for(Lead le : ldls)
    {
    ml.put(le.Lead_Clone__c,le);
    }
    
    for(Lead_Clone__c lc : trigger.new)
    {
    lead la = ml.get(lc.ID);
    Lead_clone__c lcl = new lead_Clone__c();        
    lc.Parent_Lead__c = la.ID;        
    }
    }
    if(opplist.size()>0){insert opplist;}
    
    
}