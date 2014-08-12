public class LX_SAP_Record_Extension {
    private final LX_SAP_Record__c oSR;
    private String sSoldTo;
   
    public LX_SAP_Record_Extension(ApexPages.StandardController stdcontroller) {
     // oSR = (LX_SAP_Record__c)stdController.getRecord();
    
      //List <LX_SAP_Record__c> listSR = new List<LX_SAP_Record__c>([Select LX_Sold_To__c from LX_SAP_Record__c where id = :oSR.Id]);
        sSoldTo = ApexPages.currentPage().getParameters().get('LX_Sold_To__c');
        sSoldTo='a66e000000000JI';
    }
  //Our collection of the class/wrapper objects cContact 
    public List<LX_Sales_Organization_Wrapper> listSOrg {get; set;}

    //This method uses a simple SOQL query to return a List of 
    
    public List<LX_Sales_Organization_Wrapper> getSalesOrg() {
        if(listSOrg == null) {
           Map<id,LX_SAP_Record_Sales_Org__c> mapSoldSalesOrg = new Map<id,LX_SAP_Record_Sales_Org__c>([Select LX_Sales_Organization__c from LX_SAP_Record_Sales_Org__c where LX_SAP_Record__c='a66e000000000JI' ]);
            //List<LX_SAP_Record_Sales_Org__c> listSoldSalesOrg = new List<LX_SAP_Record_Sales_Org__c>([Select LX_Sales_Organization__c from LX_SAP_Record_Sales_Org__c where LX_SAP_Record__c=:sSoldTo ]);
            Set<Id> SetSoldSalesOrg = mapSoldSalesOrg.keySet() ;
           // SetSoldSalesOrg.addAll(listSoldSalesOrg);
            listSOrg = new List<LX_Sales_Organization_Wrapper>();
            for(Sales_Organization__c record: [select Id, Name from Sales_Organization__c where id in ('a27e000000004yo') Limit 10 ]) {
                // As each contact is processed we create a new cContact object and add it to the contactList
                listSOrg.add(new LX_Sales_Organization_Wrapper(record));
            }
        }
        return listSOrg;
    }


    public PageReference processSelected() {

                //We create a new list of Contacts that we be populated only with Contacts if they are selected
        List<Sales_Organization__c> listSelectedOrg = new List<Sales_Organization__c>();

        //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
        for(LX_Sales_Organization_Wrapper record: getSalesOrg()) {
            if(record.selected == true) {
                listSelectedOrg.add(record.oSalesOrg);
            }
        }

        // Now we have our list of selected contacts and can perform any type of logic we want, sending emails, updating a field on the Contact, etc
        System.debug('These are the selected Contacts...');
        for(Sales_Organization__c record: listSelectedOrg) {
            system.debug(record);
        }
        listSOrg=null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
        return null;
    }


    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class LX_Sales_Organization_Wrapper  {
        public Sales_Organization__c oSalesOrg{get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public LX_Sales_Organization_Wrapper(Sales_Organization__c oSOrg) {
            oSalesOrg =  oSOrg;
            selected = false;
        }
    }
}