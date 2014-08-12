/*
Class Name : LX_ChildOpportunity1
Description : Extension class for creating child Opportunity Record based on the selection of country values
Created By : Veenu Trehan (vtrehan@deloitte.com)
Created Date : 24-9-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan                   1000                   Initial Version
*************************************************************************/


public class LX_ChildOpportunity1
{   
    public list<displayChildWrapper> ChildWrap{get;set;}
    public Opportunity opp {get;set;}
    List<Opportunity> childOppList = new List<Opportunity>();//vt
    public list<Opportunity> ChildAlreadyCreated{get;set;}
    public boolean AlreadyCreatedFlag{get;set;}
    map <id,list<Opportunity>> CountryMap1=new map <id,list<Opportunity>>(); 
    public Decimal masterOppConversionRate,conversionRate,childOppconversionRate;
    public boolean countryFlag = false;//flag to check if any country value is selected
    public List<String> childOppCountries = new List<String>();//used to capture the country values selected at VF page for creating Child Opp
    //Variable to store the legacy company of the opportunity owner.
    public string userLegacy = ''; 
    //Map to store the country code and salesOrganization
    public map<string,Sales_Organization__c> salesOrgCountry = new map<string,Sales_Organization__c>();
    //Map to store the sales org custom settings data.
    private map<string,LX_Opportunity_Sales_Org__c> oppSalesOrg = LX_Opportunity_Sales_Org__c.getAll();    
    //keyvalue for the US lemark sales org value
    public string lexmarkUS = '';
    //keyvalue for the non US lemark sales org value    
    public string nonLexmarkUS = ''; 
    map<string,LX_Countries_In_Scope__c> masterOppMap=new map<string,LX_Countries_In_Scope__c>();   
    List<LX_Countries_In_Scope__c> selectedCountries = new List<LX_Countries_In_Scope__c>();
    map<id,Opportunity>ParentOpps= new map<id,Opportunity>();
    map<id,Opportunity> ChildOpps=new map<id,Opportunity>();
    
    //Boolean to indicate if the class was called from the batch class or page.
    private boolean calledFromBatch = false;
    
    public string opptyStageValue = 'Qualifying';
    public decimal opptyProbValue = 0;

    //Parent OpportunityID;
    string parentOppId;

   // Constructor for standardOpp
    public LX_ChildOpportunity1(ID opportunityID)
    {   
    	
        system.debug('>>>>>>>>>opportunityID>>>>'+opportunityID);
        calledFromBatch = true;
        ChildWrap=new list<displayChildWrapper>();
        AlreadyCreatedFlag = false;
        this.opp =  [SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,LX_Master_Opportunity__c FROM Opportunity 
                   WHERE Id = :opportunityID limit 1];
        ParentOpps.put(this.opp.id,this.opp);
        parentOppId = this.opp.id;
        
 //US3526 
        If (this.opp.LX_Master_Opportunity__c != TRUE){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot create a child for a child opportunity'));
            return; 
         }
 //US3526           
        for(LX_Countries_In_Scope__c s: [select id, name,LX_Country__c,LX_Opportunity__c,CurrencyIsoCode,LX_Exchange_Rate__c ,LX_UniqueOpp_Country__c,LX_Account_hidden__c,LX_user_hidden__c
                                        from LX_Countries_In_Scope__c
                                        Where LX_Opportunity__c=:opportunityID ]){   
            masterOppMap.put(s.LX_UniqueOpp_Country__c,s);
        }
    
        
        //Store the legacy company of the owner of the opportunity.
        userLegacy = this.opp.owner.Legacy_Company__c;
        if(userLegacy != null){
            userLegacy = userLegacy.trim().toUpperCase();
        }
        system.debug('>>>>>userLegacy >>>>>>>>'+userLegacy );
         
        for(LX_Opportunity_Sales_Org__c SalesRec :oppSalesOrg.values()){
            system.debug('>>>>SalesRec.LX_CountryCode__c>>>>>'+SalesRec.LX_CountryCode__c);
            system.debug('>>>>SalesRec.LX_Legacy_Company__c>>>>'+SalesRec.LX_Legacy_Company__c);            
            //populate the key for the US sales org.
            if((SalesRec.LX_CountryCode__c != null) && (SalesRec.LX_CountryCode__c.trim() == 'US') && (SalesRec.LX_Legacy_Company__c != null) && (SalesRec.LX_Legacy_Company__c.trim() != '') && (SalesRec.LX_Legacy_Company__c.trim().toUpperCase() == 'LEXMARK')){
                lexmarkUS = SalesRec.LX_CountryCode__c + SalesRec.LX_DefaultSalesOrg__c;
            }
            if((SalesRec.LX_CountryCode__c != null) && (SalesRec.LX_CountryCode__c.trim() == 'US') && (SalesRec.LX_Legacy_Company__c == null)){
                nonLexmarkUS = SalesRec.LX_CountryCode__c + SalesRec.LX_DefaultSalesOrg__c;
            }
        }
         
         //call the method to create the child record.
         if(masterOppMap.size() > 0){
            continueLogic();  
         }
    }


