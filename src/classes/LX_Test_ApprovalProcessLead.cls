@isTest(SeeAllData=true)
private class LX_Test_ApprovalProcessLead
{
  static testMethod void testsendRecordToApprovalWebSvc()
  {
      Lead newLead0 = Data_Lead.CreateApprovalProcessLead('Afghanistan','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead0.id);
      
      Lead newLead01 = Data_Lead.CreateApprovalProcessLead('Canada','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead01.id);
      
      Lead newLead02 = Data_Lead.CreateApprovalProcessLead('Denmark','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead02.id);

      Lead newLead03 = Data_Lead.CreateApprovalProcessLead('Austria','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead03.id);
      
      Lead newLead04 = Data_Lead.CreateApprovalProcessLead('Spain','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead04.id);
      
      Lead newLead05 = Data_Lead.CreateApprovalProcessLead('Morocco','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead05.id);
       
  }
  
  static testMethod void testcopyRequestorId()
  {
      User tstUser = Data_User.testUserwithManager(); 
      System.Runas(tstUser){
      Lead newLead = Data_Lead.CreateApprovalProcessLead('Germany','ISS');    
      LX_ApprovalProcessLead.copyRequestorId(newLead.id); 
      
      Lead newLead1 = Data_Lead.CreateApprovalProcessLead('Germany','PSW');    
      LX_ApprovalProcessLead.copyRequestorId(newLead1.id);
      }
  }
  
   static testMethod void testsendRecordToApprovalWebSvcSet1()
  {
      Lead newLead06 = Data_Lead.CreateApprovalProcessLead('South Africa','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead06.id);
      
      Lead newLead9 = Data_Lead.CreateApprovalProcessLead('Bulgaria','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead9.id);
      
      Lead newLead8 = Data_Lead.CreateApprovalProcessLead('Ireland','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead8.id);
      
  }
  
   static testMethod void testsendRecordToApprovalWebSvcSet2()
  {  
      Lead newLead6 = Data_Lead.CreateApprovalProcessLead('Germany','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead6.id);
      
      Lead newLead5 = Data_Lead.CreateApprovalProcessLead('Bangladesh','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead5.id);
      
      Lead newLead4 = Data_Lead.CreateApprovalProcessLead('Anguilla','ISS');    
      LX_ApprovalProcessLead.sendRecordToApproval(newLead4.id);
  } 
  
}