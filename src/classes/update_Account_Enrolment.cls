public class update_Account_Enrolment
{
public static void updateAccount(List<Account> Acc)
{
Set<ID> AccID = new Set<ID>();
           if(!AccID.isEmpty())
            {
            List<LX_Program_Enrollment__c> LpLst = new List<LX_Program_Enrollment__c>();
            List<string> LpUpd = new List<string>();
            LpLst = [Select ID,LX_Enrollment_Status__c  from LX_Program_Enrollment__c where LX_Account__r.Id  IN: Acc ];
         for(LX_Program_Enrollment__c LP : LpLst)
            {
            system.debug('ssssssssssssss' +LP.id);
            if( LP.LX_Enrollment_Status__c == 'Active' )
            {
                LpUpd.add(LP.ID);
            }
            }
            if(!LpUpd.isEmpty())
            {
                List<Account> aLst=new List <Account> ();
                for(Account a: Acc)
                {
                    a.GSS_Monitored__c ='Level 2';
                    aLst.add(a);
                }
                Update aLst;
            }
      }
  }
    
    

public static void updateAccountfromEnrolment(List<LX_Program_Enrollment__c> LPELst)
{
Set<ID> AccID = new Set<ID>();
    for(LX_Program_Enrollment__c LP : LPELst)
        {
            if(LP.LX_Account__c != null)
            {
                AccID.add(LP.LX_Account__c);
            }
        }

    if(!AccID.isEmpty())
        {
        List<Account> AcLst = new List<Account>();
        List<Account> AcUpd = new List<Account>();
        AcLst = [Select ID,Account_Status__c,Party_Role__c from Account where ID in: AccID and Account_Status__c = 'Active' and Party_Role__c = 'Alliance Partner/OEM'];
        for(Account Acc : AcLst)
        {
            system.debug('ssssssssssssss' +Acc.id);
            AcUpd.add(New Account(ID = Acc.id,GSS_Monitored__c = 'Level 2'));
        }
        
            if(!AcUpd.isEmpty())
            {
                Update AcUpd;
            }
        }
    }
}