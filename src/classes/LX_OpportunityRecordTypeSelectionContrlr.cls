/*
Class Name : LX_OpportunityRecordTypeSelectionContrlr
Description : Extension class for selecting Opportunity Reocrd type based on three fields and autopopulates the type,account, reocrd type Id fields.It 
              also autopopulates the territory field with the default territory of the current user.
Created By : Veenu Trehan (vtrehan@deloitte.com)
Created Date : 10-6-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan     17-05-2013        1000                   Initial Version
Rashi Joshi      10-01-2013        1001                   changed in RecordTypeLogic
Sumedha          22-01-2014        1002                   added logic to also compare opportunity
                                                          division on Opportunity with custom
                                                          setting data to select the record type
********************************************************************************************/

public class LX_OpportunityRecordTypeSelectionContrlr {
      //public List<SelectOption> options = new List<SelectOption>();
      private string recordTypeNameCurrent = '';
     public Opportunity NewOpp{get;set;}
     public List<Opportunity>oppList{get;set;}
     public Boolean flag {get;set;}
     public String product_type ='';
    /* public String CheckboxTech {get;set;}
     public String CheckboxSoft {get;set;}
     public String CheckboxMPS {get;set;}*/
     private PageReference PageRef = new PageReference ('/006/e');
    //Page Reference for Opportunity edit page
    private string currentUserId                            = UserInfo.getUserId();
    //stores the id of the current user
    private final string retURLID                           = 'retURL';
    private list<LX_Territory_Member__c>   defaultList;
    private final string recordTypeName                     = 'RecordType';
    private final string entName                            = 'ent';
    private final string nooverride                         = 'nooverride';
    private final string nooverrideValue                    = '1';    
    private final string TerritoryID                        = System.Label.LX_TerritoryFieldID;
    private final string TerritoryNameID                    = System.Label.Lx_TerritoryNameFieldID;
    private final string InvoiceLogo                        = System.Label.LX_InvoiceLogoID;
    private final string InvoiceLogoName                    = System.Label.LX_InvoiceLogoName;
    private final string SalesOrgNamelabel                  =System.Label.LX_Opportunity_SalesOrgName;
    private final string salesOrgIDlabel                    = System.Label.LX_Opportunity_SalesOrgID;
    private static final string strAccountID                = 'accid';
    private static final string strtype                     = 'type';
    private static final string CountryUS                   ='US';
    private static final string LegacayComp                 ='Lexmark';
    private static final string ISSDiv                      ='ISS';
    private static final string PSWDiv                      ='PSW';
   
    private static final string LX_OppoLevel                = System.Label.LX_OppoLevel;
    private string returl,ent,recordType,defaultTerritoryId,defaultTerritoryName,accountID;
    list<Sales_Organization__c> SalesOrg=new list<Sales_Organization__c>();
    private User user;
    private map<string,Invoice_Logo__c> invoiceLogoMap = new map<string,Invoice_Logo__c>();
    private static string DefSalesOrgId,SalesOrgName,salesOrgID,CounrtyCode;
    public string selectedSalesOption{get;set;}        


     public List<SelectOption> options{get;set;}
     public List<SelectOption> options_new{get;set;}
     public List<User> curUser;
     /*
    * Description : Default constructor to get the page parameters like return url the record name the account id etc and 
                to get the default territory of the current user.
    */     
     public  LX_OpportunityRecordTypeSelectionContrlr(ApexPages.StandardController controller){
        
        
        curUser  = [SELECT ID,Legacy_Company__c FROM User WHERE ID =:UserInfo.getUserID() LIMIT 1];
        
        returl        = ApexPages.currentPage().getParameters().get(retURLID);
        ent           = ApexPages.currentPage().getParameters().get(entName);
        recordType    = ApexPages.currentPage().getParameters().get(recordTypeName);
        accountID     = ApexPages.currentPage().getParameters().get(strAccountID);
        //gets various page parameters
        defaultList = [select id, Name, LX_Territory_Id__c, LX_Territory_Id__r.Name 
                               FROM  LX_Territory_Member__c
                               WHERE LX_User__c = :currentUserId
                               AND LX_DefaultFlag__c = true];
        //query to get the default territory and terittory id of the current user to populate it on the Opp                               
        NewOpp=New Opportunity();

       flag =false;
   
     List <Schema.PicklistEntry> F1 = Opportunity.LX_Sales_Type__c.getDescribe().getPicklistValues();
      options = new List<SelectOption>();
      for(Schema.PicklistEntry pick1 :F1){
         
          options.add(new SelectOption(pick1.getLabel(),pick1.getValue()));
      }    
               
    }
   
