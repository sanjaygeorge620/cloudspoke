/* Class Name   : LX_EvalProducts_Cntrl
    * Description   : This class is a controller for "LX_EvalProducts" page to override
    *                "New" button on Evaluation Products. It gives a user the ability to add
    *                more than one products at the same time
    * Created By   : Sumedha K.
    * Created Date : 12-06-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            12-06-2013               1000                Initial Version    
    * Sumedha K.            12-12-2013               1001                Added delete and add more buttons logic
    * Sumedha K.            12-12-2013               1002                Moved error messages and Ids to custom labels and commented code
    */
public class LX_EvalProducts_Cntrl{
   // Variable used to store the Master record type id. All the evaluation products created from New button are defaulted to this record type
   // Variable used to store master Evaluation Unit Id.
            public Id evalUnitID = ApexPages.currentPage().getParameters().get(Label.LX_Eval_Unit);
   // List to store the evaluation products to be added
            public List<LX_Evaluation_Product__c> evalProdList{get;set;}
   // Variable used to store the row numbers while adding more than one products
            public String count{get;set;}
   
    /*
     * 
     * Description : This is the constructor. This methods adds a row of evaluation product defaulting the evaluation Unit Id
     * from which the new button on the related list is accessed
     * Param - : The Evaluation ID passed over the URL.
     * Param - : Record Type Id defaulted to Master Record Type
     * Returns :  null
    */
            public LX_EvalProducts_Cntrl(ApexPages.StandardController controller) {
                count = '0';
                evalProdList = new List<LX_Evaluation_Product__c>();
                // when the page is loaded, by default a row of evaluation product with evaluation unit prepopulated is displayed
                evalProdList.add(new LX_Evaluation_Product__c(LX_Seed_Order_Request__c = evalUnitID ));
            }
    
    /*
     * 
     * Description : This action method is called when a user tries to add more than one evaluation product
     * Param - : The Evaluation ID passed over the URL.
     * Param - : Record Type Id defaulted to Master Record Type
     * Returns :  null
    */
                public  Pagereference addMore(){
                   
                    evalProdList.add(new LX_Evaluation_Product__c(LX_Seed_Order_Request__c = evalUnitID ));
                    return null;    
                }
    
    /*
     * 
     * Description : This action method is called when a user saves evaluation products    
     * Throws appropriate error if the insert fails
     * Param - : List of evaluation products
     * Returns : pagereference. It redirects the page to the master evaluation unit
    */
    public Pagereference saveEvalProd(){

       // variable used to store the evaluation products to be inserted
                   List<LX_Evaluation_Product__c> saveList = new List<LX_Evaluation_Product__c>();
                   List<LX_Evaluation_Product__c> unsaveList = new List<LX_Evaluation_Product__c>();
       // checks if the original list displayed has any rows
       if(evalProdList.size()>0){
         for(LX_Evaluation_Product__c eProd : evalProdList){
         // checks if the row to be saved has product and quantity entered
            if(eProd.LX_Product__c != null && eProd.LX_Quantity__c != null){
                saveList.add(eProd);
            }else{
              unsaveList.add(eProd);
            }
         }
       }
       if(unsaveList.size()>0){
         ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'There are records with no products or quantity. Please enter some value');
         ApexPages.addMessage(message);
         return null;
       }
       try{
         system.debug('*********'+evalProdList);
         system.debug('*********'+saveList);

         insert saveList;
         system.debug('*********'+evalProdList);
         Pagereference pg= new Pagereference ('/'+evalUnitID);
       pg.setredirect(true);
       return pg;
       }catch(Exception ex){
       // If the insert fails, appropriate error is displayed on vf page
        // ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_NoEvalProd_Error);
         ApexPages.addMessages(ex);
         System.debug('Cannot insert the evaluation products : '+ex.getMessage());
         return null;
       }
       
    }
   /*
     * 
     * Description : This action method is called when a user removes an evaluation product row    
     * Throws appropriate error if the row fails to get deleted
     * Param - : Index of the row which is to be deleted
     * Param - : List of Evaluation Product
     * Returns : null
    */ 
           public Pagereference delEvalProd(){
               Integer i = integer.valueOf(count);
               try{
               system.debug(evalProdList);
                 if((i-1)>0){
                   evalProdList.remove(i-1);
                            }
                  system.debug(evalProdList);
               }catch(Exception ex){
                   // if an error is encountered while removing a row from the list, the user is intimated about the failure
                   ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_DelEvalProd_Error);
                   ApexPages.addMessage(message);
                  System.debug('Cannot delete the evaluation product : '+ex.getMessage());
               }
               return null;
           }
    
 }