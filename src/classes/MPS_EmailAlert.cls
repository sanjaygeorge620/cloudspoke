/**
* Author : Pruthvi Ayireddy
* Date: 08/04/2014 
* Description : To implement the logic for the custom button 'MPS Email'.
* 				 When the user clicks on this button,
* 							i.  if there is an opportunity team member and the role is 'Customer Operations Manager/Regional Operations Consultant',send an email and create a task assigned to the role.
*  							ii. else send an email and create a task assigned to the opportunity owner.
* 							iii.if there is no opportunity team, then send an email and create a task assigned to the opportunity owner.
*/

global class MPS_EmailAlert{
    
    webservice static void MPSTask(Id OppId){
        
        List<OpportunityTeamMember> OppTeam = [Select Id,TeamMemberRole,OpportunityId,UserId,Opportunity.Name,Opportunity.OwnerId,Opportunity.StageName from OpportunityTeamMember where OpportunityId = :OppId];
        List<Opportunity> Opportunities = [Select Id,OwnerId,Name,StageName from Opportunity where Id = :Oppid];
        List<Id> UserIds = new List<Id>();
        List<Task> taskList = new List<Task>();
        
        if(OppTeam.size()>0){
            for(OpportunityTeamMember otm : OppTeam){
                
                String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + otm.OpportunityId;
                Task ct = new Task();
                ct.Subject = 'This MPS opportunity is now ready to download the MPS Download file for your review';
                ct.Description = 'The URL to the MPS Opportunity is: '+fullRecordURL;
                if(otm.TeamMemberRole == 'Customer Operations Manager' || otm.TeamMemberRole == 'Regional Operations Consultant'){
                    ct.OwnerId = otm.UserId;
                    UserIds.add(otm.UserId); 
                }else{
                    ct.OwnerId = otm.Opportunity.OwnerId;
                    UserIds.add(otm.Opportunity.OwnerId);
                }
                taskList.add(ct);
                
                // Email Alert 
                for(Integer i =0;i<UserIds.size();i++){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(UserIds[i]);
                    System.debug('********************************************************'+UserIds[i]);
                    mail.setsubject(otm.Opportunity.Name+'Opportunity stage changed to proposing');
                    mail.setHtmlBody('This e-mail is to inform you that this opportunity stage has now moved to Proposing Status.'+'<br>'+
                                     'Please review the opportunity and where appropriate create/update the Deal Desk quote information'+'<br>'+
                                     'and the Product/Services in the Scope/Solution tab.<p>'+
                                     'Opportunity Name  : '+otm.Opportunity.Name+'<br>'+
                                     'Opportunity Stage : '+otm.Opportunity.StageName+'<br>'+
                                     'Link to the Opportunity : '+'<a href='+fullRecordURL+'>'+otm.Opportunity.Name+'</a><br>'             
                                    );
                    mail.saveAsActivity = false; // Has to be set to false when using the 'User' Object.
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            if(!taskList.isEmpty()){
                insert taskList; 
            }
        }else{
            for(Opportunity opp : Opportunities){
                String recordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id;
                Task tsk = new Task();  
                tsk.Subject = 'This MPS opportunity is now ready to download the MPS Download file for your review';
                tsk.OwnerId = opp.OwnerId;
                tsk.Description = 'The URL to the MPS Opportunity is: '+recordURL;
                taskList.add(tsk);
                UserIds.add(opp.OwnerId);
                
                // Email Alert
                for(Integer i =0;i<UserIds.size();i++){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(UserIds[i]);
                    mail.setsubject(opp.Name+'Opportunity stage changed to proposing');
                    mail.setHtmlBody('This email is to inform you that this opportunity stage has now moved to Proposing Status.'+'<br>'+
                                     'Please review the opportunity and where appropriate create/update the Deal Desk quote information'+'<br>'+
                                     'and the Product/Services in the Scope/Solution tab.<p>'+
                                     'Opportunity Name  : '+opp.Name+'<br>'+
                                     'Opportunity Stage : '+opp.StageName+'<br>'+
                                     'Link to the Opportunity : '+'<a href='+recordURL+'>'+opp.Name+'</a><br>'          
                                    );
                    mail.saveAsActivity = false;  // Has to be set to false when using the 'User' Object.
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }  
            if(!taskList.isEmpty()){
                insert taskList; 
            }
        }
    }
}