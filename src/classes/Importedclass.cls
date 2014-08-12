/* Class Name   : Importedclass
    * Description   : Created a custom button on NA Evaluation Unit Request object and this below class is a javascript reference.
    * Created By    : Bhanu Prakash.
    * Created Date  : 007/03/2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Bhanu Prakash       07/11/2013             1000                   Initial Version.
    * 
*/


global class Importedclass {
        Webservice static string ImportedMethod(String importedid) {
        String var = 'Please check the availability of atleast one PS demo product or Check the Bill to or Ship to if Demotype is equal to standard demo';
            LX_Seed_Order_Request__c lxe = new LX_Seed_Order_Request__c();             
            lxe  = [SELECT Id,LX_Bill_To_Address__c,LX_Form_Submitted__c,LX_Bill_To_City__c,LX_Bill_To_State_Province__c,LX_Bill_To_Postal_Code__c, LX_Bill_To_Country__c,LX_Demo_Type__c,LX_Ship_To_City__c,LX_Ship_To_Address__c,LX_Ship_To_Postal_Code__c,LX_Ship_To_State_Province__c,LX_Ship_To_Country__c,(SELECT Id FROM Evaluation_Products__r) FROM LX_Seed_Order_Request__c WHERE LX_Seed_Order_Request__c.Id = : importedid];               
           system.debug('child products' +lxe.Evaluation_Products__r.size());
            if((lxe.Evaluation_Products__r.size() > 0 && lxe.LX_Ship_To_State_Province__c != null && lxe.LX_Ship_To_City__c != null && lxe.LX_Ship_To_Postal_Code__c != null && lxe.LX_Bill_To_Address__c != null && lxe.LX_Bill_To_City__c != null && lxe.LX_Bill_To_State_Province__c != null && lxe.LX_Bill_To_Postal_Code__c != null && lxe.LX_Bill_To_Country__c != null &&  lxe.LX_Ship_To_Address__c != null && lxe.LX_Ship_To_Country__c != null && lxe.LX_Demo_Type__c == 'Standard Demo')||(lxe.Evaluation_Products__r.size() > 0 && lxe.LX_Demo_Type__c != 'Standard Demo'))
            {            
                lxe.LX_Form_Submitted__c  = true;
                lxe.LX_Demo_Status__c = 'Submitted';
                update lxe;
                approvalProcessRequest(importedid);
                for(LX_Evaluation_Product__c evalProduct :  lxe.Evaluation_Products__r)
                approvalProcessRequest(evalProduct.id);    
                
               return 'Success';
            }
            else 
            {
            return var;
            }
            
        }
        
        Webservice static void approvalProcessRequest(String approvalId)
        {
        // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
    
            req.setObjectId(approvalId);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
         }

    }