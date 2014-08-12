/**
 * Author : Pruthvi Ayireddy
 * Date: 07/01/2014
 * Description : To handle after trigger activities i.e., update the corresponding Managed Reference Account field whenever there is an update in the Reference Profile Field.
 */

trigger UpdateManagedReferenceAccount on refedge__Reference_Basic_Information__c (after insert,after update) {
    
    // Bypass code
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    
    UpdateManagedReferenceAccount_Handler.updateReferenceAccount(trigger.new,trigger.oldMap,trigger.isInsert);
    
    //UpdateManagedReferenceAccount_Handler.populateReferenceAccount(trigger.new,trigger.oldMap,trigger.isInsert);
}