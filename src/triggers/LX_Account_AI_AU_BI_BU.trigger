/* Trigger Name  : LX_Account_AI_AU_BI_BU
 * Description   : This is a trigger that checks if the Country Code of the account get populated or changed then sales org on the opportunity which havent been populated would be populated.
 * Created By    : Sanjay George(Deloitte)
 * Created Date  : 07-08-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Sanjay George        07-08-2013                       Initial Version
 * Srinivas Pinnamaneni 07-22-2013                       Migrated to QA
 * Sanjay George        08-20-2013
 */

trigger LX_Account_AI_AU_BI_BU on Account (after insert, after update, Before Insert , Before Update) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    
    // Global rating fields
    map<id,List<String>> OppidRating = new map<id,List<String>>();
    
    //Declaring variables to get the accounts which is updated and their corresponding opportunity
    list<Opportunity> oppToBeUpdate = new list<Opportunity>();
    list<id>    accountIdToBeUpdate = new list<id>();    
    
    if(Trigger.isUpdate && Trigger.isBefore)
    {
        LX_AccountTriggerUtils.updatedBillingAddress(trigger.new,trigger.oldMap);
    }
    
    //Technically an opportunity can be added only after an account is created hence setting the 
    //This trigger is to only isUpdate
    if(Trigger.IsAfter){
        for(Account acc:trigger.new){
          if(Trigger.IsInsert){
              LX_Lead_util.CreatedAccountIDSet.add(acc.id);
              system.debug('------>'+acc.DunsNumber+ acc.Lead_Conversion_ID__c);
              
          }
          if(trigger.isUpdate){
            //Check if the country code is not blank and has changed
            if((acc.LX_Country_Code__c != null)&&
                (acc.LX_Country_Code__c.trim()!= '')&&
                (acc.LX_Country_Code__c != trigger.oldMap.get(acc.id).LX_Country_Code__c)){
                // to be updated in MDM
                    accountIdToBeUpdate.add(acc.id);    
            }
          }
        }
        if(accountIdToBeUpdate.size() > 0&&trigger.isUpdate){
            
            //Query for the opportunity which is has the account and doesnot have any sales org attached to the opp     
            oppToBeUpdate = [select id,OwnerId,AccountID from Opportunity 
                                        where AccountID =:accountIdToBeUpdate
                                        and Sales_Organization__c = null];
                                        
            if(oppToBeUpdate.size() > 0){   
                // Updating Oppotunities related to Account                    
                LX_UpdateOpportunitrySalesOrg.updateOpportunity(oppToBeUpdate);
            }        
        }       
    }
 
    
    
    
    // All before Operations are happening
    if(Trigger.IsBefore){   
        OppidRating =LX_AccountTriggerUtils.RatingCalc(Trigger.new);
        //update Primary Iss Segment value based in Party Type from custom setting
        LX_AccountTriggerUtils.updatedPrimaryISSSegment(Trigger.new);
        for(account acc: Trigger.new){
        // Added by Sumedha on 9/12 
        if(Trigger.isInsert && (acc.Customer_is_USING_third_party_supplies__c == false && acc.LX_Account_using_Third_party_parts__c == false)){
         acc.LX_Uses_Third_Party_Parts_StatusDate__c = NULL;
         acc.LX_Uses_Third_Party_Supplies_StatusDate__c = NULL;
         acc.LX_Selling_ThirdPartySupplies_StatusDate__c = NULL;
         acc.LX_Selling_Third_Party_Parts_Status_Date__c = NULL;
        }
        if(acc.LX_Lead_DUNS_Number__c!=null&&Trigger.isBefore){
            acc.DunsNumber =acc.LX_Lead_DUNS_Number__c ;
                  
        }
            Account OldAccount;
            if(Trigger.oldMap != null)
                OldAccount=Trigger.oldMap.get(acc.Id);
        
            if(OldAccount!=null){           
                if(OldAccount.LX_Is_Contact_Opt_Status__c!=acc.LX_Is_Contact_Opt_Status__c)
                    if(acc.LX_Is_Contact_Opt_Status__c!=true)
                        acc.LX_Is_Contact_Opt_Status__c=false;
           
            }
        

            //acc.BillingCountry = acc.Physical_Country__c!=null?acc.Physical_Country__c:'';
            // Global and Local Rating
            system.debug('Rating:'+ OppidRating.get(acc.id)[0]+'Local Rating:'+OppidRating.get(acc.id)[1]
            );
            acc.Rating =OppidRating.get(acc.id)[0];
            acc.Country_Account_Rating__c=OppidRating.get(acc.id)[1];
        }
    }
}