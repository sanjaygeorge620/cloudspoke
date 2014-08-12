/* Class Name   : LX_Test_Program_Util
 * Description  : Test Class to cover Programutil class
 * Created By   : Srinivas Pinnamaneni
 * Created On   : 02-Jan-14

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Srinivas Pinnamaneni           02-Jan-14        Initial version
*/

@isTest(seeAllData=true)
private class LX_Test_Program_Util{

    /* Description:Tests program approver */
    static testMethod void testProgramApprover() {
       
        List<ID> lstProfiles = new List<ID>();
        lstProfiles.add([select id from profile where name =: 'System Administrator'].Id);
        
        List<User> lstUsers = Data_User.createUser(2,lstProfiles);
        user objUser = lstUsers[1];
        objUser.managerID = null;
        update objUser;
        RecordType recordtypID = [select Id,developername from recordtype where sobjecttype =: 'LX_Partner_Program__c' and developername = 'Master_Program'];
        system.runAs(lstUsers[0])
        {
            LX_Partner_Program__c objPartnerPrgram = new LX_Partner_Program__c();
            objPartnerPrgram.Name = 'TestPartnerProgram'+system.currentTimeMillis();
            objPartnerPrgram.Program_Level__c = 'Global Program (L1)';
            objPartnerPrgram.LX_Program_Type__c = 'PSW';
            objPartnerPrgram.recordTypeID = recordtypID.Id;
            insert objPartnerPrgram;
            
            
        }
        
        system.runAs(objUser)
        {
        
            LX_Partner_Program__c objPartnerPrgram = new LX_Partner_Program__c();
            objPartnerPrgram.Name = 'TestPartnerProgram'+system.currentTimeMillis();
            objPartnerPrgram.Program_Level__c = 'Global Program (L1)';
            objPartnerPrgram.LX_Program_Type__c = 'PSW';
            objPartnerPrgram.recordTypeID = recordtypID.Id;
            insert objPartnerPrgram;
        
        }
        
    }
}