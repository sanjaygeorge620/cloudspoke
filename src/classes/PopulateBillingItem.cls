global  class PopulateBillingItem {
    
 webService static void createBillingItem(List<Opportunity> opplist,Opportunity parentOpp, pse__Proj__c prj) {       
        createProjBillingItems_DS.parentOpp = parentOpp; 
        createProjBillingItems_DS.Create(opplist, prj);
        
    }
}