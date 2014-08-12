trigger updateProjectFields on pse__Proj__c (before insert, before update) 
{

    // Trigger Switch
    Boolean LX_Switch = false; 
    static integer index = 0;    
    // Get current profile custom setting.
    LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
    // Get current Organization custom setting.
    LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
    // Get current User custom setting.
    LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
    
    // Allow the trigger to skip the User/Profile/Org based on the custom setting values
    if(LXUser != null)
        LX_Switch = LXUser.Bypass__c;
    else if(LXProfile != null)
        LX_Switch = LXProfile.Bypass__c;
    else if(LXOrg != null)
        LX_Switch = LXOrg.Bypass__c;
    if(LX_Switch)
        return;    


map<ID,ID> prj_srv = new map<ID,ID>();
Set<ID> srv_lst = new Set<ID>();
map<ID,Server__c> srv_mp = new map<ID,Server__c>();
List<pse__Proj__c> prj_lst = new list<pse__Proj__c>();

//Create a list of ids to store the Opportunity Ids 
list<id> oppIds = new list<id>();
//Map to store the ship to and Bill To fields from opportunity
map<id,Opportunity> oppMap;


if(trigger.isInsert)
{
    for(pse__proj__c c : trigger.new)
    {
        if(c.pse__Opportunity__c != null){
            oppIds.add(c.pse__Opportunity__c);
        }
        
    prj_srv.put(c.id,c.Server__c);
    srv_lst.add(c.Server__c);
    }

for(Server__c s :[Select ID,Server_Type__c,Release__c,Platform__c,Platform_Version__c,Database__c,Database_Version__c from Server__c where ID in :srv_lst])
{
srv_mp.put(s.id,s);
}

//popuate all the opp fields for the prok
oppMap = new map<id,Opportunity>([Select id,LX_Bill_To_Email_Address__c,LX_Bill_To_Address__c,LX_Bill_To_Address_2__c,LX_Bill_To_City__c,LX_Bill_To_Company__c,LX_Bill_To_Company_2__c,LX_Bill_To_Country__c,LX_Bill_To_ID__c,Bill_To_Name__c,LX_Bill_To_Postal__c,LX_Bill_To_State__c, LX_Ship_To_Address__c,LX_Ship_To_Address_2__c,LX_Ship_To_City__c,LX_Ship_To_Company__c,LX_Ship_To_Company_2__c,LX_Ship_To_Country__c, LX_Ship_To_ID__c,Ship_To_Name__c,LX_Ship_To_Postal__c,LX_Ship_To_State__c from Opportunity where id =:oppIds]);

for(pse__proj__c c : trigger.new)
{

if(c.Server__c != null)
{
c.Current_Server_Type__c = srv_mp.get(prj_srv.get(c.id)).Server_Type__c;
c.Current_Release__c = srv_mp.get(prj_srv.get(c.id)).Release__c;
c.Current_Platform__c = srv_mp.get(prj_srv.get(c.id)).Platform__c; 
c.Current_Platform_Version__c = srv_mp.get(prj_srv.get(c.id)).Platform_Version__c; 
c.Current_Database__c = srv_mp.get(prj_srv.get(c.id)).Database__c; 
c.Current_Database_Version__c = srv_mp.get(prj_srv.get(c.id)).Database_Version__c; 
}
    if((c.pse__Opportunity__c != null)&&(oppMap.get(c.pse__Opportunity__c)!= null)){
        Opportunity op = oppMap.get(c.pse__Opportunity__c);
        c.LX_Bill_To_Address_2__c       =   op.LX_Bill_To_Address_2__c;
        c.LX_Bill_To_Address__c         =   op.LX_Bill_To_Address__c ;
        c.LX_Bill_To_City__c            =   op.LX_Bill_To_City__c;
        c.LX_Bill_To_Company_2__c       =   op.LX_Bill_To_Company_2__c;
        c.LX_Bill_To_Company__c         =   op.LX_Bill_To_Company__c;
        c.LX_Bill_To_Country__c         =   op.LX_Bill_To_Country__c;
        c.LX_Bill_To_ID__c              =   op.LX_Bill_To_ID__c;
        c.Bill_To_Name__c               =   op.Bill_To_Name__c;
        c.LX_Bill_To_Postal__c          =   op.LX_Bill_To_Postal__c;
        c.LX_Bill_To_State__c           =   op.LX_Bill_To_State__c;
        c.LX_Bill_To_Email_Address__c   =   op.LX_Bill_To_Email_Address__c; 

        c.LX_Ship_To_Address_2__c   =   op.LX_Ship_To_Address_2__c;
        c.LX_Ship_To_Address__c     =   op.LX_Ship_To_Address__c ;
        c.LX_Ship_To_City__c        =   op.LX_Ship_To_City__c;
        c.LX_Ship_To_Company__c     =   op.LX_Ship_To_Company__c;
        c.LX_Ship_To_Country__c     =   op.LX_Ship_To_Country__c;
        c.LX_Ship_To_ID__c          =   op.LX_Ship_To_ID__c;
        c.Ship_To_Name__c           =   op.Ship_To_Name__c;
        c.LX_Ship_To_Postal__c      =   op.LX_Ship_To_Postal__c;
        c.LX_Ship_To_State__c       =   op.LX_Ship_To_State__c;

    }
}
}

if(trigger.isUpdate )
{
for(pse__proj__c c : trigger.new)
{
//prj_srv.put(c.id,trigger.newmap.get(c.id).Server__c);
//srv_lst.add(trigger.newmap.get(c.id).Server__c);

prj_srv.put(c.id,c.Server__c);
srv_lst.add(c.Server__c);

}

for(Server__c s :[Select ID,Server_Type__c,Release__c,Platform__c,Platform_Version__c,Database__c,Database_Version__c from Server__c where ID in :srv_lst])
{
srv_mp.put(s.id,s);
}


for(pse__proj__c c : trigger.new)
{

if(c.Server__c != null && c.Server__c != trigger.oldmap.get(c.id).Server__c)
{

c.Current_Server_Type__c = srv_mp.get(prj_srv.get(c.id)).Server_Type__c;
c.Current_Release__c = srv_mp.get(prj_srv.get(c.id)).Release__c;
c.Current_Platform__c = srv_mp.get(prj_srv.get(c.id)).Platform__c; 
c.Current_Platform_Version__c = srv_mp.get(prj_srv.get(c.id)).Platform_Version__c; 
c.Current_Database__c = srv_mp.get(prj_srv.get(c.id)).Database__c; 
c.Current_Database_Version__c = srv_mp.get(prj_srv.get(c.id)).Database_Version__c; 

}

if(c.Server__c == null && trigger.oldmap.get(c.id).Server__c != null)
{

c.Current_Server_Type__c = null;
c.Current_Release__c = null;
c.Current_Platform__c = null; 
c.Current_Platform_Version__c = null; 
c.Current_Database__c = null; 
c.Current_Database_Version__c = null; 

}

}
 
}
}