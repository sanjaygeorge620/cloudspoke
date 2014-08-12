public with sharing class LX_LicenseContactController {
    
    //Decalare all the static constants for the class
    private static final string LX_ASC  = 'ASC';
    private static final string LX_DESC     = 'DESC';
    private static final string LX_CONTACT_QUERY = 'SELECT ID,Contact__c,Contact__r.Name,Contact__r.email,Contact__r.Title,Contact__r.City__c,Contact__r.State__c,LX_Ship_To__c,LX_Ship_To__r.Name,LX_SAP_Record_Sales_Organization__c FROM ';
    private static final string LX_QUERY1 =  ' WHERE LX_SAP_Record_Sales_Organization__c =\'';
    private static final string LX_QUERY2 = '\' AND Contact__r.AccountID =\'';
    private static final string LX_CONDITN_QUERY = ' AND  Contact__r.Name LIKE \'%';
    
    
    
    
  
  //Variable to store object Name
   public String objectName = 'LX_Contact_ShiptoSalesOrg__c ';
  // Variable to store the Seltect License Contact ID for the opportunity.  
   private string selectedRecord   = ApexPages.currentPage().getParameters().get('selectedRecord');
  // Variable to store the Opportunity ID for the opportunity.  
   private string oppId          = ApexPages.currentPage().getParameters().get('oppId');
   // Variable to store the initialQuery String;
   private string query          = '';
  // Variable to store the condition for the query.
   private string condition      = '';         
  // Variable to store the sort direction for the columns
   private String sortDirection = 'ASC';  
  // Variable to store the field on which the sorting is going to happen.
   private String sortExp = 'name';  
  // Variable that checks if the page can be loaded correctly or not.
   public Boolean isError{get;set;}
   // Variable to store the Contact Name entered in search box  
   public string input1{get;set;}
   // Variable to store wrapper class list
   public list<customLicenseConWrapper> resultList;
  // Variable used to store boolean value to return to Opportunity if Ship to is not present on Opp
  public Boolean returnOpp{get; set;}
  /* getter method for the resultList variable
  */
   public list<customLicenseConWrapper> getresultList(){
    system.debug('>>>>>>>>>>>>>>>>resultList>>>>>>>>>>inside getter>>>>>>>>>'+resultList);
    return this.resultList;
  }
  
   // Variable to store the sortExpression
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
         sortDirection = (sortDirection == LX_ASC)? LX_DESC : LX_ASC;
       else
         sortDirection = LX_ASC;
       sortExp = value;
     }
   }

  
  // getter method for the sortDirection    
  public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return LX_ASC;
        else
         return sortDirection;
     }
  
  // setter method for the sortDirection    
  public void setSortDirection(String sortDir)
     {  
       sortDirection = sortDir;
     }

   /*Constructor method 
   */
   public LX_LicenseContactController(){
    returnOpp = FALSE;
   // Building base query
    query = LX_CONTACT_QUERY+objectName+'';
    
    if(oppId != NULL){
     List<Opportunity> opp = [SELECT id,AccountID /*, LX_Ship_To_New__c*/ FROM Opportunity WHERE id =:oppId LIMIT 1];
     
     /*if(opp[0].LX_Ship_To_New__c != NULL){
         returnOpp = FALSE;
        query = query + LX_QUERY1 + opp[0].LX_Ship_To_New__c + LX_QUERY2+opp[0].AccountID+'\'';
        System.debug('Initial Query :'+query);
        viewAllData();
     }else{
       returnOpp = TRUE;
     //  ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Cannot select License Contact without Ship to on Opportunity.');
     //  ApexPages.addMessage(message);
     } */
    }
   }
   
   public void viewAllData(){
    
     returnOpp = FALSE;
     String NullLast = 'NULLS LAST';
     string sortFullExp = '';
        //build the full sort expression
       if(sortDirection == LX_ASC)
           sortFullExp = sortExpression  + ' ' + sortDirection;
       else
          sortFullExp = sortExpression  + ' ' + sortDirection + ' ' + NullLast;
       
      string finalQuery  = query + condition;
       //query the database based on the sort expression
       
       system.debug('>>>>>>>>>>>>>>>'+query + ' order by ' + sortFullExp );
      
    List<LX_Contact_ShiptoSalesOrg__c > licenseCon= Database.query(finalQuery   + ' order by ' + sortFullExp + '');
    resultList = new list<customLicenseConWrapper>();
    resultList.clear();
    for(LX_Contact_ShiptoSalesOrg__c org :licenseCon){
      if(selectedRecord != '' && selectedRecord != null && org.id == selectedRecord){
          resultList.add(new customLicenseConWrapper(org,true));
      }else
        resultList.add(new customLicenseConWrapper(org,false));
    }
    
   }
   /* Method called when user enters input parameter to filter the query
   */
   public Pagereference Go(){
    condition = '';
    returnOpp = FALSE;
    if(input1 != NULL && input1.trim() != '')
       condition = ' AND  Contact__r.Name LIKE \'%' + input1+ '%\'';
    viewAllData();
    return null;
   }
   
   /* Method called to Update the Opportunity after selecting the required License Contact
   */
   public Pagereference updateOpp(){
     string selectedID = null;
        for(customLicenseConWrapper wrap :resultList){
            if(wrap.selected == true){
                selectedID = wrap.licenseConObject.id;
            }
        }
        //Rahul Commented
      /*//Opportunity opp = new Opportunity (id = oppId , LX_License_Contact__c = selectedID);
      
      try{
        update opp;
      }catch(Exception ex){
        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'There has been an error. Opportunity could not be updated with selected License Contact.');
        ApexPages.addMessage(message);
        System.debug('Could not update opportunity :'+ex.getmessage());
      }*/
    // return new Pagereference('/'+oppId);
    return null;
   }
   
   /* Cancel method to return to Opportunity screen without any changes to Opportunity
   */
   public Pagereference cancel(){
    // return new pagereference('/'+oppId); 
    return null;
   }
   
  /* Wrapper class to hold the License Contact Record 
  */  
    public class customLicenseConWrapper{
    //Boolean to let us know the 
    public Boolean selected{get;set;}
  
    //License Contact object to store the Lincese Contact for each line.
    public LX_Contact_ShiptoSalesOrg__c licenseConObject{get;set;}
    
    /* Consutructor for the customLicenseConWrapper
    */
    public customLicenseConWrapper(LX_Contact_ShiptoSalesOrg__c licenseConObject,boolean isSelected){
        this.licenseConObject = licenseConObject;       
        this.selected     = isSelected;
    }   
  }
}