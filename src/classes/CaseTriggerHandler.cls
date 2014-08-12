Public with sharing class CaseTriggerHandler{
    
    //*********************************************************************************
    // Trigger Utility Methods
    //*********************************************************************************
        
        //Constructor
            private boolean m_isExecuting = false;
            private integer BatchSize = 0;
            public CaseTriggerHandler(boolean isExecuting, integer size){
                m_isExecuting = isExecuting;
                BatchSize = size;
                
                //Added ByPass Logic
                if(LX_CommonUtilities.ByPassBusinessRule()) return; 
            }

        //Insert
            public  void OnBeforeInsert(LIST<Case> triggernew){
                //Copy Server Fields
                CaseCopyServerFields.Execute(triggernew, null, null);
                
            }
            public void OnAfterInsert(list<Case> triggernew){
                //none
            }
            
        //Update
            public void OnBeforeUpdate(LIST<Case> triggerold, LIST<Case> triggernew, MAP<Id,Case> triggernewmap, MAP<Id,Case> triggeroldmap){
               //Copy Server Fields
                CaseCopyServerFields.Execute(triggernew, triggeroldmap, triggernewmap);
            }
            public void OnAfterUpdate(LIST<Case> triggerold, LIST<Case> triggernew, MAP<Id,Case> triggeroldmap, MAP<Id,Case> triggernewmap){
                //none
            }
    
    
}