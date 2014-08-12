public class rfpProjectItem_Ship {

  public rfp_projects__c ev;

  public String formatedDate; 

    public rfpProjectItem_Ship(rfp_projects__c e) { 

    ev = e;

    // build formated date

    //9:00 AM - 1:00 PM

    // system.debug(e.RFP_Ship_Date_and_Time__c.format('MMM a'));

   
    Datetime endd = e.RFP_Ship_Date_and_Time__c.addMinutes(0);

    //system.debug(e.RFP_Ship_Date_and_Time__c.format('h:mm a '));

    formatedDate = '(' + e.RFP_Ship_Date_and_Time__c.format('h:mm a') + ')';

    //formatedDate = e.RFP_Due_Date_and_Time__c.format('h:mm a') + ' - ' + endd.format('h:mm a');

    system.debug('****************SFDC test formateddate' +formateddate);

    }

  public rfp_projects__c getEv() { return ev; }

  public String getFormatedDate() { return formatedDate; }

}