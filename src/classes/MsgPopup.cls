public class MsgPopup extends SitesController{     
  private string ControllerID;
  public MsgPopup() {
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
           
      }
      
      public list<Training_Attendee__c> ATTENDEES {get; set;}
    public ELearning_Registration__c REGISTRATION {get; set;} 
    public Course__c COURSE;
    
     public ELearning_Registration__c getRegistrationDetails(){
           ELearning_Registration__c RegistrationDetail;
           try{  
                RegistrationDetail = [Select 
                                            e.Account__r.id,
                                            e.Account__r.name, 
                                            e.Class__r.name, 
                                            e.Class__r.id,
                                            e.Total_Cost__c,  
                                            e.Registration_Status__c, 
                                            e.Purchase_Order_Number__c, 
                                            e.Payment_Method__c, 
                                            e.Number_of_Attendees__c, 
                                            e.Name_on_Credit_Card__c, 
                                            e.Name, 
                                            e.Credit_Card_Type__c, 
                                            e.Credit_Card_Number__c, 
                                            e.Credit_Card_Expiration_Date__c, 
                                            e.Course_Name__c, 
                                            e.Course_Type__c,
                                            e.Country__c, 
                                            e.Cost_Per_Attendee__c, 
                                            e.Comments__c, 
                                            e.Billing_Zip__c, 
                                            e.Billing_State__c, 
                                            e.Billing_City__c, 
                                            e.Billing_Amount__c, 
                                            e.Address_2__c, 
                                            e.Address_1__c,
                                            e.Class__r.Training_Location__r.name, 
                                            e.Class__r.Trainers__c,
                                            //e.Class__r.Trainer__c,
                                            e.Class__r.Class_Date_Str__c,
                                            e.Class__r.Hours_Text__c,
                                            e.Class__r.class_type__c,
                                            e.Class__r.Language__c,
                                            e.Class__r.Country__c                                                                                       
                                         From 
                                             ELearning_Registration__c e
                                          where id=:ControllerID and
                                                e.Account__r.id=:SITE_ACCOUNT.id
                                          limit 1
                                       ];
          
          } catch(QueryException e){
                throw new NoDataFoundException();
          }   
        
       return RegistrationDetail;
     }
   
    /*
  public ELearning_Registration__c getElearning(){
        ELearning_Registration__c  Elearning = [Select 
                                Credit_Card_Expiration_Date__c,
                                Credit_Card_Number__c,
                                Credit_Card_Type__c,
                                Address_1__c,
                                Address_2__c,
                                Billing_City__c,
                                Billing_Zip__c,
                                Billing_State__c,
                                Payment_Method__c,
                                Name_on_Credit_Card__c,
                                Country__c                            
                              From 
                                 ELearning_Registration__c
                              where ELearning_Registration__c.id=:ControllerID
                              limit 1
                           ];
       return Elearning;
       }    */
             
  }