/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public with sharing class SitesTrainingRegistrationController Extends SitesController{
    
//-------------------------------------------------------------------------------
// Register
//-------------------------------------------------------------------------------
    private                string    ControllerID; 
    public     static      string    trainername;
    private                list<ELearning_Registration__c> registrationList = new list<ELearning_Registration__c> ();
    public list<Training_Attendee__c> ATTENDEES {get; set;}
    public ELearning_Registration__c REGISTRATION {get; set;} 
    public Course__c COURSE;


    ELearning_Registration__c RegistrationDetail;

    public SitesTrainingRegistrationController() {

        ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
        RegistrationDetail = new ELearning_Registration__c ();
        REGISTRATION = new ELearning_Registration__c();
        newRegistration();

        registrationList = [Select  e.Payment_Method__c,e.Credit_Card_Type__c,e.Purchase_Order_Number__c,
                                    e.Billing_Zip__c, e.Billing_State__c, 
                                    e.Billing_City__c, e.Address_2__c, e.Address_1__c,
                                    e.Country__c
                                    From ELearning_Registration__c e
                                    where e.Applicant__r.id=:UserInfo.getUserId()
                                    order by lastmodifieddate desc ];

        system.debug('sssssssssssssssssssssssss'+registrationList);
        if(registrationList.size()>0){
        registrationDetail = registrationList[0];
        REGISTRATION.Payment_Method__c = registrationDetail.payment_Method__c;
        REGISTRATION.Credit_Card_Type__c = registrationDetail.Credit_Card_Type__c;
        REGISTRATION.Address_1__c = registrationDetail.Address_1__c;
        REGISTRATION.Address_2__c = registrationDetail.Address_2__c ;
        REGISTRATION.Billing_State__c = registrationDetail.Billing_State__c;
        REGISTRATION.Billing_Zip__c = registrationDetail.Billing_Zip__c;
        REGISTRATION.Billing_City__c = registrationDetail.Billing_City__c;
        REGISTRATION.Country__c = registrationDetail.Country__c;
        REGISTRATION.Purchase_Order_Number__c=registrationDetail.Purchase_Order_Number__c;
        }
      }
    
//-------------------------------------------------------------------------------
// Details
//-------------------------------------------------------------------------------
    public Class__c getClass(){
         Class__c  t_class = [Select 
                                name,
                                Course__r.name,
                                Training_Location__r.Name, 
                                Trainers__c,
                                Hours_Text__c, 
                                Class_Type__c, 
                                Class_Date__c,
                                Language__c,
                                Country__c
                              //  Course__r.Geo__c                                
                             From 
                                 Class__c
                              where Class__c.id=:ControllerID
                              limit 1
                           ];
       return t_class;
       }    
    

    
    public void addATTENDEE(){
        // Adding row to the attendee list
        ATTENDEES.add(new Training_Attendee__c(Class__c=getClass().id));
    }    
    
    private void  newRegistration(){

            ATTENDEES = new List<Training_Attendee__c>();
            
            if (SITE_CONTACT.ID==null){
                ATTENDEES.add(new Training_Attendee__c(Class__c=getClass().id));
            
            //defaulting the contact information
            } else if (SITE_CONTACT.ID!=null){
                     Contact c = [select 
                                        Contact_Role__c, 
                                        Physical_City__c, 
                                        Address_Edit_States__c,
                                        Physical_Postal_Code__c,
                                        Address_Edit_Countries__c, 
                                        Physical_Street_Address__c, 
                                        Physical_Street_Address_2__c, 
                                        phone, 
                                        email, 
                                        name, 
                                        account.name 
                                  from contact 
                                  where id=:SITE_CONTACT.ID
                                  ];            
             
                 //ATTENDEE
                     ATTENDEES.add(new Training_Attendee__c(Class__c=getClass().id, Name = c.Name, Contact_Phone__c=c.phone, Attendee_Email__c= c.email, Attendee_ImageNow_Role__c=c.Contact_Role__c));
                 //REGISTRATION
                 
                 
                 
                     REGISTRATION.Address_1__c =c.Physical_Street_Address__c;
                     REGISTRATION.Address_2__c =c.Physical_Street_Address_2__c;
                     REGISTRATION.Billing_City__c =c.Physical_City__c;
                     REGISTRATION.Billing_State__c =c.Address_Edit_States__c;
                     REGISTRATION.Billing_Zip__c =c.Physical_Postal_Code__c;
                     REGISTRATION.Country__c =c.Address_Edit_Countries__c;
             }           
             
         }    
    
    
//-------------------------------------------------------------------------------
// Submit
//-------------------------------------------------------------------------------    
    public pagereference submitEnrollment(){
        
        Savepoint RegSP = Database.setSavepoint();
        
        try{
            //Grab the terms they agreed to
            Legal_Term__c legal = [Select id From Legal_Term__c l where l.Public__c =true and l.Type__c = 'Training Registration' order by l.Version__c desc limit 1];
            
          
            REGISTRATION.Class__c=getClass().id;
            REGISTRATION.Terms_Agreed_By__c=UserInfo.getUserId(); 
            REGISTRATION.Terms_Agreed_On__c = Datetime.now().date();
            REGISTRATION.Terms__c = legal.id;
            system.debug('Registration' +REGISTRATION);
            insert REGISTRATION;
                
            for(Training_Attendee__c ta : ATTENDEES){
                        ta.registration__C= REGISTRATION.id;
                    }
                insert ATTENDEES;
                
            // Create an approval request for the registration  
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(REGISTRATION.id);
                    
            // Submit the approval request for the Registration
            Approval.ProcessResult result = Approval.process(req1);
                    
            // Verify the result  
            System.assert(result.isSuccess());
            
          } catch(Exception e){  
            
                //Rollback Error
                Database.rollback(RegSP);
            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error enrolling for class. '+e.getMessage()));
                ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesTrainingRegistrationController.submitEnrollment','High','Generic');
            
            return null;
            } 
            
            //Complete
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully submitted.'));
            //Success...Go to registration*/
            PageReference Pg;
            if(SITE_NAME == 'ChannelPortalSite')
    {
    pg = page.registrationdetails_Partner;
    }
    if(SITE_NAME == 'CustomerPortalSite')
    {
    pg = page.registrationdetails;
    }
            
            Pg.getParameters().put('id', REGISTRATION.id);
            Pg.getParameters().put('enrollment', 'success');
            Pg.setRedirect(true);
           return Pg;
    }
    
    
    
//-------------------------------------------------------------------------------
// Navigation
//-------------------------------------------------------------------------------
    public PageReference step1() {
      return Page.registration_class;
    }

    public PageReference step2() 
    {
    pagereference pg;
    if(SITE_NAME == 'ChannelPortalSite')
    {
    pg = page.registration_class_confirmation_partner;
    }
    if(SITE_NAME == 'CustomerPortalSite')
    {
    pg = page.registration_class_confirmation;
    }
    
     return pg;
    }
    
}