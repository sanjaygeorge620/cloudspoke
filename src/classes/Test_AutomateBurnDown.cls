/**
* @author Nitish Kumar
* @date   06/06/2012
* @description Test class of automateBurnDown Class
*
* Modification Log    :
* ------------------------------------------------------------------------------------------------
* Developer                 Date                    Description
* ---------------         -----------             ----------------------------------------------
* Nitish Kumar             06-JUNE-2012             Original Version
*/

@isTest(SeeAllData = false)
private class Test_AutomateBurnDown {
    
    static testMethod void myUnitTest() {
        
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 200; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Progress',
                                                Start_Date__c = date.parse('06/01/2012'),
                                                End_Date__c   = date.parse('12/01/2012')
                                            );
            sprints.add(objSprint);
        }
         insert sprints;
        
         List<Requirements__c> requirements = new List<Requirements__c>{};
        
            for(Integer i = 0; i < 20; i++){
                Requirements__c objRequirement =new Requirements__c(
                                                        User_Story__c           = 'Test-Description-User-Stroy',
                                                        Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                        Development_Stage__c    = 'Backlog' ,
                                                        Priority__c             = '0',
                                                        Planned_Sprint_del__c   = sprints[0].Id,
                                                        Allocated_Sprint__c     = sprints[0].Id
                );
                requirements.add(objRequirement);
            }
             Requirements__c req1 = new Requirements__c(User_Story__c           = 'Test-Description-User-Stroy',
                                                        Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                        Development_Stage__c    = 'Passed (complete)' ,
                                                        Priority__c             = '0',
                                                        Planned_Sprint_del__c   = sprints[0].Id,
                                                        Allocated_Sprint__c     = sprints[0].Id
                                                        
             );
              
              requirements.add(req1);
             insert requirements ;
            
        // Date dat = date.parse('01/01/2012');   
         
         list<BurnDown2__c> burndown = new list<BurnDown2__c>();
            for(Integer i = 0; i < 20; i++){
                 BurnDown2__c burn = new BurnDown2__c(
                                                    Sprint__c = sprints[0].Id
                                                    
             );
                 burndown.add(burn);                                   
            }
            
            BurnDown2__c burn1 = new BurnDown2__c(
                                                    Sprint__c = sprints[0].Id,
                                                    Date__c = date.parse('12/06/2012'));
                                                    
            burndown.add(burn1);
            
            BurnDown2__c burn2 = new BurnDown2__c(
                                                    Sprint__c = sprints[0].Id,
                                                    Date__c = date.today());
            burndown.add(burn2);         
                                           
            insert burndown;
            
            test.startTest();
            
            automateBurnDown.generateSprintBurndown(sprints[0].id);
            automateBurnDown.updateSprintBurndown(sprints[0].id);
        
            test.stopTest();
    }
    
    static testMethod void test_automateBurnDownBatchJob() {
        
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 200; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Progress',
                                                Start_Date__c = date.parse('06/01/2012'),
                                                End_Date__c   = date.parse('12/01/2012')
                                            );
            sprints.add(objSprint);
        }
         insert sprints;
        
         List<Requirements__c> requirements = new List<Requirements__c>{};
        
            for(Integer i = 0; i < 20; i++){
                Requirements__c objRequirement =new Requirements__c(
                                                        User_Story__c           = 'Test-Description-User-Stroy',
                                                        Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                        Development_Stage__c    = 'Backlog' ,
                                                        Priority__c             = '0',
                                                        Planned_Sprint_del__c   = sprints[0].Id,
                                                        Allocated_Sprint__c     = sprints[0].Id
                );
                requirements.add(objRequirement);
            }
             Requirements__c req1 = new Requirements__c(User_Story__c           = 'Test-Description-User-Stroy',
                                                        Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                        Development_Stage__c    = 'Passed (complete)' ,
                                                        Priority__c             = '0',
                                                        Planned_Sprint_del__c   = sprints[0].Id,
                                                        Allocated_Sprint__c     = sprints[0].Id
                                                        
             );
              
              requirements.add(req1);
             insert requirements ;
            
        // Date dat = date.parse('01/01/2012');   
         
         list<BurnDown2__c> burndown = new list<BurnDown2__c>();
            for(Integer i = 0; i < 20; i++){
                 BurnDown2__c burn = new BurnDown2__c(
                                                    Sprint__c = sprints[0].Id
                                                    
             );
                 burndown.add(burn);                                   
            }
            
            BurnDown2__c burn1 = new BurnDown2__c(
                                                    Sprint__c = sprints[0].Id,
                                                    Date__c = date.parse('12/06/2012'));
                                                    
            burndown.add(burn1);
            
            BurnDown2__c burn2 = new BurnDown2__c(
                                                    Sprint__c = sprints[0].Id,
                                                    Date__c = date.today());
            burndown.add(burn2);         
                                           
            insert burndown;
            
            test.startTest();
            string strQuery = 'Select Actual_burndown__c,Current_velocity__c, Date__c,Optimum_burndown__c,Project__c, Projected_burndown__c,Sprint__c ,Sprint__r.Working_Days_Through_Sprint__c,Sprint__r.Number_Working_Days_in_Sprint__c From BurnDown2__c Where Sprint__c = \'' + sprints[0].Id + '\''; 
            
        //    automateBurnDownBatchJob objBatch = new automateBurnDownBatchJob(strQuery);
         //   database.executebatch(objBatch);
             
            test.stopTest();
    }

}