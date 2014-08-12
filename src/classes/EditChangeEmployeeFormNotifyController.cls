/**
Controller Class Name:- EditChangeEmployeeFormNotifyController 
Page :- EditChangeEmployeeFormNoti
Uses
1. Used to override the edit button on New/ Change Employee Form Notifications records.
2. Polpulate value(Manager, Cost center, Business Unit,Business Title, Office Location ) from User records in to New/ Change Employee Form Notifications records.
3. Send email alert -New Hire Notification and Employee Change Notification, when clicked on submit button. 
*/
public class EditChangeEmployeeFormNotifyController {


 public Employee_Change_Request__c empFormController{get;set;}
 public ID contactId{get;set;}
 public ID EmpFormId{get;set;}
 public Id salesforceuserId{get;set;}
 public list<User> contextUserInfo{get;set;}
 public PageReference empFormNoitfyPage;

 
 
     /*****************CONSTRUCTOR*******************/
     public EditChangeEmployeeFormNotifyController(ApexPages.StandardSetController controller) {
        if(ApexPages.currentPage().getParameters().get('pageAction') == 'onNew')
          createEmployeeChangeNotificationRecord();
        else{
          EmpFormId=ApexPages.currentPage().getParameters().get('Id');
          System.debug('************Id'+EmpFormId);
          empFormController=[select Id,New_Cost_Center__c,New_Business_Title__c,New_Office_Location_City_State__c,New_Manager__c,Business_Unit__c,Contact_Name__c,Effective_Date__c,Correction__c,Change_Reason__c,Desk_Number__c,New_Department__c,Mobile_Option__c,New_Sub_Department__c,Notes_Creation__c,Business_Group__c,Sales_Group__c from Employee_Change_Request__c where Id=:EmpFormId limit 1];
          System.debug('*****Emp'+empFormController);
        }
    }
   
   // Added check for IsManager before allowing New/Edit ECN 
   public PageReference Redirect() {          
        User u = [Select Id,Email,Name,Is_Manager__c from User where Id = :UserInfo.getUserId()];
        PageReference pg;
        String newURL;
        if(u.Is_Manager__c != True )     
             pg = new PageReference('/apex/EmployeeChangeErrorPage');
        return pg;
    }
    /*
    public EditChangeEmployeeFormNotifyController(ApexPages.StandardController controller) {
      
    }
    */
    /**
    It execute when new Employee Form change notification object is being created
    */
    public void createEmployeeChangeNotificationRecord(){  
    empFormController = new Employee_Change_Request__c();    
    contactId=ApexPages.currentPage().getParameters().get('conId'); 
  //this.empFormController = (Employee_Change_Request__c)controller.getRecord();  
    if (ApexPages.currentPage().getParameters().get('salesforceuserId') != '' ){
     salesforceuserId =ApexPages.currentPage().getParameters().get('salesforceuserId');
     contextUserInfo=[select Manager.Id,Manager.Is_Manager__c,Cost_Center__c,Title,Office_Location__c,Is_Manager__c,Legacy_Company__c from User where Id=: salesforceuserId limit 1];
  /* Populating the values from User into Empolyee Change Form Notification object record's values   */
     empFormController.New_Cost_Center__c= contextUserInfo[0].Cost_Center__c;
     empFormController.New_Business_Title__c= contextUserInfo[0].Title;
     empFormController.New_Office_Location_City_State__c= contextUserInfo[0].Office_Location__c;
     /*
     There is filter criteria on the field manager of new/ change employee form change notification object.
     Is manger must be tur for enetering its value.
     */
     if(contextUserInfo[0].Manager.Is_Manager__c==true)
      empFormController.New_Manager__c=contextUserInfo[0].Manager.Id;
   // If Legacy Company is PCSFT in User record, then Perceptive is to be placed in Business_Unit__c of object New/ Change Employee Form Noification
      if(contextUserInfo[0].Legacy_Company__c=='PCSFT')
       empFormController.Business_Unit__c='Perceptive';  
      else
        empFormController.Business_Unit__c=contextUserInfo[0].Legacy_Company__c ;
      }
      empFormController.Contact_Name__c=contactId;      
    }
   /**
    Internally Submit method is used to send email alert New Hire Notification and Employee Change Notification.
    after clicking on this it set the submitted field as true, which further match with the workflow condition
    */
     public PageReference submit(){
     empFormController.Submitted__c=true;
     try{
     if(ApexPages.currentPage().getParameters().get('pageAction') == 'onNew')
       insert empFormController;
      else{
       update empFormController;
      }
     } 
     catch(Exception ex){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
     } 
     if(ApexPages.currentPage().getParameters().get('pageAction') =='onNew'){
      empFormNoitfyPage= new PageReference('/'+contactId);
      return empFormNoitfyPage;
     }
     else {
      empFormNoitfyPage= new PageReference('/'+EmpFormId);
      return empFormNoitfyPage;
     }      
   }
   
   public PageReference save(){
   try{
    empFormController.Contact_Name__c = contactId;
    upsert empFormController;
    system.debug('*** Contact Id **** '+empFormController+' ^^^^^ '+empFormController.Contact_Name__c);
   }
   catch(Exception ex){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
   } 
   if(ApexPages.currentPage().getParameters().get('pageAction') =='onNew'){
     empFormNoitfyPage= new PageReference('/'+contactId);
     return empFormNoitfyPage;
  }
   else {
     empFormNoitfyPage= new PageReference('/'+EmpFormId);
            return empFormNoitfyPage;
   }
 }
  public PageReference cancel(){
   if(ApexPages.currentPage().getParameters().get('pageAction') =='onNew'){
     empFormNoitfyPage= new PageReference('/'+contactId);
     return empFormNoitfyPage;
   }
   else {
     empFormNoitfyPage= new PageReference('/'+EmpFormId);
     return empFormNoitfyPage;
   }
  }
}