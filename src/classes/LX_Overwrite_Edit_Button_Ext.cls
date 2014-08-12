public with sharing class LX_Overwrite_Edit_Button_Ext {
    public string oppId {get;set;}
    public Id userId {get;set;}
    public Id ownerid{get;set;}
    public Id OwnerManager{get;set;}
    public string OppName{get;set;}
    public list <opportunity> OppList {get;set;}

  
    public LX_Overwrite_Edit_Button_Ext(ApexPages.StandardController controller) {
        OppList = new list<opportunity>();
        string str = ApexPages.currentPage().getParameters().get('retURL') ;
        oppId = str.remove('/');
        
        userId=userinfo.getUserId();
        if(oppId!=null && oppId!=''){
            OppList=[Select id,Owner.Managerid,OwnerId,Name 
                     FROM opportunity
                     WHERE id=:oppId limit 1];
              if(OppList.size()>0){
                  ownerid =OppList[0].OwnerId ;  
                  OwnerManager =OppList[0].Owner.Managerid;
                  OppName=OppList[0].Name ;
                  } 
                 }
        }

}