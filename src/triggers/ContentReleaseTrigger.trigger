/*
Update Release Field
Created by Mike Fitzgerald
November 2010
*/

trigger ContentReleaseTrigger on ContentVersion (before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code

     
     for(ContentVersion RS: Trigger.new){
            system.debug('ProductRelease__c: '+RS.ProductRelease__c); 
            system.debug('Product_Release__c: '+RS.Product_Release__c);
           
           //Adding error handling to prevent any major issues from occuring when uploading content
           try{ 
                if (RS.Product_Release__c !='0.0.0' && RS.Product_Release__c!=null && RS.Product_Release__c!=''){
                    RS.ProductRelease__c =  PerceptiveUtility.AddToMultiselect(RS.ProductRelease__c, RS.Product_Release__c);    
                    }
            }
           catch(Exception e){
               //Print to Error Log
               ErrorLogUtility.createErrorRecord(e.getMessage(),'ContentReleaseTrigger','Low','Generic');
           }         
         }
}