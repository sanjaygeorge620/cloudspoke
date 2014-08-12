/* Class Name   : LX_SubmitRecordToApproval 
    * Description : This class is used to submit Approval process.
    * Created By   : Sumedha K.
    * Created Date : 05-16-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            05-16-2013               1000                Initial Version    
    */

public with sharing class LX_SubmitRecordToApproval {
 
   /*  Description : It accepts a record Id and submits approval process for it.
    *  Param - recId: String  
    *  Returns :  VOID
    */
 public static void approvalID(String recID){
   submitApproval(recID);
 }

    /*  Description : It accepts a record Id and creates approval process for it.
    *  Param - recId: String  
    *  Returns :  VOID
    */
    private static void submitApproval(String recId){
         // Create an Approval Process
            try{
               Approval.ProcessSubmitRequest request= new Approval.ProcessSubmitRequest();
              request.setComments('Submitting record for Approval');
              request.setObjectId(recId);
                        
             //  Submit the record for Approval
             Approval.ProcessResult submitApproval = Approval.process(request);
             }catch(Exception ex){
                System.debug('The approval process could not be initiated'+ex.getMessage());
                LX_CommonUtilities.createExceptionLog(ex);//Exception log ,Kapil Reddy Sama 6/6/13
             }
    
    }
}