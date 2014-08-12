/*
 * Class to create Price Books.  Farms out tasks to PriceBookBatchedProcessor.
 * Instantiated from CreatePriceBooks.trigger when a user changes the status of
 * a Price Book Maker record.
 *
 * This class is used for both the SAP and BigMachines exports.
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-10-07
 */
public class CreatePriceBooks 
{
    private Price_Book_Maker__c pbm;
    private Id accountId;
    
    public CreatePriceBooks(ID priceMakerId)
    {
        pbm = [Select Status__c from Price_Book_Maker__c where ID = :priceMakerId];
    }
    
    public CreatePriceBooks(ID priceMakerId, ID accountId)
    {
        this(priceMakerId);
        this.accountId = accountId;
        
        if (accountId != null) {
            // For an account run, find the latest full run (that has core price books) and 
            // add it to the current Price Book Maker's lookup
            List<Price_Book_Maker__c> maker = [
                    Select
                        Id
                    From
                        Price_Book_Maker__c
                    Where
                        Status__c = 'Complete' and
                        Account__c = null];
            if (maker.size() != 1) {
                // issue, we need to have exactly one completed price book maker to proceed
            }
            else {
                pbm.Previous_Price_Book_Maker__c = maker.get(0).Id;
            }
        }
    }
    
    /*
     * Controller method for all tasks related to Price Book creation.
     */
    public void process()
    {
        if (pbm == null) {
            /* this should never happen */
            System.debug('Price Maker was invalid');
            return;
        }
        else {
            System.debug('Beginning process.  Status is '+pbm.Status__c);
        }
        
        if (pbm.Status__c == 'Submitted') {
            /*
            1. Update status to Core - In Progress
            */
            updateStatus('Core - In Progress');
            
            /*
            2. Populate Core Price book with Product records with a 
            status: General Availability. 
            */
            /*
            3. Update status to Core - Complete 
            */
           // PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(pbm.Id, true, 'CreateCorePriceBooks');
           // Database.executeBatch(batch, 90);                                                                       //PRJ001716 jd: changed from 100 to 50
        }
        else if (pbm.Status__c == 'Ready to Publish') {
            /*
            1. Update status to Published - In Progress
            */
            updateStatus('Published - In Progress');
            
            /*
            2. Using records in the Price Book Definition object, populate the 
            Published Price Book by creating a record for each record found in 
            the Core Price Book object that were created by the previous 
            action. For example, if there are 3 records in the Price Book 
            Definition and 10 records in the Core Price Book object, then you 
            should have 30 records in the Published Price Book Object.
            */
            /* 
            3. Update status to Published - Complete
            */
            
            // if no account is set, create all published price books
            if (accountId == null) {            
                //PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(pbm.Id, true, 'CreatePublishedPriceBooks');
                //Database.executeBatch(batch, 90);                                                               //PRJ001716 jd: changed from 100 to 50
                
                /* and now customer specific price books */
                /*PriceBookBatchedProcessor customerBatch = new PriceBookBatchedProcessor(pbm.Id, false, 'CreatePublishedPriceBooks', [
                        Select
                            Id, 
                            Price_Book_Product__c,
                            Price_Book_Product__r.Name,
                            Price_Book_SMSA__c,
                            Price_Book_SMSA__r.Name,
                            Price_Book_VSOE__c,
                            Price_Book_VSOE__r.Name ,
                            Sales_Organization__c,
                            Coverage_ID__r.Sales_Organization__c,
                            Coverage_ID__r.Sales_Organization__r.Sales_Organization__c
                        From 
                            Account 
                        Where 
                            (Price_Book_Product__r.Name != 'Base' and Price_Book_Product__c != null) or 
                            (Price_Book_SMSA__r.Name != 'Base' and Price_Book_SMSA__c != null) or 
                            (Price_Book_VSOE__r.Name != 'Base' and Price_Book_VSOE__c != null)]);
                Database.executeBatch(customerBatch, 90);    */                                          //PRJ001716 jd: changed from 100 to 50
                
               // PriceBookBatchedProcessor archiveBatch = new PriceBookBatchedProcessor(pbm.Id, false, 'CleanupPublishedPriceBooks');
               // Database.executeBatch(archiveBatch, 90);                                                //PRJ001716 jd: changed from 100 to 50
            }
            // otherwise, only the published price books for this account
            else {
                List<Account> accounts = [
                        Select
                            Id, 
                            Price_Book_Product__c,
                            Price_Book_Product__r.Name,
                            Price_Book_SMSA__c,
                            Price_Book_SMSA__r.Name,
                            Price_Book_VSOE__c,
                            Price_Book_VSOE__r.Name,
                            Sales_Organization__c,
                            Coverage_ID__r.Sales_Organization__c,
                            Coverage_ID__r.Sales_Organization__r.Sales_Organization__c
                        From 
                            Account 
                        Where 
                            ((Price_Book_Product__r.Name != 'Base' and Price_Book_Product__c != null) or 
                            (Price_Book_SMSA__r.Name != 'Base' and Price_Book_SMSA__c != null) or 
                            (Price_Book_VSOE__r.Name != 'Base' and Price_Book_VSOE__c != null)) and
                            Id = :accountId];
               // PriceBookBatchedProcessor customerBatch = new PriceBookBatchedProcessor(pbm.Id, true, 'CreatePublishedPriceBooks', accounts);
              //  Database.executeBatch(customerBatch, 90);                                                   //PRJ001716 jd: changed from 100 to 50
                
                // Update other Published Price Books to be Archived
              //  PriceBookBatchedProcessor archiveBatch = new PriceBookBatchedProcessor(pbm.Id, false, 'CleanupPublishedPriceBooks', accounts);
               //Database.executeBatch(archiveBatch, 90);                                                    //PRJ001716 jd: changed from 100 to 50
            }
        }
        else if (pbm.Status__c == 'Published - Complete') {
            /*
            5.  Update all other Price Book Makers with status = Completed to status = Archived
            */
            
            if (accountId == null) {                
                List<Price_Book_Maker__c> makersToUpdate = new List<Price_Book_Maker__c>();
                for (List<Price_Book_Maker__c> priceBookMakers : [
                        Select
                            Id
                        From
                            Price_Book_Maker__c
                        Where
                            Status__c = 'Complete']) {
                    for (Price_Book_Maker__c priceBookMaker : priceBookMakers) {
                        priceBookMaker.Status__c = 'Archived';
                        makersToUpdate.add(priceBookMaker);
                    }
                }
                if (makersToUpdate.size() > 0) {
                    update makersToUpdate;
                }
            }
            else {              
                List<Price_Book_Maker__c> makersToUpdate = [
                        Select
                            Id
                        From
                            Price_Book_Maker__c
                        Where
                            Status__c = 'Complete' and
                            Account__c = :accountId];
                for (Price_Book_Maker__c priceBookMaker : makersToUpdate) {
                    priceBookMaker.Status__c = 'Archived';
                }
                update makersToUpdate;
            }
            /* 
            6. Update status to Complete
            */
            updateStatus('Complete');
        }
        else { // Status is not recognized...
            System.debug('Unrecognized status: '+pbm.Status__c+', exiting prematurely.');
        }
    }

    /*
     * Update the status of the Price Book Maker object so that we can keep the user 
     * aware of what is going on behind the scenes.  Updating status should occur before
     * a code block, after a code block, and in any error state of the code block.
     */    
    private void updateStatus(String newStatus) {
        pbm.Status__c = newStatus;
        if (newStatus == 'Complete') {
            pbm.Complete_Date__c = System.now();
            pbm.Name = 'PB Maker '+DateTime.now().format('yyyy_MM_dd HH:mm');
        }
        
        update pbm;
    }
}