   // Constructor 
    public LX_ChildOpportunity1(ApexPages.StandardController controller)
    {    
        ChildWrap=new list<displayChildWrapper>();
        AlreadyCreatedFlag = false;
        this.opp =  [SELECT Id, OwnerID, owner.Legacy_Company__c, Name,MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,LX_Master_Opportunity__c  FROM Opportunity 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('oppId') limit 1];
        ParentOpps.put(this.opp.id,this.opp);
        parentOppId  = this.opp.id;
        //Store the legacy company of the owner of the opportunity.
        userLegacy = this.opp.owner.Legacy_Company__c;
        if(userLegacy != null){
            userLegacy = userLegacy.trim().toUpperCase();
        }
        system.debug('>>>>>userLegacy >>>>>>>>'+userLegacy );

 //US3526        
        If (this.opp.LX_Master_Opportunity__c != TRUE){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot create a child for a child opportunity'));
            return;
        }
 //US3526                   
        for(LX_Opportunity_Sales_Org__c SalesRec :oppSalesOrg.values()){
            system.debug('>>>>SalesRec.LX_CountryCode__c>>>>>'+SalesRec.LX_CountryCode__c);
            system.debug('>>>>SalesRec.LX_Legacy_Company__c>>>>'+SalesRec.LX_Legacy_Company__c);            
            //populate the key for the US sales org.
            if((SalesRec.LX_CountryCode__c != null) && (SalesRec.LX_CountryCode__c.trim() == 'US') && (SalesRec.LX_Legacy_Company__c != null) && (SalesRec.LX_Legacy_Company__c.trim() != '') && (SalesRec.LX_Legacy_Company__c.trim().toUpperCase() == 'LEXMARK')){
                lexmarkUS = SalesRec.LX_CountryCode__c + SalesRec.LX_DefaultSalesOrg__c;
            }
            if((SalesRec.LX_CountryCode__c != null) && (SalesRec.LX_CountryCode__c.trim() == 'US') && (SalesRec.LX_Legacy_Company__c == null)){
                nonLexmarkUS = SalesRec.LX_CountryCode__c + SalesRec.LX_DefaultSalesOrg__c;
            }
        }
           
        getMasterOppSelCountries();        
        system.debug('>>>>lexmarkUS>>>>>'+lexmarkUS+'>>>>>nonLexmarkUS>>>>'+nonLexmarkUS);
    }
    
    // Logic on click of Continue Button
     public PageReference continueLogic() {
        string conCountries = '';
        system.debug('*****childOppCountries '+childOppCountries );
        PageReference PageRef = new PageReference('/'+opp.id) ;
        Map<String,String> HiddenMpsCntryMap = new Map<String,String>();//Map to capture the values of country for which Child opp are already created
        List<String> HiddenMpsCntryLst = new List<String>();//List to store the values of country for which Child opp are already created
      
        list<LX_Countries_In_Scope__c> CS=new list<LX_Countries_In_Scope__c>();
                    CS=getSelected();
                    system.debug('###cs'+cs);
                    if(Cs!=null && CS.size()>0){
                createChildOpp(opp.Id);// call to method creating child opportunities
                }
                else{
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one value'));
                   return Null;
                }
                
        if(countryFlag==false)
        {
            PageRef.setRedirect(true);
            return PageRef ; 
        }
        else
        return Null;
        
    }
    //to redirect to the opportunity record if cancel button is clicked
     public PageReference cancelLogic(){
        
        PageReference PageRef  = new PageReference ('/'+opp.id);
       
        return PageRef ;
    }   
    
    
   // displays the name of countries selected in Master opp as picklist values on VF page
    
