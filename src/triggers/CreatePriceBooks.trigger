/*
 * Upon state change of a Price Book Maker record, begin some more complex business logic
 * regarding Price Book creation.
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-11-10
 */
trigger CreatePriceBooks on Price_Book_Maker__c (after insert, after update)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    for (Price_Book_Maker__c obj : Trigger.new) {
        /* Only execute process() if we're at a beginning state */
        if (new Set<String>{
                    'Submitted', 
                    'Ready to Publish',
                    'Published - Complete'}.contains(obj.Status__c)) {
            // In practice, Account__c will only be set when initiated from an Account
            new CreatePriceBooks(obj.Id, obj.Account__c).process();
        }
    }
}