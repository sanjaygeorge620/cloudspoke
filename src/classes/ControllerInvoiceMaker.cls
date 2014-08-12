/************************************************************
 * Controller extension for the Invoice Maker page.
 * 
 * This page allows the user to view released billing events
 * that are ready to be invoiced.  The user can then select
 * event batches and create an invoice.
 * 
 * The invoice creation creates an xml request for Intacct,
 * and then posts this request.  Intacct's response is then parsed
 * for error checking.
 * 
 * Once the items are invoiced, the billing events are updated
 * with invoiced = true.
 * 
 * Eric Sexton
 * 
 * 
 * 
 * 
 ************************************************************/


public with sharing class ControllerInvoiceMaker {

    /******************************************
     *  Properties
     * 
     ******************************************/
    public List<batchClass> batchList { get; set; }
    
    public String selectedBatchId { get; set; }
    public String selectedEventId { get; set; }
    
    // Options
    public Boolean useApprove { get; set; }
    public Boolean updateInvoiced   { get; set; }
    
    private Boolean Testing_Mode;
    
    /******************************************
     *  Constructor
     * 
     ******************************************/
    public ControllerInvoiceMaker(ApexPages.StandardController stdController) {
        useApprove      = true;
        updateInvoiced  = true;
        
        batchList       = new List<batchClass>();
        selectedBatchId = '';
        selectedEventId = '';
        
        this.Testing_Mode = false;
        
        //retrieveBatches();

    }
    
    public void retrieveBatches() {
        retrieveBatches(Testing_Mode);
    }
    public void retrieveBatches(Boolean testingmode) {
        // Retrieves batches that contain Released and Authorized events
        // Note that only the released and authorized events will appear under these
        // batches.  This may be awkward, as the same batch can have released and un-released events.
        // If this occurs, the summary totals will be in-accurate.
        
        Integer limitnumber = 1000;
        Testing_Mode = testingmode;
        if ( testingmode == true ) {  limitnumber = 10; }
        
        batchList.clear();

        Set<ID> batchesWithReleasedEvents = new Set<ID>();
        
        for ( pse__Billing_Event__c e : 
                [ SELECT pse__Billing_Event_Batch__c 
                  FROM pse__Billing_Event__c
                  WHERE pse__Is_Released__c = true
                  and   ( pse__Is_Approved__c = :useApprove or pse__Is_Approved__c = true )
                  and   pse__Invoiced__c = false
                  LIMIT :limitnumber
                ] ) {
            
            batchesWithReleasedEvents.add(e.pse__Billing_Event_Batch__c);
        }
        

        
        for ( pse__Billing_Event_Batch__c b : 
            [ SELECT ID, Name, pse__Account__r.Name, pse__Time_Period__r.Name, pse__Summary_Amount__c, CreatedDate,
                     pse__Group__c, pse__Practice__c, pse__Region__c
              FROM pse__Billing_Event_Batch__c 
              WHERE ID in :batchesWithReleasedEvents
              ORDER BY Name
            ] ) {
            
                batchClass x = new batchClass();
                x.Data = b;
                x.useApprove = useApprove;
                batchList.add(x);
        }

    }

    //  Wish I could do it this way ...
    
    /**public void alternateLoad() {
        for ( pse__Billing_Event_Batch__c b : 
            [ SELECT 
                b.ID, b.Name, b.pse__Account__r.Name, b.pse__Time_Period__r.Name, b.pse__Summary_Amount__c, b.CreatedDate,
                e.ID, e.Name, e.pse__project__c, e.pse__Date__c, e.pse__Summary_Amount__c, e.pse__Is_Released__c,
                i.id, i.Name, i.pse__Date__c, i.pse__Object_Id__c, i.pse__Quantity__c, 
                      i.pse__Description__c, i.pse__Category__c, i.pse__Amount__c, i.pse__Unit_Price__c
              FROM
                pse__Billing_Event_Batch__c b
                INNER JOIN
                pse__Billing_Event__c e
                ON b.id = e.pse__Billing_Event_Batch__c
                INNER JOIN
                pse__Billing_Event_Item__c i
                ON e.id = i.pse__Billing_Event__c
              
              ]) {
            
            batchList.add(b);
        }
            
    }**/
    
    /******************************************
     *  Action methods from buttons
     * 
     ******************************************/
    public void invoice() {
        List<pse__Billing_Event__c> eventsToInvoice = new List<pse__Billing_Event__c>();        
        
        for (batchClass b : batchList ) {
            if ( b.selected == true ) {
                b.expand();     // loads events
                for ( eventClass e : b.events ) {
                    e.expand();  // loads items
                    eventsToInvoice.add(e.Data);
                }
            }
            else { // if user selected individual events ...
                for ( eventClass e : b.events ) {
                    if ( e.selected == true ) {
                        e.expand(); // loads items
                        eventsToInvoice.add(e.Data);
                    }
                }
            }
        }
        
        for ( pse__Billing_Event__c event : eventsToInvoice ) {
            
        /* *** REPLACE WITH SOFTRAX INTEGRATION PROCESS -S.Clune 11/17/2009 ***
            PSE2Intacct.IntacctResponseClass IntacctResponse = PSE2Intacct.invoiceEvents( event );

            if ( IntacctResponse.status != 'success' ) {
                ApexPages.Message myErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Problem with invoicing event ' + event.Name + ' : ' + IntacctResponse.description);
                ApexPages.addMessage(myErrorMsg);
            }
            else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Invoiced event ' + event.Name + ' : Sales Invoice = ' + IntacctResponse.key);
                ApexPages.addMessage(myMsg);
                
                event.pse__Invoice_Number__c = IntacctResponse.key;
                event.pse__Invoiced__c = true; 
                
            }
        ****** */   
        }
        
        if ( updateInvoiced ) {
            try {
                update eventsToInvoice;
            }
            catch (Exception ex ) {
                ApexPages.Message myErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Problem updating Billing Events: ' + ex );
                ApexPages.addMessage(myErrorMsg);
            }
        }
        
        
        retrieveBatches();  // refreshes list for the page

    }
    

    
    /******************************************
     *  Action methods from buttons  -- unrelease
     *  Sends the batch/event back to Bill Generation pages
     ******************************************/    
    public void unrelease() {
        List<pse__Billing_Event__c> eventsToRelease = new List<pse__Billing_Event__c>();
        
        for (batchClass b : batchList ) {
            if ( b.selected == true ) {
                b.expand();
                for ( eventClass e : b.events ) {
                    eventsToRelease.add(e.Data);
                }
            }
            else { // if user selected individual events ...
                for ( eventClass e : b.events) {
                    if ( e.selected == true ) {
                        e.expand();
                        eventsToRelease.add(e.Data);
                    }
                }
            }
        }       
        for ( pse__Billing_Event__c e : eventsToRelease ) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Un-Releasing event '  + e.Name);
            ApexPages.addMessage(myMsg);
            e.pse__Is_Released__c = false;
            e.pse__Is_Approved__c = false;
        }
        update eventsToRelease;
        retrieveBatches();  // refreshes everything
    }
    public void recalc() { 
        
    }

    /******************************************
     *  Action methods from the expand/collapse buttons
     * 
     ******************************************/    
    public void expandBatch() {
        for ( integer i = 0; i < batchList.size(); i++ ) {
            if ( batchList[i].Data.id == selectedBatchId ) {
                batchList[i].expand();
                break;
            }
        }
    }
    public void collapseBatch() {
        for ( integer i = 0; i < batchList.size(); i++ ) {
            if ( batchList[i].Data.id == selectedBatchId ) {
                batchList[i].collapse();
                break;
            }
        }
    }
    
    public void expandEvent() {
        for ( integer i = 0; i < batchList.size(); i++ ) {
            if ( batchList[i].Data.id == selectedBatchId ) {
                batchList[i].expandMyEvent(selectedEventId);
                break;
            }
        }       
    }
    
    public void collapseEvent() {
        for ( integer i = 0; i < batchList.size(); i++ ) {
            if ( batchList[i].Data.id == selectedBatchId ) {
                batchList[i].collapseMyEvent(selectedEventId);
                break;
            }
        }   
    }
    


    /******************************************
     *  Internal classes
     * 
     ******************************************/

    
    
    /******************************************
     *  Internal batch class
     * 
     ******************************************/
    public class batchClass {
        public boolean expanded { get; set; }
        public boolean selected { get; set; }
        public pse__Billing_Event_Batch__c Data { get; set; }
        public List<eventClass> events { get; set; }
        public Boolean useApprove { get; set; }
        
        public batchClass() {
            this.useApprove = true;
            this.expanded = false;
            this.selected = false;
            this.Data = new pse__Billing_Event_Batch__c();
            this.events = new List<eventClass>();
        }
        public String getname() { return this.Data.Name; }
        public String getamountAsString() { return this.Data.pse__Summary_Amount__c.format(); }
                
        public void expand( ) {
            if ( this.Data.id != null ) { 
                    this.events = retrieveEvents(this.Data.id);
            }
            this.expanded = true;
        }
        public void collapse() {
            this.expanded = false;
        }
        
        private List<eventClass> retrieveEvents(ID batchID ) {

            List<eventClass> events = new List<eventClass>();
            for ( pse__Billing_Event__c e : 
                    [ SELECT Id, Name, pse__project__c, pse__Date__c, pse__Summary_Amount__c, pse__Is_Released__c,
                        pse__Status__c, pse__Is_Approved__c, pse__Invoiced__c, pse__Invoice_Number__c, 
                        pse__Invoice_Date__c, pse__Budget_Remaining__c, pse__Billing_Event_Batch__c, pse__Billing_Contact__c, 
                        pse__Approver__c, OwnerId, CurrencyIsoCode, pse__Project__r.Name, 
                        pse__Billing_Event_Batch__r.pse__Account__c, 
                        //pse__Billing_Event_Batch__r.pse__Account__r.IntacctID__c,
                        pse__Billing_Event_Batch__r.pse__Account__r.Name,
                        //pse__Project__r.pse__Opportunity__r.Location__c,
                        pse__Project__r.pse__Opportunity__r.Owner.Name,
                        pse__Project__r.pse__Opportunity__c,
                        //pse__Project__r.project_id__c,
                        pse__Project__r.pse__project_id__c,
                        //pse__Project__r.pid__c,
                        ( SELECT 
                                ID, Name, pse__Date__c, pse__Object_Id__c, pse__Quantity__c, 
                                 pse__Description__c, pse__Category__c, pse__Amount__c, pse__Unit_Price__c,
                                 pse__Project__c,  pse__Project__r.Name, pse__Billing_Event__c, OwnerId
                          From pse__Billing_Event_Items__r 
                          ORDER BY pse__Date__c, pse__Description__c )
                      FROM pse__Billing_Event__c 
                      WHERE pse__Billing_Event_Batch__c = :batchId 
                      and  pse__Is_Released__c = true
                      and  ( pse__Is_Approved__c = :useApprove or pse__Is_Approved__c = true ) 
                      and  pse__Invoiced__c = false
                      ORDER BY Name
                      LIMIT 1000 
                  ]) {
                eventClass x = new eventClass();
                x.Data = e;
                events.add(x);
            }
            return events;
        }
        
        public void expandMyEvent(ID eventID) {
            for ( integer i = 0; i < this.events.size(); i++ ) {
                if ( this.events[i].Data.id == eventID ) {
                    this.events[i].expand();
                }
            }
        }
        public void collapseMyEvent(ID eventID) {
            for ( integer i = 0; i < this.events.size(); i++ ) {
                if ( this.events[i].Data.id == eventID ) {
                    this.events[i].collapse();
                }
            }   
        }
    }
    
    /******************************************
     *  Internal event class
     * 
     ******************************************/
    
    public class eventClass {
        public boolean expanded { get; set; }
        public boolean selected { get; set; }
        public boolean RecalcEnabled { get; set; }
        public pse__Billing_Event__c Data { get; set; } 
        public List<itemClass> items { get; set; }
        
        public eventClass() {
            this.expanded = false;
            this.selected = false;
            this.RecalcEnabled  = false;
            this.Data = new pse__Billing_Event__c();
            this.items = new List<itemClass>();
        }
        
        public String getname() { return this.Data.Name; }
        public String getamountAsString() { return this.Data.pse__Summary_Amount__c.format(); }
        
        public void expand( ) {
            if ( this.Data.id != null  ) {
                    this.items = retrieveItems(this.Data.id);
            }
            this.expanded = true;
        }
        public void collapse() {
            this.expanded = false;
        }
        
        private List<itemClass> retrieveItems(ID eventID) {
            List<itemClass> items = new List<itemClass>();
            for ( pse__Billing_Event_Item__c i : this.Data.pse__Billing_Event_Items__r ) {
                itemClass x = new itemClass();
                x.Data = i;
                items.add(x);
            }
            return items;
        }
        
    }
    
    /******************************************
     *  Internal item class
     * 
     ******************************************/
    
    public class itemClass {
        public boolean expanded { get; set; }
        public boolean selected { get; set; }
        public pse__Billing_Event_Item__c Data { get; set; }

        public itemClass() {
            this.expanded = false;
            this.selected = false;
            this.Data = new pse__Billing_Event_Item__c();

        }
        
        public String getname() { return this.Data.Name; }
        public String getamountAsString() { return this.Data.pse__Amount__c.format(); }
        public String getunitPriceAsString() { return this.Data.pse__Unit_Price__c.format(); }
        

    }

}