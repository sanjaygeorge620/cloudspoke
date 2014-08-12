public without sharing class DataDotComServices {
        private class DataDotComException extends Exception{}
                                                            //contactid or companyid, 0=contact 1=company, i.e. Lead Creation*/
        //EXAMPLE SIGNATURE: DataDotComServices.purchaseRecord(companyid,1,'Lead Creation');
        public static boolean purchaseRecord(String datadotcom_id , string DatacloudEntityType, string PurchaseReason) {
           try{
                System.debug('Entered purchaseId() ' + datadotcom_id + ' ' + DatacloudEntityType + ' ' + PurchaseReason);
                if(isOwned(datadotcom_id))
                    return true;
                    
                DatacloudPurchaseUsage pu = new DatacloudPurchaseUsage(DatacloudEntityType=DatacloudEntityType, Description=PurchaseReason);
                insert pu;
                
                String puID = pu.ID;
                if (puID == null || puID == '') {
                    throw new DataDotComException('Unsuccessful Purchase. Purchase ID returned: '+ puID);
                }
                
                DatacloudOwnedEntity oe = new DatacloudOwnedEntity(PurchaseUsageId=puID, DataDotComKey=datadotcom_id, DatacloudEntityType=DatacloudEntityType);
                insert oe;
                
                String oeID = oe.ID;
                if (oeID == null || oeID == '') {
                    throw new DataDotComException('Unsuccessful Purchase. Owned ID returned: ' + oe.ID);
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'Successfully Purchased Record'));
                return true; 
                
           }catch(dmlException e){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDMLmessage(0)));
               return false; 
           }catch(exception e){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getmessage() + ' #' + e.getLineNumber()));
               return false; 
           }     
        }
        
        
        public static boolean isOwned(string datakey){
            List<DatacloudOwnedEntity> OwnedRecords = [SELECT 
                                                             Id, 
                                                             DataDotComKey
                                                             FROM DatacloudOwnedEntity 
                                                        WHERE DataDotComKey = :datakey /*AND UserId = :UserInfo.getUserId()*/ LIMIT 1];
            if(OwnedRecords.size()>0)
                return true;
            else
                return false;
        }
        
}