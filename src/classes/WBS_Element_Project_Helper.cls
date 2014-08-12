Public with sharing class WBS_Element_Project_Helper{
    
    //*********************************************************************************
    // Trigger Utility Methods
    //*********************************************************************************
        
        //Constructor
            private boolean m_isExecuting = false;
            private integer BatchSize = 0;
            public WBS_Element_Project_Helper(boolean isExecuting, integer size){
                m_isExecuting = isExecuting;
                BatchSize = size;
            }

        //Insert
            public  void OnBeforeInsert(LIST<WBS_Element_Project__c> triggernew){
               //Find related projects            
                FindRelatedPSEProject(triggernew, null, null);
            }
            public void OnAfterInsert(list<WBS_Element_Project__c> triggernew){
                //none
            }
            
        //Update
            public void OnBeforeUpdate(LIST<WBS_Element_Project__c> triggerold, LIST<WBS_Element_Project__c> triggernew, MAP<Id,WBS_Element_Project__c> triggernewmap, MAP<Id,WBS_Element_Project__c> triggeroldmap){
               //Find related projects
               FindRelatedPSEProject(triggernew, triggeroldmap, triggernewmap);
            }
            public void OnAfterUpdate(LIST<WBS_Element_Project__c> triggerold, LIST<WBS_Element_Project__c> triggernew, MAP<Id,WBS_Element_Project__c> triggernewmap, MAP<Id,WBS_Element_Project__c> triggeroldmap){
                //none
            }
    
    
    
    //*********************************************************************************
    // Helper Methods
    //*********************************************************************************
        
        //Find related PSE Projects
        public void FindRelatedPSEProject(list<WBS_Element_Project__c> triggernew, MAP<Id,WBS_Element_Project__c> triggeroldmap, MAP<Id,WBS_Element_Project__c> triggernewmap){ 
            //Get set of related opportunities
                set<string> sOpportunities = new set<string>();
                for(WBS_Element_Project__c w: triggernew){
                    //If there is no project assigned but there is an opportunity, assign to oppty set
                    if(w.Project__c==null && w.opportunity__c!=null)
                        sOpportunities.add(w.opportunity__c);
                }
                
            //Get set of other assigned WBS Element Projects to prevent assignment of projects to new records that have already been assigned
                set<id> sPreviouslyAssignedProjects = new set<id>();
                for(WBS_Element_Project__c w:[select id, project__c from WBS_Element_Project__c where Opportunity__c in: sOpportunities]){
                    sPreviouslyAssignedProjects.add(w.project__c);
                    
                    //Need to add a project back if it is currently being removed as the query above doesn't know the state of trigger.new
                    if(trigger.isupdate && triggernewmap!=null && triggeroldmap!=null && triggernewmap.containskey(w.id) && sPreviouslyAssignedProjects.contains(w.project__c)){
                        if(triggeroldmap.get(w.id).project__c!=triggernewmap.get(w.id).project__c){
                            //remove project
                            sPreviouslyAssignedProjects.remove(triggeroldmap.get(w.id).project__c);        
                        }
                    }
                }        
                
            //Get map of Opportunities/Related PSE Projects (non Pre-Sales)
                map<id,list<pse__Proj__c>> mProjects = new map<id,list<pse__Proj__c>>();
                for(opportunity o:[select id, (select id from pse__Projects__r where recordtype.developername!='Pre_Sales' ) from opportunity where id in: sOpportunities]){
                    mProjects.put(o.id,o.pse__Projects__r);
                }
                
            //Assign  Projects
                //If no project matches: Proj = null
                //If 1 project matches: Proj = id of project
                //If > 1 project matches: Clone currect record and create multiple WBS Element Projects
                
                list<pse__Proj__c> projs;
                list<WBS_Element_Project__c> newRecords = new list<WBS_Element_Project__c>();
                for(WBS_Element_Project__c w: triggernew){
                // SC:2/14/2014: Updated as per Case # 00727896 such that only WBS elements of Type Costing gets copied on Projects. 
                    if((w.Project__c==null && w.opportunity__c!=null && mProjects.ContainsKey(w.opportunity__c)) && w.WBS_Element_Type__c == 'Costing'){
                        projs = new list<pse__Proj__c>(mProjects.get(w.opportunity__c));
                        
                        //If 1 project matches: Proj = id of project    
                            if(projs.size()==1){
                               w.Project__c = projs[0].id;     
                               
                        //If > 1 project matches: Update current record and create multiple WBS Element Projects
                            }else if(projs.size()>1){
                                   for (Integer i = 0; i < projs.size(); i++) { 
                                    //Assign first record to existing record
                                      if(i==0){
                                          w.Project__c = projs[i].id;     
                                      }else{
                                        newRecords.add(new WBS_Element_Project__c(WBS_Element__c=w.WBS_Element__c,Opportunity__c=w.Opportunity__c,Project__c=projs[i].id));
                                      } 
                                   }
     
                            }else{
                                //If no project matches: Proj = null
                            }                          
                    }    
                }
                
                //Create records forprocessing
                if(newRecords.size()>0){
                    try{
                       insert newRecords;
                   }catch(exception e){
                       //Exception Handler
                       system.debug('FindRelatedPSEProject Error=>:'+e.getmessage());
                   }   
                
                }
        }
    
}