/**************************************************************
Class Name   : Data_Assignment
Created by   : Srikanth Seela
Created Date : May 13, 2011
Modified By : 
Modified Date : 
Purpose      : Class for creating an Assignment
***************************************************************/
@isTest
public class Data_Assignment
{
    //Create Assignments for a project 
    public static List<pse__Assignment__c> createAssignments(List<pse__Proj__c> prjs,pse__Schedule__c sch,integer num){
        try{
        List<pse__Assignment__c> assignments = new List<pse__Assignment__c> ();
        List<pse__Proj__c> projects = prjs;
        Data_UserPermissionControl.createPermission(projects);
        pse__Schedule__c schedule = sch;
        System.debug('PPPPPPPPPPPProjects '+projects);  
        //Account acc = Data_Account.createAccount();
        //List<Contact> contacts = Data_Contact.createContacts(acc.Id,projects.Size());
        
        //System.debug('Contacts created :'+contacts) ;
        
            //For each project in the List
            for(integer j=0;j<projects.Size();j++){
            
                System.debug('Creating Assignments for Project '+ j);
            
                //create Assignments
                for(integer i=0;i<num;i++){
                
                    System.debug('Creating Assignment '+i+'For Project '+j);
                    
                    pse__Assignment__c assignment = new pse__Assignment__c();
                    assignment.pse__Project__c = projects[j].id;
                    assignment.pse__Status__c = 'Scheduled';
                    assignment.pse__Schedule__c = schedule.id;
                    //assignment.pse__Resource__c =  Projects[j].Accounting_Contact__c; 
                    //System.debug('SSSSSSSSSSSSSSS Projects[j].Accounting_Contact__c '+Projects[j].Accounting_Contact__c);  
                    assignment.pse__Bill_Rate__c = 0;
                    assignment.pse__Is_Billable__c = false;
                    assignment.pse__Cost_Rate_Amount__c = 0;
                    assignment.CurrencyIsoCode = 'USD';
                    //assignment.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c = Userinfo.getUserId();
                    
                    //Add the assignment to assignments
                    assignments.add(assignment);
            }
        }
        insert assignments;        
        return assignments;
        }
        catch(exception e){
        
        }
        return null;
        
    
    }
    static testMethod void testcreatedAssignments() 
    {

      system.debug('*********Start test*******' +Limits.getQueries());
      List<pse__Proj__c> Projects = Data_Project.createProject(1);
      System.debug('Project is Created'+Projects);
      pse__Schedule__c sch = Data_Schedule.createSchedule();
      System.debug('Schedule is Created'+Sch);
   //   test.starttest();
      List<pse__Assignment__c> a = Data_Assignment.createAssignments(Projects,sch,1);
    //  test.stopTest();      
      system.debug('List of Assignments created for the Project(s): '+a);
      
      //System.assertEquals(a.size(),1);
      //System.assertEquals(a[0].pse__Status__c,'Scheduled');
  }      
  
  //Create Assignments for a project 
    public static List<pse__Assignment__c> createAssignments10(List<pse__Proj__c> prjs,pse__Schedule__c sch,integer num){
        try{
        List<pse__Assignment__c> assignments = new List<pse__Assignment__c> ();
        List<pse__Proj__c> projects = prjs;
        Account acc = data_account.createAccount3();
        list<Contact> con = data_contact.createContacts(acc.id, 1);
        Data_UserPermissionControl.createPermission(projects);
        pse__Schedule__c schedule = sch;
        System.debug('PPPPPPPPPPPProjects '+projects);  
        
            for(integer j=0;j<projects.Size();j++){
            
                System.debug('Creating Assignments for Project '+ j);
            
                //create Assignments
                for(integer i=0;i<num;i++){                
                    System.debug('Creating Assignment '+i+'For Project '+j);                    
                    pse__Assignment__c assignment = new pse__Assignment__c();
                    assignment.pse__Project__c = projects[j].id;
                    assignment.pse__Status__c = 'Scheduled';
                    assignment.pse__Schedule__c = schedule.id;
                    assignment.pse__Resource__c = con[0].id ;         
                    assignment.pse__Bill_Rate__c = 0;
                    assignment.pse__Is_Billable__c = false;
                    assignment.pse__Cost_Rate_Amount__c = 0;
                    assignment.CurrencyIsoCode = 'USD';                    
                    assignments.add(assignment);
            }
        }
        insert assignments;        
        return assignments;
        }
        catch(exception e){
        
        }
        return null;
        
    
    }

}