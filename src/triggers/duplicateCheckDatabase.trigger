/****************************************************************************
Author     :    Appirio Inc.
Create Date:    13 May
Reason     :    Add combination of Database Name and version in a Unique field.
*****************************************************************************/
trigger duplicateCheckDatabase on Database_Master__c (before insert,before Update)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
    for(Database_Master__c d:trigger.New)
        d.Database_and_Version_Combination__c = d.Database__c+'='+d.Database_Version__c;
}