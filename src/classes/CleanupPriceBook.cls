/*
    This class call batches for :
    1.) Delete all core price book record related to price book maker.
    2.) Delete all published price book record related to price book maker.
    3.) Delete price book maker record.
    
*/
global  class CleanupPriceBook {
    
    webservice static Boolean deletePriceBookMaker(Id priceBookMakerId){
        Boolean isSuccess = false;
        if(priceBookMakerId != null){
            try{
                
                List<Price_Book_Maker__c> priceBookMakers = [select Id, Status__c from Price_Book_Maker__c where id =: priceBookMakerId  limit 1];
                if(priceBookMakers.size() > 0){
                    priceBookMakers.get(0).status__c = 'Delete in Progress';
                    update priceBookMakers.get(0);
                }
                // delete Core Price Book records
                System.debug('---Process for Core Price Book');
                PriceBookCleanup corePBBatchedProcess = new PriceBookCleanup(priceBookMakerId,'DeleteCorePriceBooks');
                Database.executeBatch(corePBBatchedProcess, 200);
            
                // delete Published Price Book records
                System.debug('---Process for Published Price Book');
                PriceBookCleanup publishedPBBatchedProcess = new PriceBookCleanup(priceBookMakerId,'DeletePublishedPriceBooks');
                Database.executeBatch(publishedPBBatchedProcess,200);
                isSuccess = true;
            }catch(Exception ex){
                System.debug('--Exception---'+ex.getMessage());
            }
            
        } 
        return isSuccess;
    }
}