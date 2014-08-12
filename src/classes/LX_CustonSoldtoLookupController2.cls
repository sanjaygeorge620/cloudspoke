public with sharing class LX_CustonSoldtoLookupController2 {

     /* Class Name : LX_CustonSoldtoLookupController2 
    * Description  : To Add/Submit request for sold to.
    * Created By   : Sumedha
    * Created Date : 06-12-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha          06-12-2013                                           Initial Version
    
    */

  // Variable to store the typeOfRecord that we have to perform the search on.      
  private string typeOfRecord   = ApexPages.currentPage().getParameters().get('type');
  // Variable to store the AccountID for the opportunity.
  private string accountId      = ApexPages.currentPage().getParameters().get('accountId');
  // Variable to store the Opportunity ID for the opportunity.  
  private string oppId          = ApexPages.currentPage().getParameters().get('oppId');
  // Variable to store the initialQuery String;
  private string query          = '';
  // Variable to store the condition for the query.
  private string condition      = '';  
    // Variable that checks if the page can be loaded correctly or not.
  public Boolean isError{get;set;}
  public LX_SAP_Record_Sales_Org__c sapSoldTo {get; set;}
  private String sortDirection = 'ASC';
  private String sortExp = 'name';
  public String search {get; set;}
  public Boolean searchBoolean; 
  public LX_CustonSoldtoLookupController2(){
    
    isError = false;
    searchBoolean = FALSE;
    //Check on the type of the RecordType and then construct the query.
        if(typeOfRecord == 'SOLD'){
            query = 'select id, Name, LX_Sold_To__r.Name, LX_Sold_To__r.LX_Payment_Terms__c, LX_Sold_To__r.LX_Currency__c, LX_Sales_Org1__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Sold_To_Sales_Org\' ';
        }else if (typeOfRecord == 'BILL'){
            query = 'select id, LX_Bill_To__r.Name, LX_Bill_To__r.LX_Contact_First_Name__c , LX_Bill_To__r.LX_Contact_Last_Name__c, LX_Bill_To__r.LX_Physical_Street_Address__c, LX_Bill_To__r.LX_Physical_City__c, LX_Bill_To__r.LX_Physical_Province__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Bill_To_Sales_Org\' ';
        }else if(typeOfRecord == 'SELL'){
            query = 'select id, LX_Ship_To__r.Name,LX_Ship_To__r.LX_Contact_First_Name__c ,LX_Ship_To__r.LX_Contact_Last_Name__c, LX_Ship_To__r.LX_Physical_Street_Address__c,LX_Ship_To__r.LX_Physical_City__c,LX_Ship_To__r.LX_Physical_Province__c from LX_SAP_Record_Sales_Org__c where RecordType.DeveloperName = \'LX_Ship_To_Sales_Org\'';
        }
    viewSoldToData();
  
  }
  
      // To sort the column 
      public String sortExpression
       {
         get
         {
            return sortExp;
         }
         set
         {
           //if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           else
             sortDirection = 'ASC';
           sortExp = value;
         }
       }
    
     public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
     public void setSortDirection(String sortDir)
     {  
       sortDirection = sortDir;
     }
     
   
  
  //List of Wrapper to hold the record values onto the page.
  private list<customSoldToWrapper> resultList = new list<customSoldToWrapper>();
  
  
   /* Description : Gets the result set
    *  Param - None
    *  Returns :  list<customSoldToWrapper> : Wrapper Class which stores results
    */
  public list<customSoldToWrapper> getresultList(){
    return this.resultList;
  }
  
  /* Description : Gets the records based on the user entered filter criteria
    *  Param - None
    *  Returns :  PageReference
  */
  public PageReference viewSoldToData() {
      
      String NullLast = 'NULLS LAST';
      string sortFullExp = '';
      if(searchBoolean){
        query = query + 'AND (LX_Sold_To__r.Name LIKE \'%' + search + '%\' OR LX_Sold_To__r.LX_Payment_Terms__c LIKE \'%' + search + '%\' OR LX_Sold_To__r.LX_Currency__c LIKE \'%' + search + '%\' OR LX_Sales_Org1__c LIKE \'%' + search + '%\')';
      }
       //build the full sort expression
       if(sortDirection == 'ASC')
           sortFullExp = sortExpression  + ' ' + sortDirection;
         // sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + NullLast;
       else
          sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + NullLast;
      
    
    //query the database based on the sort expression
    list<LX_SAP_Record_Sales_Org__c> SoldTo= Database.query(query + ' order by ' + sortFullExp + '');
      
    //List<LX_SAP_Record_Sales_Org__c> SoldTo= Database.query('SELECT id,Name, LX_Sold_To__r.Name, LX_Sold_To__r.LX_Payment_Terms__c, LX_Sold_To__r.LX_Currency__c,LX_Sales_Org1__c  FROM LX_SAP_Record_Sales_Org__c order by ' + sortFullExp + '');
    resultList.clear();
    for(LX_SAP_Record_Sales_Org__c org :SoldTo){
        resultList.add(new customSoldToWrapper(org));
    }
    searchBoolean = TRUE;
    return null;
  
   }
   
    /* Description : Sets the boolean variable values and calls viewSoldToData method.
    *  Param - None
    *  Returns :  PageReference
    */
   public Pagereference go(){
    searchBoolean = TRUE;
    viewSoldToData();
    return null;
   }
 
  /* 
  Description : Wrapper class to hold the SAP Record Sales org Record
  */
  public class customSoldToWrapper{
    //Boolean to let us know the 
    public Boolean selected{get;set;}
  
    //SAP sales Org object to store the Sold To Object for each line.
    public LX_SAP_Record_Sales_Org__c soldToObject{get;set;}
    
    /* Consutructor for the customSoldToWrapper
    */
    public customSoldToWrapper(LX_SAP_Record_Sales_Org__c soldToObject){
        this.soldToObject = soldToObject;       
    }   
  }


}