    /*
    * Description : Update the salestype based on the product checkboxes selected.
    */     

   public Pagereference change_sales()
   {
      flag=true;
      product_type ='';
      if(NewOpp.MPS__c == true){flag=true; product_type +='MPS;';}
      if(NewOpp.Software_Solutions__c == true){flag=true;product_type +='Software Solutions;';}
      if(NewOpp.Technology__c == true){flag=true;product_type +='Technology;';}
       
      if(product_type.substringAfterLast(';')==''){ product_type = product_type.substringBeforeLast(';');}
        sales_list();
        return null;
   }
  
    public List<SelectOption> sales_list()
    {
    Integer j =0;
     flag=true;

    options = new List<SelectOption>();
    List<String> ProductList = product_type.split(';',0);
    ProductList.sort();
    product_type ='';
    for(j = 0 ; j < ProductList.size() ; j++){product_type += string.valueof(ProductList.get(j)) + ';' ; }
    if(product_type.substringAfterLast(';')==''){product_type = product_type.substringBeforeLast(';');}
    String sales_type_op = LX_OpportunityHelper.sales_type(product_type ) ; 
    List<String> salesOpList = sales_type_op.split(',',0);
    Integer i ;
     options = new list<SelectOption>();
        for(i = 0 ; i < salesOpList.size() ; i++){
                  options.add(new SelectOption(salesOpList.get(i) ,salesOpList.get(i)));
        }
        
    return options;
   }
    
       
    
