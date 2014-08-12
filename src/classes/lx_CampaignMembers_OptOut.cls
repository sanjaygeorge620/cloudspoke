/* Class Name   : lx_CampaignMembers_OptOut 
* Description   : This is a class for campaign owners to approve opt-out requests object.
* Created By   : Srinivas
* Created Date : 10-06-2013 
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Srinivas           10-06-2013                                  Initial Version
*/
public class lx_CampaignMembers_OptOut{
    //Declare a variable to store campaign members
    public List<CampaignMemberWrapper> m_lstCampaignMembers {get;set;}
    
      
    public lx_CampaignMembers_OptOut()
    {
        //Create a variable to get campaign Id from the Query String
        ID campaignId = ApexPages.currentPage().getParameters().get('cid');
        String strOptedStatus = 'Opt-Out Requested';
        m_lstCampaignMembers = new List<CampaignMemberWrapper>();
        //Get all the campaign members which are Opt_Out for this campaign
        for(CampaignMember obj : [select id,Status,Contact.Name,LX_AEX_Owner_name__c,LX_Account_Owner_name__c,Contact.Account.Name,Contact.title,Lead.Name from CampaignMember
                                                        where Campaignid =:campaignId and Status =: strOptedStatus])
        
        {
            m_lstCampaignMembers.add(new CampaignMemberWrapper(obj));
            
        }
        
    }
    
      /* Description : Wrapper class to build details to display in visual force page
    */
    
    public class CampaignMemberWrapper
    {
        //Create variables in the wrapper class to store the selected Id's
        public boolean m_isSelected{get;set;}
        public String m_FirstName{get;set;}
        public String m_Type{get;set;}
        public String m_Title{get;set;}
        public String m_Account{get;set;}
        public CampaignMember m_CampaignMember{get;set;}
        public String m_AccountOwner{get;set;}
        public String m_SWAexOwnerName{get;set;}
        
        public CampaignMemberWrapper(CampaignMember objCampMember)
        {
          this.m_FirstName = objCampMember.Contact.Name == null ? objCampMember.Lead.Name : objCampMember.Contact.Name;
          this.m_Type = objCampMember.Contact.Name == null ? 'Lead' : 'Contact';
          this.m_CampaignMember = objCampMember;
          this.m_Title = objCampMember.Contact.Title;
          this.m_Account = objCampMember.Contact.Account.Name;
          this.m_AccountOwner = objCampMember.LX_Account_Owner_name__c;
          this.m_SWAexOwnerName = objCampMember.LX_AEX_Owner_name__c;
        }
    }
    
       /* Description : Approves campaign members.
    *  Returns :  void.
    */
    
    public pageReference ApproveMembers()
    {
        updateCampiagnMembers('Opted-Out');
        return null;
    }
    
      /* Description : Rejects campaign members.
    *  Returns :  void.
    */
    
    public pageReference RejectMembers()
    {
      updateCampiagnMembers('Opt-Out Denied');
      return null;
    }
    
      /* Description : It updates the status to opt-out / opt-out denied.
    *  Param - StrStatus : updates the status to opt-out / opt-out denied. 
    *  Returns :  void.
    */
    private void updateCampiagnMembers(String StrStatus)
    {
        //Declare a list to store the selected records 
        List<CampaignMember> lstCampaignMembers = new List<CampaignMember>();
        system.debug('Test == '+m_lstCampaignMembers);
        for(CampaignMemberWrapper cWrapper : m_lstCampaignMembers){
               if(cWrapper.m_isSelected){
                    cWrapper.m_CampaignMember.Status = StrStatus;
                    lstCampaignMembers.add(cWrapper.m_CampaignMember);
               }
          }
          
        if(lstCampaignMembers.size() <= 0) return;
        //Update the campaign Member status
        update lstCampaignMembers;
    
    }
}