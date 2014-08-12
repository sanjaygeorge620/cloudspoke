/* Class Name   : LX_AccountDetailsExtension 
    * Description   : Extension for 'LX_AccountDetails' page for displaying the Account and related Opportunity,Enrollments.
    * Created By    : Kapil Reddy Sama.
    * Created Date  : 07/11/2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Kapil Reddy Sama       07/11/2013             1000                   Initial Version.
    * Nithin                 08/16/2013             1001                   Replaced NameLocal with Alias__c in the query.
    */

public without sharing class LX_AccountDetailsExtension {
    Public Account accountDisplay {get;set;}
    public list<Opportunity> oppList {get;set;}
    public String baseURL{get;set;}
    public String currentURL{get;set;}
    public list<LX_Program_Enrollment__c> enrollments {get;set;}
    public integer size{get;set;}
    public integer pageSize{get;set;}
    private string id = Apexpages.currentPage().getParameters().get('id');
    //standard set controller for pagination    
    public ApexPages.StandardSetController setCon1 {
        get{
            if(setCon1 == null){               
                
                setCon1 = new ApexPages.StandardSetController(new list<LX_Program_Enrollment__c>());
                setCon1.setPageSize(5);                
            }
            return setCon1 ;
        }set;
    }
    
    //standard set controller for pagination
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){               
                
                setCon = new ApexPages.StandardSetController(new list<Opportunity>());
                setCon.setPageSize(5);                
            }
            return setCon;
        }set;
    }
    
    // list of Opportunities to display
    public List<Opportunity> oppPaginationList{
        get
        {
            if(setcon != null)
                return (List<Opportunity>)setcon.getRecords();
            else
                return null ;
        }
        set;
    } 
    /* Description : list of enrollments to display
    *  Param - 
    *  Returns : List<LX_Program_Enrollment__c>  
    */
    
    public List<LX_Program_Enrollment__c> enrollmentPaginationList{
        get
        {
            if(setcon1 != null)
                return (List<LX_Program_Enrollment__c>)setcon1.getRecords();
            else
                return null ;
        }
        set;
    } 
    
    /* Description : Controller for setting up the variables
    *  Param - StandardController - Account standard controller
    *  Returns :  
    */
    public LX_AccountDetailsExtension(ApexPages.StandardController controller) {
        //Account temp = (Account)controller.getRecord();
        string accountId  = Apexpages.currentpage().getParameters().get('id');
        //@Nithin: Replaced NameLocal with Alias__c in the query
        accountDisplay = [SELECT id,Name,BillingCity,Owner.Name,BillingState,Alias__c,BillingCountry,Global_Account__c,type,
                                 Global_Account_Owner__r.Name,Party_Role__c,Number_Open_Opportunities__c,Party_Type__c,
                                 Partner_ISS_Local_Grade__c,Primary_ISS_Internal_Segment__c,Partner_ISS_Global_Grade__c,
                                 MPS_Capable_Partner__c,ISS_Coverage_Model__c,Primary_Sector_Focus__c,ISS_Coverage_Method__c,
                                 Secondary_Sector_Focus__c,Coverage_Status__c,
                                 Rating,TR_Status__c,Country_Account_Rating__c,Local_Priority__c,footprint__c,
                                 MPS_Qualification__c,LX_Sales_Team_Assigned__c,Lexmark_Sub_Vertical__c,
                                 Owner.email from Account where id = :accountId  ];
        oppList = new list<Opportunity>();
        size = 5;
        pageSize = 5;
        baseURl = URL.getSalesforceBaseUrl().toExternalForm();
        currentURL = URL.getCurrentRequestUrl().toExternalForm();
        string accid = ApexPages.currentPage().getParameters().get('id');    
        oppList  = new list<Opportunity>();
        oppList = [SELECT id,Name,Owner.Name ,StageName,LX_Product_Type__c,LX_Sales_Type__c,type,LX_Program_Enrollment__r.Name,Amount,Primary_Partner__r.Name,Account.Restricted_TR_Account__c 
                          from Opportunity 
                          Where Accountid = :accid  and Account.Restricted_TR_Account__c != true order by name ];
        
                          
        enrollments = new list<LX_Program_Enrollment__c>();
        enrollments = [select id ,Master_Program__c,Master_Program__r.name,lx_account__c ,LX_Enrollment_End_Date__c ,LX_Enrollment_Status__c from LX_Program_Enrollment__c where lx_account__c = :accid order by Master_Program__r.Name];
        
    }
    
    /* Description : Increase the number of records to display on the page.
    *  Param - 
    *  Returns :  PageReference
    */
    public pageReference showMore(){
        size += 5;
        return null;
    }
    /* Description : Set the StandardSetController for pagination
    *  Param - 
    *  Returns :  PageReference
    */
    public pageReference showPagination(){
        setCon = new ApexPages.StandardSetController(oppList );               
        setCon.setPageSize(20);   
        System.debug('setcon.getRecords()-->'+setcon.getRecords());                         
        oppPaginationList= setcon.getRecords();
        return null;
    }
    
    /* Description : Increase the number of records to display on the page.
    *  Param - 
    *  Returns :  PageReference
    */
    public pageReference showMore1(){
        pageSize += 5;
        return null;
    }
    /* Description : Set the StandardSetController for pagination
    *  Param - 
    *  Returns :  PageReference
    */
    public pageReference showEnrollmentPagination(){
        setCon1 = new ApexPages.StandardSetController(enrollments);               
        setCon1.setPageSize(20);   
        System.debug('setcon1.getRecords()-->'+setcon1.getRecords());                         
        enrollmentPaginationList = setcon1.getRecords();
        return null;
    }
    
    /* Description : Returns the next set of Opportunities
    *  Param - 
    *  Returns :  void
    */
    public void next()
    {  
        setcon.next();
    }
    /* Description : Returns the previous set of Opportunities
    *  Param - 
    *  Returns :  void
    */
    public void previous()
    { 
        setcon.previous();
    }    
    
    /* Description : Returns the next set of Enrollments
    *  Param - 
    *  Returns :  void
    */
    public void next1()
    {  
        
        setcon1.next();
    }
    
    /* Description : Returns the previous set of Enrollments
    *  Param - 
    *  Returns :  void
    */
    
    public void previous1()
    { 
        setcon1.previous();
    }
    
    /* Description : Reset the Standard set controller variables and reload the page.
    *  Param - 
    *  Returns :  PageReference
    */
    public pageReference cancel1(){
        setCon1 = new ApexPages.StandardSetController(new list<LX_Program_Enrollment__c>());        
        setCon = new ApexPages.StandardSetController(new list<Opportunity>());
        return new pageReference('/apex/LX_accountDetails?id='+id) ;       
    }
}