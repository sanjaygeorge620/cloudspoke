public class Order_Products{
     ApexPages.StandardController standardController;
      private order__c currentProject;
    public Order_Products(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.currentProject = (order__c)pcfController.getRecord();

    }
    
        public order__c OrderRec  {
          // TODO: Provide getter/setter.  Getter should return the position using a SOQL statement that references the id.
          get{
            OrderRec = [select opportunity__c from Order__c where id = :ApexPages.currentPage().getParameters().get('id')];
            return OrderRec ;
          }set;
        }
        //pulling in data for the project for activity history
         public Opportunity OppRec{
            get {
                if (OppRec== null) {
                                           
                        OppRec= [SELECT id, 
                           (SELECT ID
                               , PricebookEntry.Product2.Name
                               , Quantity
                               FROM opportunityLineItems WHERE (opportunityID = :orderRec.Opportunity__c))
                        FROM Opportunity
                        WHERE id = :orderRec.Opportunity__c]; 
                        
                        
                        
                }
                return OppRec;     
            }
            set;
         }
      
   
        
         /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
    public OrderItems[] getOrderLineItems() {
        OrderItems[] OrderLineItems= new OrderItems[]{};
         
        /* Task object */
        for (OpportunityLineItem t : OppRec.opportunityLineItems ) { 
                 addItems(OrderLineItems, new OrderItems(t.id, t.PricebookEntry.Product2.Name, t.Quantity, t.PricebookEntry.Product2.Name ) ); 
         }
        return OrderLineItems;
    }
    
    /* This method adds the newHistory object to the given projHistories collection in the appropriate order. 
       The order provided here places the oldest records at the front of the list, i.e. by date ascending. */
    private void addItems(OrderItems[] OrderLineItems, OrderItems newItems) {
        Integer position = OrderLineItems.size();
        for (Integer i = 0; i < OrderLineItems.size(); i++) {
            if (newItems.Quantity > OrderLineItems[i].Quantity) {
                position = i;
                break;
            }
        }
        
        if (position == OrderLineItems.size()) {
            OrderLineItems.add(newItems);
        } else {
            OrderLineItems.add(position, newItems);
        }
    }

}