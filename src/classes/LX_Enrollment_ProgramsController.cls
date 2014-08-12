public with sharing class LX_Enrollment_ProgramsController  
{ 
    public List<Account> results{get;set;} // search results
    public string searchString{get;set;} // search keyword
    public String ProgramId{get;set;}
    public String strAccountId = null;
    public List<LX_Partner_Program__c> lstPartnerProgramRecords{get;set;} // search results
    public String bPartnerPage{get;set;}
    public String m_FilterCritirea {get;set;}
    public LX_Partner_Program__c ObjPartner{get;set;}
    public Account objAcct  {get;set;}
    public LX_Enrollment_ProgramsController (){       
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        ProgramId=System.currentPageReference().getParameters().get('programId');
        strAccountId = System.currentPageReference().getParameters().get('accountID');
        bPartnerPage = System.currentPageReference().getParameters().get('fromPartner');       
        system.debug('strAccountId == '+strAccountId);
        if(strAccountId != null)
        {
            //strAccountId = strAccountId.replace('%2F','');
            getPatrnerPrograms(strAccountId);
        }
        else if(bPartnerPage != null && bPartnerPage == 'true')
        {
            results = performSearchFromPartner();
            system.debug('performSearchFromPartner()-->'+performSearchFromPartner());
        }
        else
        {
            runSearch();  
        }
   } 
    
  // performs the keyword search
  public PageReference searchPartnerPrograms() {
    String strAccntId = System.currentPageReference().getParameters().get('accountID');
    getPatrnerPrograms(strAccntId);
    return null;
  }
  
  private void getPatrnerPrograms(String strAccountId)
  {
    system.debug('strAccountId-->'+strAccountId);
    List<Account>  lstAccount = [select id,RecordType.Name,Primary_ISS_Internal_Segment__c,LX_Total_Capability_Score__c,BillingCountry,LX_Geo__c,LXK_Region__c,Partner_MPS_Capability_Score__c, Partner_ISS_Solutions_Capability_Score__c,Party_Type__c,Partner_ISS_Capability_Segment__c,ISS_Coverage_Method__c from account where id =: strAccountId and RecordType.Name = 'Location Partner'];
    objAcct = null;
    if(lstAccount != null && lstAccount.size() > 0){
        objAcct = lstAccount[0];
    }
    
    if(objAcct == null) return;
    //Default search for Partner Programs
    String strDefaultSearch = '';
    String strOperator = ' AND ';
    //Kapil 1/13/2014: Lock local ISS Program will not be used anymore. 
    //strDefaultSearch += ' Where RecordType.Name = \'Lock Local ISS Program\'';     
    strDefaultSearch += ' Where RecordType.Name = \'Local ISS Program\'';
    //Get level 1 records
    strDefaultSearch += strOperator + 'Program_Level__c = \''+Label.Local_Program_Name_Partner_Program+'\'';
    //Get Active records
    strDefaultSearch += strOperator + 'Program_Status__c = \'Active\'';    
    
    String strDynamicSearch = '';
    //Add filter for GEO value
    if(objAcct.LX_Geo__c != null)
        strDynamicSearch += strOperator + 'LX_GEO__c = \''+objAcct.LX_GEO__c+'\'';
    //Add filter for Region value
    if(objAcct.LXK_Region__c != null)
        strDynamicSearch += strOperator + 'LX_Region__c = \''+objAcct.LXK_Region__c+'\'';
    //Add filter for billing country value
    if(objAcct.BillingCountry != null)
        strDynamicSearch += strOperator + 'LX_Country__c = \''+objAcct.BillingCountry+'\'';
    //Add filter for MPS Capability Score value
    if(objAcct.Partner_MPS_Capability_Score__c != null)
        strDynamicSearch += strOperator + 'LX_T_Minimum_MPS_Capability_Score__c <= '+objAcct.Partner_MPS_Capability_Score__c;
    //Add filter for ISS Capability Score value
    if(objAcct.Partner_ISS_Solutions_Capability_Score__c != null)
        strDynamicSearch += strOperator + 'LX_T_Minimum_Solution_Capability_Score__c <= '+objAcct.Partner_ISS_Solutions_Capability_Score__c;
    //Add filter for Party Group value
    if(objAcct.Party_Type__c != null)
    { 
        //Set<String> setPartyTypes = new Set<String>();
        //setPartyTypes.add(objAcct.Party_Type__c);
        strDynamicSearch += strOperator + 'LX_Party_Type__c includes (\''+objAcct.Party_Type__c+'\')';
    }
    //Add filter for ISS Coverage Method value
    if(objAcct.ISS_Coverage_Method__c != null)
        strDynamicSearch += strOperator + 'LX_ISS_Coverage_Method__c = \''+objAcct.ISS_Coverage_Method__c+'\'';
     //Kapil(2/18/2014):Sprint 13 change to add Capability Segment,Internal Segment and Capability Score to the filter criteria.  
     if(objAcct.Partner_ISS_Capability_Segment__c != null)
        strDynamicSearch += strOperator + 'LX_Partner_ISS_Capability_Segment__c = \''+objAcct.Partner_ISS_Capability_Segment__c+'\'';
        
     if(objAcct.Primary_ISS_Internal_Segment__c != null)
    strDynamicSearch += strOperator + 'LX_Primary_ISS_Internal_Segment__c = \''+objAcct.Primary_ISS_Internal_Segment__c+'\'';
    
     if(objAcct.LX_Total_Capability_Score__c != null)
    strDynamicSearch += strOperator + 'LX_Minimum_Total_Capability_Score__c <= '+objAcct.LX_Total_Capability_Score__c;
        
    String strQuery = 'Select name,LX_Partner_ISS_Capability_Segment__c,LX_Primary_ISS_Internal_Segment__c,LX_Minimum_Total_Capability_Score__c,LX_Region__c ,LX_GEO__c,LX_Party_Type__c,LX_T_Minimum_MPS_Capability_Score__c,LX_ISS_Coverage_Method__c,LX_T_Minimum_Solution_Capability_Score__c,LX_Country__c,LX_Program_Type__c,Recordtype.Name,LX_Start_Date__c,Program_End_Date__c,Program_Status__c from LX_Partner_Program__c';
      
    system.debug('strQuery == '+strQuery);
    system.debug('strDynamicSearch == '+strDynamicSearch);
    system.debug('strDefaultSearch == '+strDefaultSearch);
    //Add default filters to query 
    strQuery += strDefaultSearch;
    //Apply user search critirea
    if(searchString != '' && searchString != null)
        strQuery += ' AND name LIKE \'%' + searchString +'%\'';
    else
    {
        //Add Custom filter to query
        strQuery += strDynamicSearch;
    }    
    system.debug('strQuery == '+strQuery);
    lstPartnerProgramRecords = Database.Query(strQuery);
    if(lstPartnerProgramRecords.size() <= 0) lstPartnerProgramRecords = null;    
  
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearchFromPartner();               
  } 
 

  // run the search and return the records found. 
 /*  private List<Account> performSearch(string searchString) 
  {

    for(LX_Partner_Program__c TempObjPartner:[select id,LX_Party_Type__c,ISS_Capability_Segment__c,LX_Program_Enrolled__r.Minimum_MPS_Capability_Score__c,LX_Program_Enrolled__r.Minimum_Solutions_Capability_Score__c,LX_GEO__c,LX_Region__c,LX_Country__c ,LX_T_County__c ,LX_T_Minimum_Solution_Capability_Score__c,LX_T_Minimum_MPS_Capability_Score__c from LX_Partner_Program__c where id=:ProgramId])
    {
    ObjPartner=TempObjPartner;
    } 

     
    String WhereFilter='Name!=\'\' and Recordtype.Name=\'Location Partner\'';


    if(ObjPartner.LX_GEO__c!=null)
    WhereFilter+='and LX_Geo__c=\''+ObjPartner.LX_GEO__c+'\'';
    if(ObjPartner.LX_Region__c!=null)
    WhereFilter+='and LXK_Region__c=\''+ObjPartner.LX_Region__c+'\'';
    if(ObjPartner.LX_Country__c !=null)
    WhereFilter+='and BillingCountry=\''+ObjPartner.LX_Country__c +'\'';
    if(ObjPartner.LX_Program_Enrolled__r.Minimum_MPS_Capability_Score__c!=null)
    WhereFilter+='and Partner_MPS_Capability_Score__c='+ObjPartner.LX_Program_Enrolled__r.Minimum_MPS_Capability_Score__c;
    if(ObjPartner.LX_Program_Enrolled__r.Minimum_Solutions_Capability_Score__c!=null)
    WhereFilter+='and Partner_ISS_Solutions_Capability_Score__c='+ObjPartner.LX_Program_Enrolled__r.Minimum_Solutions_Capability_Score__c;


    String soql = 'select  Partner_ISS_Capability_Segment__c,Name,Id,Industry,Party_Role__c,Party_Type__c,BillingCountry,BillingCity,owner.Name from account';8
    if(searchString != '' && searchString != null)
    soql = soql +  ' where name LIKE \'%' + searchString +'%\' and ';
    else
    soql =soql + ' where ';

    soql = soql+WhereFilter+' limit 25';
    
    String WhereFilter='';
    if(ObjPartner.LX_Country__c!=null)
    WhereFilter+='BillingCountry=\''+ObjPartner.LX_Country__c+'\'';

    WhereFilter += 'and Type = \'Partner\'';

    WhereFilter += 'and Coverage_Status__c = \'Active\'';

    String soql = 'select  Partner_ISS_Capability_Segment__c,Name,Id,Industry,Party_Role__c,Party_Type__c,BillingCountry,BillingCity,owner.Name from account';
    if(searchString != '' && searchString != null)
        soql = soql +  ' where name LIKE \'%' + searchString +'%\' and ';
    else
        soql =soql + ' where ';

    soql = soql+WhereFilter+' limit 200';

    System.debug('==================soql='+soql);

    List<Account> TempListAccount = database.query(soql);

    for(Account ObjAccount:database.query(soql))
    {

    System.debug('==================ObjAccount='+ObjAccount);
    System.debug('==================ObjPartner='+ObjPartner);

    boolean IsMatch=false;
    if(ObjAccount.Party_Type__c!=null&&ObjPartner.LX_Party_Type__c!=null)
    {
    if(ObjPartner.LX_Party_Type__c.contains(ObjAccount.Party_Type__c))
    IsMatch=true;
    }
    else
    IsMatch=true;

    if(ObjAccount.Partner_ISS_Capability_Segment__c!=null && ObjPartner.ISS_Capability_Segment__c!=null)
    {
    if(ObjPartner.ISS_Capability_Segment__c.contains(ObjAccount.Partner_ISS_Capability_Segment__c))
    IsMatch=true;
    }
    else
    IsMatch=true;

    if(IsMatch)
    TempListAccount.Add(ObjAccount);


    }
    if(!TempListAccount.IsEmpty())
        return TempListAccount;
    else
        return null; 
  }
  */
  
  private List<Account> performSearchFromPartner() 
  {    
    if(ProgramId == '' || ProgramId == null) return null;
    objPartner = [select id,LX_Party_Type__c,ISS_Capability_Segment__c,LX_Program_Enrolled__r.Minimum_MPS_Capability_Score__c,LX_Program_Enrolled__r.Minimum_Solutions_Capability_Score__c,LX_GEO__c,LX_Region__c,LX_Country__c ,LX_T_County__c ,LX_ISS_Coverage_Method__c,LX_T_Minimum_Solution_Capability_Score__c,LX_T_Minimum_MPS_Capability_Score__c from LX_Partner_Program__c where id=:ProgramId] ;
    System.debug('objPartner-->'+objPartner);
    String WhereFilter='';
    WhereFilter+= '  Recordtype.name=\'Location Partner\'';    
    WhereFilter+=' and BillingCountry=\''+ObjPartner.LX_Country__c+'\'';
      
    /*if(ObjPartner.LX_Region__c != null){    
        WhereFilter += 'and LXK_Region__c = \''+ObjPartner.LX_Region__c+'\'';    
    }
    if(ObjPartner.LX_Geo__c != null){ 
        WhereFilter += 'and LX_Geo__c = \''+ObjPartner.LX_Geo__c+'\'';
    }
    if(ObjPartner.LX_Program_Enrolled__r.Minimum_MPS_Capability_Score__c != null)
        WhereFilter+='and Partner_MPS_Capability_Score__c='+ObjPartner.LX_Program_Enrolled__r.Minimum_MPS_Capability_Score__c;
    if(ObjPartner.LX_Program_Enrolled__r.Minimum_Solutions_Capability_Score__c != null)
        WhereFilter+='and Partner_ISS_Solutions_Capability_Score__c='+ObjPartner.LX_Program_Enrolled__r.Minimum_Solutions_Capability_Score__c;      
    if(ObjPartner.LX_ISS_Coverage_Method__c != null && ObjPartner.LX_ISS_Coverage_Method__c != ''){
        WhereFilter += 'and ISS_Coverage_Method__c = \''+ObjPartner.LX_ISS_Coverage_Method__c+'\''; 
    }   */
    system.debug('WhereFilter-->'+WhereFilter);
    String soql = 'select  Partner_ISS_Capability_Segment__c,ISS_Coverage_Method__c,LX_Geo__c,LXK_Region__c,Partner_ISS_Solutions_Capability_Score__c,Partner_MPS_Capability_Score__c,Name,Id,Industry,Party_Role__c,Party_Type__c,BillingCountry,BillingCity,owner.Name from account';
    system.debug('searchString-->'+searchString);
    if(searchString != '' && searchString != null){
      soql = soql +  ' where name LIKE \'%' + searchString +'%\' and ';
    }
    else{
      soql = soql + ' where ';
    }   
    soql = soql+WhereFilter+' limit 200';
    system.debug('Soql-->'+soql);
    List<Account> TempListAccount = new list<Account>();
    if(ObjPartner.LX_Country__c != null && ObjPartner.LX_Country__c != ''){
        TempListAccount = database.query(soql);
    }
    /*for(Account ObjAccount:database.query(soql)){
        boolean IsMatch=true;
        system.debug('IsMatch-->'+IsMatch);
        if( ObjAccount.Party_Type__c!=null&&ObjPartner.LX_Party_Type__c!=null ) 
        {
            if(ObjPartner.LX_Party_Type__c.contains(ObjAccount.Party_Type__c)){
                IsMatch=true;
                system.debug('IsMatch-->'+IsMatch);
            }else IsMatch=false;
        }
        else if(ObjPartner.LX_Party_Type__c == '' || ObjPartner.LX_Party_Type__c == null){
            IsMatch=true;
        }
        system.debug('IsMatch-->'+IsMatch);
        if( ObjAccount.Partner_ISS_Capability_Segment__c!=null && ObjPartner.ISS_Capability_Segment__c!=null)
        {
            if(ObjPartner.ISS_Capability_Segment__c.contains(ObjAccount.Partner_ISS_Capability_Segment__c)){
                IsMatch=true;
                system.debug('IsMatch-->'+IsMatch);
            } else IsMatch=false;
        }
        else if(ObjPartner.ISS_Capability_Segment__c == null || ObjPartner.ISS_Capability_Segment__c == ''){
            IsMatch=true;
        }
        system.debug('IsMatch-->'+IsMatch);
       
        if(IsMatch){
            TempListAccount.Add(ObjAccount);
        }
    }   */
   
    if(!TempListAccount.IsEmpty()){
        return TempListAccount;
    }
    else
        return null; 
  }
  
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // used by the visual force page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visual force page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
 
}