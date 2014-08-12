Public class LX_RMA_Extension
{
    Public LX_RMA__c RMAStanRecord;
    Public LX_RMA__c RMAStanRecord1;
    public boolean Profilecheck{get;set;}
    Public ID id1;
    
    
    Public LX_RMA_Extension(Apexpages.StandardController controller)
    {
        this.RMAStanRecord = (LX_RMA__C)controller.getrecord();
        id1 = Apexpages.currentpage().getparameters().get('id');
        if(id1 !=null)
        RMAStanRecord1 = [select id,LX_RMA_Submitted__c  from LX_RMA__C where id =:id1];
         Profilecheck = LX_CreditAppLead_Utility.globalDataAdmin(UserInfo.getUserid(),UserInfo.getprofileid());
    }
    
    Public Pagereference viewPage()
    {
        Pagereference detailPage = new Pagereference('/apex/RMAdetailPage?id='+id1);
        detailPage.setredirect(true);
        return detailPage;
    }
    
    Public Pagereference editPage()
    {
       if(RMAStanRecord1.LX_RMA_Submitted__c && (!(profileCheck)))
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'The record is submitted and do not have the approriate permission to edit the record.'));
                return null;
            }
        else
        {
            Pagereference editPage = new Pagereference('/apex/RMAeditPage?id='+id1+'&mode=edit');
            editPage.setredirect(true);
            return editPage;
        }
    }
        
    Public Pagereference newPage()
    {
        //ID id = Apexpages.currentpage().getparameters().get('id');
        Pagereference newPage = new Pagereference('/apex/RMAeditPage?mode=new');
        newPage.setredirect(true);
        return newPage;
    }
}