trigger LXFO_User_Story_AI_AU_BD on Requirements__c (After Update, After Insert , Before Delete) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code

 // Web service callouts for Syncing with Rally
 boolean DeletionSync = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').DeletionSync__c:false;
    if(DeletionSync){
        if(trigger.isBefore&& trigger.isDelete){
            for(Requirements__c us:trigger.Old){
                LXFO_RallyCalloutMappingUtility RC = new LXFO_RallyCalloutMappingUtility ();
                LXFO_RallyCalloutMappingUtility.US_ups= us;
                if(!Test.isRunningTest()){
                    LXFO_RallyCalloutMappingUtility.deleteUS(us.Object_ID__c);
                }
                             
            }
        } 
    }       
    
        if (trigger.isAfter && (trigger.isUpdate||trigger.isInsert)) {
            

                        
                   Map<Id,User> productOwnerMapVar = new Map<Id,User>([select id, Name from User LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
                   Map<Id,Release__c> releaseMapVar = new Map<Id,Release__c>([select id, Name from Release__c LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
                   Map<Id,Sprint__c> iterationMapvar = new Map<Id,Sprint__c>([select id, name from Sprint__c LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
                   Map<Id,Project__c> projectMapvar = new Map<Id,Project__c>([select id, name from Project__c LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
                        
            
            for(Requirements__c us:trigger.new){
                boolean flag = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').ScheduleRunning__c:false;
            
                if(flag){
                    try{
                    
                        if(trigger.isUpdate){
                            if(trigger.oldmap.get(us.id)!=null&&us.Object_ID__c==trigger.oldmap.get(us.id).Object_ID__c){
                                LXFO_RallyCalloutMappingUtility RC = new LXFO_RallyCalloutMappingUtility();
                                LXFO_RallyCalloutMappingUtility.US_ups= us;
                               //  if(!Test.isRunningTest())
                                {
                                    LXFO_RallyCalloutMappingUtility.upsertUS(us.id, us.Object_id__c, us.User_Story_Name__c, us.State__c, productOwnerMapVar.get(us.Product_Owner__c).Name, 
                                                                             releaseMapVar.get(us.Release__c).Name, us.Description__c, iterationMapvar.get(us.Planned_Sprint_del__c).Name, projectMapVar.get(us.Project__c).Name, 
                                                                             us.SFDC_Story_Points__c,us.Capability__c, us.SubCapability__c,us.User_Group__c, us.Area__c, 
                                                                             us.Capability_Rank__c, us.Functional_Evaluation__c, us.Old_ID__c, us.Integration__c, us.Sources__c, us.ranking__c, 
                                                                             us.requester__c);
                                }    // map fields check and call the function
                            }
                            else{
                                
                            }
                        }
                        else{
                            LXFO_RallyCalloutMappingUtility RC = new LXFO_RallyCalloutMappingUtility ();
                            LXFO_RallyCalloutMappingUtility.US_ups= us;
                            //if(!Test.isRunningTest())
                            {
                                    LXFO_RallyCalloutMappingUtility.upsertUS(us.id, us.Object_id__c, us.User_Story_Name__c, us.State__c, productOwnerMapVar.get(us.Product_Owner__c).Name, 
                                                                             releaseMapVar.get(us.Release__c).Name, us.Description__c, iterationMapvar.get(us.Planned_Sprint_del__c).Name, projectMapVar.get(us.Project__c).Name, 
                                                                             us.SFDC_Story_Points__c,us.Capability__c, us.SubCapability__c,us.User_Group__c, us.Area__c, 
                                                                             us.Capability_Rank__c, us.Functional_Evaluation__c, us.Old_ID__c, us.Integration__c, us.Sources__c, us.ranking__c, 
                                                                             us.requester__c);
                            }
                        } 
                    }   
                    catch(exception e){
                        us.adderror('Error: Please fill Sprint, Project, Release and Product Owner');
                    }   
                }
            }
           
        }
    
}