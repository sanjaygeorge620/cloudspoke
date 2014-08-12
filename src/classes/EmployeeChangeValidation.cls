public class EmployeeChangeValidation {
     /**
     * Name:EmployeeChangeValidation
     *
     * Description: Employee Change request Validation for a new record
     * Created By: Manoj Kolli
     * Created Date: 4/17/2012
     */
    public EmployeeChangeValidation(ApexPages.StandardSetController controller) {

    }
    public EmployeeChangeValidation(){
    }
   
    public PageReference Redirect() {
                  
        User u = [Select Id,Email,Name,Is_Manager__c from User where Id = :UserInfo.getUserId()];
        PageReference pg;
        String newURL;
        if(u.Is_Manager__c != True ){
                                     
             pg = new PageReference('/apex/EmployeeChangeErrorPage');
             
          }
        else{
            ID cId;
            String cname,conid;
            if (ApexPages.currentPage().getParameters().get('id') != '' || ApexPages.currentPage().getParameters().get('id') != null){
              cId = ApexPages.currentPage().getParameters().get('id');
              }
            
            Contact con = [Select Id,LastName,FirstName,Name,AccountId from Contact where Id = :cId];
            
            cname = con.Name;
            cname = EncodingUtil.urlEncode(cname, 'UTF-8');
            conid = EncodingUtil.urlEncode(cId, 'UTF-8');
            
            newURL = '/a4r/e?CF00N70000002voyv='+cname+'&CF00N70000002voyv_lkid='+conid+'&nooverride=1&cancelURL=/'+cId;
            
            pg = new PageReference(newURL);
          }
        return pg;
    }
    
    Public PageReference Error(){
        ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.Error, 'You must be a manager to complete this request..');  
         ApexPages.addMessage(errMsg);
         PageReference pg = new PageReference('/apex/EmployeeChangeErrorPage');
             return pg;           
    }
    
}