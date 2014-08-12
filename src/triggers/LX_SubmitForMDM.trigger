/*
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 08/05/2013
 *
 * Author : Arun thakur(arunsingh6@deloitte.com)
 * 
 * Description : before Insert Trigger to Update Account record MDM fields.
 */

/*
MDM Fields :
Fields Required for MDM :
Required on Lead Record 
Business Name (English)
Street Line 1(English)
Street Line 2(English)
City(English)
Country(English)
Region/State/Province(English)
Postal Code(English)
TOD:
Party Group
Party Type
Party Role
Sales Representative
*/
trigger LX_SubmitForMDM on Account (before Insert)
{
    for(Account ObjAccount:Trigger.New)
    {
        
        ObjAccount.MDM_Status__c='Awaiting MDM';
        ObjAccount.Account_Submitted__c=false;//MDM validation is required 

    }

}