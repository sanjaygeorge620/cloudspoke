public class generateThreadID {
    public static String generateThreadID(string OrgID, string CaseID){
        string threadID;
        String OrgID1 = OrgId.substring(0, 4);
           //org ID will be the all digits after 0s.  need to know length after first 4, then check for zeros until none remaining 
           string OrgID2='';//added ='' by arun thakur 
           String tempID = OrgId.Substring(5);
            Integer TempIDEnd = tempID.length();

            system.debug('tempID' + tempID);
            system.debug('tempID - lastindexof' + tempID.lastIndexof('0'));
            
            if(tempIDEnd>tempID.lastIndexof('0')+1)// Added  by arun thakur//OrgID2 = tempID.Substring(tempID.lastIndexof('1'), tempIDEnd -3);//000 00 1 JwAV EA0

            OrgID2 = tempID.Substring(tempID.lastIndexof('0')+1, tempIDEnd -3);
            
            
            

           system.debug('orgID-' + orgID);
           system.debug('orgID1-' + orgID1);
           system.debug('orgID2-' + orgID2);
           
           
           String caseID1 = caseId.substring(0, 4);
           string caseID2;
           String TempcaseID = caseId.Substring(5);
           Integer TempCaseEnd = tempcaseID.length();

            system.debug('caseID' + TempcaseID);
            system.debug('caseID - lastindexof' + TempcaseID.lastIndexof('0'));
            system.debug('caseID - lastindexof' + TempcaseID.lastIndexof('00'));
            // Story S-97014
            if (TempcaseID.lastIndexof('0')+1 < tempCaseEnd -3) {
                caseID2 = TempcaseID.Substring(TempcaseID.lastIndexof('0')+1, tempCaseEnd -3);
            } else {
                caseID2 = TempcaseID.Substring(TempcaseID.lastIndexof('00')+2, tempCaseEnd -3);
            }
            

           system.debug('caseID-' + orgID);
           system.debug('caseID-' + orgID1);
           system.debug('caseID-' + caseID2);
           
        //  [First 4 digits of the OrganizationID followed by all digits after the last zero].[First 4 digits of the CaseID followed by all digits after the last zero]
        //  Thread ID = 00DX ased23.00a4 DDs2
           
           threadID = orgID1+orgID2+'.'+caseID1+caseID2;
           system.debug(threadID);
           return threadID;
    }

}