public class lastViewed_RA {
 
    public Datetime cDT; 
    public String LongDate; 
    public String firstname; 
    public String lastname;    
    public String userid;
 
    private final Remote_Access__c acct;
 
    public lastViewed_RA (ApexPages.StandardController stdController) {
        this.acct = (Remote_Access__c)stdController.getRecord();    
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
            Remote_Access__c a = [select Last_Viewed_By__c from Remote_Access__c where id = :acct.id limit 1];        
         
            //Assign values to Last Viewed By field &amp; update the record        
            a.Last_Viewed_By__c = (firstname + ' ' + lastname + ', ' + getLongDate());        
            update a;    
        }
 
}