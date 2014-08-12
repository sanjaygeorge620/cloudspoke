/******************************************************************************
Name     : TrainingAttendeeAfterinsert, after update 
Purpose  : Set the sum of total attendee discount of attendees on the Class object.
Author   : 
Date     : April 21, 2014
******************************************************************************/

trigger SumOfDiscountsOfAttendeRecords on Training_Attendee__c (after insert,after update) {


if(LX_CommonUtilities.ByPassBusinessRule()) return;

    Set<id> setClassid=new Set<id>();
    Map<string,Decimal> ClassWithTotalDiscounts=new Map<string,Decimal>();
    
        for(Training_Attendee__c nta: Trigger.new){
    
        if(nta.Class__c!=null && nta.Discount__c!=null){
            setClassid.add(nta.Class__c);
          }                    
    }
     List<Class__c> ListClass=new List<Class__c>();
    if(setClassid.size()>0)
     {
      ListClass=[Select id,Total_Concession__c from Class__c where id In:setClassid];
      List<Training_Attendee__c> ListTrainingAttendee=[Select Id,Discount__c from Training_Attendee__c where id In:setclassid and Discount__c!=null];
    for(Id Clid:setClassid)
        {
       Decimal totcons=0;
       for(Training_Attendee__c ta: ListTrainingAttendee)
          {
           if(Clid==ta.Class__c)
              {
                 totcons=totcons+ta.Discount__c;
              }
           } 
            ClassWithTotalDiscounts.put(Clid,totcons);
         }    
       }
 List<Class__c> UpdateClass=new List<Class__c>();
  for(Class__c CS:ListClass){
     CS.Total_Concession__c=ClassWithTotalDiscounts.get(CS.id);
     UpdateClass.add(CS);
  }
  if(UpdateClass.size()>0){
  
  update UpdateClass;
  
  }
 }