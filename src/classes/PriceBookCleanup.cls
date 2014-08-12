/*
    This batch class delete core and publsiehd price book records related to a price book maker record and delete price book maker reocrd also.
*/
global class PriceBookCleanup implements Database.Batchable<sObject>{
    
    public Id priceBookMakerId;
    public String priceBookType;
    
    public PriceBookCleanup(Id priceBookMakerId, String priceBookType){
        this.priceBookMakerId = priceBookMakerId;
        this.priceBookType = priceBookType; 
    }
    
    /* This method generate query on the basis on price book type */
    public String generateQuery(){
        if(priceBookType == 'DeleteCorePriceBooks'){
            return 'Select '+
                   '    Id '+
                   'From '+
                   '    Core_Price_Book__c '+
                   'Where '+
                   '    Price_Book_Maker_ID__c = \''+priceBookMakerId+'\'';
        }
        if(priceBookType == 'DeletePublishedPriceBooks'){
            return 'Select '+
                   '    Id '+
                   'From '+
                   '    Published_Price_Book__c '+
                   'Where '+
                   '    Price_Book_Maker_ID__c = \''+priceBookMakerId+'\'';
        }else {
            System.debug('Unknown Price Type: '+priceBookType);
            return '';
        }
    }
    /* This method start batch processing */
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = generateQuery();
        return Database.getQueryLocator(query);
    }
    /* This method excute the main functionality on batch. Delete batch records.*/
    global void execute(Database.BatchableContext BC, List<SObject> scope){
        if (priceBookType == 'DeleteCorePriceBooks' && scope instanceof List<Core_Price_Book__c> && scope.size() > 0){
            cleanupObject(scope);
        }else if (priceBookType == 'DeletePublishedPriceBooks' && scope instanceof List<Published_Price_Book__c> && scope.size() > 0){
            cleanupObject(scope);
        }
    }
    
    /* This method finish the batches.*/
    global void finish(Database.BatchableContext BC){
        
        if(priceBookType == 'DeletePublishedPriceBooks'){
            List<Published_Price_Book__c> publishedPriceBooks = [select Id from Published_Price_Book__c where price_Book_Maker_ID__c = : priceBookMakerId limit 10];
            if(publishedPriceBooks.size() == 0){
                Price_Book_Maker__c priceBookMaker = [select Id, Status__c from Price_Book_Maker__c where id =: priceBookMakerId  limit 1];
                if(priceBookMaker != null){
                  	priceBookMaker.Status__c = 'Cleaned Up';
                    update priceBookMaker;
                }
            }   
        }
    }
    
    public void cleanupObject(List<SObject> scope){
    	delete scope;
    	Database.EmptyRecycleBinResult[]  emptyRecycleBinResults = Database.emptyRecycleBin(scope); 
    }

}