trigger LX_EventTrigger_AI_AU on Event (After Insert, After Update) {
if(LX_CommonUtilities.ByPassBusinessRule()) return;    
    list<Contact> ConList = new list<Contact>();  
    Contact Con;
    boolean OldValue;
    for(Event Evt: Trigger.new){
    
       if(Trigger.IsAfter&&(Trigger.IsInsert||Trigger.IsUpdate)){
           if(Trigger.IsUpdate)
               OldValue = Trigger.Oldmap.get(Evt.Id).Completed__c;
           if ( OldValue!=Evt.Completed__c||Trigger.IsInsert){
               if(Evt.Whoid!=null){
                   String EvtID = Evt.Whoid;
                   if( Evt.Lx_Activity_Method__c=='F2F'&&EvtID.startsWith('003')&&Evt.Completed__c==true){
                       Con = new Contact(id=EvtID, LX_Last_F2F_Date__c=Evt.LastModifiedDate);
                       ConList.add(Con);
                   }
                   else if ( Evt.Lx_Activity_Method__c=='Phone'&&EvtID.startsWith('003')&&Evt.Completed__c==true){
                       Con = new Contact(id=EvtID,  LX_Last_Called_Date__c=Evt.LastModifiedDate);
                       ConList.add(Con);
                   
                   }
               }
           }
           
       } 
    }
    try{
    if(ConList!=null)
        update ConList;
    }catch(exception e){
        for( Event ev : trigger.new){
            ev.addError(e.getDMLMessage(0));
        }
        
    }
    



}