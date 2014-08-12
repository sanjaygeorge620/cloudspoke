trigger InvoiceMaker on Invoice_Maker__c (after insert, after update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
    Map<Id,Invoice_Maker__c> invoiceMakerMap_PS =  new Map<Id,Invoice_Maker__c>();
    Map<Id,Invoice_Maker__c> invoiceMakerMap_ISS =  new Map<Id,Invoice_Maker__c>();    
    Map<Id,Invoice_Maker__c> invoiceMakerMap_DS =  new Map<Id,Invoice_Maker__c>();
    Map<Id,Invoice_Maker__c> invoiceMakerMap_MSU =  new Map<Id,Invoice_Maker__c>();
    
    string PrRTId = ProjectRecordType__c.getValues('Professional Services').Record_Type_ID__c;
    
     
    if(Trigger.isInsert){
        for(Invoice_Maker__c im : Trigger.New)
        {
            if(im.status__c != null && im.status__c.equals('Ready-For-Pickup') && 
            im.Time_Period__c != null && im.Record_Types__c == 'Professional Services')
            {
                //im.Status__c = 'In-Process';
                invoiceMakerMap_PS.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
                if(im.status__c != null && im.status__c.equals('Ready-For-Pickup') && 
            im.Time_Period__c != null && im.Record_Types__c == 'ISS Implementation Project')
            {
                //im.Status__c = 'In-Process';
                invoiceMakerMap_ISS.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
            
            //-------------------------DATABASE SERVICES--------------------------
            system.debug('In the loop2');
            if(im.status__c != null && im.status__c.equals('Ready-For-Pickup') && 
            im.Time_Period__c != null && im.Record_Types__c == 'Database Services')
            {
                //im.Status__c = 'In-Process';
                system.debug('In the loop');
                invoiceMakerMap_DS.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
            
            //--------------------------------------Managed Services----------------------------------
            
            if(im.status__c != null && im.status__c.equals('Ready-For-Pickup') && 
            im.Time_Period__c != null && im.Record_Types__c == 'Managed Services')
            {
                //im.Status__c = 'In-Process';
                system.debug('In the loop');
                invoiceMakerMap_MSU.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
            
            
        }
    }
    if(Trigger.isUpdate)
    {
        for(Invoice_Maker__c im : Trigger.New)
        {
            if(im.status__c != null && im.Status__c != Trigger.oldMap.get(im.id).Status__c &&
             im.status__c.equals('Ready-For-Pickup') && im.Time_Period_End_Date__c != null &&
             im.Time_Period_Start_Date__c != null && 
             im.Record_Types__c == 'Professional Services')
            {
                //im.Status__c = 'In-Process';
                invoiceMakerMap_PS.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
           if(im.status__c != null && im.Status__c != Trigger.oldMap.get(im.id).Status__c &&
             im.status__c.equals('Ready-For-Pickup') && im.Time_Period_End_Date__c != null &&
             im.Time_Period_Start_Date__c != null && 
             im.Record_Types__c == 'ISS Implementation Project')
            {
                //im.Status__c = 'In-Process';
                invoiceMakerMap_PS.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
            
            //-----------------------------Database Services----------------------
            
            if(im.status__c != null && im.Status__c != Trigger.oldMap.get(im.id).Status__c &&
             im.status__c.equals('Ready-For-Pickup') && im.Time_Period_End_Date__c != null &&
             im.Time_Period_Start_Date__c != null && 
            im.Record_Types__c == 'Database Services')
            {
                //im.Status__c = 'In-Process';
                invoiceMakerMap_DS.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
            
          //-----------------------------------------Managed Services-------------------------
          
            if(im.status__c != null && im.Status__c != Trigger.oldMap.get(im.id).Status__c &&
             im.status__c.equals('Ready-For-Pickup') && im.Time_Period_End_Date__c != null &&
             im.Time_Period_Start_Date__c != null && 
            im.Record_Types__c == 'Managed Services')
            {
                //im.Status__c = 'In-Process';
                invoiceMakerMap_MSU.put(im.id,new Invoice_Maker__c(id = im.id,Status__c = 'In-Process'));
            }
            
            
        }   
    }
    if(invoiceMakerMap_PS.size() > 0)
    {
        update invoiceMakerMap_PS.values();
        InvoiceMaker.excute(invoiceMakerMap_PS.keySet(),'Professional Services');
        InvoiceMaker_NoContract.excute(invoiceMakerMap_PS.keySet(),'Professional Services');
        InvoiceMaker_Intl.excute(invoiceMakerMap_PS.keySet(),'Professional Services');
        InvoiceMaker_Intl_NoContract.excute(invoiceMakerMap_PS.keySet(),'Professional Services');
    }
    if(invoiceMakerMap_ISS.size() > 0)
    {
        update invoiceMakerMap_ISS.values();
        InvoiceMaker.excute(invoiceMakerMap_ISS.keySet(),'ISS Implementation Project');
        InvoiceMaker_NoContract.excute(invoiceMakerMap_ISS.keySet(),'ISS Implementation Project');
        InvoiceMaker_Intl.excute(invoiceMakerMap_ISS.keySet(),'ISS Implementation Project');
        InvoiceMaker_Intl_NoContract.excute(invoiceMakerMap_ISS.keySet(),'ISS Implementation Project');
    }
    
    
    if(invoicemakermap_DS.size()>0)
    {
    update invoiceMakerMap_DS.values();
    system.debug('IDs in trigger'+invoiceMakerMap_DS.keySet());
    InvoiceMaker_DS.excute(invoiceMakerMap_DS.keySet());
    }
    if(invoicemakermap_MSU.size()>0)
    {
    update invoiceMakerMap_MSU.values();
    system.debug('IDs in trigger'+invoiceMakerMap_MSU.keySet());
    InvoiceMaker_MS.excute(invoiceMakerMap_MSU.keySet());
    }
    
}