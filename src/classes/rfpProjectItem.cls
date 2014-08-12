public class rfpProjectItem {
    public rfp_projects__c ev;
    public String formatedDate; 
        public rfpProjectItem(rfp_projects__c e) { 
        ev= e;
        // build formated date
        //9:00 AM - 1:00 PM
        // system.debug(e.activitydatetime.format('MMM a'));
        // system.debug(e.DurationInMinutes);
        Datetime endd = e.RFP_Due_Date_and_Time__c.addMinutes(0);
        //system.debug(e.activitydatetime.format('h:mm a '));
        formatedDate = '(' + e.RFP_Due_Date_and_Time__c.format('h:mm a') + ')';
        //formatedDate = e.RFP_Due_Date_and_Time__c.format('h:mm a') + ' - ' + endd.format('h:mm a');
        system.debug(formateddate);
        }
    public rfp_projects__c getEv() { return ev; }
    public String getFormatedDate() { return formatedDate; }
}