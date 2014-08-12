trigger LX_Program_Enrollment_Validation on LX_Program_Enrollment__c (before insert,before update)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
/*
Map<Id,String> Lx_Map_Program_Account=new Map<Id,String>();
Map<Id,String> Lx_Map_Partner_Program=new Map<Id,String>();

for(LX_Program_Enrollment__c ObjProgramEnrollment:trigger.New)
{
    Lx_Map_Program_Account.Put(ObjProgramEnrollment.LX_Account__c,'');
    Lx_Map_Partner_Program.Put(ObjProgramEnrollment.Master_Program__c,'');
}

for(LX_Partner_Program__c ObjPartnerProgram:[select Id,Country__c from LX_Partner_Program__c where Id in : Lx_Map_Partner_Program.Keyset()])
{
    if(Lx_Map_Partner_Program.containsKey(ObjPartnerProgram.Id))
    {
        Lx_Map_Partner_Program.Put(ObjPartnerProgram.Id,ObjPartnerProgram.Country__c);
    }
}

for(Account ObjAccount:[select Id,Physical_Country__c from Account where Id in : Lx_Map_Program_Account.Keyset()])
{
    if(Lx_Map_Program_Account.containsKey(ObjAccount.Id))
        {
            Lx_Map_Program_Account.Put(ObjAccount.Id,ObjAccount.Physical_Country__c);
        }
    

}

for(LX_Program_Enrollment__c ObjProgramEnrollment:trigger.New)
{

    String AccountCountry=Lx_Map_Program_Account.get(ObjProgramEnrollment.LX_Account__c);
    String  PartnerCountry=Lx_Map_Partner_Program.get(ObjProgramEnrollment.Master_Program__c);
    
    if(!PartnerCountry.contains(AccountCountry))
    {
        ObjProgramEnrollment.addError('You must select a program for your country.');
    }
    
    
    
}
*/

}