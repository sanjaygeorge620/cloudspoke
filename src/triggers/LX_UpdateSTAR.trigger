/* Trigger Name   : LX_UpdateSTAR
    * Description   : This Trigger Sets the STAR's Status = 'Assigned' and Assigned Resource = Person creating the STAR comment with Available = True   
    *                
    * Created By   : Sanjay Chaudhary
    * Created Date : 02-17-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sanjay Chaudhary            02-17-2014        Case # 00727453  , This has been changed to Enhancement So In-Activating the Trigger.                          
    */

trigger LX_UpdateSTAR on STAR_Comment__c (before insert, after insert) {
if(LX_CommonUtilities.ByPassBusinessRule()) return;
Map <String, String> starCommentSTAR = new Map<String, String> ();
Map <String, String> starCommentCreatedBy = new Map <String, String> ();
Map <String, String> STARstarComment = new Map <String, String> ();

List <STAR__c> starList = new List<STAR__c>();

for (STAR_Comment__c starComm: Trigger.new) {
    if (starComm.Available__c == true) {
        starCommentSTAR.put (starComm.Id, starComm.STAR__c);
        starCommentCreatedBy.put(starComm.Id, starComm.CreatedById); 
        STARstarComment.put (starComm.STAR__c,starComm.Id);   
    }
}

if (starCommentSTAR.size()>0 && Trigger.isAfter){
    for (STAR__c star: [Select Id, Status__c, Assigned_Resource__c from Star__c where Id in: starCommentSTAR.values()] ){
        if (star.Assigned_Resource__c != starCommentCreatedBy.get(STARstarComment.get(star.Id)) && star.Status__c !='Assigned' )
        {
        star.Assigned_Resource__c = starCommentCreatedBy.get(STARstarComment.get(star.Id));
        star.Status__c = 'Assigned';
        starList.add(star);
        }
    }
}
if (starList.size()>0)
update starList ;
}