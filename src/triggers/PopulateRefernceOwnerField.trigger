/**
 * Author : Pruthvi Ayireddy
 * Date: 06/26/2014
 * Description : To handle after trigger activities i.e., update the corresponding Reference Owner field whenever there is an update in the Account Fields.
 */

trigger PopulateRefernceOwnerField on Account (after insert,after update)
{
    // Bypass code
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 
    
    PopulateRefernceOwnerFieldHandler.updateReferenceOwner(trigger.new,trigger.oldMap);
    
}