    public List<displayChildWrapper> getMasterOppSelCountries() {
    
        //List<SelectOption> MasterOppSelCountries = new List<SelectOption>();
        list<LX_Countries_In_Scope__c> masterOpp = new list<LX_Countries_In_Scope__c>();
        //masterOpp = [select Id, Name,MPS_Country__c from opportunity where Id =:opp.id ];  
       
        ChildAlreadyCreated=new list<Opportunity>();
        //query the already created rchild records for the master opp
        ChildAlreadyCreated=[select id,Name,LX_Child_Country__c,Master_Opportunity__c
                             from Opportunity
                             where Master_Opportunity__c = :opp.Id];
        if(ChildAlreadyCreated.size()>0){
            //setting the flag to display an output panel
            AlreadyCreatedFlag=true;
        }                    
        
        //addingg values to map<id, list<>>
       List<Opportunity> Opplist;
       for(opportunity opp:ChildAlreadyCreated){
            system.debug('##In For loop'+opp);
                if(CountryMap1.containsKey(opp.LX_Child_Country__c)){
                    system.debug('@@@@CountryMap1.get(opp.LX_Child_Country__c)'+CountryMap1.get(opp.LX_Child_Country__c));
                 Opplist=  CountryMap1.get(opp.LX_Child_Country__c);
                 Opplist.add(opp);
            CountryMap1.put(opp.LX_Child_Country__c,Opplist);
            }else{
            Opplist = new List<Opportunity> ();
            Opplist.add(opp);
            CountryMap1.put(opp.LX_Child_Country__c,Opplist);
            }
            system.debug('CountryMap1.size()'+CountryMap1.size());
          }                   
        masterOpp =[select id, name,LX_Country__c,LX_Opportunity__c,CurrencyIsoCode,LX_Exchange_Rate__c ,LX_UniqueOpp_Country__c,LX_Account_hidden__c,LX_user_hidden__c
                    from LX_Countries_In_Scope__c
                    Where LX_Opportunity__c=:opp.id ];
                    
        List<String>MasterOppCountryLst = new List<String>();
        if(masterOpp.size()>0)
        {
            for(LX_Countries_In_Scope__c s: masterOpp ) 
            {   
                ChildWrap.add(new displayChildWrapper(s));
                //MasterOppSelCountries.add(new SelectOption(s.LX_Country__c,s.LX_Country__c) );
                masterOppMap.put(s.LX_UniqueOpp_Country__c,s);
            }
            //system.debug('&&&&&MasterOppSelCountries'+MasterOppSelCountries);
            System.debug('ChildWrap$$$'+ChildWrap);
            return ChildWrap;
        }
        
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No new child records.'));
             return null;
        }
       
        } 
        ///////////////////////////////////
        //to get selcted records on the vf page
        public list<LX_Countries_In_Scope__c> getSelected(){
            
            if(!calledFromBatch){
            
                selectedCountries.clear();
                for(displayChildWrapper cwrapper: ChildWrap){ 
                    if(cwrapper.Check == true){
                         selectedCountries.add(cwrapper.DispCountries); 
                    }
                    system.debug('####selectedCountries'+selectedCountries);
                    }
                    if(selectedCountries.size()>0){
                        system.debug('@@@@ifloop');
                        return selectedCountries;
                        
                    }else{
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Country.'));
                        system.debug('@@@@elseloop');
                        return null;
                    }
            }else{
                list<string> selectedID  = new list<string>();
                //get all the ids for which the Hidden scope has to be created 
                if(this.opp.LX_Countries_In_Scope_Hidden__c != null){
                    selectedID = this.opp.LX_Countries_In_Scope_Hidden__c.split(',');
                }else{
                    return null;
                }
                list<LX_Countries_In_Scope__c> countriesToBeReturned = new list<LX_Countries_In_Scope__c>();
                map<id,LX_Countries_In_Scope__c> countriesInScopeMap = new map <id,LX_Countries_In_Scope__c>([select id, name,LX_Country__c,LX_Opportunity__c,CurrencyIsoCode,LX_Exchange_Rate__c ,LX_UniqueOpp_Country__c
                        from LX_Countries_In_Scope__c
                        Where id in :selectedID]);
                for (string countryid:selectedID){
                    if(countriesInScopeMap.containsKey(countryid)){
                        countriesToBeReturned.add(countriesInScopeMap.get(countryid));
                    }
                }
                
                return countriesToBeReturned;
            }
        }
       
        
        ///////////////////////////////////
    
    public List<String> getChildOppCountries () {
        return childOppCountries ;
    }

    public void setChildOppCountries (List<String> countries) {
        this.childOppCountries = countries;
    }      
    //method to create child opportunities for selected records
    public void createChildOpp(Id oppId)
    {   list<LX_Countries_In_Scope__c> CS=new list<LX_Countries_In_Scope__c>();
        CS=getSelected();
        system.debug('#######te'+CS);
       // List<string>splittedCountryList = new List<string>();
        List<Opportunity> oppList = new List<Opportunity>();
        //List<Opportunity> childOppList = new List<Opportunity>();
        List<Opportunity> oldChildOppList = new List<Opportunity>();
        Map<String,LX_MPS_Country_Currency_Mapping__c> IsoCodeMap = LX_MPS_Country_Currency_Mapping__c.getAll();
        Map<String,LX_Country_Code_Mapping__c> CountryCodeMap = LX_Country_Code_Mapping__c.getAll();
        Map<String,Opportunity> ChildOppMap = new Map<String,Opportunity>();
        String Id = oppId;
        system.debug('******Id'+Id);
        //query to find if there are child opportunity for a master opportunity
        oldChildOppList = [Select Name,Id,MPS_ChildOppCountry__c from opportunity where Master_Opportunity__c =:oppId];
       
        if(oldChildOppList.size()>0)
        {
            for(Opportunity opp:oldChildOppList )
            {
                ChildOppMap.put(opp.MPS_ChildOppCountry__c,opp);
            }
        }
        String soql = LX_UtilChildOpp.getCreatableFieldsSOQL('Opportunity','id=\''+Id+'\'');//call to utility class,returning Soql Querry
        oppList = Database.query(soql);
        system.debug('@@@@@@@@'+oppList[0]);
        
        if(oppList.size()>0)
        {
            for(Opportunity opp:oppList)
            {
                    
                    //Rahul Get all the sales org information for the relevant country.
                    for(Sales_Organization__c salesOrg: [SELECT id,Sales_Organization__c ,Name,LX_Country_Code__c,LX_Default__c
                                                                                                    FROM Sales_Organization__c]){
                            if(salesOrg.LX_Country_Code__c != 'US' && salesOrg.LX_Default__c){
                                salesOrgCountry.put(salesOrg.LX_Country_Code__c,salesOrg);
                            }else if(salesOrg.LX_Country_Code__c == 'US'){
                                salesOrgCountry.put(salesOrg.LX_Country_Code__c+salesOrg.Sales_Organization__c,salesOrg);
                            }
                    }
                    system.debug('>>>>>salesOrgCountry>>>>>>'+salesOrgCountry);
                
                    for(LX_Countries_In_Scope__c s:CS)
                    {   
                        system.debug('ChildOppMap.get(s.LX_Country__c)'+ChildOppMap.get(s.LX_Country__c));
                      // if(ChildOppMap.get(s.LX_Country__c)==Null)
                        // {
                            Opportunity childOpp;
                            childOpp = opp.clone(false);
                            //system.debug('LX_Account_hidden__c'+s.LX_Account_hidden__c);
                             if(s.LX_Account_hidden__c!=null ){
                                childOpp.AccountID=s.LX_Account_hidden__c;
                                // system.debug('LX_Account_hidden__c2'+s.LX_Account_hidden__c);
                            }
                             system.debug('LX_user_hidden__c'+s.LX_user_hidden__c);
                            if(s.LX_user_hidden__c!=null ){
                               // system.debug('LX_user_hidden__c2'+s.LX_user_hidden__c);
                                childOpp.Ownerid= s.LX_user_hidden__c;
                               // system.debug('LX_user_hidden__c3'+s.LX_user_hidden__c);
                            }
                             // SG: Updation of Closed date to Today if Closed date if in past.
                            if(childOpp.closeDate<System.today()){
                                childOpp.closeDate=System.today();
                            }
                            childOpp.StageName = opptyStageValue;
                            //2/27 VT added to solve case#00756680
                            childOpp.LX_Stage_Number_New__c=1.0;
                            childOpp.Probability = opptyProbValue;
                            
                            ////////// Added Custom settings to assaign Values to ChildOpp                            
                             List <LX_ChildOppnull__c> LX = LX_ChildOppnull__c.getAll().values();
                              for(LX_ChildOppnull__c Ch : LX){
                                   childOpp.put(Ch.Name,Ch.Value__c);
                                }                           
                          
                            childOpp.LX_No_of_BM_Quotes__c=0;
                            childOpp.LX_MQLI_Update_Tracker__c=false;
                            /////////
                            childOpp.LX_Master_Opportunity__c=false;
                            childopp.LX_Has_Participant_Opportunities__c=false;
                            system.debug('>>>>>>>>>>>>>'+masterOppMap);
                            childOpp.LX_Child_Country__c=masterOppMap.get(s.LX_UniqueOpp_Country__c).id;
                            if(!CountryMap1.containsKey(masterOppMap.get(s.LX_UniqueOpp_Country__c).id)){
                                system.debug('########ifloop');
                            childOpp.Name = childOpp.Name = opp.Name+'-'+masterOppMap.get(s.LX_UniqueOpp_Country__c).LX_Country__c+''+masterOppMap.get(s.LX_UniqueOpp_Country__c).CurrencyIsoCode;
                            }else{
                            integer i=CountryMap1.get(childOpp.LX_Child_Country__c).size()+1;
                            system.debug('#####I'+i);
                            childOpp.Name = childOpp.Name = opp.Name+'-'+masterOppMap.get(s.LX_UniqueOpp_Country__c).LX_Country__c+''+masterOppMap.get(s.LX_UniqueOpp_Country__c).CurrencyIsoCode+i;
                            }
                            childOpp.MPS_Country__c = Null;
                            childOpp.Master_Opportunity__c = opp.Id;
                            childOpp.Opportunity_Country__c = s.LX_Country__c;// field to be used to capture country Code
                            childOpp.MPS_ChildOppCountry__c = s.LX_Country__c;
                            childOpp.LX_Country_Code__c = CountryCodeMap.get(s.LX_Country__c).Country_Code__c;
                            childOpp.CurrencyIsoCode = masterOppMap.get(s.LX_UniqueOpp_Country__c).CurrencyIsoCode;
                                ////////////bmi fields of parent to child
                             childOpp.LX_Master_Agreement_Type__c=opp.LX_Agreement_Type__c;
                             childOpp.LX_Master_Quote_Reference__c=opp.LX_Primary_Quote_Number__c;
                             childOpp.LX_Master_Quote_Name__c=opp.LX_Quote_Name__c;
                             childOpp.LX_Master_Control_Number__c=opp.LX_Quote_Control_Number__c;
                             childOpp.LX_Master_Quote_Start_Date__c=opp.LX_Quote_Start_Date__c;
                             childOpp.LX_Master_Quote_End_Date__c=opp.LX_Quote_End_Date__c;
                             ////
                            childOpp.LX_Agreement_Type__c=opp.LX_Agreement_Type__c;
                            childOpp.LX_Quote_Category__c=opp.LX_Quote_Category__c;
                            childOpp.LX_Quote_Category_Questions_before__c=opp.LX_Quote_Category_Questions_before__c;
                            childOpp.LX_Quote_Term_months__c=opp.LX_Quote_Term_months__c;
                            childOpp.LX_Primary_Quote_Number__c=opp.LX_Primary_Quote_Number__c;
                            childOpp.LX_Finance_Discussion_Comments__c=opp.LX_Finance_Discussion_Comments__c;
                            childOpp.LX_Quote_Name__c=opp.LX_Quote_Name__c;
                            childOpp.LX_Quote_Control_Number__c=opp.LX_Quote_Control_Number__c;
                            childOpp.LX_Quote_Description__c=opp.LX_Quote_Description__c;
                            childOpp.LX_Quote_category_extra_attributes__c=opp.LX_Quote_category_extra_attributes__c;
                                                        //////////////////////////////
                                Sobject sobj = (Opportunity)childOpp;
                                for(Schema.SObjectField fld:LX_UtilChildOpp.getFieldsOfType('CURRENCY'))   {
                                    //childOpp.fld=opp.fld*childOppconversionRate ;
                                    //Sobject s = new Sobject;
                                    if((Integer) Integer.valueof(sobj.get(fld))!=null){
                                        sobj.put(fld, (Double) Integer.valueof(sobj.get(fld))*Double.valueof(s.LX_Exchange_Rate__c));
                                    }
                                    
                             }
                             childOpp = (Opportunity) sobj;
                           //system.debug('$$$$$ConversionRate$$$'+childOppconversionRate);
                            system.debug('>>>>>>>>>>>>>>>>>>'+salesOrgCountry.get(childOpp.LX_Country_Code__c)+'$$$$$salesOrgCountry.get(childOpp.LX_Country_Code__c)$$'+salesOrgCountry.get(childOpp.LX_Country_Code__c));                            
                          /*2/26 VT commented
                           if(opp.Amount!=null){
                            childOpp.Amount = (opp.Amount* (Double.valueof(s.LX_Exchange_Rate__c))) ;
                            }else{
                            childOpp.Amount =0;
                            }*/
                            //2/26 VT added amount=0
                             childOpp.Amount =0;
                            //Rahul Adding the part to populate the sales org
                            if(childOpp.LX_Country_Code__c != 'US' && salesOrgCountry.get(childOpp.LX_Country_Code__c) != null){
                                childOpp.Sales_Organization__c = salesOrgCountry.get(childOpp.LX_Country_Code__c).id;
                            }else if(childOpp.LX_Country_Code__c == 'US'){
                                if((userLegacy != 'LEXMARK')&&(salesOrgCountry.get(nonLexmarkUS) != null)){
                                    childOpp.Sales_Organization__c = salesOrgCountry.get(nonLexmarkUS).id;
                                }else if((userLegacy == 'Lexmark')&&(salesOrgCountry.get(lexmarkUS) != null)){
                                    childOpp.Sales_Organization__c = salesOrgCountry.get(lexmarkUS).id;
                                }
                            }
                            
                            
                            
                       
                        else
                        {
                            childOpp.CurrencyIsoCode = opp.CurrencyIsoCode ; 
                        }
                        
                        childOppList.add(childOpp); 
                        system.debug('@@$$childOppList'+childOppList); 
                                            
                    //}
                  }  
                     countryFlag = false;
                
            }
        
            //Rahul added logic to indicate the parent opportunity is a master opportunity and has children on them.
            childOppList.add(new Opportunity(id = oppId, LX_Master_Opportunity__c = true, LX_Has_Participant_Opportunities__c = true, LX_Batch_Child_Opportunity__c = false));
            upsert childOppList;
            childOppList.remove(childOppList.size()-1);//removing the parent opp
            //createLineItems(opp,childOppList);

            list<id> childOppSet = new list<id>();
            for(Opportunity o:childOppList){
            ChildOpps.put(o.id,o) ;
            childOppSet.add(o.id); 
            }
            system.debug('#####Parent'+ParentOpps+'###child'+ChildOpps);
            if(ParentOpps.size()>0 && ChildOpps.size()>0){
            map<id,OpportunityLineItem> lineItems= new map <id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c 
                                                                                from OpportunityLineItem
                                                                                where OpportunityId=:ParentOpps.keyset()]); 
                                                                                
            LX_OpportunityLineItemHelper.mqliUpdate1WithLinesFuture(parentOppId,childOppSet);
        }  }      
    }
    //////////////////////////////////// Veenu Added 19/11
    //wrapper class to display records
    public class displayChildWrapper{
        public boolean Check{get;set;}
        public LX_Countries_In_Scope__c DispCountries{get;set;}
        public displayChildWrapper(LX_Countries_In_Scope__c C){
        check=false;
        DispCountries=c;
        }
      } 
        ////////////////////////////////////
}