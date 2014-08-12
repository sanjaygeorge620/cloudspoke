/* Class Name   : LX_STAR_BI_BU
    * Description  : This Trigger populates the owner.
    * Created By   : Maruthi Kolla
    * Created Date : 11/25/2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla              11/25/2013              1000                   Initial Version
    * Pruthvi Ayireddy           06/11/2014                                Added the logic to create an Opportunity Team Member when assigned resource is added to a star at the time
    *                                                                      of creation or updating the star.
*/    

trigger LX_STAR_BI_BU on STAR__c (after insert, after update) {
    List<STAR__c> star_rec= new List<STAR__c>();
    List<STAR__c> star_requests = new List<STAR__c>();
    List<Task> taskRecords = new List<Task>();
    List<STAR__c> star_oppteam = new List<STAR__c>();                               // added by Pruthvi to create Opportunity Team Member
    List<OpportunityTeamMember> lstOppTeams = new List<OpportunityTeamMember>();    // added by Pruthvi to create Opportunity Team Member
    Set<Id> oppId = new Set<Id>();                                                  // added by Pruthvi to create Opportunity Team Member
    Set<Id> usergroupId = new Set<Id>();                                            // added by Pruthvi to create Opportunity Team Member
    String typeofRequest = Label.LX_STAR_Type_of_Request;
    List<String> valuesList=typeofRequest.split(',');
    Set<String> requestValues = new Set<String>();
    requestValues.addall(valuesList);

    for(STAR__c star_req : Trigger.new)
    {
        if(Trigger.isInsert)
        {
            if(star_req.Assigned_Resource__c != null)
            //star_req.OwnerID = star_req.Assigned_Resource__c;
            {
                STAR__c temp_star = new STAR__c(id=star_req.id,OwnerID =star_req.Assigned_Resource__c);
                star_rec.add(temp_star);
            }
        
            if(star_req.Assigned_Resource__c != null && star_req.Division__c == 'PSW' && !(requestValues.contains(star_req.Type_of_Request__c)))
            {
                star_requests.add(star_req);
                star_oppteam.add(star_req);
                oppId.add(star_req.Opportunity__c);
                usergroupId.add(star_req.Assigned_Resource__c);
            }else{                                                                  // added by Pruthvi to create Opportunity Team Member
                if(star_req.Assigned_Resource__c != null && star_req.Division__c == 'PSW' && star_req.Opportunity__c != null){
                    star_oppteam.add(star_req);
                    oppId.add(star_req.Opportunity__c);
                    usergroupId.add(star_req.Assigned_Resource__c);
                }
            }
        }

        if(Trigger.isUpdate)
        {
            if(star_req.Assigned_Resource__c != null && star_req.Assigned_Resource__c != Trigger.oldMap.get(star_req.ID).Assigned_Resource__c)
            {
                STAR__c temp_star2 = new STAR__c(id=star_req.id,OwnerID =star_req.Assigned_Resource__c);
                star_rec.add(temp_star2);
             }
             
             if(star_req.Assigned_Resource__c != null && Trigger.oldmap.get(star_req.id).Assigned_Resource__c==null   && star_req.Division__c == 'PSW' && !(requestValues.contains(star_req.Type_of_Request__c)) && star_req.Opportunity__c != null)
            {
                star_requests.add(star_req);
                star_oppteam.add(star_req);
                oppId.add(star_req.Opportunity__c);
                usergroupId.add(star_req.Assigned_Resource__c);
            }else{                                                                  // added by Pruthvi to create Opportunity Team Member
                if(star_req.Assigned_Resource__c != null && star_req.Assigned_Resource__c != Trigger.oldMap.get(star_req.ID).Assigned_Resource__c   && star_req.Division__c == 'PSW' && star_req.Opportunity__c != null){
                    star_oppteam.add(star_req);
                    oppId.add(star_req.Opportunity__c);
                    usergroupId.add(star_req.Assigned_Resource__c);
                }
            }
        }
    }  
        
    // Code to Autopopulate Tasks when resource is assigned on STAR record.
    
       if(FirstRun_Check.FirstRun_LX_STAR_BI_BU_trigger  == true)
       {
            if(star_requests.size()>0)
            {
                System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&'+star_requests);
                For(Star__C star: star_requests)
                {
                    Task task_temp = new Task();
                    task_temp.whatid= star.id;
                    task_temp.recordtypeid= Label.LX_STAR_Task;
                    task_temp.ownerid = star.Assigned_Resource__c;
                    task_temp.Subject = 'SE:' + star.Type_of_Request__c;
                    task_temp.Lx_Activity_Type__c = 'Sales Activity';
                    task_temp.Lx_Activity_Method__c = 'Note';
                    task_temp.status = 'Not Started';
                    task_temp.Priority = 'Normal';
                    if(star.End_Date__c != null)
                    task_temp.ActivityDate = star.End_Date__c;
                    else
                    task_temp.ActivityDate = star.Start_Date__c;
                    task_temp.LX_Account__c = star.LX_Account_Name__c;
                    task_temp.LX_Opportunity__c = star.LX_Opportunity_Name__c;
                    taskRecords.add(task_temp); 
                } 
                
                if(taskRecords.size()>0)
                insert taskRecords;
                
            }
            // added by Pruthvi to create Opportunity Team Member
            if(star_oppteam.size()>0)
            {
                System.debug('***************************************'+star_oppteam);
                for(Star__C staropp: star_oppteam)
                {
                    OpportunityTeamMember oppTeam = new OpportunityTeamMember();
                    oppTeam.OpportunityId = staropp.Opportunity__c;
                    oppTeam.UserId = staropp.Assigned_Resource__c;
                    oppTeam.TeamMemberRole='Sales Engineer';
                    lstOppTeams.add(oppTeam);
                }
                
                if (!lstOppTeams.isEmpty()) 
                {
                    insert lstOppTeams; 
                }
            }
            
            FirstRun_Check.FirstRun_LX_STAR_BI_BU_trigger = false;
        }
    
    //get the opportunity team members sharing records based on user/group
    List<OpportunityShare> shares = [select Id, OpportunityAccessLevel,UserOrGroupId,  
                                     RowCause from OpportunityShare where OpportunityId IN :oppId and UserOrGroupId IN :usergroupId
                                     and RowCause = 'Team'];
                                     
    // set the team members access to read/write
    for (OpportunityShare share : shares){ 
        share.OpportunityAccessLevel = 'Edit';
    }
    update shares; 
        
    if(star_rec.size()>0){ //CRC Review Modification (Madhu: 01/29/14)
        update star_rec;
        }
}