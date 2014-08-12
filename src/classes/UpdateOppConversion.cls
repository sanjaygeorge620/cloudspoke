public with sharing class UpdateOppConversion {

@future
    public static void updateOppConversionDate(List<ID> oppIDSet) {
        ID oppRecID = null;
        if (oppIDSet !=null && oppIDset.size()> 0){
            List<Opportunity> UpdatedOppLIst = New List<Opportunity>();
            for (Integer i=0;i<oppIDSet.size(); i++){
                oppRecID = oppIDSet[i];                     
                Date Date_Qualification_Conv = null;
                date Date_Presentation_Conversion= null;
                date Date_Proposal_Conv= null;
                date Date_Validation_Conversion= null;
                date Date_Negotiation_Conv= null;
                date CloseDate= null;
                date CloseWithdrawDate= null;
                date CloseDeadDate= null;
                Date TodaysDate = Date.today();
                

                Opportunity oppRec = ([Select id, StageName, Name, Date_Qualification_Conv__c, Date_Presentation_Conversion__c,
                        Date_Proposal_Conv__c,Date_Validation_Conversion__c, Date_Negotiation_Conv__c, CloseDate from Opportunity where id=:oppRecID]);

                if(oppRec != null){                        
                system.debug('***Name: ' + opprec.Name);    
                //*****Qualificiation*******        
                if (oppRec.Date_Qualification_Conv__c == NULL){
                    Date_Qualification_Conv = TodaysDate;
                }Else{   
                    Date_Qualification_Conv = oppRec.Date_Qualification_Conv__c;
                }    
                system.debug('***Date Qualification: ' + Date_Qualification_Conv);
                
                //*******Presentation********
                if (oppRec.Date_Presentation_Conversion__c == NULL){
                    Date_Presentation_Conversion = TodaysDate;
                }Else {    
                    Date_Presentation_Conversion= oppRec.Date_Presentation_Conversion__c;
                }    
                system.debug('***Date_Presentation_Conversion: ' + Date_Presentation_Conversion);
                
                //*******Proposal********
                If (oppRec.Date_Proposal_Conv__c == NULL) {
                    Date_Proposal_Conv= TodaysDate;
                }Else {
                    Date_Proposal_Conv= oppRec.Date_Proposal_Conv__c;
                }    
                system.debug('***Date_Proposal_Conv: ' + Date_Proposal_Conv);
                
                //********Validation*********
                If (oppRec.Date_Validation_Conversion__c == NULL) {
                    Date_Validation_Conversion = TodaysDate;
                } Else {   
                    Date_Validation_Conversion= oppRec.Date_Validation_Conversion__c;
                }    
                system.debug('*****Date_Validation_Conversion: ' + Date_Validation_Conversion);
                
                
                //*******Negotiation********
                If (oppRec.Date_Negotiation_Conv__c == NULL) {
                    Date_Negotiation_Conv= TodaysDate;
                } Else {    
                    Date_Negotiation_Conv= oppRec.Date_Negotiation_Conv__c;  
                }
                system.debug('***Date_Negotiation_Conv: ' + Date_Negotiation_Conv);
                CloseDate = oppRec.CloseDate;  
                CloseWithdrawDate = oppRec.CloseDate;
                CloseDeadDate = oppRec.CloseDate; 
                
                //********Qualification - Set all Fields********* 
                //if(oppRec.StageName == 'Qualification'){ Kapil Reddy Sama 5/13/2013,replaced the old stages with the new ones 
                if(oppRec.StageName == 'Developing'){
                    if (oppRec.Date_Qualification_Conv__c == Null){
                        oppRec.Date_Qualification_Conv__c = Date_Qualification_Conv;
                    }   
                }
                
                //*******Presentation - Set All fields *********
                if(oppRec.StageName == 'Demonstrating'){//Veenu Trehan 5/13/2013,replaced the old stage Presentation with the new ones 
                    If (oppRec.Date_Presentation_Conversion__c == Null){
                        oppRec.Date_Presentation_Conversion__c = Date_Presentation_Conversion;
                    }
                    if (oppRec.Date_Qualification_Conv__c == Null){
                        oppRec.Date_Qualification_Conv__c = Date_Presentation_Conversion;
                    }
                       
                }
            
                //******Proposal - Set All Fields ************
                //if(oppRec.StageName =='Proposal'){Kapil Reddy Sama 5/13/2013,replaced the old stages with the new ones 
                if(oppRec.StageName =='Demonstrating'){
                    If (oppRec.Date_Proposal_Conv__c == Null){
                            oppRec.Date_Proposal_Conv__c = Date_Proposal_Conv;
                    }
                    If (oppRec.Date_Presentation_Conversion__c == Null){
                        oppRec.Date_Presentation_Conversion__c = Date_Proposal_Conv;
                        Date_Presentation_Conversion = Date_Proposal_Conv;
                    }
                    If (oppRec.Date_Qualification_Conv__c == Null){
                        oppRec.Date_Qualification_Conv__c = Date_Presentation_Conversion;
                    }
                    If (oppRec.Date_Proposal_Conv__c == Null){
                            oppRec.Date_Proposal_Conv__c = Date_Proposal_Conv;
                    }
                }
                
                //*****Validation - Set All fields *************
                //if(oppRec.StageName =='Validation'){Kapil Reddy Sama 5/13/2013,replaced the old stages with the new ones 
                if(oppRec.StageName =='Proposing'){
                    If (oppRec.Date_Validation_Conversion__c  == Null){
                        oppRec.Date_Validation_Conversion__c = Date_Validation_Conversion;
                    }
                    If (oppRec.Date_Proposal_Conv__c == Null){
                            oppRec.Date_Proposal_Conv__c = Date_Validation_Conversion;
                            Date_Proposal_Conv = Date_Validation_Conversion;
                    }
                    If (oppRec.Date_Presentation_Conversion__c == Null){
                        oppRec.Date_Presentation_Conversion__c = Date_Proposal_Conv;
                        Date_Presentation_Conversion = Date_Proposal_Conv;
                    }
                    If (oppRec.Date_Qualification_Conv__c  == Null){
                            oppRec.Date_Qualification_Conv__c = Date_Presentation_Conversion;
                    }
                    
                }
                //*********Negotiation - Set All Fields **********
                //if(oppRec.StageName =='Negotiation'){Kapil Reddy Sama 5/13/2013,replaced the old stages with the new ones 
                if(oppRec.StageName =='Closing'){
                    If (oppRec.Date_Negotiation_Conv__c == Null){
                            oppRec.Date_Negotiation_Conv__c = Date_Negotiation_Conv;
                    }
                    If (oppRec.Date_Validation_Conversion__c  == Null){
                        oppRec.Date_Validation_Conversion__c = Date_Negotiation_Conv;
                        Date_Validation_Conversion = Date_Negotiation_Conv;
                    }
                    If (oppRec.Date_Proposal_Conv__c == Null){
                            oppRec.Date_Proposal_Conv__c = Date_Validation_Conversion;
                            Date_Proposal_Conv = Date_Validation_Conversion;
                    }
                    If (oppRec.Date_Presentation_Conversion__c == Null){
                        oppRec.Date_Presentation_Conversion__c = Date_Proposal_Conv;
                        Date_Presentation_Conversion = Date_Proposal_Conv;
                    }
                    If (oppRec.Date_Qualification_Conv__c  == Null){
                            oppRec.Date_Qualification_Conv__c = Date_Presentation_Conversion;
                    }
                }
                
                //*********Closed Won - set all Fields  ********
                if(oppRec.StageName =='Closed Won'){
                    If (oppRec.Date_Negotiation_Conv__c == Null){
                            oppRec.Date_Negotiation_Conv__c = CloseDate;
                            Date_Negotiation_Conv = CloseDate;
                    }
                    If (oppRec.Date_Validation_Conversion__c  == Null){
                        oppRec.Date_Validation_Conversion__c = Date_Negotiation_Conv;
                        Date_Validation_Conversion = Date_Negotiation_Conv;
                    }
                    If (oppRec.Date_Proposal_Conv__c == Null){
                        oppRec.Date_Proposal_Conv__c = Date_Validation_Conversion;
                        Date_Proposal_Conv = Date_Validation_Conversion;
                    }
                    If (oppRec.Date_Presentation_Conversion__c == Null){
                        oppRec.Date_Presentation_Conversion__c = Date_Proposal_Conv;
                        Date_Presentation_Conversion = Date_Proposal_Conv;
                    }
                    If (oppRec.Date_Qualification_Conv__c  == Null){
                        oppRec.Date_Qualification_Conv__c = Date_Presentation_Conversion;
                    }
                }
                
          
       /*          if(oppRec.StageName =='Closed Withdraw' || oppRec.StageName =='Closed Dead' ){
                    If (oppRec.Date_Negotiation_Conv__c == Null){
                            oppRec.Date_Negotiation_Conv__c = TodaysDate;
                            Date_Negotiation_Conv = TodaysDate;
                    }
                    If (oppRec.Date_Validation_Conversion__c  == Null){
                        oppRec.Date_Validation_Conversion__c = Date_Negotiation_Conv;
                        Date_Validation_Conversion = Date_Negotiation_Conv;
                    }
                    If (oppRec.Date_Proposal_Conv__c == Null){
                        oppRec.Date_Proposal_Conv__c = Date_Validation_Conversion;
                        Date_Proposal_Conv = Date_Validation_Conversion;
                    }
                    If (oppRec.Date_Presentation_Conversion__c == Null){
                        oppRec.Date_Presentation_Conversion__c = Date_Proposal_Conv;
                        Date_Presentation_Conversion = Date_Proposal_Conv;
                    }
                    If (oppRec.Date_Qualification_Conv__c  == Null){
                        oppRec.Date_Qualification_Conv__c = Date_Presentation_Conversion;
                    }
                }*/
                
                 if(oppRec.StageName =='Closed Withdraw'){
                     oppRec.Date_closed_withdraw__c = TodaysDate;
                 }
                 if(oppRec.StageName =='Closed Dead'){
                     oppRec.Date_closed_dead__c = TodaysDate;
                 }
                
                system.debug('opprec - updated' + oppRec);
                UpdatedOppList.add(oppRec);
                }
            }
            update UpdatedOppList;
            
        }   
    }   
}