public class lastViewed_mss{
 
    public Datetime cDT; 
    public String LongDate; 
    public String firstname; 
    public String lastname;    
    public String userid;
 
    private final Migration_Services_Server__c acct;
 
    public lastViewed_mss(ApexPages.StandardController stdController) {
        this.acct = (Migration_Services_Server__c)stdController.getRecord();    
    }
 
       public String getLongDate() {        
           cDT = System.now();   
           //Format the datetime value to your locale        
           LongDate = cDT.format('dd/MM/yyyy HH:mm');    
           return LongDate;    
       }
 
        public void updateField() {
            //Get the user info from the current user        
            firstname = System.Userinfo.getFirstName();        
            lastname = System.Userinfo.getLastName();       
            userid = System.Userinfo.getUserId();
         
            //Get the account record to be updated        
            Migration_Services_Server__c a = [select Last_Viewed_By__c from Migration_Services_Server__c where id = :acct.id limit 1];        
         
            //Assign values to Last Viewed By field &amp; update the record        
            a.Last_Viewed_By__c = (firstname + ' ' + lastname + ', ' + getLongDate());        
            update a;    
        }
 
}