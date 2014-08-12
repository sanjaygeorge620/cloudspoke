//Requested by Jonathon Ward 
//Prevent Opportunity Deletion
//19FEB2014
trigger LX_Opportunity_BD on Opportunity (before delete) {

    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 19-Feb-14] : Added Bypass code
    
    boolean DeleteAccess = LX_UserAccess__c.getInstance(userinfo.getuserid()).Opportunity_Deletion__c;
    //Prevent unauthorized users from deleting Opportunities
    for(Opportunity r: trigger.old){
         if(!DeleteAccess) 
             r.adderror('Insufficient Delete Permissions');
    }
}