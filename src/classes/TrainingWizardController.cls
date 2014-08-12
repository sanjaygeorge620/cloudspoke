// Developed to Improve Training Registration
// Created by Michael Fitzgerald
// August 2010
// This class is retrieving lists and Enrolling Attendees

Public with sharing Class TrainingWizardController{
    // Standard Objects
        User u;
        Contact c;
        
    // Custom Objects
        Class__c EClass;
        ELearning_Registration__c ERegistration;
        Course__c ECourse;
        Training_Attendee__c EAttendee;
        
    // Custom Variables    
        public List<Training_Attendee__c> Trainee {get; set;}
        public boolean RenderNoClassError {get; set;}
        public string Confirmation {get; set;}
        
    // Constructors
    public TrainingWizardController(){/*Constructor not used */}
    public TrainingWizardController(ApexPages.StandardController controller) {
        this.EClass = (Class__c)controller.getrecord();
        
        //Showing Error about no class has been selected
        if (eclass.id==null) {RenderNoClassError=true;}else{RenderNoClassError=false;}
        
        // Setting up the SObject variables for Registration and Attendee
        Trainee = new List<Training_Attendee__c>();
        if(ERegistration== null) ERegistration= new ELearning_Registration__c();
        
        // Querying the Current User's Id
        u = [select contactid, name from User where id=:userinfo.getuserid()]; 
        System.debug('TRAINING USER NAME'+u.Name);
        // If the user has an associated contact, query contact info to default object fields
        if (u.contactid!=null){
            c = [select Contact_Role__c, 
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
                  where contact.id 
                  IN (select user.contactid from user where user.id = :userinfo.getuserid())];
            
            // Adding the found contact as the default attendee to the Trainee List
            Trainee.add(new Training_Attendee__c(name=c.name,Contact_Phone__c=c.phone,Attendee_Email__c=c.email));
                        
            // Defaulting the Address information for the registration
            ERegistration.Address_1__c =c.Physical_Street_Address__c;
            ERegistration.Address_2__c =c.Physical_Street_Address_2__c;
            ERegistration.Billing_City__c =c.Physical_City__c;
            ERegistration.Billing_State__c =c.Address_Edit_States__c;
            ERegistration.Billing_Zip__c =c.Physical_Postal_Code__c;
            ERegistration.Country__c =c.Address_Edit_Countries__c;
            }            
        else {
            // Adding a new blank record to the list
            Trainee.add(new Training_Attendee__c());
            }
    }
    
    // Function Methods
    public void addrow(){
        // Adding row to the attendee list
        Trainee.add(new Training_Attendee__c(Class__c=eClass.id));
    }    
    
    
    Public pagereference enroll(){
        // Enrolling the Attendee
        //Savepoint in case we need to rollback
            Savepoint RegSP = Database.setSavepoint();
            
        try{
            //Update the ERegistration
            ERegistration.Class__c=eClass.id;
            insert ERegistration;
                
             // Update the Training Attendee object with the list of attendees      
            for(Training_Attendee__c ta : trainee){
                    ta.Class__c=eClass.id;
                    ta.registration__C= ERegistration.id;
                }
            insert Trainee;
            
            // Create an approval request for the registration  
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(ERegistration.id);
                
            // Submit the approval request for the Registration
            Approval.ProcessResult result = Approval.process(req1);
                
            // Verify the result  
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
            
            //Showing the confirmation Number
            ELearning_Registration__c rg =[select name from ELearning_Registration__c where id=:ERegistration.id];
            Confirmation = 'Confirmation # ' + rg.name;
            // Show Successful Message
            if (result.isSuccess()){
                string prefix = site.getprefix();
                if (prefix==null){prefix='';}
                ApexPages.Message confirmMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'We have received your registration.<br />Confirmation # ' + rg.name +'<br /> For additional information including what to expect and travel information, please visit our <a style="color:#333333;font-size:100%;margin:0px;" href="'+prefix+'/apex/TrainingInfo">Training</a> page.');
                ApexPages.addMessage(confirmMsg); 
            }
          }  
          catch (DmlException e) {// DML Exception handling code here
            ApexPages.addMessages(e);
            
            //Rollback to previous state
            Database.rollback(RegSP);
            
            // Writing to Error Log
            ErrorLogUtility.createErrorRecord(e.getMessage(),'TrainingWizardController.enroll','High','DML');
            return Page.Training_Wizard_1;
          }  
          catch(Exception e){// Generic Exception handling code here  
            ApexPages.addMessages(e);
            
            //Rollback Error
            Database.rollback(RegSP);
            
            // Writing to Error Log
            ErrorLogUtility.createErrorRecord(e.getMessage(),'TrainingWizardController.enroll','Low','Generic');
            return Page.Training_Wizard_1;
            } 
            
            //Complete
            return Page.Training_Wizard_Confirmation;
    }
    
    // LISTS    
    public ELearning_Registration__c getRegistrationData() {
      if(ERegistration== null) ERegistration= new ELearning_Registration__c();
       system.debug(ERegistration);
      return ERegistration;
       }

    // Navigation
    public PageReference step1() {
      return Page.Training_Wizard_1;
    }

    public PageReference step2() {
     return Page.Training_Wizard_2;
    }
    public PageReference MyRegistrations() {
     return Page.Registration;
    }
 
 // TEST ----------------------------------------------------------------------------
    // TEST ----------------------------------------------------------------------------
    static testMethod void TrainingWizardController() {
  
      
     
     // Query Profile        
        //4.18.2013 from 184 to 186
        //Profile p = [select id from profile where name = 'Perceptive Customer Portal Admin' limit 1]; 
      //    Profile p = [select id from profile where name = 'Customer Portal Manager Custom' limit 1];
      //UserRole objUser = [Select PortalType, PortalRole, Name, Id, ContactAccessForAccountOwner,
      //                                                       CaseAccessForAccountOwner From UserRole Where PortalType = 'Partner' Limit 1];
        // Insert Account
            Account aNew = new Account(Name='Test Company', Physical_Country__c = 'USA', BillingCountry = 'USA');
            insert aNew;
            system.debug('Account: ' +aNew.ID + ' Name: ' + aNew.Name);  
         
      // Insert Contact
            Contact cNew = new Contact(accountid=aNew.id, FirstName='John', LastName='Doe',Lx_Lexmark_Vertical__c = 'Manufacturing' );
            cNew.Phone = '123456';
            cNew.MobilePhone = '9999999999';
            cNew.Email = 'Test@Test.com';
             insert cNew;
             system.debug('Contact: ' +cNew.ID + ' Name: ' + cNew.Name);  
            
     
      // Insert User
       /* User MyUser = new User(alias = 'standt', Contactid=cNew.id, email='cstandarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, UserRoleId = objUser.Id,
            timezonesidkey='America/Los_Angeles', username='standarduser@testorg.com');
         Insert MyUser;
     */ // USI team commented for coverage
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
        User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id, 
        timezonesidkey='America/Los_Angeles', username='standardus3dcvfrtgber@testo564rg1.com',LX_Region__c = 'NE',Legacy_Company__c = 'Lexmark');
        Insert adminUser;



        
          System.runAs(adminUser) {
          //MyUser.Contactid=cNew.id;
            
         
            
            course__c course = new course__c(name='Course Name');
            insert course;
        
            Class__c Cempty = new Class__c(course__c=course.id, Class_Capacity__c =10000);
            insert Cempty;
            
            Class__c Cfull = new Class__c(course__c=course.id, Class_Capacity__c =0);
            insert Cfull;
            
              Test.setCurrentPageReference(new PageReference('Page.Training_Wizard_1'));
              ApexPages.currentPage().getParameters().put('id', cEmpty.id);
              ApexPages.Standardcontroller sc = New ApexPages.StandardController(cEmpty);
              TrainingWizardController controller01 = New TrainingWizardController(sc);
            
            Test.startTest();
                system.debug('MJF TRAINING User: ' +adminUser.ID + ' Name: ' + adminUser.lastname);
                
                controller01.getRegistrationData();
                controller01.step1();
                controller01.step2();
                controller01.addrow();
                
                controller01.enroll();
                
                controller01.MyRegistrations();
            
            
              
              ApexPages.currentPage().getParameters().put('id', cFull.id);
              ApexPages.Standardcontroller sc2 = New ApexPages.StandardController(cFull);
              TrainingWizardController controller02 = New TrainingWizardController(sc2);
            
            
                system.debug('TRAINING User: ' +adminUser.ID + ' Name: ' + adminUser.lastname);
                
                controller02.getRegistrationData();
                controller02.step1();
                controller02.step2();
                controller02.addrow();
                
                controller02.enroll();
                
                controller02.MyRegistrations();
            Test.stopTest();    
            }       
    }                                          
}