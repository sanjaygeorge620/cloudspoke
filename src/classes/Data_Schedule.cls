/**************************************************************
Class Name   : Data_Schedule
Created by   : Srikanth Seela
Created Date : May 13th, 2011
Modified By : 
Modified Date : 
Purpose      : Class for creating a schedule
***************************************************************/
public class Data_Schedule{

    //Static Method for creating the Schedule
    public static pse__Schedule__c createSchedule(){
    
        pse__Schedule__c schedule = new pse__Schedule__c();        
        schedule.pse__Start_Date__c = Date.today();
        schedule.pse__End_Date__c = Date.today().addDays(1); 
        insert schedule;       
        return schedule;
    }
    
    //Test whether the Schedule is created or not
    static testMethod void testScheduleData() {
       
       pse__Schedule__c Sch = Data_Schedule.createSchedule();
       List<pse__Schedule__c> schs = new List<pse__Schedule__c>();
       
       System.debug('Schedule being tested: '+Sch);
              
       schs=[SELECT OwnerId from pse__Schedule__c where id= :Sch.id];
       
       System.assertNotEquals(schs[0].id,null);
       System.assertEquals(sch.id,schs[0].id);
       System.assertNotEquals(sch.id,null);     
       System.assertEquals(Sch.pse__Start_Date__c,Date.today()); 
       System.assertEquals(Sch.pse__End_Date__c,Date.today()+1);
    }  
  
}