     /*
  *Description : Method used get the record type id based on the record type name.
  */
    Public Id GetRecordTypeId(string strRecordTypeName){
        recordTypeNameCurrent = strRecordTypeName;
          Map<String, Schema.RecordTypeInfo> mapRecordTypes;
         // get the describtion of the SObject like Record type
         schema.Describesobjectresult sobjdescribe = Opportunity.sObjectType.getDescribe();
         // Fetch the Record type info
         mapRecordTypes = sobjdescribe.getRecordTypeInfosByName();  
         Schema.Recordtypeinfo objRecordTypeInfo;
         objRecordTypeInfo = mapRecordTypes.get(strRecordTypeName);
         
         return objRecordTypeInfo.getRecordTypeId();
         }
     /*
  *Description : Method used to determine the record type of an opportunity based on three fields using custom settings.
  */
    public void RecordTypeLogic(){
       
        map<string,LX_Opp_RecordType__c> oppRecordType = LX_Opp_RecordType__c.getAll();
        //gets the custom setting for record
        
        system.debug('rectype$$$$$$$$'+oppRecordType );
            user = [Select id,legacy_company__c,Name from User where id =:userinfo.getUserId()];

        //loop to iterate over the custom setting and set the record type id and opportunity type field based on the custom setting
        for(LX_Opp_RecordType__c OppRec :oppRecordType.values()){
        // added condition to bypass LX_First_Time_to_Revenue__c  
            /*system.debug('###product_type'+product_type);  
            system.debug('##LX_Sales_Type__c'+NewOpp.LX_Sales_Type__c);  
            system.debug('>>>>>>>Custom Setting division>>>>>>>'+OppRec.LX_Opportunity_Division__c);
            system.debug('>>>>>>>Opp Division>>>>>>>'+NewOpp.LX_Opportunity_Division__c);*/
            if(user.Legacy_Company__c == LegacayComp){
               NewOpp.LX_Opportunity_Division__c = 'ISS';
            }else{
               NewOpp.LX_Opportunity_Division__c = 'PSW';
            }
       
       if(  (NewOpp.LX_Opportunity_Division__c == ISSDiv && 
              NewOpp.LX_Opportunity_Division__c == OppRec.LX_Opportunity_Division__c
           && product_type == OppRec.LX_Product_Type__c && 
           NewOpp.LX_Sales_Type__c==OppRec.LX_Sales_Type__c) 
           || (NewOpp.LX_Opportunity_Division__c == 'PSW' && 
                NewOpp.LX_Opportunity_Division__c == OppRec.LX_Opportunity_Division__c &&
                product_type == OppRec.LX_Product_Type__c && 
                NewOpp.LX_Sales_Type__c==OppRec.LX_Sales_Type__c 
                && NewOpp.LX_First_Time_to_Revenue__c == OppRec.LX_First_Time_to_Revenue__c)
           || ((OppRec.LX_Opportunity_Division__c  == null || 
                OppRec.LX_Opportunity_Division__c.trim()  == '') &&
                product_type == OppRec.LX_Product_Type__c && 
                NewOpp.LX_Sales_Type__c==OppRec.LX_Sales_Type__c 
                && NewOpp.LX_First_Time_to_Revenue__c == OppRec.LX_First_Time_to_Revenue__c))
                   {                 
                     /* system.debug('########NewOpp.LX_Sales_Type__c'+ NewOpp.LX_Sales_Type__c);
                      system.debug('########OppRec.LX_Record_Type__c'+OppRec.LX_Record_Type__c);
                      system.debug('## GetRecordTypeId(OppRec.LX_Record_Type__c)'+ GetRecordTypeId(OppRec.LX_Record_Type__c));
                       system.debug('Entered Seconf if');*/
                    NewOpp.RecordTypeId=GetRecordTypeId(OppRec.LX_Record_Type__c);
                    NewOpp.Type=OppRec.LX_Opportunity_Type__c;
/*                      system.debug('########NewOpp.type'+ NewOpp.type);
                      system.debug('########OppRec.LX_Record_Type__c'+OppRec.LX_Record_Type__c);
                      system.debug('########OppRec.LX_Product_Type__c'+OppRec.LX_Product_Type__c);
                      system.debug('########OppRec.LX_First_Time_to_Revenue__c'+OppRec.LX_First_Time_to_Revenue__c);
                      system.debug('########OppRec.LX_Sales_Type__c'+OppRec.LX_Sales_Type__c);*/
                    break;
                    
                   
                        }
                    }
             //    }
          }
    /*
  *Description : Method invoked on clicking the Cancel button, it redirects the user to the previous page.
  */    
    public PageReference cancelLogic(){
        if(returl==null){
            PageRef  = new PageReference ('/'+'006');
        }
        else{
        PageRef  = new PageReference (returl);
        }
        return PageRef ;
    }       
     /*
  *Description : Method invoked on clicking the continue button, it selects the record type and populated the other parameters in the url for 
                 new opp creation.
  */     
    public PageReference continueLogic(){
    
    System.debug('>>>>>>>Inside continueLogic>>>>>>>');
    //VT 6/27:gets custom setting for sales org
    map<string,LX_Opportunity_Sales_Org__c> oppSalesOrg = LX_Opportunity_Sales_Org__c.getAll();
    System.debug('>>>>>>>Opportunity Sales Org Vaues>>>>>>'+oppSalesOrg);
    newopp.LX_Sales_Type__c     = selectedSalesOption;
    System.debug('>>>>>>Sales Type value>>>>>>>'+selectedSalesOption);
    
        
    user = [Select id,legacy_company__c,Name from User where id =:userinfo.getUserId()];

    if(user.Legacy_Company__c == null || (user.Legacy_Company__c != null && user.Legacy_Company__c.trim() == '')){
      user.Legacy_Company__c = LegacayComp;      
    }
    
    
    
   // system.debug('user.Legacy_Company__C   -->'+user.Legacy_Company__C   ); 
    for(Invoice_Logo__c invLogo :[select id,Name from Invoice_Logo__c]){
        invoiceLogoMap.put(invLogo.Name,invLogo);   
    }

       
    if(accountID!=null ){
    account testacc ;
    
    //VT 8/7:added LX_Channel__c to the query
    for(Account a:[select id,name,LX_Country_Code__c, footprint__c,LX_Sales_Team_Assigned__c,LX_Channel__c from account where id= :accountID]){
        testacc = a;
    }
      //opp need not originate as lead
              
            if(testacc!=null){
               //VT 8/7:added for new channel opp
                NewOpp.LX_channel__c=testacc.LX_Channel__c;
                NewOpp.Reason_for_Conversion__c ='Sales';
                if(testacc.footprint__c=='None'){
                    NewOpp.LX_First_Time_to_Revenue__c='First Time to Revenue';
                }else if(testacc.footprint__c!='None'){
                    NewOpp.LX_First_Time_to_Revenue__c='Repeat Customer';
                }
                //*************Added to default Sales org
                if(user!=null){
                    for(LX_Opportunity_Sales_Org__c SalesRec :oppSalesOrg.values()){
                        //of country is US, need to check for legacy company

                                                                                                                        
                        if(user.legacy_company__c==LegacayComp && testacc.LX_Country_Code__c==CountryUS){
                              
                    if(((SalesRec.LX_CountryCode__c != null) && (SalesRec.LX_CountryCode__c.trim() != '')) && (user.legacy_company__c==LegacayComp) && (SalesRec.LX_CountryCode__c==CountryUS)){                                 
                                DefSalesOrgId=SalesRec.LX_DefaultSalesOrg__c;
                                CounrtyCode=SalesRec.LX_CountryCode__c;
                                
                            }
                        }
                        //else need not check for legacy company
                        else{
                             if(((SalesRec.LX_CountryCode__c != null) && (SalesRec.LX_CountryCode__c.trim() != '')) && testacc.LX_Country_Code__c== SalesRec.LX_CountryCode__c ){ 
                                
                                DefSalesOrgId=SalesRec.LX_DefaultSalesOrg__c;
                                CounrtyCode=SalesRec.LX_CountryCode__c;

                                break;
                            }
                        }   
                    }
                 }
                 system.debug('>>>>>>>>>>>>CounrtyCode>>>>>>>>>>'+CounrtyCode );
                 if(CounrtyCode != 'US'){
                     system.debug('>>>>>>>>>>>>inside Non US');
                     SalesOrg=[SELECT id,Sales_Organization__c ,Name,LX_Country_Code__c
                                                  FROM Sales_Organization__c
                                                  WHERE Sales_Organization__c=:DefSalesOrgId AND LX_Country_Code__c=:CounrtyCode and LX_Default__c =: true
                                                  limit 1];
                 }else{
                     system.debug('>>>>>>>>>>>>inside US');
                     SalesOrg=[SELECT id,Sales_Organization__c ,Name,LX_Country_Code__c
                                                  FROM Sales_Organization__c
                                                  WHERE Sales_Organization__c=:DefSalesOrgId AND LX_Country_Code__c=:CounrtyCode
                                                  limit 1];
                 }
                system.debug('>>>>>>>>>>>>>>>>SalesOrg>>>>>>>>>>>'+SalesOrg);                           
                if((SalesOrg!=null)&&(SalesOrg.size()>0)){
                    SalesOrgName=SalesOrg[0].name;
                    salesOrgID =SalesOrg[0].Id;
                }                           
            //*************Added to default Sales org
            }
            RecordTypeLogic();
        for(LX_Territory_Member__c defaultTer :defaultList){
            defaultTerritoryId    = defaultTer.Id;
            defaultTerritoryName  = defaultTer.Name;
            }
            
        /*system.debug('>>>>>>>>>>>>>NewOpp.RecordTypeId>>>>>>>>>'+NewOpp.RecordTypeId);    
        system.debug('>>>>>>>>>>>>>NewOpp.Type>>>>>>>>>'+NewOpp.Type);    */
        //PageRef.getParameters().put('00Nf0000000MFZK','Technology');//Rahul Added for CR 36
        //PageRef.getParameters().put('00Nf0000000MFZK','Software Solutions');//Rahul Added for CR 36    
       
        PageRef.getParameters().put(System.Label.LX_Sales_Type,NewOpp.LX_Sales_Type__c);
        PageRef.getParameters().put(LX_OppoLevel,'Level 1');//Rahul Added for CR 36    
        if(user.Legacy_Company__c == LegacayComp){
           PageRef.getParameters().put(System.Label.LX_Opp_Div,ISSDiv);
        }else{
          PageRef.getParameters().put(System.Label.LX_Opp_Div,PSWDiv);
       
        }
        PageRef.getParameters().put(retURLID,returl);
        PageRef.getParameters().put(entName,ent);
        PageRef.getParameters().put('RecordType',NewOpp.RecordTypeId);
        PageRef.getParameters().put(TerritoryNameID,defaultTerritoryName);
        PageRef.getParameters().put(TerritoryID,defaultTerritoryId);
      //  PageRef.getParameters().put(label.LX_Opportunity_Sector,testacc.LX_Sales_Team_Assigned__c);
     Schema.sObjectType objType = Schema.Opportunity.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the list of picklist values for this field.
      list<Schema.PicklistEntry> values =  fieldMap.get('Sector__c').getDescribe().getPickListValues();
      set<String> vertical = new set<String>();
        for(Schema.PicklistEntry s:values){
         vertical.add(s.getLabel());   
        }
        System.debug('vertical'+vertical);
        if(vertical.contains(testacc.LX_Sales_Team_Assigned__c)){
           PageRef.getParameters().put(label.LX_Opportunity_Sector,testacc.LX_Sales_Team_Assigned__c);
        }
        
        PageRef.getParameters().put(label.LX_Default_Reason_For_Conversion,NewOpp.Reason_for_Conversion__c);
        PageRef.getParameters().put(label.LX_Default_Lead_Originator,user.id);
        PageRef.getParameters().put(label.LX_Default_Lead_Originator_Name,user.Name);
        PageRef.getParameters().put(label.LX_Opportunity_First_Time_to_Revenue,NewOpp.LX_First_Time_to_Revenue__c);
        
        //Rahul Adding condtion for run rate Opportunities
        if(recordTypeNameCurrent.Trim() != 'Run Rate'){
            PageRef.getParameters().put('opp11','Qualifying');//VT:6/20 added 
        }
        PageRef.getParameters().put(SalesOrgNamelabel,SalesOrgName);//VT6/27 added
        PageRef.getParameters().put(salesOrgIDlabel,salesOrgID);//VT6/27 added
        PageRef.getParameters().put('opp7','50000');//RR7/25 added
         
       if(newopp.MPS__c==true){PageRef.getParameters().put(Label.LX_MPS_CheckBox,'1');  }
      if(newopp.Software_Solutions__c==true){PageRef.getParameters().put(System.Label.LX_Software_Solutions_Checkbox,'1'); }
      if(newopp.Technology__c == true){PageRef.getParameters().put(System.Label.LX_Technology_Checkbox,'1');}
        if((invoiceLogoMap.containsKey(user.Legacy_Company__C))&&(user.Legacy_Company__c != 'AccessVia')&&(user.Legacy_Company__c != 'Saperion')){
            PageRef.getParameters().put(InvoiceLogoName,invoiceLogoMap.get(user.Legacy_Company__C).Name);
            PageRef.getParameters().put(InvoiceLogo,invoiceLogoMap.get(user.Legacy_Company__C).id);
        }else if(user.Legacy_Company__C == 'PCSFT' || user.Legacy_Company__C == 'Acuo'){
            if(invoiceLogoMap.containsKey('Perceptive')){
                PageRef.getParameters().put(InvoiceLogoName,invoiceLogoMap.get('Perceptive').Name);
                PageRef.getParameters().put(InvoiceLogo,invoiceLogoMap.get('Perceptive').id); 
            }
        }
        
        //Rahul Commenting part
        /*if(((user.Legacy_Company__c == null)||(user.Legacy_Company__c == LegacayComp))&&(product_type.trim()=='Software Solutions')){
            NewOpp.Type = 'New Logo';
        }else if(((user.Legacy_Company__c == null)||(user.Legacy_Company__c == LegacayComp))&&(product_type.trim()=='Software Solutions;Technology')){
            NewOpp.Type = 'New Logo Joint';
        }*/
        
       /* system.debug('>>>>>>>>>1>>'+NewOpp.Type);
        system.debug('>>>>>>>>>2>>'+product_type.trim());
        system.debug('>>>>>>>>>3>>'+user.Legacy_Company__c);
        system.debug('>>>>>>>>>4>>'+LegacayComp);*/
       
        PageRef.getParameters().put('opp5',NewOpp.Type);
        PageRef.getParameters().put(nooverride, nooverrideValue);       
        if(accountID  != null){
            PageRef.getParameters().put(strAccountID, accountID  );       
            }
        return PageRef ;
        } 
    

    else{
            RecordTypeLogic();
        for(LX_Territory_Member__c defaultTer :defaultList){
            defaultTerritoryId    = defaultTer.Id;
            defaultTerritoryName  = defaultTer.Name;
            } 

     
        PageRef.getParameters().put(LX_OppoLevel,'Level 1');//Rahul Added for CR 36          
         PageRef.getParameters().put(retURLID,returl);
        PageRef.getParameters().put(entName,ent);
        PageRef.getParameters().put('RecordType',NewOpp.RecordTypeId);
        PageRef.getParameters().put(TerritoryNameID,defaultTerritoryName);
        PageRef.getParameters().put(TerritoryID,defaultTerritoryId);
 
        PageRef.getParameters().put(label.LX_Opportunity_Sales_Type,NewOpp.LX_Sales_Type__c);
     
        PageRef.getParameters().put(label.LX_Opportunity_First_Time_to_Revenue,NewOpp.LX_First_Time_to_Revenue__c);
        PageRef.getParameters().put('opp11','Qualifying');//VT:6/20 added
     
        
        
        if(invoiceLogoMap.containsKey(user.Legacy_Company__C)){
            PageRef.getParameters().put(InvoiceLogoName,invoiceLogoMap.get(user.Legacy_Company__C).Name);
            PageRef.getParameters().put(InvoiceLogo,invoiceLogoMap.get(user.Legacy_Company__C).id);
        }else if(user.Legacy_Company__C == 'PCSFT' || user.Legacy_Company__C == 'Acuo'){
            if(invoiceLogoMap.containsKey('Perceptive')){
                PageRef.getParameters().put(InvoiceLogoName,invoiceLogoMap.get('Perceptive').Name);
                PageRef.getParameters().put(InvoiceLogo,invoiceLogoMap.get('Perceptive').id); 
                
            }
        }
    
        
        PageRef.getParameters().put(nooverride, nooverrideValue);       
        if(accountID  != null){
            PageRef.getParameters().put(strAccountID, accountID  );       
            }
        return PageRef ;
        } 
        }
}