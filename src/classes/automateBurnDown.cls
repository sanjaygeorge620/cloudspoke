Global class automateBurnDown {
          
    //calculate optimal burndown for a given day in a given sprint
    private static decimal optimalBurndown(Sprint__c sprint, Decimal totalPoints, Integer daysIntoSprint){
         Decimal optimalPointsPerDay = totalPoints/(sprint.Number_Working_Days_in_Sprint__c);
         Decimal burndown = totalPoints - (optimalPointsPerDay * daysIntoSprint);
         
         if(burndown < 0)
            burndown = 0;   
         
         return burndown;
    }          
          
/**
     * @description :- populates the burndown object with a row for each date within the sprint 
                    that is a working day (ie exclude weekends) with sprint name, date, 
                    and project fields populated and fields for actual burndown, 
                    optimum burndown, current velocity and projected burndown left blank
     * @param :- Sprint Id
     */ 
            
     WebService static void generateSprintBurndown(String sprintId){
           // Query the Sprint object 
            Sprint__c currentsprint = [select Name,Start_Date__c, End_Date__c,Number_Working_Days_in_Sprint__c, Project__c , Project__r.Name from Sprint__c where id =: sprintId];

           list<date> datelist = new list<date>();
           
              
              // Local Variables 
              date startDate = currentsprint.Start_Date__c;
              date endDate   = currentsprint.End_Date__c;
              integer numberDaysBet = startDate.daysBetween(endDate);
              BurnDown2__c burndown;
              Map<Date,BurnDown2__c> mapburnDown = new map<Date,BurnDown2__c>();
              
              list<Requirements__c> userStoryList = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,
                                                           Allocated_Sprint__r.End_Date__c,Development_Stage__c,Story_Points_Dummy__c 
                                                           From Requirements__c where Allocated_Sprint__c =: sprintId];
              
              Decimal totalpoints = 0;
              
              for (Requirements__c userStory : userStoryList ){
                   totalpoints = totalpoints + userStory.Story_Points_Dummy__c;
              }                                             
          
              // Query all the BurnDown records for the selected Sprint
              list<BurnDown2__c> presentburnDown = [select Name, Date__c,Sprint__c from BurnDown2__c where Sprint__c =: currentsprint.Id];
              
              // Putting the Date of Burndown object as key and BurnDown object as value
              for(BurnDown2__c bDown : presentburnDown){
                  mapburnDown.put(bDown.Date__c , bDown);
              }
            
            //Lists of objects to insert and update
            list<BurnDown2__c> burnDownlist = new list<BurnDown2__c>();
            list<BurnDown2__c> burndownsToUpdate = new list<BurnDown2__c>();
            
               
              // Filtering the weekdays and creating BurnDown Objects only for Weekdays
              Integer j = 0; //days through sprint
              for (Integer i= 0 ; i <= numberDaysBet; i++ ){
                   Date tempstart = startdate.addDays(i);
                   date weekStart = tempstart.toStartofWeek();
                   integer dayOfWeek = weekStart.daysBetween(tempstart);
                   
                   // If selcted day is not Saturday and Sunday
                   if (dayOfWeek != 5 && dayOfWeek != 6){
                        j = j + 1;
                        if(!(mapburnDown.containsKey(tempstart) && mapburnDown.get(tempstart).Sprint__c == currentsprint.id)){
                            //Create the new BurnDown Object with following Values
                            burndown = new BurnDown2__c();
                            burndown.Name = currentsprint.Name +' Burndown';
                            burndown.Date__c = tempstart;
                            burndown.Project__c = currentsprint.Project__r.Name;
                            burndown.Sprint__c  = currentsprint.Id;
                            burndown.Optimum_burndown__c = optimalBurndown(currentsprint, totalpoints, j);
                            // Add to the list
                            burnDownlist.add(burndown);
                        }else{
                            //Burndown object already exists
                            burndown = mapburnDown.get(tempstart);
                            burndown.Optimum_burndown__c = optimalBurndown(currentsprint, totalpoints, j);
                            burndownsToUpdate.add(burndown);
                        }
                    } 
               }
               // Insert the list
               try{
                 insert burnDownlist;
                 update burndownsToUpdate;
               }
               catch(DMLException e) {
               } 
        }


                 
    /**
     * @author :- Nitish Kumar
     * @date  :-  04/06/2012
     * @description :- populates the burndown object with a row for each date within the sprint 
                       that is a working day (ie exclude weekends) with Optimum_burndown__c ,Current_velocity__c
                       ,Projected_burndown__c and Actual_burndown__c fields
     * @param :- Sprint Id
     */ 

    WebService static void updateSprintBurndown(String sprintId){
            list<BurnDown2__c> updateburndown2List = new list<BurnDown2__c>();   // Empty list to be updated later
            // Query All the User Story in the current Sprint
            list<Requirements__c> userStoryList = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,Allocated_Sprint__r.Number_Working_Days_in_Sprint__c,
                                                           Allocated_Sprint__r.End_Date__c,Development_Stage__c,Story_Points_Dummy__c 
                                                           From Requirements__c where Allocated_Sprint__c =: sprintId and Allocated_Sprint__r.Status__c = 'In Progress'];
            
            //Query All the BurnDown Records in the Sprint selected
            list<BurnDown2__c> burndown2List = [Select Actual_burndown__c,Current_velocity__c, 
                                                              Date__c,Optimum_burndown__c,Project__c,
                                                              Projected_burndown__c,Sprint__c ,Sprint__r.Working_Days_Through_Sprint__c,
                                                              Sprint__r.Number_Working_Days_in_Sprint__c,Sprint__r.End_Date__c 
                                                              From BurnDown2__c where Sprint__c =: sprintId  and Sprint__r.Status__c = 'In Progress' Order by Date__c asc];
            
            map<Date, Integer> datemap = new map<Date, Integer>();
            Integer i = 0;
               
            // Adding the working days passed with the Date as the key to the map 
            for(BurnDown2__c burndown : burndown2List){
                datemap.put(burndown.Date__c,i);
                i = i+1;
            }
              
            //Calculate totals
            Decimal totalcompletepoints = 0;
            Decimal totalpoints = 0;    
            for(Requirements__c userStory : userStoryList ){
                // Calculate total complete points
                if (userStory.Development_Stage__c == 'Passed (complete)'){
                    totalcompletepoints = totalcompletepoints + userStory.Story_Points_Dummy__c;
                }
                // Calculate TotalPoints
                totalpoints = totalpoints + userStory.Story_Points_Dummy__c;
            }
            Decimal velocity = 0;
            Decimal actualburn = 0;
            Integer dayOfSprint = 0;
            Integer actualDayOfSprint = 0;         
            for(BurnDown2__c burndown2 : burndown2List){ //looping in order of date ASC
                dayOfSprint++;
                if(date.today() == burndown2.Date__c){ //update actual burndown for today
                    actualburn = totalpoints - totalcompletepoints;
                    burndown2.Actual_burndown__c = actualburn;
                    burndown2.Points_Complete__c = totalcompletepoints;
                    //work-around for graphing limits:
                    //We need to differentiate between ZERO and NULL. 
                    //When creating the summary graph, the sum of the nulls is incorrectly calculated as ZERO
                    //Step A: filter out the zeros from the graph
                    //Step B (here): fudge data so that zero is reported at 0.01, causing it to be graphed and showing the complete sprint
                    if(actualburn==0){
                        burndown2.Actual_burndown__c = 0.01;
                    } 
                    
                    velocity = totalcompletepoints / dayOfSprint;
                    burndown2.Current_velocity__c = totalcompletepoints/(burndown2.Sprint__r.Working_Days_Through_Sprint__c);
                    actualDayOfSprint = dayOfSprint;
                }
                    
                // Add the BurnDown record to the list
                updateburndown2List.add(burndown2);
            } 
                 
            // Update the list
            try{
                update  updateburndown2List;
            }catch(DMLException e) {
            }
        }   
   }